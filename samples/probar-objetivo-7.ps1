[CmdletBinding()]
param(
    [string]$WebhookUrl = $env:ODD_PEDIDOS_WEBHOOK,
    [switch]$IncluirTelegram
)

$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($WebhookUrl)) {
    throw 'Indica el webhook con -WebhookUrl o la variable ODD_PEDIDOS_WEBHOOK.'
}

$parsedUrl = $null
if (-not [Uri]::TryCreate($WebhookUrl, [UriKind]::Absolute, [ref]$parsedUrl) -or
    $parsedUrl.Scheme -notin @('http', 'https')) {
    throw 'WebhookUrl debe ser una URL HTTP o HTTPS absoluta.'
}

$httpClient = [System.Net.Http.HttpClient]::new()
$httpClient.Timeout = [TimeSpan]::FromSeconds(45)
$sampleDirectory = $PSScriptRoot
$results = [System.Collections.Generic.List[object]]::new()

function Send-OrderSample {
    param(
        [Parameter(Mandatory)][string]$CaseName,
        [Parameter(Mandatory)][string]$FileName,
        [Parameter(Mandatory)][int]$ExpectedStatus,
        [string]$IdempotencyKey
    )

    $filePath = Join-Path $sampleDirectory $FileName
    if (-not (Test-Path -LiteralPath $filePath -PathType Leaf)) {
        throw "No existe la muestra: $FileName"
    }

    $body = [System.IO.File]::ReadAllText($filePath)
    $request = [System.Net.Http.HttpRequestMessage]::new([System.Net.Http.HttpMethod]::Post, $WebhookUrl)
    $request.Content = [System.Net.Http.StringContent]::new($body, [System.Text.Encoding]::UTF8, 'application/json')
    if ($IdempotencyKey) {
        [void]$request.Headers.TryAddWithoutValidation('Idempotency-Key', $IdempotencyKey)
    }

    try {
        $response = $httpClient.SendAsync($request).GetAwaiter().GetResult()
        $responseBody = $response.Content.ReadAsStringAsync().GetAwaiter().GetResult()
        $actualStatus = [int]$response.StatusCode
        $response.Dispose()
    }
    finally {
        $request.Dispose()
    }

    if ($actualStatus -ne $ExpectedStatus) {
        throw "$CaseName esperaba HTTP $ExpectedStatus y recibió HTTP $actualStatus. Respuesta: $responseBody"
    }
    if ($ExpectedStatus -eq 400) {
        $errorJson = $responseBody | ConvertFrom-Json
        if (-not $errorJson.motivos -or $errorJson.motivos.Count -lt 1) {
            throw "$CaseName devolvió HTTP 400 sin motivos de validación."
        }
    }

    $results.Add([pscustomobject]@{ Caso = $CaseName; Esperado = $ExpectedStatus; Obtenido = $actualStatus; Resultado = 'OK' })
    Write-Host ("OK  {0}: HTTP {1}" -f $CaseName, $actualStatus)
    return $responseBody
}

try {
    $key = 'odd7-' + [guid]::NewGuid().ToString('N')
    [void](Send-OrderSample -CaseName 'pedido válido' -FileName 'pedido.json' -ExpectedStatus 200)
    [void](Send-OrderSample -CaseName 'pedido inválido' -FileName 'pedido-invalido.json' -ExpectedStatus 400)
    [void](Send-OrderSample -CaseName 'límite 1000' -FileName 'limite-1000.json' -ExpectedStatus 200)
    [void](Send-OrderSample -CaseName 'idempotencia primer envío' -FileName 'idempotencia.json' -ExpectedStatus 200 -IdempotencyKey $key)
    [void](Send-OrderSample -CaseName 'idempotencia repetida' -FileName 'idempotencia.json' -ExpectedStatus 200 -IdempotencyKey $key)
    [void](Send-OrderSample -CaseName 'conflicto de clave' -FileName 'idempotencia-conflicto.json' -ExpectedStatus 409 -IdempotencyKey $key)

    if ($IncluirTelegram) {
        Write-Warning 'Los siguientes casos envían solicitudes reales al bot configurado.'
        [void](Read-Host 'Pulsa Enter para continuar o Ctrl+C para cancelar')
        [void](Send-OrderSample -CaseName 'límite 1001 y aprobación' -FileName 'limite-1001.json' -ExpectedStatus 200)
        [void](Read-Host 'Aprueba el pedido de 1001 en Telegram y luego pulsa Enter')
        [void](Send-OrderSample -CaseName 'solicitud de aprobación' -FileName 'aprobacion.json' -ExpectedStatus 200)
        [void](Read-Host 'Aprueba el pedido en Telegram y luego pulsa Enter para continuar')
        [void](Send-OrderSample -CaseName 'solicitud de rechazo' -FileName 'rechazo.json' -ExpectedStatus 200)
        [void](Read-Host 'Rechaza el pedido en Telegram y luego pulsa Enter para finalizar')
        Write-Warning 'Verifica APPROVED y REJECTED en PostgreSQL; HTTP 200 solo confirma recepción.'
    }

    Write-Host "`nResumen: $($results.Count) casos HTTP correctos."
    $results | Format-Table -AutoSize
}
finally {
    $httpClient.Dispose()
}

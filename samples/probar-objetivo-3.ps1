$cases = @(
  @{name='valido'; json='{"cliente":"Prueba HTTP","email":"prueba@example.com","productos":[{"nombre":"A","cantidad":2,"precio":15}],"total":30}'; expected=200},
  @{name='centavos'; json='{"cliente":"Prueba HTTP","email":"prueba@example.com","productos":[{"nombre":"A","cantidad":3,"precio":0.1},{"nombre":"B","cantidad":1,"precio":0.2}],"total":0.5}'; expected=200},
  @{name='faltantes'; json='{}'; expected=400},
  @{name='email'; json='{"cliente":"Prueba HTTP","email":"mal","productos":[{"nombre":"A","cantidad":1,"precio":1}],"total":1}'; expected=400},
  @{name='cantidad'; json='{"cliente":"Prueba HTTP","email":"prueba@example.com","productos":[{"nombre":"A","cantidad":0,"precio":1}],"total":0}'; expected=400},
  @{name='producto'; json='{"cliente":"Prueba HTTP","email":"prueba@example.com","productos":[{"cantidad":1}],"total":1}'; expected=400},
  @{name='total'; json='{"cliente":"Prueba HTTP","email":"prueba@example.com","productos":[{"nombre":"A","cantidad":2,"precio":0.1}],"total":0.3}'; expected=400}
)
$failed = $false
foreach ($case in $cases) {
  try {
    $response = Invoke-WebRequest -Uri 'http://localhost:5678/webhook/pedidos' -Method Post -ContentType 'application/json' -Body $case.json -UseBasicParsing
    $status = [int]$response.StatusCode
    $body = $response.Content
  } catch {
    if (-not $_.Exception.Response) { Write-Output "$($case.name): ERROR $($_.Exception.Message)"; $failed = $true; continue }
    $status = [int]$_.Exception.Response.StatusCode
    $reader = [System.IO.StreamReader]::new($_.Exception.Response.GetResponseStream())
    $body = $reader.ReadToEnd()
  }
  Write-Output "$($case.name): HTTP $status $body"
  if ($status -ne $case.expected) { $failed = $true }
}
if ($failed) { exit 1 }

# Objetivo 2: recepción de pedidos

El workflow `Order Processing` recibe `POST /pedidos` y responde únicamente `{"mensaje":"Pedido recibido"}`. No incluye validaciones, PostgreSQL ni Telegram. El ejemplo enviado está en `samples/pedido.json`.

## Prueba HTTP real

Con el workflow publicado temporalmente en n8n local se ejecutó desde PowerShell:

```powershell
$body = Get-Content -Raw -Encoding UTF8 samples/pedido.json
Invoke-WebRequest -Uri 'http://localhost:5678/webhook/pedidos' -Method Post -ContentType 'application/json; charset=utf-8' -Body ([Text.Encoding]::UTF8.GetBytes($body)) -UseBasicParsing
```

Resultado: HTTP 200, `Content-Type: application/json; charset=utf-8`, cuerpo `{"mensaje":"Pedido recibido"}`. La ejecución webhook `2` terminó correctamente y el MCP confirmó que recibió cliente, email, productos y total. Los dos nodos y el workflow también pasaron la validación MCP. El workflow fue despublicado después de la prueba y su estado inactivo se confirmó mediante MCP.

Antes de publicarlo, una solicitud a `/webhook-test/pedidos` devolvió HTTP 404 porque no había un escuchador de prueba activo. La ejecución manual MCP `1` terminó correctamente, pero por sí sola no verificó la respuesta HTTP.

## Archivo del workflow

`workflows/order-processing.json` contiene el nombre, nodos, conexiones y ajustes obtenidos de `get_workflow_details` mediante MCP. El MCP no expone una herramienta específica de exportación; el archivo se construyó con esos datos y su importación no se ha verificado.

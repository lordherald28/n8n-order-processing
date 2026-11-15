# Objetivo 2: recepción de pedidos

El workflow `Order Processing` recibe `POST /pedidos` y responde únicamente `{"mensaje":"Pedido recibido"}`. No incluye validaciones, PostgreSQL ni Telegram. El ejemplo enviado, con dos productos en el array, está en `samples/pedido.json`.

## Verificaciones

- MCP: validación correcta de los dos nodos y del workflow.
- PowerShell: durante la prueba técnica previa, la petición HTTP real devolvió 200 y `{"mensaje":"Pedido recibido"}`. La ejecución webhook `2` terminó correctamente; el registro MCP confirma la recepción de `cliente`, `email`, `productos` y `total`.
- Bruno: el usuario importó manualmente el workflow JSON en n8n y confirmó que probó el webhook satisfactoriamente. El pedido de prueba actual incluye dos productos en el array `productos` y total 60.
- Tras la prueba HTTP de PowerShell, el workflow se despublicó y MCP confirmó que quedó inactivo.

## Correspondencia del JSON

Comparé `workflows/order-processing.json` con la definición actual obtenida por `get_workflow_details` mediante MCP. Coinciden el nombre, nodos y sus parámetros, conexiones y ajustes. El archivo conserva la definición importada y probada manualmente por Bruno, según la confirmación del usuario.

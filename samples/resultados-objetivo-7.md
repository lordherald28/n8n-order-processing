# Objetivo 7: matriz de pruebas y evidencia

## Pruebas PowerShell

Ejecuta desde una instancia de prueba con el workflow preparado y credenciales propias:

```powershell
$env:ODD_PEDIDOS_WEBHOOK = 'https://<host-n8n>/webhook/pedidos'
.\samples\probar-objetivo-7.ps1
```

Sin opciones, el script comprueba por HTTP pedido válido (200), pedido inválido (400 con motivos), umbral 1.000 (200), idempotencia con igual clave/cuerpo (200 en ambos intentos) y conflicto con igual clave/cuerpo diferente (409). Usa una clave aleatoria nueva en cada ejecución.

Para probar el límite 1.001, aprobación y rechazo humanos, usa `-IncluirTelegram`. El script advierte antes de enviar mensajes reales, pausa para las decisiones y recuerda que hay que comprobar el estado terminal en PostgreSQL. Las decisiones no se consideran verificadas por la respuesta HTTP.

## Recuperación manual

La recuperación se comprueba a partir de una incidencia PostgreSQL real, registrada después de los reintentos del workflow. Sigue [`recuperacion-manual.md`](recuperacion-manual.md). No hay un endpoint de recuperación que pueda invocar el script HTTP, y no se inyecta un fallo modificando workflows, credenciales o el servidor.

## Estado de ejecución en esta entrega

- Preparado: casos JSON sintéticos, script PowerShell sin módulos adicionales, comandos y criterios observables.
- Verificado localmente: 10 archivos JSON parseados, AST de PowerShell sin errores, enlaces/rutas/anchors Markdown válidos y `git diff --check` sin errores.
- El script PowerShell se ejecutó contra un receptor HTTP local simulado: 6/6 respuestas esperadas (200, 400 con motivos, 200, 200, 200 y 409). Esto valida el cliente y sus aserciones, no el workflow n8n.
- Pendiente de ejecución contra una instancia: pruebas HTTP, estados PostgreSQL, aprobación/rechazo Telegram y recuperación de una incidencia real. No se configuró ni activó ningún workflow para esta entrega.
- No hay capturas n8n/Telegram incluidas; no estaban disponibles evidencias visuales reales para anonimizar.

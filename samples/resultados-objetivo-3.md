# Objetivo 3: validación de pedidos

## Evidencia

El workflow se actualizó mediante MCP y la validación de los seis nodos pasó. Las ejecuciones manuales mediante MCP 14 y 15 aceptaron respectivamente un pedido válido y el cálculo `3 × 0.10 + 0.20 = 0.50`. Las ejecuciones 13, 16, 17 y 18 detectaron email inválido, campos ausentes, cantidad cero y total incorrecto, respectivamente. La tabla `Incidencias pedidos` contiene las cuatro incidencias y sus motivos; los dos pedidos válidos no generaron registros.

Con el workflow publicado temporalmente, `powershell -NoProfile -ExecutionPolicy Bypass -File samples\probar-objetivo-3.ps1` terminó con código 0: los casos válido y de centavos devolvieron HTTP 200; faltantes, email, cantidad, producto y total devolvieron HTTP 400. MCP confirmó cinco filas nuevas en `Incidencias pedidos` (IDs 7–11), con los motivos correspondientes, y ninguna fila nueva para los válidos. El workflow se desactivó después y MCP confirmó `active: false`.

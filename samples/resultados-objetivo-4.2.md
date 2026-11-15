# Objetivo 4.2: persistencia de pedidos

## Evidencias mediante MCP oficial de n8n

- La ejecución manual 36 confirmó la conexión a PostgreSQL y la ausencia inicial de las tablas `pedidos` y `productos`. La ejecución 37 creó el esquema de `sql/objetivo-4.2.sql`.
- Las ejecuciones manuales 38 y 40 procesaron dos pedidos válidos y guardaron dos productos por pedido. La segunda comprobó decimales, comas y apóstrofos.
- Las consultas de lectura de las ejecuciones 41 y 47 recuperaron ambos pedidos y sus cuatro productos con sus valores correspondientes. La segunda se ejecutó después de las pruebas inválidas y no recuperó ninguno de esos pedidos.
- Las ejecuciones 39 y 42–46 procesaron pedidos inválidos por email, cantidad, campos ausentes, producto incompleto o total incorrecto. Todas llegaron a `Registrar incidencia` y `Responder incidencia`, sin ejecutar `Guardar pedido`; se registraron las incidencias 12–17.
- Con autorización, se publicó temporalmente el workflow y se ejecutó `powershell -NoProfile -ExecutionPolicy Bypass -File samples\probar-objetivo-3.ps1`: código de salida 0, dos respuestas HTTP 200 y cinco HTTP 400. Las ejecuciones 48–54 corresponden a esas solicitudes.
- La consulta de lectura de la ejecución 55 confirmó los dos pedidos HTTP válidos (IDs 3 y 4) y sus tres productos; los inválidos no se guardaron en PostgreSQL. Las ejecuciones 50–54 registraron las incidencias 18–22. La instancia confirmó después `active: false`.
- Las ejecuciones 36–47 y 55 usaron el disparador manual del MCP con una base real. El workflow auxiliar de inspección se archivó al terminar.

Los registros de prueba se conservan en la base y en la tabla de incidencias.

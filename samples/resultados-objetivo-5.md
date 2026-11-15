# Objetivo 5: resultados parciales

- Mediante el MCP oficial se aplicó la migración en la ejecución 56. La columna permite estados desconocidos para los pedidos anteriores.
- La ejecución 57 guardó el pedido 5, de total 1000, y siguió la rama automática. La ejecución 61 consultó PostgreSQL y confirmó `PROCESSED`.
- Las ejecuciones 58 y 59 guardaron los pedidos 6 y 7, de totales 1001 y 1002. La ejecución 61 confirmó `PENDING_APPROVAL` en ambos.
- Telegram rechazó los botones en las ejecuciones 58 y 59 porque la URL generada por n8n usa `localhost` y Telegram la considera inválida. No se enviaron solicitudes de aprobación; las ejecuciones terminaron en error y los pedidos siguen pendientes.
- La ejecución 60 registró una incidencia para un pedido inválido y no ejecutó el almacenamiento PostgreSQL.
- En ese momento se validaron los nodos de comparación, Telegram y actualización con el MCP, pero aún no se habían probado las decisiones.

En esa etapa quedó pendiente probar las decisiones con una URL accesible; los resultados posteriores se detallan abajo.

## Reanudación con ngrok

- Se observó un proceso ngrok activo y un túnel HTTPS en su API local. Esto no demuestra que n8n utilice esa URL en los enlaces de Telegram.
- El MCP oficial rechazó las consultas al workflow durante el descubrimiento OAuth porque el emisor anunciado no coincide con el origen `localhost` configurado en el conector. No se pudo comprobar la configuración actual de n8n ni ejecutar las nuevas pruebas.

## Nuevas pruebas con ngrok

- El MCP volvió a responder y mostró una URL HTTPS de ngrok para el webhook. El workflow estaba inactivo.
- Las ejecuciones manuales 62 y 63 guardaron los pedidos 8 y 9 (totales 1101 y 1102) y quedaron esperando en Telegram sin el error anterior. El responsable aprobó el primero y rechazó el segundo; ambas ejecuciones terminaron correctamente y `Registrar decisión` devolvió `APPROVED` y `REJECTED`, respectivamente.
- La ejecución 64 guardó el pedido 10, de total 1000, y terminó por la rama automática.
- La ejecución 65 consultó PostgreSQL y confirmó los estados `APPROVED`, `REJECTED` y `PROCESSED` de los pedidos 8, 9 y 10. En la misma ejecución se intentaron decisiones contrarias para los pedidos 8 y 9 con la condición `estado = 'PENDING_APPROVAL'`: se modificaron cero filas. Se restituyó la consulta original de almacenamiento después de la comprobación.
- Las pruebas utilizaron el disparador manual del MCP y una URL HTTPS de ngrok ya configurada en n8n. No fue necesario publicar el workflow; el MCP confirmó que permanecía inactivo al finalizar.

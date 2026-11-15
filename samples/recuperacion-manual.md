# Escenario: recuperación manual

Este caso reutiliza una recepción que ya haya fallado y esté registrada. No crees una incidencia falsa ni cambies consultas, credenciales o disponibilidad del servidor para forzarla.

1. En `Errores técnicos pedidos`, identifica una fila cuyo origen sea `PostgreSQL` o `PostgreSQL decisión`.
2. Copia `recepcion_id` y comprueba que la fila correspondiente existe en `Respaldo pedidos`.
3. En el workflow `Order Processing - Recuperación manual`, pega el identificador en `Seleccionar recepción` y ejecuta manualmente.
4. Comprueba que el pedido/productos o la decisión se recuperaron. Ejecuta una segunda vez y verifica que no se insertaron duplicados ni se cambió un estado terminal.
5. Si el origen es `PostgreSQL decisión`, compara la decisión guardada en el detalle técnico con el estado actual. La recuperación no reenvía Telegram.

La prueba depende de un fallo auténtico; sin una incidencia disponible, el resultado correcto es dejar el escenario pendiente. El workflow auxiliar es un disparador manual, no un endpoint HTTP.

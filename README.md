# n8n Order Processing

Entorno inicial para una prueba técnica de procesamiento de pedidos con n8n y Organic Driven Development (ODD).

## Entorno detectado

- n8n está ejecutándose en el contenedor Docker `n8n` (`n8nio/n8n:latest`); versión detectada desde el contenedor: **2.47.7**.
- Docker CLI/Engine disponible: **29.1.3**.
- Git disponible: **2.52.0.windows.1**.
- No se detectó una instalación de n8n en PATH ni como paquete npm global. Esta carpeta es independiente del contenedor y de los workflows existentes.

## Validación de pedidos (objetivo 3)

El workflow `workflows/order-processing.json` recibe pedidos en `POST /pedidos`. Comprueba cliente, email, productos con nombre, cantidad positiva y precio, y total. Compara el total con la suma exacta en centavos, sin redondeo binario. Los válidos siguen a la confirmación de recepción; los inválidos se guardan con sus motivos en la tabla de datos de n8n `Incidencias pedidos` y reciben una respuesta HTTP 400.

El export referencia la tabla de esta instancia; al importarlo en otra, crea una tabla con las columnas de texto `pedido` y `motivos` y selecciónala en el nodo `Registrar incidencia`. El registro contiene el pedido serializado y la lista de motivos. Los ejemplos están en `samples/pedido.json` y `samples/pedido-invalido.json`; las pruebas y resultados se encuentran en `samples/probar-objetivo-3.ps1` y `samples/resultados-objetivo-3.md`.

## Persistencia en PostgreSQL (objetivo 4.2)

Los pedidos válidos se guardan en `pedidos` junto con sus productos en `productos`, mediante una consulta parametrizada y atómica. La confirmación se emite después de guardar. La rama de incidencias permanece sin cambios. El esquema está en `sql/objetivo-4.2.sql` y los resultados en `samples/resultados-objetivo-4.2.md`.

Al importar el workflow, configura una credencial PostgreSQL propia en los nodos PostgreSQL y selecciona la tabla de incidencias de la instancia. No incluyas contraseñas en el export ni en el repositorio.

## Aprobación de pedidos (objetivo 5)

La migración `sql/objetivo-5.sql` añade el estado sin asignar uno a los pedidos anteriores. Los pedidos nuevos de hasta 1.000 se guardan como `PROCESSED`; los superiores se guardan como `PENDING_APPROVAL`. El nodo de decisión solo modifica filas pendientes y asigna `APPROVED` o `REJECTED`. Las pruebas reales están documentadas en `samples/resultados-objetivo-5.md`.

Al importar el JSON, selecciona tus credenciales PostgreSQL y Telegram, y escribe tu propio Chat ID en `Solicitar aprobación`. El JSON no incluye credenciales ni Chat ID. El nodo nativo genera enlaces de respuesta a partir de la URL de n8n; esta debe ser válida para Telegram y accesible para la persona que responde. Para la prueba se utilizó temporalmente una URL HTTPS de ngrok ya disponible y configurada en n8n; la dirección concreta no forma parte del export. Cada entorno debe configurar su propia URL externa y mantenerla disponible mientras haya aprobaciones pendientes.

El webhook confirma la recepción después de guardar el pedido y antes de enviar la solicitud a Telegram. Si el envío falla, el pedido permanece en `PENDING_APPROVAL`; la confirmación de recepción no demuestra que se haya enviado la solicitud.

## Objetivo 6: recuperación de errores

La migración `sql/objetivo-6.sql` se aplicó a la base de este proyecto. El workflow guarda cada entrada en `Respaldo pedidos` antes de validarla. Las incidencias de validación siguen en `Incidencias pedidos`; los fallos de PostgreSQL y Telegram se registran por separado en `Errores técnicos pedidos`. En otra instancia hay que crear las dos tablas y seleccionarlas en los workflows: `Respaldo pedidos` usa columnas de texto `pedido`, `idempotency_key`, `recepcion_id`; `Errores técnicos pedidos` usa `origen`, `recepcion_id`, `pedido`, `detalle`.

La cabecera opcional `Idempotency-Key` identifica reintentos del mismo pedido. Una clave ya usada con contenido diferente devuelve 409. Si no se envía, cada solicitud nueva es independiente, incluso si el contenido es idéntico; los reintentos internos usan el identificador de recepción. Los registros históricos no se interpretan como reintentables. El respaldo y las incidencias pueden contener datos personales y deben protegerse como tales.

PostgreSQL reintenta hasta tres veces. Si persiste el fallo, se conserva el original y se devuelve 503. Para recuperar una entrada registrada con origen `PostgreSQL` o `PostgreSQL decisión`, abre el workflow `Order Processing - Recuperación manual`, introduce su `recepcion_id` en `Seleccionar recepción` y ejecútalo manualmente. La recuperación no reenvía aprobaciones; si el pedido requiere aprobación, revisa su situación antes de contactar al responsable. No debe utilizarse para los pedidos 6 y 7 sin una decisión explícita.

Telegram no se reintenta automáticamente. El registro de un fallo exige revisión manual antes de cualquier reenvío, ya que la entrega puede ser incierta. La marca `aprobacion_intentada` se establece antes del envío: representa que el envío se reservó y podría haber ocurrido, no confirma que Telegram lo recibió. La decisión solo modifica pedidos pendientes. Un fallo al guardarla se registra como `PostgreSQL decisión` con el identificador y la respuesta disponibles para revisión; no vuelve a solicitar aprobación automáticamente.

Las pruebas reales y sus límites constan en `samples/resultados-objetivo-6.md`. Ambos workflows permanecen inactivos; publicar requiere autorización.

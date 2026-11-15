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

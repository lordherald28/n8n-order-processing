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

No se guardan pedidos válidos en PostgreSQL ni se incluyen Telegram o aprobaciones.

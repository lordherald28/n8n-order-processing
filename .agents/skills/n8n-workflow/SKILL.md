---
name: n8n-workflow
description: Crea, prueba y exporta workflows del proyecto para n8n 2.47.7 en Docker.
---

# n8n workflow

- Interactúa con n8n prioritariamente y de forma obligatoria mediante las herramientas disponibles del MCP oficial autenticado por OAuth. Está prohibido usar automatización gráfica o acceder/modificar directamente la base de datos interna. Si MCP no permite una operación necesaria, informa la limitación y solicita autorización antes de usar una alternativa, conforme a `AGENTS.md`.
- Antes de cada operación, comprueba las herramientas MCP disponibles y sus capacidades reales, incluidos los permisos OAuth necesarios, el proyecto y el recurso objetivo. No supongas que una herramienta, permiso o resultado existe: basa cada paso y reporte en las respuestas reales del MCP.
- Usa las herramientas MCP que estén disponibles y autorizadas para crear, editar, ejecutar, probar y exportar workflows. Para cada acción, sigue sus requisitos documentados de referencia, descubrimiento, validación y confirmación; distingue validaciones previas de cambios persistidos y ejecuciones reales.
- Mantén compatibilidad con n8n 2.47.7. Si la instancia o las herramientas reportan una versión o capacidad incompatible, detente e informa antes de continuar.
- Limita la consulta y modificación a workflows y otros recursos del proyecto autorizado. No modifiques workflows existentes ajenos al proyecto, ni expongas credenciales o secretos.
- Pide autorización antes de cambiar Docker, instalar componentes o desplegar, conforme a `AGENTS.md`.

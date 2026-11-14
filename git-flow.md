# Git flow

- `main` es la rama estable y está protegida conceptualmente: no se permiten commits directos.
- `develop` es la rama de integración y pruebas.
- Usa una rama `feature/*` por cada objetivo de desarrollo, creada desde `develop`.
- Cada objetivo comprobado genera commits reales con mensajes [Conventional Commits](https://www.conventionalcommits.org/).
- Crea un PR de `feature/*` hacia `develop`. No lo fusiones sin aprobación humana.
- Prueba los cambios integrados en `develop` utilizando n8n local y Cloudflare Tunnel cuando corresponda al objetivo.
- Solo después de pruebas satisfactorias en `develop`, crea un PR de `develop` hacia `main`.
- Está prohibido simular commits o historial.
- Haz push a GitHub cuando exista un remoto configurado.

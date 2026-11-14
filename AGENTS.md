# AGENTS.md

## Autoridad del proyecto

Este archivo es la autoridad principal de las instrucciones del proyecto. En caso de conflicto, respeta las reglas más específicas de la tarea y las skills aplicables, sin ampliar el objetivo autorizado.

## Alcance y flujo de trabajo

- Trabaja en un solo objetivo a la vez. No comiences otro hasta que el usuario diga «listo».
- Codex puede resolver detalles técnicos menores necesarios para el objetivo actual, pero no ampliar su alcance.
- Para cada objetivo, sigue el ciclo: implementar → probar → verificar → commit.
- Pide autorización antes de instalar software, cambiar Docker o desplegar.
- No modifiques workflows existentes ajenos al proyecto ni expongas secretos.
- Codex puede crear ramas feature, commits y Pull Requests. Todo merge requiere autorización humana explícita.
- No hagas force-push, borres ramas remotas ni modifiques Rulesets sin autorización.
- Si GitHub bloquea una operación, informa del motivo sin evadir la protección.
- Sigue [git-flow.md](git-flow.md) y las skills aplicables en `.agents/skills/`.

## Uso de IA

La IA puede ayudar a analizar, implementar y documentar el objetivo autorizado. El usuario mantiene el control del alcance, las autorizaciones, las aprobaciones de PR y los merges. Registra resultados reales y no presentes trabajo no verificado como completado.

# Penalisto se despliega desde el repo como agente declarativo

Penalisto se creaba a mano en el creador de agentes: pegar las instrucciones, regenerar los .zip y subir cada skill otra vez tras cada cambio. Ahora `agente/` es un paquete de app de Microsoft 365 Agents Toolkit (manifiesto de agente declarativo v1.9, que admite skills como carpetas con su SKILL.md) y `atk provision --env dev` lo crea o lo actualiza. Las instrucciones y las skills siguen siendo los mismos archivos, así que el repo es la única fuente y no hay copia que mantener a mano. Las skills están en preview (octubre de 2026) y la CLI solo las mete en el paquete con `ATK_FRONTIER=true`.

El conocimiento se limita a la carpeta de material común por URL (`MATERIAL_COMUN_URL`), porque sin URL el agente buscaría en todo el OneDrive de la fiscal y mezclaría Asuntos. La web se limita a los mismos sitios de [ADR 0002](0002-web-limitada-sin-datos-del-asunto.md).

## Consequences

- `atk provision` se ejecuta con la cuenta de Microsoft 365 de la fiscal: el agente vive en su tenant y quien mantiene el repo no necesita cuenta propia.
- Hace falta que el tenant permita subir apps personalizadas, o que un administrador apruebe el agente. Si no, queda el camino manual: `empaquetar.sh` y el creador de agentes.
- El despliegue automático en cada push (GitHub Actions) queda para más adelante, cuando se haya comprobado el despliegue manual en su tenant.

# Penalisto se publica desde el repo como agente declarativo

Penalisto se creaba a mano en el creador de agentes: pegar las instrucciones, regenerar los .zip y subir cada skill otra vez tras cada cambio. Ahora `agente/` es un paquete de app de Microsoft 365 Agents Toolkit (manifiesto de agente declarativo v1.9, que admite skills como carpetas con su SKILL.md). Una GitHub Action genera `penalisto.zip` en cada cambio y lo publica como Release, y la fiscal lo carga como app personalizada desde Teams o la app de Microsoft 365. Las instrucciones y las skills siguen siendo los mismos archivos, así que el repo es la única fuente. Las skills están en preview (octubre de 2026) y la CLI solo las mete en el paquete con `ATK_FRONTIER=true`.

El conocimiento se limita a la carpeta de material común por URL (`MATERIAL_COMUN_URL`), porque sin URL la capacidad de OneDrive buscaría en todo el OneDrive de la fiscal y mezclaría Asuntos. La carpeta es opcional: si no hay URL, `empaquetar.sh` quita esa capacidad del paquete y el agente se queda sin acceso a OneDrive. La web se limita a los mismos sitios de [ADR 0002](0002-web-limitada-sin-datos-del-asunto.md).

## Considered Options

- `atk provision` desde su equipo: descartado porque la fiscal no puede instalar Node en su máquina.
- `atk provision` desde la GitHub Action, sin que ella intervenga: descartado porque necesita un registro de aplicación con permisos en su tenant, que solo puede crear un administrador.

## Consequences

- Cada versión sigue necesitando que ella cargue el .zip, pero es un solo archivo con un enlace fijo, en vez de pegar instrucciones y subir 7 .zip.
- El ID de la app está fijo en `env/.env.dev` y la versión es `1.0.<n.º de ejecución>`, para que cada carga sustituya a la anterior.
- El repo es privado porque `penalisto.zip` lleva dentro la URL del material común, que incluye el nombre de la organización y, si es su OneDrive, el usuario de la fiscal. Para descargar la Release hay que tener acceso al repo: ella necesita una cuenta de GitHub con acceso de lectura, o se lo manda quien mantiene el repo. La URL tampoco se escribe en el repo: va en la variable `MATERIAL_COMUN_URL`.
- Hace falta que el tenant permita cargar apps personalizadas, o que un administrador suba el .zip al catálogo de la organización. Si no, queda el camino manual: los .zip por skill de `empaquetar.sh` y el creador de agentes.

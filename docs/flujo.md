# Flujo de trabajo con Penalisto

Guía para las personas. El vocabulario está en [CONTEXT.md](../CONTEXT.md) y las decisiones de fondo en [docs/adr/](adr/).

## Equivalencias con el flujo de Matt Pocock

| Pocock | Penalisto | Notas |
|---|---|---|
| repo | Adjuntos de cada chat (PDF de la causa + Extracto) | No hay Cuaderno ([ADR 0005](adr/0005-sin-cuaderno-adjuntos-en-cada-chat.md)) |
| `grill-me` / `grilling` | Interrogar | Desde aquí se lanza Investigar y se analizan documentos |
| `research` | Investigar | Web limitada y sin datos del Asunto ([ADR 0002](adr/0002-web-limitada-sin-datos-del-asunto.md)) |
| `to-spec` | Extractar | El Extracto hace de spec |
| — | Foliar | Específico de la causa ([ADR 0006](adr/0006-folios-son-paginas-de-cada-acontecimiento.md)) |
| `implement` | Calificar | La Calificación es lo que sale del flujo |
| `code-review` | Revisar | Tres ejes: Extracto, Estándares, Legal |
| `handoff` | Traspaso | Emite el Extracto, no un documento aparte ([ADR 0001](adr/0001-extracto-unico-documento-vivo.md)) |
| `wait-what` | ¿Cómo? | En las instrucciones, no es skill |
| `CONTEXT.md` + ADRs | Extracto (Fundamento de la acusación + Pendiente) | |

## Preparación (una sola vez)

1. Opcional, se puede añadir más tarde: crear una carpeta en OneDrive o SharePoint con el **material común**, es decir, lo que no está en las webs permitidas (criterios propios, modelos de Calificación que le gusten, jurisprudencia del TS de referencia, las circulares de la FGE que más use).
2. Si existe la carpeta, crear en GitHub la variable `MATERIAL_COMUN_URL` (Settings → Secrets and variables → Actions → Variables) con su URL y volver a lanzar la Action. Sin ella, el agente sale sin acceso a OneDrive: funciona igual, pero Revisar no tiene sus criterios con los que comparar y la Calificación no sigue sus modelos.
3. Instalar el agente **Penalisto** ([ADR 0007](adr/0007-agente-declarativo-desde-el-repo.md)). Cada cambio en `agente/` que llega a `main` hace que la GitHub Action genere `penalisto.zip` y lo publique en [Releases](https://github.com/escorponox/penalisto-skills/releases/latest). La fiscal no instala nada:
   - Descargar [penalisto.zip](https://github.com/escorponox/penalisto-skills/releases/latest/download/penalisto.zip) con la sesión de GitHub iniciada: el repo es privado y ella necesita una cuenta con acceso de lectura. Si no tiene cuenta, lo descarga quien mantiene el repo y se lo manda.
   - En Teams o en la app de Microsoft 365: Aplicaciones → Administrar tus aplicaciones → Cargar una aplicación personalizada, y elegir el .zip.
   - Repetirlo cada vez que haya una versión nueva: la app conserva su ID, así que sustituye a la anterior.
   - Lo que lleva el paquete está en [agente/declarativeAgent.json](../agente/declarativeAgent.json): instrucciones, skills, web limitada (boe.es, poderjudicial.es y fiscal.es; cabe una cuarta), intérprete de código y, si hay URL, la carpeta de material común como conocimiento.
   - Para generarlo en local: `./empaquetar.sh` (necesita Node, y opcionalmente `MATERIAL_COMUN_URL=…` delante), que lo deja en `dist/penalisto.zip`.

   Si el tenant no deja subir apps propias, crearlo a mano en el creador de agentes:
   - **Instrucciones**: pegar [agente/instrucciones.md](../agente/instrucciones.md) entero.
   - **Conocimiento**: la carpeta del paso 1, enlazada. No subir archivos directamente al agente, porque no se pueden combinar con skills ([ADR 0003](adr/0003-material-comun-fuera-del-agente.md)).
   - **Web**: limitarla a 4 URLs públicas que elija ella (p. ej. boe.es, poderjudicial.es, fiscal.es y una más). Desactivar "Buscar en todos los sitios web".
   - **Intérprete de código**: activado, para que pueda entregar .docx.
   - **Skills**: subir los 7 .zip de `dist/` (uno por carpeta de `agente/skills/`). Después de editar una skill, regenerar los .zip con `./empaquetar.sh`.

## Por cada Asunto

1. Guardar en una carpeta propia del Asunto (en OneDrive o en el equipo) los **PDF de la causa, un PDF por Acontecimiento**, con nombres que digan qué contienen ("Atestado GC.pdf", "Declaración judicial perjudicada.pdf"), y, si existe, el **índice de la causa**. Así la página de cada PDF es su folio ([ADR 0006](adr/0006-folios-son-paginas-de-cada-acontecimiento.md)). Ahí se irá guardando también el último Extracto.
2. Para **cada chat**: abrir Penalisto y **adjuntar** los PDF de la causa y el último Extracto (si ya hay). Para Foliar, adjuntar también el índice; para Revisar, el Extracto y la Calificación. Copilot solo deja adjuntar 3 archivos por mensaje, así que se suben en varios mensajes seguidos (la **Carga**): Penalisto solo contesta con lo recibido y espera, sin analizar nada.
3. Cuando estén todos, escribir el nombre del paso solo, al principio del mensaje.

| Paso | Qué hace | Termina cuando |
|---|---|---|
| **Interrogar** | Preguntas por rondas con una respuesta propuesta. Ella puede contestar, pedir que investigue algo o que analice un documento. | No queda ningún apartado del Extracto sin respuesta o sin anotar en Pendiente, y ella confirma que hay un conocimiento compartido. |
| **Extractar** | Redacta o actualiza el Extracto sin preguntar, con el estilo de sus extractos. Cita "A. [nombre del PDF] (f. x)". | Cada apartado está completo o anotado en Pendiente, cada afirmación tiene su cita y el Fundamento responde a las cinco preguntas para cada acusado y delito. |
| **Foliar** | Pide en una sola lista el número de Acontecimiento de cada PDF citado (o lo saca del índice) y lo pone en las citas. | Ninguna cita lleva el nombre del PDF entre corchetes, salvo las anotadas en Pendiente. |
| **Calificar** | Genera la Calificación a partir del Extracto. Si hay Pendiente o falta Foliar, lo avisa y pregunta si sigue. | Cada elemento de la Calificación sale del Extracto. |
| **Revisar** | **En un chat nuevo.** Hallazgos graves y menores en los ejes Extracto, Estándares y Legal, sin tocar nada. Después aplica los que ella acepte. | Ella ha decidido sobre cada hallazgo. |
| **Traspaso** | Cierra el chat y emite el Extracto en .docx. | Un chat nuevo podría seguir solo con el Extracto. Después ella lo **descarga, sustituye el anterior en la carpeta del Asunto y lo adjunta en el chat siguiente**. |

Interrogar y Extractar pueden alternarse en varios chats. Cualquier chat se puede cerrar con Traspaso en cualquier momento.

## Aparcado a propósito

- **Tipos de delito** (trata, estafa…): queda 1 hueco de skill. Se decidirá con ella si se usa una skill por delito o una skill "Delitos" con un archivo por delito (si Copilot permite archivos de recursos en una skill).
- **MCP de legislación**, para cuando se vea si se puede conectar.

## Por comprobar en su tenant

- Que su cuenta puede cargar apps personalizadas: tiene que aparecerle "Cargar una aplicación personalizada" en Teams. Si no, hay que pedírselo al administrador o usar el creador de agentes.
- Que cargar una versión nueva de `penalisto.zip` sustituye a la anterior y no deja dos Penalisto.

- Que el intérprete de código y las skills funcionan juntos en el mismo agente.
- Que una skill admite archivos además del SKILL.md, y que el intérprete de código puede abrir `plantilla-extracto.docx` de Extractar (también desde Foliar y Traspaso). Si no, subir la plantilla a la carpeta de material común.
- Que una skill puede aplicar otra (Traspaso aplica Extractar; Interrogar aplica Investigar).
- Que el .docx generado se descarga bien y se puede adjuntar en otro chat.
- Cuántos PDF y de qué tamaño admite un chat como adjuntos (por mensaje, 3).
- Que Penalisto respeta la Carga: no se pone a analizar con los primeros 3 PDF.

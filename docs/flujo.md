# Flujo de trabajo con Penalisto

Guía para las personas. El vocabulario está en [CONTEXT.md](../CONTEXT.md) y las decisiones de fondo en [docs/adr/](adr/).

## Equivalencias con el flujo de Matt Pocock

| Pocock | Penalisto | Notas |
|---|---|---|
| repo | Cuaderno (uno por Asunto) | |
| `grill-me` / `grilling` | Interrogar | Desde aquí se lanza Investigar y se analizan documentos |
| `research` | Investigar | Web limitada y sin datos del Asunto ([ADR 0002](adr/0002-web-limitada-sin-datos-del-asunto.md)) |
| `to-spec` | Extractar | El Extracto hace de spec |
| — | Foliar | Específico de la causa ([ADR 0004](adr/0004-folios-se-concilian-despues.md)) |
| `implement` | Calificar | La Calificación es lo que sale del flujo |
| `code-review` | Revisar | Tres ejes: Extracto, Estándares, Legal |
| `handoff` | Traspaso | Emite el Extracto, no un documento aparte ([ADR 0001](adr/0001-extracto-unico-documento-vivo.md)) |
| `wait-what` | ¿Cómo? | En las instrucciones, no es skill |
| `CONTEXT.md` + ADRs | Extracto (Fundamento de la acusación + Pendiente) | |

## Preparación (una sola vez)

1. Crear una carpeta en OneDrive o SharePoint con el **material común**: circulares de la FGE, criterios propios, jurisprudencia del TS de referencia y modelos de Calificación que le gusten.
2. Crear el agente **Penalisto** en el creador de agentes:
   - **Instrucciones**: pegar [agente/instrucciones.md](../agente/instrucciones.md), solo el bloque de debajo de la línea.
   - **Conocimiento**: la carpeta del paso 1, enlazada. No subir archivos directamente al agente, porque no se pueden combinar con skills ([ADR 0003](adr/0003-material-comun-fuera-del-agente.md)).
   - **Web**: limitarla a 4 URLs públicas que elija ella (p. ej. boe.es, poderjudicial.es, fiscal.es y una más). Desactivar "Buscar en todos los sitios web".
   - **Intérprete de código**: activado, para que pueda entregar .docx.
   - **Skills**: subir los 7 .zip de `dist/` (uno por carpeta de `agente/skills/`). Después de editar una skill, regenerar los .zip con `./empaquetar.sh`.

## Por cada Asunto

1. Crear un **Cuaderno** con el nombre del Asunto.
2. Subir los **PDF de la causa** con nombres que digan qué contienen ("Tomo 1 – atestado y declaraciones.pdf"). Si existe, subir también el **índice de la causa con folios**.
3. Para **cada chat**: abrir Penalisto, escribir `init`, esperar "Penalisto inicializado", **mover el chat al Cuaderno** (… > Mover al cuaderno) y escribir el nombre del paso solo, al principio del mensaje.

| Paso | Qué hace | Termina cuando |
|---|---|---|
| **Interrogar** | Preguntas por rondas con una respuesta propuesta. Ella puede contestar, pedir que investigue algo o que analice un documento. | No queda ningún apartado del Extracto sin respuesta o sin anotar en Pendiente, y ella confirma que hay un conocimiento compartido. |
| **Extractar** | Redacta o actualiza el Extracto sin preguntar. Cita por documento, fecha y página del PDF. | Cada apartado está completo o anotado en Pendiente, y cada afirmación tiene su cita. |
| **Foliar** | Cambia las páginas del PDF por los folios reales, por tandas (o con el índice). | Ninguna cita queda solo con la página del PDF, salvo las anotadas en Pendiente. |
| **Calificar** | Genera la Calificación a partir del Extracto. Si Pendiente no está vacío o faltan folios, lo avisa y pregunta si sigue. | Cada elemento de la Calificación sale del Extracto. |
| **Revisar** | **En un chat nuevo.** Hallazgos graves y menores en los ejes Extracto, Estándares y Legal, sin tocar nada. Después aplica los que ella acepte. | Ella ha decidido sobre cada hallazgo. |
| **Traspaso** | Cierra el chat y emite el Extracto en .docx. | Un chat nuevo podría seguir solo con el Extracto. Después ella lo **descarga, lo sube al Cuaderno y borra el anterior**. |

Interrogar y Extractar pueden alternarse en varios chats. Cualquier chat se puede cerrar con Traspaso en cualquier momento.

## Aparcado a propósito

- **Tipos de delito** (trata, estafa…): queda 1 hueco de skill. Se decidirá con ella si se usa una skill por delito o una skill "Delitos" con un archivo por delito (si Copilot permite archivos de recursos en una skill).
- **MCP de legislación**, para cuando se vea si se puede conectar.

## Por comprobar en su tenant

- Que el intérprete de código y las skills funcionan juntos en el mismo agente.
- Que una skill admite archivos además del SKILL.md.
- Que una skill puede aplicar otra (Traspaso aplica Extractar; Interrogar aplica Investigar).
- Que el .docx generado se descarga bien y se puede subir al Cuaderno.

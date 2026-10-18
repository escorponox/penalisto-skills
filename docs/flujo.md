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

1. Crear una carpeta en OneDrive o SharePoint con el **material común**: circulares de la FGE, criterios propios, jurisprudencia del TS de referencia y modelos de Calificación que le gusten.
2. Desplegar el agente **Penalisto** desde este repo con Microsoft 365 Agents Toolkit ([ADR 0007](adr/0007-agente-declarativo-desde-el-repo.md)):
   - Instalar la CLI (`npm install -g @microsoft/m365agentstoolkit-cli`) y activar las skills con `export ATK_FRONTIER=true TEAMSFX_AGENT_SKILLS=true`. Sin `ATK_FRONTIER` la CLI 1.1.18 genera el paquete sin las skills, aunque la documentación solo menciona `TEAMSFX_AGENT_SKILLS`.
   - En [env/.env.dev](../env/.env.dev), poner en `MATERIAL_COMUN_URL` la URL de la carpeta del paso 1.
   - Ejecutar `atk provision --env dev` e iniciar sesión con la cuenta de Microsoft 365 de la fiscal, que es la que tiene Copilot. La primera vez crea el agente; las siguientes lo actualizan con lo que haya en `agente/`.
   - Lo que se despliega está en [agente/declarativeAgent.json](../agente/declarativeAgent.json): instrucciones, skills, web limitada (boe.es, poderjudicial.es y fiscal.es; cabe una cuarta), intérprete de código y la carpeta de material común como conocimiento.

   Si el tenant no deja subir apps propias, crearlo a mano en el creador de agentes:
   - **Instrucciones**: pegar [agente/instrucciones.md](../agente/instrucciones.md) entero.
   - **Conocimiento**: la carpeta del paso 1, enlazada. No subir archivos directamente al agente, porque no se pueden combinar con skills ([ADR 0003](adr/0003-material-comun-fuera-del-agente.md)).
   - **Web**: limitarla a 4 URLs públicas que elija ella (p. ej. boe.es, poderjudicial.es, fiscal.es y una más). Desactivar "Buscar en todos los sitios web".
   - **Intérprete de código**: activado, para que pueda entregar .docx.
   - **Skills**: subir los 7 .zip de `dist/` (uno por carpeta de `agente/skills/`). Después de editar una skill, regenerar los .zip con `./empaquetar.sh`.

## Por cada Asunto

1. Guardar en una carpeta propia del Asunto (en OneDrive o en el equipo) los **PDF de la causa, un PDF por Acontecimiento**, con nombres que digan qué contienen ("Atestado GC.pdf", "Declaración judicial perjudicada.pdf"), y, si existe, el **índice de la causa**. Así la página de cada PDF es su folio ([ADR 0006](adr/0006-folios-son-paginas-de-cada-acontecimiento.md)). Ahí se irá guardando también el último Extracto.
2. Para **cada chat**: abrir Penalisto, **adjuntar** los PDF de la causa y el último Extracto (si ya hay), y escribir el nombre del paso solo, al principio del mensaje. Para Foliar, adjuntar también el índice; para Revisar, el Extracto y la Calificación.

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

- Que su cuenta puede subir apps personalizadas (si no, `atk provision` falla y hay que pedírselo al administrador o usar el creador de agentes).

- Que el intérprete de código y las skills funcionan juntos en el mismo agente.
- Que una skill admite archivos además del SKILL.md.
- Que una skill puede aplicar otra (Traspaso aplica Extractar; Interrogar aplica Investigar).
- Que el .docx generado se descarga bien y se puede adjuntar en otro chat.
- Cuántos PDF y de qué tamaño admite un chat como adjuntos.

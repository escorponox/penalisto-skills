# El Extracto es el único documento vivo; el Traspaso es un paso, no un documento

En el flujo de Pocock, el glosario (`CONTEXT.md`), las decisiones (ADRs) y el handoff son artefactos separados que el agente escribe solo en el repo. En Copilot, un chat no puede guardar archivos: cada documento obliga a la fiscal a descargarlo y adjuntarlo a mano en el chat siguiente. Por eso lo juntamos todo en un único documento por Asunto, el Extracto: las decisiones de la fiscal van en su Fundamento de la acusación, y lo que falta en el apartado Pendiente. Cerrar un chat (Traspaso) consiste en emitir el Extracto actualizado.

## Considered Options

- Tres documentos (Extracto, Decisiones, Traspaso), como en Pocock: descartado porque triplica el trabajo manual y abre la puerta a que se desincronicen.

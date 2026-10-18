# Sin Cuaderno: los PDF de la causa y el Extracto se adjuntan en cada chat

La idea inicial era tener un Cuaderno de Copilot por Asunto, con los PDF de la causa y el Extracto, y mover a él cada chat con Penalisto (de ahí el mensaje `init`). Pero un agente personalizado no se puede usar dentro de un Cuaderno (octubre de 2026), así que se descarta. Cada chat con Penalisto empieza de cero y la fiscal le adjunta lo que necesita: los PDF de la causa y el Extracto más reciente, más el índice para Foliar o la Calificación para Revisar. Los guarda ella en una carpeta del Asunto fuera de Copilot. Desaparece `init`. Traspaso no cambia: emite el Extracto, que la fiscal adjunta en el chat siguiente.

## Considered Options

- Una carpeta de OneDrive o SharePoint por Asunto enlazada como conocimiento: descartado porque el conocimiento es del agente, no de cada chat, y mezclaría los Asuntos.
- Un único chat por Asunto: descartado porque los chats largos pierden contexto y Revisar necesita un chat nuevo.

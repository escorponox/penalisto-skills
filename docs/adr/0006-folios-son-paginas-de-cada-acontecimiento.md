# Los folios son las páginas de cada PDF; Foliar solo numera los Acontecimientos

Sustituye al [ADR 0004](0004-folios-se-concilian-despues.md). La fiscal ya no descarga la causa en un solo PDF: adjunta cada Acontecimiento en su propio PDF, así que la página del PDF es el folio. Penalisto cita desde el principio `A. [nombre del PDF] (f. 2-3)` y lo único que no puede saber es el número de Acontecimiento, porque el PDF no lo trae. Foliar sigue siendo un paso propio, después de Extractar, pero ahora pide un número por PDF en una sola lista (o lo saca del índice de la causa) en vez de repasar las citas una a una.

## Considered Options

- Seguir con un solo PDF y convertir las páginas en folios cita por cita, como decía el ADR 0004: descartado porque obliga a repasar cada cita, y ahora basta con un número por PDF.

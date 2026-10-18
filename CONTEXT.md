# Penalisto

Flujo de trabajo para que una fiscal trabaje con un agente de Microsoft 365 Copilot especializado en derecho penal español. Adapta el flujo de skills de Matt Pocock (interrogar → spec → implementar → revisar) al trabajo de calificar en una fiscalía: el Extracto hace de spec y la Calificación es lo que se produce.

## Language

### Herramientas

**Penalisto**:
El agente personalizado de Copilot especializado en penal. Es el único agente que ejecuta el flujo.
_Avoid_: bot, asistente, Copilot (Copilot es la plataforma, no el agente)

**Skill**:
Paquete de instrucciones (SKILL.md) instalado en Penalisto que define cómo ejecutar un paso del flujo.
_Avoid_: prompt, plantilla

**Adjuntos**:
Los archivos que la fiscal adjunta al abrir cada chat con Penalisto: los PDF de la causa, el Extracto más reciente y, si hace falta, el índice de la causa o la Calificación. Es lo único que Penalisto ve del Asunto, porque cada chat empieza de cero. Es lo que más se parece a un repo de Pocock.
_Avoid_: Cuaderno, notebook, carpeta

### Personas

**Visador**:
Fiscal que supervisa y da el visto bueno a la Calificación. Es uno de los lectores del Extracto.
_Avoid_: jefe, revisor

**Fiscal de juicio**:
Compañero que acude al juicio oral del Asunto, que no tiene por qué ser quien calificó. Es el otro lector del Extracto.
_Avoid_: fiscal de sala

### El Asunto

**Asunto**:
Un procedimiento penal concreto en el que la fiscal tiene que calificar.
_Avoid_: caso, expediente, causa

**Tipo de procedimiento**:
La clase de procedimiento del Asunto (sumario, abreviado, jurado, delitos leves…). Determina la forma de la Calificación.
_Avoid_: tipo de causa

### Pasos del flujo

**Interrogar**:
Paso en el que Penalisto hace preguntas por rondas hasta alcanzar con la fiscal un conocimiento compartido del Asunto. Dentro de este paso se pueden lanzar Investigar y analizar documentos de la causa.
_Avoid_: entrevista, grill

**Investigar**:
Consulta de legislación, jurisprudencia o doctrina, con la fuente citada. Se lanza normalmente dentro de Interrogar.
_Avoid_: research, buscar

**Extractar**:
Paso en el que Penalisto redacta o actualiza el Extracto a partir de lo ya fijado, sin hacer más preguntas. Es el equivalente de `to-spec`.
_Avoid_: resumir

**Foliar**:
Paso posterior a Extractar en el que Penalisto repasa con la fiscal cada cita del Extracto para sustituir la página del PDF por el folio real de la causa.
_Avoid_: conciliar, citar

**Calificar**:
Paso en el que Penalisto genera la Calificación a partir del Extracto, no de la conversación suelta.
_Avoid_: redactar, implementar

**Revisar**:
Paso en el que Penalisto evalúa una Calificación, en un chat nuevo que solo ve el Extracto y la Calificación, según tres ejes: Extracto, Estándares y Legal.
_Avoid_: corregir, code review

**Eje Extracto**:
Eje de Revisar que comprueba que la Calificación recoge todo lo del Extracto y no añade nada que no esté en él.
_Avoid_: eje spec

**Eje Estándares**:
Eje de Revisar que comprueba el formato propio del Tipo de procedimiento, que estén las conclusiones del art. 650 LECrim, los criterios de la fiscal, las circulares de la FGE y la jurisprudencia del Tribunal Supremo.
_Avoid_: eje estilo

**Eje Legal**:
Eje de Revisar que comprueba que las penas estén dentro del marco legal, que los tipos penales estén vigentes en la fecha de los hechos y que las circunstancias modificativas estén bien aplicadas.
_Avoid_: eje jurídico

**Traspaso**:
Paso con el que se cierra un chat: Penalisto emite el Extracto actualizado para que la fiscal lo adjunte en el chat siguiente y este continúe.
_Avoid_: resumen, handoff

**¿Cómo?**:
Petición de la fiscal para que Penalisto vuelva a explicar su último mensaje con más claridad.
_Avoid_: wait-what, aclarar

### Artefactos

**Extracto**:
El diagnóstico de la causa y el único documento vivo del Asunto: un esquema que analiza la prueba por apartados (acusados, testifical, pericial, documental) siguiendo el orden de la causa, y que termina con el Fundamento de la acusación. Es la spec del flujo.
_Avoid_: ficha del asunto, resumen, expediente, CONTEXT.md

**Fundamento de la acusación**:
Apartado final del Extracto que explica, para el Visador y el Fiscal de juicio, por qué se acusa, con qué prueba y por qué se descarta lo que no se acusa.
_Avoid_: conclusión, motivación

**Pendiente**:
Apartado del Extracto con lo que falta por aclarar o decidir. Es lo primero que lee el chat siguiente, y tiene que estar vacío antes de Calificar.
_Avoid_: tareas, siguiente paso

**Calificación**:
El escrito que produce el flujo: escrito de calificación provisional en sumario o escrito de acusación en abreviado. Su contenido sigue las conclusiones del art. 650 LECrim.
_Avoid_: borrador, escrito de acusación, escrito (a secas)

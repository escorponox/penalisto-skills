---
name: extractar
description: 'Extractar: redacta o actualiza el Extracto del Asunto solo con lo ya fijado. Úsala cuando la fiscal escriba "Extractar" solo, al principio del mensaje.'
---

# Extractar

Pon por escrito en el Extracto lo que ya está fijado: sintetiza lo que hay en la conversación, en el Extracto anterior y en la causa. Lo que siga abierto va a Pendiente. Escríbelo como lo escribe la fiscal: es su documento y lo van a leer el Visador y el Fiscal de juicio.

## Pasos

1. **Reúne lo fijado**: la conversación de este chat, el Extracto adjunto (si existe) y los PDF de la causa.
2. **Redacta el Extracto** con la estructura de tus instrucciones. Si ya existía, actualízalo: conserva lo que siga valiendo y cambia solo lo que la conversación haya modificado.
3. **Cita cada afirmación** como dicen tus instrucciones: Acontecimiento y folio, o el nombre del PDF entre corchetes si aún no tiene número.
4. **Escribe el Fundamento de la acusación** para alguien que no ha estado en la conversación (ver abajo).
5. **Pasa a Pendiente** todo lo que esté sin decidir, sea contradictorio o no tenga cita, tal cual: decidirlo es cosa de la fiscal.
6. **Entrega** el Extracto como .docx generado sobre `plantilla-extracto.docx` (ver abajo).

## Cómo se escribe cada apartado

**Acusados y Testifical.** En mayúsculas el nombre del acusado o testigo, con su papel si lo tiene ("(perjudicada)", "(taxista)"). Debajo, una entrada por declaración, en el orden de la causa, que empieza por la cita y el tipo: "A. 9 (f. 2-3). Denuncia.", "A. 13. Declaración judicial.". Para los acusados, primero la HHP en una línea: "A. 15. HHP. Limpia." o "No computables".

- Lo que declara, en estilo indirecto y en frases cortas: "Que no conoce al otro investigado.". Si declara mucho, en una lista.
- Si no declara, dilo en la misma línea: "Asistido de Letrado. No declara.".
- Si una declaración ratifica otra anterior, pon solo lo que añade: "Ratifica su declaración policial. Añade: …".
- Si el testigo reclama, cierra con "RECLAMA.".
- Si algo no cuadra con otra cita (cantidades, fechas, quién hizo qué), anótalo en el sitio: "(NOTA: no son 500 sino 1.000 euros en total, A. 10 (f. 3))". Solo contradicciones o datos que no casan; tus valoraciones van al Fundamento.

**Pericial.** Una línea por pericia: cita, tipo y conclusión. Si la conclusión decide la calificación, cítala literal entre comillas.

**Documental.** El índice de la causa: una línea por Acontecimiento relevante, en orden, con lo que es y, si hace falta, lo que acredita ("A. 10. Oficio policial 24/03/2026. Titularidad del teléfono y de la cuenta: ambos del acusado."). Incluye los autos (prisión, PA, procesamiento, conclusión). Dentro del atestado, desglosa sus folios con sangría.

**Fundamento de la acusación.** Prosa en primera persona, la de la fiscal ("Lo veo como tentativa porque…"), con las decisiones que ella tomó en Interrogar. Empieza por la prueba de cargo en una frase y luego razona. Recoge sus dudas, lo que habrá que ver en juicio y el margen para una conformidad si ella lo ha dicho. Las sentencias y criterios que hayan salido, con su referencia y la cita literal del pasaje que importa. Si hay responsabilidad civil, explica el cálculo y el baremo o criterio. Termina con la Calificación propuesta de cada acusado, en una lista corta: delitos con artículo, título de participación, circunstancias modificativas, penas y responsabilidad civil.

Para cada acusado y cada delito, el Fundamento tiene que responder a cinco preguntas, sin usarlas como títulos:

1. ¿Qué prueba hay?
2. ¿Dónde está? (con la cita)
3. ¿Qué acredita?
4. ¿Qué problemas tiene? (la versión del acusado, contradicciones, lo que falta)
5. ¿Por qué basta para condenar?

**Encabezado y pie**, tal como dicen tus instrucciones. La fecha es la de hoy.

## Generar el .docx

Usa siempre la plantilla `plantilla-extracto.docx` de esta skill: ya trae el escudo y "Fiscalía de Área de Elche" en el encabezado, el número de página en el pie, los márgenes y Arial 12 con interlineado 1,5. Ábrela con el intérprete de código (python-docx), borra los párrafos de ejemplo y escribe cada párrafo con su estilo. No pongas formato a mano: el estilo ya lo lleva.

| Estilo | Para |
|---|---|
| Extracto Cabecera | Las tres líneas del encabezado: órgano, procedimiento, NGF |
| Extracto Titulo | "EXTRACTO" |
| Extracto Apartado | Título de cada apartado: ACUSADOS, TESTIFICAL, PERICIAL, DOCUMENTAL, FUNDAMENTO DE LA ACUSACIÓN, PENDIENTE |
| Extracto Persona | Nombre del acusado o testigo, y "Calificación propuesta: <acusado>" |
| Extracto Cita | Línea de cita y tipo de cada declaración ("A. 9 (f. 2-3). Denuncia.") |
| Extracto Texto | Lo que declara, las notas, las líneas de Documental y Pericial, y el Fundamento |
| Extracto Lista | Puntos de una declaración larga y de la Calificación propuesta (la raya la pone el estilo) |
| Extracto Folio | Folios desglosados dentro del atestado en Documental |
| Extracto Pendiente | Cada entrada de Pendiente (el número lo pone el estilo) |
| Extracto Firma | "Elche, <fecha>", "La Fiscal", "Marta Lacasa", tras un párrafo vacío de Extracto Texto |

```python
from docx import Document
doc = Document("plantilla-extracto.docx")
for p in list(doc.paragraphs):
    p._element.getparent().remove(p._element)
doc.add_paragraph("PA 604/2026", style="Extracto Cabecera")
p = doc.add_paragraph(style="Extracto Texto")
p.add_run("Prueba de cargo: ").bold = True   # negrita solo para una etiqueta dentro del texto
p.add_run("atestado, declaraciones de los testigos e informe forense.")
doc.save("Extracto - <Asunto>.docx")
```

Si no encuentras la plantilla, dilo y genera el .docx con ese mismo formato: A4, márgenes de 2,5 cm arriba y abajo y 3 cm a los lados, Arial 12, interlineado 1,5, justificado. Cabecera en negrita; "EXTRACTO" centrado, en negrita y subrayado; títulos de apartado en mayúsculas y negrita dentro de un recuadro; nombres en negrita; líneas de cita subrayadas; firma alineada a la derecha.

## Terminado

El Extracto está listo cuando **cada apartado está completo o tiene su entrada en Pendiente**, **cada afirmación sobre la causa tiene su cita** y **el Fundamento responde a las cinco preguntas para cada acusado y delito**. Luego propón el siguiente paso: Interrogar si Pendiente tiene decisiones abiertas, Foliar si quedan citas con el nombre del PDF entre corchetes, o Calificar si no falta nada.

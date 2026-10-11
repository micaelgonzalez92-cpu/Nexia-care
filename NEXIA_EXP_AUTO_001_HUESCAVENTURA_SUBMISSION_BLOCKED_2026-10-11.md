# NEXIA EXP-AUTO-001 — HUESCAVENTURA SUBMISSION CHECKPOINT — 2026-10-11

Status: USER AUTHORIZED SUBMISSION / PROJECT REVERIFIED OPEN / SUBMISSION BLOCKED BY FREE EXECUTION CHANNEL
Cost: €0
Proposal price authorized: €300
Paid plans/tools: NOT AUTHORIZED

## Authorization
Kael explicitly authorized one proposal to the Huescaventura Workana project at €300 with the previously prepared bounded scope, with no spend and no paid plan.

## Live project verification
The public Workana project was rechecked immediately after authorization and still appeared as OPEN / EVALUATING PROPOSALS with the same semiautomatic n8n + Airtable scope and €200–€300 indicative budget.

## Execution-channel check
- Workana connector/plugin available in the current ChatGPT plugin catalog: NONE FOUND.
- Native web search can read the public project but cannot authenticate or submit forms.
- The available dynamic browser automation route in this session is metered/paid.
- The user explicitly prohibited spend and paid plans for this submission.

Therefore the proposal was **not submitted**. Using the metered browser would exceed the approved cost boundary.

## Final proposal text — READY FOR MANUAL SUBMISSION

Me encaja especialmente que queráis empezar de forma semiautomática y con revisión humana. Para esta primera fase priorizaría fiabilidad, duplicados, campos faltantes y trazabilidad antes de automatizar el envío al cliente. Además, vuestro caso está bien acotado porque el lead ya llega a Airtable y disponéis de n8n autoalojado.

1. **Cómo plantearía la fase semiautomática**
   Lead ya creado en Airtable -> validación/normalización -> clasificación -> detección de datos faltantes/posibles duplicados -> resumen interno -> respuesta sugerida -> aviso interno -> estado/próximo paso. El mensaje al cliente no se enviaría automáticamente en esta fase.

2. **Herramientas**
   n8n como orquestador y Airtable como fuente/estado principal. IA solo donde aporte valor (clasificación, resumen y borrador) y reglas deterministas para validación, campos obligatorios, idempotencia y duplicados. Un único canal interno de aviso (Telegram o email) para mantener el piloto simple.

3. **Estructura de leads**
   Identidad/contacto, origen, tipo de solicitud, fecha, personas, alojamiento, actividades, datos faltantes, resumen, estado, siguiente acción, última interacción, posible duplicado e identificador de procesamiento.

4. **Clasificación**
   Categorías de negocio acordadas: despedida, amigos, familia, empresa, escolar, solo actividad y pack con alojamiento. Mantendría una categoría de revisión cuando la entrada sea ambigua.

5. **Datos faltantes**
   Matriz de campos mínimos por tipo de solicitud. El flujo compara lo recibido con esa matriz y guarda qué falta, sin inventar datos.

6. **Respuesta sugerida**
   Generada a partir de categoría + datos presentes + faltantes + siguiente paso, con prompt restringido para no inventar precios, disponibilidad ni condiciones. Se guarda como borrador para revisión humana.

7. **Duplicados, errores y campos incompletos**
   Idempotencia por evento y reglas explícitas de identidad (email/teléfono normalizados cuando exista contexto suficiente), evitando fusiones agresivas. Los errores quedan visibles y no deben producir escrituras parciales. Los casos dudosos pasan a revisión humana.

8. **Seguimiento si el cliente no responde**
   En esta fase guardaría estado + fecha de próximo seguimiento y generaría una tarea/aviso interno. No activaría envío autónomo hasta que el flujo esté probado y aprobado.

9. **Experiencia previa**
   He construido y probado un prototipo técnico local de intake de leads con validación, idempotencia, deduplicación conservadora, actualización no destructiva, borrador de respuesta y manejo de fallos. Las pruebas actuales incluyen 9/9 tests de lógica y 12/12 pruebas de integración HTTP local. Quiero ser preciso: todavía no lo presento como un despliegue productivo previo en n8n para un cliente; precisamente por eso propongo esta primera fase pequeña, medible y con supervisión humana.

10. **Plazo y presupuesto**
   Presupuesto: **€300** para esta primera fase acotada, incluyendo workflow exportable, pruebas con datos de muestra, documentación breve y una ronda de corrección. Objetivo interno de ejecución: <=4 horas de trabajo medido una vez disponibles los accesos/campos acordados. El calendario final lo confirmaría tras revisar la estructura real de Airtable y el n8n existente, sin ampliar alcance sin aprobación.

### Alcance incluido
- una fuente de entrada ya existente;
- Airtable/Google Sheets como destino/estado;
- validación y clasificación;
- detección de faltantes;
- deduplicación conservadora;
- resumen y respuesta sugerida;
- una notificación interna;
- estado/próximo paso;
- lógica básica de seguimiento;
- pruebas con datos de muestra;
- export del workflow + documentación breve;
- una ronda de corrección.

### Excluido
- envío autónomo por WhatsApp;
- configuración de WhatsApp Business API;
- migración CRM;
- campañas multicanal;
- compra de APIs/suscripciones;
- limpieza histórica masiva;
- soporte abierto sin límite.

## Required human action
Because no free authenticated Workana submission channel is available from this session, Kael must manually submit the prepared proposal from Workana if he wants to preserve the zero-cost boundary.

No proposal, message, contract, revenue or payment was created by this checkpoint.

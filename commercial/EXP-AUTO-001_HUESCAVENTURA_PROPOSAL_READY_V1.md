# EXP-AUTO-001 — HUESCAVENTURA PROPOSAL READY V1

Date: 2026-10-13
Status: INTERNAL READY / NOT SUBMITTED
Opportunity: WORKANA-HUESCAVENTURA-001
Authorized gross price: EUR 300
Submission authority: CONDITIONAL — only after Workana profile approval is explicitly verified, the project is freshly rechecked open, and submission requires EUR0 additional spend.
External contact performed: NO
Cash spend: EUR0

## Current public brief snapshot

Revalidated on 2026-10-13 from the public Workana project page:
- project remains Abierto / Evaluando propuestas;
- approximate budget EUR 200–300 fixed price;
- 1 visible proposal;
- buyer payment verified;
- n8n already self-hosted;
- desired phase is explicitly semiautomatic with human review before WhatsApp/email sending;
- requested functions include lead detection, field review, classification, missing-data detection, internal summary, suggested response, internal notification, lead state/next step, duplicate detection, basic follow-up, documentation and exportable n8n workflow;
- buyer asks applicants to answer 10 concrete implementation questions.

Public source:
https://www.workana.com/es/job/automatizar-recepcion-y-clasificacion-de-leads-desde-formulario-con-airtable-y-n8n

## Submission draft

Hola,

Plantearía esta primera fase como una automatización comercial semiautomática y acotada: un único flujo de entrada de leads, reglas claras, IA solo donde aporta valor y revisión humana antes de cualquier mensaje al cliente. La prioridad sería que el sistema sea mantenible, fácil de probar y que no pierda ni duplique oportunidades.

### 1. ¿Cómo plantearía esta fase semiautomática?

Partiría del lead que ya llega desde vuestra web a Airtable o Google Sheets. Desde ahí, n8n validaría y normalizaría los datos, clasificaría la solicitud, detectaría información faltante, prepararía un resumen interno y una respuesta sugerida, avisaría al equipo y dejaría registrado el estado y próximo paso. La respuesta al cliente quedaría preparada, pero no se enviaría automáticamente en esta primera fase.

### 2. ¿Qué herramientas usaría y por qué?

Usaría vuestro n8n autoalojado como orquestador. Para la primera versión elegiría una única fuente de verdad —Airtable o Google Sheets, según cuál esté realmente usando el flujo actual— y un único canal de aviso interno, Telegram o email. La IA la usaría para clasificación, resumen y borrador de respuesta, pero las validaciones, duplicados, estados y reglas críticas quedarían controlados de forma determinista en el workflow.

### 3. ¿Cómo estructuraría la base de leads?

Mantendría una estructura simple y auditable con, como mínimo: identificador de origen, fecha de entrada, nombre, teléfono, email, fecha deseada, número de personas, alojamiento, actividades/intereses, tipo de lead, datos faltantes, resumen interno, estado, próximo paso, fecha de próximo seguimiento, contador de seguimientos y claves normalizadas para control de duplicados. Evitaría crear campos que no tengan una función operativa real.

### 4. ¿Cómo clasificaría el lead?

Combinaría reglas explícitas con IA. Las categorías serían las que ya habéis definido: despedida, grupo de amigos, familia, empresa, escolar, solo actividad y pack con alojamiento. Cuando la información sea insuficiente o ambigua, el sistema no debería forzar una categoría: marcaría el lead para revisión humana.

### 5. ¿Cómo detectaría datos faltantes?

Definiríamos qué campos son obligatorios por tipo de solicitud. n8n compararía cada lead con esa matriz y devolvería exactamente qué información falta. La IA no rellenaría ni inventaría datos ausentes; solo ayudaría a redactar una pregunta útil para obtenerlos.

### 6. ¿Cómo generaría una respuesta sugerida útil para WhatsApp/email?

El borrador se generaría usando únicamente los datos disponibles del lead y unas reglas de tono/objetivo acordadas. La respuesta debería ser breve, contextual, pedir solo los datos realmente necesarios y orientar al siguiente paso comercial. En esta primera fase quedaría como borrador para copiar/revisar y enviar manualmente.

### 7. ¿Cómo gestionaría duplicados, errores o campos incompletos?

Usaría identificadores de evento cuando existan y una identidad normalizada basada en teléfono/email para detectar repeticiones de forma conservadora. Un mismo lead no debería crear registros duplicados por reintentos. Los errores de integración, datos inválidos o casos ambiguos irían a una ruta de revisión con estado explícito, en vez de dejar el workflow fallando silenciosamente.

### 8. ¿Cómo plantearía el seguimiento si el cliente no responde?

Guardaría estado, fecha del último contacto, próximo seguimiento y número de intentos. n8n podría generar una tarea o aviso interno cuando corresponda, pero mantendría el envío al cliente bajo revisión humana en esta primera versión. Así se puede medir el proceso antes de automatizar más.

### 9. ¿He creado automatizaciones de leads o respuestas comerciales antes?

He construido y ejecutado una prueba técnica específica en n8n 2.42.6 para intake de leads, validación, normalización, clasificación/revisión y deduplicación persistente. La prueba se ejecutó con casos separados por webhook y verificó que el estado de duplicados sobrevivía a un reinicio del proceso. Prefiero ser preciso: es una prueba técnica ejecutada y reproducible, no la presentaré como una implantación previa para un cliente de pago. Esa base técnica sí es directamente adaptable a vuestro flujo real.

### 10. ¿Qué plazo y presupuesto propondría?

Para una primera versión funcional y acotada propondría EUR 300 a precio fijo. Alcance: una fuente de entrada (Airtable o Sheets), las clasificaciones acordadas, validación de campos, control conservador de duplicados, resumen, respuesta sugerida con revisión humana, un canal de aviso interno, estado/próximo paso, seguimiento básico, pruebas, workflow exportable, documentación corta y una corrección acotada tras vuestra revisión.

Plazo propuesto: 2 días laborables desde que estén disponibles los accesos necesarios y una pequeña muestra de leads reales o anonimizados para probar el flujo.

Para considerar la primera fase aceptada, propondría probar juntos casos normales, un lead incompleto, un duplicado y un caso deliberadamente inválido. Si esos casos quedan bien resueltos y el flujo es claro de mantener, la fase estaría lista; cualquier ampliación a WhatsApp Business API, más canales o automatización autónoma se trataría como una fase posterior.

## Scope lock

Included in EUR300:
- one inbound source: Airtable OR Google Sheets;
- required-field validation and normalization;
- requested bounded lead classification;
- missing-data detection;
- internal summary;
- suggested reply under human review;
- one internal notification channel: Telegram OR email;
- state / next-step / basic follow-up fields;
- conservative deduplication;
- invalid/error review path;
- sample/synthetic acceptance cases;
- n8n workflow export;
- short handover/documentation;
- one bounded correction.

Excluded unless separately approved and repriced:
- both Airtable and Sheets as parallel production sources;
- autonomous customer sending;
- WhatsApp Business/API setup;
- CRM migration;
- mass historical cleanup;
- multi-channel rollout;
- complex load/concurrency guarantees;
- paid APIs/subscriptions purchased by Nexia;
- open-ended support.

## Internal rejection memo — professional gate

### Strongest rejection reason
"The applicant does not show prior paid-client production experience."

Resolution:
- Do not hide or exaggerate this gap.
- Answer question 9 with a specific executed technical proof: n8n 2.42.6, separate webhook cases, persistent deduplication and process restart.
- The buyer asks whether the applicant has created lead/commercial-response automations and requests an example; it does not state that paid-client production history is mandatory.
- Remaining risk is commercial credibility, not technical truth. The proposal offsets it with specific architecture, acceptance tests and a tightly bounded first milestone.

### Second strongest rejection reason
"EUR300 could become an underpriced broad build if every listed tool/channel is interpreted as included."

Resolution:
- Explicitly lock phase 1 to Airtable OR Sheets and Telegram OR email.
- Keep WhatsApp sending human-reviewed and exclude WhatsApp Business/API setup.
- Treat additional channels/integrations as later phases.

### Obvious amateur signal to avoid
Generic statements such as "I can automate this with AI and n8n" without explaining identity, missing-data policy, error handling, follow-up state or acceptance criteria.

Resolution:
- Proposal specifies normalized identifiers, deterministic validation, REVIEW fallback, explicit error path, state fields and concrete acceptance cases.

### Missing edge case
Replayed events or the same person arriving with incomplete/changed data could create duplicate records or overwrite useful information.

Resolution:
- Use source/event ID when available plus normalized phone/email identity;
- apply conservative merge/update policy only after agreed rules;
- route ambiguity to human review rather than destructive merging.

### Missing differentiation
Many applicants can connect nodes; the buyer explicitly values maintainability, errors, duplicates and non-generic responses.

Resolution:
- Differentiate on reliability: deterministic checks around the AI, persistent identity state, observable errors, human approval and acceptance tests.

## Professional readiness adjudication

TECHNICAL GATE: PASS — underlying n8n capability evidence already executed.
DOMAIN GATE: PASS — proposal maps directly to the buyer's lead process and requested categories/actions.
DEFECT GATE: PASS WITH SCOPE LOCK — major overrun risks are excluded explicitly.
PROFESSIONAL BENCHMARK GATE: PASS — proposal answers all 10 buyer questions with implementation-specific detail and avoids generic AI-sales language.
ADVERSARIAL REVIEW GATE: PASS — principal credibility and scope objections are disclosed and bounded rather than hidden.
ECONOMIC/EXPOSURE GATE: BLOCKED UNTIL EXISTING CONDITIONS — profile approval not verified; project must remain open; submission cost must remain EUR0.

READY STATUS: INTERNALLY READY FOR SUBMISSION ONLY WHEN THE EXISTING COMMERCIAL GATE CLEARS.

## Internal economics

Gross: EUR300
Platform fee assumption: 20% = EUR60
Estimated after platform: EUR240
Human labor target: <=4h at EUR15/h = <=EUR60
Estimated contribution before overhead/tax if target met: EUR180
Tax: UNKNOWN
Realized revenue/profit: EUR0 until paid and reconciled.

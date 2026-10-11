# NEXIA EXP-AUTO-001 — HUESCAVENTURA CANDIDATE GATE — 2026-10-11

Status: QUALIFIED FOR HUMAN-GATED PROPOSAL / NOT SUBMITTED / NO CONTACT EXECUTED
Cost so far: €0
Source: public Workana buyer brief.

## Buyer-initiated opportunity

Project: "Automatización de respuestas y seguimiento de leads por Whatsapp/email con N8n, Airtable e Ia" — Huescaventura.

Public brief facts observed:
- status shown as open/evaluating proposals;
- first phase explicitly semiautomatic, with human review before WhatsApp/email sending;
- existing site already creates leads in Airtable from chat/form;
- requested first-phase functions include lead classification, missing-data detection, internal summary, suggested reply, internal alert, next-step state, duplicate detection, basic follow-up logic and documentation;
- existing self-hosted n8n is already available to the buyer;
- stated indicative budget: €200–€300 fixed price;
- public page showed 1 proposal / 1 interested freelancer at research time;
- client showed 2 projects published, 1 paid project and verified payment.

This brief is materially closer to EXP-AUTO-001 than the previously sampled higher-budget briefs because the requested architecture is deliberately bounded and semiautomatic, values duplicates/errors/maintenance, and does not require autonomous customer messaging in phase 1.

## Qualification score

Pre-contact score using NEXIA_EXP_AUTO_001_VALIDATION_PACK.md:
- manual/repetitive lead process explicitly stated: +2
- one existing primary intake path into Airtable: +1
- clear lightweight data destination (Airtable/Google Sheets): +1
- stated pain around response speed / lost opportunities / follow-up: +2
- budget supports a €249–€300 proposal: +2
- explicitly values duplicates, errors, maintenance and documentation: +1
- asks for prior examples but does not state a mandatory production-portfolio threshold: +1

Total: 10/10 before channel-cost adjustment.

No automatic NO-GO condition identified from the public brief. However, the answer about prior experience must be fully truthful: Nexia has synthetic/local lead-automation evidence, not a client n8n deployment.

## Channel economics — Workana fee discovered after initial EXP-AUTO-001 economics precommitment

Official Workana documentation currently states that the freelancer commission at the start of a client relationship is 20%; proposal submission itself is free.

Original EXP-AUTO-001 contribution target used:
- target realized price: €249;
- labor: <=4.0 h at €15/h = €60;
- variable tooling/API allowance: <=€10;
- provisional contribution target before acquisition overhead/tax: €179.

Workana channel recomputation:

### At €249 gross proposal
- Workana 20% commission: €49.80
- after platform commission: €199.20
- after 4 h labor (€60), assuming €0 other variable tooling: €139.20 contribution
- with the original €10 variable-cost allowance: €129.20

Conclusion: €249 on Workana FAILS the original provisional contribution gate.

### At €300 gross proposal
- Workana 20% commission: €60
- after platform commission: €240
- after 4 h labor (€60), assuming €0 other variable tooling: €180 contribution
- with €10 other variable cost: €170

Conclusion: at €300, the original ~€179 provisional contribution is only preserved if additional variable tooling/API cost is approximately €0 and delivery remains <=4 h. Therefore €300 is the only defensible price inside the buyer's stated range if the experiment keeps the original economics target.

The threshold is not being retroactively changed. The new platform fee is new evidence requiring channel-specific recomputation.

## Proposed bounded scope at €300 — draft only

Phase 1 only:
1. trigger on new lead already created in Airtable (or one agreed existing source only);
2. normalize and validate key fields;
3. classify into the buyer's agreed lead categories;
4. identify required missing fields;
5. generate internal structured summary;
6. generate a suggested WhatsApp/email response for human review only;
7. create one internal notification channel chosen by the buyer (Telegram OR email);
8. detect obvious duplicates using explicit identity rules;
9. write lead status and next-step fields;
10. create one basic non-response follow-up flag/state, not autonomous customer messaging unless separately agreed;
11. test with synthetic/sample leads first;
12. deliver exported n8n workflow + concise handover notes + one bounded correction round.

Explicit exclusions at this price:
- no autonomous WhatsApp sending;
- no WhatsApp Business API setup;
- no multi-channel production campaign;
- no new CRM migration;
- no paid API/subscription purchase by Nexia;
- no large historical-data cleanup;
- no more than one chosen internal notification channel;
- no open-ended support obligation.

## Delivery-time gate

Target <=4 measured hours total including review/correction/handover.

Suggested internal timebox:
- 0.5 h: map Airtable fields + classification/missing-field contract;
- 1.25 h: n8n workflow construction for intake/validation/classification/dedup/status;
- 0.75 h: suggested-response + internal notification branch;
- 0.5 h: test set + error/duplicate cases;
- 0.5 h: documentation/export;
- 0.5 h: correction reserve.

Total target: 4.0 h.

If real access/configuration complexity makes this estimate impossible before commitment, do not silently expand scope; re-scope or stop.

## Truthful answer to the buyer's 10 questions — DRAFT / NOT SENT

1. **¿Cómo plantearías esta fase semiautomática?**
   Como un flujo acotado y revisable: el lead ya entra en Airtable; n8n valida/normaliza, clasifica, detecta datos faltantes y posibles duplicados, prepara resumen + respuesta sugerida, avisa internamente y deja estado/próximo paso. El mensaje al cliente no se envía automáticamente en esta fase.

2. **¿Qué herramientas usarías y por qué?**
   Aprovecharía vuestro n8n autoalojado como orquestador y Airtable como fuente/estado principal. Usaría IA únicamente para tareas donde aporte valor (clasificación/resumen/borrador) y mantendría reglas deterministas para validación, campos obligatorios, idempotencia y duplicados. Telegram o email solo como aviso interno, eligiendo uno para mantener el piloto simple.

3. **¿Cómo estructurarías la base de leads?**
   Con campos de identidad/contacto, origen, tipo de solicitud, fecha/personas/alojamiento/actividades, datos faltantes, resumen, estado, siguiente acción, última interacción, indicador de posible duplicado y un identificador de procesamiento para evitar repetir eventos.

4. **¿Cómo clasificarías el lead?**
   Primero con las categorías ya definidas por negocio (despedida, amigos, familia, empresa, escolar, solo actividad, pack con alojamiento). Separaría reglas de negocio verificables de la clasificación asistida por IA y dejaría categoría "revisión" cuando la entrada sea ambigua.

5. **¿Cómo detectarías datos faltantes?**
   Definiría una matriz de campos mínimos por tipo de solicitud. El flujo compara los campos presentes con esa matriz y guarda qué falta sin inventar datos.

6. **¿Cómo generarías una respuesta sugerida útil?**
   A partir de categoría + datos presentes + datos faltantes + siguiente paso. El prompt estaría restringido para no inventar precios, disponibilidad ni condiciones. La salida queda como borrador para revisión humana.

7. **¿Cómo gestionarías duplicados, errores o campos incompletos?**
   Idempotencia por evento y reglas explícitas de identidad (por ejemplo email/teléfono normalizados cuando exista contexto suficiente), sin fusionar agresivamente datos ambiguos. Los errores deben quedar visibles y no producir escrituras parciales. Los casos dudosos pasan a revisión humana.

8. **¿Cómo plantearías el seguimiento si el cliente no responde?**
   En fase 1 guardaría estado + fecha de próximo seguimiento y generaría una tarea/aviso interno. No activaría envío autónomo al cliente hasta que el primer flujo esté probado y aprobado.

9. **¿Has creado automatizaciones de leads o respuestas comerciales antes?**
   He construido y probado un prototipo técnico local de intake de leads con validación, idempotencia, deduplicación conservadora, actualización no destructiva, borrador de respuesta y manejo de fallos. Las pruebas actuales incluyen 9/9 tests de lógica y 12/12 pruebas de integración HTTP local. Quiero ser preciso: todavía no lo presento como un despliegue productivo previo en n8n para un cliente; precisamente por eso propondría esta primera fase pequeña, medible y con supervisión humana.

10. **¿Qué plazo y presupuesto propones?**
    Propuesta preparada: €300 para esta primera fase estrictamente acotada, con workflow exportable, pruebas con datos de muestra, documentación breve y una ronda de corrección. Objetivo interno de ejecución: <=4 horas de trabajo medido una vez disponibles accesos/campos acordados. El calendario externo concreto debe confirmarse solo tras revisar la estructura real de Airtable y el n8n existente.

## Proposal opener — DRAFT / NOT SENT

"Me encaja especialmente que queráis empezar de forma semiautomática y con revisión humana: para una primera fase, priorizaría fiabilidad, duplicados, campos faltantes y trazabilidad antes de automatizar el envío al cliente. Vuestro caso también está bien acotado porque el lead ya llega a Airtable y disponéis de n8n autoalojado."

## Human Gate

No proposal has been submitted.

To submit this candidate, explicit Kael authorization is required for:
- Workana proposal submission to this specific public project;
- price boundary of €300 (different from the original €249 hypothesis because Workana's 20% channel fee changes unit economics);
- use/connection/creation of a Workana freelancer account if not already available/approved;
- any later client contact within Workana generated by the proposal.

No paid plan is required to submit proposals according to Workana's public documentation, but profile approval/account state is UNKNOWN in the current session.

## Decision

Candidate status: **QUALIFIED FOR HUMAN-GATED PROPOSAL AT €300 ONLY**.

At €249 through Workana: economics FAIL.
At €300: economics are provisionally viable only if delivery <=4 h and extra paid tooling ~= €0.

No revenue, contract, payment or client acceptance is claimed.

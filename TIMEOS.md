# NEXIA TIMEOS — TIEMPO, ATENCIÓN HUMANA Y APALANCAMIENTO

Status: ACTIVE / MODEL C / EVIDENCE-GATED
Updated: 2026-10-15

## Propósito
Medir tiempo, atención humana, espera y retrabajo para aumentar el apalancamiento de Nexia sin confundir sacrificio con progreso.

El objetivo no es maximizar horas trabajadas ni productividad económica aislada. Es reducir tiempo total hasta un sistema excelente y validado, reservando la atención humana para identidad, autoridad, juicio estratégico y excepciones donde realmente aporta valor.

## Integridad
- HECHO VERIFICADO: registrar tiempo real solo con fuente temporal razonable.
- ESTIMACIÓN: útil para planificar, nunca equivalente a tiempo medido.
- UNKNOWN / NOT INSTRUMENTED != 0.
- Conversación abierta, worker instalado o automatización diseñada no equivalen a horas activas ni a ahorro.
- Ahorro de automatización requiere baseline comparable y medición posterior neta de mantenimiento/excepciones.

## Campos por sesión/tarea relevante
- session_id
- date
- start/end/duration cuando estén instrumentados
- mission/workstream/experiment
- actor: NEXIA / KAEL / MIXED
- action / intended outcome
- System Loop / Reality Loop / support classification
- result / evidence_level
- human_attention_minutes
- waiting_latency_minutes cuando sea material
- rework_minutes
- automation_minutes_saved_estimate_or_measured
- maintenance_minutes
- exception_minutes
- human_action_category A–F
- blocker / next_action

## Clasificación humana
A. identidad/legal/acción física inevitable;
B. autoridad/aprobación;
C. juicio estratégico;
D. excepción/incidencia;
E. automatizable pero todavía no automatizada;
F. fricción innecesaria.

Objetivo: reducir F primero y E después cuando el valor neto sea positivo. No eliminar A–D mediante atajos que rompan autoridad, seguridad, calidad o realidad externa.

## Métricas de atención
- Human Attention Hours/week.
- Kael-only minutes/week.
- Human Attention by A–F category.
- Gate waiting latency.
- Rework hours.
- Human Actions / meaningful outcome or transaction where meaningful.
- Exception/escalation rate.
- Minutes saved net of maintenance.

## Métricas de apalancamiento
Según contexto:
- verified useful outcomes per Human Attention Hour;
- resolved material defects per Human Attention Hour;
- validated learning / decisions unlocked per Human Attention Hour;
- contribution or revenue per Human Attention Hour for commercial work;
- autonomous verified executions / human interventions;
- reusable capability created versus maintenance imposed.

No existe una única métrica universal de productividad humana.

## Automatización — Value Test
Antes de invertir trabajo técnico material:
1. definir proceso/workload y por qué importa;
2. medir/estimar explícitamente baseline;
3. identificar toil, errores, riesgo, espera y coste;
4. estimar build + maintenance + failure burden;
5. verificar observabilidad/recovery necesarias;
6. automatizar si el valor sistémico + externo esperado supera la carga;
7. medir después;
8. mantener, simplificar, ampliar o retirar según evidencia.

Valor válido puede ser: tiempo, fiabilidad, recuperación, evidencia, velocidad, calidad, utilidad externa, capacidad reutilizable o economía sostenible.

No automatizar un proceso defectuoso, no observable o irrelevante. Una capacidad crítica de seguridad/continuidad puede justificar automatización antes de monetización.

## Baseline de Kael — 7 días representativos
Estado actual: `NOT_INSTRUMENTED / PREPARED`.

Antes de fijar un Kael Attention Budget:
- registrar durante 7 días representativos solo la atención material, con mínima fricción;
- clasificar minutos A–F;
- registrar esperas causadas por Human Gates cuando sean materiales;
- identificar tareas repetidas que Nexia podría preparar, eliminar o automatizar;
- separar trabajo deliberado de tiempo pasivo/espera;
- no imponer un registro tan costoso que invalide la medición.

El baseline no obliga a trabajar un número específico de horas. Su función es revelar capacidad real y desperdicio.

## Protocolo mínimo de captura
Cuando Kael realiza una acción material solicitada por Nexia, basta con capturar cuando sea posible:
`fecha | acción | minutos aproximados o medidos | categoría A–F | resultado`.

Si el dato no se obtiene con fricción razonable, marcar UNKNOWN en lugar de insistir.

## Velocidad
Optimizar:
- total cycle time;
- waiting latency;
- rework;
- handoffs;
- time-to-detect failure;
- time-to-recover;
- time-to-learning;
- time-to-ready-for-current-purpose.

Más rapidez local no es mejor si aumenta retrabajo, errores o fragilidad.

## Estado actual
A 2026-10-15:
- capital spent: EUR0;
- revenue / settled revenue / reconciled net profit: EUR0;
- Kael weekly available hours: NOT INSTRUMENTED;
- Contra setup attention elapsed: UNKNOWN_NOT_INSTRUMENTED;
- EXP-AUTO-001 mantiene <=4h humanas como gate precomprometido de entrega del piloto; no es el presupuesto semanal de Kael ni la misión de Nexia;
- Human Actions/real transaction: NOT COMPUTABLE sin transacción real;
- Local Worker machine time no equivale a tiempo humano.

## Regla de progreso
Atribuir progreso temporal cuando exista evidencia de mejora/resultado/aprendizaje: verdad, recuperación, fiabilidad, calidad, autonomía, external reality, reducción de toil/rework, capacidad reusable o economía sostenible.

No atribuir progreso por volumen de mensajes, documentos, commits, agentes, automatizaciones o complejidad.

## Próximo paso
Usar este protocolo de forma ligera cuando aparezcan acciones humanas materiales suficientes para producir un baseline representativo. No inventar horas retrospectivamente.

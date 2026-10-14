# NEXIA TIMEOS — Tiempo, atención humana y productividad económica

Status: ACTIVE / EVIDENCE-GATED
Updated: 2026-10-14

## Propósito
Medir el tiempo y la atención humana dedicados a NEXIA por misión, experimento y resultado, evitando confundir actividad con progreso y permitiendo reducir dependencia humana de forma verificable.

## Regla de integridad
- HECHO VERIFICADO: solo registrar tiempo real cuando exista una fuente temporal fiable.
- ESTIMACIÓN: puede aproximarse para planificación, pero nunca convertirse en tiempo medido.
- UNKNOWN / NOT INSTRUMENTED ≠ 0.
- Conversación abierta, worker instalado o automatización diseñada no equivalen a horas activas ni a ahorro de tiempo.
- Una automatización solo demuestra ahorro cuando existe baseline comparable y medición posterior neta de mantenimiento/excepciones.

## Campos por sesión/tarea relevante
- session_id
- start_time / end_time / duration_minutes cuando estén instrumentados
- mission_id / experiment_id
- task / workstream
- actor: NEXIA / KAEL / MIXED
- action
- output
- evidence_level
- result
- value_created
- human_attention_minutes
- automation_minutes_saved_estimate_or_measured
- maintenance_minutes
- exception_minutes
- blocker
- next_action

## Métricas principales

### Economía del tiempo
- Human Attention Hours / semana.
- Human Attention Hours / experimento.
- Human Attention Hours / entrega/transacción.
- Revenue per Human Attention Hour = ingreso realizado / atención humana medida del mismo alcance.
- Contribution per Human Attention Hour = contribución realizada / atención humana medida del mismo alcance.
- Net Profit per Human Attention Hour = beneficio neto reconciliado / atención humana medida del mismo periodo, solo cuando sea contablemente válido.

### Dependencia humana
- Human Actions / transaction.
- Human Dependency Ratio = acciones operativas realmente humanas / acciones operativas significativas totales, solo con instrumentación suficiente.
- Tiempo hasta resolver Human Gate.
- % acciones humanas clasificadas como automatable-but-not-yet-automated.
- % acciones humanas por identidad/legalidad/autoridad/decisión/excepción.

### Automatización
- minutos baseline vs minutos asistidos/automatizados para workload comparable;
- minutos ahorrados netos = baseline − post-automation − mantenimiento − excepciones atribuibles;
- automation success rate = ejecuciones verificadas correctas / intentos;
- exception/escalation rate;
- error/failure cost avoided cuando pueda medirse;
- coste de infraestructura/API/energía cuando sea material e instrumentado.

## Clasificación de acciones humanas
A. identidad/legal/acción física inevitable;
B. autoridad/aprobación reservada a Kael;
C. juicio estratégico;
D. excepción/incidencia;
E. automatizable pero todavía no automatizada;
F. fricción innecesaria.

Objetivo de autonomía: reducir F y E cuando el valor esperado sea positivo. No intentar eliminar A–D mediante atajos que rompan autoridad, seguridad o calidad.

## Automation Value Test
Antes de invertir trabajo técnico en una automatización:
1. definir proceso y workload;
2. medir o estimar explícitamente baseline;
3. identificar error/riesgo/coste actual;
4. estimar coste de construcción + mantenimiento;
5. automatizar solo si reduce tiempo/error/coste/riesgo o aumenta evidencia/beneficio;
6. medir después;
7. mantener, simplificar o retirar según resultado.

No optimizar una automatización cuyo proceso todavía no tiene demanda o relevancia económica demostrable salvo que sea una capacidad de seguridad/continuidad crítica.

## Estado actual
A 2026-10-14:
- Capital registrado: €0.
- Revenue / settled revenue / reconciled net profit: €0.
- EXP-AUTO-001 tiene techo precomprometido de <=4 h humanas por piloto, pero no existe todavía entrega real para medir.
- Human Attention Hours/week: NOT INSTRUMENTED.
- Human Actions/real transaction: NOT INSTRUMENTED porque no existe transacción real.
- Revenue/Contribution per Human Attention Hour: NOT COMPUTABLE aún.
- Local Worker stability trial: tiempo de máquina no debe registrarse automáticamente como tiempo humano; su coste eléctrico permanece UNKNOWN/NOT INSTRUMENTED mientras no se mida.

## Regla de productividad
Progreso se atribuye por evidencia + resultado + aprendizaje + mejora reproducible + efecto económico/decisional o reducción verificada de carga/riesgo.

No se atribuye progreso por volumen de mensajes, documentos, commits, agentes, automatizaciones o complejidad arquitectónica.

## Próximo objetivo de TimeOS
Instrumentar atención humana de manera casi automática y con baja fricción cuando existan entregas/transacciones reales, empezando por EXP-AUTO-001. No imponer registro manual intensivo a Kael si el coste de medir supera el valor de la medición.

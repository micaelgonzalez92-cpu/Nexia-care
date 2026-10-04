# EXP-001B — Protocolo de prueba mejorado

Updated: 2026-10-05
Cost: €0

## Objetivo
No medir solo si el usuario entiende el diagnóstico. Medir si Nexia Care puede ayudar a resolver un problema real en el primer intento o producir el dato mínimo que permite el siguiente diagnóstico.

## Hipótesis
H1: Un flujo que empieza por el síntoma concreto, cambia una sola variable por vez y termina en una acción reversible aumentará la probabilidad de acción útil frente al MVP actual.
H2: Registrar resultado antes/después permite distinguir utilidad real de una recomendación que simplemente suena plausible.
H3: Los casos de café aguado, flujo lento/goteo y dosificación irregular son buenos primeros candidatos porque admiten observación antes/después y aparecen repetidamente en comunidades de propietarios.

## Diseño de prueba
1. El participante explica el problema con sus palabras.
2. Se registra modelo y síntoma inicial.
3. El participante usa Nexia Care sin instrucciones técnicas adicionales.
4. Nexia debe proponer una primera acción segura/reversible.
5. El participante ejecuta la acción.
6. Se registra resultado antes/después.
7. Si no se resuelve, se captura el dato nuevo más útil y se termina sin rescate salvo riesgo de seguridad.
8. Al final: utilidad 1-5, confianza 1-5, tiempo aproximado y punto de fricción.

## Guardrails
- No desmontar componentes internos.
- No recomendar comprar piezas como primera respuesta.
- No indicar maniobras eléctricas o de servicio interno.
- Ante humo, olor a quemado, agua cerca de electricidad o comportamiento peligroso: detenerse y desenchufar.
- Una modificación por prueba cuando el problema sea de extracción/molienda.

## Casos prioritarios
### A — Café débil / dosis baja
Variables observables: cantidad de molienda, intensidad seleccionada, forma del poso, cuerpo del café.
Resultado mínimo: mejora perceptible o diagnóstico más específico.

### B — Flujo lento / goteo
Variables observables: duración aproximada de extracción, flujo continuo vs gotas, ajuste de molienda.
Resultado mínimo: mejora del flujo o evidencia de que no es un ajuste simple.

### C — No sale café
Variables observables: ruido/bomba, circulación de agua, depósito, presencia de aviso.
Resultado mínimo: recuperación del flujo o clasificación clara para servicio.

## Métrica principal
% de participantes que llegan a una acción útil sin ayuda significativa.

## Métricas secundarias
- % resuelto en primera acción
- % que obtiene un dato diagnóstico nuevo aunque no se resuelva
- tiempo hasta primera acción
- abandonos
- rescates
- confianza
- utilidad percibida

## Criterio de aprendizaje
Un resultado aislado no valida el producto. Buscar al menos 3 pruebas y comparar rutas.

## Evidencia externa que motivó esta mejora
- ForoCafé muestra casos españoles de Magnifica S/ECAM22.110 con café aguado, goteo y problemas de molienda. cite pendiente: registrar fuente externa en el informe, no dentro de la app.
- Reddit, 13 ago 2026: propietario de ECAM22.110.B reportó una reducción aproximada del 30-40% en la molienda, café débil y posos irregulares; el caso seguía sin resolver en la conversación. Esto es señal de problema real, no evidencia de que Nexia Care lo resuelva.

## Human Gate
La investigación puede descubrir casos y preparar mensajes. El contacto externo debe realizarlo Kael mediante un canal autorizado.

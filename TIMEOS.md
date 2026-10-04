# NEXIA TIMEOS — Registro de tiempo y productividad

## Propósito
Medir el tiempo de trabajo dedicado a NEXIA por misión, bloque y resultado, evitando confundir actividad con progreso.

## Regla de integridad
- HECHO VERIFICADO: solo se registran como horas reales las que tengan una fuente temporal fiable.
- ESTIMACIÓN: puede reconstruirse una ventana temporal de conversación, pero no equivale a tiempo activo trabajando.
- HIPÓTESIS: valor económico/hora futuro.
- RECOMENDACIÓN: usar sesiones explícitas desde ahora para mejorar precisión.
- No se atribuyen horas ficticias a NEXIA ni a Kael.

## Estado inicial
A fecha 2026-10-04:
- Horas históricas exactas de trabajo activo: NO DISPONIBLES.
- Tiempo calendario de conversaciones: existe parcialmente en el historial, pero no permite distinguir conversación activa, pausas y trabajo efectivo.
- Tiempo de trabajo por misión: NO MEDIDO de forma estructurada.
- Coste económico registrado: 0 €.
- Ingresos atribuibles: 0 €.
- Beneficio atribuible: 0 €.

## Reconstrucción histórica cualitativa
El trabajo del proyecto se ha concentrado en:
1. Arquitectura y diseño operativo de NEXIA.
2. Diseño del sistema de misiones, Human Gate, agentes, memoria y economía.
3. Investigación y descarte de oportunidades de negocio.
4. Diseño y validación conceptual de NEXIA Care.
5. Investigación de economía de consumibles/afiliación y descarte de una vía con margen insuficiente.
6. Construcción del MVP diagnóstico de NEXIA Care.
7. Construcción del estado persistente NEXIA_STATE.json y NEXIA_MEMORY.md.
8. Construcción del HQ inicial de solo lectura.
9. Configuración de GitHub Pages y preparación/verificación pendiente de publicación.
10. Diseño y documentación del reclutamiento del primer participante real.
11. Configuración de automatizaciones operativas.
12. Diseño de la arquitectura de autonomía progresiva.
13. Definición del protocolo de voz/wake-word y registro de comandos.
14. Diseño de la futura adquisición automatizada de participantes.
15. Definición de TimeOS como sistema de medición de esfuerzo/productividad.

## Valoración actual
El trabajo realizado ha producido infraestructura real y documentación real, pero todavía no existe evidencia económica.
Por tanto:
- Actividad acumulada: ALTA.
- Evidencia comercial: BAJA / 0 usuarios reales.
- Extracción: 0.
- Reproducibilidad: 0.
- Principal riesgo: seguir invirtiendo tiempo en arquitectura antes de obtener evidencia de usuario.

## TimeOS operativo desde ahora
Cada sesión de trabajo relevante deberá registrar:
- session_id
- start_time
- end_time
- duration_minutes
- mission_id
- task
- agent/workstream
- action
- output
- evidence_level
- result
- value_created
- blocker
- next_action

## Métricas
- Horas por misión.
- Horas por experimento.
- Horas de arquitectura vs validación.
- Horas hasta primera evidencia.
- Horas hasta primera extracción.
- Horas por extracción.
- Coste económico por hora.
- Beneficio neto por hora.
- % del tiempo dedicado a actividades que generan evidencia.
- % de trabajo que puede automatizarse.
- Tiempo humano de Kael por hito.

## Regla de productividad
XP/progreso solo se atribuye por:
evidencia + resultado + aprendizaje + mejora reproducible.

No se atribuye progreso por número de mensajes, documentos creados o complejidad arquitectónica.

## Próximo objetivo de TimeOS
Conectar el registro de tiempo a las misiones reales de NEXIA sin introducir una carga manual significativa para Kael.

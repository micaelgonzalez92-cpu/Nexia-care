# NEXIA — Comandos de sistema

Registro vivo de comandos útiles para consultar, dirigir y auditar NEXIA sin tener que explicar el contexto cada vez.

## Cómo usarlos

Puedes decirlos en lenguaje natural. No necesitas memorizar una sintaxis exacta.

### Estado y control
- **NEXIA, estado** — estado global: misión, experimento activo, capital, ingresos, beneficio, usuarios, bloqueos y Human Gate.
- **NEXIA, avance** — qué ha cambiado desde la última revisión y qué se ha ejecutado realmente.
- **NEXIA, misión** — misión prioritaria única y criterio de éxito/fracaso.
- **NEXIA, siguiente** — siguiente acción útil de mayor prioridad que pueda ejecutarse ahora.
- **NEXIA, bloqueos** — bloqueos actuales, dependencia y qué los desbloquea.
- **NEXIA, decisiones** — decisiones que requieren intervención de Kael, separadas de lo que NEXIA puede ejecutar sola.

### Economía y riesgo
- **NEXIA, economía** — ingresos, costes, margen, beneficio, capital disponible y economía de los experimentos activos.
- **NEXIA, riesgo** — riesgos abiertos, probabilidad/impacto cualitativos, límites y mitigaciones.
- **NEXIA, gate** — Human Gate: gastos, compromisos o acciones irreversibles pendientes de aprobación.

### Descubrimiento y experimentación
- **NEXIA, radar** — oportunidades nuevas, evidencia, falsación, economía preliminar y descartes.
- **NEXIA, experimentos** — experimentos activos/finalizados con hipótesis, acción, métrica, resultado y aprendizaje.
- **NEXIA, mejoras** — mejoras detectadas, aplicadas, pendientes y motivo de prioridad.
- **NEXIA, comparar [A] vs [B]** — comparación factual por demanda, margen, riesgo, capital, automatización y escalabilidad, sin ranking arbitrario.
- **NEXIA, falsar [oportunidad]** — intenta encontrar primero las razones por las que la oportunidad podría no funcionar.

### Memoria y arquitectura
- **NEXIA, memoria** — aprendizajes, descartes, hipótesis obsoletas y trabajo ya realizado para evitar duplicación.
- **NEXIA, arquitectura** — estado de módulos, dependencias y cambios estructurales.
- **NEXIA, automatización** — automatizaciones activas, propósito, frecuencia, límites y posibles duplicados.
- **NEXIA, HQ** — estado del centro de mando y de sus fuentes de datos.
- **NEXIA, telemetría** — qué métricas se capturan realmente y qué todavía no está instrumentado.

### Voz e interacción
- **NEXIA, modo escucha** — informa del estado del protocolo de activación por palabra clave.
- **NEXIA, activa escucha** — solicita el modo de activación por palabra clave para la conversación.
- **NEXIA, desactiva escucha** — solicita volver al comportamiento normal de conversación.
- **Regla de activación propuesta:** una frase hablada solo se interpreta como dirigida a NEXIA cuando comienza con **“Nexia”** (admitiendo pausas o puntuación natural). Las frases que no comiencen con la palabra clave se tratan como conversación ambiente y no como instrucciones de NEXIA.

### Ejecución
- **NEXIA, construye [mejora]** — ejecuta si es segura, reversible y sin gasto; si requiere aprobación, prepara la acción y la deja en Human Gate.
- **NEXIA, prepara [experimento]** — devuelve hipótesis, acción, coste, métrica, éxito, fracaso, riesgo e información obtenida.
- **NEXIA, auditoría** — busca inconsistencias, afirmaciones no verificadas, automatizaciones ficticias, datos obsoletos y trabajo duplicado.
- **NEXIA, informe** — resumen ejecutivo: hechos verificados, cambios reales, bloqueos, intervención humana imprescindible y única siguiente misión.

## Contrato de respuesta

Cada comando debe distinguir:
- **HECHO VERIFICADO**
- **ESTIMACIÓN**
- **HIPÓTESIS**
- **RECOMENDACIÓN**

Y respetar:
- 0 € mientras sea posible.
- Ningún gasto, contratación o acción irreversible sin aprobación de Kael.
- No afirmar ejecución, automatización o verificación sin evidencia.
- Priorizar la siguiente acción que aumente evidencia, beneficio, automatización, escalabilidad o reduzca riesgo/coste.

## Mantenimiento automático

Este registro debe revisarse periódicamente junto con la mejora continua de NEXIA:
1. Añadir comandos que aparezcan como necesidad repetida.
2. Eliminar o fusionar comandos redundantes.
3. Mantener descripciones cortas y accionables.
4. No crear comandos solo por estética.
5. Registrar cambios reales en GitHub.

**Versión:** 1.1
**Última actualización:** 2026-10-04

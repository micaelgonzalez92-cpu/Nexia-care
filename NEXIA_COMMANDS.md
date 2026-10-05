# NEXIA — Comandos de sistema

Registro vivo de comandos útiles para consultar, dirigir y auditar NEXIA sin tener que explicar el contexto cada vez.

## Cómo usarlos
Puedes decirlos en lenguaje natural. No necesitas memorizar una sintaxis exacta.

### Estado y control
- **NEXIA, estado** — estado global: misión, experimento activo, capital, ingresos, beneficio, usuarios, bloqueos y Human Gate.
- **NEXIA, avance** — qué ha cambiado desde la última revisión y qué se ha ejecutado realmente.
- **NEXIA, misión** — misión prioritaria y criterios de éxito/fracaso.
- **NEXIA, siguiente** — siguiente acción útil de mayor prioridad que pueda ejecutarse ahora.
- **NEXIA, bloqueos** — bloqueos actuales, dependencia y qué los desbloquea.
- **NEXIA, decisiones** — decisiones que requieren intervención de Kael, separadas de lo que NEXIA puede ejecutar sola.
- **NEXIA, gates** — cola completa de Human Gates paralelos, prioridad, estado y acción requerida.

### Autoridad, sincronización y auditoría
- **NEXIA, autoridad** — clasifica una acción como GREEN/YELLOW/RED y explica qué autorización necesita.
- **NEXIA, sincronización** — estado de consistencia entre STATE y artefactos derivados; nunca afirma sincronización sin verificación.
- **NEXIA, auditoría** — busca inconsistencias, afirmaciones no verificadas, automatizaciones ficticias, datos obsoletos y trabajo duplicado.
- **NEXIA, decisiones** — consulta el Decision Log antes de repetir una investigación.
- **NEXIA, autorización [acción]** — prepara el contrato de autorización: hipótesis, acción, coste, métrica, éxito, fracaso, riesgo, información y stop/rollback.
- **NEXIA, verifica [acción]** — comprueba evidencia de ejecución antes de marcarla como completada.

### Economía y riesgo
- **NEXIA, economía** — ingresos, costes, margen, beneficio, capital disponible y economía de los experimentos activos.
- **NEXIA, riesgo** — riesgos abiertos, probabilidad/impacto cualitativos, límites y mitigaciones.
- **NEXIA, gate** — Human Gate: gastos, compromisos o acciones irreversibles pendientes de aprobación.
- **NEXIA, costes** — desglose de costes reales y potenciales de la siguiente acción, antes de pedir aprobación.

### Usuario y validación
- **NEXIA, usuario** — estado del experimento NEXIA Care con foco en usuarios reales, feedback, fricciones y siguiente paso de validación.
- **NEXIA, validación** — evidencia acumulada, qué está demostrado, qué sigue siendo hipótesis y qué prueba falta.
- **NEXIA, experimentos** — experimentos activos/finalizados con hipótesis, acción, métrica, resultado y aprendizaje.

### Descubrimiento y experimentación
- **NEXIA, radar** — oportunidades nuevas, evidencia, falsación, economía preliminar y descartes.
- **NEXIA, mejoras** — mejoras detectadas, aplicadas, pendientes y motivo de prioridad.
- **NEXIA, comparar [A] vs [B]** — comparación factual por demanda, margen, riesgo, capital, automatización y escalabilidad.
- **NEXIA, falsar [oportunidad]** — intenta encontrar primero las razones por las que la oportunidad podría no funcionar.

### Memoria y arquitectura
- **NEXIA, memoria** — aprendizajes, descartes, hipótesis obsoletas y trabajo ya realizado.
- **NEXIA, arquitectura** — estado de módulos, dependencias y cambios estructurales.
- **NEXIA, automatización** — automatizaciones activas, propósito, frecuencia, límites y duplicados.
- **NEXIA, HQ** — estado del centro de mando y de sus fuentes de datos.
- **NEXIA, telemetría** — métricas capturadas realmente y qué todavía no está instrumentado.

### Ejecución
- **NEXIA, construye [mejora]** — ejecuta si es segura, reversible y sin gasto; si requiere aprobación, prepara la acción y la deja en Human Gate.
- **NEXIA, prepara [experimento]** — hipótesis, acción, coste, métrica, éxito, fracaso, riesgo e información obtenida.
- **NEXIA, informe** — hechos verificados, cambios reales, bloqueos, intervención humana imprescindible y siguiente misión.

## Contrato de respuesta
Cada comando debe distinguir:
- **HECHO VERIFICADO**
- **ESTIMACIÓN**
- **HIPÓTESIS**
- **RECOMENDACIÓN**

Y respetar:
- 0 € mientras sea posible.
- Ningún gasto, contratación o acción irreversible sin aprobación de Kael.
- No afirmar ejecución, automatización, autorización o verificación sin evidencia.
- Toda acción externa pasa por el Authority Engine.
- Toda operación asíncrona conserva el estado REQUESTED/RUNNING/VERIFYING hasta obtener verificación.
- Priorizar la siguiente acción que aumente evidencia, beneficio, automatización, escalabilidad o reduzca riesgo/coste.

## Mantenimiento automático
1. Añadir comandos cuando aparezca una necesidad repetida.
2. Eliminar/fusionar redundantes.
3. Mantener descripciones accionables.
4. No crear comandos por estética.
5. Registrar cambios reales en GitHub.

**Versión:** 1.3
**Última actualización:** 2026-10-05

# NEXIA — HISTORIA, EVOLUCIÓN Y ESTADO ACTUAL

Fecha: 2026-10-15
Estado: DOCUMENTO EXPLICATIVO / TRUTH-SAFE / HISTORIA RESUMIDA

## Qué es Nexia

Nexia no es una única aplicación ni un único negocio. Es un sistema de decisión y ejecución que hemos ido construyendo para investigar problemas reales, diseñar soluciones, probarlas, medir resultados, aprender de los fallos y acumular capacidades reutilizables. Su misión actual es convertirse en un sistema de primer nivel, continuamente mejorable, fiable, recuperable, verificable, adaptable y progresivamente autónomo, capaz de transformar problemas reales en resultados útiles y sostenibles.

El proyecto empezó de forma mucho más concreta. La primera implementación persistida fue Nexia Care, un MVP de diagnóstico para cafeteras De'Longhi Magnifica. El objetivo inicial era ayudar a una persona a describir un fallo, recibir una primera orientación y evitar compras innecesarias de piezas. Ese pequeño prototipo fue importante porque nos obligó a pasar de conversaciones e ideas a una pieza funcional, publicada y versionada.

A partir de ahí Nexia dejó de ser solo una herramienta concreta y empezó a convertirse en una arquitectura. Creamos un HQ o centro de mando, un registro persistente del estado, memoria de aprendizaje, ledger de experimentos, sistema de comandos, copias de recuperación y mecanismos para reanudar el trabajo entre conversaciones sin depender de la memoria temporal del chat. GitHub pasó a ser la fuente canónica de continuidad. También aparecieron el Authority Engine, los Human Gates, el Decision Log, TimeOS y reglas para distinguir qué puede ejecutar Nexia de forma autónoma, qué puede preparar y qué debe detenerse para aprobación humana.

## Aprender mediante experimentos reales

Nexia se diseñó desde el principio para no enamorarse de una sola idea. Probamos y analizamos distintas rutas económicas y operativas: diagnóstico y decision-commerce de Nexia Care, investigación de afiliación, reparación frente a sustitución de productos, experimentos alrededor de cafeteras De'Longhi, reventa/vintage y Vinted, oportunidades de automatización, plantillas y productos n8n, servicios freelance, Workana, Contra y una línea de contenido AI/UGC con herramientas generativas.

Algunas rutas se cerraron o perdieron prioridad. La arquitectura llegó a adaptarse temporalmente a una misión resale-first, con modelo de datos, intake, control de calidad, unit economics e inventario. Más adelante el proyecto adoptó una interpretación economy-first, en la que el beneficio sostenible se convirtió en la principal métrica de progreso. Esa etapa también fue útil, pero terminó mostrando una limitación: perseguir exclusivamente la proximidad al ingreso podía llevarnos a infravalorar fiabilidad, recuperación, evidencia, seguridad y capacidad acumulada.

La filosofía de Nexia evolucionó por tanto hacia algo más amplio. Los experimentos económicos siguen siendo críticos, pero funcionan como sensores de la realidad y no como única razón de existir.

## El salto técnico: automatización fiable

Uno de los avances más importantes fue EXP-AUTO-001. Empezó como una hipótesis comercial: una empresa que recibe leads puede valorar un sistema que valide, normalice, clasifique, deduplique y prepare información para revisión humana antes de realizar acciones sensibles.

Construimos primero una referencia en JavaScript/Node.js para procesar leads de forma determinista. La lógica incluía normalización, validación de campos obligatorios, idempotencia por evento, deduplicación por identidad, merge no destructivo, alertas de revisión manual, auditoría y manejo explícito de fallos. La primera suite de regresión detectó un supuesto inseguro en la normalización de teléfonos. En lugar de ocultar el error, se corrigió la lógica, se añadió un caso negativo y la suite revisada terminó con 9/9 pruebas superadas.

Después trasladamos y verificamos parte de la lógica en n8n 2.42.6. Ejecutamos seis casos sintéticos dentro de un runtime real de n8n manteniendo `autonomous_send=false`. Posteriormente construimos una prueba de deduplicación persistente usando Data Tables nativas de n8n. Se enviaron webhooks separados con eventos repetidos e identidades equivalentes; el sistema conservó solo los registros únicos esperados. El proceso de n8n se detuvo, se reinició con el mismo almacenamiento y la deduplicación siguió funcionando. Eso demostró persistencia en el entorno aislado de prueba, aunque no equivale a producción de cliente ni garantiza concurrencia a gran escala.

También construimos una capa de QA con GitHub Actions. Esa infraestructura permite importar y exportar workflows, ejecutar casos sintéticos, iniciar n8n, llamar webhooks, auditar Data Tables, reiniciar procesos y volver a comprobar el estado persistente. El objetivo es que una automatización no se considere correcta solo porque 'se ve bien' en el editor.

En paralelo exploramos n8n Creator como posible vía de distribución. Una primera plantilla fue rechazada por ser demasiado básica. Ese rechazo se conservó como evidencia negativa y provocó una mejora del estándar: cualquier activo reutilizable debía aportar profundidad real y no complejidad cosmética.

## Construcción de capacidad de ejecución

Otro frente importante fue reducir la dependencia de herramientas escasas o de ejecución manual. Nexia desarrolló rutas de ejecución cero-cuota y locales dentro de límites estrictos.

GitHub Actions quedó verificado como plano de ejecución automatizada. También se verificó generación de imagen local con ComfyUI + FLUX.2 Klein 4B FP8 y asistencia de código acotada con Ollama + Qwen2.5-Coder 7B Instruct. Se desarrolló un navegador local aislado, autenticado y de solo lectura mediante Chrome DevTools Protocol para inspeccionar Workana sin enviar propuestas ni modificar cuentas.

Posteriormente se construyó un puente de ejecución local: una tarea canónica en GitHub podía activar de forma acotada un script PowerShell, abrir la sesión local de navegador, producir un resultado saneado y devolverlo automáticamente por GitHub API. Se verificó una ejecución one-shot con Windows Task Scheduler y limpieza posterior. La autorización no se extendió a servicios persistentes, polling ni acciones externas.

Incluso se hizo una prueba formal de estabilidad de un worker durante 24 horas. Operativamente produjo 288/288 registros correctos y cero fallos funcionales, pero el experimento se declaró formalmente FAIL porque el máximo intervalo observado fue 10,001 minutos frente a un umbral predefinido de 10,000. Ese resultado resume bien la doctrina de Nexia: no cambiar el umbral después de ver el resultado y no convertir un fallo formal en éxito solo porque 'casi pasó'.

## Continuidad, evidencia y recuperación

Una parte central de Nexia ha sido aprender a no perder el trabajo. Se crearon NEXIA_BOOT.json, NEXIA_STATE.json, NEXIA_LIVE.json, índices de eventos, checkpoints y backups. También se probaron rutas de recuperación desde el propio repositorio. El HQ sufrió errores y llegó a ser restaurado después de una sobrescritura accidental; esos problemas impulsaron reglas más estrictas de read-back, verificación post-escritura, recuperación y separación entre persistencia y funcionamiento real.

Con el tiempo se consolidó una regla fundamental: un commit solo demuestra persistencia; no demuestra que algo funciona, que una automatización está operativa, que existe un cliente o que se ha generado ingreso. De la misma forma, una cuenta creada, un portfolio publicado o una aplicación enviada no equivalen a demanda, pago ni beneficio.

## Calidad, competencia y retrofit

Nexia empezó a compararse sistemáticamente con competidores y referentes top-tier. Se crearon estándares de calidad continua, dirección de arte, inteligencia competitiva y retrofit de activos existentes. La idea es que cada vez que elevamos un estándar importante, los activos ACTIVE o REUSABLE afectados deben revisarse, mejorarse y volver a verificarse.

Esto dio lugar al ciclo obligatorio de tareas materiales: VERIFY -> CRITIQUE -> COMPARE -> IMPROVE -> RE-VERIFY -> CAPTURE -> STOP RATIONALLY. El objetivo no es buscar una perfección infinita, sino llegar a READY_FOR_CURRENT_PURPOSE y mover la atención al siguiente cuello de botella cuando seguir puliendo aporta menos valor.

## La etapa actual: System Excellence + External Reality

El 15 de octubre activamos el modelo constitucional actual: SYSTEM EXCELLENCE + EXTERNAL REALITY. Este modelo sustituyó la interpretación economy-first sin borrar la historia anterior. La economía sigue siendo una validación, un recurso y un resultado crítico, pero Nexia ya no prioriza automáticamente lo que esté más cerca del ingreso.

Desde entonces Nexia trabaja con dos bucles. El System Loop observa, diseña, construye, verifica, estresa, recupera, instrumenta, mejora, estandariza y automatiza. El Reality Loop observa un problema real, formula una hipótesis, expone una capacidad mínima, mide la respuesta externa, aprende y actualiza el sistema. La excelencia interna evita crecimiento frágil; la realidad externa evita sobreoptimizar algo que nadie necesita.

El sistema también mantiene precedencia dura para seguridad, legalidad, privacidad, evidencia, autoridad humana y continuidad. Después prioriza dinámicamente según criticidad, dependencias, impacto, urgencia, aprendizaje, economía, coste, reversibilidad y riesgo.

## Contra y el Reality Loop comercial actual

El principal Reality Loop comercial activo es EXP-AUTO-001, actualmente presentado como `Lead Intake Reliability Sprint`. Contra se convirtió en la superficie primaria porque permite exponer de forma controlada una capacidad ya construida y medir reacción real de compradores.

Se preparó un microtest de cero gasto con un máximo de seis aplicaciones y una ventana de catorce días. Se construyó un portfolio basado en cuatro technical proofs complementarios: Lead Intake & Human Review, Persistent Deduplication, Fail-Safe Processing y Workflow QA & Regression. No se presentan como cuatro clientes distintos, sino como cuatro capas de una misma especialización.

El portfolio pasó por varias iteraciones de benchmark y QA visual. Las primeras imágenes introdujeron métricas o datos ficticios que podían confundirse con resultados reales; esas versiones fueron rechazadas. Se rediseñó el sistema con límites de verdad visibles, datos sintéticos etiquetados y una identidad visual unificada. El sistema visual V4 actual incluye portada Nexia, foto profesional y cuatro piezas coherentes. También se preparó un servicio flagship, una web/portfolio estática, un sistema de comunicación comercial y una estrategia de crecimiento orgánico basada prioritariamente en LinkedIn, Contra Community y posteriormente un Instagram profesional separado del Instagram personal.

## Qué es Nexia hoy

Hoy Nexia es simultáneamente una arquitectura de gobierno, una memoria persistente, un sistema de experimentación, una capa de automatización y QA, una disciplina de evidencia y un motor de aprendizaje.

Dispone de continuidad canónica en GitHub, Human Gates, Authority Engine, estándares de calidad, scorecards, radar de oportunidades, TimeOS, procesos de retrofit, capacidades locales acotadas, pruebas técnicas de automatización y un Reality Loop comercial activo.

Pero el sistema mantiene límites claros. No existe todavía evidencia de despliegue en producción de cliente, experiencia comercial de cliente verificada, beneficio neto ni un motor económico escalable demostrado. La facturación, cobros y beneficio reconciliado siguen en cero en el estado canónico actual. La fiabilidad, recuperación y observabilidad son parciales por subsistema, y la conformidad de todo el repositorio no está verificada elemento por elemento.

Eso no es un defecto que intentemos ocultar; es exactamente la frontera de verdad desde la que Nexia sigue avanzando.

## La idea central

Nexia nació como un pequeño diagnóstico para una cafetera y se ha convertido en un sistema que intenta responder a una pregunta mucho más ambiciosa: ¿cómo construir una máquina de decisión y ejecución que pueda enfrentarse a problemas reales, aprender de cada intento, conservar lo aprendido, elevar su propio estándar y generar resultados cada vez más útiles con menos dependencia humana innecesaria?

El trabajo realizado hasta ahora no consiste solo en código o automatizaciones. Consiste en haber construido una forma de operar: investigar, experimentar, fallar de manera visible, recuperar, comparar, medir, mejorar y volver a intentar sin perder el contexto ni falsificar los resultados.

Ese es el núcleo de Nexia.
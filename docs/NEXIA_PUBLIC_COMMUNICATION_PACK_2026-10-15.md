# NEXIA — PUBLIC COMMUNICATION PACK

Fecha: 2026-10-15
Estado: PREPARED_INTERNAL / TRUTH-SAFE / REUSABLE
Base: `docs/NEXIA_PROJECT_STORY_2026-10-15.md` + estado canónico actual.

## 1. Versión de una frase

Nexia es un sistema de decisión y ejecución que investiga problemas reales, construye y verifica soluciones, aprende de los fallos y acumula capacidades reutilizables para producir resultados cada vez más útiles, fiables y sostenibles.

## 2. Pitch de 30 segundos

Nexia empezó como una herramienta sencilla de diagnóstico y ha evolucionado hasta convertirse en un sistema operativo de experimentación, automatización, verificación y aprendizaje. Integra continuidad en GitHub, control de autoridad, pruebas automatizadas, recuperación, benchmarking competitivo y bucles de validación con el mundo real. La idea no es construir un único producto, sino una máquina capaz de investigar problemas, desarrollar soluciones, comprobarlas, aprender de la evidencia y reutilizar lo aprendido en proyectos posteriores.

## 3. Pitch de 2 minutos

Nexia es un proyecto que hemos construido para convertir ideas y problemas reales en soluciones verificables de forma cada vez más sistemática. Empezó con Nexia Care, un pequeño MVP de diagnóstico para cafeteras De'Longhi, pero muy pronto el foco cambió: en lugar de limitarnos a una sola aplicación, empezamos a construir la infraestructura que permitiera investigar, crear, probar, medir y mejorar muchos proyectos distintos.

A partir de ahí desarrollamos una arquitectura de continuidad con GitHub como fuente canónica, estados persistentes, eventos, checkpoints y recuperación. Añadimos un Authority Engine y Human Gates para separar trabajo autónomo seguro de acciones que requieren aprobación humana. Creamos sistemas de QA y automatización con GitHub Actions, Node.js y n8n, y verificamos capacidades como ejecución real de workflows, deduplicación persistente tras reinicio y regresiones automatizadas.

También investigamos rutas económicas y tecnológicas diferentes: Nexia Care, reventa, automatización empresarial, productos n8n, AI/UGC, Workana y Contra. Algunas vías se descartaron, otras se pausaron y otras aportaron capacidades reutilizables. Los fallos se conservan como evidencia en lugar de reescribirse.

Hoy Nexia opera bajo el modelo `System Excellence + External Reality`: mejorar el sistema internamente y, al mismo tiempo, exponer capacidades al mundo real para comprobar utilidad, competencia, aceptación y economía. El Reality Loop comercial principal actual es EXP-AUTO-001, centrado en automatización fiable de entrada de leads y calidad de datos.

## 4. Explicación para perfil profesional / posibles colaboradores

Nexia es una arquitectura de trabajo para investigación, automatización y mejora continua. Combina gobierno, persistencia, pruebas técnicas, experimentación comercial y aprendizaje acumulativo.

El sistema mantiene estado y continuidad en GitHub; diferencia preparación, ejecución y verificación; utiliza controles de autoridad para evitar acciones no autorizadas; y aplica un ciclo sistemático de calidad: verificar, criticar, comparar con referentes, mejorar, volver a verificar y registrar el resultado.

A nivel técnico hemos trabajado con JavaScript, Node.js, n8n, webhooks, Data Tables, GitHub Actions, Chrome DevTools Protocol, PowerShell, GitHub API, Windows Task Scheduler, Ollama, Qwen2.5-Coder, ComfyUI y modelos locales de generación de imagen. También hemos diseñado mecanismos de QA, recuperación, deduplicación, idempotencia, validación, observabilidad y revisión humana.

Nexia no se presenta como un sistema terminado ni como un agente plenamente autónomo 24/7. Su valor actual está en la combinación de capacidades ya verificadas, disciplina de evidencia y un proceso explícito para seguir elevando la fiabilidad y validar utilidad real.

## 5. Explicación técnica

Arquitectónicamente, Nexia separa varias capas:

- **Continuidad:** `NEXIA_BOOT.json`, `NEXIA_STATE.json`, `NEXIA_LIVE.json`, eventos, índices y checkpoints.
- **Gobierno:** Authority Engine, Human Gates, reglas GREEN/YELLOW/RED, control de gasto y acciones externas.
- **Calidad:** tests, GitHub Actions, regresiones, verificación post-escritura, benchmarking competitivo y retrofit de activos ACTIVE/REUSABLE.
- **Automatización:** Node.js, n8n, webhooks, Data Tables, PowerShell, Task Scheduler y rutas locales acotadas.
- **Ejecución local:** navegador autenticado de solo lectura mediante Chrome DevTools Protocol y un puente one-shot para devolver resultados saneados a GitHub.
- **IA local:** Qwen2.5-Coder mediante Ollama para asistencia acotada y FLUX.2 Klein mediante ComfyUI para generación de imagen.
- **Reality Loop:** experimentos comerciales y de mercado con métricas diferenciadas entre señal, intención, aceptación, pago y beneficio.

En EXP-AUTO-001 se verificó lógica de procesamiento de leads, 9/9 regresiones sintéticas después de corregir una normalización de teléfono, ejecución real en n8n 2.42.6 y deduplicación persistente mediante Data Tables a través de reinicio del proceso. No existe todavía despliegue de cliente en producción.

## 6. Qué hemos demostrado

HECHO VERIFICADO:

- continuidad y recuperación basadas en GitHub;
- estado canónico y trazabilidad de eventos;
- reglas explícitas de autoridad y aprobación humana;
- ejecución y pruebas automatizadas con GitHub Actions;
- lógica de automatización en JavaScript/Node.js;
- ejecución sintética real en n8n 2.42.6;
- deduplicación persistente con Data Tables a través de reinicio del proceso;
- regresión Node 9/9 tras corregir un fallo real;
- navegador local autenticado de solo lectura para Workana;
- puente local one-shot con retorno saneado a GitHub;
- prueba formal de estabilidad de 24 horas con 288/288 registros funcionales, aunque formalmente FAIL por superar el umbral temporal preregistrado en aproximadamente 0,06 s;
- generación local de imagen y asistencia de código acotada;
- sistemas de benchmark, retrofit y QA comercial/visual;
- portfolio, posicionamiento y materiales comerciales para EXP-AUTO-001.

## 7. Qué NO hemos demostrado

HECHO VERIFICADO / LÍMITE DE VERDAD:

- no hay despliegue EXP-AUTO-001 verificado en producción de cliente;
- no hay experiencia de cliente en producción verificada;
- no hay todavía un piloto pagado aceptado y reconciliado;
- ingresos liquidados y beneficio reconciliado actuales: EUR 0;
- no existe un worker persistente 24/7 autorizado y verificado;
- no está verificada la conformidad elemento por elemento de todo el repositorio;
- fiabilidad, recuperación y observabilidad siguen siendo parciales según subsistema;
- portfolio, perfil, visuales o demostraciones técnicas no equivalen a demanda, cliente, venta o beneficio.

## 8. Herramientas y tecnologías utilizadas

### Desarrollo y automatización
- GitHub / GitHub API
- GitHub Actions
- JavaScript
- Node.js
- n8n 2.42.6
- Webhooks
- n8n Data Tables
- HTML/CSS/JavaScript para prototipos y portfolio

### Ejecución local y operaciones
- PowerShell
- Windows Task Scheduler
- Chrome / Chrome DevTools Protocol
- GitHub CLI
- scripts locales y runners acotados

### IA y generación
- ChatGPT como superficie de razonamiento/orquestación
- Ollama
- Qwen2.5-Coder 7B Instruct
- ComfyUI
- FLUX.2 Klein 4B FP8
- herramientas generativas externas investigadas, incluyendo Higgsfield

### Investigación, mercado y distribución
- Contra
- Workana
- benchmarking de competidores y perfiles top-tier
- investigación web y documentación de mercado

## 9. Qué diferencia a Nexia

Nexia no está diseñado para maximizar actividad, sino aprendizaje verificable y capacidad acumulada. Sus principios centrales son:

1. distinguir hechos de hipótesis;
2. conservar los fallos y no reescribir resultados;
3. verificar después de ejecutar;
4. comparar con referencias externas;
5. automatizar solo procesos suficientemente entendidos y observables;
6. mantener control humano en acciones sensibles;
7. reutilizar lo aprendido entre proyectos;
8. evitar que una única oportunidad económica capture todo el sistema;
9. detener el perfeccionismo cuando el siguiente cuello de botella tiene mayor valor;
10. mejorar simultáneamente el sistema y su contacto con la realidad.

## 10. Situación actual

Nexia está actualmente en una fase de `SYSTEM EXCELLENCE + EXTERNAL REALITY`.

El núcleo de gobierno, continuidad, evidencia y varios subsistemas técnicos está construido y parcialmente verificado. El retrofit de calidad continúa para activos ACTIVE y REUSABLE. EXP-AUTO-001 es el Reality Loop comercial principal y se está preparando para obtener evidencia externa real mediante Contra y otros canales, sin confundir portfolio o actividad con validación comercial.

La siguiente gran transición no consiste en añadir más documentación interna, sino en conectar las capacidades construidas con compradores y problemas reales, medir la respuesta y utilizar esa evidencia para actualizar el sistema.

## 11. Mensaje final reutilizable

Nexia no es un producto terminado; es una infraestructura de aprendizaje y ejecución en evolución. Lo que hemos construido hasta ahora demuestra capacidad técnica, continuidad, disciplina de verificación y una arquitectura para experimentar sin perder lo aprendido. El siguiente nivel de validación depende de convertir esas capacidades en resultados reales de usuario y cliente, medirlos y dejar que la evidencia determine qué debe crecer, cambiar o desaparecer.

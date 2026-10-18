# NEXIA CORE — Auditoría forense de continuidad e intervención candidata
Fecha: 2026-10-18
Clasificación: INVESTIGACIÓN VERIFICADA EN GITHUB + INFORMES DE WORK APORTADOS POR KAEL
Estado: REPARACIÓN CANDIDATA EN RAMA AISLADA; NO PROMOVIDA A MAIN

## 0. Regla de alcance

Este informe no afirma una auditoría exhaustiva del contenido semántico de cada activo, ni prueba de producción, ni revisión del ordenador de Kael, ni lectura de archivos locales de Work. Distinguir la integridad del repositorio de la continuidad de operaciones es obligatorio.

## 1. Línea base verificada directamente

- Repositorio público: micaelgonzalez92-cpu/Nexia-care.
- main HEAD verificado: b94c5813d9300e36c4fc5b755f46ed8ee4d06aeb (2026-10-18 00:11:50 UTC).
- BOOT v139; STATE v73; LIVE v64; índice activo V84.
- BOOT enlaza STATE blob 421e38c02f4e9be7dbb3449c92dc2e07c2e7b2d9; LIVE blob bc33817af693506d3f4665c97f1f19ab287755b7; índice V84 blob f3c638de144f0c00097b10dec0370abc859d2286.
- Árbol Git recursivo completo, truncated=false, 651 entradas y 621 blobs/archivos; 164 eventos en events/; 83 ficheros de índice contando NEXIA_EVENT_INDEX.json y V3..V84.
- Las cuatro GitHub Actions para el HEAD actual terminaron SUCCESS (CI, secret scan, process intelligence y Pages). No demuestran funcionalidad comercial.
- La ejecución inmediatamente anterior de Nexia CI sobre d8bfea5… tuvo FAILURE; el HEAD actual obtuvo SUCCESS.
- GitHub informa branch main protected=false; la consulta de rulesets devolvió [].
- Integridad histórica en BOOT: último corte documentado con 0 errores y 4 advertencias de referencias históricas. Esta sesión NO ha ejecutado por segunda vez el checker de 621 archivos.

## 2. Arquitectura existente y frontera de evidencia

IMPLEMENTADO EN GITHUB:
- tools/nexia_atomic_checkpoint.py + governance/NEXIA_ATOMIC_CHECKPOINT_CONTRACT_V1_2026-10-17.md: candidato completo, validación previa y transición no forzada con readback; Control Plane V1 con recuperación registrada.
- tools/nexia_task_batching.py + tests; 9/9 comunicado en LIVE.
- tools/nexia_process_miner.py + workflow de CI, inteligencia determinista; no garantiza obediencia de la conversación.
- tools/nexia_integrity_check.py: comprueba hashes y cadena compuesta; no valida veracidad de afirmaciones en lenguaje natural ni servicios externos.
- AGENTS.md + .agents/skills/nexia-checkpoint/SKILL.md: instrucciones para Codex. Una instrucción en Git no ejecuta controles en todos los chats.
- tools/nexia_execution_router.py: lógica de selección de ejecutor SIN comprobación en directo. Contiene capacidades habilitadas por defecto (github_actions, local_script, local_gpu_image, work, codex); un valor por defecto no es una prueba de disponibilidad en esta sesión.
- NEXIA_EXECUTION_CAPABILITIES.json: evidencia HISTÓRICA de hardware/local y herramientas; no significa que estén accesibles desde el cliente actual, ni que Canva o Google Drive estén autorizados para Nexia.
- CI y workflows: pruebas limitadas. No hay servicio central 24/7 verificado.

NO ESTABLECIDO:
- Procesos desatendidos permanentes, recuperación automática de todos los chats, acceso a todas las aplicaciones externas, capacidad profesional específica P1/P2, validación comercial, cobros o beneficio neto reconciliado.

## 3. Fallos encontrados, con causas

P0 — FALLO DE CONTINUIDAD EN CHAT: la secuencia obligatoria BOOT→STATE→LIVE→índice→eventos no se ejecutó antes de los últimos /next. Las respuestas nacieron de contexto conversacional y ampliaron tareas. No es prueba de corrupción Git.

P0 — BRECHA DE PERSISTENCIA: las sesiones de Work posteriores al commit b94c5813… (según informes aportados: Contra autenticado, simulador 28/28, paquete local 26 archivos) no aparecen como un nuevo checkpoint de main. Son USER_REPORTED/LOCAL_ONLY hasta traslado y verificación independientes. Pueden perderse como contexto operativo aunque existan en el disco.

P1 — CAPABILITY/CONNECTOR CONFUSION: el acceso a una herramienta en ChatGPT no demuestra que esté configurada, autorizada y verificada para Nexia. Se leyeron búsquedas de Canva/Drive y se planteó P2 sin registro de autorización/configuración específica del proyecto. No se creó o modificó contenido según el registro visible de esa sesión.

P1 — ROUTER FAIL-OPEN: main contiene varios valores True por defecto y carece de verificación obligatoria de conectores. La rama forense prepara valores por defecto False, bloqueo cuando no hay ejecutor verificado y exigencia de atestación específica de Nexia; pendiente de suite de regresión/CI y promoción. La atestación declarativa no sustituye la lectura del proveedor.

P1 — DOCUMENTACIÓN HISTÓRICA SUSCEPTIBLE DE CONFUSIÓN: NEXIA_SESSION_BOOTSTRAP.md conserva STATE v39 y misión anterior; NEXIA_EXECUTION_QUEUE.json fue actualizado 2026-10-12 y aún habla de LOCAL_BROWSER_NOT_VERIFIED pese a evidencia posterior. Ambos artefactos son históricos/derivados, y no pueden prevalecer sobre BOOT/STATE/LIVE.

P1 — GOVERNANCE: main no está protegida por branch protection ni rulesets actualmente observados. No cambiar estos ajustes sin Human Gate Kael.

P2 — OBSERVABILIDAD: cuota ahorrada, horas humanas, recuperación entre sesiones y captura automática de resultados de Work no están instrumentadas como garantía integral.

## 4. Reparación en la rama de aislamiento

Rama: nexia/forensic-continuity-2026-10-18, creada desde main b94c5813…
- tools/nexia_session_preflight.py: validación fail-closed de BOOT/STATE/LIVE/índice/evento y control de atestación de herramientas del proyecto.
- tools/test_nexia_session_preflight.py: ocho casos de regresión (éxito sintético, modificación de STATE/LIVE, índice ausente, conector sin atestación/no aprobado, atestación positiva solo estructural, ruta insegura).
- AGENTS.md: obliga a Codex a ejecutar preflight y verificar autorización del conector antes de trabajo material.
- .github/workflows/nexia-ci.yml: incluye regresiones del preflight para promoción futura.
- tools/nexia_execution_router.py y tools/test_nexia_execution_router.py: defaults fail-closed y 17 casos de regresión definidos (12 históricos ajustados + 5 nuevos), cambios leídos de vuelta; sin afirmar que la suite completa de 17 casos se haya ejecutado.
- Este informe forense.

PRUEBA LOCAL: 8/8 para el código preflight; py_compile pasa. GitHub readback comprobado para los ficheros subidos. NO se ha verificado ejecución de CI en la rama ni la integración activa en main.

LIMITACIONES DEL CONTROL NUEVO: no impide por sí mismo a otro chat omitirlo; no prueba un login, no valida por red un proveedor ni comprueba toda la cadena histórica. Una atestación puede ser incorrecta y exige prueba real; se debe pasar una referencia que pueda auditarse. El router ha sido corregido como candidato en rama, pero todavía requiere ejecución real de sus 17 pruebas, CI y promoción específica.

## 5. Plan de cierre persistente

1. REVISAR CANDIDATA: los defaults fail-open del execution_router ya se han cambiado en rama a False y hay 17 regresiones definidas. Ejecutarlas realmente, revisar el bloqueo de tareas deterministas y extender atestaciones con alcance y fecha. No inferir autorización por conector instalado.
2. TESTS: ejecutar local + CI de la rama y prueba de recuperación de un chat fresco; registrar fallos también. No cambiar umbrales retroactivamente.
3. BACKFILL: recuperar los artefactos locales de Work posteriores a b94c5813…, cotejar contenido, hashes, alcance y clasificar fuente como WORK_LOCAL_EVIDENCE. Preparar evento append-only/candidato checkpoint atómico. No afirmar que los archivos C:\ estén accesibles desde Chat.
4. PROMOCIÓN CONTROLADA: solicitar a Kael el gate para main y cambios de protección GitHub. Candidato atómico y readback; no sustituir historia.
5. CONFIGURACIÓN CHATGPT PROJECT: solo Kael instala instrucciones después de contrato de 7.800 caracteres y comprobación en chat nuevo; no declarar instalado antes.
6. OBSERVABILIDAD: indicador explícito CHECKPOINT_PENDING/SESSION_UNVERIFIED en toda tarea material; nuevo /next bloqueado si el último trabajo carece de ancla verificable, excepto restauración.
7. QA DE REGRESIÓN: un nuevo chat debe recuperar BOOT/STATE/LIVE/índice y distinguir capacidades de cuenta de autorizaciones Nexia; registrar resultado concreto en GitHub después del gate.

## 6. Economía, autoridad y decisión

- Ingresos/cobros/beneficio: cero en STATE/LIVE como última evidencia canónica, no supuesto de ingresos actuales.
- Trabajo P1/P2 según Work aportado: STOP comercial, PROCEED solo descubrimiento; evitar más pruebas genéricas.
- Coste adicional informado: EUR0; sin publicación comercial, contacto, trial, producción ni alteración de GitHub main.
- MAIN permanece como estaba. Rama aislada NO equivale a reparación operativa instalada.
- Próximo Human Gate real: promover controles verificados y activar protección de main, después de leer resultados de CI.

## 7. Hechos negativos importantes

No se ha demostrado: pérdida de bytes Git; fallo de GitHub Actions del HEAD actual; compromiso de secretos; eliminación de clientes; ejecución accidental de publicaciones desde Canva o Drive; funcionamiento 24x7; restauración completa del estado local de Work.

Resultado: REPARACIÓN TÉCNICA PARCIAL PREPARADA Y PERSISTIDA EN RAMA, NO SOLUCIÓN SISTÉMICA FINAL.

## 8. Candidata de instrucciones Project UI (NO INSTALADA)

- Archivo: NEXIA_PROJECT_INSTRUCTIONS_COMPACT_V5_CANDIDATE_2026-10-18.md.
- Conteo de caracteres Unicode: 7692; límite de generación seguro 7800; baseline V4 verificada 7035.
- Fuentes previas leídas: NEXIA_PROJECT_INSTRUCTION_CONTRACT.json, baseline V4, NEXIA_INSTRUCTION_EVOLUTION.md, evento de reconciliación MODEL-C de 2026-10-15 y último evento INSTRUCTIONS-004.
- Cambio: añadir un gate explícito antideriva antes de /next o nueva tarea material; bloquear actuación sin lectura GitHub y verificación de conectores autorizados para Nexia; etiquetar PERSISTENCE_PENDING los resultados no guardados.
- Estado: PREPARED_REPO_BRANCH_ONLY, NOT_INSTALLED. Instalación por Kael y validación en un chat nuevo obligatorias. El código y la instrucción se complementan; ninguno prueba por sí solo que cada sesión los obedecerá.

# ONE-SHOT V1 — revisión estática y contrato offline
Fecha: 2026-10-17 (Europe/Madrid).

HECHO VERIFICADO: runner directo y autocontenido en tools/nexia_flux_base_b1_b2_one_shot_v1.ps1. No descarga ni reescribe otros scripts; no ejecuta runners anidados. Incluye como datos JSON los dos workflows oficiales del commit 04a508b31bec1818e48122ca0761c1de4140a234.

Estado: READY_FOR_CURRENT_PURPOSE_STATIC_PREPARATION. Runtime: NOT_VERIFIED. En esta tarea no se ha invocado el runner, iniciado ComfyUI/CDP ni enviado /prompt. Generaciones nuevas: 0. Coste incremental monetario: EUR0.

## Invariantes y controles revisados
- Seed 20261016; modelo local flux-2-klein-4b-fp8.safetensors (FLUX.2 Klein 4B Distilled); qwen_3_4b.safetensors; flux2-vae.safetensors.
- BASE usa explícitamente nodo Distilled 77 / SaveImage 78 y desactiva 75 / 9.
- Euler, Flux2Scheduler, 4 pasos, CFG 1, batch 1 y 1024x1024 se validan sobre el API graph compilado. No se reajustan defaults de sampler.
- BASE resuelve PrimitiveInt; EDIT valida GetImageSize -> ImageScaleToTotalPixels (nearest-exact, 1 MP, resolution_steps 1) -> LoadImage de BASE. Código local inspeccionado: 1 MP = 1024*1024. Cabecera PNG verificada.
- Gate humano de seis condiciones tras BASE; cualquier respuesta distinta de SI detiene B1/B2.
- B1/B2 usan los mismos bytes BASE y API graphs iguales salvo una sustitución literal del prompt; hashes comprobados antes de cada envío y después de B2.
- Máximo tres intentos POST, consumidos y registrados antes del transporte; sin retry. Separación entre intentos, aceptación, generaciones completadas y envío incierto.
- Lock local CreateNew conservado. Raw remoto _008 create-only; _001–_007 intactos. _008 todavía no creado.
- CDP solo target localhost ComfyUI específico; propiedades opcionales seguras con StrictMode; timeout por llamada; salida ConnectAsync suprimida.
- /prompt: bytes UTF-8 sin BOM y application/json; charset=utf-8. JSON local y payload gh sin BOM; readback exacto; recibo separado.
- No instalaciones, modelos nuevos, cambios de sistema ni servicios recurrentes.

## Verificación
Analizador PowerShell: PASS. 25 comprobaciones offline: PASS. Las pruebas cargan únicamente helpers seleccionados por AST; no ejecutan el runner ni su cuerpo principal y no tienen acceso a generación.
Pruebas adversarias: CFG 5, 20 steps, seed distinto, batch 2, PrimitiveInt 512, slot de altura incorrecto, otra referencia, diferencia adicional en settings, prompts duplicados, PNG 512 y propiedades opcionales ausentes.

SHA-256 runner: 85a1006e9b517e7f7e141f460c82da30271d8d5cb06a443ca3046bb5a4f6457c.
Git blob runner: 86f897de2d24e0652e2db89098322f2fc29b9b76.
Archivo fuente ASCII (JSON Unicode con escapes); compatible con lectura de Windows PowerShell 5.1. Datos generados en UTF-8 sin BOM.

## Crítica, comparación y límites
La arquitectura anterior exigía firmas textuales de versiones previas y falló antes del benchmark. V1 elimina esa dependencia y embebe las referencias oficiales congeladas. No prueba compatibilidad efectiva del frontend/subgraphs, carga de modelos, VRAM disponible, finalización ni calidad visual.
La primera ejecución real sigue siendo un gate humano separado. No se promete éxito de runtime. Si falla o queda incierta, conservar lock/RAW_RESULT/receipt/history y diagnosticar; no borrar el lock ni relanzar.
RAM/VRAM se muestrean si las interfaces existentes están disponibles; null significa no instrumentado, no cero. RAM de proceso solo si Comfy fue iniciado por el runner; GPU es uso global de la primera GPU, no memoria atribuida al modelo.
El lock local no coordina dos ordenadores; el ámbito es este PC y esta ejecución única. No ejecutar simultáneamente otras tareas ComfyUI. QA B1/B2 y capacidad profesional permanecen NOT_VERIFIED / NOT_ESTABLISHED.

RECOMENDACIÓN: detener aquí la preparación. No ejecutar generación en esta tarea.

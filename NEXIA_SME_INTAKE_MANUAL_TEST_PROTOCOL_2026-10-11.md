# NEXIA — Protocolo manual de prueba del harness SME Intake

Fecha: 2026-10-11  
Estado: PREPARADO; NO EJECUTADO  
Coste: 0 €  
Alcance: prueba local con datos sintéticos; no contactar clientes, no enviar datos, no crear cuentas ni publicar.

## Objetivo y límites

Comprobar el funcionamiento visible del archivo `prototypes/sme-intake-test-harness.html` y registrar evidencia reproducible. El test sintético no demuestra demanda, disposición a pagar, ahorro en un negocio real, ni beneficio. El código se ha inspeccionado estáticamente; no se ha ejecutado en navegador en esta sesión.

## Preparación

1. Descargar el archivo HTML desde el repositorio Nexia Core o abrir el archivo en un navegador local.
2. Desconectar cualquier expectativa de integración: el harness no debe enviar ni guardar información. Usar únicamente los ocho casos sintéticos incluidos.
3. Anotar navegador, sistema operativo, fecha y si se abrió como archivo local.
4. No introducir datos reales de clientes.

## Prueba A — Clasificación sintética

1. Pulsar **Ejecutar 8 casos**.
2. Confirmar que aparecen ocho filas, sin errores de JavaScript visibles.
3. Comparar el resultado de cada fila con el esperado:
   - T01 → urgent
   - T02 → quote
   - T03 → info
   - T04 → clarify
   - T05 → human_review
   - T06 → human_review
   - T07 → clarify
   - T08 → out_of_scope
4. Registrar el total PASS/8 y cualquier desviación. Umbral: 8/8 esperados y cero fallos críticos. Si falla cualquier caso, conservar la evidencia y no declarar aprobado.

## Prueba B — Cronómetro y mediciones volátiles

1. Para cada caso T01–T08, elegir modo Manual, pulsar Iniciar, realizar una lectura manual simulada de la tarea y pulsar Detener y registrar.
2. Repetir para el mismo caso en modo Asistido + revisión, incluyendo tiempo de revisión y correcciones; no detener el reloj antes de terminar el trabajo.
3. Repetir cada pareja al menos tres veces alternando el orden Manual/Asistido para reducir sesgo de orden.
4. Confirmar que cada registro muestra caso, modo y segundos; comprobar Reiniciar.
5. Copiar las mediciones manualmente a una hoja de cálculo o a estas notas antes de cerrar la pestaña. El propio harness no conserva ni exporta los datos: cerrar la página puede perderlos.

## Hoja de captura

| Campo | Registrar |
|---|---|
| Entorno | Navegador y versión / sistema operativo |
| Clasificación | PASS/8 o FAIL; incluir IDs fallidos |
| Caso y repetición | T01–T08; repetición 1–3+ |
| Tiempo manual | Segundos, incluida lectura y correcciones |
| Tiempo asistido | Segundos, incluida revisión y correcciones |
| Calidad | Error material sí/no; descripción |
| Seguridad | Promesa no verificada, dato inventado o derivación incorrecta sí/no |
| Evidencia | Captura de pantalla opcional, sin datos personales |
| Limitaciones | Interrupciones, mediciones incompletas, problemas del navegador |

## Umbrales predefinidos

- Clasificación sintética: 8/8 resultados correctos.
- Seguridad: cero fallos críticos.
- Calidad: sin degradación material frente al proceso manual.
- Tiempo: reducción mediana de al menos 20%, calculada sobre pares comparables e incluyendo revisión/correcciones.

Si no hay suficientes pares comparables o el proceso asistido requiere más revisión, el resultado es INCONCLUSO/FRACASO según la causa; no cambiar umbrales después de observar resultados. Incluso si pasa, solo habilita una prueba de flujo sintético más rigurosa, no una afirmación comercial.

## Protocolo de decisión

- PASS sintético + tiempos medidos: considerar una prueba supervisada con datos ficticios y una revisión independiente.
- Fallo crítico o salida inventada: detener el avance y corregir antes de cualquier prueba externa.
- Sin ejecución real del navegador: estado BLOQUEADO POR INSTRUMENTACIÓN; no inferir que el HTML funciona.
- Prueba con cliente, publicación o contacto comercial: requiere autorización explícita de Kael sobre acción, alcance y exposición.

## Sensibilidad económica (estimación, no previsión)

Hipótesis para comparar únicamente la sensibilidad al tiempo: precio neto de IVA, €15/h de trabajo humano, €5 de herramientas variables por pedido y un proxy fiscal del 25% aplicado a contribución positiva. Excluye costes fijos, devoluciones, impagos, IVA real, variación fiscal y soporte imprevisto.

| Precio hipotético | Horas totales por pedido | Contribución antes de proxy fiscal | Después del proxy | Pedidos/mes para llegar a €1.000 |
|---:|---:|---:|---:|---:|
| €149 | 4 h | €84,00 | €63,00 | 16 |
| €149 | 5 h | €69,00 | €51,75 | 20 |
| €149 | 6 h | €54,00 | €40,50 | 25 |
| €149 | 8 h | €24,00 | €18,00 | 56 |
| €89 | 3 h | €39,00 | €29,25 | 35 |

La sensibilidad muestra que la economía se deteriora rápidamente si adquisición, entrega y soporte exceden las horas previstas. Antes de elegir esta oferta hay que medir tiempos reales y obtener evidencia de intención de compra; las cifras no son ingresos, cotizaciones ni beneficios observados.

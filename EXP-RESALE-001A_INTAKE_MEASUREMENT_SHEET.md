# EXP-RESALE-001A — Hoja de recepción y medición del piloto

Estado: PREPARADA / SIN INVENTARIO RECIBIDO
Coste de esta hoja: 0 €
Regla: no registrar compra, venta, coste real ni beneficio sin evidencia observable. La compra del lote por 61,30 € entregado sigue pendiente de pago de Kael.

## 1. Resumen del lote

- Experimento: EXP-RESALE-001A
- Lote previsto: 10 camisetas de marca
- Coste total entregado previsto: 61,30 € (checkout verificado; compra no ejecutada)
- Coste unitario previsto si se compra: 6,13 €
- Unidades recibidas: UNKNOWN / NOT RECEIVED
- Unidades vendibles: UNKNOWN / NOT INSPECTED
- Ingreso liquidado: 0 € registrado hasta ahora; no implica ventas futuras
- Beneficio neto: UNKNOWN / NOT REALIZED

## 2. Registro por prenda

Completar una fila por artículo cuando se reciba físicamente. No inventar valores.

| Campo | Qué registrar |
|---|---|
| SKU / ID | Identificador único (p. ej. VDO-VWN-001) |
| Fecha de recepción | Fecha real de recepción |
| Marca / modelo | Según etiqueta y evidencia disponible |
| Talla | Etiqueta y, si procede, medidas reales |
| Color / patrón | Descripción objetiva |
| Estado | Defectos, desgaste, manchas, olores, daños |
| Autenticidad / confianza | Evidencia disponible; incertidumbres explícitas |
| Fotos | Referencias a fotos de etiquetas, frontal, espalda y defectos |
| Vendible | Sí / No / Pendiente de revisión |
| Motivo no vendible | Si aplica |
| Minutos de preparación | Tiempo humano medido |
| Coste laboral | Minutos ÷ 60 × tarifa €/h explícita |
| Fecha de anuncio | Fecha real de publicación |
| Precio anunciado | Precio realmente publicado |
| Fecha de venta | Fecha real de venta, si existe |
| Precio realizado | Importe efectivamente acordado/realizado |
| Estado del cobro | Pendiente / Liquidado / Reembolsado |
| Comisión | Comisión real de plataforma/pago |
| Envío pagado por vendedor | Coste real asumido por vendedor |
| Embalaje | Coste real atribuible |
| Descuento / devolución | Importe y motivo real |
| Coste de producto asignado | Coste de adquisición asignado según regla contable definida |
| Contribución | Precio realizado − costes variables atribuibles |
| Evidencia | Enlaces/ID de recibos, liquidaciones, anuncios y mensajes relevantes |

## 3. Reglas de cálculo

- No usar el precio anunciado como ingreso: solo cuenta el precio realmente realizado.
- No considerar una venta como cobro liquidado hasta comprobar el abono.
- Separar contribución por artículo de beneficio neto del negocio.
- Incluir costes de entrada, comisiones, envío asumido, embalaje, devoluciones, defectos y tiempo humano con tarifa explícita.
- Si una cifra no está disponible, marcar UNKNOWN / NOT INSTRUMENTED.
- No atribuir beneficio neto sostenible a una única venta.
- No cambiar umbrales del experimento sin autorización explícita de Kael.

## 4. Métricas de cierre

- Porcentaje vendible = unidades vendibles ÷ unidades recibidas.
- Precio medio realizado = suma de precios realizados ÷ unidades vendidas.
- Contribución por unidad vendida y por unidad comprada.
- Tiempo humano total y por artículo.
- Días hasta la primera venta y rotación por periodo.
- Devoluciones/defectos y coste asociado.
- Caja pagada y cobros efectivamente liquidados.
- Beneficio neto después de impuestos: solo cuando costes, periodo e impuestos estén reconciliados.

## 5. Gate y estado actual

- Compra: PENDING_KAEL_PAYMENT.
- No comprar ni publicar anuncios como si existiera inventario antes de recibirlo y comprobarlo.
- Los umbrales originales del piloto no se modifican en esta hoja.
- Próximo paso tras la compra aprobada y efectuada: recepción, fotografías, inspección, medición del tiempo y registro por SKU.

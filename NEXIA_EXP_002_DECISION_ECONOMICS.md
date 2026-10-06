# EXP-002 — Decision Economics v1

## Estado
- Estado: QA FUNCIONAL COMPLETADO
- Coste: 0 €
- Experimento activo principal no cambia: EXP-001B
- Alcance: NEXIA Care / flujo de diagnóstico
- Fecha: 2026-10-06

## Hipótesis
Una capa de decisión económica contextualizada puede aumentar la proporción de diagnósticos que terminan en una siguiente acción útil, evitando compras prematuras y manteniendo abiertas varias vías de monetización.

## Acción
NEXIA Care clasifica el resultado en una de estas rutas:
1. Mantenimiento → reevaluar
2. Diagnóstico → servicio / reparación
3. Reparar primero → servicio si persiste
4. Diagnóstico → reparar / comparar
5. Diagnóstico primero → comparar

La interfaz no inventa precios ni recomienda una pieza cuando la causa es incierta.

## Métrica
Porcentaje de rutas de diagnóstico que terminan en una acción económica clara y segura.

## Éxito
>=80% de las rutas probadas producen una siguiente acción comprensible sin compra prematura ni precio inventado.

## Resultado QA — HECHO VERIFICADO
Browser-QA terminal completado mediante el run existente, sin lanzar un segundo run:
- Run ID: ec697659-b3ff-423c-b682-d6c4bd00a3b7
- Rutas probadas: 2
- Rutas con diagnóstico completo: 2/2
- Rutas con decisión económica clara y segura: 2/2 = 100%
- Errores visibles: 0
- Ruta 1: “No sale café” → REPARAR PRIMERO → SERVICIO SI PERSISTE
- Ruta 2: “Fuga de agua” → DIAGNÓSTICO → SERVICIO / REPARACIÓN
- En ambas rutas se evitó recomendar compra de piezas mientras la causa era incierta.

## Fracaso
- recomendación económica ambigua;
- compra sugerida sin causa suficientemente identificada;
- ruta que no permite decidir el siguiente paso;
- error funcional visible.

## Riesgo
Bajo: cambio reversible, sin gasto, sin contacto externo y sin compromiso comercial.

## Información obtenida
- La capa económica cambia de ruta según el síntoma en lugar de aplicar una monetización única.
- Las comprobaciones de bajo coste se priorizan antes de una compra.
- La decisión “Repair/Service” queda separada del diagnóstico inicial.
- El flujo es funcionalmente coherente en las dos rutas probadas.

## Limitación de evidencia
El resultado 100% corresponde a una muestra de 2 rutas, no a todos los síntomas del producto ni a usuarios reales. Por tanto, EXP-002 queda funcionalmente validado para estas rutas, pero no constituye evidencia de conversión, utilidad con usuarios reales ni rentabilidad.

## Siguiente acción
Mantener EXP-001B como experimento principal y buscar evidencia de usuario real. En paralelo, continuar la matriz Repair/Replace sin gasto y sin repetir investigación pública de afiliación salvo que aparezca nueva evidencia.

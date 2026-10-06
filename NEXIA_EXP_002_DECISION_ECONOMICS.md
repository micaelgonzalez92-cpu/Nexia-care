# EXP-002 — Decision Economics v1

## Estado
- Estado: IMPLEMENTADO, PENDIENTE DE QA
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

## Fracaso
- recomendación económica ambigua;
- compra sugerida sin causa suficientemente identificada;
- ruta que no permite decidir el siguiente paso;
- error funcional visible.

## Riesgo
Bajo: cambio reversible, sin gasto, sin contacto externo y sin compromiso comercial.

## Información buscada
- qué síntomas pueden pasar directamente a mantenimiento;
- cuáles requieren diagnóstico técnico;
- cuáles justifican comparar reparación frente a reacondicionado/sustitución;
- dónde hace falta más evidencia antes de monetizar.

## Estado de evidencia
La implementación existe en GitHub. La validación funcional depende del browser-QA ya abierto. No se declara éxito hasta disponer de resultado terminal verificable.

# EXP-001B — Matriz de evidencia diagnóstica

Fecha: 2026-10-05

## Objetivo

Convertir síntomas reales de Magnifica S en pruebas observables y seguras antes de recomendar acciones. No se considera una solución validada hasta que un usuario real la ejecuta y se observa un resultado.

## Caso prioritario actual

**Síntoma:** ECAM22.110.B que pasó a moler aproximadamente 30–40 % menos café, producir café muy débil y posos irregulares.

**Evidencia:** reporte público de un usuario publicado el 13/08/2026. El usuario indica además que el servicio técnico no encontró el problema y que ya había limpiado la máquina.

**Qué demuestra:** existe un problema real, concreto, reciente y potencialmente reproducible.

**Qué NO demuestra:** causa, solución, tasa de éxito de Nexia Care ni disposición a pagar.

## Matriz inicial

| Síntoma observable | Dato mínimo | Acción inicial admisible | Resultado a registrar | Riesgo |
|---|---|---|---|---|
| Café débil / poco cremoso | modelo + intensidad + comportamiento del café | comprobar ajuste de molienda según instrucciones oficiales, un clic cada vez y evaluar tras 2 cafés | mejora / igual / peor | bajo si se sigue el manual |
| Café demasiado lento / gota a gota | modelo + velocidad de salida | comprobar si la molienda está demasiado fina y ajustar según instrucciones oficiales | flujo mejora / igual / peor | bajo |
| Molienda aparentemente corta | modelo + tiempo aproximado de molienda + intensidad + aspecto del poso | medir antes de tocar ajustes; después probar solo una variable | tiempo/poso antes y después | bajo |
| Posos irregulares | foto opcional + descripción + consistencia | no asumir causa; correlacionar con cantidad molida y resultado en taza | regularidad + calidad de café | bajo |
| Agua debajo de la máquina | ubicación + momento + frecuencia | detener diagnóstico si existe riesgo eléctrico; derivar a revisión segura | fuga sí/no | medio/alto |

## Regla de intervención

1. Primero observar.
2. Después cambiar una sola variable.
3. Esperar el número de ciclos indicado por la documentación oficial cuando exista.
4. Registrar antes/después.
5. Si empeora, volver al estado anterior cuando sea seguro.
6. No recomendar desmontaje interno, reparaciones eléctricas ni compra de piezas como primer paso.

## Fuente oficial

La página oficial de De'Longhi para ECAM22.110.B ofrece instrucciones de uso y guías específicas, incluida la sección de ajuste del molino.

El manual oficial indica, para café débil/no cremoso, que una causa posible es una molienda demasiado gruesa y que el ajuste debe hacerse un clic cada vez mientras el molino está funcionando, observando el efecto después de dos cafés. Para café que sale demasiado lento o gota a gota, indica la hipótesis inversa: molienda demasiado fina y ajuste un clic en sentido contrario.

## Hipótesis EXP-001B

Un flujo que:

**síntoma → dato observable → acción oficial/reversible → prueba antes/después → decisión**

tiene más probabilidad de producir una acción útil en el primer contacto que un listado genérico de consejos.

## Criterio de validación

No marcar "resuelto" por satisfacción verbal.

Un caso cuenta como resolución si:
- el usuario ejecuta la acción sin rescate significativo;
- el resultado mejora de forma observable;
- el usuario confirma que la mejora es útil.

Si no se resuelve, cuenta igualmente como evidencia diagnóstica si produce un dato nuevo que reduce el espacio de hipótesis.

## Estado

- Participantes reales: 0/3.
- Coste: 0 €.
- Contacto externo realizado por Nexia: no.
- Solución validada: no.

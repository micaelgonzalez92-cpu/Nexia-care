# NEXIA VOICE COMMANDS

Status: ACTIVE / ZERO-COST / SAFETY-FIRST
Version: 1.0

Voice is an interface, never an authority bypass.

## Safety
- Ambiguous transcription never triggers material action.
- YELLOW/RED actions require exact confirmation after scope, cost, exposure, benefit and risk are stated.
- "ejecuta", "hazlo", "adelante" are not universal authorization.
- If uncertain, use read-only analysis or preparation.
- "PARA TODO" / "DETÉN TODO" / "MODO SEGURO" invoke the emergency-brake intent where technically possible.

## Canonical phrases
- "Nexia, estado" -> /status
- "Nexia, siguiente acción" -> /next
- "Nexia, audita el sistema" -> /audit
- "Nexia, evoluciona el sistema" -> /evolve
- "Nexia, seguridad" -> /security
- "Nexia, protege el sistema" -> /protect
- "Nexia, dime qué necesitas de mí" -> /kael
- "Nexia, verifica [acción]" -> /verify
- "Nexia, investiga [tema]" -> /research
- "Nexia, prepara [acción]" -> /prepare
- "Nexia, guarda el estado" -> /checkpoint
- "Nexia, comandos" -> /commands
- "Nexia, ayuda" -> /help

## Conversational mapping
Natural language may map to these intents, but if more than one command is plausible, ask for clarification.
Examples: "¿Cuál es el siguiente paso?", "¿Qué riesgos tenemos?", "¿Qué está bloqueando la máquina?", "Busca una mejora real", "Comprueba si eso se hizo de verdad", "¿Qué podemos hacer sin gastar?".

## Transcription defense
Potentially dangerous collisions include compra/compara, envía/enseña, publica/prepara, contacta/consulta, paga/para, plus numbers, amounts, recipients, URLs and quantities. Never infer material details from context alone. Repeat the interpreted action and request correction if any detail could change the outcome.

## High-risk confirmation
1. State exactly what was understood.
2. State benefit, cost, exposure, risk, scope and rollback/stop condition.
3. Ask for exact confirmation.
4. Confirmation must cover the exact stated action and scope.
5. Any material transcription change invalidates confirmation.

## Control vocabulary
PREPARA = prepare only.
VERIFICA = verify evidence.
EXPLICA/ANALIZA = read-only unless separately authorized.
INVESTIGA = public research/falsification.
GUARDA = persist verified state.
CANCELA = stop where technically possible.
PARA TODO = emergency brake.
MODO SEGURO = read-only/preparation mode.
¿QUÉ HAS ENTENDIDO? = show interpretation.

## Boundary
This registry defines the durable voice policy and mappings. It does not claim a separate public voice-execution service exists. Voice never bypasses Authority Engine, Security Shield, Human Gates, financial guardrails or persistence rules.

# NEXIA — PUBLIC URL / IDENTITY MAP

Updated: 2026-10-05

## HECHO VERIFICADO

The repository contains clean public route directories:
- `/NexaCare/` — public diagnostic interface.
- `/NexaHQ/` — public command-centre interface.

Repository: `micaelgonzalez92-cpu/Nexia-care`.

Recent commits explicitly created and branded these routes:
- `d40a5669` — clean NexaCare interface route.
- `aa3b837c` — NexaCare public route.
- `8e49911a` — clean NexaHQ command route.
- `904f4177` — NexaHQ public route.
- `f3fdf6ef` — brand NexaCare interface.
- `8a38de01` — brand NexaHQ interface.

## IMPORTANT DISTINCTION

The clean **path names** are implemented, but the GitHub Pages **hostname** still derives from the GitHub account/repository hosting identity.

Therefore the desired end state:

- NexaCare → branded route
- NexaHQ → branded route
- no personal identifier in the public hostname

is **not yet fully achieved**.

Removing the personal identifier from the hostname requires a different hosting identity (for example a suitable organization-owned Pages identity) or a custom domain. No domain has been supplied or purchased, and NEXIA must not spend money without Kael approval.

## FLOOT

No repository evidence found connecting these route commits to Floot. Floot remains unrecovered and must not be treated as the source of truth.

## NEXT SAFE ACTION

Keep the clean routes as the canonical product paths. Investigate zero-cost hosting/domain options and current GitHub Pages configuration. Do not purchase a domain or change external ownership without a Human Gate.


## RUNTIME VERIFICATION — 2026-10-05

Public runtime verification completed through a live browser run after the NexaCare MVP 0.4 code update.

Verified URLs:
- https://micaelgonzalez92-cpu.github.io/Nexia-care/
- https://micaelgonzalez92-cpu.github.io/Nexia-care/NexaCare/

Both served **NexaCare · MVP 0.4**.

Functional verification on the /NexaCare/ route:
- Magnifica S · ECAM21/22.110 selectable.
- Triángulo rojo / aviso de posos selectable.
- Step 3/3 displayed the expected check: ¿Has retirado y vuelto a colocar correctamente el recipiente de posos y la bandeja de goteo?
- No external form, purchase or data mutation occurred.

Browser verification run: d19020b5-10a5-4d2e-ac27-d28e56d1e24c.

The hostname remains the GitHub account/repository hostname; branded/custom hostname remains a separate Human Gate and was not changed.

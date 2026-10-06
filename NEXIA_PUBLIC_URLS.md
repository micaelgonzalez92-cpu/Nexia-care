# NEXIA — PUBLIC URL / IDENTITY MAP

Updated: 2026-10-05

## HECHO VERIFICADO

The repository contains clean public route directories:
- `/NEXIA Care/` — public diagnostic interface.
- `/NEXIA HQ/` — public command-centre interface.

Repository: `micaelgonzalez92-cpu/Nexia-care`.

Recent commits explicitly created and branded these routes:
- `d40a5669` — clean NEXIA Care interface route.
- `aa3b837c` — NEXIA Care public route.
- `8e49911a` — clean NEXIA HQ command route.
- `904f4177` — NEXIA HQ public route.
- `f3fdf6ef` — brand NEXIA Care interface.
- `8a38de01` — brand NEXIA HQ interface.

## IMPORTANT DISTINCTION

The clean **path names** are implemented, but the GitHub Pages **hostname** still derives from the GitHub account/repository hosting identity.

Therefore the desired end state:

- NEXIA Care → branded route
- NEXIA HQ → branded route
- no personal identifier in the public hostname

is **not yet fully achieved**.

Removing the personal identifier from the hostname requires a different hosting identity (for example a suitable organization-owned Pages identity) or a custom domain. No domain has been supplied or purchased, and NEXIA must not spend money without Kael approval.

## FLOOT

No repository evidence found connecting these route commits to Floot. Floot remains unrecovered and must not be treated as the source of truth.

## NEXT SAFE ACTION

Keep the clean routes as the canonical product paths. Investigate zero-cost hosting/domain options and current GitHub Pages configuration. Do not purchase a domain or change external ownership without a Human Gate.


## RUNTIME VERIFICATION — 2026-10-05

Public runtime verification completed through a live browser run after the NEXIA Care MVP 0.4 code update.

Verified URLs:
- https://micaelgonzalez92-cpu.github.io/Nexia-care/
- https://micaelgonzalez92-cpu.github.io/Nexia-care/NEXIA Care/

Both served **NEXIA Care · MVP 0.4**.

Functional verification on the /NEXIA Care/ route:
- Magnifica S · ECAM21/22.110 selectable.
- Triángulo rojo / aviso de posos selectable.
- Step 3/3 displayed the expected check: ¿Has retirado y vuelto a colocar correctamente el recipiente de posos y la bandeja de goteo?
- No external form, purchase or data mutation occurred.

Browser verification run: d19020b5-10a5-4d2e-ac27-d28e56d1e24c.

The hostname remains the GitHub account/repository hostname; branded/custom hostname remains a separate Human Gate and was not changed.

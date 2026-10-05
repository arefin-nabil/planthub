# Git Workflow — PlantHub Bangladesh

**Document Version:** 1.0
**Status:** Draft — Development Phase
**Last Updated:** 2026-08-06

---

## 1. Branching Model

```
main            → always deployable
develop         → integration branch for the current phase
feature/<name>  → one feature/module at a time, branched from develop
fix/<name>      → bug fixes
docs/<name>     → documentation-only changes
```

Example: `feature/orders-status-transition`, `fix/low-stock-alert-threshold`

## 2. Commit Message Format

```
<type>(<scope>): <short summary>

[optional longer description]
```

**Types:** `feat`, `fix`, `docs`, `refactor`, `test`, `chore`

**Examples:**
```
feat(orders): add status transition validation
fix(inventory): correct low-stock threshold comparison
docs(api): document consultation booking endpoint
```

## 3. Pull Request Rules

- Every feature branch merges into `develop` via PR — no direct pushes to `develop` or `main`
- PR description must state: what changed, which module(s), and which requirement/use-case ID it addresses (e.g. "Implements FR-NUR-06")
- At least one review pass before merge (self-review acceptable for solo development, but must be a distinct pass — not merge-on-write)
- CI (lint + tests) must pass before merge

## 4. Release Flow

```
develop → (stabilization) → main → tag (vX.Y.Z) → deploy
```

- Tag format: semantic versioning `vMAJOR.MINOR.PATCH`
- `MAJOR` — breaking API changes; `MINOR` — new features; `PATCH` — fixes

## 5. Resuming After a Long Gap

When picking this project back up after weeks/months away:
1. Read `08_Development/BackendRoadmap.md` to see which stage was last checked off
2. Check `git log develop -20` for the most recent work
3. Re-run `npx prisma migrate status` to confirm local DB matches the latest migration
4. Review any `Open Decisions` / `Open Items` sections across the `docs/` set — these are unresolved questions left for future-you

---

*See also: [CodingStandards.md](./CodingStandards.md) · [BackendRoadmap.md](./BackendRoadmap.md)*

# Coding Standards — PlantHub Bangladesh

**Document Version:** 1.0
**Status:** Draft — Development Phase
**Last Updated:** 2026-08-06

---

## 1. Language & Tooling

- **TypeScript** in `strict` mode (`tsconfig.json`: `"strict": true`)
- **ESLint** + **Prettier** enforced via pre-commit hook (Husky + lint-staged)
- No `any` without an explicit inline comment justifying it

## 2. File & Naming Conventions

- Files: `camelCase.ts` (e.g. `orderService.ts`)
- Classes/Types/Interfaces: `PascalCase`
- Constants: `UPPER_SNAKE_CASE`
- One module per feature folder, following `04_Architecture/FolderStructure.md`

## 3. Layer Discipline

- **Controllers** never contain business logic or direct Prisma calls — they call a service and shape the HTTP response only
- **Services** never import Express types (`Request`/`Response`) — keeps them testable in isolation
- **Repositories** are the only layer that imports `PrismaClient`

## 4. Error Handling

- All async route handlers wrapped (e.g. `express-async-handler` or equivalent) so errors reach the global error handler
- Business errors thrown as typed custom error classes (`NotFoundError`, `ValidationError`, `ForbiddenError`) — never raw `throw new Error("...")` in service code
- Global error handler maps error classes to the HTTP status codes defined in `06_API/API_Standards.md`

## 5. Validation

- Every route's input validated with a Zod schema before the controller executes
- Validation schemas live alongside their module (`<feature>.validation.ts`), not centralized in one giant file

## 6. Async & Database

- No unhandled promise rejections — always `await` or explicitly `.catch()`
- Multi-step writes that must succeed/fail together use Prisma transactions (`prisma.$transaction`)
- No N+1 query patterns — use Prisma `include`/`select` to fetch related data in one query

## 7. Testing Expectations

- New service-layer logic requires at least one unit test (see `09_Testing/TestPlan.md`)
- Critical flows (order placement, payment, status transitions) require integration test coverage before merging to `main`

## 8. Comments & Documentation

- Code comments explain **why**, not **what** (the code itself should show what)
- Any deviation from an architectural rule in this doc set must be called out in a comment linking to the relevant doc

## 9. Commit Hygiene

- Follow the commit format defined in `GitWorkflow.md`
- No commented-out dead code merged to `main`
- No secrets or `.env` values committed — verify against `.env.example`

---

*See also: [GitWorkflow.md](./GitWorkflow.md) · [04_Architecture/Architecture.md](../04_Architecture/Architecture.md)*

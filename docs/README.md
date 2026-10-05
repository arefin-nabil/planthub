# PlantHub Bangladesh — Documentation Index

This `docs/` folder is the single source of truth for the PlantHub Bangladesh project. Start here.

## Structure

```
docs/
├── 01_Project_Overview/    → Vision, Goals, Scope
├── 02_Requirement/         → Functional & Non-Functional Requirements
├── 03_System_Analysis/     → Use Cases, User Stories
├── 04_Architecture/        → System Architecture, Folder Structure
├── 05_Database/            → Prisma Schema, Indexes
├── 06_API/                 → API Standards, Auth, Plants, Orders, Notifications
├── 07_UI_UX/                → Design System (theme, colors, patterns)
├── 08_Development/         → Backend Roadmap, Coding Standards, Git Workflow
├── 09_Testing/             → Test Plan
└── 10_Deployment/          → CI/CD & Deployment
```

## How to Use This

- **Starting fresh / resuming after a gap?** Read `01_Project_Overview/Vision.md`, then `08_Development/BackendRoadmap.md` to see what's already built.
- **Building a feature?** Check its Functional Requirement ID in `02_Requirement/FunctionalRequirements.md`, its use case in `03_System_Analysis/`, its data model in `05_Database/Schema.md`, and its endpoint contract in `06_API/`.
- **Onboarding a teammate?** Give them this whole folder — it's written to stand alone without verbal explanation.
- **Showing a client/investor?** `01_Project_Overview/` and `07_UI_UX/DesignSystem.md` are the most presentable entry points.

## Status Tracking

Every document carries a `Status` and `Last Updated` field in its header. Update these as decisions firm up — especially the **Open Decisions / Open Items** sections in `04_Architecture/Architecture.md` and `10_Deployment/CI_CD.md`, which track what's still unresolved.

## Tech Stack (Quick Reference)

Node.js · Express.js · TypeScript · Prisma · MongoDB · JWT · Socket.io

---

*This documentation set is written to IEEE 830-influenced SRS structure and is intended to be presentable to clients, investors, and usable as a university thesis reference.*

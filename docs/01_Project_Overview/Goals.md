# Project Goals — PlantHub Bangladesh

**Document Version:** 1.0
**Status:** Draft — Development Phase
**Last Updated:** 2026-08-06

---

## 1. Strategic Objectives

1. Build a trusted online plant marketplace for Bangladesh
2. Digitize nursery business operations end-to-end
3. Simplify inventory and stock management for nursery owners
4. Provide accessible online plant consultation services
5. Create a knowledge-sharing platform for plant lovers
6. Build a creator economy around plant education (blog → purchase / consultation attribution)
7. Prepare the platform architecture for future AI-powered plant services

## 2. Goals by Stakeholder

### 2.1 Business Goals
- Onboard verified nurseries and establish platform trust through a tiered verification system
- Generate revenue through commissions, subscriptions, and premium listings (see `09_Roadmap.md` and future `RevenueModel.md`)
- Reduce nursery dependence on informal social-media selling

### 2.2 Technical Goals
- Ship a modular, layered backend (Node.js + Express.js + TypeScript + Prisma + MongoDB) that can support new roles and features without major rework
- Enforce role-based access control (RBAC) across Customer, Nursery Owner, Plant Expert, and Admin roles from day one
- Provide real-time capability (order status, notifications, chat consultation) via Socket.io
- Keep the API and data model extensible enough to onboard future roles: Delivery Partner, Nursery Employee, Affiliate, Content Moderator, Super Admin

### 2.3 User Experience Goals
- Mobile-first, fast, image-focused, nature-inspired UI
- Clear trust signals (verification badges, reviews, ratings) throughout the buying journey
- Frictionless order-to-delivery experience with visible order/delivery status at every stage

## 3. Success Criteria (Development Phase)

A goal is considered achieved for this phase when:

- [ ] Core roles (Customer, Nursery Owner, Admin) can complete their primary workflows end-to-end in a working environment
- [ ] Marketplace supports browse → product detail → cart/order → status tracking
- [ ] Nursery dashboard supports product, inventory, and order management
- [ ] Authentication & RBAC is implemented and tested for all defined roles
- [ ] Notification system delivers at least in-app + real-time (Socket.io) notifications
- [ ] Documentation set (this `docs/` folder) stays in sync with what is actually built, so the project can be resumed by the same or a new developer after a long gap

## 4. Non-Goals (For This Phase)

To keep the development phase scoped and achievable, the following are explicitly **out of scope for now** (tracked instead in `09_Roadmap.md` under Phase 2 / Phase 3):

- AI Disease Detection, AI Recommendation Engine, AI Smart Search
- Video/audio consultation calls
- Courier API integrations (delivery tracking is manual/status-based initially)
- SMS notifications
- Multi-branch nursery / employee management
- Produce marketplace, plant passport

---

*Related documents: [Vision.md](./Vision.md) · [Scope.md](./Scope.md)*

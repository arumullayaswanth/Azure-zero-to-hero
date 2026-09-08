# Day 3: Notes — Real Use Cases

Short real-world use cases for Resources, Resource Groups, and ARM.

---

## Use Case 1: Group by Environment

Keep Dev, Test, and Prod separate:

```text
rg-app-dev   → resources for development
rg-app-test  → resources for testing
rg-app-prod  → resources for production
```

Delete `rg-app-dev` when done testing → all dev resources go with it. Prod stays safe.

---

## Use Case 2: Group by Project / Team

Each team gets its own resource group:

```text
rg-team-frontend
rg-team-backend
rg-team-data
```

Easy billing and access control per team.

---

## Use Case 3: Easy Cleanup

Built a demo? Put everything in one resource group.
Delete the group → everything is removed in one click. No leftover resources = no surprise bills.

---

## Use Case 4: Cost Tracking with Tags

Add tags to resources so you know what costs what:

```text
Environment = Production
Owner       = payments-team
CostCenter  = 1024
```

ARM uses tags for billing reports and organization.

---

## Use Case 5: Access Control (RBAC)

Give a team access only to their resource group:

```text
Developer → Contributor on rg-team-backend only
```

They can manage their resources, but not touch production.

---

## Quick Rules to Remember

- A resource belongs to **only one** resource group.
- Deleting a resource group deletes **everything inside it**.
- ARM handles create, update, delete, tags, policies, and access.

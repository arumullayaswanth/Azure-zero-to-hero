# Microsoft Entra ID — Identity and Access Management (IAM)

Short and simple. Control *who* can access *what* in Azure.

---

## Quick Meaning

- **Microsoft Entra ID** (formerly Azure AD) → where users, groups, and apps live (identity).
- **Authentication** → proving who you are (login).
- **Authorization** → what you're allowed to do (permissions).
- **RBAC (Role-Based Access Control)** → assign roles to control access.

```text
Identity (Entra ID)  →  Authentication (login)  →  Authorization (RBAC role)  →  Access
```

---

## Key Roles (built-in)

| Role | What it can do |
|------|----------------|
| **Owner** | Full access + can give access to others |
| **Contributor** | Create/manage resources, but can't grant access |
| **Reader** | View only, no changes |
| **User Access Administrator** | Manage access for others only |

Rule: give the **least** access needed (principle of least privilege).

---

## The 3 Parts of an RBAC Assignment

```text
Who        +   What role    +   Where (scope)
(user)         (Reader)          (resource group)
```

**Scope** can be: Management Group → Subscription → Resource Group → single Resource.

---

## Step 1: Create a user (Entra ID)
1. Portal → search `Microsoft Entra ID` → **Users** → **+ New user**.
2. Create the user with a name and password → **Create**.

## Step 2: Create a group (optional but recommended)
1. Entra ID → **Groups** → **+ New group**.
2. Type: Security, add the user as a member → **Create**.

## Step 3: Assign a role (RBAC)
1. Open a **Resource group** (e.g. `rg-day11`).
2. Left menu → **Access control (IAM)** → **+ Add** → **Add role assignment**.
3. Pick a role (e.g. **Reader**).
4. Assign access to → **User, group...** → select your user/group.
5. **Review + assign**.

## Step 4: Verify
1. Still in **Access control (IAM)** → **Role assignments** tab.
2. Confirm your user/group shows with the role you gave.

## Step 5: Do it with CLI (optional)
```bash
# assign Reader role to a user on a resource group
az role assignment create --assignee user@domain.com --role "Reader" --resource-group rg-day11

# list role assignments
az role assignment list --resource-group rg-day11 --output table
```

## Step 6: Remove access (cleanup)
```bash
az role assignment delete --assignee user@domain.com --role "Reader" --resource-group rg-day11
```

---

## RBAC Best Practices

- **Least privilege** → give only what's needed.
- **Assign roles to groups**, not individual users (easier to manage).
- **Avoid Owner** for daily work; use Contributor.
- **Scope narrowly** → resource group instead of whole subscription when possible.
- **Review access** regularly.

---

## ✅ Remember
- **Entra ID** = identity store, **RBAC** = who can do what, where.
- Assignment = **who + role + scope**.
- Prefer **groups** + **least privilege**.

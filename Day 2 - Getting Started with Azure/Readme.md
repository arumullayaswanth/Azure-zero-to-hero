# Day 2: Getting Started with Azure

Short and simple. Create an account, understand regions, and know IaaS vs PaaS vs SaaS.

---

## 1. Creating an Azure Account

- You need an **Azure account** + an **Azure subscription**.
- All resources you create belong to your subscription (used for billing and access control).
- Manage everything from the **Azure Portal** (your control room).

👉 Create a free account: [Create Azure Free Account](https://medium.com/@yaswanth.arumulla/create-azure-free-account-708f803fa500)

```text
Azure Subscription
├── Virtual Machine
├── Storage Account
├── Virtual Network
└── Database
```

---

## 2. Regions and Availability Zones

**Region** → a geographic location of Azure data centers (e.g. Central India, East US).
Pick one close to your users for lower latency.

**Availability Zone** → physically separate data centers inside a region (own power, cooling, network).
Spread your app across zones so one zone failure doesn't take it down.

```text
Azure Region
├── Zone 1
├── Zone 2
└── Zone 3
```

> Region = big location. Availability Zone = separate location inside that region.

When picking a region, check: service availability, latency, cost, compliance, and disaster recovery needs.

---

## 3. IaaS vs PaaS vs SaaS
https://medium.com/@yaswanth.arumulla/iaas-vs-paas-vs-saas-who-actually-manages-what-5ca5d8d8b35d

| Model | You manage | Azure manages | Example |
|-------|-----------|---------------|---------|
| **IaaS** | The server (OS, app, updates) | Hardware | Azure Virtual Machines |
| **PaaS** | Just your app | The platform | Azure App Service |
| **SaaS** | Nothing (just use it) | Everything | Microsoft 365 |

Simple way to remember:

- **IaaS** → "Give me a server, I'll manage it."
- **PaaS** → "Here's my app, you manage the platform."
- **SaaS** → "Just give me the software, I'll use it."

More management ← IaaS ... PaaS ... SaaS → Less management

### Real SaaS Products MNCs Use Daily

- **Microsoft 365** — email, Word, Excel, Teams
- **Google Workspace** — Gmail, Docs, Drive, Meet
- **Salesforce** — CRM / sales management
- **Slack** — team messaging
- **Zoom** — video meetings
- **ServiceNow** — IT service management
- **SAP (SuccessFactors)** — HR and business operations
- **Zoom / Jira / Confluence** — project and dev collaboration

These are all SaaS — the company just logs in and uses them, no servers to manage.

---

That's Day 2. Next we start creating real Azure resources.

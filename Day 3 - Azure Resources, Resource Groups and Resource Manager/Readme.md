# Day 3: Hands-On Playbook — Resources, Resource Groups & Resource Manager

Today we are going to **actually build things** in Azure, step by step.

Everything is explained in plain, simple words. Just follow each step in order. ✅

---

## First, 3 Simple Definitions

- **Resource** → One single thing you create in Azure. Example: a Storage Account, a Virtual Machine, a Database.
- **Resource Group** → A folder that holds related resources together, so they are easy to manage.
- **Azure Resource Manager (ARM)** → The system that creates, updates, and deletes your resources when you click buttons.

Here is how they fit together:

```text
Azure
│
└── Resource Group      (a folder for related resources)
    ├── Storage Account  (a resource)
    └── Virtual Network  (a resource)
```

That's the whole idea. Now let's build it. 🚀

---

## 🎒 What You Need Before We Start

1. A computer with internet. 🌐
2. An Azure account. (Free is fine!)
   - No account yet? Go to: https://azure.microsoft.com/free
   - Sign up. You may need to add a card, but the free stuff won't charge you.
3. That's it. No coding needed for this part. 🙌

---

## 🟦 PART A — Create a Resource Group (the folder)

### Step 1: Open the Azure Portal
- Go to: https://portal.azure.com
- Log in with your email and password. 🔑

### Step 2: Find "Resource groups"
- At the **top search bar**, type: `Resource groups`
- Click the result that says **Resource groups**. 🔍

### Step 3: Click "+ Create"
- Look for a button that says **+ Create** (top-left area).
- Click it. 🖱️

### Step 4: Fill in the boxes
You will see a form. Fill it like this:

| Box | What to put | Why |
|-----|-------------|-----|
| **Subscription** | Leave the one already selected | This is your billing account 💳 |
| **Resource group** | `rg-day3-practice` | The name of your folder 📦 |
| **Region** | Pick one close to you (e.g. `Central India` or `East US`) | Where your resources are hosted 🌍 |

> 💡 Tip: Names should have **no spaces**. Use dashes `-` instead.

### Step 5: Review + Create
- Click **Review + create** (bottom).
- Wait for the green ✅ **Validation passed**.
- Click **Create**.

🎉 **Done!** You just created your first Resource Group!

---

## 🟩 PART B — Create a Resource Inside It

We will add a **Storage Account** (a place to keep files). It's cheap and easy. 💾

### Step 1: Go to your Resource Group
- In the top search bar, type `Resource groups` again.
- Click your group: **rg-day3-practice**.

### Step 2: Click "+ Create"
- Inside the resource group, click **+ Create**.
- This opens the **Marketplace** (Azure's catalog of services 🏬).

### Step 3: Search for Storage Account
- In the search box type: `Storage account`
- Click **Storage account** → then click **Create**.

### Step 4: Fill in the boxes
| Box | What to put |
|-----|-------------|
| **Subscription** | Leave as-is |
| **Resource group** | Should already say `rg-day3-practice` ✅ |
| **Storage account name** | `stday3practice123` (must be **lowercase**, **no spaces**, and **globally unique** — add random numbers) |
| **Region** | Same region as your group |
| **Performance** | Standard |
| **Redundancy** | LRS (cheapest) |

> 💡 If the name is taken, just add more numbers, like `stday3practice4567`.

### Step 5: Review + Create
- Click **Review** (bottom).
- Wait for ✅ **Validation passed**.
- Click **Create**.
- Wait ~30 seconds. You'll see **"Your deployment is complete."** 🎊

🎉 **Done!** You created your first resource inside the resource group!

---

## 🤖 PART C — Understand Azure Resource Manager (ARM)

You didn't see ARM, but it was working the whole time.

Every time you clicked **Create**, this happened behind the scenes:

```text
You (click Create)
      ↓
Azure Portal
      ↓
Azure Resource Manager (ARM)
      ↓
Your resource is created ✅
```

ARM is the layer that actually creates, changes, and deletes your resources.

### See ARM's work (proof!) 🔎
- Go to your resource group **rg-day3-practice**.
- On the left menu, click **Deployments**.
- You'll see a list of everything ARM built for you — a history log of your actions. 📖

---

## 🧹 PART D — Clean Up (so you don't pay money!)

Very important! 💰 Delete practice stuff when you're done.

### Delete the whole resource group (and everything inside it)
1. Go to your resource group **rg-day3-practice**.
2. Click **Delete resource group** (top).
3. It will ask you to **type the name** to confirm: type `rg-day3-practice`.
4. Click **Delete**.

> ⚠️ **Remember:** Deleting a resource group deletes **everything inside it**. That's great for cleanup, but scary in real projects. Be careful in real life! 🚨

---

## 🏆 What You Learned Today

- **Resource** = one thing you create (like a Storage Account).
- **Resource Group** = a folder that holds related resources.
- **Resource Manager (ARM)** = the layer that creates and manages everything.

```text
Resource         → the actual Azure service you create
Resource Group   → a folder for related resources
Resource Manager → the management layer that runs it all
```

---

## ✅ Mini Checklist (tick these!)

- [ ] I logged into portal.azure.com
- [ ] I created a Resource Group named `rg-day3-practice`
- [ ] I created a Storage Account inside it
- [ ] I looked at **Deployments** to see ARM's work
- [ ] I deleted the resource group to clean up

---

## 🎁 Bonus: Do It With One Command (optional)

When you're ready to level up, open **Azure Cloud Shell** (the `>_` icon at the top of the portal) and try:

```bash
# Create a resource group
az group create --name rg-day3-cli --location eastus

# Create a storage account inside it
az storage account create \
  --name stday3cli$RANDOM \
  --resource-group rg-day3-cli \
  --location eastus \
  --sku Standard_LRS

# Clean up when done
az group delete --name rg-day3-cli --yes --no-wait
```

That's Azure Resource Manager doing the same job through the command line instead of clicks.

---

**Great job today! You built real Azure infrastructure. See you on Day 4! 👋**

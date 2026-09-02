# Day 3: Azure Resources, Resource Groups and Resource Manager

Today we'll work directly in Azure and understand how resources and resource groups are created and managed.

## Lab Objective

By the end of this hands-on, you will:

- Create a Resource Group
- Create Azure resources inside it
- Understand the relationship between a Subscription, Resource Group, and Resource
- Explore Azure Resource Manager
- Check resource deployments
- Add tags
- Clean up the resources

---

## Step 1: Create a Resource Group

Go to the **Azure Portal**.

Search for:

`Resource groups`

Click **Create**.

Enter:

- **Subscription:** Your Azure Subscription
- **Resource Group:** `rg-azure-zero-to-hero`
- **Region:** Choose a suitable region

Click:

**Review + create → Create**

### Check

Open the Resource Group and make sure it was created successfully.

At this point:

```text
Azure Subscription
        ↓
rg-azure-zero-to-hero
```

The Resource Group is currently empty.

---

## Step 2: Create a Storage Account

Now let's create our first Azure resource.

Search for:

`Storage accounts`

Click **Create**.

For the Resource Group, select:

`rg-azure-zero-to-hero`

Give the Storage Account a unique name.

Choose your required region and keep the remaining settings suitable for this lab.

Click:

**Review + create → Create**

Wait for the deployment to finish.

### Check

Open the Resource Group again.

You should now see:

```text
rg-azure-zero-to-hero
        │
        └── Storage Account
```

The Storage Account is our **resource**.

---

## Step 3: Create a Virtual Network

Now let's create another resource.

Search for:

`Virtual networks`

Click **Create**.

Use the same Resource Group:

`rg-azure-zero-to-hero`

Give the VNet a name such as:

`vnet-dev`

For this basic lab, you can use the default networking settings.

Click:

**Review + create → Create**

### Check

Go back to the Resource Group.

You should now have:

```text
rg-azure-zero-to-hero
│
├── Storage Account
└── Virtual Network
```

Now you can clearly see why Resource Groups are useful.

Instead of having resources scattered around, we have resources belonging to the same lab grouped together.

---

## Step 4: Understand the Azure Resource Hierarchy

Now pause for a second and look at what we created.

```text
Azure Subscription
        │
        ▼
Resource Group
        │
   ┌────┴─────┐
   ▼          ▼
Storage      VNet
Account
```

Remember:

- **Subscription** → Where the resources are managed and billed
- **Resource Group** → Logical container for related resources
- **Resource** → The actual Azure service you create

---

## Step 5: Explore Azure Resource Manager

Now let's see what happens when we create these resources.

When you create a resource through the Azure Portal, you're not directly talking to the physical Azure servers.

The request goes through **Azure Resource Manager (ARM)**.

```text
You
 ↓
Azure Portal
 ↓
Azure Resource Manager
 ↓
Azure Resource
```

You can also interact with Azure resources using:

```text
Azure Portal
Azure CLI
PowerShell
Terraform
ARM Templates
APIs
```

For now, just remember:

**Azure Resource Manager is the management layer for Azure resources.**

---

## Step 6: Check Deployment History

Go to:

**Resource Group → Deployments**

You should see the deployments that happened when you created your resources.

Open a deployment and look at the details.

This becomes very useful when a deployment fails.

Instead of just seeing:

```text
Deployment failed
```

you can inspect the deployment details and find out what went wrong.

---

## Step 7: Add Tags

Now let's do something you'll commonly see in real Azure environments.

Open your Resource Group and add tags.

For example:

```text
Environment = Dev
Project     = Azure-Zero-to-Hero
Owner       = Yaswanth
```

Tags help you identify and organize resources.

Imagine you have hundreds of resources in a company.

A tag can quickly tell you:

> "Why does this resource exist?"

---

## Step 8: Explore the Resources

Take a few minutes and open each resource.

Check:

- Resource name
- Region
- Resource Group
- Subscription
- Status
- Tags

The goal here is not to memorize every option.

Just get comfortable navigating Azure.

---

## Step 9: Clean Up

This is an important part of every Azure hands-on lab.

If you don't need these resources anymore, delete them.

Go to:

**Resource Groups → rg-azure-zero-to-hero → Delete resource group**

Enter the Resource Group name to confirm.

Once the Resource Group is deleted, the resources inside it are deleted as well.

```text
Resource Group
│
├── Storage Account
└── Virtual Network

        ↓ Delete Resource Group

Everything is removed
```

**Important:** Never do this blindly in a real production environment.

---

## Hands-on Checklist

Before finishing Day 3, make sure you completed:

- [ ] Created a Resource Group
- [ ] Created a Storage Account
- [ ] Created a Virtual Network
- [ ] Verified resources inside the Resource Group
- [ ] Explored Azure Resource Manager
- [ ] Checked deployment history
- [ ] Added tags
- [ ] Deleted the lab resources

---

## What You Should Understand

After completing this lab, you should be able to look at an Azure environment and understand:

```text
Subscription
     ↓
Resource Group
     ↓
Resources
```

And when you create or manage those resources:

```text
Portal / CLI / Terraform / API
              ↓
     Azure Resource Manager
              ↓
        Azure Resources
```

That's the basic foundation we'll build on in the next hands-on labs.

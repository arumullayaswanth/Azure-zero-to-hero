# Day 3: Azure Resources, Resource Groups and Resource Manager

Today, let's understand three things you'll work with almost every time you use Azure:

* Azure Resources
* Resource Groups
* Azure Resource Manager

Don't worry, these are actually pretty simple once you see how they fit together.

---

## 1. Resources in Azure

Let's say you are building an application on Azure.

You might need a Virtual Machine, a Storage Account, a Virtual Network, and a Database.

Each of these is called an **Azure Resource**.

So, simply:

**Anything you create and manage in Azure is generally a resource.**

For example:

```text
Virtual Machine     → Resource
Storage Account     → Resource
Virtual Network     → Resource
Database            → Resource
```

As we move through this series, you'll create many different Azure resources.

---

## 2. Resource Groups in Azure

Now imagine you are building an e-commerce application.

You have:

* 2 Virtual Machines
* 1 Database
* 1 Storage Account
* 1 Virtual Network

Managing all of these individually can become messy.

So Azure gives you a way to group related resources together.

That's a **Resource Group**.

You could have something like:

```text
E-Commerce Resource Group
│
├── Virtual Machine
├── Virtual Machine
├── Database
├── Storage Account
└── Virtual Network
```

Now you have one logical place to manage resources that belong to the same application or environment.

For example, you might create separate resource groups for:

```text
Development
Testing
Production
```

One important thing to remember:

**A resource can belong to only one resource group at a time.**

And when you delete a resource group, the resources inside that resource group are also deleted.

So be careful when deleting resource groups in a production environment.

---

## 3. Overview of Azure Resource Manager

Now you might be wondering:

**"Who actually manages all these Azure resources?"**

This is where **Azure Resource Manager (ARM)** comes in.

ARM is the management layer that Azure uses to create, update, delete, and manage resources.

For example, when you create a Virtual Machine from the Azure Portal, the portal is not directly managing the physical infrastructure.

The request goes through Azure Resource Manager.

```text
You
 ↓
Azure Portal / CLI / Terraform
 ↓
Azure Resource Manager
 ↓
Azure Resources
```

And ARM isn't only used when creating resources.

It also helps with things like:

* Access control
* Resource organization
* Tags
* Policies
* Deployments

So when you hear **Azure Resource Manager**, think:

> **"This is the management layer through which I manage my Azure resources."**

---

## The Simple Picture

At this point, keep this picture in your mind:

```text
Azure
│
├── Resource Group
│   ├── VM
│   ├── Storage
│   ├── Database
│   └── Network
│
└── Resource Group
    ├── VM
    └── Database
```

**Resource = The actual Azure service you create**

**Resource Group = A logical container for related resources**

**Resource Manager = The management layer used to manage those resources**

That's all you need to understand for Day 3.

We'll use these concepts constantly as we start creating real Azure infrastructure.

# Day 2: Getting Started with Azure

In Day 1, we understood the basic cloud concepts.

Now let's actually get started with Azure.

We are going to keep this simple. First, we'll create an Azure account, then we'll understand where our resources actually run, and finally we'll understand the difference between **IaaS, PaaS, and SaaS**.

---

## 1. Creating an Azure Account

Okay, let's start with the obvious question:

**How do I actually get into Azure?**

You need an Azure account and an Azure subscription.

Once you have access to Azure, you'll normally use the **Azure Portal** to create and manage your resources.

Think about the Azure Portal as your **control room**.

From here, you can create things like:

* Virtual Machines
* Virtual Networks
* Storage Accounts
* Databases
* Kubernetes clusters
* And many other Azure services

You don't need to memorize all of these right now. We'll use them throughout this series.

### Azure Subscription

One thing you should understand from the beginning is the **Azure subscription**.

When you create Azure resources, they are created under a subscription.

For example, imagine you're learning Azure and you create:

```text
Azure Subscription
│
├── Virtual Machine
├── Storage Account
├── Virtual Network
└── Database
```

All of these resources belong to your subscription.

The subscription is also important from a **billing and access-control** perspective.

For learning purposes, you can create an Azure free account if you're eligible.

You can follow this guide:

**[Create Azure Free Account](https://medium.com/@yaswanth.arumulla/create-azure-free-account-708f803fa500)**

Once you've created the account, open the **Azure Portal**.

That's where we'll start doing the hands-on work in the coming days.


# 2. Exploring Regions and Availability Zones in Azure

Now let's say you've created your Azure account.

The next thing you'll notice when creating an Azure resource is that Azure often asks you:

**"Which region do you want to deploy this resource to?"**

At first, you might think:

> "Why does Azure care where I create my VM?"

It actually matters quite a lot.

## Azure Regions

An Azure **Region** is a geographical location where Azure has its infrastructure.

For example, Azure has regions in different parts of the world, including India, the United States, and many other locations. Microsoft maintains a current list of regions and their Availability Zone support.

Let's say your company has most of its customers in India.

You probably want your application to run somewhere reasonably close to those users.

Why?

Because network traffic has to travel between your users and your application.

Generally:

**Closer users → Lower network latency → Better user experience**

But location isn't the only thing you think about.

When choosing a region, you also need to consider:

* Is the Azure service available there?
* Do I need Availability Zones?
* Are there data residency requirements?
* What is the cost?
* Do I need another region for disaster recovery?

Microsoft also recommends checking service availability, compliance, latency, pricing, and resilience requirements when selecting a region.

So don't just open the Azure Portal and randomly select a region.

**Region selection is part of your architecture.**

### Let's Take a Real Example

Imagine you're building an e-commerce application for customers in India.

You have:

```text
Customers in India
        ↓
     Internet
        ↓
    Azure Region
        ↓
   Your Application
        ↓
     Database
```

If your application is deployed far away from your main users, you may introduce unnecessary network latency.

So you would normally start by looking at regions close to your users and then check whether that region supports all the Azure services your application needs.

That's how an engineer thinks about regions.

## Availability Zones

Now let's go one step deeper.

Suppose you've selected an Azure region.

You might think:

> "Okay, my application is in the region. I'm done."

Not quite.

Inside many Azure regions, Microsoft provides **Availability Zones**.

An Availability Zone is a physically separate group of datacenters inside an Azure region, with independent power, cooling, and networking.

Think about it like this:

```text
              Azure Region
                   │
        ┌──────────┼──────────┐
        │          │          │
      Zone 1     Zone 2     Zone 3
        │          │          │
     Servers    Servers    Servers
```

The zones are connected with low-latency networking, but they are physically separated to reduce the chance that a local failure affects all of them.

## Why Do We Need Availability Zones?

Let's say you have an application running on one server.

Something happens to that physical location:

**Power problem → Server goes down → Application goes down**

That's obviously not what we want for a production application.

Instead, we can design the application across multiple Availability Zones.

For example:

```text
                 Users
                   │
              Load Balancer
                   │
        ┌──────────┼──────────┐
        │          │          │
      Zone 1     Zone 2     Zone 3
        │          │          │
      App 1      App 2      App 3
```

Now if one zone has an outage, the other zones can continue serving the application, assuming the application has been designed and configured to use multiple zones.

That's the real purpose of Availability Zones:

**Protect your application from a failure of one zone.**

But don't make this mistake:

### Region ≠ Availability Zone

A **Region** is the larger geographical location.

An **Availability Zone** is a separate physical location inside that region.

For example:

```text
Azure Region
│
├── Availability Zone 1
├── Availability Zone 2
└── Availability Zone 3
```

## 3. IaaS vs PaaS vs SaaS in Azure

Let's say you have a Python application and you want to run it on Azure.

### IaaS — Infrastructure as a Service

You can create an **Azure Virtual Machine**.

Azure gives you the server, but you manage the things inside it.

For example, you may need to install Python, configure the web server, deploy your application, apply OS updates, and take care of security.

So basically:

**Azure gives you the server → You manage the server.**

**Example:** Azure Virtual Machines

---

### PaaS — Platform as a Service

Now imagine you don't want to manage the server.

You just want to say:

> "Here is my application. I want to run it."

You can use **Azure App Service**.

Azure manages the underlying platform, while you mainly focus on your application.

So:

**You give Azure the application → Azure manages more of the platform.**

**Example:** Azure App Service

---

### SaaS — Software as a Service

Now imagine you don't even want to build the application.

You just want to use ready-made software.

For example, your company needs email and collaboration tools. You can use **Microsoft 365** instead of building and managing your own system.

So:

**The software is already built → You simply use it.**

**Example:** Microsoft 365

---

### The Simple Difference

Think about it this way:

**IaaS:** "Give me a server. I'll manage it."

**PaaS:** "I'll give you my application. You manage the platform."

**SaaS:** "Just give me the software. I'll use it."

The main difference is **how much you have to manage yourself**.

**IaaS → More management**

**PaaS → Less management**

**SaaS → Very little infrastructure management**

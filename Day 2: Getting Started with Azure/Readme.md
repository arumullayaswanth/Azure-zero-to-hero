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

---

# 2. Exploring Regions and Availability Zones in Azure
Now let's say you've created your Azure account.

The next thing you'll notice when creating an Azure resource is that Azure often asks you:

**"Which region do you want to deploy this resource to?"**

At first, you might think:

> "Why does Azure care where I create my VM?"

It actually matters quite a lot.

---

## Azure Regions

An Azure **Region** is a geographical location where Azure has its infrastructure.

For example, Azure has regions in different parts of the world, including India, the United States, Europe, and many other locations. Microsoft maintains a current list of regions and their Availability Zone support.

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

---

## Let's Take a Real Example

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

---

# Availability Zones

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

---

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

And one more important point:

**Availability Zones do not protect you from a complete regional outage.**

If you need protection against an entire region becoming unavailable, you need to consider a multi-region architecture and a disaster recovery strategy.

Also, not every Azure service supports Availability Zones in every region, so always check the service's regional support before designing your architecture.

---

# 3. IaaS vs PaaS vs SaaS in Azure

Now let's come to one of the most important concepts in cloud.

You've probably heard:

**IaaS**
**PaaS**
**SaaS**

Don't try to memorize the definitions.

Let's take a real application and see what changes.

---

## Let's Say You Have a Python Application

Imagine you're a developer.

You've built a Python web application.

The application is ready.

Now you tell me:

> "I need somewhere to run this application."

Okay.

Azure gives you different ways to do that.

Let's start with the most hands-on option.

---

# IaaS — Azure Virtual Machine

You can create an **Azure Virtual Machine**.

Let's say you create an Ubuntu VM.

Azure gives you the virtual server.

Now it's your job to do a lot of the work.

For example:

```text
Create VM
   ↓
Install Ubuntu / choose OS
   ↓
Configure the server
   ↓
Install Python
   ↓
Install dependencies
   ↓
Configure web server
   ↓
Deploy application
   ↓
Patch and maintain the OS
```

Now you're probably thinking:

> "Wait, I have to do all of that?"

Yes.

That's the point.

Azure is taking care of the underlying physical infrastructure, but you're responsible for managing the VM and the software running inside it.

This is **IaaS — Infrastructure as a Service**.

**Azure Virtual Machines are an example of IaaS.**

---

## Why Would I Use a VM?

Now don't think:

> "IaaS means bad because I have more work."

Not at all.

Sometimes you **want that control**.

For example, imagine you have a legacy application that requires:

* A specific operating system
* Custom software
* Special server configuration
* Full administrator access

In that situation, a VM can make a lot of sense.

You get more control.

But remember:

**More control = More responsibility**

That's the trade-off with IaaS.

---

# PaaS — Azure App Service

Now let's change the requirement.

You come back to me and say:

> "I don't want to manage the operating system. I don't want to patch servers. I don't want to worry about the underlying infrastructure. I just want to deploy my application."

Okay.

Then why create a VM?

You could use **Azure App Service**.

You deploy your application to App Service, and Azure manages much more of the underlying platform for you.

Your focus becomes:

```text
My Code
   ↓
Azure App Service
   ↓
Azure manages more of the platform
```

You're still responsible for your application and its configuration, but you don't have to manage the underlying VM and operating system in the same way you would with IaaS.

That's **PaaS — Platform as a Service**.

**Azure App Service is a common PaaS example.**

---

## VM vs App Service

Let's make this very practical.

Imagine we have the exact same Python application.

### With a VM:

You might need to think about:

```text
Operating System
Python
Dependencies
Web Server
Security
Patching
Application
```

### With App Service:

Your focus is much more on:

```text
Application
Application Configuration
Deployment
Data
```

Azure takes care of much more of the platform underneath.

That's the value of PaaS.

**You spend less time managing servers and more time working on the application.**

---

# SaaS — Just Use the Software

Now let's go one step further.

Suppose your company needs email and collaboration tools.

Are you going to:

> "Create a VM, install an email server, configure it, patch it, maintain it, and build a web interface?"

Obviously not.

You just want to **use the software**.

That's where SaaS comes in.

For example, **Microsoft 365** is a SaaS offering.

You sign in and use the software.

You aren't managing the underlying servers or deploying the application yourself.

That's **SaaS — Software as a Service**.

---

# So What Is the Real Difference?

Forget the complicated definitions for a moment.

Ask yourself one question:

> **"How much of the infrastructure do I want to manage?"**

### IaaS

You say:

> "Give me the server. I'll manage it."

**Example:** Azure Virtual Machine

---

### PaaS

You say:

> "I have the application. You manage more of the platform, and I'll focus on my application."

**Example:** Azure App Service

---

### SaaS

You say:

> "I don't want to build or manage the application. I just want to use it."

**Example:** Microsoft 365

---

## Think About It Like This

```text
             MORE CONTROL
                  │
                  ▼
               IaaS
          Azure Virtual Machine
                  │
                  │
                  ▼
               PaaS
          Azure App Service
                  │
                  │
                  ▼
               SaaS
            Microsoft 365
                  │
                  ▼
           LESS MANAGEMENT
```

As you move from **IaaS → PaaS → SaaS**, more of the underlying infrastructure and platform is managed for you.

But remember:

**SaaS is not automatically better than PaaS, and PaaS is not automatically better than IaaS.**

It depends on your requirement.

---

# One Real-World Example

Let's imagine you're working for an e-commerce company.

You have three different requirements.

### Requirement 1 — Legacy Application

You have an old application that needs a specific Windows Server configuration.

You need full control.

**Azure Virtual Machine → IaaS**

---

### Requirement 2 — New Web Application

Your developers have built a web application.

They don't want to spend their time patching operating systems.

They just want to deploy the application.

**Azure App Service → PaaS**

---

### Requirement 3 — Employee Productivity

Your employees need email, documents, meetings, and collaboration tools.

You don't want to build those applications yourself.

**Microsoft 365 → SaaS**

And here's something important:

**A company can use all three at the same time.**

For example:

```text
E-Commerce Company
│
├── Legacy Application
│       └── Azure VM → IaaS
│
├── Web Application
│       └── App Service → PaaS
│
└── Employee Collaboration
        └── Microsoft 365 → SaaS
```

That's how you should think about these models in the real world.

---

# Day 2 — What You Should Take Away

By the end of this day, you should not just know the terms.

You should understand the thinking behind them.

When you create something in Azure, ask yourself:

**Where should I deploy it?**

→ That's where **Regions and Availability Zones** come into the picture.

**How much control do I need over the infrastructure?**

→ That's where **IaaS, PaaS, and SaaS** come into the picture.

And as we move through this series, you'll start seeing these concepts again and again.

We're not learning these terms just for interviews.

We're learning them because they are the foundation for the Azure architecture we'll build in the upcoming days.

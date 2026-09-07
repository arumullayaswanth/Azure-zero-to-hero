# Day 1: Understanding Cloud Concepts, Vocabulary and Terminology

Before we start working with Azure services, we need to understand some basic cloud terms. You will see these words everywhere in Azure, so let's understand them in a simple way.

---

## What is Cloud?

Let's say you want to start a company and you need servers to run your application.

The traditional way is: **buy servers → set up a data center → install everything → maintain the hardware.**

That's expensive and takes time.

With cloud, you don't need to buy the physical servers yourself. You can go to Azure, create the resources you need, use them, and pay for what you use.

So, when we say **"cloud"**, think of it as **someone else providing the infrastructure that you can use over the internet.**

---

## Public, Private and Hybrid Cloud

Let's take a simple company example.

### Public Cloud

Suppose your company doesn't want to buy servers. You simply use Microsoft Azure's infrastructure.

That's **Public Cloud**.

The infrastructure belongs to the cloud provider, and many different customers use the cloud platform.

**Example:**
Your application is running on Azure Virtual Machines.

---

### Private Cloud

Now imagine a large bank.

The bank may have strict security and compliance requirements, so it wants its cloud infrastructure dedicated to its own organization.

That's **Private Cloud**.

The infrastructure is dedicated to one organization.

---

### Hybrid Cloud

Now imagine the same bank keeps its highly sensitive systems in its own private environment but uses Azure for applications that don't need to stay there.

Now you're using both environments together.

That's **Hybrid Cloud**.

**Simple way to remember:**

**Public = Provider's infrastructure**
**Private = Your organization's dedicated infrastructure**
**Hybrid = Combination of both**

---

# What is Cloud Computing?

Cloud and cloud computing are closely related, but don't get confused by the terminology.

When we use **servers, storage, databases, networking, or other computing resources through the cloud**, that's cloud computing.

For example, you have a website and need a server.

Instead of purchasing a physical server, you open Azure and create a Virtual Machine.

You now have a server without physically owning one.

**That's cloud computing.**

---

# Cloud Vocabulary

These are the terms you'll hear again and again when working with Azure.

---

## Virtualization

Imagine you have **one powerful physical server**.

Instead of using that server for only one application, you can divide its resources and run multiple virtual computers on it.

That's **virtualization**.

Think about an apartment building.

You have **one building**, but inside it you have many separate apartments.

Similarly:

**One physical server → Multiple Virtual Machines**

---

## Virtual Machine

A Virtual Machine, or **VM**, is basically a computer created using software instead of buying a physical computer.

For example, from your laptop you can go to Azure and create an **Ubuntu VM**.

That VM can have:

* CPU
* RAM
* Disk
* Operating system
* Applications

From your point of view, you're working with a computer. The difference is that the physical hardware is somewhere inside Microsoft's data center.

---

## API

Let's say you're using the Azure Portal and you click **"Create Virtual Machine."**

You might think Azure Portal itself is creating the VM.

Behind the scenes, the portal is communicating with Azure services using **APIs**.

An API is basically a **way for one software system to talk to another software system.**

For example:

**Azure Portal → Azure API → Create VM**

And you don't have to use the portal every time. You can also use Azure CLI, PowerShell, Terraform, or your own application to interact with Azure through APIs.

---

## Regions

Now let's say you want to deploy your application in Azure.

Azure has data centers in different parts of the world.

These geographical locations are called **Regions**.

For example:

* Central India
* East US
* West Europe

If most of your customers are in India, you might choose an Azure region closer to them.

Why?

Because generally, the closer your application is to your users, the better the network response can be.

---

## Availability Zones

Now imagine your application is running in an Azure region.

What happens if there is a problem with one data center?

This is where **Availability Zones** come in.

An Azure region can have multiple physically separate zones.

You can place your application across different zones.

So if one zone has a problem, your application can continue running from another zone.

Think about it like this:

**Region**

→ Zone 1
→ Zone 2
→ Zone 3

The important point is:

**Availability Zones are physically separate locations inside a region.**

---

## Scalability

Imagine you have an application running on **2 servers**.

Normally, that's enough.

But suddenly you're running a big sale and thousands of additional users start accessing your application.

Those 2 servers may not be enough anymore.

So you add more resources or more servers.

That's **scalability**.

In simple words:

**Workload increases → You increase resources.**

---

## Elasticity

Elasticity is closely related to scalability.

Let's continue the same example.

Your sale starts, and traffic increases.

Azure automatically adds more resources.

After the sale ends, traffic goes down, so Azure automatically removes the resources you no longer need.

That's **elasticity**.

So remember it like this:

**Scalability = ability to increase/decrease capacity**

**Elasticity = capacity automatically adjusts with demand**

---

## Agility

Imagine your company needs a new server.

In the traditional world, you might need to:

Order hardware → wait for delivery → install it → configure it → make it available.

That could take days or weeks.

With Azure, you can create a VM within minutes.

That ability to **quickly create, change, and experiment with infrastructure** is what we mean by **agility**.

This is one of the biggest advantages of cloud.

---

## High Availability

Let's say your application is running on only one server.

If that server crashes, your application goes down.

Instead, you could run your application on multiple servers.

If one server goes down, another server can continue serving users.

That's **High Availability**.

The goal is simple:

**Keep the application available with as little downtime as possible.**

---

## Fault Tolerance

Now let's make it slightly stronger.

Suppose one component fails.

A fault-tolerant system is designed so that the failure doesn't stop the overall system from working.

For example:

**Server 1 ❌**

But:

**Server 2 ✅ → Application continues**

The system is designed to tolerate that failure.

---

## Disaster Recovery

Now imagine something much bigger happens.

Your entire Azure region becomes unavailable.

What are you going to do?

This is where **Disaster Recovery (DR)** comes in.

You may have backups or a copy of your application running somewhere else.

If the primary environment goes down, you recover the application from the backup or secondary environment.

That's disaster recovery.

**High Availability** is mainly about staying available during failures.

**Disaster Recovery** is about recovering after a major disaster.

---

## Load Balancing

Imagine you have three servers:

**Server 1**
**Server 2**
**Server 3**

Now 10,000 users are accessing your application.

You don't want all 10,000 users going to Server 1 while Server 2 and Server 3 are sitting idle.

So you put a **Load Balancer** in front.

The load balancer receives the incoming requests and distributes them across the available servers.

Something like:

**Users → Load Balancer → Server 1**
　　　　　　　　　　→ **Server 2**
　　　　　　　　　　→ **Server 3**

This helps prevent a single server from becoming overloaded.


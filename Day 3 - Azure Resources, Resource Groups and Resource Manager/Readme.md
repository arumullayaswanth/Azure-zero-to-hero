# Day 3: Resources, Resource Groups & Resource Manager

Short and simple. Follow the steps. ✅

---

## Quick Meaning

- **Resource** → one thing you create (Storage Account, VM, Database).
- **Resource Group** → a folder that holds related resources.
- **Resource Manager (ARM)** → the layer that creates and manages everything.

---

## Step 1: Log in
1. Go to https://portal.azure.com
2. Sign in.

## Step 2: Create a Resource Group
1. Search `Resource groups` in the top bar → click it.
2. Click **+ Create**.
3. **Resource group**: `rg-day3-practice`
4. **Region**: pick one close to you.
5. Click **Review + create** → **Create**.

## Step 3: Create a Resource inside it
1. Open your group `rg-day3-practice`.
2. Click **+ Create** → search `Storage account` → **Create**.
3. **Name**: `stday3practice123` (lowercase, unique).
4. **Region**: same as group.
5. Click **Review + create** → **Create**.

## Step 4: See ARM at work
1. Open `rg-day3-practice`.
2. Left menu → **Deployments**.
3. You'll see the history of what ARM built.

## Step 5: Clean up
1. Open `rg-day3-practice`.
2. Click **Delete resource group** → type the name → **Delete**.

---

## ✅ Done
- Resource = the service you create
- Resource Group = the folder
- Resource Manager = the manager behind it all

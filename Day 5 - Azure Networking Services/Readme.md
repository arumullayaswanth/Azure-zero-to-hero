# Day 5: Azure Networking Services

Short and simple. The core building blocks of Azure networking.

---

## Quick Meaning

- **Virtual Network (VNet)** → your own private network in Azure.
- **Subnet** → a smaller section inside a VNet.
- **CIDR** → the IP range notation (e.g. `10.0.0.0/16`).
- **Route Table** → rules for where network traffic goes.
- **NSG (Network Security Group)** → a firewall for subnets/VMs (allow/deny ports).
- **ASG (Application Security Group)** → group VMs by role to apply NSG rules easily.

---

## Real-World Example

```text
VNet 10.0.0.0/16
├── Subnet: web   10.0.1.0/24  → web servers
├── Subnet: app   10.0.2.0/24  → app servers
└── Subnet: data  10.0.3.0/24  → databases
```

Each subnet holds one tier. NSGs control who can talk to whom.

---

## Step 1: Create a Virtual Network
1. Portal → search `Virtual networks` → **+ Create**.
2. **Resource group**: `rg-day5-net`
3. **Name**: `vnet-day5`
4. **Region**: pick one close to you.
5. **IP address space**: `10.0.0.0/16`

## Step 2: Add Subnets
1. In the **Subnets** tab, add:
   - `web` → `10.0.1.0/24`
   - `app` → `10.0.2.0/24`
   - `data` → `10.0.3.0/24`
2. Click **Review + create** → **Create**.

## Step 3: Create a Network Security Group (NSG)
1. Portal → search `Network security groups` → **+ Create**.
2. **Name**: `nsg-web` → same resource group/region → **Create**.
3. Open it → **Inbound security rules** → **+ Add**:
   - Allow `HTTP (80)` and `HTTPS (443)` from Internet.
   - Allow `SSH (22)` only from your IP.

## Step 4: Attach NSG to a Subnet
1. Open `nsg-web` → **Subnets** → **+ Associate**.
2. Select `vnet-day5` → subnet `web` → **OK**.

## Step 5: Route Table (optional)
1. Portal → search `Route tables` → **+ Create** → `rt-day5`.
2. Add a route (e.g. force traffic through a firewall/appliance).
3. Associate it with a subnet.

## Step 6: Clean up
1. Delete resource group `rg-day5-net`.

---

## ✅ Remember
- VNet = private network, Subnet = section of it.
- NSG = allow/deny traffic (your firewall rules).
- ASG = group VMs by role for simpler NSG rules.
- Route Table = control the path traffic takes.

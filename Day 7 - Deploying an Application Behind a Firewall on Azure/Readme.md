# Day 7: Deploying an Application Behind a Firewall — Project 2

Hands-on project. Deploy a web app on a VM, keep it private, and expose it safely through Azure Firewall. Steps only. ✅

---

## What We Build

```text
Internet
   │
Azure Firewall  (public entry point)
   │
VNet 10.0.0.0/16
├── Subnet: AzureFirewallSubnet
├── Subnet: workload  → App VM (private, no public IP)
└── Azure Bastion     → secure admin access
```

The app VM has **no public IP**. Users reach it only through the firewall. You manage it through **Bastion** (no SSH from the internet).

---

## Step 1: Networking Setup
1. Portal → create resource group `rg-day7-fw`.
2. Create a VNet `vnet-day7` with address space `10.0.0.0/16`.
3. Add subnets:
   - `AzureFirewallSubnet` → `10.0.1.0/26`
   - `AzureBastionSubnet`  → `10.0.2.0/26`
   - `workload`            → `10.0.3.0/24`

## Step 2: Create the App VM (private)
1. Create a VM `vm-app` in the `workload` subnet.
2. **Image**: Ubuntu 22.04, **Size**: `Standard_B1s`.
3. **Public IP**: set to **None** (keep it private).
4. Username `azureuser`, SSH key or password.

## Step 3: Add Azure Bastion (secure access)
1. Portal → search `Bastion` → **+ Create**.
2. Place it in `AzureBastionSubnet` of `vnet-day7`.
3. **Create**. Now connect to `vm-app` via Bastion (browser, no public IP needed).

## Step 4: Deploy the Application
1. Connect to `vm-app` through Bastion.
2. Install the web server:
   ```bash
   sudo apt update
   sudo apt install nginx -y
   sudo systemctl enable --now nginx
   echo "<h1>App running behind Azure Firewall - Day 7</h1>" | sudo tee /var/www/html/index.html
   ```

## Step 5: Create Azure Firewall
1. Portal → search `Firewalls` → **+ Create** → `fw-day7`.
2. Place it in `AzureFirewallSubnet` of `vnet-day7`.
3. Give it a new public IP. **Create**.
4. Note the firewall's **public IP**.

## Step 6: Route Traffic Through the Firewall
1. Create a route table `rt-day7`.
2. Add a default route `0.0.0.0/0` → next hop = the firewall private IP.
3. Associate `rt-day7` with the `workload` subnet.

## Step 7: Firewall Rule to Reach the App (DNAT)
1. Open `fw-day7` → **Rules** → **NAT rule collection** → **+ Add**.
2. Rule:
   - **Source**: `*` (or your IP)
   - **Destination**: firewall public IP, port `80`
   - **Translated address**: `vm-app` private IP, port `80`
3. Save.

## Step 8: Test
1. In your browser open:
   ```text
   http://<FIREWALL_PUBLIC_IP>
   ```
2. You should see **"App running behind Azure Firewall - Day 7"**. ✅
3. The VM itself has no public IP — traffic only flows through the firewall.

## Step 9: Troubleshooting
- No page? Check the NAT rule ports and the route table association.
- Can't connect to VM? Use Bastion, not direct SSH.
- Still stuck? Check NSG rules on the `workload` subnet allow port 80.

## Step 10: Clean up
1. Delete resource group `rg-day7-fw` (removes firewall, VM, Bastion, VNet).

---

## ✅ Remember
- App VM stays **private** (no public IP).
- **Firewall** is the only public entry point.
- **Bastion** gives secure admin access without exposing SSH.
- **Route table + NAT rule** connect the internet to your private app safely.

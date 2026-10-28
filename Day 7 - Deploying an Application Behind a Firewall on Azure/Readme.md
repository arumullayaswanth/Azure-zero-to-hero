# Day 7: Deploying an Application Behind a Firewall — Project 2

Hands-on project. Deploy a web app on a private VM and expose it safely through Azure Firewall. Steps only. ✅

---

## What We Build

```text
Internet
   │
Azure Firewall  (public entry point)
   │
VNet 10.0.0.0/16
├── Subnet: AzureFirewallSubnet   (firewall)
├── Subnet: AzureBastionSubnet    (secure admin access)
└── Subnet: workload              → App VM (private, no public IP)
```

The app VM has **no public IP**. Users reach it only through the firewall. You manage it through **Bastion** (no SSH from the internet).

---

## Step 1: Create the VNet + Firewall together
> Tip: You can enable Azure Firewall directly inside the VNet creation wizard — it auto-creates the firewall subnet and firewall for you.

1. Portal → create resource group `rg-day7-fw`.
2. Portal → search `Virtual networks` → **+ Create**.
3. **Name**: `vnet-day7`, **Address space**: `10.0.0.0/16`.
4. In the **Security** tab of the wizard:
   - **Enable Azure Firewall** → ✅
   - Firewall name: `fw-day7`
   - It auto-creates the `AzureFirewallSubnet` and a public IP.
   - (Optional) **Enable Azure Bastion** → ✅ as well.
5. Add the workload subnet:
   - `workload` → `10.0.3.0/24`
6. **Review + create** → **Create**.
7. After it deploys, open `fw-day7` and copy its **public IP** and **private IP**.

## Step 2: Create the App VM (private)
1. Create a VM `vm-app` in the `workload` subnet.
2. **Image**: Ubuntu 22.04, **Size**: `Standard_B1s`.
3. **Public IP**: set to **None** (keep it private).
4. Username `azureuser`, SSH key or password.

## Step 3: NSG with ports 22 and 80
> This matches what you selected — only SSH and HTTP.

1. The VM's NSG should allow:
   - `SSH (22)` — for admin (ideally only from your IP or Bastion).
   - `HTTP (80)` — so the firewall can reach the app.
2. If needed: open the NSG → **Inbound security rules** → **+ Add** → add ports `22` and `80` (Allow).

## Step 4: Connect with Bastion and deploy the app
1. Open `vm-app` → **Connect** → **Bastion** → log in.
2. Install the web server:
   ```bash
   sudo apt update
   sudo apt install nginx -y
   sudo systemctl enable --now nginx
   echo "<h1>App running behind Azure Firewall - Day 7</h1>" | sudo tee /var/www/html/index.html
   ```

## Step 5: Route traffic through the firewall
> A route matches an IP range (not a single port). Use `0.0.0.0/0` and send it to the firewall.

1. Create a route table `rt-day7`.
2. Add a route:
   - **Address prefix**: `0.0.0.0/0`
   - **Next hop type**: `Virtual appliance`
   - **Next hop address**: firewall **private IP**
3. Associate `rt-day7` with the `workload` subnet.

## Step 6: Firewall NAT rule (this is what forwards port 80 to the app)
1. Open `fw-day7` → **Rules** → **NAT rule collection** → **+ Add**.
2. Rule:
   - **Source**: `*` (or your IP)
   - **Destination address**: firewall **public IP**
   - **Destination port**: `80`
   - **Translated address**: `vm-app` **private IP**
   - **Translated port**: `80`
3. Save.

## Step 7: Test
1. In your browser open:
   ```text
   http://<FIREWALL_PUBLIC_IP>
   ```
2. You should see **"App running behind Azure Firewall - Day 7"**. ✅
3. The VM has no public IP — traffic only flows through the firewall.

## Step 8: Troubleshooting
- No page? Check the **NAT rule** ports (80 → 80) and the firewall public IP.
- Check the **route table** is associated with the `workload` subnet and points to the firewall private IP.
- Check the **NSG** allows port 80 inbound.
- Can't connect to VM? Use **Bastion**, not direct SSH.

## Step 9: Clean up
1. Delete resource group `rg-day7-fw` (removes firewall, VM, Bastion, VNet).

---

## ✅ Remember
- Enabling the firewall during VNet creation is a valid shortcut — it builds the firewall subnet for you.
- NSG with **22 + 80** is enough for the VM.
- A **route** matches an IP range (`0.0.0.0/0`), not a single port — it sends traffic to the firewall.
- The **NAT rule** on the firewall is what actually forwards port 80 to your private VM.

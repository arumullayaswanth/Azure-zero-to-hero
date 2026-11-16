# Day 6: Advanced Networking Services

Short and simple. The networking services you use in real projects.

---

## Quick Meaning

- **Application Gateway + WAF** → smart load balancer for web apps (Layer 7) + Web Application Firewall to block attacks.
- **Load Balancer** → spreads traffic across servers (Layer 4).
- **Azure DNS** → hosts your domain names in Azure.
- **Azure Firewall** → managed, central network firewall for your VNets.
- **VNet Peering** → connect two VNets so they talk privately.
- **VPN Gateway** → secure tunnel between Azure and your on-premises network.

---

## When to Use What

| Need | Use |
|------|-----|
| Route web traffic by URL/host, block attacks | Application Gateway + WAF |
| Simple fast traffic spread (TCP/UDP) | Load Balancer |
| Manage domain names | Azure DNS |
| Central firewall for all VNets | Azure Firewall |
| Connect two Azure VNets | VNet Peering |
| Connect office/on-prem to Azure | VPN Gateway |

---

## Step 1: Create a Load Balancer
1. Portal → search `Load balancers` → **+ Create**.
2. **Resource group**: `rg-day6-net`, **Name**: `lb-day6`.
3. **Type**: Public, **SKU**: Standard.
4. Add a **frontend IP**, a **backend pool** (your VMs), and a **health probe**.
5. Add a **load balancing rule** (e.g. port 80 → backend 80).
6. **Review + create** → **Create**.

## Step 2: Create an Application Gateway (with WAF)
1. Portal → search `Application gateways` → **+ Create**.
2. **Name**: `appgw-day6`, same resource group.
3. **Tier**: `WAF V2` (enables the Web Application Firewall).
4. Choose your VNet + a dedicated subnet for the gateway.
5. Add frontend IP, backend pool, and routing rule.
6. **Review + create** → **Create**.

## Step 3: Set up Azure DNS
1. Portal → search `DNS zones` → **+ Create** → enter your domain (e.g. `example.com`).
2. Add record sets (A, CNAME) pointing to your resources.
3. Update your domain registrar to use Azure name servers.

## Step 4: Create Azure Firewall
1. Portal → search `Firewalls` → **+ Create** → `fw-day6`.
2. Place it in a subnet named `AzureFirewallSubnet`.
3. Add network/application rules to allow or deny traffic.

## Step 5: VNet Peering
1. Open a VNet → **Peerings** → **+ Add**.
2. Select the other VNet → enable traffic both ways → **Add**.

## Step 6: VPN Gateway (connect on-prem)
1. Portal → search `Virtual network gateways` → **+ Create**.
2. Choose VPN type, SKU, and your VNet.
3. Configure the on-prem device with the shared key.

## Step 7: Clean up
1. Delete resource group `rg-day6-net`.

---

## ✅ Remember
- App Gateway = Layer 7 (web, URL-based) + WAF for security.
- Load Balancer = Layer 4 (fast, simple).
- Firewall = central protection. Peering = VNet-to-VNet. VPN Gateway = on-prem to Azure.

# Day 4: Azure Virtual Machines — Hands-On Steps

Steps only. Just follow each step in order. ✅

---

## PART A — Create a Virtual Machine

1. Go to https://portal.azure.com and log in.
2. In the top search bar, type `Virtual machines` and click it.
3. Click **+ Create** → **Azure virtual machine**.
4. Fill in the **Basics** tab:
   - **Subscription**: leave as-is
   - **Resource group**: click **Create new** → name it `rg-day4-vm`
   - **Virtual machine name**: `vm-day4`
   - **Region**: pick one close to you (e.g. `Central India` / `East US`)
   - **Image**: `Ubuntu Server 22.04 LTS`
   - **Size**: `Standard_B1s` (cheap)
   - **Authentication type**: `SSH public key`
   - **Username**: `azureuser`
   - **SSH public key source**: `Generate new key pair`
   - **Key pair name**: `vm-day4-key`
5. Under **Inbound port rules**:
   - **Public inbound ports**: `Allow selected ports`
   - **Select inbound ports**: check `SSH (22)` and `HTTP (80)`
6. Click **Review + create**.
7. Wait for ✅ **Validation passed**, then click **Create**.
8. A popup appears → click **Download private key and create resource**.
9. Save the `.pem` file (you'll need it to connect).
10. Wait for **"Your deployment is complete."**
11. Click **Go to resource**.
12. Copy the **Public IP address** shown on the VM overview page.

---

## PART B — Connect to the Virtual Machine (SSH)

1. Open a terminal (Command Prompt / PowerShell / Git Bash).
2. Go to the folder where the `.pem` key was saved:
   ```bash
   cd Downloads
   ```
3. Fix key permissions (skip if on Windows CMD):
   ```bash
   chmod 400 vm-day4-key.pem
   ```
4. Connect (replace `<PUBLIC-IP>` with the IP you copied):
   ```bash
   ssh -i vm-day4-key.pem azureuser@<PUBLIC-IP>
   ```
5. Type `yes` when asked to continue.
6. You are now inside the VM. ✅

---

## PART C — Deploy Your First App (Nginx web server)

1. Inside the VM, update packages:
   ```bash
   sudo apt update
   ```
2. Install Nginx:
   ```bash
   sudo apt install nginx -y
   ```
3. Start Nginx:
   ```bash
   sudo systemctl start nginx
   ```
4. Enable it on boot:
   ```bash
   sudo systemctl enable nginx
   ```
5. In your browser, open:
   ```text
   http://<PUBLIC-IP>
   ```
6. You should see the **"Welcome to nginx!"** page. ✅

### (Optional) Show your own page
1. Replace the default page:
   ```bash
   echo "<h1>Hello from my Azure VM - Day 4</h1>" | sudo tee /var/www/html/index.html
   ```
2. Refresh the browser → you'll see your message.

---

## PART D — Virtual Machine Scale Set (Autoscaling)

1. In the portal top search bar, type `Virtual machine scale sets` and click it.
2. Click **+ Create**.
3. Fill in **Basics**:
   - **Resource group**: `rg-day4-vm`
   - **Scale set name**: `vmss-day4`
   - **Region**: same as before
   - **Orchestration mode**: `Uniform`
   - **Image**: `Ubuntu Server 22.04 LTS`
   - **Size**: `Standard_B1s`
   - **Username**: `azureuser`
   - **Authentication**: SSH public key or password
4. Go to the **Scaling** tab:
   - **Initial instance count**: `2`
   - **Scaling policy**: `Custom`
   - **Minimum**: `2`, **Maximum**: `5`
   - **Scale out** when CPU > `75%`
   - **Scale in** when CPU < `25%`
5. Click **Review + create**.
6. Wait for ✅ **Validation passed**, then click **Create**.
7. Wait for **"Your deployment is complete."** ✅

---

## PART E — Clean Up (avoid charges 💰)

1. Search `Resource groups` in the top bar.
2. Click `rg-day4-vm`.
3. Click **Delete resource group** (top).
4. Type `rg-day4-vm` to confirm.
5. Click **Delete**.

---

## ✅ Checklist

- [ ] Created VM `vm-day4`
- [ ] Connected via SSH
- [ ] Installed Nginx and opened it in the browser
- [ ] Created scale set `vmss-day4`
- [ ] Deleted the resource group to clean up

---

## 🎁 Bonus: CLI Version (optional)

```bash
# Create resource group
az group create --name rg-day4-cli --location eastus

# Create VM
az vm create \
  --resource-group rg-day4-cli \
  --name vm-day4-cli \
  --image Ubuntu2204 \
  --size Standard_B1s \
  --admin-username azureuser \
  --generate-ssh-keys

# Open port 80
az vm open-port --resource-group rg-day4-cli --name vm-day4-cli --port 80

# Clean up
az group delete --name rg-day4-cli --yes --no-wait
```

---

**Done! See you on Day 5. 👋**

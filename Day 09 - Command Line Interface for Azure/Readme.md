# Day 9: Command Line Interface for Azure (Azure CLI)

Short and simple. Create and manage Azure resources from the command line.

---

## Why Azure CLI?

- Faster than clicking in the portal.
- Repeatable — save commands in scripts.
- Works on Windows, Mac, Linux, and in the browser (Cloud Shell).

> ⚠️ **PowerShell vs Bash:** The commands below are on a **single line** so they work in both.
> - In **Bash**, the line-continuation character is `\`.
> - In **PowerShell**, it's a backtick `` ` `` (NOT `\`). If you use `\` in PowerShell you'll get "Missing expression after unary operator '--'".
> - `$RANDOM` only works in **Bash**. In PowerShell, use a fixed number in the name instead.

---

## Step 1: Get Azure CLI
**Option A — Cloud Shell (easiest, nothing to install)**
1. In the portal, click the `>_` icon at the top.
2. Choose **Bash**. CLI is ready.

**Option B — Install locally**
- Windows: download the MSI from https://aka.ms/installazurecliwindows
- Mac: `brew install azure-cli`
- Linux: `curl -L https://aka.ms/InstallAzureCli | bash`

Check it works:
```bash
az version
```

## Step 2: Log in
```bash
az login
```
A browser opens → sign in. (Skip this in Cloud Shell — already logged in.)

See your subscriptions:
```bash
az account show
az account list --output table
```

## Step 3: Create a Resource Group
```bash
az group create --name rg-day9-cli --location eastus
```

## Step 4: Create a Storage Account
```bash
az storage account create --name stday9cli12345 --resource-group rg-day9-cli --location eastus --sku Standard_LRS
```

## Step 5: Create a Virtual Machine
Single line:
```bash
az vm create --resource-group rg-day9-cli --name vm-day9 --image Ubuntu2204 --size Standard_B1s --admin-username azureuser --generate-ssh-keys --debug
```
- Check which VM sizes are actually available to you in that region:
```bash
az vm list-skus --location eastus --size Standard_B --output table
```

Open ports 80 and 22:
```bash
az vm open-port --resource-group rg-day9-cli --name vm-day9 --port 80 --priority 1001
az vm open-port --resource-group rg-day9-cli --name vm-day9 --port 22 --priority 1002
```

## Step 6: Connect to the VM (automatic)

**Easiest — `az ssh` auto-connects (finds IP + key for you):**
```bash
az ssh vm --resource-group rg-day9-cli --name vm-day9
```
First time only, add the extension if prompted:
```bash
az extension add --name ssh
```

**Or connect manually with the public IP:**
```bash
az vm show -d --resource-group rg-day9-cli --name vm-day9 --query publicIps -o tsv
ssh azureuser@<PUBLIC-IP>
```

**Private VM (no public IP)? Connect through Bastion:**
```bash
az network bastion ssh --name <bastion-name> --resource-group rg-day9-cli --target-resource-id <vm-id> --auth-type ssh-key --username azureuser --ssh-key ~/.ssh/id_rsa
```

## Step 7: List and Inspect
```bash
# list all resource groups
az group list --output table

# list VMs
az vm list --output table

# show details of one VM
az vm show --resource-group rg-day9-cli --name vm-day9
```

## Step 8: Clean up
```bash
az group delete --name rg-day9-cli --yes --no-wait
```

---

## Handy Commands Cheat Sheet

| Task | Command |
|------|---------|
| Login | `az login` |
| Set subscription | `az account set --subscription "<name or id>"` |
| Create RG | `az group create -n <name> -l <region>` |
| Delete RG | `az group delete -n <name> --yes` |
| List resources in RG | `az resource list -g <name> -o table` |
| Help for any command | `az <command> --help` |

---

## ✅ Remember
- Use `--output table` (or `-o table`) for readable results.
- `$RANDOM` helps make storage names unique.
- `az <command> --help` shows all options for anything.
- Cloud Shell needs no install and is already logged in.

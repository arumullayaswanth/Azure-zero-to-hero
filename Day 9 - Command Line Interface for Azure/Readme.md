# Day 9: Command Line Interface for Azure (Azure CLI)

Short and simple. Create and manage Azure resources from the command line.

---

## Why Azure CLI?

- Faster than clicking in the portal.
- Repeatable — save commands in scripts.
- Works on Windows, Mac, Linux, and in the browser (Cloud Shell).

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
az storage account create \
  --name stday9cli$RANDOM \
  --resource-group rg-day9-cli \
  --location eastus \
  --sku Standard_LRS
```

## Step 5: Create a Virtual Machine
```bash
az vm create \
  --resource-group rg-day9-cli \
  --name vm-day9 \
  --image Ubuntu2204 \
  --size Standard_B1s \
  --admin-username azureuser \
  --generate-ssh-keys
```

Open port 80:
```bash
az vm open-port --resource-group rg-day9-cli --name vm-day9 --port 80
```

## Step 6: List and Inspect
```bash
# list all resource groups
az group list --output table

# list VMs
az vm list --output table

# show details of one VM
az vm show --resource-group rg-day9-cli --name vm-day9
```

## Step 7: Clean up
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

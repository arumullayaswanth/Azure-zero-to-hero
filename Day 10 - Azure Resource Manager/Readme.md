# Day 10: Azure Resource Manager (ARM) & Templates

Short and simple. Deploy resources as code with ARM templates and Bicep.

---

## Quick Meaning

- **ARM** → the management layer that creates/updates/deletes all Azure resources.
- **ARM Template** → a JSON file that describes what to deploy (Infrastructure as Code).
- **Bicep** → a simpler language that compiles down to ARM JSON (easier to read/write).

```text
You → ARM Template / Bicep → Azure Resource Manager → Resources
```

---

## Why Templates?

- **Repeatable** → deploy the same setup again and again.
- **Consistent** → no manual clicking mistakes.
- **Version-controlled** → store in Git, review changes.

---

## ARM Template vs Bicep vs CLI vs Terraform

| Tool | Language | Best for |
|------|----------|----------|
| **ARM Template** | JSON (verbose) | Native Azure IaC |
| **Bicep** | Clean DSL (compiles to ARM) | Easier Azure-only IaC |
| **Azure CLI** | Commands/scripts | Quick one-off tasks, automation scripts |
| **Terraform** | HCL (multi-cloud) | IaC across Azure + AWS + GCP |

Simple rule: **Bicep** for Azure-only IaC, **Terraform** for multi-cloud, **CLI** for quick actions.

---

## Step 1: Create a Resource Group
```bash
az group create --name rg-day10-arm --location eastus
```

## Step 2: Write a Bicep file
Create a file `storage.bicep`:
```bicep
param location string = resourceGroup().location
param storageName string = 'stday10${uniqueString(resourceGroup().id)}'

resource storage 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

output storageAccountName string = storage.name
```

## Step 3: Deploy the Bicep file
```bash
az deployment group create --resource-group rg-day10-arm --template-file storage.bicep
```

## Step 4: (Alternative) Deploy a raw ARM JSON template
```bash
az deployment group create --resource-group rg-day10-arm --template-file azuredeploy.json --parameters storageName=stday10demo123
```

## Step 5: Convert between ARM and Bicep
```bash
# Bicep → ARM JSON
az bicep build --file storage.bicep

# ARM JSON → Bicep
az bicep decompile --file azuredeploy.json
```

## Step 6: Check the deployment
```bash
az deployment group list --resource-group rg-day10-arm --output table
```

## Step 7: Clean up
```bash
az group delete --name rg-day10-arm --yes --no-wait
```

---

## ✅ Remember
- ARM is the engine; templates/Bicep are the instructions you give it.
- **Bicep = easy, readable** version of ARM JSON.
- Use `az deployment group create` to deploy a template.
- Store templates in Git so infrastructure is versioned and repeatable.

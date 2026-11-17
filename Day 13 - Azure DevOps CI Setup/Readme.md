# Day 13: Azure DevOps — CI Setup — Project 3

Set up **Continuous Integration (CI)** for the **Voting App** using Azure DevOps Pipelines.
Follow the steps in order, top to bottom. ✅

**What CI does:** every time you push code, the pipeline runs 3 stages →
**Build** the Docker image → **Push** it to Azure Container Registry (ACR) → **Update** the K8s manifest (sets up CD for Day 14).

---

## Order of Steps (overview)

We use the **Microsoft-hosted agent** (`ubuntu-latest`) so you can run CI right away —
no VM needed. The self-hosted agent VM is optional (STEP 10) for later.

```text
1. Import app code into Azure Repos
2. Create a Resource Group
3. Create an Azure Container Registry (ACR)
4. Create a Service Connection (DevOps → ACR)
5. Create the Pipeline (add YAML)
6. Add the update script
7. Run the pipeline
8. Verify the image in ACR
9. (Reference) ACR pull secret
10. (Optional, later) Set up a Self-Hosted Agent VM
11. Clean up
```

> ⚠️ If running the pipeline gives "no hosted parallelism has been purchased or granted",
> your org doesn't have the free Microsoft-hosted grant yet. In that case, do STEP 10
> (self-hosted agent) and change the pipeline `pool` to `name: 'azureagent'`.

---

## The Voting App (5 microservices)

| Service | Tech | Job |
|---------|------|-----|
| **vote** | Python | User votes between two options |
| **redis** | Redis | Collects new votes |
| **worker** | .NET | Consumes votes, stores in DB |
| **db** | PostgreSQL | Stores votes |
| **result** | Node.js | Shows results live |

We build CI for the **vote** service (same pattern for worker/result).

---

## STEP 1 — Import the App Code into Azure Repos
1. Open the voting app repo: https://github.com/dockersamples/example-voting-app
2. In **Azure DevOps** → your project → **Repos** → **Import a repository**.
3. Paste the GitHub URL → **Import**.
4. The `vote`, `result`, `worker` folders now live in your Azure Repo. ✅

---

## STEP 2 — Create a Resource Group
1. Azure Portal → search `Resource groups` → **+ Create**.
2. **Resource group**: `rg-day13-ci`
3. **Region**: pick one close to you (e.g. `Central India`).
4. **Review + create** → **Create**.

CLI:
```bash
az group create --name rg-day13-ci --location centralindia
```

---

## STEP 3 — Create an Azure Container Registry (ACR)
1. Azure Portal → search `Container registries` → **+ Create**.
2. **Resource group**: `rg-day13-ci`
3. **Registry name**: `yournameazurecicd` (lowercase, unique)
4. **SKU**: Basic → **Review + create** → **Create**.
5. Open the registry → **Settings** → **Access keys** → turn **Admin user** ON (note the username/password; used later for the K8s secret).

CLI:
```bash
az acr create --resource-group rg-day13-ci --name yournameazurecicd --sku Basic
```

---

## STEP 4 — Create the Service Connection (DevOps → ACR)
1. Azure DevOps → **Project settings** → **Service connections** → **New service connection**.
2. Choose **Docker Registry** → **Azure Container Registry**.
3. Select your subscription + your ACR → name it `acr-connection` → **Save**.

---

## STEP 5 — Create the Pipeline
1. Azure DevOps → **Pipelines** → **Create Pipeline**.
2. Choose **Azure Repos Git** → select your `voting-app` repo.
3. Choose **Starter pipeline** → replace all content with the YAML below.
4. Replace the placeholder values (service connection id, ACR name).

### `vote-pipeline.yaml`
```yaml
trigger:
  paths:
    include:
      - vote/*

resources:
  - repo: self

variables:
  dockerRegistryServiceConnection: '<your-service-connection-id>'
  imageRepository: 'votingapp'
  containerRegistry: '<yourname>azurecicd.azurecr.io'
  dockerfilePath: '$(Build.SourcesDirectory)/vote/Dockerfile'
  tag: '$(Build.BuildId)'

pool:
  vmImage: 'ubuntu-latest'    # Microsoft-hosted agent (no VM needed)
  # For a self-hosted agent instead, use:  name: 'azureagent'

stages:
- stage: Build
  displayName: Build
  jobs:
  - job: Build
    steps:
    - task: Docker@2
      displayName: Build an image
      inputs:
        containerRegistry: '$(dockerRegistryServiceConnection)'
        repository: '$(imageRepository)'
        command: 'build'
        Dockerfile: 'vote/Dockerfile'
        tags: '$(tag)'

- stage: Push
  displayName: Push
  jobs:
  - job: Push
    steps:
    - task: Docker@2
      displayName: Push an image
      inputs:
        containerRegistry: '$(dockerRegistryServiceConnection)'
        repository: '$(imageRepository)'
        command: 'push'
        tags: '$(tag)'

- stage: Update
  displayName: Update K8s Manifest
  jobs:
  - job: Update
    steps:
    - task: ShellScript@2
      inputs:
        scriptPath: 'scripts/updateK8sManifests.sh'
        args: 'vote $(imageRepository) $(tag)'
```

---

## STEP 6 — Add the Update Script (3rd stage / CD)
Create `scripts/updateK8sManifests.sh` in the repo:
```bash
#!/bin/bash
set -x
REPO_URL="https://<ACCESS-TOKEN>@dev.azure.com/<ORG>/voting-app/_git/voting-app"
git clone "$REPO_URL" /tmp/temp_repo
cd /tmp/temp_repo
sed -i "s|image:.*|image: <ACR-NAME>.azurecr.io/$2:$3|g" k8s-specifications/$1-deployment.yaml
git add .
git commit -m "Update Kubernetes manifest"
git push
rm -rf /tmp/temp_repo
```
This updates the deployment image tag so Argo CD / AKS picks it up in Day 14.

---

## STEP 7 — Run the Pipeline
1. Click **Save and run**.
2. The Microsoft-hosted agent (`ubuntu-latest`) runs **Build → Push → Update**.
3. Watch each stage finish green ✅.

---

## STEP 8 — Verify the Image in ACR
1. Portal → your ACR → **Services** → **Repositories**.
2. You should see `votingapp` with a tag = the build number.

CLI:
```bash
az acr repository list --name <yourname>azurecicd --output table
```

---

## STEP 9 — (Reference) ACR Pull Secret for Kubernetes
Used later in CD so AKS can pull from your private ACR:
```bash
kubectl create secret docker-registry <secret-name> \
  --namespace <namespace> \
  --docker-server=<acr-name>.azurecr.io \
  --docker-username=<sp-id-or-admin-user> \
  --docker-password=<sp-password-or-admin-key>
```

---

## STEP 10 — (Optional, later) Set Up a Self-Hosted Agent VM
Only needed if Microsoft-hosted agents are blocked ("no hosted parallelism").
Do this later, then change the pipeline `pool` to `name: 'azureagent'`.

**10.1 Create the VM**
1. Portal → **Virtual machines** → **+ Create**.
2. Resource group `rg-day13-ci`, name `azureagent`, Ubuntu 22.04, size `Standard_B2ts_v2`.
3. Allow SSH (22) → **Create** → copy the **public IP**.

**10.2 Install Docker on the VM**
```bash
ssh azureuser@<VM_PUBLIC_IP>
sudo apt update
sudo apt install docker.io -y
sudo usermod -aG docker azureuser
sudo systemctl restart docker
# log out and back in so the docker group applies
```

**10.3 Create the Agent Pool in Azure DevOps**
1. **Project settings** → **Agent pools** → **Add pool**.
2. Type: **Self-hosted**, name: `azureagent` → **Create**.

**10.4 Create a Personal Access Token (PAT)**
1. Top right → **User settings** → **Personal access tokens** → **+ New Token**.
2. Scope: **Agent Pools (Read & manage)** → **Create** → copy the token.

**10.5 Install and Configure the Agent (on the VM)**
```bash
mkdir myagent && cd myagent
curl -O <agent-download-url>     # URL from the pool's "New agent" screen
tar zxvf vsts-agent-linux-*.tar.gz
./config.sh                      # Server URL, PAT, pool = azureagent
./run.sh
```
The agent shows **Online** in the portal. Then set `pool: name: 'azureagent'` in the YAML.

---

## STEP 11 — Clean Up
```bash
az group delete --name rg-day13-ci --yes --no-wait
```
(If you created the self-hosted agent, stop it with `Ctrl + C` on the VM.)

---

## ✅ Remember
- **CI** = Build → Push → (Update manifest) on every code change.
- **Microsoft-hosted agent** (`ubuntu-latest`) lets you run CI with no VM.
- **Service connection** lets the pipeline log in to ACR.
- The **Update stage** edits the K8s manifest → sets up **CD** for Day 14.

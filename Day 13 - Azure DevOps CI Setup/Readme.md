# Day 13: Azure DevOps — CI Setup — Project 3

Set up **Continuous Integration (CI)** for the **Voting App** using Azure DevOps Pipelines.



**What CI does here:** every time you push code, the pipeline runs 3 stages →
**Build** the Docker image → **Push** it to Azure Container Registry (ACR) → **Update** the K8s manifest (sets up CD for Day 14).

---

## The Voting App (5 microservices)

| Service | Tech | Job |
|---------|------|-----|
| **vote** | Python | User votes between two options |
| **redis** | Redis | Collects new votes |
| **worker** | .NET | Consumes votes, stores in DB |
| **db** | PostgreSQL | Stores votes |
| **result** | Node.js | Shows results live |

We build CI for the **vote** service in this project (same pattern for worker/result).

---

## PART 1 — Get the Code into Azure Repos
1. Open the voting app repo: https://github.com/dockersamples/example-voting-app (or the video's fork).
2. In **Azure DevOps** → your project → **Repos** → **Import a repository**.
3. Paste the GitHub URL → **Import**.
4. The `vote`, `result`, `worker` folders now live in your Azure Repo.

---

## PART 2 — Create a Resource Group
1. Azure Portal → search `Resource groups` → **+ Create**.
2. **Resource group**: `rg-day13-ci`
3. **Region**: pick one close to you (e.g. `Central India`).
4. **Review + create** → **Create**.

Or CLI:
```bash
az group create --name rg-day13-ci --location centralindia
```

---

## PART 3 — Create an Azure Container Registry (ACR)
1. Azure Portal → search `Container registries` → **+ Create**.
2. **Resource group**: `rg-day13-ci` (the one you just created)
3. **Registry name**: `yournameazurecicd` (lowercase, unique)
4. **SKU**: Basic → **Review + create** → **Create**.
5. Open the registry → **Settings** → **Access keys** → turn **Admin user** ON (note the username/password; used later for the K8s secret).

Or CLI:
```bash
az acr create --resource-group rg-day13-ci --name yournameazurecicd --sku Basic
```

---

## PART 4 — Create a Self-Hosted Agent (on an Azure VM)
> The video uses a **self-hosted agent** because Microsoft-hosted agents need a paid parallelism grant (takes days to approve). A self-hosted agent on a VM works immediately.

### 3a. Create the VM
1. Portal → **Virtual machines** → **+ Create**.
2. Resource group `rg-day13-ci`, name `azureagent`, Ubuntu 22.04, size `Standard_B2ts_v2`.
3. Allow SSH (22) → **Create** → copy the **public IP**.

### 3b. Install Docker on the VM (SSH in first)
```bash
ssh azureuser@<VM_PUBLIC_IP>
sudo apt update
sudo apt install docker.io -y
sudo usermod -aG docker azureuser
sudo systemctl restart docker
# log out and back in so docker group applies
```

### 3c. Create the Agent Pool in Azure DevOps
1. Azure DevOps → **Project settings** → **Agent pools** → **Add pool**.
2. Pool type: **Self-hosted**, name: `azureagent` → **Create**.

### 3d. Create a Personal Access Token (PAT)
1. Top right → **User settings** → **Personal access tokens** → **+ New Token**.
2. Scope: **Agent Pools (Read & manage)** → **Create** → copy the token.

### 3e. Install and Configure the Agent (on the VM)
1. In the `azureagent` pool → **New agent** → **Linux** → copy the download commands.
2. On the VM:
   ```bash
   mkdir myagent && cd myagent
   # download the agent (use the URL shown in the portal)
   curl -O <agent-download-url>
   tar zxvf vsts-agent-linux-*.tar.gz
   ./config.sh
   ```
3. When prompted:
   - **Server URL**: `https://dev.azure.com/<your-org>`
   - **Auth type**: PAT → paste your token
   - **Agent pool**: `azureagent`
   - **Agent name**: press Enter (default)
4. Run the agent:
   ```bash
   ./run.sh
   ```
5. Back in the portal, the agent shows **Online** (green). ✅

---

## PART 5 — Create the Service Connection to ACR
1. Azure DevOps → **Project settings** → **Service connections** → **New service connection**.
2. Choose **Docker Registry** → **Azure Container Registry**.
3. Select your subscription + your ACR → name it (e.g. `acr-connection`) → **Save**.

---

## PART 6 — Create the Pipeline
1. Azure DevOps → **Pipelines** → **Create Pipeline**.
2. Choose **Azure Repos Git** → select your `voting-app` repo.
3. Choose **Starter pipeline** → replace all content with the YAML below.

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
  name: 'azureagent'          # your self-hosted pool

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

> Replace `dockerRegistryServiceConnection` and `containerRegistry` with your real values.
> `pool: name: 'azureagent'` must match your self-hosted agent pool name.

---

## PART 7 — Add the Update Script (for the 3rd stage / CD)
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

## PART 8 — Run the Pipeline
1. Click **Save and run**.
2. The self-hosted agent picks up the job → runs **Build → Push → Update**.
3. Watch each stage finish green ✅.

---

## PART 9 — Verify the Image in ACR
1. Portal → your ACR → **Services** → **Repositories**.
2. You should see `votingapp` with a tag = the build number.

CLI:
```bash
az acr repository list --name <yourname>azurecicd --output table
```

---

## PART 10 — (Reference) ACR Pull Secret for Kubernetes
Used later in CD so AKS can pull from your private ACR:
```bash
kubectl create secret docker-registry <secret-name> \
  --namespace <namespace> \
  --docker-server=<acr-name>.azurecr.io \
  --docker-username=<sp-id-or-admin-user> \
  --docker-password=<sp-password-or-admin-key>
```

---

## PART 11 — Clean Up
```bash
az group delete --name rg-day13-ci --yes --no-wait
```
(Also stop the agent with `Ctrl + C` on the VM.)

---

## ✅ Remember
- **CI** = Build → Push → (Update manifest) on every code change.
- **Self-hosted agent** avoids the Microsoft-hosted parallelism wait.
- **Service connection** lets the pipeline log in to ACR.
- The **Update stage** edits the K8s manifest → sets up **CD** for Day 14.

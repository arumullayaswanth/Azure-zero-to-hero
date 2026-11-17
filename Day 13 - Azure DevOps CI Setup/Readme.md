# Day 13: Azure DevOps — CI Setup — Project 3

Set up **Continuous Integration (CI)** for the **Voting App** using Azure DevOps Pipelines.
Follow the steps in order, top to bottom. ✅

**What CI does:** every time you push code, the pipeline runs 3 stages →
**Build** the Docker image → **Push** it to Azure Container Registry (ACR) → **Update** the K8s manifest (sets up CD for Day 14).

---

## Order of Steps (overview)

```text
1. Import app code into Azure Repos
2. Create a Resource Group
3. Create an Azure Container Registry (ACR)
4. Create a Self-Hosted Agent (VM)
5. Create a Service Connection (DevOps → ACR)
6. Create the Pipeline (add YAML)
7. Add the update script
8. Run the pipeline
9. Verify the image in ACR
10. (Reference) ACR pull secret
11. Clean up
```

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

## STEP 4 — Create a Self-Hosted Agent (on an Azure VM)
> Why: Microsoft-hosted agents need a paid parallelism grant (takes days to approve). A self-hosted agent on a VM works immediately.

**4.1 Create the VM**
1. Portal → **Virtual machines** → **+ Create**.
2. Resource group `rg-day13-ci`, name `azureagent`, Ubuntu 22.04, size `Standard_B2ts_v2`.
3. Allow SSH (22) → **Create** → copy the **public IP**.

**4.2 Install Docker on the VM**
```bash
ssh azureuser@<VM_PUBLIC_IP>
sudo apt update
sudo apt install docker.io -y
sudo usermod -aG docker azureuser
sudo systemctl restart docker
# log out and back in so the docker group applies
```
```bash
exit
ssh azureuser@<VM_PUBLIC_IP>
```

**4.3 Create the Agent Pool in Azure DevOps**
1. Azure DevOps → **Project settings** → **Agent pools** → **Add pool**.
2. Pool type: **Self-hosted**, name: `azureagent` → **Create**.

**4.4 Create a Personal Access Token (PAT)**
1. Top right → **User settings** → **Personal access tokens** → **+ New Token**.
2. Scope: **Agent Pools (Read & manage)** → **Create** → copy the token.

**4.5 Install and Configure the Agent (on the VM)**
1. In the `azureagent` pool → **New agent** → **Linux** → copy the download commands.
2. On the VM:
   ```bash
   mkdir myagent && cd myagent
   curl -O <agent-download-url>
   tar zxvf vsts-agent-linux-*.tar.gz
   ./config.sh
   ```
3. When prompted:
   - **Server URL**: `https://dev.azure.com/<your-org>`
- Example: if your browser shows https://dev.azure.com/yaswanthreddy/my-first-devops-project,
   - **Auth type**: PAT → paste your token
   - **Enter agent pool (press enter for default) >**: azureagent
   - **Enter agent name (press enter for azureagent)**: press Enter 
   - **Enter work folder (press enter for _work)** : press Enter

4. Start the agent:
   ```bash
   ./run.sh
   ```
5. In the portal, the agent shows **Online** (green). ✅

---

## STEP 5 — Create the Pipeline (service connection is auto-created here)
> Using the **Docker** pipeline template creates the ACR service connection for you —
> no need for a separate step.

1. Azure DevOps → **Pipelines** → **New pipeline**.
2. **Where is your code?** → choose **Azure Repos Git**.
3. Select your `my-first-devops-project` repo.
4. **Configure your pipeline** → choose **Docker — Build and push an image to Azure Container Registry**.
5. **Select an Azure subscription** → pick yours → **Continue** (sign in if prompted).
6. On the Docker config screen:
   - **Container registry**: select your ACR (`yournameazurecicd`) — this auto-creates the service connection.
   - **Image Name**: `votingapp`
   - **Dockerfile**: `$(Build.SourcesDirectory)/vote/Dockerfile`  (change `result` → `vote`)
7. Click **Validate and configure**.
8. Azure generates a starter YAML. **Replace all of it** with the full 3-stage YAML below, then **Save and run**.

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
```

> This pipeline has 2 stages: **Build** and **Push**. (The K8s manifest "Update" stage is added later in Day 14 for CD.)

---

## STEP 6 — Run the Pipeline
1. Click **Save and run**.
2. The agent picks up the job → runs **Build → Push**.
3. Watch each stage finish green ✅.

---

## STEP 7 — Verify the Image in ACR
1. Portal → your ACR → **Services** → **Repositories**.
2. You should see `votingapp` with a tag = the build number.

CLI:
```bash
az acr repository list --name <yourname>azurecicd --output table
```

---

## STEP 8 — (Reference) ACR Pull Secret for Kubernetes
Used later in CD so AKS can pull from your private ACR:
```bash
kubectl create secret docker-registry <secret-name> \
  --namespace <namespace> \
  --docker-server=<acr-name>.azurecr.io \
  --docker-username=<sp-id-or-admin-user> \
  --docker-password=<sp-password-or-admin-key>
```

---

## STEP 9 — Clean Up
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

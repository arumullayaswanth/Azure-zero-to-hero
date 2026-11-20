# Day 14: Azure DevOps — Full CI + CD — Project 4

The **complete end-to-end flow** for the Voting App: CI (build + push to ACR) **and**
CD (deploy to AKS with Argo CD / GitOps), all in one ordered list. ✅

📺 Video: https://www.youtube.com/watch?v=HyTIsLZWkZg

**The big picture:**
```text
push code → CI: build image → push to ACR → update manifest in Git
          → CD: Argo CD sees Git change → deploys new image to AKS
```

---

## Order of Steps (overview)

```text
--- CI (build & push) ---
1.  Import app code into Azure Repos
2.  Create a Resource Group
3.  Create an Azure Container Registry (ACR)
4.  Create a Self-Hosted Agent (VM)
5.  Create the Pipeline (build + push to ACR)
6.  Run the pipeline & verify image in ACR

--- CD (deploy to AKS) ---
7.  Create an AKS cluster
8.  Connect to the cluster (kubectl)
9.  Install Argo CD on AKS
10. Access the Argo CD UI
11. Connect Argo CD to your Azure Repo
12. Create the ACR image pull secret
13. Create an Argo CD Application
14. Add the Update stage to the CI pipeline
15. Push code → watch CI + CD run end-to-end
16. Access the app
17. Clean up
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

---

# ===== PART A — CI (Build & Push) =====

## STEP 1 — Import the App Code into Azure Repos
1. Voting app repo: https://github.com/dockersamples/example-voting-app
2. Azure DevOps → **Repos** → **Import a repository** → paste the URL → **Import**.

## STEP 2 — Create a Resource Group
```bash
az group create --name rg-day14 --location centralindia
```

## STEP 3 — Create an Azure Container Registry (ACR)
1. Portal → `Container registries` → **+ Create** → RG `rg-day14`, name `yournameazurecicd`, SKU Basic.
2. Open the ACR → **Settings → Access keys** → turn **Admin user** ON (note username + password).
```bash
az acr create --resource-group rg-day14 --name yournameazurecicd --sku Basic
```

## STEP 4 — Create a Self-Hosted Agent (on an Azure VM)
**4.1 Create the VM**: Portal → VM `azureagent`, Ubuntu 22.04, `Standard_B2ts_v2`, allow SSH.

**4.2 Install Docker + fix permissions**
```bash
ssh azureuser@<VM_PUBLIC_IP>
sudo apt update
sudo apt install docker.io -y
sudo usermod -aG docker azureuser
sudo systemctl restart docker
exit                       # log out/in so the docker group applies
ssh azureuser@<VM_PUBLIC_IP>
docker ps                  # should work without sudo
```

**4.3 Create the agent pool**: Azure DevOps → **Project settings → Agent pools → Add pool** → Self-hosted → name `azureagent`.

**4.4 Create a PAT**: User settings → **Personal access tokens** → scope **Agent Pools (Read & manage)** → copy it.

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

4. Run the agent as a BACKGROUND SERVICE (stays Online after you close SSH + survives reboot)
```bash
sudo ./svc.sh install azureuser
sudo ./svc.sh start
sudo ./svc.sh status                  
 # should show "active (running)"

# (Alternative, temporary: ./run.sh  — but it stops when you close the terminal)
```


## STEP 5 — Create the Pipeline (build + push to ACR)
1. **Pipelines → New pipeline → Azure Repos Git →** your repo `my-first-devops-project`.
2. **Configure → Docker (Build and push to ACR)** → pick subscription → pick your ACR (auto-creates the service connection).
3. Replace the generated YAML with the pipeline file in this folder:
   **[`azure-pipelines.yaml`](./azure-pipelines.yaml)**
4. Update the placeholders (service connection id, ACR name) → **Save and run**.

> The pipeline uses one `pool:` block (`name: 'azureagent'`) — no `vmImage` anywhere.

## STEP 6 — Run the Pipeline & Verify in ACR
1. **Save and run** → agent runs Build + Push.
2. Verify: Portal → ACR → **Repositories** → `votingapp` with a tag.
```bash
az acr repository list --name yournameazurecicd --output table
```

---

# ===== PART B — CD (Deploy to AKS with Argo CD) =====

> **Where to run the commands below:** on your **agent VM** (or Azure Cloud Shell).
> Make sure Azure CLI is logged in first: `az login` (use the device-code link on a headless VM).
> Run STEP 7-10, 12, 16 in the terminal; STEP 11 and 13 are in the Argo CD web UI.

## STEP 7 — Create an AKS Cluster
```bash
az aks create --resource-group rg-day14 --name aks-day14 --node-count 2 --node-vm-size Standard_B2s_v2 --generate-ssh-keys
```

## STEP 8 — Connect to the Cluster
```bash
az aks install-cli
az aks get-credentials --resource-group rg-day14 --name aks-day14
kubectl get nodes          # nodes should be Ready
```

## STEP 9 — Install Argo CD on AKS
```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl get pods -n argocd # wait until all are Running
```

## STEP 10 — Access the Argo CD UI
```bash
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
kubectl get svc argocd-server -n argocd    # copy EXTERNAL-IP
# admin password:
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```
Open `https://<EXTERNAL-IP>` → login `admin` + the password above.

## STEP 11 — Connect Argo CD to your Azure Repo
Argo CD UI → **Settings → Repositories → Connect repo (HTTPS)**:
- Repo URL: your Azure Repo URL
- Username: `azure`, Password: an Azure DevOps **PAT (Code: Read)**
- **Connect** → Successful.

## STEP 12 — Create the ACR Image Pull Secret
So AKS can pull private images:
```bash
kubectl create secret docker-registry acr-secret \
  --namespace default \
  --docker-server=yournameazurecicd.azurecr.io \
  --docker-username=<acr-admin-username> \
  --docker-password=<acr-admin-password>
```
Add `imagePullSecrets: - name: acr-secret` to your deployment manifests.

## STEP 13 — Create an Argo CD Application
Argo CD UI → **+ New App**:
- **Name**: `voting-app`, **Project**: `default`, **Sync Policy**: Automatic (Prune + Self Heal)
- **Repo URL**: your repo, **Path**: `k8s-specifications`
- **Cluster**: `https://kubernetes.default.svc`, **Namespace**: `default`
- **Create** → Argo CD deploys the app and keeps it synced with Git. ✅

## STEP 14 — Add the Update Stage to the CI Pipeline
This is what links CI to CD: after pushing the image, update the manifest in Git.

1. Add the update script to your repo: **[`scripts/updateK8sManifests.sh`](./scripts/updateK8sManifests.sh)**
   (edit the PAT, ORG, repo name, and ACR name inside it).
2. The pipeline file **[`azure-pipelines.yaml`](./azure-pipelines.yaml)** already includes the
   **Update** stage that runs this script after Build + Push.
3. Commit both files and the pipeline will now Build → Push → Update Git on every run.

## STEP 15 — Push Code → Watch CI + CD End-to-End
1. Edit the `vote` app → push to `main`.
2. **CI** runs: build → push to ACR → update manifest in Git.
3. **CD** (Argo CD) sees the Git change → auto-deploys the new image to AKS.
4. Watch the app go **Synced / Healthy** in the Argo CD UI. ✅

## STEP 16 — Access the App
```bash
kubectl get svc
```
Open the `vote` (and `result`) service EXTERNAL-IP in the browser.

## STEP 17 — Clean Up
```bash
az group delete --name rg-day14 --yes --no-wait
```
(Stop/remove the agent service on the VM: `sudo ./svc.sh stop && sudo ./svc.sh uninstall`.)

---

## ✅ Remember
- **CI** = build → push → **update Git manifest**.
- **CD (GitOps)** = Argo CD watches Git and deploys to AKS automatically.
- **Image pull secret** lets AKS pull private images from ACR.
- Full loop: **push code → CI (ACR + Git) → Argo CD → AKS**.

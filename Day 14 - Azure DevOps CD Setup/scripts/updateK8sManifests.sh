#!/bin/bash
# Updates the image tag in the K8s deployment manifest and pushes it back to Git.
# Argo CD watches this repo and deploys the new image to AKS.
# Args: $1 = service name (e.g. vote), $2 = image repository, $3 = image tag
set -x

REPO_URL="https://<PAT>@dev.azure.com/<ORG>/my-first-devops-project/_git/my-first-devops-project"

git clone "$REPO_URL" /tmp/temp_repo
cd /tmp/temp_repo

# Change the image line in the deployment manifest to the new tag
sed -i "s|image:.*|image: yournameazurecicd.azurecr.io/$2:$3|g" k8s-specifications/$1-deployment.yaml

git add .
git commit -m "Update $1 image tag to $3"
git push

# Cleanup
rm -rf /tmp/temp_repo

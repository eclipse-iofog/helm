#!/bin/bash

set -e

VERSION="$1"
GIT_TOKEN="$2"

REPO_DIR=/tmp/helm

# Checkout the Helm package branch
git clone -b gh-pages --single-branch https://github.com/eclipse-iofog/helm.git "$REPO_DIR"

# Generate Helm packages
for CHART in iofog iofog-k8s
do
	helm package -d "$REPO_DIR" "$CHART"
done
helm repo index "$REPO_DIR" --url https://eclipse-iofog.github.io/helm/

# Push new packages
cd "$REPO_DIR"
git commit -a -m "$VERSION" 
git push "https://$GIT_TOKEN@github.com/eclipse-iofog/helm.git"
rm -rf "$REPO_DIR"
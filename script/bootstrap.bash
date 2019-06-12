#!/bin/bash

set -o errexit -o pipefail -o noclobber -o nounset
cd "$(dirname "$0")"

OS=$(uname -s | tr A-Z a-z)

GCLOUD_VERSION=250.0.0
TERRAFORM_VERSION=0.12.1
HELM_VERSION=2.14.0

# GCP CLI
if [[ -z $(command -v gcloud) ]]; then
  if [[ "$OS" == "darwin" ]]; then
      curl -Lo gcloud.tar.gz https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-"$GCLOUD_VERSION"-"$OS"-x86_64.tar.gz
      tar -xf gcloud.tar.gz
      rm gcloud.tar.gz
      google-cloud-sdk/install.sh -q
      rm -r google-cloud-sdk
  else
      export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
      echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
      curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
      sudo apt-get update && sudo apt-get install google-cloud-sdk
  fi
else
  echo "gcloud already installed"
  gcloud --version
fi

# Terraform
if [[ -z $(command -v terraform) ]]; then
  curl -fSL -o terraform.zip https://releases.hashicorp.com/terraform/"$TERRAFORM_VERSION"/terraform_"$TERRAFORM_VERSION"_"$OS"_amd64.zip
  sudo mkdir -p /usr/local/opt/
  sudo unzip -q terraform.zip -d /usr/local/opt/terraform
  rm -f terraform.zip
  sudo ln -s /usr/local/opt/terraform/terraform /usr/local/bin/terraform
else
  echo "Terraform already installed"
  terraform --version
fi

# Helm
if ! which helm > /dev/null; then
  curl -Lo helm.tar.gz https://storage.googleapis.com/kubernetes-helm/helm-v"$HELM_VERSION"-"$OS"-amd64.tar.gz
  tar -xf helm.tar.gz
  rm helm.tar.gz
  sudo mv "$OS"-amd64/helm /usr/local/bin
  chmod +x /usr/local/bin/helm
  rm -r "$OS"-amd64
  helm init --client-only
else
  echo "Helm already installed"
  helm version
fi

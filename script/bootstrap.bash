#!/bin/bash

set -e

OS=$(uname -s | tr A-Z a-z)
HELM_VERSION=2.13.1

# Helm
curl -Lo helm.tar.gz https://storage.googleapis.com/kubernetes-helm/helm-v"$HELM_VERSION"-"$OS"-amd64.tar.gz
tar -xf helm.tar.gz
rm helm.tar.gz
sudo mv "$OS"-amd64/helm /usr/local/bin
chmod +x /usr/local/bin/helm
rm -r "$OS"-amd64
helm init --client-only
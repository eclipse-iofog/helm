# ioFog Kubernetes Helm Package Repository

This repository is used to serve Helm packages of ioFog Kubernetes.


# Prerequisites

The following commands require an installation of `Helm` and `kubectl` executing the deployment. It also assumes you have a running Kubernetes cluster and Agent nodes.

* [Helm installation instructions](https://helm.sh/docs/using_helm/#installing-helm)
* [kubectl installation instructions](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

# Usage

## Install ioFog Stack

Add this repository to your Helm repository index and install the ioFog stack and Kubernetes services

```
helm repo add iofog https://eclipse-iofog.github.io/helm
helm install --name iofog --namespace iofog ./iofog 
```

## Add Agents

Integrate on-cluster Controller with Agents at the edge. Note that this must be run from within the Agent machine
```
# From a device with sufficient Kubernetes cluster permissions:
CONNECTOR_IP=$(kubectl -n iofog get svc connector -o jsonpath={.status.loadBalancer.ingress[0].ip})

# From a device or a container running your ioFog Agent: 
iofog-agent config -a "http://${CONNECTOR_IP}:51121/api/v3/"
```

# ioFog Kubernetes Helm Package Repository

This repository is used to serve Helm packages of ioFog Kubernetes.


# Prerequisites

The following commands require an installation of `Helm` and `kubectl` executing the deployment. It also assumes you have a running Kubernetes cluster and Agent nodes.

* [Helm installation instructions](https://helm.sh/docs/using_helm/#installing-helm)
* [kubectl installation instructions](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

# Usage

## Install ioFog Stack

Add this repository to your Helm repository index and install the ioFog stack and Kubernetes services

```bash
helm repo add iofog https://eclipse-iofog.github.io/helm
helm install --name iofog --namespace iofog ./iofog 
```

### Mutliple Instances of ioFog stack

If you want to have multiple instances of ioFog on the same Kubernetes cluster, it is necessary to tell Helm not to install custom resource definitions. This can be done by overriding the `createCustomResource` (default: `true`) variable.

```bash
helm install --name iofog --namespace iofog --set createCustomResource=false ./iofog
```
 
Only use this option when the ioFog custom resource exists, either from another Helm installation or manual installation using [iofogctl](https://github.com/eclipse-iofog/iofogctl).

To check if the custom resource exists, run
```bash
kubectl get crd iofogs.k8s.iofog.org
```

## Uninstall ioFog Stack

To uninstall ioFog stack, simply delete the Helm release, where the release name refers to `--name` arguments used during installation. 

```bash
helm delete --purge iofog
```

Note that due to Helm's handing of custom resource definitions, all such definitions are orphaned when a release is created and thus need to be deleted manually.

```bash
kubectl delete crd iofogs.k8s.iofog.org 
```

## Add Agents

Integrate on-cluster Controller with Agents at the edge. Note that this must be run from within the Agent machine
```bash
# From a device with sufficient Kubernetes cluster permissions:
CONNECTOR_IP=$(kubectl -n iofog get svc connector -o jsonpath={.status.loadBalancer.ingress[0].ip})

# From a device or a container running your ioFog Agent: 
iofog-agent config -a "http://${CONNECTOR_IP}:51121/api/v3/"
```

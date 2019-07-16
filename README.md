# ioFog Kubernetes Helm Package Repository

This repository is used to serve Helm packages of ioFog Kubernetes.


# Prerequisites

The following commands require an installation of `Helm` and `kubectl` executing the deployment. It also assumes you have a running Kubernetes cluster and Agent nodes.

* [Helm installation instructions](https://helm.sh/docs/using_helm/#installing-helm)
* [kubectl installation instructions](https://kubernetes.io/docs/tasks/tools/install-kubectl/)


## Create Service Account for Tiller

Note that on RBAC enabled Kubernetes clusters (e.g. GKE, AKE), it is necessary to create a service account for Tiller before initializing helm. See [helm init instructions](https://helm.sh/docs/using_helm/#tiller-and-role-based-access-control) for more details.

In order to create the cluster role binding on GKE, you need to have `roles/container.admin` permission. If your account doesn't have the role, it can be added using the following:

```bash
gcloud projects add-iam-policy-binding $PROJECT --member=user:person@company.com --role=roles/container.admin
```

Next, create service account for Tiller and bind cluster-admin role.

```bash
kubectl create serviceaccount --namespace kube-system tiller-svacc
kubectl create clusterrolebinding tiller-crb --clusterrole=cluster-admin --serviceaccount=kube-system:tiller-svacc
```

## Initialize Helm And Install Tiller

You can now use your service account to initialize Helm.

```bash
helm init --service-account tiller-svacc --wait
```

Note that on Azure Kubernetes Service (AKS), you will also need to specify node selectors for Tiller.

```bash
helm init --service-account tiller-svacc --node-selectors "beta.kubernetes.io/os"="linux" --wait
```

# Usage

## Install ioFog Stack

Add this repository to your Helm repository index and install the ioFog stack and Kubernetes services

```bash
helm repo add iofog https://eclipse-iofog.github.io/helm
helm install --name iofog --namespace iofog iofog/iofog
```

### Multiple Instances of ioFog Stack

If you want to have multiple instances of ioFog on the same Kubernetes cluster, it is necessary to tell Helm not to install custom resource definitions. This can be done by overriding the `createCustomResource` (default: `true`) variable.
 Only use this option when the ioFog custom resource exists, either from another Helm installation or manual installation using [iofogctl](https://github.com/eclipse-iofog/iofogctl).

To check if the custom resource exists, run `kubectl get crd iofogs.k8s.iofog.org`. If the resource exists, you must use `createCustomResource=false` so that Helm does not try to create it again. 

```bash
helm install --name iofog --namespace iofog --set createCustomResource=false iofog/iofog
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

## Run Tests

You can run simple test suite on your newly deployed ioFog stack using helm:

```bash
helm test iofog
```

To see a detailed output from the tests, you cna check test-runner logs using `kubectl -n iofog logs test-runner`. In case you do not want to inspect the logs, using `helm test --cleanup iofog` will remove all test pods after running the tests. 

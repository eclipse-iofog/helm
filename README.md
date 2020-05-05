# ioFog Kubernetes Helm Package Repository

This repository is used to serve Helm packages of ioFog Kubernetes.

# Prerequisites

The following commands require an installation of `Helm v3+` and `kubectl` executing the deployment. It also assumes you have a running Kubernetes cluster and Agent nodes.

* [Helm installation instructions](https://helm.sh/docs/intro/install/)
* [kubectl installation instructions](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

# Usage

## Install ioFog Stack

Add this Helm repository to our Helm repository index and install the ioFog stack and Kubernetes services

```bash
helm repo add iofog https://eclipse-iofog.github.io/helm
```

To list all available version of iofog Helm chart, including development versions, run:

```bash
helm search repo -l --devel iofog/iofog 
```

To install a specific version of ioFog, use `helm install`:

```bash
helm install my-ecn \
 --namespace my-ns --create-namespace \
 --version 2.0.0-rc1 \
 --set controlPlane.user.email=user@domain.com \
 --set controlPlane.user.password=any123password345 \
 iofog/iofog
```

To list all Helm releases, we can simply run `helm list`.

The following is a complete list of all user configurable properties for the ioFog Helm chart. All of the properties are optional and have defaults. Use `--set property.name=value` in `helm install` to parametrize Helm release.

| Property                                | Default value                   | Description                                                                                   |
| --------------------------------------- | ------------------------------- | --------------------------------------------------------------------------------------------- |
| user.firstName                          | First                           | First name of initial user in Controller                                                      |
| user.surname                            | Second                          | Surname of initial user in Controller                                                         |
| user.email                              | user@domain.com                 | Email (login) of initial user in Controller                                                   |
| user.password                           | H23fkidf9hoibf2nlk              | Password of initial user in Controller                                                        |
| database.provider                       |                                 | Not supported in ioFog Community Edition                                                      |
| database.host                           |                                 | Not supported in ioFog Community Edition                                                      |
| database.port                           | 0                               | Not supported in ioFog Community Edition                                                      |
| database.user                           |                                 | Not supported in ioFog Community Edition                                                      |
| database.password                       |                                 | Not supported in ioFog Community Edition                                                      |
| database.dbName                         |                                 | Not supported in ioFog Community Edition                                                      |
| images.controller                       | iofog/controller:2.0.0-rc1      | [Controller Docker image](https://hub.docker.com/r/iofog/controller/tags)                     |
| images.kubelet                          | iofog/iofog-kubelet:2.0.0-rc1   | [Kubelet Docker image](https://hub.docker.com/r/iofog/iofog-kubelet/tags)                     |
| images.operator                         | iofog/iofog-operator:2.0.0-rc1  | [Operator Docker image](https://hub.docker.com/r/iofog/iofog-operator/tags)                   |
| images.portManager                      | iofog/port-manager:2.0.0-rc1    | [Port Manager Docker image](https://hub.docker.com/r/iofog/port-manager/tags)                 |
| images.proxy                            | iofog/proxy:2.0.0-rc1           | [Proxy Docker image](https://hub.docker.com/r/iofog/proxy/tags)                               |
| replicas.operator                       | 1                               | Number of replicas of Operator pods                                                           |
| replicas.controller                     | 1                               | Number of replicas of Controller pods                                                         |


### Connection to Installed ioFog

Once the installation is complete, you will be able to connect to the ioFog Controller on K8s using [iofogctl](https://iofog.org/docs/2.0.0/tools/iofogctl/usage.html). Make sure the `--namespace` here matches the one used during `helm install` step, so `iofogctl` can find the correct ECN using your kubeconfig file.

```bash
iofogctl --namespace my-ns connect --kube ~/.kube/config --email user@domain.com --pass H23fkidf9hoibf2nlk
```

## Uninstall ioFog Stack

To uninstall ioFog stack, simply delete the Helm release, where the release name refers to `--name` arguments used during installation.

```bash
helm --namespace my-ns delete my-ecn
```

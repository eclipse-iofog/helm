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
 
 To install a specific version of ioFog, use `helm install`:
 
 ```bash
 helm install my-ecn \
     --set controlPlane.user.email=user@domain.com \
     --set controlPlane.user.password=any123password345 \
     --version 2.0.0 \
     --namespace my-ecn \
     iofog/iofog
 ```
 
 To list all Helm releases, we can simply run `helm list`.
 
 The following is a complete list of all user configurable properties for the ioFog Helm chart. All of the properties are optional and have defaults. Use `--set property.name=value` in `helm install` to parametrize Helm release.
 
 | Property                                | Default value                   | Description                                                                                   |
 | --------------------------------------- | ------------------------------- | --------------------------------------------------------------------------------------------- |
 | createCustomResources                   | true                            | See [Multiple Edge Compute Networks](#multiple-edge-compute-networks)                         |
 | controlPlane.userfirstName              | First                           | First name of initial user in Controller                                                      |
 | controlPlane.usersurname                | Second                          | Surname of initial user in Controller                                                         |
 | controlPlane.useremail                  | user@domain.com                 | Email (login) of initial user in Controller                                                   |
 | controlPlane.userpassword               | H23fkidf9hoibf2nlk              | Password of initial user in Controller                                                        |
 | controlPlane.database.provider          |                                 | Not supported in ioFog Community Edition                                                      |
 | controlPlane.database.host              |                                 | Not supported in ioFog Community Edition                                                      |
 | controlPlane.database.port              | 0                               | Not supported in ioFog Community Edition                                                      |
 | controlPlane.database.password          |                                 | Not supported in ioFog Community Edition                                                      |
 | controlPlane.database.dbName            |                                 | Not supported in ioFog Community Edition                                                      |
 | controlPlane.controller.replicas        | 1                               | Number of replicas of Controller pods                                                         |
 | controlPlane.controller.image           | iofog/controller:1.3.0-rc1     | [Controller Docker image](https://hub.docker.com/r/iofog/controller/tags)                     |
 | controlPlane.controller.imagePullPolicy | Always                          | Controller Docker image [pull policy](https://kubernetes.io/docs/concepts/containers/images/) |
 | controlPlane.kubeletImage               | iofog/iofog-kubelet:1.3.0-rc1  | [Kubelet Docker image](https://hub.docker.com/r/iofog/iofog-kubelet/tags)                     |
 | controlPlane.loadBalancerIp             |                                 | Pre-allocated static IP address for Controller                                                |
 | controlPlane.serviceType                | LoadBalancer                    | Service type for Controller (one of `LoadBalancer`, `NodePort` or `ClusterIP`)                |
 | operator.replicas                       | 1                               | Number of replicas of Operator pods                                                           |
 | operator.image                          | iofog/iofog-operator:1.3.0-rc1 | [OperatorDocker image](https://hub.docker.com/r/iofog/iofog-operator/tags)                    |
 | operator.imagePullPolicy                | Always                          | Operator Docker image [pull policy](https://kubernetes.io/docs/concepts/containers/images/)   |


### Connection to Installed ioFog

Once the installation is complete, you will be able to connect to the ioFog Controller on K8s using [iofogctl](https://iofog.org/docs/2.0.0/tools/iofogctl/usage.html).

```bash
iofogctl connect k8s-ctrl --kube-config ~/.kube/config --email user@domain.com --pass any123password345
```

Once you are connected, you can use `iofogctl` to deploy edge Agents. Then, you can use `kubectl` or `iofogctl` to deploy microservices to your edge Agents.

## Uninstall ioFog Stack

To uninstall ioFog stack, simply delete the Helm release, where the release name refers to `--name` arguments used during installation.

```bash
helm delete my-ecn
```

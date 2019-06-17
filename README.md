# ioFog Kubernetes Helm Package Repository

This repository is used to serve Helm packages of ioFog Kubernetes.


# Prerequisites

The following commands require an installation of `Helm` and `kubectl` executing the deployment. It also assumes you have a running Kubernetes cluster and Agent nodes.

* [Helm installation instructions](https://helm.sh/docs/using_helm/#installing-helm)
* [kubectl installation instructions](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

Note that on GKE, it is necessary to create a service account for Tiller before initializing helm. See [helm init instructions](https://helm.sh/docs/using_helm/#tiller-and-role-based-access-control) for more details.

# Usage

## Install ioFog Stack

Add this repository to your Helm repository index and install the ioFog stack and Kubernetes services

```bash
helm repo add iofog https://eclipse-iofog.github.io/helm
helm install --name iofog --namespace iofog iofog/iofog
```

### Multiple Instances of ioFog Stack

If you want to have multiple instances of ioFog on the same Kubernetes cluster, it is necessary to tell Helm not to install custom resource definitions. This can be done by overriding the `createCustomResource` (default: `true`) variable.

```bash
helm install --name iofog --namespace iofog --set createCustomResource=false iofog/iofog
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


## Testing ioFog Stack With Agent

### Credentials For ioFog Agent

In order to test the ioFog stack, we will need access to a single ioFog agent. Note that this agent is external to the Kubernetes cluster, but its credentials need to be stored as a secret in the cluster.

You need to create such secret manually, in the same namespace the Helm chart was deployed. This secret only needs to be created or updated when you want to use a different agent for testing purposes. It is not required in any way if you don't need to test the ioFog stack.

```bash
kubectl -n iofog create secret generic agent --from-file=privateKey=/home/username/.ssh/agent-key --from-literal=URI=username@34.66.151.77
```

The credentials are used by the test runner. You can test them by running `ssh -i /home/username/.ssh/agent-key username@34.66.151.77`. It is also possible to check the secret:

```bash
kubectl -n iofog get secret agent-credentials -o yaml
```

When the secret and the agent are available, upgrade your Helm release to reference this secret.

```bash
helm upgrade iofog --namespace iofog --set createCustomResource=false --set test.credentials=agent-credentials iofog/iofog
```

### Register Agent With The ioFog Stack

Now is the time to register the agent with the rest of the ioFog stack. For this purpose, use [iofogctl](https://github.com/eclipse-iofog/iofogctl).

```bash
iofogctl connect -n iofog iofog-test-controller \
  -o $(kubectl -n iofog get svc controller -o jsonpath='{.status.loadBalancer.ingress[0].ip}:{.spec.ports[0].port}') \
  -e user@domain.com  -p '#Bugs4Fun' 

iofogctl deploy agent -n iofog-test agent1 --user username --host 34.66.151.77 --key-file /home/username/.ssh/agent-key
```

Note that the arguments for agent deployment are the same as the credentials we provided to the secret.

### Run Tests

Then run the tests using Helm.

```bash
helm test iofog
```

## Known Issues

When deploying agent for testing purposes, it is possible to encounter a SSH bug in GKE. This disables Helm completely due to its inability to communicate with Tiller.

```console
$ helm list
Error: forwarding ports: error upgrading connection: error dialing backend: No SSH tunnels currently open. Were the targets able to accept an ssh-key for user "gke-0e29ce169876a2a9afc0"?
```

There is currently no known workaround.

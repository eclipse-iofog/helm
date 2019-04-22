# ioFog Kubernetes Helm Package Repository

This repository is used to serve Helm packages of ioFog Kubernetes.

# Usage

The following commands require an installation of Helm, jq, and curl from the machine executing the deployment. It also assumes you have a running Kubernetes cluster and Agent nodes.

Add this repository to your Helm repository index
```
helm repo add iofog https://eclipse-iofog.github.io/helm
```
Install Controller and Connector to cluster
```
helm install iofog/iofog
```
Wait for Controller to obtain an external IP address and then create a user and access token. Use the access token to install ioFog Kubelet, Scheduler, and Operator
```
IP=""
while [ -z "$IP" ] ; do
  IP=$(kubectl get svc controller --template="{{range .status.loadBalancer.ingress}}{{.ip}}{{end}}" -n iofog)
  [ -z "$IP" ] && sleep 10
done
PORT=51121

USER_RESULT=$(curl \--request POST \
http://"$IP":"$PORT"/api/v3/user/signup \
--header 'Content-Type: application/json' \
--data '{ "firstName": "Dev", "lastName": "Test", "email": "user@domain.com", "password": "#Bugs4Fun" }')
echo "$USER_RESULT"

AUTH_RESULT=$(curl --request POST \
--url http://"$IP":"$PORT"/api/v3/user/login \
--header 'Content-Type: application/json' \
--data '{"email":"user@domain.com","password":"#Bugs4Fun"}')
echo "$AUTH_RESULT"

TOKEN=$(echo "$AUTH_RESULT" | jq -r .accessToken)
helm install iofog/iofog-k8s --set-string controller.token="$TOKEN"
```
Integrate on-cluster Controller with Agents at the edge. Note that this must be run from within the Agent machine
```
IP=<controller_ip>
iofog-agent config -a http://"$IP":51121/api/v3/
```


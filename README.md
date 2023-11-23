# Install Cloud Agnost Apps via Helm

## Quickstart

> [!WARNING]
> You need Kubernetes version 1.24 or above to make sure that all the components are working.

## Environment Specific Installation Instructions

> [!WARNING]
> First, make sure that you have helm installed described [here](https://helm.sh/docs/intro/install/)

Add the repo:

```bash
# Add helm repo
helm repo add cloud-agnost https://cloud-agnost.github.io/charts
helm repo update
```

> [!WARNING]
> This chart requires 2400 milicores of CPU and 4Gi of memory. Therefore, we recommend at least 4 CPUs and 8 GBs of memory in the cluster.
> If you plan to have more services (e.g. PostgreSQL database or RabbitMQ queue), then you will need more resources.

> [!WARNING]
> If you already have NGINX ingress running on your cluster, make sure to disable it's deployment with `--set ingress-nginx.enabled=false` flag

### Minikube

On minikube, if you haven't done already, you need to enable ingress, volumesnapshots, and csi-hostpath-driver addons:

```bash
$> minikube start --cpus=4 --memory 8192
...
$> minikube addons enable ingress
💡  ingress is an addon maintained by Kubernetes. For any concerns contact minikube on GitHub.
You can view the list of minikube maintainers at: https://github.com/kubernetes/minikube/blob/master/OWNERS
    ▪ Using image registry.k8s.io/ingress-nginx/controller:v1.7.0
    ▪ Using image registry.k8s.io/ingress-nginx/kube-webhook-certgen:v20230312-helm-chart-4.5.2-28-g66a760794
    ▪ Using image registry.k8s.io/ingress-nginx/kube-webhook-certgen:v20230312-helm-chart-4.5.2-28-g66a760794
🔎  Verifying ingress addon...
🌟  The 'ingress' addon is enabled

$> minikube addons enable volumesnapshots
$> minikube addons enable csi-hostpath-driver

$> minikube addons disable storage-provisioner
$> minikube addons disable default-storageclass

$> kubectl patch storageclass csi-hostpath-sc -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
$> kubectl patch storageclass csi-hostpath-sc -p '{"allowVolumeExpansion":true}'
```

Then run the below commands:

```bash
# Install the chart on Kubernetes:
helm upgrade --install agnost cloud-agnost/base --namespace agnost --create-namespace \
             --set ingress-nginx.enabled=false

# check the pods status, make sure that mongodb, rabbitmq, and redis are running:
# it takes around 5 minutes (depending on your local resources and internet connection)
kubectl get pods -n agnost
NAME                                           READY   STATUS    RESTARTS      AGE
engine-monitor-deployment-6d5569878f-nrg7q     1/1     Running   0             8m8s
engine-realtime-deployment-955f6c77b-2wx52     1/1     Running   0             8m8s
engine-scheduler-deployment-775879f956-fq4sc   1/1     Running   0             8m8s
engine-worker-deployment-76d94cd4c9-9hsjc      1/1     Running   0             8m8s
minio-594ff4f778-hvk4t                         1/1     Running   0             8m8s
mongodb-0                                      2/2     Running   0             7m57s
platform-core-deployment-5f79d59868-9jrbm      1/1     Running   0             8m8s
platform-sync-deployment-7c8bf79df6-h2prc      1/1     Running   0             8m8s
platform-worker-deployment-868cb59558-rv86h    1/1     Running   0             8m8s
rabbitmq-server-0                              1/1     Running   0             7m49s
redis-master-0                                 1/1     Running   0             8m8s
studio-deployment-7fdccfc77f-pxsfj             1/1     Running   0             8m8s
```

You can configure the settings based on [base values.yaml](https://github.com/cloud-agnost/charts/blob/master/base/values.yaml).

Then you can reach your app via the IP address of your ingress:

```bash
# get the IP address of the Ingress --> EXTERNAL-IP field
$> kubectl get svc -n ingress-nginx
NAME                              TYPE           CLUSTER-IP      EXTERNAL-IP      PORT(S)                      AGE
agnost-ingress-nginx-controller   LoadBalancer   10.245.185.76   192.168.49.2     80:30323/TCP,443:31819/TCP   7m1s

# or to get it via script:
kubectl get svc -n ingress-nginx -o jsonpath='{.items[].status.loadBalancer.ingress[].ip}'
```

Then open your browser and access to the IP address (`http://192.168.49.2` for the given example above)

### Docker Desktop

If you already have docker desktop running and you're using the Kubernetes that is shipped with it:

```bash
# Docker Desktop Kubenetes does not have ingress plugin, so you can install it via the chart:
helm upgrade --install agnost cloud-agnost/base --namespace agnost --create-namespace \
             --set ingress-nginx.enabled=true
```

### GKE (Google Kubernetes Engine)

GKE does not need extra configuration, just install the chart:

```bash
helm upgrade --install agnost cloud-agnost/base --namespace agnost --create-namespace
```

### EKS (AWS Elastic Kubernetes Service)

AWS requires an annotation for Ingress, here is how to install it:

```bash
helm upgrade --install agnost cloud-agnost/base --namespace agnost --create-namespace \
             --set ingress-nginx.platform=EKS
```

### AKS (Azure Kubernetes Service)

Azure requires an annotation for Ingress, here is how to install it:

```bash
helm upgrade --install agnost cloud-agnost/base --namespace agnost --create-namespace \
             --set ingress-nginx.platform=AKS
```

### DOKS (DigitalOcean Kubernetes)

Digital Ocean requires an annotation for Ingress, here is how to install it:

```bash
helm upgrade --install agnost cloud-agnost/base --namespace agnost --create-namespace \
             --set ingress-nginx.platform=DOKS
```

## Accessing Services

If you need to access to the services running on Kubernetes, you need to run `kubectl port-forward` command.
Example:

```bash
# you can access to the database from `localhost:27017` after running this:
kubectl port-forward mongodb-0 -n agnost 27017:27017
```

Similar can be done for redis, rabbitmq, and other services.

More information can be found [here](https://kubernetes.io/docs/tasks/access-application-cluster/port-forward-access-application-cluster/)


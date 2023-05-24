# Install Cloud Agnost Apps via Helm

First make sure that you have helm installed [here](https://helm.sh/docs/intro/install/)

Then run the below commands:

```bash
# Add helm repo
helm repo add cloud-agnost https://cloud-agnost.github.io/charts

# Install dependency apps (mongodb, rabbitmq, redis)
helm install base cloud-agnost/base

# check the pods status, make sure that mongodb, rabbitmq, and redis are running:
# it takes around 5 minutes (depending on your local resources and internet connection)
kubectl get pods
NAME                                                 READY   STATUS    RESTARTS   AGE
base-rabbitmq-cluster-operator-6bcd9ff874-pxfn5      1/1     Running   0          5m34s
base-rabbitmq-messaging-topology-operator-558z95rf   1/1     Running   0          5m34s
mongodb-0                                            2/2     Running   0          5m30s
mongodb-1                                            2/2     Running   0          4m45s
mongodb-2                                            2/2     Running   0          4m2s
mongodb-kubernetes-operator-6cf66cbc7f-zsf9s         1/1     Running   0          5m34s
provisioner-7595bc66bb-vs8ll                         1/1     Running   0          5m34s
rabbitmq-server-0                                    0/1     Running   0          5m16s
rabbitmq-server-1                                    1/1     Running   0          5m16s
rabbitmq-server-2                                    1/1     Running   0          5m16s
redis-master-0                                       1/1     Running   0          5m34s
redis-replicas-0                                     1/1     Running   0          5m34s

# install cloud-agnost applications
helm install apps cloud-agnost/apps
```

You can configure the settings based on [base values.yaml](https://github.com/cloud-agnost/charts/blob/master/base/values.yaml) or [apps values.yaml](ttps://github.com/cloud-agnost/charts/blob/master/apps/values.yaml)


## Environment Specific Instructions

### Minikube

On minikube, if you haven't done already, you need to enable ingress addon:

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
```

Then you can reach your app via the IP address of your ingress:

```bash
# get the IP address of the Ingress
$> kubectl get ingress base-cloud-agnost
NAME                CLASS    HOSTS   ADDRESS        PORTS   AGE
base-cloud-agnost   <none>   *       192.168.49.2   80      5m8s
```

Then open your browser and access to the IP address (`http://192.168.49.2` for the given example above)

### MicroK8s

If you haven't done already, you need to enable ingress addon:

```bash
$> microk8s enable ingress
```

Then, you can reach your app via the Ingress IP address:

```bash
$> kubectl get ingress base-cloud-agnost
```

### Docker Desktop

If you already have docker desktop running and you're using the Kubernetes that is shipped with it:

 1. First install NGINX Ingress (or any other ingress controller of your choice):

    ```bash
    $> helm upgrade --install ingress-nginx ingress-nginx \
        --repo https://kubernetes.github.io/ingress-nginx \
        --namespace ingress-nginx --create-namespace
    ```

 2. Once the Ingress controller is installed, you can directly access the application via `http://localhost`

### Kind

It is similar to `Docker Desktop` setup, you first need to install your favourite Ingress controller, then reach your app via browser.

### K3S

K3S deploys Traefik ingress by default, you should be able to access the apps directly on the service IP address.

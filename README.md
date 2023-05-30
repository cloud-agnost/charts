# Install Cloud Agnost Apps via Helm

First make sure that you have helm installed [here](https://helm.sh/docs/intro/install/)

Then run the below commands:

```bash
# Add helm repo
helm repo add cloud-agnost https://cloud-agnost.github.io/charts

# Install dependency apps (mongodb, rabbitmq, redis)
helm install agnost cloud-agnost/base --namespace agnost --create-namespace

# check the pods status, make sure that mongodb, rabbitmq, and redis are running:
# it takes around 5 minutes (depending on your local resources and internet connection)
kubectl get pods -n agnost
NAME                                                           READY   STATUS    RESTARTS      AGE
agnost-rabbitmq-cluster-operator-6d4dd5cd6d-cjg8q              1/1     Running   0             8m8s
agnost-rabbitmq-messaging-topology-operator-6d4b7ff656-smw22   1/1     Running   0             8m8s
engine-monitor-deployment-6fd67646b9-txzw2                     1/1     Running   0             8m8s
engine-realtime-deployment-5ff4594bdd-2lz6f                    1/1     Running   0             8m8s
engine-scheduler-deployment-85bc7c7ddc-smqq4                   1/1     Running   0             8m8s
engine-worker-deployment-77d9d5fd7-d6s4z                       1/1     Running   0             8m8s
mongodb-0                                                      2/2     Running   0             7m57s
mongodb-1                                                      2/2     Running   0             6m51s
mongodb-2                                                      2/2     Running   0             5m59s
mongodb-kubernetes-operator-6cf66cbc7f-482h6                   1/1     Running   0             8m8s
platform-core-deployment-5f79d59868-9jrbm                      1/1     Running   0             8m8s
platform-sync-deployment-7c8bf79df6-h2prc                      1/1     Running   0             8m8s
platform-worker-deployment-868cb59558-rv86h                    1/1     Running   0             8m8s
platform-worker-deployment-868cb59558-x2gpz                    1/1     Running   0             83s
provisioner-8696fffc96-27b8x                                   1/1     Running   0             8m8s
rabbitmq-server-0                                              1/1     Running   0             7m49s
rabbitmq-server-1                                              1/1     Running   0             7m49s
rabbitmq-server-2                                              1/1     Running   0             7m49s
redis-master-0                                                 1/1     Running   0             8m8s
redis-replicas-0                                               1/1     Running   0             8m8s
```

You can configure the settings based on [base values.yaml](https://github.com/cloud-agnost/charts/blob/master/base/values.yaml).

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

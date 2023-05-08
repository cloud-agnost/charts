# Install Cloud Agnost Apps via Helm

First make sure that you have helm installed [here](https://helm.sh/docs/intro/install/)

Then run the below commands:

```bash
helm repo add cloud-agnost https://cloud-agnost.github.io/charts
helm install cloud-agnost cloud-agnost/base
```

You can configure the settings based on [values.yaml](https://github.com/cloud-agnost/charts/blob/master/base/values.yaml)

```bash
# initial installation:
helm install cloud-agnost cloud-agnost/base --set meta=true

# if you have already installed with other parameters:
helm upgrade cloud-agnost cloud-agnost/base --set meta=true
```

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
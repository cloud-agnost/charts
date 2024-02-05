# DOKS (DigitalOcean Kubernetes)

Add the repo and continue with your Kubernetes Platform's documentation:

```bash
helm repo add cloud-agnost https://cloud-agnost.github.io/charts
helm repo update
```

> [!WARNING]
> If you already have NGINX ingress running on your cluster, make sure to disable it's deployment with `--set ingress-nginx.enabled=false` flag

Digital Ocean requires an annotation for Ingress, here is how to install it:

> [!TIP]
> Below commands create `agnost` namespace to install applications and `agnost-operators` namespace to install 3rd party software operators.
> You can skip the `--namespace` and `--create-namespace` options.
> In this case, the installation will be performed on the `default` and `operators` namespaces.

```bash
helm upgrade --install agnost cloud-agnost/base --namespace agnost --create-namespace \
             --set ingress-nginx.platform=DOKS \
             --set minio.mode=distributed --set minio.replicas=4
```

Check the pods status, make sure that mongodb, rabbitmq, and redis are running:
It takes around 5 minutes (depending on your local resources and internet connection)

```bash
$> kubectl get pods -n agnost
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

### EKS (AWS Elastic Kubernetes Service)

> [!WARNING]
> If you already have NGINX ingress running on your cluster, make sure to disable it's deployment with `--set ingress-nginx.enabled=false` flag

AWS requires an annotation for Ingress, here is how to install it:

```bash
helm upgrade --install agnost cloud-agnost/base --namespace agnost --create-namespace \
             --set ingress-nginx.platform=EKS
```

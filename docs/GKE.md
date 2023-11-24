### GKE (Google Kubernetes Engine)

> [!WARNING]
> If you already have NGINX ingress running on your cluster, make sure to disable it's deployment with `--set ingress-nginx.enabled=false` flag

GKE does not need extra configuration, just install the chart:

```bash
helm upgrade --install agnost cloud-agnost/base --namespace agnost --create-namespace
```

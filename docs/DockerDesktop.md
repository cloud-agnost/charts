### Docker Desktop

If you already have docker desktop running and you're using the Kubernetes that is shipped with it:

```bash
# Docker Desktop Kubenetes does not have ingress plugin, so you can install it via the chart:
helm upgrade --install agnost cloud-agnost/base --namespace agnost --create-namespace \
             --set ingress-nginx.enabled=true
```

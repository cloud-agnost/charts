# Install Cloud Agnost Apps via Helm

## Requirements

> [!WARNING]
>
>1. You need Kubernetes version 1.24 or above to make sure that all the components are working.
>
>2. Make sure that you have the latest version of helm installed described [here](https://helm.sh/docs/intro/install/)
>
>3. This chart requires 2400 milicores of CPU and 4Gi of memory. Therefore, we recommend at least 4 CPUs and 8 GBs of memory in the cluster. If you plan to have more services (e.g. PostgreSQL database or RabbitMQ queue), then you will need more resources.

## Environment Specific Installation Instructions

- [Minikube](./docs/Minikube.md)

- [Docker Desktop](./docs/DockerDesktop.md)

- [Google Kubernetes Engine](./docs/GKE.md)

- [AWS Elastic Kubernetes Service](./docs/EKS.md)

- [Azure Kubernetes Service](./docs/AKS.md)

- [Digital Ocean Kubernetes](./docs/DOKS.md)

## Accessing Services

If you need to access to the services running on Kubernetes, you need to run `kubectl port-forward` command.
Example:

```bash
# you can access to the database from `localhost:27017` after running this:
kubectl port-forward mongodb-0 27017:27017 -n <NAMESPACE>
```

Similar can be done for redis, rabbitmq, and other services:

> [!WARNING]
>
> Below commands run on the default namespace, if you installed the chart to other namespace, then you should add `-n <NAMESPACE>`

### MinIO Console

```bash
# http://localhost:9001
kubectl port-forward svc/minio-storage-console 9001:9001

# username:
kubectl get secret minio-credentials -o jsonpath='{.data.rootUser}' | base64 -d

# password:
kubectl get secret minio-credentials -o jsonpath='{.data.rootPassword}' | base64 -d
```

### RabbitMQ

```bash
# http://localhost:15672
kubectl port-forward svc/rabbitmq 15672:15672

# username
kubectl get secret rabbitmq-default-user -o jsonpath='{.data.username}' | base64 -d

# password
kubectl get secret rabbitmq-default-user -o jsonpath='{.data.password}' | base64 -d
```

### Zot Registry

```bash
# http://localhost:5000
kubectl port-forward svc/local-registry 5000:5000
```

### Tekton Pipelines

```bash
# http://localhost:9097/#/taskruns
kubectl port-forward svc/tekton-dashboard -n tekton-pipelines 9097:9097
```

More information can be found [here](https://kubernetes.io/docs/tasks/access-application-cluster/port-forward-access-application-cluster/)

## Wildcard Certificates

If you would like to create a wildcard certificate for your domain with `cert-manager` and `let's encrypt`, then you need to use `DNS-01` challange. This requires credentials to access your DNS provider.

More information with some examples can be found on [cert-manager documentation](https://cert-manager.io/docs/configuration/acme/dns01/)

After you successfully created your `Issuer`, then you need to update the ingress objects as given example below:

```yaml
## example for studio-ingress
## all ingresses need to be updated!
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: studio-ingress
  namespace: {{ .Release.Namespace }}
  annotations:
    nginx.ingress.kubernetes.io/proxy-body-size: 500m
    nginx.ingress.kubernetes.io/proxy-connect-timeout: '6000'
    nginx.ingress.kubernetes.io/proxy-send-timeout: '6000'
    nginx.ingress.kubernetes.io/proxy-read-timeout: '6000'
    nginx.ingress.kubernetes.io/proxy-next-upstream-timeout: '6000'
    nginx.ingress.kubernetes.io/rewrite-target: /$1
    # add an annotation indicating the issuer to use.
    cert-manager.io/cluster-issuer: nameOfClusterIssuer
spec:
  ingressClassName: nginx
  tls: # < placing a host in the TLS config will determine what ends up in the cert's subjectAltNames
    - hosts:
        - example.com
      secretName: myingress-cert # < cert-manager will store the created certificate in this secret.
  rules:
    - host:
      http:
        paths:
          - path: /(.*)
            pathType: ImplementationSpecific
            backend:
              service:
                name: studio-clusterip-service
                port:
                  number: 4000
```

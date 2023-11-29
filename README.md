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
kubectl port-forward mongodb-0 -n agnost 27017:27017
```

Similar can be done for redis, rabbitmq, and other services.

More information can be found [here](https://kubernetes.io/docs/tasks/access-application-cluster/port-forward-access-application-cluster/)

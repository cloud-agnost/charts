# Install Altogic Apps via Helm

First make sure that you have helm installed [here](https://helm.sh/docs/intro/install/)

Then run the below commands:

```bash
helm repo add cloud-agnost https://cloud-agnost.github.io/charts
helm install cloud-agnost-base cloud-agnost/base
```

You can configure the settings based on [values.yaml](https://github.com/cloud-agnost/charts/blob/master/base/values.yaml)

```bash
helm install cloud-agnost-base cloud-agnost/base --set meta=true
```

{{- define "rmqco.msgTopologyOperator.fullname" -}}
{{- printf "%s-%s" "rabbitmq-cluster-operator" "rabbitmq-messaging-topology-operator" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "rmqco.msgTopologyOperator.webhook.fullname" -}}
{{- printf "%s-%s" "rabbitmq-cluster-operator" "rabbitmq-messaging-topology-operator-webhook" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "common.names.namespace" -}}
{{- if eq .Release.Namespace "default" -}}
    {{- printf "%s" "operators" | trunc 63 | trimSuffix "-" -}}
{{- else -}}
    {{- printf "%s-%s" .Release.Namespace "operators" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "mariadb-operator-webhook.subjectName" -}}
{{- if eq .Release.Namespace "default" -}}
mariadb-operator-webhook.operators.svc
{{- else -}}
mariadb-operator-webhook.{{ .Release.Namespace }}-operators.svc
{{- end -}}
{{- end -}}

{{- define "mariadb-operator-webhook.altName" -}}
{{- if eq .Release.Namespace "default" -}}
  {{- printf "%s" "mariadb-operator-webhook.operators.svc" -}}
{{- else -}}
  {{- printf "%s.%s-%s" "mariadb-operator-webhook" .Release.Namespace "operators.svc" -}}
{{- end -}}
{{- end -}}

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

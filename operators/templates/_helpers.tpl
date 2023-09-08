{{/*
MariaDB Webhook certificate subject name
*/}}
{{- define "mariadb-operator-webhook.subjectName" -}}
{{- if eq .Release.Namespace "default" }}
mariadb-operator-webhook.operators.svc
{{- else }}
mariadb-operator-webhook.{{ .Release.Namespace }}-operators.svc
{{- end }}
{{- end }}

{{/*
Webhook certificate subject alternative name
*/}}
{{- define "mariadb-operator-webhook.altName" -}}
{{- if eq .Release.Namespace "default" }}
mariadb-operator-webhook.operators.svc
{{- else }}
mariadb-operator-webhook.{{ .Release.Namespace }}-operators.svc
{{- end }}
{{- end }}

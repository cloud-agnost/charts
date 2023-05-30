{{- define "provisioner-labels" -}}
helm.sh/chart: {{ .Chart.Name | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/name: provisioner
app.kubernetes.io/instance: {{ .Release.Name | quote }}
{{- end -}}
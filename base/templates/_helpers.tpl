{{- $secret := (lookup "v1" "Secret" .Release.Namespace "cluster-secrets") -}}

{{ if $secret -}}
{{- define "clusterIds" }}
clusterId: {{ $secret.data.clusterId }}
clusterAcessToken: {{ $secret.data.clusterAcessToken }}
{{- end }}

{{- define "tokens" }}
masterToken: {{ $secret.data.masterToken }}
accessToken: {{ $secret.data.accessToken }}
passPhrase: {{ $secret.data.passPhrase }}
{{- end }}

{{ else -}}

{{- define "clusterIds" }}
clusterId: {{ (printf "cls_%s" (uuidv4 | replace "-" "" | trunc 10)) }}
clusterAcessToken: {{ (printf "at_%s" (uuidv4 | replace "-" "" )) }}
{{- end }}

{{- define "tokens" }}
masterToken: {{ (printf "mt-%s" (uuidv4 | replace "-" "" )) }}
accessToken: {{ (printf "at-%s" (uuidv4 | replace "-" "" )) }}
passPhrase: {{ uuidv4 }}
{{- end }}
{{ end }}

{{- define "provisioner-labels" -}}
helm.sh/chart: {{ .Chart.Name | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/name: provisioner
app.kubernetes.io/instance: {{ .Release.Name | quote }}
{{- end -}}
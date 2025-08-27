{{/*
扩展名称
*/}}
{{- define "bookinfo.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
常用标签
*/}}
{{- define "bookinfo.labels" -}}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- with .Values.commonLabels }}
{{- toYaml . }}
{{- end }}
{{- end }}

{{/*
选择器标签
*/}}
{{- define "bookinfo.selectorLabels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
创建镜像地址
*/}}
{{- define "bookinfo.image" -}}
{{- $registry := .imageRoot.Values.global.imageRegistry | default .imageRoot.Values.imageRegistry -}}
{{- $repository := .imageName -}}
{{- $tag := .imageRoot.Values.global.imageTag | default .imageRoot.Values.imageTag | default .Chart.AppVersion -}}
{{- if $registry }}
{{- printf "%s/%s:%s" $registry $repository $tag -}}
{{- else }}
{{- printf "%s:%s" $repository $tag -}}
{{- end }}
{{- end }}

{{/*
创建服务账户名称
*/}}
{{- define "bookinfo.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "bookinfo.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}
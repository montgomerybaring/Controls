{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "dcetemplaterules.name" -}}
{{- if .Values.dcetemplaterules.version -}}
	{{- $name := default .Chart.Name .Values.nameOverride | trunc 59 | trimSuffix "-" -}}
	{{printf "%s-%s" $name .Values.dcetemplaterules.version -}}
{{- else -}}
	{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}


{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "dcetemplaterules.fullname" -}}
	{{- if .Values.fullnameOverride -}}
			{{- if .Values.deployment.version -}}
				{{- .Values.fullnameOverride | trunc 59 | trimSuffix "-" -}}-{{- .Values.deployment.version -}}
			{{- else -}}
				{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
			{{- end -}}
	{{- else -}}
		{{- $name := default .Chart.Name .Values.nameOverride -}}
			{{- if contains $name .Release.Name -}}
				{{- if .Values.deployment.version -}}
					{{- $name := printf "%s-%s" .Release.Name | trunc 59 | trimSuffix "-" .Values.deployment.version -}}
				{{- else -}}
					{{- $name := .Release.Name | trunc 63 | trimSuffix "-" -}}
				{{- end -}}
			{{- else -}}
				{{- if .Values.deployment.version -}}
					{{- $name := printf "%s-%s" .Release.Name $name | trunc 59 | trimSuffix "-" -}}
					{{- $name := printf "%s-%s" $name .Values.deployment.version -}}
				{{- else -}}
					{{- $name := printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
				{{- end -}}
			{{- end -}}
	{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "dcetemplaterules.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "dcetemplaterules.labels" -}}
app.kubernetes.io/name: {{ include "dcetemplaterules.name" . }}
helm.sh/chart: {{ include "dcetemplaterules.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if .Values.deployment.version }}
version: {{ .Values.deployment.version }}
{{- end }}
{{- end -}}

{{- define "dcetemplaterules.kname" -}}
{{- if .Values.dcetemplaterules.version -}}
	{{- .Values.fullnameOverride | trunc 59 | trimSuffix "-" -}}-{{- .Values.dcetemplaterules.version -}}
{{- else -}}
	{{- if .Values.deployment.version -}}
		{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
	{{- else -}}
		{{ include "dcetemplaterules.name" . }}
	{{- end -}}
{{- end -}}
{{- end -}}

{{- define "dcetemplaterules.matchlabels" -}}
app.kubernetes.io/name: {{ include "dcetemplaterules.kname" . }}
{{- if .Values.deployment.version }}
version: {{ .Values.deployment.version }}
{{- else }}
app.kubernetes.io/instance: {{ include "dcetemplaterules.name" . }}
{{- end -}}
{{- end -}}

{{- define "dcetemplaterules.matchLabels" -}}
app.kubernetes.io/name: {{ include "dcetemplaterules.name" . }}
app.kubernetes.io/instance: {{ include "dcetemplaterules.name" . }}
{{- if .Values.deployment.version }}
version: {{ .Values.deployment.version }}
{{- end }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "dcetemplaterules.selectorLabels" -}}
app.kubernetes.io/name: {{ include "dcetemplaterules.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "serviceaccountname" -}}
{{- if .Values.config.version -}}
{{ .Values.serviceAccount.name }}-{{ .Values.config.version }}
{{- else -}}
{{ .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}


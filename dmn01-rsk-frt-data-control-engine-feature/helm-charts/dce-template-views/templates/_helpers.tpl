{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "dcetemplateviews.name" -}}
{{- if .Values.dcetemplateviews.version -}}
	{{- $name := default .Chart.Name .Values.nameOverride | trunc 59 | trimSuffix "-" -}}
	{{printf "%s-%s" $name .Values.dcetemplateviews.version -}}
{{- else -}}
	{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}


{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "dcetemplateviews.fullname" -}}
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
{{- define "dcetemplateviews.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "dcetemplateviews.labels" -}}
app.kubernetes.io/name: {{ include "dcetemplateviews.name" . }}
helm.sh/chart: {{ include "dcetemplateviews.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if .Values.deployment.version }}
version: {{ .Values.deployment.version }}
{{- end }}
{{- end -}}

{{- define "dcetemplateviews.kname" -}}
{{- if .Values.dcetemplateviews.version -}}
	{{- .Values.fullnameOverride | trunc 59 | trimSuffix "-" -}}-{{- .Values.dcetemplateviews.version -}}
{{- else -}}
	{{- if .Values.deployment.version -}}
		{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
	{{- else -}}
		{{ include "dcetemplateviews.name" . }}
	{{- end -}}
{{- end -}}
{{- end -}}

{{- define "dcetemplateviews.matchlabels" -}}
app.kubernetes.io/name: {{ include "dcetemplateviews.kname" . }}
{{- if .Values.deployment.version }}
version: {{ .Values.deployment.version }}
{{- else }}
app.kubernetes.io/instance: {{ include "dcetemplateviews.name" . }}
{{- end -}}
{{- end -}}

{{- define "dcetemplateviews.matchLabels" -}}
app.kubernetes.io/name: {{ include "dcetemplateviews.name" . }}
app.kubernetes.io/instance: {{ include "dcetemplateviews.name" . }}
{{- if .Values.deployment.version }}
version: {{ .Values.deployment.version }}
{{- end }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "dcetemplateviews.selectorLabels" -}}
app.kubernetes.io/name: {{ include "dcetemplateviews.name" . }}
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

{{- define "dcetemplateviews.viewvalues" -}}
{{- join "," .Values.viewLables }}
{{- end -}}
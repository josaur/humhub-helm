{{/*
Expand the name of the chart.
*/}}
{{- define "humhub.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "humhub.fullname" -}}
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
Create chart name and version as used by the chart label.
*/}}
{{- define "humhub.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "humhub.labels" -}}
helm.sh/chart: {{ include "humhub.chart" . }}
{{ include "humhub.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "humhub.selectorLabels" -}}
app.kubernetes.io/name: {{ include "humhub.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "humhub.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "humhub.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Return the humhub Secret Name
*/}}
{{- define "humhub.secretName" -}}
{{- if .Values.existingSecret }}
    {{- printf "%s" .Values.existingSecret -}}
{{- else -}}
    {{- printf "%s" (include "humhub.fullname" .) -}}
{{- end -}}
{{- end -}}


{{/*
Return the humhub-database Secret Name
*/}}
{{- define "humhub.databaseSecretName" -}}
{{- if .Values.externalDatabase.existingSecret }}
    {{- printf "%s" .Values.externalDatabase.existingSecret -}}
{{- else -}}
    {{- printf "%s-database" (include "humhub.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the path to redis
*/}}
{{- define "humhub.redisHost" -}}
{{- if (not .Values.redis.humhubEnabled) }} 
    {{- printf "" -}}
{{- else -}}
{{- if  .Values.redis.enabled }}    
    {{- printf "%s-redis-master.%s.svc.cluster.local" .Release.Name .Release.Namespace -}}
{{- else -}}
    {{- printf  .Values.redis.hostname  -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "humhub.redisPort" -}}
{{- if (not .Values.redis.humhubEnabled) }} 
    {{- printf "" -}}
{{- else -}}
{{- if  .Values.redis.enabled }}    
    {{- printf "6379" -}}
{{- else -}}
    {{- printf  .Values.redis.port  -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return the humhub-redis Secret Name
*/}}
{{- define "humhub.redisSecretName" -}}
{{- if .Values.redis.auth.existingSecret }}
    {{- printf "%s" .Values.redis.auth.existingSecret -}}
{{- else -}}
    {{- printf "%s-redis" .Release.Name -}}
{{- end -}}
{{- end -}}

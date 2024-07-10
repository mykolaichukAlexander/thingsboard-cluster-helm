
{{/*
Expand the name of the chart.
*/}}
{{- define "thingsboard.name" -}}
{{- default .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Return a node label
*/}}
{{- define "thingsboard.node.label" -}}
{{ printf "%s-node" .Release.Name }}
{{- end }}

{{- define "thingsboard.node.host" }}
{{- if not .Values.installation.msa }}
{{- printf "%s-%s" .Release.Name "node"}}
{{- else}}
{{- printf "%s-%s" .Release.Name "core"}}
{{- end}}
{{- end}}

{{/*
Return a node image
*/}}
{{- define "thingsboard.node.image" -}}
{{- if .Values.installation.pe }}
{{- $repository := .Values.node.image.repository | default .Values.global.repository |  default "thingsboard/tb-pe-node" }}
{{- $appversion := .Values.node.image.tag | default (printf "%sPE" .Values.global.tag) | default (printf "%sPE" .Chart.AppVersion) }}
{{- printf "%s:%s" $repository $appversion }}
{{- else }}
{{- $repository := .Values.node.image.repository | default .Values.global.repository | default "thingsboard/tb-node" }}
{{- $appversion := .Values.node.image.tag | default .Values.global.tag | default (printf "%s" .Chart.AppVersion) }}
{{- printf "%s:%s" $repository $appversion }}
{{- end }}
{{- end }}

{{/*
Return a node image
*/}}
{{- define "thingsboard.engine.image" -}}
{{- if .Values.installation.pe }}
{{- $repository := .Values.engine.image.repository | default .Values.global.repository | default "thingsboard/tb-pe-node" }}
{{- $appversion := .Values.engine.image.tag | default (printf "%sPE" .Values.global.tag) | default (printf "%sPE" .Chart.AppVersion) }}
{{- printf "%s:%s" $repository $appversion }}
{{- else }}
{{- $repository := .Values.engine.image.repository | default .Values.global.repository | default "thingsboard/tb-node" }}
{{- $appversion := .Values.engine.image.tag | default .Values.global.tag | default (printf "%s" .Chart.AppVersion) }}
{{- printf "%s:%s" $repository $appversion }}
{{- end }}
{{- end }}

{{/*
Returning a port list for Tb node pod. If Transport is enabled but this is not MSA mode its ports will be added to Node.
*/}}
{{- define "thingsboard.node.ports" }}
{{- $context := index . "context" -}}
{{- $type := index . "type" -}}
{{- range $transportType, $transportConfig := $context.Values.transports }}
  {{- if not (eq $transportType "http") }}
    {{- if and $transportConfig.enabled ( not $context.Values.installation.isMSA )}}
      {{- range $transportConfig.ports }}
              {{- if eq $type "pod" }}
- containerPort: {{ .value }}
  name: {{ .name }}
  protocol: {{ .protocol | default "TCP" | toString }}
              {{- else }}
- port: {{ .value }}
  name: {{ .name }}
  protocol: {{ .protocol | default "TCP" | toString }}
              {{- end }}
      {{- end }}
    {{- end }}
  {{- end }}
{{- end }}
{{- end }}

{{- define "thingsboard.node.resources.default" }}
    resources:
      limits:
        cpu: "2000m"
        memory: 4000Mi
      requests:
        cpu: "1000m"
        memory: 3000Mi
{{- end}}

{{/*
Return a core label
*/}}
{{- define "thingsboard.core.label" -}}
{{ printf "%s-core" .Release.Name }}
{{- end }}

{{- define "thingsboard.core.resources.default" }}
    resources:
      limits:
        cpu: "2000m"
        memory: 4000Mi
      requests:
        cpu: "1000m"
        memory: 3000Mi
{{- end}}

{{/*
Return a rule engine label
*/}}
{{- define "thingsboard.ruleengine.label" -}}
{{ printf "%s-rule-engine" .Release.Name }}
{{- end }}

{{- define "thingsboard.ruleengine.resources.default" }}
    resources:
      limits:
        cpu: "2000m"
        memory: 4000Mi
      requests:
        cpu: "1000m"
        memory: 3000Mi
{{- end}}

{{/*
Return a transport image
*/}}
{{- define "thingsboard.transport.image" -}}
{{- $context := index . "context" -}}
{{- $transportBody := index . "transportBody" -}}
{{- if $context.Values.installation.pe }}
{{- $repository := $transportBody.image.repository | default (printf "thingsboard/tb-pe-%s" $transportBody.name) }}
{{- $appversion := $transportBody.image.tag | default (printf "%sPE" .Values.global.tag) | default (printf "%sPE" $context.Chart.AppVersion) }}
{{- printf "%s:%s" $repository $appversion }}
{{- else }}
{{- $repository := $transportBody.image.repository | default (printf "thingsboard/tb-%s" $transportBody.name) }}
{{- $appversion := $transportBody.image.tag | default .Values.global.tag | default (printf "%s" $context.Chart.AppVersion) }}
{{- printf "%s:%s" $repository $appversion }}
{{- end }}
{{- end }}


{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "thingsboard.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Return redis configurations environment variables for thingsboard services
*/}}
{{- define "thingboard.cache.configuration.ref"}}
{{- if or (or .Values.internalRedisCluster.enabled .Values.internalRedis.enabled) (or .Values.externalRedis.enabled .Values.installation.msa)}}
- configMapRef:
    name: {{.Release.Name}}-redis-config
- secretRef:
    name: {{.Release.Name}}-redis-secret
{{- end }}
{{- end}}

{{/*
Return redis password
*/}}
{{- define "thingboard.redis.password" }}
{{- if or (or .Values.internalRedisCluster.enabled .Values.internalRedis.enabled) (or .Values.externalRedis.enabled .Values.installation.msa)}}
  {{- if .Values.externalRedis.enabled }}
  REDIS_PASSWORD: {{ ternary (.Values.externalRedis.password | b64enc) "" (not (empty .Values.externalRedis.password)) }}
  {{- else if .Values.internalRedisCluster.enabled }}
  REDIS_PASSWORD: {{ ternary (.Values.internalRedisCluster.password | b64enc) "" .Values.internalRedisCluster.usePassword }}
  {{- else }}
  REDIS_PASSWORD: {{ ternary (.Values.internalRedis.auth.password | b64enc) "" .Values.internalRedis.auth.enabled }}
  {{- end }}
{{- end }}
{{- end}}


{{/*
Return cassandra configurations environment variables for thingsboard services
*/}}
{{- define "thingboard.cassandra.configuration.ref"}}
{{- if or .Values.internalCassandra.enabled .Values.externalCassandra.enabled }}
- configMapRef:
    name: {{.Release.Name}}-cassandra-config
- secretRef:
    name: {{.Release.Name}}-cassandra-secret
{{- end }}
{{- end}}

{{/*
Return postgresql configurations environment variables for thingsboard services
*/}}
{{- define "thingboard.postgres.configuration.ref"}}
- configMapRef:
    name: {{.Release.Name}}-postgres-config
- secretRef:
    name: {{.Release.Name}}-postgres-secret
{{- end}}


{{/*
Return kafka configurations environment variables for thingsboard services
*/}}
{{- define "thingboard.queue.configuration.ref"}}
{{- if or (or .Values.internalKafka.enabled .Values.externalKafka.enabled) .Values.installation.msa }}
- configMapRef:
    name: {{.Release.Name}}-kafka-config
{{- end }}
{{- end}}

{{/*
Return zookeeper configurations environment variables for thingsboard services
*/}}
{{- define "thingboard.coordinator.configuration.ref"}}
{{- if or (or .Values.internalZookeeper.enabled .Values.externalZookeeper.enabled) .Values.installation.msa }}
- configMapRef:
    name: {{.Release.Name}}-zookeeper-config
{{- end }}
{{- end}}

{{- define "thingsboard.imagePullSecret" }}
{{- printf "{\"auths\": {\"%s\": {\"auth\": \"%s\"}}}" .Values.dockerAuth.registry (printf "%s:%s" .Values.dockerAuth.username .Values.dockerAuth.password | b64enc) | b64enc }}
{{- end }}


{{- define "thingsboard.ts.host" }}
{{- $tbTSHost := "" -}}
{{- range $key, $transport := .Values.transports }}
  {{- if and $transport.enabled (eq $key "http")}}
    {{- $tbTSHost = printf "%s-%s" $.Release.Name $transport.name }}
  {{- end -}}
{{- end -}}
{{ if eq $tbTSHost "" -}}
{{- ternary (printf "%s-%s" .Release.Name "node" ) (printf "%s-%s" .Release.Name "core" ) (not .Values.installation.msa) -}}
{{ else }}
{{- print $tbTSHost -}}
{{- end }}
{{- end}}

{{- define "thingsboard.web.host" }}
{{- if not .Values.installation.msa }}
{{- printf "%s-%s" .Release.Name "node"}}
{{- else}}
{{- printf "%s-%s" .Release.Name "web-ui" }}
{{- end}}
{{- end}}

{{/*
Return a web ui image
*/}}
{{- define "thingsboard.web.image" -}}
{{- if .Values.installation.pe }}
{{- $repository := .Values.web.image.repository | default "thingsboard/tb-pe-web-ui" }}
{{- $appversion := .Values.web.image.tag | default (printf "%sPE" .Values.global.tag) | default (printf "%sPE" .Chart.AppVersion) }}
{{- printf "%s:%s" $repository $appversion }}
{{- else }}
{{- $repository := .Values.web.image.repository | default "thingsboard/tb-web-ui" }}
{{- $appversion := .Values.web.image.tag | default .Values.global.tag | default (printf "%s" .Chart.AppVersion) }}
{{- printf "%s:%s" $repository $appversion }}
{{- end }}
{{- end }}


{{/*
Return a web report image
*/}}
{{- define "thingsboard.report.image" -}}
{{- $repository := .Values.report.image.repository | default "thingsboard/tb-pe-web-report" }}
{{- $appversion := .Values.report.image.tag | default (printf "%sPE" .Values.global.tag) |  default (printf "%sPE" .Chart.AppVersion) }}
{{- printf "%s:%s" $repository $appversion }}
{{- end }}

{{/*
Return a js image
*/}}
{{- define "thingsboard.js.image" -}}
{{- if .Values.installation.pe }}
{{- $repository := .Values.js.image.repository | default "thingsboard/tb-pe-js-executor" }}
{{- $appversion := .Values.js.image.tag | default (printf "%sPE" .Values.global.tag) | default (printf "%sPE" .Chart.AppVersion) }}
{{- printf "%s:%s" $repository $appversion }}
{{- else }}
{{- $repository := .Values.js.image.repository | default "thingsboard/tb-js-executor" }}
{{- $appversion := .Values.js.image.tag | default .Values.global.tag | default (printf "%s" .Chart.AppVersion) }}
{{- printf "%s:%s" $repository $appversion }}
{{- end }}
{{- end }}



{{/*
Init container that will slow deployment and let Service deploy after all script in conteiner will exit success or timeout
*/}}
{{- define "thingsboard.initcontainers" }}
{{- $context:= index . "context" | default . }}
{{- if $context.Values.installation.installTb }}
{{- $query := index . "pg_query" | default "Select count(*) from queue;" }}
- name: validate-db
  image: thingsboard/toolbox:1.6.0
  env:
    - name: RETRY_COUNT
      value: "5"
    - name: SECONDS_BETWEEN_RETRY
      value: "40"
    - name: PGHOST
      value: {{ ternary (printf "%s-%s" $context.Release.Name $context.Values.internalPostgresql.nameOverride) $context.Values.externalPostgresql.host $context.Values.internalPostgresql.enabled }}
    - name: PGDATABASE
      value: {{ ternary $context.Values.internalPostgresql.auth.database $context.Values.externalPostgresql.database $context.Values.internalPostgresql.enabled }}
    - name: PGUSER
      value: {{ ternary $context.Values.internalPostgresql.auth.username $context.Values.externalPostgresql.username $context.Values.internalPostgresql.enabled }}
    - name: QUERY_TO_VALIDATE
      value: {{ $query | quote }}
    - name: PGPASSWORD
      valueFrom:
        secretKeyRef:
          name: {{ $context.Release.Name }}-postgres-secret
          key: SPRING_DATASOURCE_PASSWORD
  {{- if or $context.Values.internalCassandra.enabled $context.Values.externalCassandra.enabled }}
    - name: CASSANDRA_HOST
      value: {{ ternary (printf "%s-%s" $context.Release.Name $context.Values.internalCassandra.nameOverride ) ( printf "%s:%s" $context.Values.externalCassandra.host $context.Values.externalCassandra.port) $context.Values.internalCassandra.enabled }}
    - name: CASSANDRA_USER
      value: {{ ternary $context.Values.internalCassandra.dbUser.user $context.Values.externalCassandra.user $context.Values.internalCassandra.enabled }}
    - name: CASSANDRA_PASSWORD
      valueFrom:
        secretKeyRef:
          key: CASSANDRA_PASSWORD
          name: {{ $context.Release.Name }}-cassandra-secret
  {{- end }}
  command:
    - bash
  args:
    - script-runner.sh
    - psql-validator.sh
  {{- if or $context.Values.internalCassandra.enabled $context.Values.externalCassandra.enabled }}
    - cqlsh-validator.sh
  {{- end }}
{{- else }}
[]
{{- end }}
{{- end}}

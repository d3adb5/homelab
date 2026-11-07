{{- define "homelab.avoidControlPlane" -}}
nodeAffinity:
  preferredDuringSchedulingIgnoredDuringExecution:
    - weight: 100
      preference:
        matchExpressions:
          - key: node-role.kubernetes.io/control-plane
            operator: DoesNotExist
{{- end }}

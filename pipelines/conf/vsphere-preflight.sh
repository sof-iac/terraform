#!/usr/bin/env bash
# Valida VSPHERE_SERVER antes do terragrunt (Jenkins). Não imprime senha.
set -euo pipefail

vsphere_normalize_server() {
  local h="${VSPHERE_SERVER:-}"
  h="${h#"${h%%[![:space:]]*}"}"
  h="${h%"${h##*[![:space:]]}"}"
  h="${h#https://}"
  h="${h#http://}"
  h="${h%%/*}"
  export VSPHERE_SERVER="$h"
}

vsphere_preflight() {
  vsphere_normalize_server
  if [ -z "${VSPHERE_SERVER:-}" ]; then
    echo "ERRO: VSPHERE_SERVER vazio. Revise a credencial Jenkins TF_VAR_hostname_vcenter_* do Site selecionado."
    exit 1
  fi
  echo "DEBUG VSPHERE_SERVER (normalizado): length=${#VSPHERE_SERVER} suffix=${VSPHERE_SERVER##*.}"
  if command -v getent >/dev/null 2>&1; then
    if ! getent hosts "$VSPHERE_SERVER" >/dev/null 2>&1; then
      echo "ERRO: o Jenkins não resolve o hostname do vCenter: '${VSPHERE_SERVER}'"
      echo "  - Confira em Manage Jenkins → Credentials → TF_VAR_hostname_vcenter_k (ou _516)"
      echo "  - Use só FQDN (ex.: algo.sof.intra), sem https://"
      echo "  - No nó Jenkins, teste: getent hosts '${VSPHERE_SERVER}'"
      exit 1
    fi
    echo "DEBUG DNS OK: $(getent hosts "$VSPHERE_SERVER" | head -1)"
  fi
}

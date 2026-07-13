#!/bin/sh
# Biblioteca para source no Jenkins (. vsphere-preflight.sh && vsphere_preflight)
# Compatível com /bin/sh (dash). Sem "set -e" aqui — o script é sourced pelo step sh do Jenkins.

vsphere_trim_secret() {
  _v="$1"
  printf '%s' "$_v" | tr -d '\r\n'
}

# Usuário e senha do Site via Jenkins (TF_VAR_username/password_vcenter_*); senão Vault (passwd_vcenter).
vsphere_export_credentials() {
  _pass=""
  _user=""
  _site="${VCENTER_SITE:-}"

  if [ "$_site" = "vsphere-516" ]; then
    _pass="${TF_VAR_password_vcenter_516:-}"
    _user="${TF_VAR_username_vcenter_516:-}"
  elif [ "$_site" = "vsphere-k" ]; then
    _pass="${TF_VAR_password_vcenter_k:-}"
    _user="${TF_VAR_username_vcenter_k:-}"
  fi

  if [ -n "$_user" ]; then
    export VSPHERE_USER="$(vsphere_trim_secret "$_user")"
    echo "DEBUG VSPHERE_USER: origem=jenkins-${_site}"
  elif [ -n "${USER_VCENTER:-}" ]; then
    export VSPHERE_USER="$(vsphere_trim_secret "$USER_VCENTER")"
    echo "DEBUG VSPHERE_USER: origem=USER_VCENTER"
  else
    export VSPHERE_USER='user_svc_jenkins'
    echo "DEBUG VSPHERE_USER: origem=fixo-user_svc_jenkins (TF_VAR_username_vcenter_* ausente)"
  fi

  if [ -n "$_pass" ]; then
    export VSPHERE_PASSWORD="$(vsphere_trim_secret "$_pass")"
    echo "DEBUG VSPHERE_PASSWORD: origem=jenkins-${_site}"
  elif [ -n "${passwd_vcenter:-}" ]; then
    export VSPHERE_PASSWORD="$(vsphere_trim_secret "$passwd_vcenter")"
    echo "DEBUG VSPHERE_PASSWORD: origem=vault-user_svc_jenkins"
  fi

  echo "DEBUG VSPHERE_USER: set=${VSPHERE_USER:+yes} length=${#VSPHERE_USER}"
}

vsphere_normalize_server() {
  h="${VSPHERE_SERVER:-}"
  h="${h#"${h%%[![:space:]]*}"}"
  h="${h%"${h##*[![:space:]]}"}"
  h="${h#https://}"
  h="${h#http://}"
  h="${h%%/*}"
  export VSPHERE_SERVER="$h"
}

vsphere_preflight() {
  vsphere_normalize_server
  vsphere_export_credentials
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
    echo "DEBUG DNS OK: $(getent hosts "$VSPHERE_SERVER" | head -n 1)"
  fi
  if [ -z "${VSPHERE_PASSWORD:-}" ]; then
    echo "ERRO: VSPHERE_PASSWORD vazio. Configure TF_VAR_password_vcenter_${VCENTER_SITE:-*} no Jenkins ou o secret Vault user_svc_jenkins."
    exit 1
  fi
  if [ -z "${VSPHERE_USER:-}" ]; then
    echo "ERRO: VSPHERE_USER vazio. Configure TF_VAR_username_vcenter_${VCENTER_SITE:-*} no Jenkins."
    exit 1
  fi
  echo "DEBUG VSPHERE_PASSWORD: set=yes length=${#VSPHERE_PASSWORD}"
}

#!/usr/bin/env bash
# Teste local do backend MinIO/S3 e terragrunt plan.
# NÃO coloque credenciais neste arquivo.
#
# Uso (na raiz do repositório, onde está envs/ e pipelines/):
#   export AWS_ACCESS_KEY_ID="sua-access-key-do-minio"
#   export AWS_SECRET_ACCESS_KEY="sua-secret-key-do-minio"
#   export VSPHERE_SERVER="vcenter516.sof.intra"
#   export VSPHERE_USER="seu-user"
#   export VSPHERE_PASSWORD="sua-senha"
#   export TF_VAR_DISTRO="alma"
#   export TF_VAR_VM_PASS="senha-vm"
#   ./pipelines/linux/test-minio-plan.sh
#
# Se der InvalidAccessKeyId mesmo com export correto, limpe o cache (pode ter sido criado pelo Jenkins):
#   CLEAR_CACHE=1 ./pipelines/linux/test-minio-plan.sh
#
# Ou, no PowerShell (Windows):
#   $env:AWS_ACCESS_KEY_ID="..."; $env:AWS_SECRET_ACCESS_KEY="..."
#   (demais variáveis)
#   bash ./pipelines/linux/test-minio-plan.sh

set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# Funciona com o script na raiz do repo (executa_plan.sh) ou em pipelines/linux/ (test-minio-plan.sh)
if [ -f "$SCRIPT_DIR/pipelines/conf/terragrunt.hcl" ]; then
  REPO_ROOT="$SCRIPT_DIR"
elif [ -f "$SCRIPT_DIR/../../pipelines/conf/terragrunt.hcl" ]; then
  REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
else
  echo "ERRO: Não encontrado pipelines/conf/terragrunt.hcl a partir de $SCRIPT_DIR"
  exit 1
fi
cd "$REPO_ROOT"
echo "Raiz do repositório: $REPO_ROOT"

if [ -z "$AWS_ACCESS_KEY_ID" ] || [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
  echo "ERRO: Defina AWS_ACCESS_KEY_ID e AWS_SECRET_ACCESS_KEY no ambiente."
  echo "Exemplo: export AWS_ACCESS_KEY_ID=... export AWS_SECRET_ACCESS_KEY=..."
  exit 1
fi
# Garante que os filhos (terragrunt/terraform) vejam as credenciais
export AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY
echo "DEBUG: AWS_ACCESS_KEY_ID definida (length=${#AWS_ACCESS_KEY_ID}), AWS_SECRET_ACCESS_KEY definida (length=${#AWS_SECRET_ACCESS_KEY})"

SRC_HCL="$REPO_ROOT/pipelines/conf/terragrunt.hcl"
if [ ! -f "$SRC_HCL" ]; then
  echo "ERRO: Arquivo não encontrado: $SRC_HCL"
  echo "Verifique se o job faz checkout do repositório completo (incluindo pipelines/conf/)."
  exit 1
fi
echo "Copiando pipelines/conf/terragrunt.hcl para envs/..."
cp -f "$SRC_HCL" "$REPO_ROOT/envs/"

echo "Diretório de trabalho: envs/test/vsphere-516/vms-testes"
cd "$REPO_ROOT/envs/test/vsphere-516/vms-testes"

# Limpa cache se pedido (evita usar backend/state de execução anterior, ex. Jenkins)
if [ -n "${CLEAR_CACHE:-}" ]; then
  echo "Limpando .terragrunt-cache..."
  rm -rf .terragrunt-cache
fi

export AWS_VERIFY_SSL="${AWS_VERIFY_SSL:-false}"
export TF_IN_AUTOMATION="${TF_IN_AUTOMATION:-true}"
export AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY

# Passa credenciais explicitamente na linha de comando para o terragrunt (evita outro valor no ambiente)
echo "Executando terragrunt init..."
env AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY_ID" AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY" terragrunt init

echo "Executando terragrunt plan -lock=false..."
env AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY_ID" AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY" terragrunt plan -lock=false

echo "Concluído: init e plan OK com as credenciais atuais."

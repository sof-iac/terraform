# =============================================================================
# Template de import — vsphere_virtual_machine (módulo linux/windows)
# =============================================================================
#
# Use quando a VM já existe no vCenter, mas o tfstate no PostgreSQL está vazio
# ou sem o recurso.
#
# Prefira o pipeline Jenkins:
#   pipelines/linux/jppl_importVM_terragrunt
#
# Parâmetros do job:
#   Ambiente / Site / Grupo  → stack Terragrunt (ex.: prod / vsphere-516 / vms-etls)
#   VmName                   → chave do for_each (= staticvmname / nome da VM)
#   VmId                     → UUID da VM no vCenter (recomendado) ou MOID (vm-XXXX)
#
# Como obter o UUID no vCenter:
#   VM → Summary → UUID  (ou govc: govc vm.info -json NOME | jq -r .VirtualMachines[0].Config.Uuid)
#
# Sintaxe do endereço Terraform (for_each):
#   vsphere_virtual_machine.vm["NOME_DA_VM"]
#
# Exemplo de bloco import (Terraform >= 1.5) — NÃO é aplicado sozinho neste
# diretório; serve de referência. O pipeline usa `terragrunt import`.
#
# -----------------------------------------------------------------------------
import {
  to = vsphere_virtual_machine.vm["TSBD31"]
  id = "vm-48687"
}
# -----------------------------------------------------------------------------
#
# Equivalente via CLI (executado dentro do stack, ex. envs/prod/vsphere-516/vms-etls):
#
#   terragrunt import 'vsphere_virtual_machine.vm["PDWH03-JDK11"]' '42204605-34db-5a3d-51f3-221dee7d3591'
#
# Depois do import, rode um plan no mesmo stack para reconciliar drift
# (discos, tags, customize, etc.).
# =============================================================================

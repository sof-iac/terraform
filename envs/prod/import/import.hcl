# =============================================================================
# Template de import — recursos vSphere no tfstate (PostgreSQL)
# =============================================================================
#
# Pipelines Jenkins:
#   VM:  pipelines/linux/jppl_importVM_terragrunt
#   Tag: pipelines/linux/jppl_importTag_Vcenter_terragrunt
#
# -----------------------------------------------------------------------------
# VM (módulo linux/windows)
# -----------------------------------------------------------------------------
# Endereço: vsphere_virtual_machine.vm["NOME"]
# ID:       UUID da VM (recomendado) ou MOID vm-XXXX
#
#   terragrunt import 'vsphere_virtual_machine.vm["PDWH03-JDK11"]' '4220-...'
#
# -----------------------------------------------------------------------------
# Tag (módulo tags_vcenter)
# -----------------------------------------------------------------------------
# Endereço: module.terraform_vsphere_tags["Tags_X"].vsphere_tag.tag
# ID:       URN no vCenter
#           Ex.: urn:vmomi:InventoryServiceTag:3021ded9-...:GLOBAL
#
#   terragrunt import \
#     'module.terraform_vsphere_tags["Tags_Postgres"].vsphere_tag.tag' \
#     'urn:vmomi:InventoryServiceTag:....:GLOBAL'
#
# Pré-requisito: a chave já deve existir no terragrunt.hcl do stack
# (ex.: envs/prod/vsphere-516/tags_vcenter → Tags_Postgres).
#
# Depois do import, rode plan no mesmo stack para reconciliar drift.
# =============================================================================

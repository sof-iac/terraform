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
#
# IMPORTANTE: o provider vsphere NÃO aceita o URN da URL no import.
# Exige JSON com category_name + tag_name (iguais ao terragrunt.hcl):
#
#   terragrunt import \
#     'module.terraform_vsphere_tags["Tags_ambienteProd"].vsphere_tag.tag' \
#     '{"category_name": "Ambiente", "tag_name": "Prod"}'
#
# No Jenkins: TagKey=Tags_ambienteProd | CategoryName=Ambiente | TagName=Prod
#
# Depois do import, rode plan no mesmo stack para reconciliar drift.
# =============================================================================

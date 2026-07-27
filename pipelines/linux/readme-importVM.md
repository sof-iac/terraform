# Import de VM existente no tfstate (PostgreSQL)

Quando a VM já existe no vCenter, mas o state no PostgreSQL está vazio ou sem o recurso.

## Pipeline

Arquivo: `pipelines/linux/jppl_importVM_terragrunt`

Referência HCL: `envs/prod/import/import.hcl`

## Parâmetros

| Parâmetro | Exemplo | Descrição |
|-----------|---------|-----------|
| Ambiente | `prod` | Ambiente do stack |
| Site | `vsphere-516` | vCenter |
| Grupo | `vms-etls` | Pasta do `terragrunt.hcl` |
| VmName | `PDWH03-JDK11` | Chave do `for_each` / `staticvmname` no HCL |
| VmId | UUID | UUID da VM (recomendado) ou MOID `vm-XXXX` |
| RodarPlanAposImport | `true` | Roda `terragrunt plan` após o import |

## Pré-requisitos

1. A VM deve existir no vCenter.
2. O `terragrunt.hcl` do Grupo já deve declarar a VM em `inputs.vm`.
3. Prefira o **UUID** da VM (Summary no vCenter), não só o MOID da URL.

## O que o job faz

```text
terragrunt import 'vsphere_virtual_machine.vm["VmName"]' 'VmId'
```

Não cria nem destrói a VM — só associa ao state do PostgreSQL do stack
(`terraform_envs/prod/vsphere-516/vms-etls`, etc.).

## Depois do import

Revise o plan. É comum aparecer drift (customize, tags, disks). Ajuste o HCL
ou aceite alterações conscientes — **não** aplique um recreate sem analisar.

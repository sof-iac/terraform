# Import de Category vCenter (Terragrunt)

Arquivo: `pipelines/linux/jppl_importCategory_Vcenter_terragrunt`

Importa categorias **já existentes** no vCenter para o tfstate. **Não cria** nada no vCenter.

## Diferença vs Tag

| | Category | Tag |
|--|----------|-----|
| Import ID | **nome** da categoria (`Ambiente`) | JSON `category_name` + `tag_name` |
| Endereço | `module.terraform_vsphere_category["KEY"].vsphere_tag_category.category` | `module.terraform_vsphere_tags["KEY"].vsphere_tag.tag` |

## Parâmetros Jenkins (uma category por run)

| Parâmetro | Exemplo |
|-----------|---------|
| Ambiente | `prod` |
| Site | `vsphere-516` |
| Grupo | `category_vcenter` |
| CategoryKey | `category_ambiente` |
| CategoryName | `Ambiente` |

## As 5 que o plan queria criar (rodar 5 vezes)

| CategoryKey | CategoryName |
|-------------|--------------|
| `category_ambiente` | `Ambiente` |
| `category_Origem` | `Origem` |
| `category_aplicacao` | `Aplicacao` |
| `category_cluster` | `Cluster` |
| `category_k8s_storage` | `k8s_storage` |

Já no state (não importar de novo): `category_guest_os`, `category_k8s_region`, `category_k8s_zone`, `category_Responsavel`.

## Equivalente manual (no diretório do stack)

```bash
terragrunt import 'module.terraform_vsphere_category["category_ambiente"].vsphere_tag_category.category' 'Ambiente'
terragrunt import 'module.terraform_vsphere_category["category_Origem"].vsphere_tag_category.category' 'Origem'
terragrunt import 'module.terraform_vsphere_category["category_aplicacao"].vsphere_tag_category.category' 'Aplicacao'
terragrunt import 'module.terraform_vsphere_category["category_cluster"].vsphere_tag_category.category' 'Cluster'
terragrunt import 'module.terraform_vsphere_category["category_k8s_storage"].vsphere_tag_category.category' 'k8s_storage'
```

## Depois do import

Rode `terragrunt plan`. Se aparecer mudança de `cardinality` (`SINGLE` ↔ `MULTIPLE`) ou `associable_types`, **não aplique recreate** sem alinhar o módulo ou o vCenter — alterar cardinality em category existente é sensível.

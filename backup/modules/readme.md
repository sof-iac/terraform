## Modulos para Terraform

```
/projeto-terraform
  ├── main.tf                  # O arquivo principal onde o módulo é chamado
  ├── vars.tf                  # O arquivo de variáveis
  ├── terragrunt.hcl           # Arquivo de configuração do Terragrunt
  └── vsphere-linux-vm         # Diretório do módulo
      ├── main.tf              # O arquivo principal do módulo
      ├── variables.tf         # Variáveis específicas do módulo
      └── outputs.tf           # Saídas do módulo
```

## Terraform

### Estrutura de trabalho

```
1 - modules
2 - aws
3 - blocok
4 - sof
```

## Boas práticas

### Estrutura de Diretórios:

Organize seus arquivos Terraform em uma estrutura de diretórios que reflita a hierarquia do seu datacenter. Por exemplo, você pode ter diretórios separados para cada ambiente (dev, staging, prod), e dentro de cada ambiente, diretórios para cada serviço (jenkins, bancos de dados, sistemas de controle, etc).

### Módulos:

Use módulos para encapsular e reutilizar o código Terraform. Cada módulo deve ser responsável por criar um único recurso ou um conjunto de recursos relacionados. Por exemplo, você pode ter um módulo para criar uma VM, outro módulo para configurar o Jenkins, etc.

### Variáveis:

Use variáveis para tornar seus módulos mais flexíveis. Isso permite que você use o mesmo módulo para criar VMs com diferentes configurações.

### Arquivos de Estado Remotos:

Use arquivos de estado remotos para manter o estado do seu datacenter. Isso permite que várias pessoas trabalhem no mesmo datacenter sem conflitos.

### Workspaces:

Use workspaces do Terraform para separar o estado de diferentes ambientes. Por exemplo, você pode ter um workspace para dev, outro para staging e outro para prod.

### Planos de Execução:

Sempre execute terraform plan antes de terraform apply para verificar as alterações que serão feitas. Lembrando que estamos utilizando Terragrunt uma camada acima

### Controle de Versão:

Use um sistema de controle de versão como o Git para rastrear as alterações no seu código Terraform. Isso permite que você veja quem fez o quê e quando, e também permite que você reverta para uma versão anterior se algo der errado.

### Exemplo da estrutura

```
modules
    ubuntu
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
aws
├── env
    ├── dev
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── staging
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── prod
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
blocok
├── env
    ├── dev
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── staging
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── prod
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
sof
├── env
    ├── dev
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── staging
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── prod
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

### Configurando o arquivo tfstate no Terragrunt no diretório /data local

No arquivo terragrunt.hcl, você pode especificar o local do arquivo tfstate usando o bloco remote_state com o backend local:

```
remote_state {
  backend = "local"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    path = "/data/terraform.tfstate"
  }
}
```

Este bloco de código instrui o Terragrunt a gerar um arquivo backend.tf no módulo Terraform que ele baixa no diretório .terragrunt-cache. A função get_terragrunt_dir() será substituída pelo caminho para o diretório que contém o terragrunt.hcl. Isso fará com que o Terraform coloque o arquivo de estado no mesmo diretório que o arquivo terragrunt.hcl.

### Configurando o arquivo tfstate no Terraform no diretório /data local

Para o Terraform, você pode especificar o local do arquivo tfstate usando o backend "local" no seu arquivo de configuração Terraform:

```
terraform {
  backend "local" {
    path = "/data/terraform.tfstate"
  }
}
```

Este bloco de código instrui o Terraform a armazenar o arquivo de estado tfstate no diretório /data.

Além disso, você pode especificar o local do arquivo tfstate ao executar os comandos terraform apply ou terraform plan usando a opção -state:

```
terraform apply -state=/data/terraform.tfstate
```

## Terraform: Módulos, Configuração DRY e Imutabilidade

### Módulos no Terraform

Os **módulos** no Terraform são usados para criar blocos de código reutilizáveis que podem ser usados em várias partes do seu código Terraform. Eles ajudam a organizar o código, tornando-o mais legível e manutenível.

### Configuração DRY

DRY significa "Don't Repeat Yourself" (Não se Repita). No contexto do Terraform, uma configuração **DRY** significa que você deve evitar a duplicação de código tanto quanto possível. Em vez disso, você deve usar módulos e variáveis para reutilizar o código.

### Backend DRY

Um **backend DRY** no Terraform é uma maneira de gerenciar o estado do Terraform de forma eficiente. Em vez de definir o backend em cada arquivo, você pode definir uma vez e reutilizá-lo em todos os seus arquivos Terraform.

### Provider DRY

Um **provider DRY** no Terraform é semelhante ao backend DRY. Em vez de definir o provider em cada arquivo, você pode definir uma vez e reutilizá-lo em todos os seus arquivos Terraform.

### Imutabilidade dos Módulos Terraform

A **imutabilidade** é um conceito importante no Terraform. Significa que, uma vez que um recurso é criado, ele não é alterado. Em vez disso, se uma mudança é necessária, o recurso antigo é destruído e um novo é criado. Isso é especialmente útil ao trabalhar com ambientes de trabalho no Terraform, pois garante que cada ambiente seja consistente e previsível.

### Link para baixar a release a integrar no VRA e a chave SHA

https://releases.hashicorp.com/terraform/

### Guest OS Indentifier VM no Vsphere - Utilizado para identificar o Guestid a usar no Terraform

https://vdc-download.vmware.com/vmwb-repository/dcr-public/b50dcbbf-051d-4204-a3e7-e1b618c1e384/538cf2ec-b34f-4bae-a332-3820ef9e7773/vim.vm.GuestOsDescriptor.GuestOsIdentifier.html

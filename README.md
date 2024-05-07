## Terraform
### Estrutura de trabalho
```
1 - modules
2 - sof-aws
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
Sempre execute terraform plan antes de terraform apply para verificar as alterações que serão feitas.
### Controle de Versão: 
Use um sistema de controle de versão como o Git para rastrear as alterações no seu código Terraform. Isso permite que você veja quem fez o quê e quando, e também permite que você reverta para uma versão anterior se algo der errado.

### Exemplo da estrutura
.
├── main.tf
├── variables.tf
├── outputs.tf
└── env
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

### Link para baixar a release a integrar no VRA e a chave SHA
https://releases.hashicorp.com/terraform/

### Guest OS Indentifier VM no Vsphere - Utilizado para identificar o Guestid a usar no Terraform
https://vdc-download.vmware.com/vmwb-repository/dcr-public/b50dcbbf-051d-4204-a3e7-e1b618c1e384/538cf2ec-b34f-4bae-a332-3820ef9e7773/vim.vm.GuestOsDescriptor.GuestOsIdentifier.html



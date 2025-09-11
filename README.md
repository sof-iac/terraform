## 🧰 Terraform e Terragrunt

### 🗂️ Estrutura de Trabalho (visão geral)

```
modules/
aws/
envs/
pipelines/
```

- **modules**: módulos reutilizáveis (`aws`, `vsphere`, `minio` etc.)
- **aws**: exemplos e ambientes com Terragrunt
- **envs**: infraestrutura por ambiente e provider (vSphere, MinIO, etc.)
- **pipelines**: scripts e configurações para CI/CD

### ✅ Boas Práticas

- **Estrutura de diretórios**: reflita ambientes (dev, test, prod) e domínios (rede, vms, s3, dns).
- **Módulos**: encapsule recursos relacionados; promova reuso e versionamento.
- **Variáveis**: parametrize módulos para cenários diferentes sem duplicação.
- **Estado remoto**: armazene o `tfstate` de forma centralizada e bloqueada.
- **Workspaces**: separe estados por ambiente quando fizer sentido.
- **Plan primeiro**: sempre rode `terraform plan`/`terragrunt plan` antes de `apply`.
- **Git**: versionamento obrigatório; PRs, code review e tags de release.

### 🧱 Exemplo de Estrutura (simplificada)

```
modules
  ├── aws
  │   ├── network/
  │   ├── ec2-instance/
  │   ├── route-53/
  │   └── s3-bucket/
  └── vsphere
      ├── datacenter-config/
      ├── network/
      ├── storage/
      └── vm/

aws
  └── envs
      ├── exemplos/
      └── prod/

envs
  ├── base/
  ├── dev/
  ├── lab/
  └── prod/

pipelines
  ├── conf/
  ├── linux/
  └── windows/
```

### 🗄️ Estado (tfstate) com Terragrunt (backend local em `/data`)

```hcl
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

- O Terragrunt gera `backend.tf` no cache e aponta o Terraform para o caminho configurado.

### 💾 Backend local com Terraform puro

```hcl
terraform {
  backend "local" {
    path = "/data/terraform.tfstate"
  }
}
```

Também é possível definir no comando:

```bash
terraform apply -state=/data/terraform.tfstate
```

### 🤖 Automatizar e aprovação (CI/CD)

- **Terragrunt (não interativo)**:

```bash
# Planejar (run-all opcional)
terragrunt plan --terragrunt-non-interactive
terragrunt run-all plan --terragrunt-non-interactive

# Aplicar sem prompt
terragrunt apply --terragrunt-non-interactive --auto-approve
terragrunt run-all apply --terragrunt-non-interactive --auto-approve
```

- **Terraform (não interativo)**:

```bash
terraform plan -out=plan.tfplan -input=false
terraform apply -input=false -auto-approve plan.tfplan
```

- **Terragrunt com planfile do Terraform** (encaminhando args após `--`):

```bash
terragrunt plan -- -out=plan.tfplan -input=false
terragrunt apply -- -input=false -auto-approve plan.tfplan
```

- **Jenkins (exemplo simples)**:

```groovy
pipeline {
  agent any
  environment { TF_IN_AUTOMATION = '1' }
  stages {
    stage('Plan') {
      steps {
        sh 'terragrunt plan -- -out=plan.tfplan -input=false'
        archiveArtifacts artifacts: 'plan.tfplan', onlyIfSuccessful: true
      }
    }
    stage('Apply (após aprovação)') {
      when { beforeAgent true; expression { return params?.AUTO_APPLY == true } }
      steps {
        sh 'terragrunt apply -- -input=false -auto-approve plan.tfplan'
      }
    }
  }
  parameters {
    booleanParam(name: 'AUTO_APPLY', defaultValue: false, description: 'Aplicar automaticamente sem prompt')
  }
}
```

- **Boas práticas**:
  - Preferir aplicar a partir de um `plan.tfplan` gerado no mesmo commit.
  - Usar `-lock-timeout` e evitar `-lock=false` em ambientes compartilhados.
  - Reservar `--auto-approve` para ambientes não produtivos ou após revisão/aprovação explícita.

### 🧩 DRY: Módulos, Backend e Providers

- **Módulos**: reuso e padronização.
- **Backend DRY**: defina uma vez via Terragrunt e gere para os módulos.
- **Provider DRY**: centralize configuração (versões, credenciais, regiões) e herde por ambiente.

### 🧱 Imutabilidade (Infra como Código)

- Evite mutações manuais. Mudanças estruturais devem destruir/criar quando apropriado.
- Garante reprodutibilidade, auditoria e previsibilidade entre ambientes.

### 🔗 Referências úteis

- **Download Terraform + SHA**: [releases.hashicorp.com/terraform](https://releases.hashicorp.com/terraform/)
- **vSphere Guest OS Identifier**: [vim.vm.GuestOsDescriptor.GuestOsIdentifier](https://vdc-download.vmware.com/vmwb-repository/dcr-public/b50dcbbf-051d-4204-a3e7-e1b618c1e384/538cf2ec-b34f-4bae-a332-3820ef9e7773/vim.vm.GuestOsDescriptor.GuestOsIdentifier.html)

### 💡 Dica: escolher tamanho de disco em bloco `dynamic "disk"` (vSphere)

```hcl
dynamic "disk" {
  for_each = data.vsphere_virtual_machine.template.disks
  content {
    label            = disk.value["label"]
    unit_number      = disk.value["unit_number"]
    thin_provisioned = disk.value["thin_provisioned"]

    # Define tamanho condicional por rótulo
    size = disk.value["label"] == "nome_do_disco" ? "tamanho_desejado" : disk.value["size"]
  }
}
```

### 🚀 Como começar (exemplo rápido)

```bash
# 1) Entre no diretório do ambiente/módulo
cd aws/envs/exemplos/exemplo_02/networking

# 2) Visualize mudanças
terragrunt plan

# 3) Aplique quando aprovado
terragrunt apply
```

### ✍️ Autor

Rogerio Vieira Silva

—

Se precisar, posso adicionar badges, fluxos de pipeline e exemplos por provider (AWS, vSphere, MinIO) em seções separadas.

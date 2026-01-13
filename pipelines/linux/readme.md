## 📋 Guia de Parâmetros dos Pipelines

Este guia explica como preencher corretamente os parâmetros ao executar os pipelines Jenkins e como criar recursos de VMs Linux no vSphere.

---

## 🚀 Como Funciona a Execução dos Pipelines

### 📊 Fluxo de Execução

Os pipelines de criação de VMs seguem um fluxo sequencial de estágios:

1. **🔐 Retornando as chaves pública e certificados**
   - Obtém credenciais do Vault (HashiCorp Vault)
   - Recupera credenciais do vCenter (hostname, usuário, senha)
   - Configura credenciais do backend S3/MinIO para armazenar o state do Terraform
   - Gera arquivos `secrets.json` e `bucket.json` com as credenciais

2. **📋 Copy terragrunt.hcl**
   - Copia o arquivo de configuração base do Terragrunt para o diretório `envs/`
   - Este arquivo contém as configurações globais do Terragrunt

3. **⚙️ Executa Terraform Init** (apenas no pipeline Test, quando `init` ≠ `nao`)
   - Inicializa o backend do Terraform
   - Baixa os providers necessários
   - Configura o lock do DynamoDB (quando habilitado)

4. **📝 Terragrunt Plan**
   - Executa `terragrunt plan` para visualizar as mudanças que serão aplicadas
   - Mostra quais recursos serão criados, modificados ou destruídos
   - **Importante:** Este estágio não cria recursos, apenas simula a execução

5. **✅ Terragrunt Apply**
   - Executa `terragrunt apply -auto-approve` para criar/modificar os recursos
   - Cria as VMs no vSphere conforme configurado no `terragrunt.hcl`
   - Salva o state no backend S3/MinIO

---

## 📖 Passo a Passo: Como Criar uma VM Linux

### Pré-requisitos

1. ✅ Ter acesso ao Jenkins com permissão para executar pipelines
2. ✅ Ter o código do projeto no Gitea (organização: `infra`, `devops`, `labcoinf` ou `siop`)
3. ✅ Ter criado a estrutura de diretórios no repositório
4. ✅ Ter configurado o arquivo `terragrunt.hcl` com as especificações da VM

### Passo 1: Preparar a Estrutura de Diretórios

Crie a estrutura de diretórios no repositório seguindo o padrão:

```
envs/
  └── {ambiente}/           # prod, test, lab ou base
      └── {site}/           # vsphere-516 ou vsphere-k
          └── {grupo}/      # Ex: vms-gitlab, vms-apache, linux-vms
              └── terragrunt.hcl
```

**Exemplo prático:**
```
envs/
  └── prod/
      └── vsphere-516/
          └── vms-gitlab/
              └── terragrunt.hcl
```

### Passo 2: Criar o Arquivo terragrunt.hcl

Crie o arquivo `terragrunt.hcl` no diretório do grupo de VMs com a configuração das suas VMs:

```hcl
terraform {
  source = "../../../../modules/vsphere/vm/linux"
}

include {
  path = find_in_parent_folders()
}

locals {  
  vcenter        = basename(dirname(get_terragrunt_dir()))
  TF_VAR_VM_PASS = get_env("TF_VAR_VM_PASS")
  TF_VAR_DISTRO  = get_env("TF_VAR_DISTRO")
} 

inputs = {
  vm = {
    "PGIT01" = {
      template          = "default-template-alma10-base"
      instances         = 1
      vmstartcount      = 6
      staticvmname      = null
      datacenter        = "SOF"
      datastore_cluster = "Purestorage_Default"
      datastore         = "Purestorage_Default"
      resource_pool     = "Blade_Kratos/Resources"
      vsphere_cluster   = "Blade_Kratos"
      domain            = "sof.intra"
      network           = {"PG_Gaia_Dominio_Recurso" = ["172.27.3.100"]}
      dns_server_list   = ["172.27.3.5", "172.27.3.6"]
      mask              = ["24"]
      gateway           = "172.27.3.1"
      cpu               = 4
      memory            = 16384
      local_adminpass   = "${local.TF_VAR_VM_PASS}"
      distro            = "${local.TF_VAR_DISTRO}"
      network_type      = ["vmxnet3"]
      annotation        = "Servidor GitLab - 01/01/2025 - Seu Nome"
      tags = {
        "Origem"     = "Terraform"
        "Ambiente"   = "Prod"
        "Aplicacao"  = "GitLab"
        "Responsavel" = "Seu Nome"
      }
      data_disk = {}
    }
  }
}
```

**📝 Campos importantes:**
- **`template`**: Nome do template base no vSphere (deve existir previamente)
- **`instances`**: Quantidade de VMs a criar
- **`vmstartcount`**: Número inicial para nomenclatura (ex: se `vmstartcount=6`, a primeira VM será `PGIT06`)
- **`staticvmname`**: Nome fixo da VM (use `null` para nomenclatura automática)
- **`network`**: Port group e IP(s) da VM
- **`cpu`** e **`memory`**: Recursos da VM
- **`distro`**: Será preenchido automaticamente pelo parâmetro do pipeline

### Passo 3: Fazer Commit no Repositório

1. Faça commit do arquivo `terragrunt.hcl` no repositório Gitea
2. Certifique-se de que o código está na branch correta (geralmente `main` ou `master`)

### Passo 4: Executar o Pipeline no Jenkins

1. **Acesse o Jenkins** e localize o pipeline apropriado:
   - **Produção:** `jppl_criaVM_terragrunt_PROD_env`
   - **Teste:** `jppl_criaVM_terragrunt_Test_env`
   - **Lab:** `jppl_criaVM_terragrunt_Lab_env`

2. **Clique em "Build with Parameters"**

3. **Preencha os parâmetros:**
   - **Projeto:** Selecione a organização do Gitea (`infra`, `devops`, `labcoinf` ou `siop`)
   - **Diretorio:** `envs` (para vSphere)
   - **Ambiente:** Selecione o ambiente (`prod`, `test`, `lab` ou `base`)
   - **Site:** Selecione o datacenter (`vsphere-516` ou `vsphere-k`)
   - **Grupo:** Digite o nome do diretório do grupo (ex: `vms-gitlab`)
   - **init:** 
     - Use `init` na **primeira execução** ou quando houver mudanças no backend
     - Use `nao` nas execuções subsequentes
   - **lock:** `true` (recomendado para evitar conflitos)
   - **distro:** Selecione a distribuição Linux (`ubuntu`, `alma`, `centos`, `orcl` ou `rocklinux`)

4. **Clique em "Build"**

### Passo 5: Acompanhar a Execução

1. **Monitore os logs** de cada estágio:
   - ✅ Verifique se o estágio "Retornando as chaves" foi bem-sucedido
   - ✅ Confirme que o "Terragrunt Plan" mostra as mudanças esperadas
   - ⚠️ **Revise cuidadosamente o output do Plan** antes de prosseguir

2. **No estágio "Terragrunt Plan":**
   - O pipeline mostrará quais recursos serão criados
   - Verifique se as configurações estão corretas (IPs, recursos, etc.)
   - Se houver erros, corrija o `terragrunt.hcl` e execute novamente

3. **No estágio "Terragrunt Apply":**
   - As VMs serão criadas no vSphere
   - O state será salvo no backend S3/MinIO
   - ⚠️ **Atenção:** Este estágio cria recursos reais e pode demorar alguns minutos

### Passo 6: Verificar a Criação

1. **Acesse o vSphere** e verifique se as VMs foram criadas
2. **Verifique o state** no backend S3/MinIO (se necessário)
3. **Teste a conectividade** das VMs criadas

---

## ⚠️ Importante: Primeira Execução vs. Execuções Subsequentes

### 🆕 Primeira Execução

- **init:** Use `init` para inicializar o backend
- O pipeline criará o lock no DynamoDB (se habilitado)
- Baixará os providers necessários

### 🔄 Execuções Subsequentes

- **init:** Use `nao` (backend já configurado)
- O pipeline apenas executará `plan` e `apply`
- Mais rápido e eficiente

### 🔧 Modificando VMs Existentes

1. Edite o arquivo `terragrunt.hcl` no repositório
2. Faça commit das alterações
3. Execute o pipeline com os mesmos parâmetros (exceto `init: nao`)
4. O pipeline detectará as mudanças e aplicará apenas o necessário

---

## 🖥️ Pipelines de Criação de VMs

### 🔷 jppl_criaVM_terragrunt_PROD_env

**Parâmetros:**

| Parâmetro | Tipo | Descrição | Exemplo |
|-----------|------|-----------|---------|
| **Projeto** | 📂 Seleção | Organização do Gitea onde o código está armazenado | `infra`, `devops`, `labcoinf`, `siop` |
| **Diretorio** | 📁 Seleção | Diretório raiz do projeto | `envs` (para vSphere) ou `aws` (para AWS) |
| **Ambiente** | 🌍 Seleção | Ambiente de destino | `prod`, `test`, `lab`, `base` |
| **Site** | 🏢 Seleção | Datacenter vSphere | `vsphere-516` ou `vsphere-k` |
| **Grupo** | ✏️ Texto | Nome do grupo/diretório das VMs no repositório | Ex: `vms-gitlab`, `vms-mariadb` |
| **init** | ⚙️ Seleção | Executa terraform init (necessário na primeira execução ou mudanças de backend) | `nao`, `init`, `init -reconfigure`, `init -migrate-state` |
| **lock** | 🔒 Seleção | Habilita ou desabilita o lock do DynamoDB | `true` (recomendado) ou `false` |
| **distro** | 🐧 Seleção | Distribuição Linux da VM | `ubuntu`, `alma`, `centos`, `orcl`, `rocklinux` |

**💡 Exemplo de uso:**
- **Projeto:** `infra`
- **Diretorio:** `envs`
- **Ambiente:** `prod`
- **Site:** `vsphere-516`
- **Grupo:** `vms-gitlab`
- **init:** `nao` (ou `init` na primeira execução)
- **lock:** `true`
- **distro:** `alma`

---

### 🔶 jppl_criaVM_terragrunt_Test_env

**Parâmetros:**

| Parâmetro | Tipo | Descrição | Exemplo |
|-----------|------|-----------|---------|
| **Projeto** | 📂 Seleção | Organização do Gitea | `infra`, `devops`, `labcoinf`, `siop` |
| **Diretorio** | 📁 Seleção | Diretório raiz | `envs` ou `aws` |
| **Ambiente** | 🌍 Seleção | Ambiente de destino | `test`, `lab`, `base`, `prod` |
| **Site** | 🏢 Seleção | Datacenter vSphere | `vsphere-516` ou `vsphere-k` |
| **Grupo** | ✏️ Texto | Nome do grupo das VMs | Ex: `vms-apache`, `vms-elk` |
| **init** | ⚙️ Seleção | Comando terraform init | `nao`, `init`, `init -reconfigure`, `init -migrate-state`, `init -upgrade` |
| **lock** | 🔒 Seleção | Lock do DynamoDB | `true` ou `false` |
| **distro** | 🐧 Seleção | Distribuição Linux | `ubuntu`, `alma`, `centos`, `orcl`, `rocklinux` |

---

### 🔸 jppl_criaVM_terragrunt_Lab_env

**Parâmetros:**

| Parâmetro | Tipo | Descrição | Exemplo |
|-----------|------|-----------|---------|
| **Projeto** | 📂 Seleção | Organização do Gitea | `infra`, `devops`, `labcoinf`, `siop` |
| **Diretorio** | 📁 Seleção | Diretório raiz | `envs` ou `aws` |
| **Ambiente** | 🌍 Seleção | Ambiente de destino | `lab`, `base`, `test`, `prod` |
| **Site** | 🏢 Seleção | Datacenter vSphere | `vsphere-516` ou `vsphere-k` |
| **Grupo** | ✏️ Texto | Nome do grupo das VMs | Ex: `linux-vms`, `vms-apache` |
| **init** | ⚙️ Seleção | Comando terraform init | `nao`, `init`, `init -reconfigure`, `init -migrate-state` |
| **lock** | 🔒 Seleção | Lock do DynamoDB | `true` ou `false` |
| **distro** | 🐧 Seleção | Distribuição Linux | `ubuntu`, `alma`, `centos`, `orcl`, `rocklinux` |

---

### 🪟 jppl_criaVM_windows_terragrunt_Teste (Windows)

**Parâmetros:**

| Parâmetro | Tipo | Descrição | Exemplo |
|-----------|------|-----------|---------|
| **Projeto** | 📂 Seleção | Organização do Gitea | `infra`, `devops`, `labcoinf`, `siop` |
| **Datacenter** | 📁 Seleção | Diretório raiz | `envs` ou `aws` |
| **Ambiente** | 🌍 Seleção | Ambiente de destino | `test`, `lab`, `base`, `prod` |
| **Site** | 🏢 Seleção | Datacenter vSphere | `vsphere-516` ou `vsphere-k` |
| **Grupo** | ✏️ Texto | Nome do grupo das VMs | Ex: `vms-windows` |
| **init** | ⚙️ Seleção | Comando terraform init | `nao`, `init`, `init -reconfigure`, `init -migrate-state` |
| **lock** | 🔒 Seleção | Lock do DynamoDB | `true` ou `false` |
| **distro** | 🪟 Seleção | Distribuição Windows | `windows server` |

---

## 🏷️ Pipelines de Configuração vCenter

### 📑 jppl_criaCategory_Vcenter_terragrunt

**Parâmetros:**

| Parâmetro | Tipo | Descrição | Exemplo |
|-----------|------|-----------|---------|
| **Projeto** | 📂 Seleção | Organização do Gitea | `infra`, `devops`, `labcoinf`, `siop` |
| **Diretorio** | 📁 Seleção | Diretório raiz | `envs` ou `aws` |
| **Ambiente** | 🌍 Seleção | Ambiente | `base`, `test`, `lab`, `prod` |
| **Site** | 🏢 Seleção | Datacenter vSphere | `vsphere-516` ou `vsphere-k` |
| **Grupo** | ✏️ Texto | Nome do grupo | Ex: `category_vcenter` |
| **init** | ⚙️ Seleção | Comando terraform init | `nao`, `init`, `init -reconfigure`, `init -migrate-state` |
| **lock** | 🔒 Seleção | Lock do DynamoDB | `true` ou `false` |

**💡 Uso:** Este pipeline cria categorias no vCenter para organização de recursos. Siga o mesmo fluxo dos pipelines de VMs, mas para criar categorias ao invés de máquinas virtuais.

---

### 🏷️ jppl_criaTag_Vcenter_terragrunt

**Parâmetros:**

| Parâmetro | Tipo | Descrição | Exemplo |
|-----------|------|-----------|---------|
| **Projeto** | 📂 Seleção | Organização do Gitea | `infra`, `devops`, `labcoinf`, `siop` |
| **Diretorio** | 📁 Seleção | Diretório raiz | `envs` ou `aws` |
| **Ambiente** | 🌍 Seleção | Ambiente | `base`, `test`, `lab`, `prod` |
| **Site** | 🏢 Seleção | Datacenter vSphere | `vsphere-516` ou `vsphere-k` |
| **Grupo** | ✏️ Texto | Nome do grupo | Ex: `tags_vcenter` |
| **init** | ⚙️ Seleção | Comando terraform init | `nao`, `init`, `init -reconfigure`, `init -migrate-state` |
| **lock** | 🔒 Seleção | Lock do DynamoDB | `true` ou `false` |

**💡 Uso:** Este pipeline cria tags no vCenter para marcação de recursos. Siga o mesmo fluxo dos pipelines de VMs, mas para criar tags ao invés de máquinas virtuais.

---

## 🔧 Pipeline de Correção de State

### 🛠️ jppl_corrige_tfstate

**Parâmetros:**

| Parâmetro | Tipo | Descrição | Exemplo |
|-----------|------|-----------|---------|
| **Key** | 🔑 Texto | Caminho da chave do tfstate no bucket S3/MinIO | `lab/vsphere-516/linux-vms/terraform.tfstate` |

**💡 Exemplo de uso:**
- Para corrigir o state de VMs no ambiente lab: `lab/vsphere-516/vms-apache/terraform.tfstate`
- Para ambiente de teste: `test/vsphere-516/vms-elk/terraform.tfstate`

---

## 💡 Dicas Importantes

### ⚙️ Quando usar `init`?

- **`nao`**: ✅ Uso normal, quando o backend já está configurado
- **`init`**: 🆕 Primeira execução ou quando houver mudanças nos providers
- **`init -reconfigure`**: 🔄 Quando houver mudanças na configuração do backend
- **`init -migrate-state`**: 📦 Para migrar o state de um backend para outro
- **`init -upgrade`**: ⬆️ Para atualizar os providers para versões mais recentes (disponível apenas no pipeline Test)

### 🔒 Lock do DynamoDB

- **`true`**: ✅ Recomendado para prevenir execuções concorrentes que possam corromper o state
- **`false`**: ⚠️ Use apenas em casos excepcionais ou para debugging
- **Importante:** Se uma execução falhar, o lock pode ficar travado. Use o pipeline `jppl_corrige_tfstate` para corrigir

### 📂 Estrutura de Diretórios

O parâmetro **Grupo** deve corresponder ao nome do diretório no repositório:
```
envs/
  ├── prod/
  │   └── vsphere-516/
  │       ├── vms-gitlab/      ← Use "vms-gitlab" no parâmetro Grupo
  │       ├── vms-mariadb/     ← Use "vms-mariadb" no parâmetro Grupo
  │       └── vms-elk/         ← Use "vms-elk" no parâmetro Grupo
  └── test/
      └── vsphere-516/
          └── vms-apache/      ← Use "vms-apache" no parâmetro Grupo
```

### 🐧 Distribuições Linux Suportadas

- **`ubuntu`**: Ubuntu (várias versões)
- **`alma`**: AlmaLinux
- **`centos`**: CentOS
- **`orcl`**: Oracle Linux
- **`rocklinux`**: Rocky Linux

**⚠️ Importante:** O template base no vSphere deve corresponder à distribuição selecionada. Exemplo:
- Para `distro: alma`, use um template como `default-template-alma10-base`
- Para `distro: ubuntu`, use um template como `default-template-ubuntu2404-base`

### 🔐 Credenciais e Segurança

- As credenciais são gerenciadas automaticamente pelo Jenkins através do Vault
- A senha da VM (`TF_VAR_VM_PASS`) vem das credenciais do Ansible
- As credenciais do vCenter são obtidas do Vault no estágio inicial
- **Nunca** commite credenciais no repositório Git

---

## 🔧 Troubleshooting (Solução de Problemas)

### ❌ Erro: "Directory not found"

**Problema:** O pipeline não encontra o diretório especificado no parâmetro **Grupo**

**Solução:**
1. Verifique se o diretório existe no repositório
2. Confirme que o caminho está correto: `{Diretorio}/{Ambiente}/{Site}/{Grupo}`
3. Verifique se o código foi commitado e está na branch correta

### ❌ Erro: "Template not found"

**Problema:** O template especificado no `terragrunt.hcl` não existe no vSphere

**Solução:**
1. Acesse o vSphere e verifique o nome exato do template
2. Atualize o campo `template` no `terragrunt.hcl`
3. Faça commit e execute o pipeline novamente

### ❌ Erro: "IP address already in use"

**Problema:** O IP especificado no `terragrunt.hcl` já está em uso

**Solução:**
1. Verifique no vSphere ou DNS quais IPs estão disponíveis
2. Atualize o campo `network` no `terragrunt.hcl` com um IP disponível
3. Faça commit e execute o pipeline novamente

### ❌ Erro: "Lock timeout" ou "State locked"

**Problema:** O state está travado por uma execução anterior que falhou

**Solução:**
1. Use o pipeline `jppl_corrige_tfstate` para liberar o lock
2. Ou execute o pipeline com `lock: false` (apenas em emergências)
3. Verifique se não há outra execução em andamento

### ❌ Erro: "Backend configuration changed"

**Problema:** A configuração do backend foi alterada

**Solução:**
1. Execute o pipeline com `init: init -reconfigure`
2. Isso reconfigurará o backend sem perder o state

### ❌ Erro: "Provider not found" ou "Module not found"

**Problema:** Os providers ou módulos não foram baixados

**Solução:**
1. Execute o pipeline com `init: init`
2. Isso baixará todos os providers e módulos necessários

### ⚠️ Pipeline trava no estágio "Terragrunt Apply"

**Possíveis causas:**
- Criação de VM demorando mais que o esperado
- Problemas de conectividade com o vSphere
- Recursos insuficientes no vSphere

**Solução:**
1. Aguarde alguns minutos (criação de VM pode levar 5-10 minutos)
2. Verifique os logs detalhados do estágio
3. Se necessário, cancele a execução e verifique o vSphere manualmente

---

## 📚 Recursos Adicionais

### 📝 Exemplo Completo de terragrunt.hcl

Consulte os exemplos existentes no repositório:
- `envs/prod/vsphere-516/vms-jenkins/terragrunt.hcl`
- `envs/test/vsphere-516/vms-zabbix/terragrunt.hcl`
- `envs/lab/vsphere-516/linux-vms/terragrunt.hcl`

### 🔍 Verificando o State

O state do Terraform é armazenado no backend S3/MinIO no caminho:
```
{ambiente}/{site}/{grupo}/terraform.tfstate
```

Exemplo: `prod/vsphere-516/vms-gitlab/terraform.tfstate`

### 🗑️ Removendo Recursos

Para remover VMs criadas:
1. Remova a configuração do `terragrunt.hcl` ou delete o arquivo
2. Execute o pipeline normalmente
3. O `terragrunt plan` mostrará que as VMs serão destruídas
4. O `terragrunt apply` removerá as VMs do vSphere

**⚠️ Atenção:** A remoção é permanente! Certifique-se antes de executar.

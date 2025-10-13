## Pipelines

Armazena os pipelines responsáveis pela automação das execuções de IaC

## 📋 Guia de Parâmetros dos Pipelines

Este guia explica como preencher corretamente os parâmetros ao executar os pipelines Jenkins.

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
- **`init -upgrade`**: ⬆️ Para atualizar os providers para versões mais recentes

### 🔒 Lock do DynamoDB

- **`true`**: ✅ Recomendado para prevenir execuções concorrentes que possam corromper o state
- **`false`**: ⚠️ Use apenas em casos excepcionais ou para debugging

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

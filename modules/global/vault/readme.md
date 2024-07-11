## Vault

Estrutura de arquivos Terraform de escopo global - Vault

### Comandos para rodar e configurar o Vault e criar AppRole

```shell
# Defina a variável de ambiente VAULT_ADDR
export VAULT_ADDR='http://127.0.0.1:8200'
```

### Inicialize o operador do Vault

```shell
vault operator init
```

### Desbloqueie o operador do Vault. Isso precisa ser feito três vezes

```shell
vault operator unseal
```

### Faça login no Vault com o token inicial do root. O <Initial_Root_Token> pode ser encontrado na saída do comando 'vault operator init'

```shell
vault login <Initial_Root_Token>
```

### Habilite a autenticação do approle

```shell
vault auth enable approle
```

### Escreva a regra do approle para o papel jenkins

```shell
vault write auth/approle/role/jenkins-role token_num_uses=0 secret_id_num_uses=0 policies="jenkins"
```

### Leia o ID da função do approle para o papel jenkins

```shell
vault read auth/approle/role/jenkins-role/role-id
```

### Escreva o ID secreto do approle para o papel jenkins

```shell
vault write -f auth/approle/role/jenkins-role/secret-id
```

### Comandos to create secret de usuário

```shell
vault secrets enable -path=secrets kv
https://www.vaultproject.io/docs/secrets/kv
vault write secrets/creds/usuario username=username password=password
```

### Create jenkins-policy.hcl

```shell
path "secrets/creds/usuario" {
 capabilities = ["read"]
}
```

```shell
vault policy write jenkins jenkins-policy.hcl
```

### Comandos para criar my-secret-text

```shell
vault write secrets/creds/my-secret-text secret=abc123
```

### Update jenkins-policy.hcl

```shell
path "secrets/creds/*" {
 capabilities = ["read"]
}
vault policy write jenkins jenkins-policy.hcl
```

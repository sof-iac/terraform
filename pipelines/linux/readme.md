## Pipeline Jenkins - Download de Certificado do HashiCorp Vault

## Introdução

Este documento descreve um pipeline do Jenkins que é responsável por baixar um certificado de um servidor HashiCorp Vault. O pipeline utiliza a CLI do Vault para acessar e recuperar o certificado armazenado como um secret. Esse processo é especialmente útil para garantir que os certificados utilizados em ambientes de produção sejam gerenciados de forma segura.

## Pré-requisitos

Para utilizar este pipeline, você deve:

1. Ter o Jenkins instalado e em funcionamento.
2. Ter o plugin **HashiCorp Vault** instalado no Jenkins.
3. Ter acesso a um servidor HashiCorp Vault com permissões apropriadas.
4. As credenciais necessárias do Vault devem estar armazenadas no Jenkins (neste exemplo, o token do Vault).
5. O cliente da CLI do Vault deve estar instalado na máquina onde o Jenkins está sendo executado.

## Estrutura do Pipeline

O pipeline contém um estágio que baixa o certificado do Vault. A estrutura geral do pipeline é a seguinte:

```groovy
pipeline {
    agent any

    environment {
        VAULT_ADDR = 'http://your-vault-server:8200' // URL do seu servidor Vault
        VAULT_TOKEN = credentials('vault-token') // Usando credenciais do Jenkins
    }

    stages {
        stage('Download Certificate') {
            steps {
                script {
                    // Exemplo: O caminho do segredo que contém o certificado
                    def secretPath = 'your/secret/path'
                    def outputFile = '/path/to/your/certificate.pem'

                    // Comando para baixar o certificado
                    def command = """
                        export VAULT_ADDR=${env.VAULT_ADDR}
                        export VAULT_TOKEN=${env.VAULT_TOKEN}
                        vault kv get -field=certificate ${secretPath} > ${outputFile}
                    """

                    // Executa o comando
                    sh command
                }
            }
        }
    }
}
```

## Pipeline Jenkins - Retornando Chaves Públicas e Certificados do vault

## Introdução

Este documento descreve um estágio específico de um pipeline do Jenkins que é responsável por recuperar chaves públicas e certificações de um servidor HashiCorp Vault. O estágio utiliza o plugin [Vault Plugin](https://www.jenkins.io/doc/book/credentials/#vault-plugin) do Jenkins para obter segredos de forma segura.

## Pré-requisitos

Para usar este pipeline, você deve:

1. Ter o Jenkins instalado e funcionando.
2. O plugin **HashiCorp Vault** deve estar instalado no Jenkins.
3. Acesso a um servidor **HashiCorp Vault** com as chaves e permissões necessárias.
4. As credenciais do Vault devem ser armazenadas no Jenkins.
5. O ambiente de execução deve ter permissões apropriadas para gravar em `/etc/ssl/certs/`.

## Descrição do Código

### Estrutura do Estágio

O estágio `Retornando as chaves publica e certificados` executa as seguintes operações:

1. **Definição de Secrets e Variáveis de Ambiente**:

   - Define os caminhos e as chaves dos secretos que serão acessados no Vault.

2. **Configuração do Vault**:

   - Define a URL do Vault e o ID das credenciais do Vault que serão usadas para autenticação.

3. **Obtenção de Certificados**:

   - O certificado do MinIO é recuperado e gravado em arquivos relevantes (`/etc/ssl/certs/minio.pem`).

4. **Obtendo Credenciais do vCenter**:

   - O nome de usuário e a senha para conectividade com o vCenter são retornados e gravados em um arquivo JSON (`secrets.json`).

5. **Obtenção de Credenciais para Backend**:
   - A chave de acesso e a chave secreta são recuperadas e armazenadas em um arquivo JSON (`bucket.json`).

### Código do Estágio

```groovy
stage('Retornando as chaves publica e certificados') {
    steps {
        script {
            dir("${Datacenter}/${Site}/envs/${Ambiente}") {
                // Define os segredos e variáveis de ambiente
                def cert_minio = [
                    [path: 'secrets/certificados/minio.sof.intra', engineVersion: 2, secretValues: [
                        [envVar: 'minio_cert', vaultKey: 'minio_cert']]
                    ]
                ]

                // Retorna a chave de conexão com o vCenter
                def secrets_vcenter = [
                    [path: 'secrets/servicos/user_svc_jenkins', engineVersion: 2, secretValues: [
                        [envVar: 'passwd_vcenter', vaultKey: 'password']]
                    ]
                ]

                // Configuração opcional
                def configuration = [
                    vaultUrl: 'https://vault.app.sof.intra',
                    vaultCredentialId: 'token_vault',
                    engineVersion: 2
                ]

                // Dentro deste bloco, suas credenciais estarão disponíveis como variáveis de ambiente
                withVault([configuration: configuration, vaultSecrets: cert_minio]) {
                    sh 'printf "%s" "$minio_cert" > /etc/ssl/certs/minio.pem 2>&1 >/dev/null'
                    sh 'printf "%s" "$minio_cert" > minio.pem 2>&1 >/dev/null'
                    sh 'update-ca-certificates'
                }

                withVault([configuration: configuration, vaultSecrets: secrets_vcenter]) {
                    sh "echo '{\\n  \"username_vcenter\": \"user_svc_jenkins\",\\n  \"passwd_vcenter\": \"$passwd_vcenter\"\\n}' > secrets.json"
                }

                withCredentials([
                    string(credentialsId: 'access_key_teste', variable: 'TF_VAR_access_key_teste'),
                    string(credentialsId: 'secret_key_teste', variable: 'TF_VAR_secret_key_teste')
                ]) {
                    sh "echo '{\\n  \"TF_VAR_backend_access_key\": \"$TF_VAR_access_key_teste\",\\n  \"TF_VAR_backend_secret_key\": \"$TF_VAR_secret_key_teste\"\\n}' > bucket.json"
                }
            }
        }
    }
}
```

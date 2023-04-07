# App01

Esse exemplo mostra como usar o Terraform para descrever toda a infraestrutura de uma aplicacao em apenas um "state". 
Ou seja, networking e compute em um mesmo recurso e estado.
O estado está armazenado remotamente no Azure.

1. Expor as envs para autenticacao na Azure
```
ACCOUNT_KEY=$(az storage account keys list --resource-group sof-terraform --account-name tfstate31022 --query '[0].value' -o tsv)
export ARM_ACCESS_KEY=$ACCOUNT_KEY
```
2. Executar o init dos modulos

```
terraform init
```
3. Validar com o terraform plan
```
terraform plan
```
4. Aplicar o plano
```
terraform apply
```
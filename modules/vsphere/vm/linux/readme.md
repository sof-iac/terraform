## Iteração sobre uma lista de IPs

Explicação detalhada sobre a configuração do Terraform para implantar um script `ansible.sh` em várias máquinas, utilizando `null_resource`.

## Estrutura do Código

O código define um recurso `null_resource` que itera sobre um conjunto de IPs e copia um script para cada um dos endereços IP. Abaixo está a estrutura do código usada.

### Código Terraform

```hcl
# Itera sobre cada rede e cada IP dentro da rede
resource "null_resource" "ansible" {
  for_each = { for idx, ip in local.all_ips : idx => ip }

  provisioner "file" {
    source      = "${path.module}/templates/ansible.sh"
    destination = "/tmp/ansible.sh"
  }

  connection {
    type        = "ssh"
    user        = "root"
    password    = var.local_adminpass
    host        = each.value
  }
}
```

## Descrição das Seções do Código

### 1. `resource "null_resource" "ansible"`

Este bloco define um recurso `null_resource` chamado `ansible`. O `null_resource` é um recurso que não executa nenhuma ação diretamente, mas pode ser usado para orquestrar outras ações ou execuções de provisionadores.

### 2. `for_each`

Esta instrução permite iterar sobre uma coleção de valores, neste caso, `local.all_ips`, que deve ser uma lista de endereços IP. Cada IP da lista se tornará uma instância do recurso `null_resource`.

### 3. `provisioner "file"`

O provisionador `file` é utilizado para transferir um arquivo do local onde o código do Terraform está sendo executado para a máquina remota.

- **`source`**: O caminho para o arquivo que será copiado. Neste caso, o caminho para o script `ansible.sh`, localizado na pasta `templates` do módulo atual.

- **`destination`**: O caminho na máquina remota onde o arquivo deve ser copiado, aqui definido como `/tmp/ansible.sh`.

### 4. `connection`

Este bloco define como o Terraform se conecta à máquina remota para executar as ações solicitadas.

- **`type`**: O tipo de conexão a ser utilizada, neste caso, SSH.

- **`user`**: O nome do usuário para conexão. Aqui, estamos usando `root`.

- **`password`**: A senha necessária para a conexão SSH, que é recuperada da variável `var.local_adminpass`.

- **`host`**: Este parâmetro se referirá a cada IP da lista iterada, que é acessado através de `each.value`.

## Variáveis Necessárias

Antes de executar este código, assegure-se de que a variável **`local.all_ips`** está definida e contém os endereços IP das máquinas alvo. Além disso, a variável **`var.local_adminpass`** deve ser configurada com a senha correta para login no usuário root das máquinas.

## Execução

Para executar este código:

1. **Inicialize o Terraform**: Execute `terraform init` para inicializar o diretório de trabalho e baixar os provedores necessários.

2. **Planeje as Alterações**: Execute `terraform plan` para visualizar as alterações que serão aplicadas.

3. **Aplique as Alterações**: Se o plano estiver correto, execute `terraform apply` para aplicar as alterações.

4. **Verifique a Execução**: Após a execução, você pode acessar cada máquina remota para garantir que o script `ansible.sh` foi transferido corretamente para o diretório `/tmp`.

## Considerações Finais

Este exemplo demonstra como usar o Terraform para interagir com máquinas remotas via SSH e transferir arquivos. A flexibilidade da abordagem permite que você utilize scripts como Ansible para automatizar ainda mais sua infraestrutura.

Para mais informações sobre como personalizar e expandir a funcionalidade deste código, consulte a documentação oficial do [Terraform](https://www.terraform.io/docs) e do [Ansible](https://docs.ansible.com/ansible/latest/index.html).

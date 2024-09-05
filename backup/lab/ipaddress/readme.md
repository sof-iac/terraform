# Terraform
Estrutura de arquivos Terraform para interação com o vsphere

### ipaddress_pool
Este script verifica se uma entrada de DNS existe para um host e IP específicos, e se não existir, ele cria uma nova entrada.

Este script usa o provedor DNS do Terraform. Ele primeiro tenta buscar o registro DNS existente. Se o valor do registro não corresponder ao valor desejado, ele criará um novo registro DNS com o valor desejado.

Basta substituir as variáveis no início do script com os valores apropriados para o rspectivo datacenter (SOF ou Blocok). O script pressupõe que estamos usando autenticação baseada em chave para o servidor DNS. Se for usado um método de autenticação diferente, precisaremos ajustar a configuração do provedor de acordo.

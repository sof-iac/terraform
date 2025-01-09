## Configuração de Swap no Ubuntu

O arquivo `swap.img` no Ubuntu é utilizado como uma extensão da memória RAM. Quando a memória RAM física do sistema está cheia, o sistema operacional pode usar esse espaço de troca para armazenar temporariamente dados que não estão sendo usados ativamente. Essa prática ajuda a evitar erros de memória insuficiente e melhora o desempenho do sistema em situações de alta demanda de memória.

O `swap.img` é geralmente criado em sistemas onde não existe uma partição de troca dedicada, como em máquinas virtuais ou sistemas com discos rígidos tradicionais.

## Criando e Configurando um Arquivo de Swap

### 1. Criar o arquivo de troca

Execute o comando abaixo para criar um arquivo de troca de 4 GB:

```bash
sudo fallocate -l 4G /swap.img
```

### 2. Definir as permissões do arquivo

Defina as permissões do arquivo para garantir que apenas o usuário root possa acessá-lo:

```bash
sudo chmod 600 /swap.img
```

### 3. Criar uma área de troca no arquivo

Configure o arquivo como uma área de troca com o comando:

```bash
sudo mkswap /swap.img
```

### 4. Habilitar o arquivo de troca

Ative o arquivo de troca no sistema:

```bash
sudo swapon /swap.img
```

### 5. Adicionar entrada no fstab

Para garantir que a troca seja ativada automaticamente na reinicialização do sistema, adicione a seguinte entrada no arquivo `/etc/fstab`:

```bash
echo '/swap.img none swap sw 0 0' | sudo tee -a /etc/fstab
```

## Conclusão

Após seguir esses passos, você terá um arquivo de troca configurado e funcionando em seu sistema Ubuntu, ajudando a melhorar a eficiência do gerenciamento de memória.
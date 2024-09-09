## Datacenter - SOF - Prod

### Estrutura de trabalho

```
locals {
  # Parse the file path we're in to read the env name: e.g., env
  # will be "dev" in the dev folder, "stage" in the stage folder,
  # etc.
  # parsed = regex(".*\/envs\/(?P<env>.*?)\/.*", get_terragrunt_dir())
}
```

### terragrunt.hcl

Configuração raiz do terragrunt para configurar o backend e o provider nos projetos criados abaixo na hierarquia de organização

node {
  // define the vault configuration
  def vaultConfig = [
    vaultUrl: 'https://vault.app.sof.intra',
    vaultCredentialId: 'token_vault',
    engineVersion: 2
  ]

  // wrap the pipeline block with the `withVault` block
  withVault([configuration: vaultConfig]) {
    // read the secret from the vault
    def secrets = [
      [path: 'secrets/servicos/user_svc_vcenter', engineVersion: 2, secretValues: [
        [envVar: 'VAULT_TOKEN', vaultKey: 'username']
      ]]
    ]

    // wrap the pipeline block with the `withVaultSecrets` block
    withVaultSecrets(secrets) {
      sh '''
        terragrunt apply -var "vault_token=$VAULT_TOKEN"
      '''
    }
  }
}

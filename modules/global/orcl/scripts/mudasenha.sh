#!/bin/bash

# Definir a nova senha do usuário
new_password="NovaSenha123"

# Gerar um hash de senha usando o comando openssl
hashed_password=$(openssl passwd -1 "$new_password")

# Alterar a senha do usuário ansible
sudo usermod --password "$hashed_password" ansible

# Verificar se a alteração foi bem-sucedida
if [ $? -eq 0 ]; then
    echo "A senha do usuário ansible foi alterada com sucesso."
else
    echo "Não foi possível alterar a senha do usuário ansible."
fi

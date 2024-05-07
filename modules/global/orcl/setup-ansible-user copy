#!/bin/bash
# setup-ansible-user
# Cria usario ansible para automação Ansible 
# e gerenciamento configuracao.
# Cria ansible user
getentUser=$(/usr/bin/getent passwd ansible)
if [ -z "$getentUser" ]
then
  echo "Usuario ansible nao existe.  Sera incluido.."
  /usr/sbin/groupadd -g 4445 ansible
  /usr/sbin/useradd -u 4445 -g 4445 -c "Ansible Automation Account" -s /bin/bash -m -d /home/ansible ansible
echo "ansible:$1" | /usr/sbin/chpasswd
mkdir -p /home/ansible/.ssh
fi
# setup ssh authorization keys for Ansible access 
echo "Configurando ssh authorization keys..."
cat << 'EOF' >> /home/ansible/.ssh/authorized_keys
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJvaUICPun0zJo21vhsvaZpYegvpzZjxxkMQxPOF5xeL user_svc_puppet.sof.intra
EOF
# Copia a chave publica e privada do ansible
arquivo_origem="/tmp/id_ed25519"
pasta_destino="/home/ansible/.ssh"

if [ -e "$arquivo_origem" ]; then
    cp "$arquivo_origem" "$pasta_destino"
    cp "$arquivo_origem.pub" "$pasta_destino"
    echo "Arquivo copiado com sucesso."
else
    echo "O arquivo "$arquivo_origem" não existe."
fi

chown -R ansible:ansible /home/ansible/.ssh
chmod 700 /home/ansible/.ssh
# setup sudo access for Ansible
if [ ! -s /etc/sudoers.d/ansible ]
then
echo "Usuario ansible nao existe.  Sera incluido.."
cat << 'EOF' > /etc/sudoers.d/ansible
User_Alias ANSIBLE_AUTOMATION = ansible
Defaults:ANSIBLE_AUTOMATION !requiretty
ANSIBLE_AUTOMATION ALL=(ALL) NOPASSWD: ALL
EOF
chmod 400 /etc/sudoers.d/ansible
fi
# end of script

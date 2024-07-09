#!/bin/bash

# Define o fuso horário
timedatectl set-timezone America/Sao_Paulo

# Instalação dos pacotes necessários
apt install -y sssd-ldap

# Configuração do arquivo sssd.conf
echo "[sssd]
config_file_version = 2
domains = sof.intra

[domain/sof.intra]
id_provider = ldap
auth_provider = ldap
ldap_uri = ldaps://172.27.3.5,ldaps://172.27.3.6,ldaps://172.27.3.7
cache_credentials = True
ldap_search_base = dc=sof,dc=intra
#ldap_id_use_start_tls = false

ldap_default_bind_dn = sso@sof.intra
ldap_default_authtok_type = password
ldap_default_authtok = sso123
ldap_user_object_class = user
ldap_group_object_class = group
ldap_user_home_directory = unixHomeDirectory
ldap_tls_reqcert = never
ldap_referrals = false" > /etc/sssd/sssd.conf

# Ajusta as permissões do arquivo sssd.conf
chmod 0600 /etc/sssd/sssd.conf

# Reinicia o serviço SSSD
systemctl stop sssd.service
systemctl start sssd.service

# Habilita a criação automática de diretórios home no PAM
pam-auth-update --enable mkhomedir

# Adiciona a configuração TLS no arquivo ldap.conf
echo "TLS_REQCERT allow" >> /etc/ldap/ldap.conf

# Testa a conexão com o servidor LDAP
ldapwhoami -x -H ldaps://172.27.3.5
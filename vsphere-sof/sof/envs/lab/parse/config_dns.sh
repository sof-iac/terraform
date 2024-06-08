#!/bin/bash
# Author: Rogerio Vieira Silva - 08/06/2024
# Este script recebe uma variável 'distro' como parâmetro e ecoa uma mensagem baseada no valor.
# Apenas ate a construção do modulo especifico ou o uso adequando de Roles no Ansible
distro=$1

case $distro in
  ubuntu)
    echo 'options edns0 trust-ad' > /etc/systemd/resolved.conf
    echo 'nameserver 172.27.3.5' | tee -a /etc/systemd/resolved.conf
    echo 'nameserver 172.27.3.6' | tee -a /etc/systemd/resolved.conf
    echo 'nameserver 172.27.3.7' | tee -a /etc/systemd/resolved.conf
    echo 'search sof.intra blocok.sof.remoto' | tee -a /etc/systemd/resolved.conf
    echo 192.168.250.163         PREP02 | tee -a /etc/systemd/resolved.conf
    echo 192.168.250.125         PREP01 | tee -a /etc/systemd/resolved.conf
    systemctl restart systemd-resolved
    ;;
  centos)
    echo 'options edns0 trust-ad' > /etc/resolv.conf
    echo 'nameserver 172.27.3.5' >> /etc/resolv.conf
    echo 'nameserver 172.27.3.6' >> /etc/resolv.conf
    echo 'nameserver 172.27.3.7' >> /etc/resolv.conf
    echo 'search sof.intra blocok.sof.remoto' >> /etc/resolv.conf
    echo 192.168.250.163         PREP02 >> /etc/hosts
    echo 192.168.250.125         PREP01 >> /etc/hosts
    ;;
  orcl)
    echo 'options edns0 trust-ad' > /etc/resolv.conf
    echo 'nameserver 172.27.3.5' >> /etc/resolv.conf
    echo 'nameserver 172.27.3.6' >> /etc/resolv.conf
    echo 'nameserver 172.27.3.7' >> /etc/resolv.conf
    echo 'search sof.intra blocok.sof.remoto' >> /etc/resolv.conf
    echo 192.168.250.163         PREP02 >> /etc/hosts
    echo 192.168.250.125         PREP01 >> /etc/hosts
    ;;
  rocklinux)
    echo 'options edns0 trust-ad' > /etc/resolv.conf
    echo 'nameserver 172.27.3.5' >> /etc/resolv.conf
    echo 'nameserver 172.27.3.6' >> /etc/resolv.conf
    echo 'nameserver 172.27.3.7' >> /etc/resolv.conf
    echo 'search sof.intra blocok.sof.remoto' >> /etc/resolv.conf
    echo 192.168.250.163         PREP02 >> /etc/hosts
    echo 192.168.250.125         PREP01 >> /etc/hosts
    ;;
  *)
    echo 'options edns0 trust-ad' > /etc/resolv.conf
    echo 'nameserver 172.27.3.5' >> /etc/resolv.conf
    echo 'nameserver 172.27.3.6' >> /etc/resolv.conf
    echo 'nameserver 172.27.3.7' >> /etc/resolv.conf
    echo 'search sof.intra blocok.sof.remoto' >> /etc/resolv.conf
    echo 192.168.250.163         PREP02 >> /etc/hosts
    echo 192.168.250.125         PREP01 >> /etc/hosts
    ;;
esac




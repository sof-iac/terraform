#!/bin/bash  

# 1. Descobrir discos não listados no fstab  
echo "Discos não listados no fstab:"  
discos_nao_listados=$(lsblk -o NAME,MOUNTPOINT | grep -v "MOUNTPOINT" | awk '{print $1}')  
echo "$discos_nao_listados"  

# 2. Listar entradas do fstab  
echo "Entradas do fstab:"  
fstab_entries=$(awk '{print $1}' /etc/fstab | tr '\n' ' ')  
echo "$fstab_entries"  

# 3. Listar discos não formatados  
echo "Discos não formatados:"  
discos_nao_formatados=""  

# Loop para encontrar discos não formatados  
for linha in $(lsblk -dno NAME); do  
    # Verificar se o disco não está listado no fstab e não possui tipo de sistema de arquivos  
    if [[ ! $fstab_entries =~ $linha && -z $(lsblk -no FSTYPE "/dev/$linha") ]]; then  
        discos_nao_formatados+="$linha"$'\n'  
    fi  
done  

echo -e "$discos_nao_formatados"  

# 4. Formatar discos não usados com ext4  
for disco in $discos_nao_formatados; do  
    echo "Formatando /dev/$disco para ext4..."  
    mkfs.ext4 "/dev/$disco"  
done  

# 5. Montar os discos e adicionar ao fstab  
for disco in $discos_nao_formatados; do  
    mount_point="/mnt/$disco"  
    mkdir -p "$mount_point"  
    echo "Montando /dev/$disco em $mount_point..."  
    mount "/dev/$disco" "$mount_point"  
    
    # Adicionar entrada ao fstab  
    echo "/dev/$disco $mount_point ext4 defaults 0 2" >> /etc/fstab  
done  

# 6. Atualizar fstab com as novas entradas  
echo "Fstab atualizado com as novas entradas."
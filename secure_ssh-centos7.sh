DATE=`date '+%Y%m%d'`

echo -e "root 로그인 차단"
cp -p /etc/ssh/sshd_config /etc/ssh/sshd_config.secure_ssh_bak_$DATE
sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
cat /etc/ssh/sshd_config |grep "PermitRootLogin" |grep -v "^#"
echo -e "....[OK]\n"

echo -e "Bastion 서버에서만 SSH 연결 허용"
echo 'sshd: 192.168.177.1  # wny-bastion' >> /etc/hosts.allow
echo "/etc/hosts.allow"
cat /etc/hosts.allow | grep -v "^#"

echo 'sshd: ALL' >> /etc/hosts.deny
echo "/etc/hosts.deny"
cat /etc/hosts.deny| grep -v "^#"
echo -e "....[OK]\n"

echo -e "보안 설정 적용을 위해 sshd 서비스를 재시작합니다."
read -p "이후 Bastion 서버에서만 접근이 가능하며, 현재 연결된 SSH 접속이 끊어질 수 있습니다. (y/n)? " answer
case ${answer:0:1} in
    y|Y )
        systemctl restart sshd
    ;;
    * )
        echo "추후 수동으로 sshd 서비스를 재시작해야 합니다."
    ;;
esac

sudo su
dnf install firewalld -y
systemctl enable firewalld
systemctl start firewalld
firewall-cmd --add-port=6996-7800/tcp --permanent
firewall-cmd --add-port=1414-1514/tcp --permanent
firewall-cmd --reload
sudo su
dnf -y install kernel-4.18.0-348.el8
dnf -y install wget 

# this argument is passed from the cmd line


echo "kernel.shmmni = 4096">> /etc/sysctl.conf
echo "kernel.shmall = 2097152">>/etc/sysctl.conf
echo "kernel.shmmax = 268435456">>/etc/sysctl.conf
echo "kernel.sem = 32 4096 32 128">>/etc/sysctl.conf
echo "fs.file-max = 524288">>/etc/sysctl.conf
sysctl -p

echo "# For MQM User">>/etc/security/limits.conf
echo "mqm       hard  nofile     1024">>/etc/security/limits.conf
echo "mqm       soft  nofile     1024">>/etc/security/limits.conf

reboot now
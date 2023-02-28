sudo su
cd work 
tar zxvf mqadv_dev931_linux_x86-64.tar.gz
cd MQServer
./mqlicense.sh -accept
dnf -y install MQSeries*.rpm --nogpgcheck

sudo su
mkdir -p /home/mqm/.ssh
chown mqm:mqm /home/mqm/.ssh
cat ./work/ssh/mqm.id_rsa.pub | tee -a /home/mqm/.ssh/authorized_keys
chown mqm:mqm /home/mqm/.ssh/authorized_keys
chmod 600 /home/mqm/.ssh/authorized_keys
chmod 700 /home/mqm/.ssh

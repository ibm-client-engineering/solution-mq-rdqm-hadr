sudo mkdir -p /home/mqm/.ssh
sudo chown mqm:mqm /home/mqm/.ssh

sudo cp work/ssh/mqm.id_rsa.pub  /home/mqm/.ssh/id_rsa.pub
sudo cp work/ssh/mqm.id_rsa /home/mqm/.ssh/id_rsa
sudo chown mqm:mqm /home/mqm/.ssh/id_rsa.pub
sudo chmod 600 /home/mqm/.ssh/id_rsa.pub
sudo chown mqm:mqm /home/mqm/.ssh/id_rsa
sudo chmod 600 /home/mqm/.ssh/id_rsa
sudo chmod 700 /home/mqm/.ssh

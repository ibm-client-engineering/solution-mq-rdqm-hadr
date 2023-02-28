FUNCTION=$(shell echo $@|cut  -c 5-)

###
hi:
	@echo " Target: $(TARGET)"

ec2-create-configs:
# Region A
	echo "Node:">$(DATA_DIR)/rdqm-a.ini
	echo "  Name=$(MQ_NAME_A_A)">>$(DATA_DIR)/rdqm-a.ini
	echo "  HA_Replication=$(MQ_A_A_IP)">>$(DATA_DIR)/rdqm-a.ini
	echo "Node:">>$(DATA_DIR)/rdqm-a.ini
	echo "  Name=$(MQ_NAME_A_B)">>$(DATA_DIR)/rdqm-a.ini
	echo "  HA_Replication=$(MQ_A_B_IP)">>$(DATA_DIR)/rdqm-a.ini
	echo "Node:">>$(DATA_DIR)/rdqm-a.ini
	echo "  Name=$(MQ_NAME_A_C)">>$(DATA_DIR)/rdqm-a.ini
	echo "  HA_Replication=$(MQ_A_C_IP)">>$(DATA_DIR)/rdqm-a.ini
	echo "">>$(DATA_DIR)/rdqm-a.ini

# Region B
	echo "Node:">$(DATA_DIR)/rdqm-b.ini
	echo "  Name=$(MQ_NAME_B_A)">>$(DATA_DIR)/rdqm-b.ini
	echo "  HA_Replication=$(MQ_B_A_IP)">>$(DATA_DIR)/rdqm-b.ini
	echo "Node:">>$(DATA_DIR)/rdqm-b.ini
	echo "  Name=$(MQ_NAME_B_B)">>$(DATA_DIR)/rdqm-b.ini
	echo "  HA_Replication=$(MQ_B_B_IP)">>$(DATA_DIR)/rdqm-b.ini
	echo "Node:">>$(DATA_DIR)/rdqm-b.ini
	echo "  Name=$(MQ_NAME_B_C)">>$(DATA_DIR)/rdqm-b.ini
	echo "  HA_Replication=$(MQ_B_C_IP)">>$(DATA_DIR)/rdqm-b.ini
	echo "">>$(DATA_DIR)/rdqm-b.ini

ec2-bastion-setup:
	ssh -i $(PEM_FILE) $(BASTION_A_SSH)  <scripts/005-bastion.sh
	ssh -i $(PEM_FILE) $(BASTION_B_SSH)  <scripts/005-bastion.sh

ec2-copy-files-bastion:
	rsync -av -e 'ssh -i $(PEM_FILE) ' --exclude=.git ./$(DATA_DIR)/ $(BASTION_A_SSH):~/work/
	rsync -av -e 'ssh -i $(PEM_FILE) ' --exclude=.git ./$(DATA_DIR)/ $(BASTION_B_SSH):~/work/
	scp -i $(PEM_FILE)  ./software/$(MQIPT_IMAGE) $(BASTION_A_SSH):~/work/
	scp -i $(PEM_FILE)  ./software/$(MQADV_IMAGE) $(BASTION_A_SSH):~/work/
	scp -i $(PEM_FILE)  ./software/$(MQIPT_IMAGE) $(BASTION_B_SSH):~/work/
	scp -i $(PEM_FILE)  ./software/$(MQADV_IMAGE) $(BASTION_B_SSH):~/work/

	
#	ssh -i $(PEM_FILE) $(BASTION_A_SSH)  <scripts/085-downloads.sh

ec2-copy-files:
	ssh -i $(PEM_FILE) $(BASTION_A_SSH)  'rsync -av -e "ssh -i ~/.ssh/id_rsa" --exclude=.git  ~/work/ $(TARGET):~/work/'

ec2-dnf:
	echo $(TARGET)
	ssh -i $(PEM_FILE) $(BASTION_A_SSH) ssh $(TARGET) <scripts/000-dnf.sh

ec2-add-user: 
	ssh -i $(PEM_FILE) $(BASTION_A_SSH) ssh $(TARGET) <scripts/010-create-user.sh

ec2-setup-mqm-user:
	ssh -i $(PEM_FILE) $(BASTION_A_SSH) ssh $(TARGET) <scripts/075-mqm-authorized_keys.sh

ec2-setup-mqm-master:
	ssh -i $(PEM_FILE) $(BASTION_A_SSH) ssh $(MQ_A_A_SSH) <scripts/070-mqm-keypair.sh
	ssh -i $(PEM_FILE) $(BASTION_A_SSH) ssh $(MQ_B_A_SSH) <scripts/070-mqm-keypair.sh

ec2-setup-mqm-bastion:
	ssh -i $(PEM_FILE) $(BASTION_A_SSH) <scripts/010-create-user.sh
	ssh -i $(PEM_FILE) $(BASTION_B_SSH) <scripts/010-create-user.sh
	ssh -i $(PEM_FILE) $(BASTION_A_SSH) <scripts/075-mqm-authorized_keys.sh
	ssh -i $(PEM_FILE) $(BASTION_B_SSH) <scripts/075-mqm-authorized_keys.sh
	ssh -i $(PEM_FILE) $(BASTION_A_SSH) <scripts/070-mqm-keypair.sh
	ssh -i $(PEM_FILE) $(BASTION_B_SSH) <scripts/070-mqm-keypair.sh

ec2-update-bash-profile: 
	ssh -i $(PEM_FILE) $(BASTION_A_SSH) ssh $(TARGET) <scripts/020-update-bash-profile.sh

ec2-update-sudoers: 
	ssh -i $(PEM_FILE) $(BASTION_A_SSH) ssh $(TARGET) <scripts/030-update-sudoers.sh

ec2-volumes:
	ssh -i $(PEM_FILE) $(BASTION_A_SSH) ssh $(TARGET) <scripts/050-volumes.sh

ec2-hostname:
	ssh -i $(PEM_FILE) $(BASTION_A_SSH) ssh $(TARGET) "sudo hostnamectl set-hostname $(HOSTNAME)"

ec2-mqipt-hostname:
	ssh -i $(PEM_FILE) $(BASTION_A_SSH) ssh $(MQIPT_A_SSH) "sudo hostnamectl set-hostname $(MQIPT_A_NAME)"
	ssh -i $(PEM_FILE) $(BASTION_A_SSH) ssh $(MQIPT_B_SSH) "sudo hostnamectl set-hostname $(MQIPT_B_NAME)"

ec2-system-settings:
	ssh -i $(PEM_FILE) $(BASTION_A_SSH) ssh $(TARGET) <scripts/060-system-settings.sh

ec2-mqadv:
	ssh -i $(PEM_FILE) $(BASTION_A_SSH) ssh $(TARGET) <scripts/080-mqadv.sh

# ONLY ON 1 NODE PER REGION
ec2-activate-node:
	ssh -i $(PEM_FILE) $(BASTION_A_SSH) ssh $(MQ_A_A_SSH) <scripts/090-activate-regional-node.sh
	ssh -i $(PEM_FILE) $(BASTION_A_SSH) ssh $(MQ_B_A_SSH) <scripts/090-activate-regional-node.sh

ec2-kmod-drbd:
	ssh -i $(PEM_FILE) $(BASTION_A_SSH) ssh $(TARGET) <scripts/100-kmod-drbd.sh

ec2-firewall:
	ssh -i $(PEM_FILE) $(BASTION_A_SSH) ssh $(TARGET) <scripts/110-firewall.sh

ec2-rqdm:	
	ssh -i $(PEM_FILE) $(BASTION_A_SSH) ssh $(TARGET) <scripts/120-rqdm.sh

ec2-mq-config:
	ssh -i $(PEM_FILE) $(BASTION_A_SSH) ssh $(MQ_A_A_SSH) sudo tee /var/mqm/rdqm.ini<$(DATA_DIR)/rdqm-a.ini
	ssh -i $(PEM_FILE) $(BASTION_A_SSH) ssh $(MQ_A_B_SSH) sudo tee /var/mqm/rdqm.ini<$(DATA_DIR)/rdqm-a.ini
	ssh -i $(PEM_FILE) $(BASTION_A_SSH) ssh $(MQ_A_C_SSH) sudo tee /var/mqm/rdqm.ini<$(DATA_DIR)/rdqm-a.ini
	ssh -i $(PEM_FILE) $(BASTION_A_SSH) ssh $(MQ_B_A_SSH) sudo tee /var/mqm/rdqm.ini<$(DATA_DIR)/rdqm-b.ini
	ssh -i $(PEM_FILE) $(BASTION_A_SSH) ssh $(MQ_B_B_SSH) sudo tee /var/mqm/rdqm.ini<$(DATA_DIR)/rdqm-b.ini
	ssh -i $(PEM_FILE) $(BASTION_A_SSH) ssh $(MQ_B_C_SSH) sudo tee /var/mqm/rdqm.ini<$(DATA_DIR)/rdqm-b.ini

# ONLY ON 1 NODE PER REGION
ec2-rdqmadm:
	-ssh -i $(PEM_FILE) $(BASTION_A_SSH) ssh $(MQ_A_A_SSH) <scripts/130-rdqadm.sh
	-ssh -i $(PEM_FILE) $(BASTION_A_SSH) ssh $(MQ_B_A_SSH) <scripts/130-rdqadm.sh


ec2-delete-queue:
	-ssh -i $(PEM_FILE) $(BASTION_A_SSH) ssh $(MQ_A_A_SSH) <scripts/130-delete-queue.sh
	-ssh -i $(PEM_FILE) $(BASTION_A_SSH) ssh $(MQ_B_A_SSH) <scripts/130-delete-queue.sh


ec2-rdqmadm-status:
	ssh -i $(PEM_FILE) $(BASTION_A_SSH) ssh $(MQ_A_A_SSH) <scripts/140-rdqadm-status.sh
	ssh -i $(PEM_FILE) $(BASTION_A_SSH) ssh $(MQ_B_A_SSH) <scripts/140-rdqadm-status.sh


ec2-etc-hosts:
	ssh -i $(PEM_FILE) $(BASTION_A_SSH)  <scripts/006-etc-hosts.sh
	ssh -i $(PEM_FILE) $(BASTION_B_SSH)  <scripts/006-etc-hosts.sh

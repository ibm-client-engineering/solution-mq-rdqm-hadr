

ssh-bastion-a:
	ssh -o "StrictHostKeyChecking no" -i $(PEM_FILE) $(BASTION_USER)@$(BASTION_A_PUBLIC_IP)
ssh-bastion-b:
	ssh -o "StrictHostKeyChecking no" -i $(PEM_FILE) $(BASTION_USER)@$(BASTION_B_PUBLIC_IP)
ssh-aa:
	ssh -i $(PEM_FILE) $(BASTION_A_SSH) "ssh -tt -i ~/.ssh/id_rsa $(MQ_A_A_SSH)"
ssh-ab:
	ssh -i $(PEM_FILE) $(BASTION_A_SSH) "ssh -tt -i ~/.ssh/id_rsa $(MQ_A_B_SSH)"
ssh-ac:
	ssh -i $(PEM_FILE) $(BASTION_A_SSH) "ssh -tt -i ~/.ssh/id_rsa $(MQ_A_C_SSH)"
ssh-ba:
	ssh -i $(PEM_FILE) $(BASTION_A_SSH) "ssh -tt -i ~/.ssh/id_rsa $(MQ_B_A_SSH)"
ssh-bb:
	ssh -i $(PEM_FILE) $(BASTION_A_SSH) "ssh -tt -i ~/.ssh/id_rsa $(MQ_B_B_SSH)"
ssh-bc:
	ssh -i $(PEM_FILE) $(BASTION_A_SSH) "ssh -tt -i ~/.ssh/id_rsa $(MQ_B_C_SSH)"


ec2-setup-bastion-keypair:
# ADD Bastion A & B to the local machines known hosts
	ssh-keyscan -H $(BASTION_A_PUBLIC_IP) >> ~/.ssh/known_hosts
	ssh-keyscan -H $(BASTION_B_PUBLIC_IP) >> ~/.ssh/known_hosts

	scp -i $(PEM_FILE) $(DATA_DIR)/ssh/id.rsa.pub $(BASTION_USER)@$(BASTION_A_PUBLIC_IP):~/.ssh/id_rsa.pub
	scp -i $(PEM_FILE) $(DATA_DIR)/ssh/id.rsa $(BASTION_USER)@$(BASTION_A_PUBLIC_IP):~/.ssh/id_rsa
	ssh -i $(PEM_FILE) $(BASTION_USER)@$(BASTION_A_PUBLIC_IP) "chmod 600 ~/.ssh/id_rsa"
	ssh -i $(PEM_FILE) $(BASTION_USER)@$(BASTION_A_PUBLIC_IP) "chmod 600 ~/.ssh/id_rsa.pub"
	scp -i $(PEM_FILE) $(DATA_DIR)/ssh/id.rsa.pub $(BASTION_USER)@$(BASTION_B_PUBLIC_IP):~/.ssh/id_rsa.pub
	scp -i $(PEM_FILE) $(DATA_DIR)/ssh/id.rsa $(BASTION_USER)@$(BASTION_B_PUBLIC_IP):~/.ssh/id_rsa
	ssh -i $(PEM_FILE) $(BASTION_USER)@$(BASTION_B_PUBLIC_IP) "chmod 600 ~/.ssh/id_rsa"
	ssh -i $(PEM_FILE) $(BASTION_USER)@$(BASTION_B_PUBLIC_IP) "chmod 600 ~/.ssh/id_rsa.pub"



ec2-bastion-accept-fingerprints:
	# add all insances to bastion a
	ssh -i $(PEM_FILE) $(BASTION_A_SSH) "ssh-keyscan -H $(MQ_A_A_IP) >> ~/.ssh/known_hosts"
	ssh -i $(PEM_FILE) $(BASTION_A_SSH) "ssh-keyscan -H $(MQ_A_B_IP) >> ~/.ssh/known_hosts"
	ssh -i $(PEM_FILE) $(BASTION_A_SSH) "ssh-keyscan -H $(MQ_A_C_IP) >> ~/.ssh/known_hosts"
	ssh -i $(PEM_FILE) $(BASTION_A_SSH) "ssh-keyscan -H $(MQ_B_A_IP) >> ~/.ssh/known_hosts"
	ssh -i $(PEM_FILE) $(BASTION_A_SSH) "ssh-keyscan -H $(MQ_B_B_IP) >> ~/.ssh/known_hosts"
	ssh -i $(PEM_FILE) $(BASTION_A_SSH) "ssh-keyscan -H $(MQ_B_C_IP) >> ~/.ssh/known_hosts"
	ssh -i $(PEM_FILE) $(BASTION_A_SSH) "ssh-keyscan -H $(BASTION_B_IP) >> ~/.ssh/known_hosts"
	ssh -i $(PEM_FILE) $(BASTION_A_SSH) "ssh-keyscan -H $(MQIPT_A_IP) >> ~/.ssh/known_hosts"

	# add all insances to bastion b
	ssh -i $(PEM_FILE) $(BASTION_B_SSH) "ssh-keyscan -H $(MQ_A_A_IP) >> ~/.ssh/known_hosts"
	ssh -i $(PEM_FILE) $(BASTION_B_SSH) "ssh-keyscan -H $(MQ_A_B_IP) >> ~/.ssh/known_hosts"
	ssh -i $(PEM_FILE) $(BASTION_B_SSH) "ssh-keyscan -H $(MQ_A_C_IP) >> ~/.ssh/known_hosts"
	ssh -i $(PEM_FILE) $(BASTION_B_SSH) "ssh-keyscan -H $(MQ_B_A_IP) >> ~/.ssh/known_hosts"
	ssh -i $(PEM_FILE) $(BASTION_B_SSH) "ssh-keyscan -H $(MQ_B_B_IP) >> ~/.ssh/known_hosts"
	ssh -i $(PEM_FILE) $(BASTION_B_SSH) "ssh-keyscan -H $(MQ_B_C_IP) >> ~/.ssh/known_hosts"
	ssh -i $(PEM_FILE) $(BASTION_B_SSH) "ssh-keyscan -H $(BASTION_A_IP) >> ~/.ssh/known_hosts"
	ssh -i $(PEM_FILE) $(BASTION_A_SSH) "ssh-keyscan -H $(MQIPT_B_IP) >> ~/.ssh/known_hosts"


ec2-bastion-accept-mqm-fingerprints:
	ssh -i $(MQM_PEM_FILE) mqm@$(BASTION_A_PUBLIC_IP) "ssh-keyscan -H $(MQ_A_A_IP) >> ~/.ssh/known_hosts"
	ssh -i $(MQM_PEM_FILE) mqm@$(BASTION_A_PUBLIC_IP) "ssh-keyscan -H $(MQ_A_B_IP) >> ~/.ssh/known_hosts"
	ssh -i $(MQM_PEM_FILE) mqm@$(BASTION_A_PUBLIC_IP) "ssh-keyscan -H $(MQ_A_C_IP) >> ~/.ssh/known_hosts"
	ssh -i $(MQM_PEM_FILE) mqm@$(BASTION_B_PUBLIC_IP) "ssh-keyscan -H $(MQ_B_A_IP) >> ~/.ssh/known_hosts"
	ssh -i $(MQM_PEM_FILE) mqm@$(BASTION_B_PUBLIC_IP) "ssh-keyscan -H $(MQ_B_B_IP) >> ~/.ssh/known_hosts"
	ssh -i $(MQM_PEM_FILE) mqm@$(BASTION_B_PUBLIC_IP) "ssh-keyscan -H $(MQ_B_C_IP) >> ~/.ssh/known_hosts"

ec2-master-nodes-accept-fingerprints:
	# add region a to master node
	ssh -i $(MQM_PEM_FILE) mqm@$(BASTION_A_PUBLIC_IP) 'ssh -i ~/.ssh/id_rsa mqm@$(MQ_A_A_IP) "ssh-keyscan -H $(MQ_A_B_IP) >> ~/.ssh/known_hosts"'
	ssh -i $(MQM_PEM_FILE) mqm@$(BASTION_A_PUBLIC_IP) 'ssh -i ~/.ssh/id_rsa mqm@$(MQ_A_A_IP) "ssh-keyscan -H $(MQ_A_C_IP) >> ~/.ssh/known_hosts"'
	
	# add region b to master node
	ssh -i $(MQM_PEM_FILE) mqm@$(BASTION_B_PUBLIC_IP) 'ssh -i ~/.ssh/id_rsa mqm@$(MQ_B_A_IP) "ssh-keyscan -H $(MQ_B_B_IP) >> ~/.ssh/known_hosts"'
	ssh -i $(MQM_PEM_FILE) mqm@$(BASTION_B_PUBLIC_IP) 'ssh -i ~/.ssh/id_rsa mqm@$(MQ_B_A_IP) "ssh-keyscan -H $(MQ_B_C_IP) >> ~/.ssh/known_hosts"'



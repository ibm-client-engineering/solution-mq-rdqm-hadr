QUEUE_CMD1="sudo /opt/mqm/bin/crtmqm -sxs -rr p -rl $(MQ_B_A_IP),$(MQ_B_B_IP),$(MQ_B_C_IP) -ri $(MQ_A_A_IP),$(MQ_A_B_IP),$(MQ_A_C_IP) -rp 7001 -fs 3072M DRHAQM1"
QUEUE_CMD2="sudo /opt/mqm/bin/crtmqm -sx -rr p -p 1501 -rl $(MQ_B_A_IP),$(MQ_B_B_IP),$(MQ_B_C_IP) -ri $(MQ_A_A_IP),$(MQ_A_B_IP),$(MQ_A_C_IP) -rp 7001 -fs 3072M DRHAQM1"

QUEUE_CMD3="sudo /opt/mqm/bin/crtmqm -sxs -rr s -ri $(MQ_B_A_IP),$(MQ_B_B_IP),$(MQ_B_C_IP) -rl $(MQ_A_A_IP),$(MQ_A_B_IP),$(MQ_A_C_IP) -rp 7001 -fs 3072M DRHAQM1"
QUEUE_CMD4="sudo /opt/mqm/bin/crtmqm -sx -rr s -ri $(MQ_B_A_IP),$(MQ_B_B_IP),$(MQ_B_C_IP) -rl $(MQ_A_A_IP),$(MQ_A_B_IP),$(MQ_A_C_IP) -rp 7001 -fs 3072M DRHAQM1"

ec2-dr-queue:
	ssh -i $(MQM_PEM_FILE) mqm@$(BASTION_B_PUBLIC_IP) ssh $(MQ_B_C_IP) "$(QUEUE_CMD1)"
	ssh -i $(MQM_PEM_FILE) mqm@$(BASTION_B_PUBLIC_IP) ssh $(MQ_B_B_IP) "$(QUEUE_CMD1)"
	ssh -i $(MQM_PEM_FILE) mqm@$(BASTION_B_PUBLIC_IP) ssh $(MQ_B_A_IP) "$(QUEUE_CMD2)"
#
	ssh -i $(MQM_PEM_FILE) mqm@$(BASTION_A_PUBLIC_IP) ssh $(MQ_A_C_IP) "$(QUEUE_CMD3)"
	ssh -i $(MQM_PEM_FILE) mqm@$(BASTION_A_PUBLIC_IP) ssh $(MQ_A_B_IP) "$(QUEUE_CMD3)"
	ssh -i $(MQM_PEM_FILE) mqm@$(BASTION_A_PUBLIC_IP) ssh $(MQ_A_A_IP) "$(QUEUE_CMD4)"

ec2-check-dr-queue:
	ssh -i $(MQM_PEM_FILE) mqm@$(BASTION_A_PUBLIC_IP) ssh $(MQ_A_A_IP) <scripts/150-check-node.sh
	ssh -i $(MQM_PEM_FILE) mqm@$(BASTION_B_PUBLIC_IP) ssh $(MQ_B_A_IP) <scripts/150-check-node.sh


ec2-dr-fail-b:
	ssh -i $(MQM_PEM_FILE) mqm@$(BASTION_B_PUBLIC_IP) ssh $(MQ_B_A_IP) "sudo /opt/mqm/bin/rdqmdr -s -m DRHAQM1"
	ssh -i $(MQM_PEM_FILE) mqm@$(BASTION_A_PUBLIC_IP) ssh $(MQ_A_A_IP) "sudo /opt/mqm/bin/rdqmdr -p -m DRHAQM1"

ec2-dr-fail-a:
	ssh -i $(MQM_PEM_FILE) mqm@$(BASTION_A_PUBLIC_IP) ssh $(MQ_A_A_IP) "sudo /opt/mqm/bin/rdqmdr -s -m DRHAQM1"
	ssh -i $(MQM_PEM_FILE) mqm@$(BASTION_B_PUBLIC_IP) ssh $(MQ_B_A_IP) "sudo /opt/mqm/bin/rdqmdr -p -m DRHAQM1"
	
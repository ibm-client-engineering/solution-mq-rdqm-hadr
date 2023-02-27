
profile-dir:
	@mkdir -p $(DATA_DIR)
	@mkdir -p $(DATA_DIR)/ssh

etc-hosts:
	@echo "$(MQ_A_A_IP)       $(MQ_NAME_A_A)">$(DATA_DIR)/hosts
	@echo "$(MQ_A_B_IP)       $(MQ_NAME_A_B)">>$(DATA_DIR)/hosts
	@echo "$(MQ_A_C_IP)       $(MQ_NAME_A_C)">>$(DATA_DIR)/hosts
	@echo "$(MQ_B_A_IP)       $(MQ_NAME_B_A)">>$(DATA_DIR)/hosts
	@echo "$(MQ_B_B_IP)       $(MQ_NAME_B_B)">>$(DATA_DIR)/hosts
	@echo "$(MQ_B_C_IP)       $(MQ_NAME_B_C)">>$(DATA_DIR)/hosts
	@echo "$(BASTION_A_IP)    $(BASTION_A_NAME)">>$(DATA_DIR)/hosts
	@echo "$(BASTION_B_IP)    $(BASTION_B_NAME)">>$(DATA_DIR)/hosts
	@echo "$(MQIPT_A_IP)      $(MQIPT_A_NAME)">>$(DATA_DIR)/hosts
	@echo "$(MQIPT_B_IP)      $(MQIPT_B_NAME)">>$(DATA_DIR)/hosts

init: profile-dir etc-hosts

download-kmod:
	wget https://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/messaging/mqadv/mqadv_dev931_linux_x86-64.tar.gz -O $(DATA_DIR)/mqadv_dev931_linux_x86-64.tar.gz

download-mqipt:
	wget https://ak-delivery04-mul.dhe.ibm.com/sdfdl/v2/sar/CM/WS/0b487/0/Xa.2/Xb.jusyLTSp44S03WBy8fq9680CGyxJSIqgDLPjgK-iHtoJNfIpWmV317YW5B4/Xc.CM/WS/0b487/0/9.2.0.8-IBM-MQIPT-LinuxX64.tar.gz/Xd./Xf.LPR.D1VK/Xg.12184622/Xi.habanero/XY.habanero/XZ.xfD6DSMB2_mikiVbMRqLbQWhaKYN1wCr/9.2.0.8-IBM-MQIPT-LinuxX64.tar.gz -O $(DATA_DIR)/



### This function will execute any function on all hosts if you prefix it with all-
exec-a: 
	-@$(MAKE) TARGET=$(MQ_A_A_SSH) HOSTNAME=$(MQ_NAME_A_A) $(FUNCTION) 
	-@$(MAKE) TARGET=$(MQ_A_B_SSH) HOSTNAME=$(MQ_NAME_A_B) $(FUNCTION) 
	-@$(MAKE) TARGET=$(MQ_A_C_SSH) HOSTNAME=$(MQ_NAME_A_C) $(FUNCTION) 

exec-b:
	-@$(MAKE) TARGET=$(MQ_B_A_SSH) HOSTNAME=$(MQ_NAME_B_A) $(FUNCTION) 
	-@$(MAKE) TARGET=$(MQ_B_B_SSH) HOSTNAME=$(MQ_NAME_B_B) $(FUNCTION) 
	-@$(MAKE) TARGET=$(MQ_B_C_SSH) HOSTNAME=$(MQ_NAME_B_C) $(FUNCTION) 

all-%: 
	@echo -e "\e[1;32m - Executing on $(MQ_NAME_A_A) $(FUNCTION) - \e[0m\n\n"
	@-$(MAKE) TARGET=$(MQ_A_A_SSH) HOSTNAME=$(MQ_NAME_A_A) $(FUNCTION) 
	@echo -e "\e[1;32m - Executing on $(MQ_NAME_A_B) $(FUNCTION) - \e[0m\n\n"
	@-$(MAKE) TARGET=$(MQ_A_B_SSH) HOSTNAME=$(MQ_NAME_A_B) $(FUNCTION) 
	@echo -e "\e[1;32m - Executing on $(MQ_NAME_A_C) $(FUNCTION) - \e[0m\n\n"
	@-$(MAKE) TARGET=$(MQ_A_C_SSH) HOSTNAME=$(MQ_NAME_A_C) $(FUNCTION) 
	@echo -e "\e[1;32m - Executing on $(MQ_NAME_B_A) $(FUNCTION) - \e[0m\n\n"
	@-$(MAKE) TARGET=$(MQ_B_A_SSH) HOSTNAME=$(MQ_NAME_B_A) $(FUNCTION) 
	@echo -e "\e[1;32m - Executing on $(MQ_NAME_B_B) $(FUNCTION) - \e[0m\n\n"
	@-$(MAKE) TARGET=$(MQ_B_B_SSH) HOSTNAME=$(MQ_NAME_B_B) $(FUNCTION) 
	@echo -e "\e[1;32m - Executing on $(MQ_NAME_B_C) $(FUNCTION) - \e[0m\n\n"
	@-$(MAKE) TARGET=$(MQ_B_C_SSH) HOSTNAME=$(MQ_NAME_B_C) $(FUNCTION) 


arns:
	aws resourcegroupstaggingapi get-resources --region $(REGION_A) --tag-filters Key=Project,Values=$(PROJECT_NAME) Key=Rev,Values=$(PROJECT_REV) --query 'ResourceTagMappingList[].ResourceARN' --output json
	aws resourcegroupstaggingapi get-resources --region $(REGION_B) --tag-filters Key=Project,Values=$(PROJECT_NAME) Key=Rev,Values=$(PROJECT_REV) --query 'ResourceTagMappingList[].ResourceARN' --output json



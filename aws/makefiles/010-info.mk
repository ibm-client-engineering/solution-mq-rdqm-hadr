
variables:
	@echo ""
	@echo ""
	@echo ""
	@echo "PROJECT UIDS"
	@echo " PROJECT_NAME             : $(PROJECT_NAME)"
	@echo " PROJECT_REV              : $(PROJECT_REV)"
	@echo " PRJ_ID                   : $(PRJ_ID)"

	@echo "Automation Profile Data"
	@echo " DATA_DIR                 : $(DATA_DIR)"
	@echo " PEM_FILE                 : $(PEM_FILE)"
	@echo " MQM_PEM_FILE             : $(MQM_PEM_FILE)"

	@echo "BASTION WORKING DIR"
	@echo " INSTALL_DIR              : $(INSTALL_DIR)"

	@echo "LOCAL TEMP FILE"
	@echo " INSTANCE_FILE            : $(INSTANCE_FILE)"

	@echo "AWS ID NAMES"
	@echo " A_NAME                   : $(A_NAME)"
	@echo " B_NAME                   : $(B_NAME)"
	@echo " KEY_NAME                 : $(KEY_NAME)"
	@echo " VPC_A_NAME               : $(VPC_A_NAME)"
	@echo " VPC_B_NAME               : $(VPC_B_NAME)"
	@echo " SUBNET_A_A_NAME          : $(SUBNET_A_A_NAME)"
	@echo " SUBNET_A_B_NAME          : $(SUBNET_A_B_NAME)"
	@echo " SUBNET_A_C_NAME          : $(SUBNET_A_C_NAME)"
	@echo " SUBNET_A_D_NAME          : $(SUBNET_A_D_NAME)"
	@echo " SUBNET_A_E_NAME          : $(SUBNET_A_E_NAME)"
	@echo " SUBNET_B_A_NAME          : $(SUBNET_B_A_NAME)"
	@echo " SUBNET_B_B_NAME          : $(SUBNET_B_B_NAME)"
	@echo " SUBNET_B_C_NAME          : $(SUBNET_B_C_NAME)"
	@echo " SUBNET_B_D_NAME          : $(SUBNET_B_D_NAME)"
	@echo " SUBNET_B_E_NAME          : $(SUBNET_B_E_NAME)"
	@echo " GATEWAY_A_NAME           : $(GATEWAY_A_NAME)"
	@echo " GATEWAY_B_NAME           : $(GATEWAY_B_NAME)"
	@echo " ATTACHMENT_A_NAME        : $(ATTACHMENT_A_NAME)"
	@echo " ATTACHMENT_B_NAME        : $(ATTACHMENT_B_NAME)"
	@echo " PEERING_NAME             : $(PEERING_NAME)"
	@echo " IGW_A_NAME               : $(IGW_A_NAME)"
	@echo " IGW_B_NAME               : $(IGW_B_NAME)"
	@echo " NAT_GW_A_PUBLIC_IP_NAME  : $(NAT_GW_A_PUBLIC_IP_NAME)"
	@echo " NAT_GW_B_PUBLIC_IP_NAME  : $(NAT_GW_B_PUBLIC_IP_NAME)"
	@echo " NAT_GW_A_NAME            : $(NAT_GW_A_NAME)"
	@echo " NAT_GW_B_NAME            : $(NAT_GW_B_NAME)"
	@echo " SECURITY_GROUP_A_NAME    : $(SECURITY_GROUP_A_NAME)"
	@echo " SECURITY_GROUP_B_NAME    : $(SECURITY_GROUP_B_NAME)"
	@echo " BASTION_A_PUBLIC_IP_NAME : $(BASTION_A_PUBLIC_IP_NAME)"
	@echo " BASTION_B_PUBLIC_IP_NAME : $(BASTION_B_PUBLIC_IP_NAME)"
	@echo " ROUTE_TABLE_A_NAME       : $(ROUTE_TABLE_A_NAME)"
	@echo " ROUTE_TABLE_B_NAME       : $(ROUTE_TABLE_B_NAME)"

# AWS REGIONS
	@echo "AWS REGION Info"
	@echo " REGION_A               : $(REGION_A)"
	@echo " REGION_B               : $(REGION_B)"

	@echo "AWS ZONE Info"
	@echo " ZONE_A_A               : $(ZONE_A_A)"
	@echo " ZONE_A_B               : $(ZONE_A_B)"
	@echo " ZONE_A_C               : $(ZONE_A_C)"
	@echo " ZONE_B_A               : $(ZONE_B_A)"
	@echo " ZONE_B_B               : $(ZONE_B_B)"
	@echo " ZONE_B_C               : $(ZONE_B_C)"
	@echo " ZONES_A                : $(ZONES_A)"
	@echo " ZONES_B                : $(ZONES_B)"


	@echo "VPC CIDR's"
	@echo " VPC_A_CIDR           : $(VPC_A_CIDR)"
	@echo " VPC_B_CIDR           : $(VPC_B_CIDR)"

	@echo "Subnet Region A CIDR's"
	@echo " VPC_A_SUBNET_A       : $(VPC_A_SUBNET_A)"
	@echo " VPC_A_SUBNET_B       : $(VPC_A_SUBNET_B)"
	@echo " VPC_A_SUBNET_C       : $(VPC_A_SUBNET_C)"
	@echo " VPC_A_SUBNET_D       : $(VPC_A_SUBNET_D)"
	@echo " VPC_A_SUBNET_E       : $(VPC_A_SUBNET_E)"
	@echo "Subnet Region B CIDR's"
	@echo " VPC_B_SUBNET_A       : $(VPC_B_SUBNET_A)"
	@echo " VPC_B_SUBNET_B       : $(VPC_B_SUBNET_B)"
	@echo " VPC_B_SUBNET_C       : $(VPC_B_SUBNET_C)"
	@echo " VPC_B_SUBNET_D       : $(VPC_B_SUBNET_D)"
	@echo " VPC_B_SUBNET_E       : $(VPC_B_SUBNET_E)"


	@echo "Compute info"
	@echo " BASTION_AMI          : $(BASTION_AMI)"
	@echo " BASTION_TYPE         : $(BASTION_TYPE)"
	@echo " BASTION_DISK_TYPE    : $(BASTION_DISK_TYPE)"
	@echo " MQ_A_AMI             : $(MQ_A_AMI)"
	@echo " MQ_A_TYPE            : $(MQ_A_TYPE)"
	@echo " MQ_A_DISK_TYPE       : $(MQ_A_DISK_TYPE)"
	@echo " MQ_B_AMI             : $(MQ_B_AMI)"
	@echo " MQ_B_TYPE            : $(MQ_B_TYPE)"
	@echo " MQ_B_DISK_TYPE       : $(MQ_B_DISK_TYPE)"
	@echo " MQIPT_A_ZONE         : $(MQIPT_A_ZONE)"
	@echo " MQIPT_B_ZONE         : $(MQIPT_B_ZONE)"

	@echo "Compute IP's"
	@echo " MQIPT_A_IP           : $(MQIPT_A_IP)"
	@echo " MQIPT_B_IP           : $(MQIPT_B_IP)"
	@echo " BASTION_A_IP         : $(BASTION_A_IP)"
	@echo " BASTION_B_IP         : $(BASTION_B_IP)"
	@echo " MQ_A_A_IP            : $(MQ_A_A_IP)"
	@echo " MQ_A_B_IP            : $(MQ_A_B_IP)"
	@echo " MQ_A_C_IP            : $(MQ_A_C_IP)"
	@echo " MQ_B_A_IP            : $(MQ_B_A_IP)"
	@echo " MQ_B_B_IP            : $(MQ_B_B_IP)"
	@echo " MQ_B_C_IP            : $(MQ_B_C_IP)"

# SSH
	@echo "SSH INFO"
	@echo " BASTION_USER         : $(BASTION_USER)"
	@echo " BASTION_A_SSH        : $(BASTION_A_SSH)"
	@echo " BASTION_B_SSH        : $(BASTION_B_SSH)"
	@echo " MQ_A_A_SSH           : $(MQ_A_A_SSH)"
	@echo " MQ_A_B_SSH           : $(MQ_A_B_SSH)"
	@echo " MQ_A_C_SSH           : $(MQ_A_C_SSH)"
	@echo " MQ_B_A_SSH           : $(MQ_B_A_SSH)"
	@echo " MQ_B_B_SSH           : $(MQ_B_B_SSH)"
	@echo " MQ_B_C_SSH           : $(MQ_B_C_SSH)"
	@echo " MQIPT_A_SSH          : $(MQIPT_A_SSH)"
	@echo " MQIPT_B_SSH          : $(MQIPT_B_SSH)"
 
 ## HOSTNAMES
	@echo "Hostnames"
	@echo " MQ_NAME_A_A          :" $(MQ_NAME_A_A)
	@echo " MQ_NAME_A_B          :" $(MQ_NAME_A_B)
	@echo " MQ_NAME_A_C          :" $(MQ_NAME_A_C)
	@echo " MQ_NAME_B_A          :" $(MQ_NAME_B_A)
	@echo " MQ_NAME_B_B          :" $(MQ_NAME_B_B)
	@echo " MQ_NAME_B_C          :" $(MQ_NAME_B_C)
	@echo " BASTION_A_NAME       :" $(BASTION_A_NAME)
	@echo " BASTION_B_NAME       :" $(BASTION_B_NAME)
	@echo " MQIPT_A_NAME         :" $(MQIPT_A_NAME)
	@echo " MQIPT_B_NAME         :" $(MQIPT_B_NAME)


info:
# Print out AWS configuration for this project to the console
	@echo "AWS Regions"
	@echo "  Region A : $(REGION_A)"
	@echo "  Region B : $(REGION_B)"

	@echo " --AWS TAGS --"
	@echo "     - VPC_A_NAME         :$(VPC_A_NAME)"
	@echo "     - VPC_B_NAME         :$(VPC_B_NAME)"
	@echo "     - SUBNET_A_A_NAME    :$(SUBNET_A_A_NAME)"
	@echo "     - SUBNET_A_B_NAME    :$(SUBNET_A_B_NAME)"
	@echo "     - SUBNET_A_C_NAME    :$(SUBNET_A_C_NAME)"
	@echo "     - SUBNET_B_A_NAME    :$(SUBNET_B_A_NAME)"
	@echo "     - SUBNET_B_B_NAME    :$(SUBNET_B_B_NAME)"
	@echo "     - SUBNET_B_C_NAME    :$(SUBNET_B_C_NAME)"
	@echo "     - GATEWAY_A_NAME     :$(GATEWAY_A_NAME)"
	@echo "     - GATEWAY_B_NAME     :$(GATEWAY_B_NAME)"
	@echo "     - ATTACHMENT_A_NAME  :$(ATTACHMENT_A_NAME)"
	@echo "     - ATTACHMENT_B_NAME  :$(ATTACHMENT_B_NAME)"
	@echo "     - PEERING_NAME       :$(PEERING_NAME)"
	@echo " ------------"
	
	@echo "VPC A"
	@echo "  Name : $(VPC_A_NAME)"
	@echo "  CIDR :$(VPC_A_CIDR)"
	@echo "  VPC A ID: $(VPC_A_ID)"
	@echo "  Subnet :"
	@echo "    - $(VPC_A_SUBNET_A)";
	@echo "    - $(VPC_A_SUBNET_B)";
	@echo "    - $(VPC_A_SUBNET_C)";



	@echo "    Subnet A ID:  $(VPC_A_SUBNET_A_ID)"
	@echo "    Subnet B ID:  $(VPC_A_SUBNET_B_ID)"
	@echo "    Subnet C ID:  $(VPC_A_SUBNET_C_ID)"
	
	#	done
	@echo "VPC B"
	@echo "  Name : $(VPC_B_NAME)"
	@echo "  CIDR :$(VPC_B_CIDR)"
	@echo "  VPC B ID: $(VPC_B_ID)"
	@echo "  Subnet :"
	@echo "    - $(VPC_B_SUBNET_A)";
	@echo "    - $(VPC_B_SUBNET_B)";
	@echo "    - $(VPC_B_SUBNET_C)";
	@echo "     Subnet A ID:  $(VPC_B_SUBNET_A_ID)"
	@echo "     Subnet B ID:  $(VPC_B_SUBNET_B_ID)"
	@echo "     Subnet C ID:  $(VPC_B_SUBNET_C_ID)"

	@echo "Bastion"
	@echo "  AMI : $(BASTION_AMI)"
	@echo "  Type : $(BASTION_TYPE)"
	@echo "  Zone :"
	@for  x in $(BASTION_ZONES); do \
	      echo "    - $$x"; \
		done
	@echo "  Disks: $(BASTION_DISKS)"
	@echo "  Disk Type: $(BASTION_DISK_TYPE)"

	@echo "REGION A"
	@echo "  AMI : $(MQ_A_AMI)"
	@echo "  Type : $(MQ_A_TYPE)"
	@echo "  Zones :"
	@for  x in $(MQ_A_ZONES); do \
	      echo "    - $$x"; \
		done
	@echo "  Disks: $(MQ_A_DISKS)"
	@echo "  Disk Type: $(MQ_A_DISK_TYPE)"

	@echo "REGION B"
	@echo "  AMI : $(MQ_B_AMI)"
	@echo "  Type : $(MQ_B_TYPE)"
	@echo "  Zones :"
	@for  x in $(MQ_B_ZONES); do \
	      echo "    - $$x"; \
		done
	@echo "  Disks: $(MQ_B_DISKS)"
	@echo "  Disk Type: $(MQ_B_DISK_TYPE)"


configure_aws:
	aws configure set aws_access_key_id $(AWS_ACCESS_KEY_ID)
	aws configure set aws_secret_access_key $(AWS_SECRET_ACCESS_KEY)
	aws configure set default.region $(AWS_DEFAULT_REGION)	  


get-mq:
	@wget https://github.com/mikefarah/yq/releases/download/v4.30.8/yq_linux_amd64 -O yq
	@chmod +x yq

preqs: get-mq


get-vpc-id-a:
	@aws ec2 describe-vpcs --region $(REGION_A) --filters "Name=tag:Name,Values=$(VPC_A_NAME)" \
	  $(PROJECT_TAGS)--query 'Vpcs[0].VpcId' --output text> tmp.$(INSTANCE_FILE)
	@echo $$(cat tmp.$(INSTANCE_FILE))

get-vpc-id-b:
	@aws ec2 describe-vpcs --region $(REGION_B) --filters "Name=tag:Name,Values=$(VPC_B_NAME)" \
	  $(PROJECT_TAGS)--query 'Vpcs[0].VpcId' --output text> tmp.$(INSTANCE_FILE)
	@echo $$(cat tmp.$(INSTANCE_FILE))

get-vpc-ids: get-vpc-id-a get-vpc-id-b
	
get-transit-gateway-id:
	aws ec2 describe-transit-gateways \
	--filters "Name=state,Values=available" "Name=tag:Name,Values=TRANSIT_GATEWAY" $(PROJECT_TAGS)\
  	--output text \
	--query 'TransitGateways[0].TransitGatewayId'


delete-transit-gateway:
	aws ec2 delete-transit-gateway \
	--transit-gateway-id tgw-0d5bd912d8cd3ca56

get-pid-a:
	aws ec2 describe-transit-gateway-peering-attachments --filters "Name=state,Values=pendingAcceptance" "Name=tag:Name,Values=$(PEERING_A_NAME)" $(PROJECT_TAGS) --region $(REGION_A)  --output text --query 'TransitGatewayPeeringAttachments[0].TransitGatewayAttachmentId' 

get-pid-b:
	aws ec2 describe-transit-gateway-peering-attachments --filters "Name=state,Values=pendingAcceptance" "Name=tag:Name,Values=$(PEERING_B_NAME)" $(PROJECT_TAGS) --region $(REGION_B)  --output text --query 'TransitGatewayPeeringAttachments[0].TransitGatewayAttachmentId' 
      

get-peering-id:
	aws ec2 describe-transit-gateway-peering-attachments --region $(REGION_A) --filters "Name=state,Values=available" "Name=tag:Name,Values=$(PEERING_NAME)" $(PROJECT_TAGS) --output text --query 'TransitGatewayPeeringAttachments[0].TransitGatewayAttachmentId' 

#	aws ec2 describe-transit-gateway-route-tables --transit-gateway-route-table-ids  $(TRANSIT_GW_A_RT_ID) --query "TransitGatewayRouteTables[0].TransitGatewayRouteTableId" --output text

target-a-a:
	@echo $(MQ_A_A_SSH)
target-a-b:
	@echo $(MQ_A_B_SSH)
target-a-c:
	@echo $(MQ_A_C_SSH)

target-b-a:
	@echo $(MQ_B_A_SSH)
target-b-b:
	@echo $(MQ_B_B_SSH)
target-b-c:
	@echo $(MQ_B_C_SSH)
	
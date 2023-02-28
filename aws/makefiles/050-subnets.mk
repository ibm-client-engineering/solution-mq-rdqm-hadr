
subnets-a:
	@echo "Creating Subnets for VPC A"
	aws ec2 create-subnet --vpc-id $(VPC_A_ID) --cidr-block $(VPC_A_SUBNET_A) \
	   --region $(REGION_A) --availability-zone $(ZONE_A_A) --query 'Subnet.SubnetId' --output text> tmp.$(INSTANCE_FILE) \
	   --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=$(SUBNET_A_A_NAME)},{Key=Project,Value=$(PROJECT_NAME)},{Key=Rev,Value=$(PROJECT_REV)}]' 


	aws ec2 create-subnet --vpc-id $(VPC_A_ID) --cidr-block $(VPC_A_SUBNET_B) \
	   --region $(REGION_A) --availability-zone $(ZONE_A_B) --query 'Subnet.SubnetId' --output text> tmp.$(INSTANCE_FILE) \
	   --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=$(SUBNET_A_B_NAME)},{Key=Project,Value=$(PROJECT_NAME)},{Key=Rev,Value=$(PROJECT_REV)}]' 

	aws ec2 create-subnet --vpc-id $(VPC_A_ID) --cidr-block $(VPC_A_SUBNET_C) \
	   --region $(REGION_A) --availability-zone $(ZONE_A_C) --query 'Subnet.SubnetId' --output text> tmp.$(INSTANCE_FILE) \
	   --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=$(SUBNET_A_C_NAME)},{Key=Project,Value=$(PROJECT_NAME)},{Key=Rev,Value=$(PROJECT_REV)}]' 

	aws ec2 create-subnet --vpc-id $(VPC_A_ID) --cidr-block $(VPC_A_SUBNET_D) \
	   --region $(REGION_A) \
	   --availability-zone $(ZONE_A_A) --query 'Subnet.SubnetId' --output text> tmp.$(INSTANCE_FILE) \
	   --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=$(SUBNET_A_D_NAME)},{Key=Project,Value=$(PROJECT_NAME)},{Key=Rev,Value=$(PROJECT_REV)}]' 

	aws ec2 create-subnet --vpc-id $(VPC_A_ID) --cidr-block $(VPC_A_SUBNET_E) \
	   --region $(REGION_A) --availability-zone $(MQIPT_A_ZONE) --query 'Subnet.SubnetId' --output text> tmp.$(INSTANCE_FILE) \
	   --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=$(SUBNET_A_E_NAME)},{Key=Project,Value=$(PROJECT_NAME)},{Key=Rev,Value=$(PROJECT_REV)}]' 

subnets-b:
	@echo "Creating Subnets for VPC B"
	aws ec2 create-subnet --vpc-id $(VPC_B_ID) --cidr-block $(VPC_B_SUBNET_A) \
	   --region $(REGION_B) --availability-zone $(ZONE_B_A) --query 'Subnet.SubnetId' --output text> tmp.$(INSTANCE_FILE) \
	   --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=$(SUBNET_B_A_NAME)},{Key=Project,Value=$(PROJECT_NAME)},{Key=Rev,Value=$(PROJECT_REV)}]' 


	aws ec2 create-subnet --vpc-id $(VPC_B_ID) --cidr-block $(VPC_B_SUBNET_B) \
	   --region $(REGION_B) --availability-zone $(ZONE_B_B) --query 'Subnet.SubnetId' --output text> tmp.$(INSTANCE_FILE) \
	   --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=$(SUBNET_B_B_NAME)},{Key=Project,Value=$(PROJECT_NAME)},{Key=Rev,Value=$(PROJECT_REV)}]' 

	aws ec2 create-subnet --vpc-id $(VPC_B_ID) --cidr-block $(VPC_B_SUBNET_C) \
	   --region $(REGION_B) --availability-zone $(ZONE_B_C) --query 'Subnet.SubnetId' --output text> tmp.$(INSTANCE_FILE) \
	   --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=$(SUBNET_B_C_NAME)},{Key=Project,Value=$(PROJECT_NAME)},{Key=Rev,Value=$(PROJECT_REV)}]' 

	aws ec2 create-subnet --vpc-id $(VPC_B_ID) --cidr-block $(VPC_B_SUBNET_D) \
	   --region $(REGION_B) \
	   --availability-zone $(ZONE_B_A) --query 'Subnet.SubnetId' --output text> tmp.$(INSTANCE_FILE) \
	   --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=$(SUBNET_B_D_NAME)},{Key=Project,Value=$(PROJECT_NAME)},{Key=Rev,Value=$(PROJECT_REV)}]' 

	aws ec2 create-subnet --vpc-id $(VPC_B_ID) --cidr-block $(VPC_B_SUBNET_E) \
	   --region $(REGION_B) --availability-zone $(MQIPT_B_ZONE) --query 'Subnet.SubnetId' --output text> tmp.$(INSTANCE_FILE) \
	   --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=$(SUBNET_B_E_NAME)},{Key=Project,Value=$(PROJECT_NAME)},{Key=Rev,Value=$(PROJECT_REV)}]' 

subnets: subnets-a subnets-b


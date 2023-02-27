
internet-gateway-a:
	@echo "Creating Internet Gateway"
	aws ec2 create-internet-gateway  --region $(REGION_A) --query "InternetGateway.InternetGatewayId" --output text > tmp.$(INSTANCE_FILE)
	aws ec2 create-tags --region $(REGION_A)  --resources $$(cat tmp.$(INSTANCE_FILE)) --tags Key=Name,Value=$(IGW_A_NAME) Key=Project,Value=$(PROJECT_NAME) Key=Rev,Value=$(PROJECT_REV)


internet-gateway-b:
	@echo "Creating Internet Gateway"
	aws ec2 create-internet-gateway  --region $(REGION_B) --query "InternetGateway.InternetGatewayId" --output text > tmp.$(INSTANCE_FILE)
	aws ec2 create-tags --region $(REGION_B)  --resources $$(cat tmp.$(INSTANCE_FILE)) --tags Key=Name,Value=$(IGW_B_NAME) Key=Project,Value=$(PROJECT_NAME) Key=Rev,Value=$(PROJECT_REV)

internet-gateway: internet-gateway-a internet-gateway-b

attach-vpc-to-igw-a:
	aws ec2 attach-internet-gateway --vpc-id $(VPC_A_ID) --internet-gateway-id $(IGW_A_ID) --region $(REGION_A)

attach-vpc-to-igw-b:
	aws ec2 attach-internet-gateway --vpc-id $(VPC_B_ID) --internet-gateway-id $(IGW_B_ID) --region $(REGION_B)

attach-vpc-to-igw: attach-vpc-to-igw-a attach-vpc-to-igw-b


get-igw-id-a:
	aws ec2 describe-internet-gateways --filter "Name=tag:Name,Values=$(IGW_NAME)" $(PROJECT_TAGS) --query "InternetGateways[0].InternetGatewayId" --region $(REGION_A) --output text 


igw-route-table-a:
	aws ec2 create-route-table --region $(REGION_A) --vpc-id $(VPC_A_ID) --query RouteTable.RouteTableId --output text>tmp.$(INSTANCE_FILE)
	aws ec2 create-tags --region $(REGION_A) --resources $$(cat tmp.${INSTANCE_FILE})  \
		--region ${REGION_A} \
	    --tags Key=Name,Value=$(ROUTE_TABLE_A_NAME) Key=Project,Value=$(PROJECT_NAME) Key=Rev,Value=$(PROJECT_REV)

igw-route-table-b:
	aws ec2 create-route-table --region $(REGION_B) --vpc-id $(VPC_B_ID) --query RouteTable.RouteTableId --output text>tmp.$(INSTANCE_FILE)
	aws ec2 create-tags --resources $$(cat tmp.${INSTANCE_FILE})  \
		--region ${REGION_B} \
	    --tags Key=Name,Value=$(ROUTE_TABLE_B_NAME) Key=Project,Value=$(PROJECT_NAME) Key=Rev,Value=$(PROJECT_REV)

igw-route-table: igw-route-table-a igw-route-table-b

igw-route-a:
#	aws ec2 describe-route-tables --filters "Name=vpc-id,Values=$(VPC_A_ID)" --query "RouteTables[*].RouteTableId" --output text
	aws ec2 create-route --region $(REGION_A) --route-table-id $(VPC_A_RT_ID) --destination-cidr-block 0.0.0.0/0  --gateway-id $(IGW_A_ID)

igw-route-b:
#	aws ec2 describe-route-tables --filters "Name=vpc-id,Values=$(VPC_A_ID)" --query "RouteTables[*].RouteTableId" --output text
	aws ec2 create-route --region $(REGION_B) --route-table-id $(VPC_B_RT_ID) --destination-cidr-block 0.0.0.0/0  --gateway-id $(IGW_B_ID)

igw-route: igw-route-a igw-route-b

igw-a-rt-attach-bastion-subnet:
	aws ec2 associate-route-table  --subnet-id $(VPC_A_SUBNET_D_ID) --route-table-id  $(VPC_A_RT_ID) --region $(REGION_A) --output text

igw-b-rt-attach-bastion-subnet:
	aws ec2 associate-route-table  --subnet-id $(VPC_B_SUBNET_D_ID) --route-table-id  $(VPC_B_RT_ID) --region $(REGION_B) --output text

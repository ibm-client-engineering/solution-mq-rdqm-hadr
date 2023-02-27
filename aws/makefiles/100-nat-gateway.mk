
nat-gw-a-ip:
	aws ec2 allocate-address --region $(REGION_A) --query "AllocationId" --output text>tmp.$(INSTANCE_FILE)
	aws ec2 create-tags --resources $$(cat tmp.${INSTANCE_FILE})  \
		--region ${REGION_A} \
	    --tags Key=Name,Value=$(NAT_GW_A_PUBLIC_IP_NAME) Key=Project,Value=$(PROJECT_NAME) Key=Rev,Value=$(PROJECT_REV) \
		--output json


nat-gw-b-ip:
	aws ec2 allocate-address --region $(REGION_B) --query "AllocationId" --output text>tmp.$(INSTANCE_FILE)
	aws ec2 create-tags --resources $$(cat tmp.${INSTANCE_FILE})  \
		--region ${REGION_B} \
	    --tags Key=Name,Value=$(NAT_GW_B_PUBLIC_IP_NAME) Key=Project,Value=$(PROJECT_NAME) Key=Rev,Value=$(PROJECT_REV) \
		--output json

nat-gw-a:
	aws ec2 create-nat-gateway --region $(REGION_A) --subnet-id $(VPC_A_SUBNET_D_ID)  --allocation-id $(NAT_GW_A_ASSOCIATION_ID) --query 'NatGateway.NatGatewayId' --output text > tmp.${INSTANCE_FILE}
	aws ec2 create-tags --resources $$(cat tmp.${INSTANCE_FILE})  \
		--region ${REGION_A} \
	    --tags Key=Name,Value=$(NAT_GW_A_NAME) Key=Project,Value=$(PROJECT_NAME) Key=Rev,Value=$(PROJECT_REV) \
		--output json

nat-gw-b:
	aws ec2 create-nat-gateway --region $(REGION_B) --subnet-id $(VPC_B_SUBNET_D_ID)  --allocation-id $(NAT_GW_B_ASSOCIATION_ID) --query 'NatGateway.NatGatewayId' --output text > tmp.${INSTANCE_FILE}
	aws ec2 create-tags --resources $$(cat tmp.${INSTANCE_FILE})  \
		--region ${REGION_B} \
	    --tags Key=Name,Value=$(NAT_GW_B_NAME) Key=Project,Value=$(PROJECT_NAME) Key=Rev,Value=$(PROJECT_REV) \
		--output json

l:
	aws ec2 describe-route-tables --region $(REGION_A) --filters "Name=tag:Name,Values=$(ROUTE_TABLE_A_NAME)" $(PROJECT_TAGS) --query "RouteTables[0].RouteTableId" --output text
# Wait for the NAT Gateway to be available
#WAIT_NAT = $(shell aws ec2 wait nat-gateway-available --nat-gateway-ids $(NAT_GATEWAY_ID))

associate-subnet-with-nat-gw-a:
	aws ec2 create-route  --route-table-id $(VPC_A_DEFAULT_RT_ID) \
	 --region $(REGION_A) \
  	 --destination-cidr-block 0.0.0.0/0 \
  	 --nat-gateway-id $(NAT_GW_A_ID) \
  	 --output json
  

associate-subnet-with-nat-gw-b:
	aws ec2 create-route  --route-table-id $(VPC_B_DEFAULT_RT_ID) \
	 --region $(REGION_B) \
  	 --destination-cidr-block 0.0.0.0/0 \
  	 --nat-gateway-id $(NAT_GW_B_ID) \
  	 --output json
  


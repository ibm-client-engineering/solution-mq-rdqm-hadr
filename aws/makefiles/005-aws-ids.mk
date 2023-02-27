PROJECT_TAGS="Name=tag:Project,Values=$(PROJECT_NAME)" "Name=tag:Rev,Values=$(PROJECT_REV)" 
DEFAULT_TAG_SPECS={Key=Project,Value=$(PROJECT_NAME)},{Key=Rev,Value=$(PROJECT_REV)}
# VPC
VPC_A_ID:=$(shell aws ec2 describe-vpcs --region $(REGION_A) --filters "Name=tag:Name,Values=$(VPC_A_NAME)" $(PROJECT_TAGS)--query 'Vpcs[0].VpcId' --output text)
VPC_B_ID:=$(shell aws ec2 describe-vpcs --region $(REGION_B) --filters "Name=tag:Name,Values=$(VPC_B_NAME)" $(PROJECT_TAGS)--query 'Vpcs[0].VpcId' --output text)
# SUBNET A
VPC_A_SUBNET_A_ID=$(shell aws ec2 describe-subnets --region $(REGION_A) --filters "Name=state,Values=available" "Name=tag:Name,Values=$(SUBNET_A_A_NAME)" $(PROJECT_TAGS) --query 'Subnets[0].SubnetId' --output text)
VPC_A_SUBNET_B_ID=$(shell aws ec2 describe-subnets --region $(REGION_A) --filters "Name=state,Values=available" "Name=tag:Name,Values=$(SUBNET_A_B_NAME)" $(PROJECT_TAGS) --query 'Subnets[0].SubnetId' --output text)
VPC_A_SUBNET_C_ID=$(shell aws ec2 describe-subnets --region $(REGION_A) --filters "Name=state,Values=available" "Name=tag:Name,Values=$(SUBNET_A_C_NAME)" $(PROJECT_TAGS) --query 'Subnets[0].SubnetId' --output text)
VPC_A_SUBNET_D_ID=$(shell aws ec2 describe-subnets --region $(REGION_A) --filters "Name=state,Values=available" "Name=tag:Name,Values=$(SUBNET_A_D_NAME)" $(PROJECT_TAGS) --query 'Subnets[0].SubnetId' --output text)
VPC_A_SUBNET_E_ID=$(shell aws ec2 describe-subnets --region $(REGION_A) --filters "Name=state,Values=available" "Name=tag:Name,Values=$(SUBNET_A_E_NAME)" $(PROJECT_TAGS) --query 'Subnets[0].SubnetId' --output text)
# SUBNET B
VPC_B_SUBNET_A_ID=$(shell aws ec2 describe-subnets --region $(REGION_B) --filters "Name=state,Values=available" "Name=tag:Name,Values=$(SUBNET_B_A_NAME)" $(PROJECT_TAGS) --query 'Subnets[0].SubnetId' --output text)
VPC_B_SUBNET_B_ID=$(shell aws ec2 describe-subnets --region $(REGION_B) --filters "Name=state,Values=available" "Name=tag:Name,Values=$(SUBNET_B_B_NAME)" $(PROJECT_TAGS) --query 'Subnets[0].SubnetId' --output text)
VPC_B_SUBNET_C_ID=$(shell aws ec2 describe-subnets --region $(REGION_B) --filters "Name=state,Values=available" "Name=tag:Name,Values=$(SUBNET_B_C_NAME)" $(PROJECT_TAGS) --query 'Subnets[0].SubnetId' --output text)
VPC_B_SUBNET_D_ID=$(shell aws ec2 describe-subnets --region $(REGION_B) --filters "Name=state,Values=available" "Name=tag:Name,Values=$(SUBNET_B_D_NAME)" $(PROJECT_TAGS) --query 'Subnets[0].SubnetId' --output text)
VPC_B_SUBNET_E_ID=$(shell aws ec2 describe-subnets --region $(REGION_B) --filters "Name=state,Values=available" "Name=tag:Name,Values=$(SUBNET_B_E_NAME)" $(PROJECT_TAGS) --query 'Subnets[0].SubnetId' --output text)
# Transit Gateway
TRANSIT_GATEWAY_A_ID=$(shell aws ec2 describe-transit-gateways --region $(REGION_A) --filters "Name=state,Values=available" "Name=tag:Name,Values=$(GATEWAY_A_NAME)" $(PROJECT_TAGS) --output text --query 'TransitGateways[0].TransitGatewayId')
TRANSIT_GATEWAY_B_ID=$(shell aws ec2 describe-transit-gateways --region $(REGION_B) --filters "Name=state,Values=available" "Name=tag:Name,Values=$(GATEWAY_B_NAME)" $(PROJECT_TAGS) --output text --query 'TransitGateways[0].TransitGatewayId')
# Transit Gateway Default Route Table ID
TRANSIT_GW_A_RT_ID=$(shell aws ec2 describe-transit-gateways --region $(REGION_A) --filters "Name=state,Values=available" "Name=tag:Name,Values=$(GATEWAY_A_NAME)" $(PROJECT_TAGS) --output text --query 'TransitGateways[0].Options.AssociationDefaultRouteTableId')
TRANSIT_GW_B_RT_ID=$(shell aws ec2 describe-transit-gateways --region $(REGION_B) --filters "Name=state,Values=available" "Name=tag:Name,Values=$(GATEWAY_B_NAME)" $(PROJECT_TAGS) --output text --query 'TransitGateways[0].Options.AssociationDefaultRouteTableId')
#NAT Gateway
NAT_GW_A_ASSOCIATION_ID=$(shell aws ec2 describe-addresses --region $(REGION_A) --filters "Name=tag:Name,Values=$(NAT_GW_A_PUBLIC_IP_NAME)" --filters $(PROJECT_TAGS) --output text --query "Addresses[0].AllocationId")
NAT_GW_B_ASSOCIATION_ID=$(shell aws ec2 describe-addresses --region $(REGION_B) --filters "Name=tag:Name,Values=$(NAT_GW_B_PUBLIC_IP_NAME)" --filters $(PROJECT_TAGS) --output json --query "Addresses[0].AllocationId")

#VPC_A_RT_ID=$(shell 	aws ec2 describe-route-tables --filters "Name=vpc-id,Values=$(VPC_A_ID)" --query "RouteTables[0].RouteTableId" --output text)
VPC_A_RT_ID=$(shell	aws ec2 describe-route-tables --region $(REGION_A) --filters "Name=tag:Name,Values=$(ROUTE_TABLE_A_NAME)" $(PROJECT_TAGS) --query "RouteTables[0].RouteTableId" --output text)
VPC_B_RT_ID=$(shell	aws ec2 describe-route-tables --region $(REGION_B) --filters "Name=tag:Name,Values=$(ROUTE_TABLE_B_NAME)" $(PROJECT_TAGS) --query "RouteTables[0].RouteTableId" --output text)

VPC_A_DEFAULT_RT_ID=$(shell aws ec2 describe-route-tables --region $(REGION_A) --filters "Name=vpc-id,Values=$(VPC_A_ID)" "Name=association.main,Values=true" --query 'RouteTables[0].RouteTableId' --output text)
VPC_B_DEFAULT_RT_ID=$(shell aws ec2 describe-route-tables --region $(REGION_B) --filters "Name=vpc-id,Values=$(VPC_B_ID)" "Name=association.main,Values=true" --query 'RouteTables[0].RouteTableId' --output text)

# AccountID

AWS_ACCONT_ID=$(shell aws sts get-caller-identity --query 'Account' --output text)
# PEEERING ID
PEERING_ID_PENDING=$(shell aws ec2 describe-transit-gateway-peering-attachments --region $(REGION_A) --filters "Name=state,Values=pendingAcceptance" "Name=tag:Name,Values=$(PEERING_NAME)" $(PROJECT_TAGS) --output text --query 'TransitGatewayPeeringAttachments[0].TransitGatewayAttachmentId' )
PEERING_ID=$(shell aws ec2 describe-transit-gateway-peering-attachments --region $(REGION_A) --filters "Name=state,Values=available" "Name=tag:Name,Values=$(PEERING_NAME)" $(PROJECT_TAGS) --output text --query 'TransitGatewayPeeringAttachments[0].TransitGatewayAttachmentId' )
BASTION_A_ID=$(shell aws ec2 describe-instances --region $(REGION_A) --filters "Name=tag:Name,Values=$(BASTION_A_NAME)"  $(PROJECT_TAGS) --output text --query "Reservations[0].Instances[0].InstanceId" )
BASTION_B_ID=$(shell aws ec2 describe-instances --region $(REGION_B) --filters "Name=tag:Name,Values=$(BASTION_B_NAME)"  $(PROJECT_TAGS) --output text --query "Reservations[0].Instances[0].InstanceId" )
#"Name=state,Values=available"
#"Name=state,Values=available"
BASTION_A_SG=$(shell aws ec2 describe-instances  --region $(REGION_A) --instance-ids $(BASTION_A_ID) --filters $(PROJECT_TAGS) --query 'Reservations[].Instances[].SecurityGroups[].GroupId' --output text)
BASTION_B_SG=$(shell aws ec2 describe-instances  --region $(REGION_B) --instance-ids $(BASTION_B_ID) --filters $(PROJECT_TAGS) --query 'Reservations[].Instances[].SecurityGroups[].GroupId' --output text)


# Bastion IP
BASTION_A_PUBLIC_IP=$(shell aws ec2 describe-instances --instance-ids $(BASTION_A_ID) --region $(REGION_A)  --filters $(PROJECT_TAGS) --query "Reservations[0].Instances[0].PublicIpAddress"   --output json)
BASTION_B_PUBLIC_IP=$(shell aws ec2 describe-instances --instance-ids $(BASTION_B_ID) --region $(REGION_B)  --filters $(PROJECT_TAGS) --query "Reservations[0].Instances[0].PublicIpAddress"   --output json)
IGW_A_ID=$(shell aws ec2 describe-internet-gateways --filter "Name=tag:Name,Values=$(IGW_A_NAME)" $(PROJECT_TAGS)  --query "InternetGateways[0].InternetGatewayId" --region $(REGION_A) --output text )
IGW_B_ID=$(shell aws ec2 describe-internet-gateways --filter "Name=tag:Name,Values=$(IGW_B_NAME)" $(PROJECT_TAGS)  --query "InternetGateways[0].InternetGatewayId" --region $(REGION_B) --output text )
NAT_GW_A_ID=$(shell aws ec2 describe-nat-gateways --filter "Name=tag:Name,Values=$(NAT_GW_A_NAME)" $(PROJECT_TAGS) --query "NatGateways[0].NatGatewayId" --region $(REGION_A) --output text )
NAT_GW_B_ID=$(shell aws ec2 describe-nat-gateways --filter "Name=tag:Name,Values=$(NAT_GW_B_NAME)" $(PROJECT_TAGS) --query "NatGateways[0].NatGatewayId" --region $(REGION_B) --output text )

SECURITY_GROUP_A_ID = $(shell aws ec2 describe-security-groups --region $(REGION_A) --filters "Name=vpc-id,Values=$(VPC_A_ID)" "Name=group-name,Values=default"  --query "SecurityGroups[0].GroupId" --output text)
SECURITY_GROUP_B_ID = $(shell aws ec2 describe-security-groups --region $(REGION_B) --filters "Name=vpc-id,Values=$(VPC_B_ID)" "Name=group-name,Values=default"  --query "SecurityGroups[0].GroupId" --output text)

ESCAPE_JSON=sed ':a;N;$$!ba;s/ \+/ /g;s/\n/ /g;s|"|\"|g'



#export DELETE_ME=instana-core; kubectl get namespace ${DELETE_ME -o json | sed 's/"kubernetes"//' > /tmp/xxx.json
#kubectl replace --raw "/api/v1/namespaces/the-namespace-name/finalize" -f /tmp/xxx.json

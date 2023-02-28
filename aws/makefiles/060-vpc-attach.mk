
attach-vpc-2-gw-a:
	aws ec2 create-transit-gateway-vpc-attachment \
	--transit-gateway-id $(TRANSIT_GATEWAY_A_ID) \
	--vpc-id ${VPC_A_ID} \
	--subnet-ids ${VPC_A_SUBNET_A_ID} ${VPC_A_SUBNET_B_ID} ${VPC_A_SUBNET_C_ID} \
	--output text \
	--region ${REGION_A} \
	--query 'TransitGatewayVpcAttachment.TransitGatewayAttachmentId'>tmp.$(INSTANCE_FILE)
	aws ec2 create-tags --resources $$(cat tmp.${INSTANCE_FILE})  \
		--region ${REGION_A} \
	    --tags Key=Name,Value=$(ATTACHMENT_B_NAME) Key=Project,Value=$(PROJECT_NAME) Key=Rev,Value=$(PROJECT_REV)



attach-vpc-2-gw-b:
	aws ec2 create-transit-gateway-vpc-attachment \
	--transit-gateway-id $(TRANSIT_GATEWAY_B_ID) \
	--vpc-id ${VPC_B_ID} \
	--subnet-ids ${VPC_B_SUBNET_A_ID} ${VPC_B_SUBNET_B_ID} ${VPC_B_SUBNET_C_ID} \
	--output text \
	--region ${REGION_B} \
	--query 'TransitGatewayVpcAttachment.TransitGatewayAttachmentId'>tmp.$(INSTANCE_FILE)
	aws ec2 create-tags --resources $$(cat tmp.${INSTANCE_FILE})  \
		--region ${REGION_B} \
	    --tags Key=Name,Value=$(ATTACHMENT_B_NAME) Key=Project,Value=$(PROJECT_NAME) Key=Rev,Value=$(PROJECT_REV)

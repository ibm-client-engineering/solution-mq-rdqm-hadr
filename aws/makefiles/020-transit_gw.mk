transit-gateway-a:
	@-rm tmp.$(INSTANCE_FILE)
	aws ec2 create-transit-gateway \
	  --description "Transit Gateway for $(PROJECT_NAME).$(PROJECT_REV) VPC Peering" \
	  --options=AmazonSideAsn=64516,AutoAcceptSharedAttachments=enable \
	  --region ${REGION_A} \
	  --output text \
	  --query 'TransitGateway.TransitGatewayId' >tmp.$(INSTANCE_FILE)
	aws ec2 create-tags --resources $$(cat tmp.${INSTANCE_FILE})  \
		--region ${REGION_A} \
	    --tags Key=Name,Value=$(GATEWAY_A_NAME) Key=Project,Value=$(PROJECT_NAME) Key=Rev,Value=$(PROJECT_REV)

transit-gateway-b:
	@-rm tmp.$(INSTANCE_FILE)
	aws ec2 create-transit-gateway \
	  --description "Transit Gateway for $(PROJECT_NAME).$(PROJECT_REV) VPC Peering" \
	  --options=AmazonSideAsn=64516,AutoAcceptSharedAttachments=enable \
	  --output text \
	  --region ${REGION_B} \
	  --query 'TransitGateway.TransitGatewayId' >tmp.$(INSTANCE_FILE)
	aws ec2 create-tags --resources $$(cat tmp.${INSTANCE_FILE})  \
		--region ${REGION_B} \
	    --tags Key=Name,Value=$(GATEWAY_B_NAME) Key=Project,Value=$(PROJECT_NAME) Key=Rev,Value=$(PROJECT_REV)


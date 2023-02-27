

peering:
	aws ec2 create-transit-gateway-peering-attachment \
	  --transit-gateway-id $(TRANSIT_GATEWAY_A_ID) \
	  --peer-transit-gateway-id $(TRANSIT_GATEWAY_B_ID) \
	  --peer-account-id $(AWS_ACCONT_ID) \
	  --peer-region ${REGION_B} \
	  --region ${REGION_A} \
	  --output text \
	  --query 'TransitGatewayPeeringAttachment.TransitGatewayAttachmentId'	  >tmp.$(INSTANCE_FILE)
	aws ec2 create-tags --resources $$(cat tmp.${INSTANCE_FILE})  \
		--region ${REGION_A} \
	    --tags Key=Name,Value=$(PEERING_NAME) Key=Project,Value=$(PROJECT_NAME) Key=Rev,Value=$(PROJECT_REV)
  

accept-peering:
	aws ec2 accept-transit-gateway-peering-attachment \
	  --transit-gateway-attachment-id $(PEERING_ID_PENDING) \
	  --region $(REGION_B)



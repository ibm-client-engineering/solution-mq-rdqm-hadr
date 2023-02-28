peering-routes:
# ADD B ROUTE TO A
	aws ec2 create-transit-gateway-route --region $(REGION_A) --destination-cidr-block $(VPC_B_CIDR) --transit-gateway-route-table-id $(TRANSIT_GW_A_RT_ID) --transit-gateway-attachment-id $(PEERING_ID)
# ADD A ROUTE TO B
	aws ec2 create-transit-gateway-route --region $(REGION_B) --destination-cidr-block $(VPC_A_CIDR) --transit-gateway-route-table-id $(TRANSIT_GW_B_RT_ID) --transit-gateway-attachment-id $(PEERING_ID)


wait-for-peering:
	watch  $(TRANSIT_GW_A_RT_ID)
	

region-a-b-route:
	aws ec2 create-route  --route-table-id $(VPC_A_DEFAULT_RT_ID) \
	 --region $(REGION_A) \
  	 --destination-cidr-block $(VPC_B_CIDR) \
  	 --transit-gateway-id $(TRANSIT_GATEWAY_A_ID) \
  	 --output json
  

region-b-a-route:
	aws ec2 create-route  --route-table-id $(VPC_B_DEFAULT_RT_ID) \
	 --region $(REGION_B) \
  	 --destination-cidr-block $(VPC_A_CIDR) \
  	 --transit-gateway-id $(TRANSIT_GATEWAY_B_ID) \
  	 --output json
  

bastion-a-b-route:
	aws ec2 create-route  --route-table-id $(VPC_A_RT_ID) \
	 --region $(REGION_A) \
  	 --destination-cidr-block $(VPC_B_CIDR) \
  	 --transit-gateway-id $(TRANSIT_GATEWAY_A_ID) \
  	 --output json
  

bastion-b-a-route:
	aws ec2 create-route  --route-table-id $(VPC_B_RT_ID) \
	 --region $(REGION_B) \
  	 --destination-cidr-block $(VPC_A_CIDR) \
  	 --transit-gateway-id $(TRANSIT_GATEWAY_B_ID) \
  	 --output json

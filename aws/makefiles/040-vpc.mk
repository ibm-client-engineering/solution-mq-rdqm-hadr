

vpc-a:
	@echo "Creating VPC A"
	aws ec2 create-vpc \
	  --region $(REGION_A) \
	  --cidr-block $(VPC_A_CIDR) \
	  --query 'Vpc.VpcId' \
	  --tag-specifications 'ResourceType=vpc,Tags=[{Key=Name,Value=$(VPC_A_NAME)},$(DEFAULT_TAG_SPECS)]'
	  
#                     'ResourceType=security-group,Tags=[{Key=Name,Value=$(SECURITY_GROUP_A_NAME)},$(DEFAULT_TAG_SPECS)]'    
vpc-b:
	@echo "Creating VPC B"
	aws ec2 create-vpc \
	  --region $(REGION_B) \
	  --cidr-block $(VPC_B_CIDR) \
	  --query 'Vpc.VpcId' \
      --tag-specifications 'ResourceType=vpc,Tags=[{Key=Name,Value=$(VPC_B_NAME)},$(DEFAULT_TAG_SPECS)]' 
	                       

vpc: vpc-a vpc-b

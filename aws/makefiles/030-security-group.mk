security-group-a:
# create a security group
	aws ec2 create-security-group --group-name $(SECURITY_GROUP_A_NAME) \
	  --region $(REGION_A) \
	  --vpc-id $(VPC_A_ID) \
	  --description "$(PROJECT_NAME)-$(REV) security group" \
	  --query "GroupId" --output text  > tmp.$(INSTANCE_FILE)

	aws ec2 create-tags --resources $$(cat tmp.${INSTANCE_FILE})  \
		--region $(REGION_A) \
	    --tags Key=Name,Value=$(SECURITY_GROUP_A_NAME) Key=Project,Value=$(PROJECT_NAME) Key=Rev,Value=$(PROJECT_REV)

security-group-b:
# create a security group
	aws ec2 create-security-group --group-name $(SECURITY_GROUP_B_NAME) \
	  --region $(REGION_B) \
	  --vpc-id $(VPC_B_ID) \
	  --description "$(PROJECT_NAME)-$(REV) security group" \
	  --query "GroupId" --output text  > tmp.$(INSTANCE_FILE)

	aws ec2 create-tags --resources $$(cat tmp.${INSTANCE_FILE})  \
		--region $(REGION_B) \
	    --tags Key=Name,Value=$(SECURITY_GROUP_B_NAME) Key=Project,Value=$(PROJECT_NAME) Key=Rev,Value=$(PROJECT_REV)


security-group: security-group-a security-group-b

add-ssh-port-a:
	aws ec2 authorize-security-group-ingress \
		--region $(REGION_A) \
		--group-id $(SECURITY_GROUP_A_ID) \
		--protocol tcp \
		--port 22 \
		--cidr 0.0.0.0/0

add-ssh-port-b:
	aws ec2 authorize-security-group-ingress \
		--region $(REGION_B) \
		--group-id $(SECURITY_GROUP_B_ID) \
		--protocol tcp \
		--port 22 \
		--cidr 0.0.0.0/0

add-region-b-traffic-to-a:
	aws ec2 authorize-security-group-ingress \
		--region $(REGION_A) \
		--group-id $(SECURITY_GROUP_A_ID) \
		--protocol all \
		--port -1 \
		--cidr $(VPC_B_CIDR)

add-region-a-traffic-to-b:
	aws ec2 authorize-security-group-ingress \
		--region $(REGION_B) \
		--group-id $(SECURITY_GROUP_B_ID) \
		--protocol all \
		--port -1 \
		--cidr $(VPC_A_CIDR)



# Get the ID of the existing EC2 instance
INSTANCE_ID = $(shell aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" --query 'Reservations[0].Instances[0].InstanceId' --output text)

# Modify the security groups associated with the EC2 instance
MODIFY_SG = $(shell aws ec2 modify-instance-attribute --instance-id $(INSTANCE_ID) --groups $(SG_ID))

get_sg_a_id:
	echo $(SECURITY_GROUP_A_ID)
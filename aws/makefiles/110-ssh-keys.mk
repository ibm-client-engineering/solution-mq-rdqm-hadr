
generate-key-pair:
	rm $(PEM_FILE) -f
	aws ec2 create-key-pair \
	--region $(REGION_A) \
   	--key-name  $(KEY_NAME) \
   	--query 'KeyMaterial' --output text > $(PEM_FILE)
	chmod 600 $(PEM_FILE)

generate-public-key:
	ssh-keygen -y -f $(PEM_FILE) > $(PEM_FILE).pub

mqm-keypair:
	ssh-keygen -t rsa -f $(DATA_DIR)/ssh/mqm.id_rsa -N ''	

import-key-pair-region-b: generate-public-key
	aws ec2 import-key-pair --region $(REGION_B) --key-name $(KEY_NAME) --public-key-material fileb://$(DATA_DIR)/ssh/id.rsa.pub

key-pair:generate-key-pair generate-public-key import-key-pair-region-b



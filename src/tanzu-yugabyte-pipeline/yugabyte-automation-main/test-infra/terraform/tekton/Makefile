

apply:
	@terraform init
	@terraform apply  -var-file="vars.tfvars" 

destroy:
	@terraform destroy  -var-file="vars.tfvars" 

HOST=`terraform show -json | jq -r .values.outputs.ip.value`
ssh:
	@echo ${HOST}
	@ssh -i bootstrap_rsa "ubuntu@${HOST}"

containers:
	scp -i bootstrap_rsa ../../../containers.tar ubuntu@${HOST}:/home/ubuntu
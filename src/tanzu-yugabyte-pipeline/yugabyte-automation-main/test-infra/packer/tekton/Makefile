

dpl ?= prod.env
include $(dpl)
export $(shell sed 's/=.*//' $(dpl))


#clean:#
#	@cd output-vmware-iso; rm -v *


#gitlab requires login
#prepprod:
#	@ytt -f vendir-prod-ytt.yml \
#	> vendir.yml
#	@vendir sync
#	@cp vendor/launch.sh scripts/
#	@chmod 755 scripts/launch.sh

build:
	@echo "Applying packer build to aws-ubuntu-tekton.pkr.hcl ..."
	@packer build -force -var-file=variables.json aws-ubuntu-tekton.pkr.hcl
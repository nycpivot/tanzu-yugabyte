

dpl ?= ../prod.env
include $(dpl)
export $(shell sed 's/=.*//' $(dpl))

container_name=$(TANZU_IMAGE_NAME)
#REGISTRY_URL=projects.registry.vmware.com
#PROJECT_NAME=tanzu_isv_engineering
REGISTRY_URL=$(TANZU_AWS_ACCOUNT_ID).dkr.ecr.$(TANZU_AWS_REGION).amazonaws.com

prep:
	@ytt -f vendir-prod-ytt.yml --data-value=kubectl_version=v1.23.5 --data-value=helm_version=3.8.2 > vendir.yml
	@vendir sync

build: 
	@docker build  -t $(container_name) -f Dockerfile .


tag:
#	@docker tag $(container_name) $(REGISTRY_URL):$(REGISTRY_PORT)/$(PROJECT_NAME)/$(container_name)
#	@docker tag $(container_name) $(REGISTRY_URL)/$(PROJECT_NAME)/$(container_name)
	echo $(container_name) $(REGISTRY_URL)/$(container_name)
	@docker tag $(container_name) $(REGISTRY_URL)/$(container_name)
	
push: tag
#	@docker push $(REGISTRY_URL):$(REGISTRY_PORT)/$(PROJECT_NAME)/$(container_name)
#	@docker push $(REGISTRY_URL)/$(PROJECT_NAME)/$(container_name)
	@docker push $(REGISTRY_URL)/$(container_name)

all: prep build push
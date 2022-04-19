dpl ?= prod.env
include $(dpl)
export $(shell sed 's/=.*//' $(dpl))
VALUES=../values

generate:
#	@scripts/fill_template.sh
	-@rm -rf $(GENDIR)
	-@mkdir -p $(GENDIR)/base
#	-@mkdir -p $(GENDIR)/tkg14	
#	-@mkdir -p $(GENDIR)/tkg15

	@ytt -f $(VALUES)/secret.yaml -f templates/serviceaccounts/serviceaccount.yaml > $(GENDIR)/base/serviceaccount.yaml
	
	@ytt -f $(VALUES)/secret.yaml -f templates/secrets/yb-secret-ytt.yaml > $(GENDIR)/base/yb-secret.yaml
	@ytt -f $(VALUES)/secret.yaml -f templates/secrets/docker-secret-ytt.yaml > $(GENDIR)/base/docker-secret.yaml


apply:
	@kubectl apply -f generated/base/yb-secret.yaml -f generated/base/docker-secret.yaml  -f generated/base/serviceaccount.yaml

delete:
	@kubectl delete -f generated/base/serviceaccount.yaml -f generated/base/yb-secret.yaml -f generated/base/docker-secret.yaml 
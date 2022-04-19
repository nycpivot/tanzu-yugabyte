
dpl ?= prod.env
include $(dpl)
export $(shell sed 's/=.*//' $(dpl))


create:
	@scripts/aws_ecr.sh
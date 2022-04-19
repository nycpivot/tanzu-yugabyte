.PHONY: test-run

apply-test-run:
	kubectl apply -f tasks/setup.yaml -f test-run/pipeline.yaml -f test-run/pipeline-run.yaml

delete-test-run:
	kubectl delete -f test-run/pipeline-run.yaml -f test-run/pipeline.yaml -f tasks/setup.yaml 

apply-test-universe-run:
	kubectl apply -f tasks/setup-universe.yaml -f test-universe-run/pipeline.yaml -f test-universe-run/pipeline-run.yaml

delete-test-universe-run:
	kubectl delete -f test-universe-run/pipeline-run.yaml -f test-universe-run/pipeline.yaml -f tasks/setup-universe.yaml 

reset-cluster:
	kubectl apply -f tasks/reset.yaml -f test-universe-run/cluster-reset-run.yaml -f test-universe-run/pipeline-cluster-reset.yaml

pipelist:
	@tkn pipelinerun list

tasklist:
	@tkn tasks list


logs:
	kubectl logs create-yb-cluster-test-yb-cluster-pod

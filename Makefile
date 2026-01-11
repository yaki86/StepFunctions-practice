dev-init:
	cd terraform/envs/dev && terraform init

dev-plan:
	cd terraform/envs/dev && terraform init \
	&& terraform plan --parallelism=30

dev-apply:
	cd terraform/envs/dev && terraform init \
	&& terraform apply --parallelism=30

dev-apply-y:
	cd terraform/envs/dev && terraform init \
	&& terraform apply --auto-approve --parallelism=30
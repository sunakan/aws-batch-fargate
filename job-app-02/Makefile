################################################################################
# 変数
################################################################################
REPOSITORY_NAME := $(shell basename $(shell pwd))

################################################################################
# マクロ
################################################################################

################################################################################
# タスク
################################################################################
.PHONY: docker-build
docker-build:
	docker build ./ --tag $(REPOSITORY_NAME):latest

.PHONY: docker-run
docker-run:
	docker run --rm -it --mount type=bind,source=${HOME}/.aws/,target=/root/.aws/ $(REPOSITORY_NAME):latest 1000

.PHONY: ci
ci:
	$(eval AWS_REGION_NAME := ap-northeast-1)
	$(eval IMAGE_TAG := $(shell git rev-parse --short HEAD))
	$(eval AWS_ACCOUNT_ID := $(shell aws sts get-caller-identity --query 'Account' --output text))
	$(eval REPOSITORY_URI := $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION_NAME).amazonaws.com/$(REPOSITORY_NAME))
	@aws ecr get-login-password --region $(AWS_REGION_NAME) | docker login --username AWS --password-stdin $(REPOSITORY_URI)
	docker build ./ --tag $(REPOSITORY_NAME):latest
	docker image tag $(REPOSITORY_NAME):latest $(REPOSITORY_URI):$(IMAGE_TAG)----$(shell TZ=Asia/Tokyo && date +"%Y%m%dT%H%M_0900")
	docker push $(REPOSITORY_URI):$(IMAGE_TAG)----$(shell TZ=Asia/Tokyo && date +"%Y%m%dT%H%M_0900")
	docker image rm $(REPOSITORY_URI):$(IMAGE_TAG)----$(shell TZ=Asia/Tokyo && date +"%Y%m%dT%H%M_0900")

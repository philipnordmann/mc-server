.PHONY: all build remove create install publish

IMAGE_NAME = refractix/mc-server
IMAGE_TAG = latest

all: build remove create

build:
	@echo "building docker image"
	docker build -t ${IMAGE_NAME}:${IMAGE_TAG} . --build-arg MC_VERSION=${IMAGE_TAG}
	@echo "building done of ${IMAGE_NAME}:${IMAGE_TAG}"

remove:
	@echo "removing old container"
	-docker rm minecraft-server-${IMAGE_TAG}
	@echo "removed minecraft-server-${IMAGE_TAG}"

create:
	@echo "creating container"
	docker create \
		--name=minecraft-server-${IMAGE_TAG} \
		--mount 'type=bind,src=/mnt/data/docker/minecraft/data/,dst=/opt/minecraft/etc/' \
		-p 25565:25565 \
		${IMAGE_NAME}:${IMAGE_TAG}
	@echo "created minecraft-server-${IMAGE_TAG}"

install:
	@echo "installing systemd unit"
	-sudo systemctl stop docker-minecraft.service
	sed "s/##IMAGE_TAG##/${IMAGE_TAG}/g" docker-minecraft.service | sudo tee /etc/systemd/system/docker-minecraft.service
	@echo "created sytemd unit"
	sudo systemctl daemon-reload
	sudo systemctl enable docker-minecraft.service
	@echo "done installing"

publish:
	@echo "publishing image to https://hub.docker.com/r/${IMAGE_NAME}"
	docker push ${IMAGE_NAME}:${IMAGE_TAG}

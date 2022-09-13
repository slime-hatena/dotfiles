CONTAINER_NAME ?= slime-hatena_dotfiles

.PHONY: test
test:
	docker run --name $(CONTAINER_NAME) --env USER=root --rm -itd ubuntu:22.04 /bin/bash
	docker cp ./scripts/install.sh $(CONTAINER_NAME):/tmp/install.sh
	docker exec $(CONTAINER_NAME) apt-get update -y
	docker exec $(CONTAINER_NAME) apt-get install git curl -y
	docker exec $(CONTAINER_NAME) /tmp/install.sh
	docker stop $(CONTAINER_NAME)

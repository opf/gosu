REPOSITORY := openproject/gosu

setup:
	docker buildx create \
		--name container-builder \
		--driver docker-container \
		--bootstrap --use

release:
	docker buildx build --push \
		--platform linux/amd64,linux/arm64/v8,linux/ppc64le \
		-t $(REPOSITORY) .

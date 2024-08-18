VERSION=0.1
CONTAINER_NAME=eda_tools

build:
	docker build -t $(CONTAINER_NAME):$(VERSION) .

push: build
	docker push $(CONTAINER_NAME):$(VERSION) 

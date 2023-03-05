
CONTAINER = "filipfilmar/eda_tools:0.0"

build:
	docker build -t $(CONTAINER) .
.PHONY: build

push: build
	docker push $(CONTAINER)
.PHONY: push

run: build
	docker run -it $(CONTAINER) /bin/bash
.PHONY: run


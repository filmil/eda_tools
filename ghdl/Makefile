VERSION=0.1
CONTAINER_NAME=ghdl
USER=filipfilmar

build: build.stamp
.PHONY: build

build.stamp: Dockerfile Makefile
	docker build -t $(USER)/$(CONTAINER_NAME):$(VERSION) .
	touch $@

push: build.stamp
	docker push $(USER)/$(CONTAINER_NAME):$(VERSION) 

clean:
	rm -fr *.stamp

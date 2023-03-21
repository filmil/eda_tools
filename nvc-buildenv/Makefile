CONTAINER = "filipfilmar/nvc_buildenv:0.0"

UID := $(shell id -u)
GID := $(shell id -g)

UIDS := \
		-u $(UID):$(GID)
OPTS := \
		--interactive \
		--tty

build: build.stamp
.PHONY: build
build.stamp: Makefile copier.sh Dockerfile
	docker build -t $(CONTAINER) .
	touch $@

install.dir:
	mkdir -p $@

push: push.stamp
.PHONY: push
push.stamp: build.stamp
	docker push $(CONTAINER)
	touch $@

run: run.stamp
.PHONY: run
run.stamp: build.stamp install.dir
	docker run \
		$(UIDS) \
		$(OPTS) \
		-v $(PWD)/install.dir:/output:rw \
		$(CONTAINER) \
		/copier.sh
.PHONY: run.stamp

clean:
	rm -fr *.stamp
	rm -fr install.dir
.PHONY: clean

bash:
	docker run \
		$(OPTS) \
		-v $(PWD)/install.dir:/output:rw \
		$(CONTAINER) \
		/bin/bash
.PHONY: bash

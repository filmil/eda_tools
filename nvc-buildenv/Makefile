CONTAINER = "filipfilmar/nvc_buildenv:0.0"

build: build.stamp
.PHONY: build
build.stamp:
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
	docker run -it $(CONTAINER) \
		-v $(PWD)/install.dir:/output:rw \
		/copier.sh
	touch $@

clean:
	rm -fr *.stamp
.PHONY: clean

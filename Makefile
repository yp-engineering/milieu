# Copyright 2015 YP LLC.
# Use of this source code is governed by an MIT-style
# license that can be found in the LICENSE file.
IMAGE_PATH=ypengineering/milieu
TAG?=latest
IMAGE=$(IMAGE_PATH):$(TAG)
DOCKER_ARGS?=-p 8080:8080
SUDO?=

build: milieu
	$(SUDO) docker build -t $(IMAGE) .

milieu: milieu.go
	CGO_ENABLED=0 go build -x -a -installsuffix cgo -ldflags '-s' ./milieu.go

run:
	$(SUDO) docker run ${DOCKER_ARGS} --rm -it $(IMAGE) $(COMMAND)

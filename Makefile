# Copyright 2015 YP LLC.
# Use of this source code is governed by an MIT-style
# license that can be found in the LICENSE file.
NAME=milieu
IMAGE_PATH=ypengineering/$(NAME)
TAG?=latest
IMAGE=$(IMAGE_PATH):$(TAG)
DOCKER_ARGS?=-P --name $(NAME) -d

ifeq ($(SUDO),true)
	S=sudo
else
	S=
endif

build: $(NAME)
	$(S) docker build -t $(IMAGE) .

$(NAME): $(NAME).go
	CGO_ENABLED=0 go build -x -a -installsuffix cgo -ldflags '-s' ./$(NAME).go

run:
	$(S) docker run ${DOCKER_ARGS} $(IMAGE) $(COMMAND)

stop:
	$(S) docker stop $(NAME)

curl:
	curl 0:$$(docker inspect $(NAME) | grep HostPort | sed s/[^0-9]//g)

rm:
	$(S) docker rm $(NAME)

btp: build run curl stop rm
	git pull -r && git push

NS = kjbreil

REPO = pz-server

.PHONY: 

default: build push

build:
	docker build -t $(NS)/$(REPO) .

clean:
	docker build --no-cache -t $(NS)/$(REPO) .

shell:
	docker run --rm --name lgsm-test -it $(NS)/$(REPO) shell

run:
	docker run --rm --name lgsm-test $(NS)/$(REPO)

push:
	docker push $(NS)/$(REPO)


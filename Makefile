.PHONY=build

NAME=cm-alpine
HTTP_PORT=9090
SSL_PORT=9443
MUSIC_PATH=~/Music

all: build data run

backup:
	docker run --volumes-from $(NAME)-data -v $(shell pwd):/backup alpine tar cvzf /backup/backup.tar.gz /home/cm/{.local,.config}

build:
	docker build -t $(NAME) .

maintain:
	docker run --rm --volumes-from $(NAME)-data -it alpine-vim /bin/bash

data:
	docker create \
	--name $(NAME)-data \
	--volume /home/cm/.config/cherrymusic \
	--volume /home/cm/.local/cherrymusic \
	cm-alpine \
	sh -c "chown -R cm:cm /home/cm/.config /home/cm/.local"

run:
	docker run \
		--name $(NAME) \
		--publish $(HTTP_PORT):8080 \
		--publish $(SSL_PORT):8443 \
		--volumes-from cm-alpine-data \
		--volume $(MUSIC_PATH):/home/cm/Music \
		-it cm-alpine

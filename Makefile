version := $(shell git rev-list HEAD --count)

all:
	wget -O ./gamelist.txt https://gist.github.com/Rem01Gaming/02f2cf5c67119b361e6a6349392845bf/raw/gamelist.txt
	zip -r9 autopriority-$(version).zip * -x .* Makefile
	rm ./gamelist.txt

version := $(shell git rev-list HEAD --count)

all:
	wget -O ./autopriority/gamelist.txt https://gist.github.com/Rem01Gaming/02f2cf5c67119b361e6a6349392845bf/raw/gamelist.txt
	cp LICENSE ./autopriority
	zip -r9 autopriority-$(version).zip ./autopriority -x .* Makefile
	rm ./autopriority/gamelist.txt ./autopriority/LICENSE

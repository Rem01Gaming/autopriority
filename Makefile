version := $(shell git rev-list HEAD --count)

all:
	wget -O autopriority/gamelist.txt https://gist.github.com/Rem01Gaming/02f2cf5c67119b361e6a6349392845bf/raw/gamelist.txt
	bash ssc/ssc -u ./auto_priority.sh ./autopriority/auto_priority64
	zip -r9 autopriority-$(version).zip ./autopriority
	rm autopriority/gamelist.txt
	rm autopriority/auto_priority64


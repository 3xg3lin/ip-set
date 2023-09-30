PREFIX	:= /usr
CONFD	:= /etc

install:
	mkdir -p $(CONFD) $(PREFIX)/bin
	cp -v etc/ip-set.conf $(CONFD)

PREFIX ?= /usr/local
BINDIR = $(PREFIX)/bin
DATADIR = $(PREFIX)/share/nyanfetch

.PHONY: all install uninstall

all:
	@echo "Nothing to build. Run 'make install' to install."

install:
	install -d $(DESTDIR)$(BINDIR)
	install -d $(DESTDIR)$(DATADIR)
	install -m 0755 nyanfetch.sh $(DESTDIR)$(BINDIR)/nyanfetch
	install -m 0644 nyancat-1.ans $(DESTDIR)$(DATADIR)/
	install -m 0644 nyancat-2.ans $(DESTDIR)$(DATADIR)/
	install -m 0644 nyancat-3.ans $(DESTDIR)$(DATADIR)/
	install -m 0644 nyancat-4.ans $(DESTDIR)$(DATADIR)/
	install -m 0644 nyancat-5.ans $(DESTDIR)$(DATADIR)/
	install -m 0644 nyancat.wav $(DESTDIR)$(DATADIR)/

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/nyanfetch
	rm -rf $(DESTDIR)$(DATADIR)

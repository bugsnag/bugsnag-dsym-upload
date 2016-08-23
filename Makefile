PROJECT = bugsnag-dsym-upload
VERSION = $(shell cat VERSION)
BINDIR := '/usr/local/bin'
MANDIR := '/usr/local/man'
INSTALLCMD := install -C

$(BINDIR)/$(PROJECT): bin/$(PROJECT)
	@$(INSTALLCMD) bin/$(PROJECT) $@

$(MANDIR)/man1/$(PROJECT).1: man/$(PROJECT).pod
	@pod2man --center $(PROJECT) --release $(VERSION) man/$(PROJECT).pod > $@
	@chmod 444 $@

install: $(BINDIR)/$(PROJECT) $(MANDIR)/man1/$(PROJECT).1

uninstall:
	@rm $(BINDIR)/$(PROJECT) $(MANDIR)/man1/$(PROJECT).1

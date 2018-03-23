PROJECT = bugsnag-dsym-upload
VERSION = $(shell cat VERSION)
BINDIR := '/usr/local/bin'
MANDIR := '/usr/local/man'
INSTALLCMD := install -C
INSTALLDIRCMD := install -d

$(BINDIR)/$(PROJECT): bin/$(PROJECT)
	@$(INSTALLDIRCMD) $(BINDIR)
	@$(INSTALLCMD) bin/$(PROJECT) $@

$(MANDIR)/man1/$(PROJECT).1: man/$(PROJECT).pod
	@$(INSTALLDIRCMD) $(MANDIR)/man1
	@pod2man --center $(PROJECT) --release $(VERSION) man/$(PROJECT).pod > $@
	@chmod 444 $@

.PHONY: features

install: $(BINDIR)/$(PROJECT) $(MANDIR)/man1/$(PROJECT).1

uninstall:
	@rm $(BINDIR)/$(PROJECT) $(MANDIR)/man1/$(PROJECT).1

test:
	@cd tools/fastlane-plugin && bundle exec rake spec
	@bundle exec maze-runner

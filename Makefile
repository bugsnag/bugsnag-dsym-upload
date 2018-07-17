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

.PHONY: boostrap uninstall test test_unit test_features

install: $(BINDIR)/$(PROJECT) $(MANDIR)/man1/$(PROJECT).1

uninstall:
	@rm $(BINDIR)/$(PROJECT) $(MANDIR)/man1/$(PROJECT).1

bootstrap:
	@bundle install
	@cd tools/fastlane-plugin && bundle install

test_unit:
	@cd tools/fastlane-plugin && bundle exec rake spec

test_features:
	@bundle exec maze-runner -c features/*.feature

test: test_unit test_features

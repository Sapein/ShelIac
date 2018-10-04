.POSIX:

BINARY=/bin
DATA=/share
SHELIAC=$(DATA)/sheliac
CORE = $(SHELIAC)/core
PARSE = $(SHELIAC)/scripts
SCRIPTS = $(SHELIAC)/scripts
MODULES = $(SHELIAC)/modules
PMODULES = $(MODULES)/pModules
FMODULES = $(MODULES)/fModules
BIN_NAME = sheliac

PREFIX = /usr/local

clean:
	rm sheliac.sh.t

distclean: clean
fullclean: clean

install:
	mkdir -p $(DESTDIR)$(PREFIX)$(BINARY)
	mkdir -p $(DESTDIR)$(PREFIX)$(SHELIAC)
	mkdir -p $(DESTDIR)$(PREFIX)$(CORE)
	mkdir -p $(DESTDIR)$(PREFIX)$(PARSE)
	mkdir -p $(DESTDIR)$(PREFIX)$(SCRIPTS)
	mkdir -p $(DESTDIR)$(PREFIX)$(MODULES)
	mkdir -p $(DESTDIR)$(PREFIX)$(PMODULES)
	mkdir -p $(DESTDIR)$(PREFIX)$(FMODULES)
	chmod +x sheliac.sh
	chmod -R +x core/
	chmod -R +x modules/
	cp sheliac.sh sheliac.sh.t
	sed 's?core_location="core/"?core_location="'$(DESTDIR)$(PREFIX)$(CORE)'"?' sheliac.sh.t > sheliac.sh.te
	mv sheliac.sh.te sheliac.sh.t
	sed 's?shs_parse_location="./"?shs_parse_location="'$(DESTDIR)$(PREFIX)$(PARSE)'"?' sheliac.sh.t > sheliac.sh.te
	mv sheliac.sh.te sheliac.sh.t
	sed 's?shs_script_location="scripts/"?shs_script_location="'$(DESTDIR)$(PREFIX)$(SCRIPTS)'"?' sheliac.sh.t > sheliac.sh.te
	mv sheliac.sh.te sheliac.sh.t
	sed 's?pack_module_location="modules/pmodules"?pack_module_location="'$(DESTDIR)$(PREFIX)$(PMODULES)'"?' sheliac.sh.t > sheliac.sh.te
	mv sheliac.sh.te sheliac.sh.t
	sed 's?func_module_location="modules/fmodules"?func_module_location="'$(DESTDIR)$(PREFIX)$(FMODULES)'"?' sheliac.sh.t > sheliac.sh.te
	mv sheliac.sh.te sheliac.sh.t
	cp -f sheliac.sh.t $(DESTDIR)$(PREFIX)$(BINARY)/$(BIN_NAME)
	cp -f core/* $(DESTDIR)$(PREFIX)$(CORE)
	cp -f scripts/* $(DESTDIR)$(PREFIX)$(SCRIPTS)
	cp -f modules/pmodules/* $(DESTDIR)$(PREFIX)$(PMODULES)
	cp -f modules/fmodules/* $(DESTDIR)$(PREFIX)$(FMODULES)

remove:
	rm $(DESTDIR)$(PREFIX)$(BINARY)/$(BIN_NAME)
	rm $(DESTDIR)$(PREFIX)$(CORE)/*
	rm $(DESTDIR)$(PREFIX)$(PMODULES)/*
	rm $(DESTDIR)$(PREFIX)$(FMODULES)/*
	rmdir $(DESTDIR)$(PREFIX)$(PMODULES)
	rmdir $(DESTDIR)$(PREFIX)$(FMODULES)
	rmdir $(DESTDIR)$(PREFIX)$(MODULES)
	rmdir $(DESTDIR)$(PREFIX)$(SCRIPTS)
	rmdir $(DESTDIR)$(PREFIX)$(PARSE) || true
	rmdir $(DESTDIR)$(PREFIX)$(CORE)
	rmdir $(DESTDIR)$(PREFIX)$(SHELIAC)

uninstall: remove

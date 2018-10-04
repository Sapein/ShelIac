.POSIX:

BINARY=/bin
DATA=/share
SHELIAC=/sheliac
CORE = /core
PARSE = /scripts
SCRIPTS = /scripts
MODULES = /modules
PMODULES = /pModules
FMODULES = /fModules

PREFIX = /usr/local

clean:
	rm sheliac.sh.t

distclean: clean
fullclean: clean

install:
	mkdir -p $(DESTDIR)$(PREFIX)$(BINARY)
	mkdir -p $(DESTDIR)$(PREFIX)$(DATA)$(SHELIAC)
	mkdir -p $(DESTDIR)$(PREFIX)$(DATA)$(SHELIAC)$(CORE)
	mkdir -p $(DESTDIR)$(PREFIX)$(DATA)$(SHELIAC)$(PARSE)
	mkdir -p $(DESTDIR)$(PREFIX)$(DATA)$(SHELIAC)$(SCRIPTS)
	mkdir -p $(DESTDIR)$(PREFIX)$(DATA)$(SHELIAC)$(MODULES)
	mkdir -p $(DESTDIR)$(PREFIX)$(DATA)$(SHELIAC)$(MODULES)$(PMODULES)
	mkdir -p $(DESTDIR)$(PREFIX)$(DATA)$(SHELIAC)$(MODULES)$(FMODULES)
	chmod +x sheliac.sh
	chmod -R +x core/
	chmod -R +x modules/
	cp sheliac.sh sheliac.sh.t
	sed 's?core_location="core/"?core_location="'$(DESTDIR)$(PREFIX)$(DATA)$(SHELIAC)$(CORE)'"?' sheliac.sh.t > sheliac.sh.te
	mv sheliac.sh.te sheliac.sh.t
	sed 's?shs_parse_location="./"?shs_parse_location="'$(DESTDIR)$(PREFIX)$(DATA)$(SHELIAC)$(PARSE)'"?' sheliac.sh.t > sheliac.sh.te
	mv sheliac.sh.te sheliac.sh.t
	sed 's?shs_script_location="scripts/"?shs_script_location="'$(DESTDIR)$(PREFIX)$(DATA)$(SHELIAC)$(SCRIPT)'"?' sheliac.sh.t > sheliac.sh.te
	mv sheliac.sh.te sheliac.sh.t
	sed 's?pack_module_location="modules/pmodules"?pack_module_location="'$(DESTDIR)$(PREFIX)$(DATA)$(SHELIAC)$(MODULES)$(PMODULES)'"?' sheliac.sh.t > sheliac.sh.te
	mv sheliac.sh.te sheliac.sh.t
	sed 's?func_module_location="modules/fmodules"?func_module_location="'$(DESTDIR)$(PREFIX)$(DATA)$(SHELIAC)$(MODULES)$(FMODULES)'"?' sheliac.sh.t > sheliac.sh.te
	mv sheliac.sh.te sheliac.sh.t
	cp -f sheliac.sh.t $(DESTDIR)$(PREFIX)$(BINARY)$(SHELIAC)
	cp -f core/* $(DESTDIR)$(PREFIX)$(DATA)$(SHELIAC)$(CORE)
	cp -f scripts/* $(DESTDIR)$(PREFIX)$(DATA)$(SHELIAC)$(SCRIPTS)
	cp -f modules/pmodules/* $(DESTDIR)$(PREFIX)$(DATA)$(SHELIAC)$(MODULES)$(PMODULES)
	cp -f modules/fmodules/* $(DESTDIR)$(PREFIX)$(DATA)$(SHELIAC)$(MODULES)$(fMODULES)

remove:
	rm $(DESTDIR)$(PREFIX)$(BINARY)$(SHELIAC)
	rm $(DESTDIR)$(PREFIX)$(DATA)$(SHELIAC)$(CORE)/*
	rm $(DESTDIR)$(PREFIX)$(DATA)$(SHELIAC)$(SCRIPTS)/*
	rm $(DESTDIR)$(PREFIX)$(DATA)$(SHELIAC)$(MODULES)$(PMODULES)/*
	rm $(DESTDIR)$(PREFIX)$(DATA)$(SHELIAC)$(MODULES)$(FMODULES)/*
	rmdir $(DESTDIR)$(PREFIX)$(DATA)$(SHELIAC)$(MODULES)$(PMODULES)
	rmdir $(DESTDIR)$(PREFIX)$(DATA)$(SHELIAC)$(MODULES)$(FMODULES)
	rmdir $(DESTDIR)$(PREFIX)$(DATA)$(SHELIAC)$(MODULES)
	rmdir $(DESTDIR)$(PREFIX)$(DATA)$(SHELIAC)$(SCRIPTS)
	rmdir $(DESTDIR)$(PREFIX)$(DATA)$(SHELIAC)$(PARSE) || true
	rmdir $(DESTDIR)$(PREFIX)$(DATA)$(SHELIAC)$(CORE)
	rmdir $(DESTDIR)$(PREFIX)$(DATA)$(SHELIAC)

uninstall: remove

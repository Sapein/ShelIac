# Using Sheliac  
This document aims at a simple tutorial for explaining how to use ShelIaC, and how to write a very simple ShelIaC Script file.

### Table of Contents  
1. Setting up ShelIaC  
2. Addtional Documents  

### 1. Setting Up ShelIaC  
Setting up, and using, ShelIaC is relatively simple to do, after getting the source (which you can do, if you have git installed, with a simple `git clone https://git.sapeint.xyz/sapeint/shelliac.git`), you can use it right out of the box using ./sheliac, although it won't really do anything, beyond trying to run the exapmple script, and no output will occur.

However, to make things work properly the follwing steps need to be taken:  
1. Setup a location to put parsed files, for example `/home/bobby/.sheliac/parsed/`, by default it uses the current directory you are in.
2. Setup a location to put scripts, for example `/home/bobby/.sheliac/scripts/`, by default it uses `scripts/`, in the current directory.
3. Setup a location to put modules, for example, `/home/bobby/.sheliac/modules/`, you must create subdirectories for both pModules and fModules.
4. Setup a location to put the core, for example, `/home/bobby/.sheliac/core/`.
5. Edit the variables in sheliac.sh: `shs_parse_location`, `shs_script_location`, `pack_module_location`, `func_module_location`, and `core_location` to those locations

After that you will need to write some scripts. If you don't want to do the configuration manually, a Makefile is provided that will automagically set everything up. The following variables are provided to you by the Makefile to have control over where it installs (defaults are listed):
BINARY - Where the binary is located, by default it is set to `/bin`.
DATA - Where the sheliac folder is located, by default this is set to `/share`.
SHELIAC - The location where the core directories are kept (such as modules, scripts, and core), by default this is set to `$DATA/sheliac`.
CORE - The location where the core files are kept (such as fModule.sh), by default this is set to `$SHELIAC/core`.
PARSE - The location where files made while parsing are kept, by default this is set to `$SHELIAC/scripts`.
SCRIPTS - The location where scripts you write are kept, by default this is set to `$SHELIAC/scripts`.
MODULES - The location where the modules folders are kept, by default this is set to `$SHELIAC/modules`.
PMODULES - The location where Pack Modules are kept, by default this is set to `$MODULES/pModules`.
FMODULES - The location where Function Modules are kept, by default this is set to `$MODULES/fModules`.
BIN_NAME - The name of the sheliac.sh file upon 'installing', by default this is set to `sheliac`.

PREFIX - The location where most files are installed, by default this is set to `/usr/local`.
DESTDIR - An optional location to attach to PREFIX, by default this is not set.

### Additional Documents  
fModule Documentation: `docs/fmodule_API.md`
pModule Documentation: `docs/pmodule_API.md`
Sheliac Script Documentation: `docs/SheliacScript.md`

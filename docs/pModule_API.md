# pModule API Documentation
  With the Package Module system existing, and having an API that is somewhat stable, this document exists in order to provide an easier access to information for writing Package Modules.

### Table of Contents
1. pModule Variables
2. Functions

## pModule Variables  
  Unlike fModules, there is only one main variable when it comes to the pModule API: `Sheliac_pRetval`.

`Sheliac_pRetval` is the Return Variable for the pModule API, as such almost all data should be stored in here, this should never be read from, only be written to. It is not guarenteed to be set prior to usage in an pModule either.

## Functions  
  The pModule API requires that each pModule implement a set of functions that are used as entry-points that recieve certain variables. Unlike the fModule API, all functions defined here are required for creating a proper pModule. Since there exists no types for pModules, all functions are listed here. All functions must be prefixed with the filename of the module, followed by an underscore, and then by the name of the function. As such the general function format is `[module_filename]_[function_name]`.

Each Function is documented as follows `[function_name](arg1, arg2, ..., argN) -> Sheliac_pRetval:Type(Val); Returns:Type(val)`. If it takes no functions then no arguments are given. All arguments given are in the order they are passed in.

###### setup() -> Sheliac_pRetval:Nothing; Returns:0  
This function is called upon loading and returns nothing, takes nothing. It's purpose is to set the module up as required.

###### canRun(server) -> Sheliac_pRetval:Bool(0/1); Returns:0 
This function takes the a server (returned from the `Sheliac_Server` or the ShelIaC Script `server()` function) and then tests to see if the package manager (or program for installing something) exists on the target server.

This function sets `Sheliac_pRetval` to either 0 (success) or 1 (unable to run). The return value of the function, through the return command, is inconsequential. If it returns 0, then the module will be used, if it returns 1 then it won't be used. This function is called before an attempt to run an action (see `install()`, `update()` and `remove()`).

###### update(server, package_name) -> Sheliac_pRetval:Command(update command); Returns:0  
This function takes the server passed in and the package name, and then generates and returns the command to perform an update to a package. It sets Sheliac_pRetval to the command necessary to update the package (ex: `apt-get update gnu-smalltalk`). The return value is insignificant.

###### remove(server, package_name) -> Sheliac_pRetval:Command(remove command); Returns:0  
This function takes the server passed in and the package name, and then generates and returns the command to remove a package. It sets Sheliac_pRetval to the command necessary to remove the package (ex: `apt-get remove gnu-smalltalk`). The return value is insignificant.

###### install(server, package_name) -> Sheliac_pRetval:Command(install command); Returns:0  
This function takes the server passed in and the package name, and then generates and returns the command to install a package. It sets Sheliac_pRetval to the command necessary to install the package (ex: `apt-get install gnu-smalltalk`). The return value is insignificant.

This function takes the server passed in and the package name, and then generates and returns the command to install a package. It sets Sheliac_pRetval to the command necessary to install the package (ex: `apt-get install gnu-smalltalk`). The return value is insignificant.

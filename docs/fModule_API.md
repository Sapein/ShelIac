# fModule API Documentation
  With the Functionality Module system existing, and having an API that is somewhat stable, this document exists in order to provide an easier access to information for writing Functionality Modules.

### Table of Contents 
1. Types of fModules
2. fModule Variables
3. Functions

## Types of fModules  
  The fModule (Functionality Module) system for ShelIaC, exists to allow for the program to be extended further, either in the ShelIaC Script or in the connection to a remote server. As such, there are two main fModule types: Language and Connection extensions. 

Language Modules add new constructs to ShelIaC Script, and extend it, either by including new functionality or extending it. These are not currently entirely implemented, and as such they are not documented at this time. 

Connction Modules add new ways for ShelIaC to connect to an external server, such as SSH or Telnet. These are implemented and the main example is the ssh fModule.

## fModule Variables  
  There are two main variables when it comes to the fModule API: `Sheliac_fRetval` and `_Sheliac_fModule_Desc`. While these are, hopefully, self-explanitory, They are documented here.

`Sheliac_fRetval` is the Return Variable for the fModule API, as such almost all data should be stored in here, this should never be read from, only be written to. It is not guarenteed to be set prior to usage in an fModule either.

`_Sheliac_fModule_Desc` is a special, internal variable that is used by the fModule API to determine which type of fModule the module is. The default is set to "Conn", however _ALL_ Modules should set this either in the init function (See Section 3 - Functions) or should set it upon loading. This is a special variable that is only used upon the loading of a module, and is ignored otherwise.

## Functions  
  The fModule API requires that each fModule implements a set of functions that are called into and recieve certain variables. Some functions are only required for some fModules, as such this section is divided into three parts - non-typed, connection, and language functions. All functions must be prefixed with the filename of the module, followed by an underscore, and then the name of the function. as such the general function format is `[module_filename]_[function_name]`.

Each Function is documented as follows `[function_name](arg1, arg2, ..., argN) -> Sheliac_fRetval:Type(Val); Returns:Type(val)`. If it takes no functions then no arguments are given. All arguments given are in the order they are passed in.

#### Non-Typed Functions  
###### setup() -> Sheliac_fRetval:Nothing; Returns:0  
This function is called upon loading and returns nothing, takes nothing. It's purpose is to set the module up as required.

#### Connection Functions  
###### canConnect(server_address, port) -> Sheliac_fRetval:Bool(0/1); Returns:Bool(0/1)  
This function takes the server address (either an IP address or domain name) and a port, and then tests if the server can be connected to or not with the Connection Type. It may ignore the port in order to test a connection, if the connection can not be made without the port, it must attempt to connect with the port given. If no port is given, the port must be assumed to be 23.

This command sets Sheliac_fRetval to either 0 (success) or 1 (unable to connect). It also returns either a 0 or 1 with the return command. If it returns 0, then it notes that the port argument was ignored for the connection, if it returns 1, then the port argument was used. If Sheliac_fRetval is a failure, then other fModules will be tested, otherwise it will use that fModule instead.

###### connect(server, port) -> Sheliac_fRetval:Command(connection command); Returns:0  
This function takes the server address (either the IP address or domain name) and a port, and then makes the connection. This function follows the same rules regarding port as `canConnect()`. This function can call canConnect under the hood to do the port tests.

It sets Sheliac_fRetval to the command necessary to connect (ex: `ssh johnsmith@example.com`). The return value is insignificant.

###### configure(server, config_location, placement_location) -> Sheliac_fRetval:Command(configure command); Returns:0  
This function takes the server passed in, along with the configuration location and location to place the file, and then generates and returns the command to setup configuration for a package. 

It sets Sheliac_fRetval to the command necessary to install the configuration (ex `cat file | ssh adam@example.com "cat > file"`). The return value is insignificant.

#### Language Functions  
There are no Language Functions at this time.

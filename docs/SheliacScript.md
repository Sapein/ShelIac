#Sheliac Script

###Table of Contents 1. Introduction
2. Explanation of 'Core' vs Non-Core
3. Variables
4. Functions

###1. Introduction  
  ShelIaC Script is a scripting language for ShelIaC that is designed to be entirely declarative. It's built upon POSIX Shell/Bash and aims to provide a decent and easy way to create 'portable' scripts.

###2. Explanation of Core vs Non-Core  
  In this documentation, you will frequently hear 'Core' vs 'Non-Core'. Core functionality is functionality that is found in the ShelIaC Core scripts and is exclusively located in the parser. All built-ins are core, and variables are core. 

  This distinction exists, as the language itself can be extended relatively easily by Function Modules, meaning that some functionality won't be included in the core. However, it is included in included packages.

###3. Variables   
  Variables are relatively easy, the format for declaring them is as follows: 
```
[var_name] := [value] 
```
The spaces are optional, however please note that the `:=` is the assignment operator. If the `=` operator is used, then the parser will not notice it, and as such it will be ignored. 

**WARNING:** If you use `=` for a variable, an error will occur, and you won't be warned about it.

###4. Functions   
  ShellIaC does not support user-defined functions, at this time. However you call a function as follows: 
```
[function_name](arg1, arg2, ..., argn)
```

The following functions are built in, along with some documentation of it. 

######server(address, port=23) -> Server  
  args: address (string), port (integer. Default is 23). 
  returns: Server
  
  This function takes a string address and a port, and then returns a server object. This is required to setup a server to connect to. This Server Object is required for other functions.

######install(server, package) -> None  
  args: server (Server), package (string)  
  returns: Nothing

  This function takes a server object returned by server() and a package string. It then installs the package onto the server.  This will also update a package if possible. Nothing is returned.

######remove(server, package) -> None  
  args: server (Server), package (string)  
  returns: Nothing

  This function takes a server object returned by server() and a package string. It then removes the package from the server. Nothing is returned.

######update(server, package) -> None  
  args: server (Server), package (string)  
  returns: Nothing

  This function takes a server object returned by server() and a package string. It then updates the package on the server. Nothing is returned.

######configure(server, package, config_location, install_location) -> None  
  args: server (Server), package (string), config_location (string), install_location (string) 
  returns: Nothing

  This function takes a server object, returned by server(), a package string, a configuration location string, and an location to put the configuration script. This returns nothing.

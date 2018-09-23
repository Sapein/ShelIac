#ShelIaC
  ShelIaC (pronounced as shellac ( \shə-ˈlak\ )), is an attempt to write an Infrastructure as Code system in pure POSIX Shell. This makes it able to run on any system that has a POSIX userspace (POSIX.1-2017 XCU) with minimal effort.

###Requirements  
1. A POSIX Shell (bash, dash, ash, ect.)  
2. A POSIX Environment (Specifically: awk, sed, and cat)  
3. A 'detector' script for the target system (used for installation and management of packages)  

###How to Use  
1. Obtain a copy of ShelIaC and install it.  
2. Write a ShelIac Script File, and place it the proper location.  
3. Run `sheliac.sh`  

###Usage Notes  
- This program requires a POSIX envrionment to run, and uses several features that may not be available in older versions of utilities.
- Due to certain things being outside of POSIX, additional scripts are required to make this entirely work. These are Pack Modules (pModules) and Functionality Modules (fModules), these must be written in POSIX Shell for it to work.
- Pack Modules deal with packaging, as such if no Pack Module exists for your system, you have to write one. 
- Functionality Modules deal with functionality, primarily with connecting to remove hosts. 

###Project Goals  
Goals:  
- Be entirely compliant with POSIX.1-2017 in the 'core'  
- Be entirely modular, so that ShelIaC may be extended as needed.  
- Have ShelIaC Script (shs) be entirely declarative, with a small 'core'.  
- Have ShelIaC detect script changes in order to allow for servers to be changed by simply updating the shs file.

Non-Goals:
- Automatic Server Provisioning.
- Support Windows in core.

###Contributing  
See CONTRIBUTING for more information.

###Licensing and Copyright  
See the LICENSE file for more information. 

###QnA  
#####Why does this Exist?  
Simple, because I was bored and found no actual creation of something like this. Additionally, I figured that it would be interesting enough.

#####What's POSIX Shell?  
Simply, it's a Shell that is available on all POSIX systems, and implements with the POSIX standard.

#####So, is it Bash/zsh/[insert shell here]?  
Not entirely, Bash has extensions that isn't POSIX and something like zsh doesn't aim for POSIX compatability (although it apparently is decently compatable). 

#####Why even write this then?  
Well, first off, it constrains me a bit so it is an interesting mental exercise. Secondly, it's definitely a unqiue attempt, but people have written entire webservers in Bash. 

#####So is SSH/Telnet/APT/yum/[insert thing here] POSIX?  
Of course not, these aren't in the POSIX specification and thus they aren't handled in the core. All tools that are non-POSIX are handled in Modules (Package Modules and Function Modules) to separate the functionality from the core, although as a side-effect this makes extending ShelIaC easier to do, as you just need to write a Module that implements the functionality you want.

#####What's ShelIaC Script?  
It's a nice little declarative language that this uses. Yes, it actually is ran and understood by ShelIaC, and the implementation uses POSIX only as well (or is mostly in that state). 

#####How does ShelIaC Script work, and how is it parsed?  
Well, it's just a small declarative language that is then parsed and translated to POSIX Shell. After that, the script is ran in a subshell, getting the information back that it needs. 

Yes, ShelIaC Script is actually POSIX Shell, just nicer. 

#####Does this mean I can write in Bash/POSIX Shell instead?  
Theoretically, yes. I haven't tried it though, but it might work. This isn't entirely supported, but the way the parser works should allow for this.

Just keep in mind this will likely be broken at some point. 

#####Can I extend ShelIaC Script in POSIX Shell/Bash then?  
Yes and no. If you combine it with the above, you can theoretically do it. **HOWEVER** it is not supported at this time.

Eventually an interface to extend the language will be written, in order to allow for the 'core' language to remain small. 

#####How do I write ShelIaC Script then?  
See the documentation.

#####Why shouldn't I just use Ansible or another IaC platform?  
You probably should.

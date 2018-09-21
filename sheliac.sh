#!/bin/sh

set -eu
IFS=$'\n\t'
_CoreIFS="${IFS}"

shs_parse_location="./" #Where the files generated during ShellIaC Script go
shs_script_location="scripts/" #Where the scripts are stored

pack_module_location="modules/pmodules"
func_module_location="modules/fmodules"
core_location="core/"
. "${core_location}"/sheliac_core.sh
. "${core_location}"/pModule.sh
. "${core_location}"/fModule.sh

startup(){
    IFS=$':\n'
    for location in $pack_module_location
    do
        SheliacCore_AddpModuleLocation "$location"
    done
    for location in $func_module_location
    do
        SheliacCore_AddfModuleLocation "$location"
    done
    SheliacCore_LoadpModules
    SheliacCore_LoadfModules
    IFS="${_CoreIFS}"
}

get_scripts() {
    _SheliacScripts=""
    IFS=$':\n'
    for script in $(ls "${shs_script_location}")
    do
        SheliacCore_ScriptTranslate "${shs_script_location}" "${script}"
        _SheliacScripts="${_sh_output}:${_SheliacScripts}"
    done
}

run_scripts() {
    IFS=$':\n'
    for script in ${_SheliacScripts}
    do
        SheliacCore_ScriptRun "${script}"
        IFS=''
        eval "${SheliacCore_ReturnVal}"
    done
}

startup
get_scripts
if [ -z ${1+x} ]
then
    run_scripts
fi

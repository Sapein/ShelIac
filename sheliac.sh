#!/bin/sh

set -eu
_CoreIFS="${IFS}"
IFS=$'\n\t'

sheliac_location="./"
pack_module_location="modules/pmodules"
func_module_location="modules/fmodules"
core_location="core/"
. "${core_location}"/pModule.sh
. "${core_location}"/fModule.sh

startup(){
    IFS=$':\n\t'
    for location in $pack_module_location
    do
        SheliacCore_AddpModuleLocation "$location"
    done
    # for location in $func_module_location
    # do
    #     SheliacCore_AddfModuleLocation "$location"
    # done
    SheliacCore_LoadpModules
    # SheliacCore_LoadfModules
    IFS="${_CoreIFS}"
}

install() {
}


startup


#!/bin/sh

set -eu
IFS=$'\n\t'
_SheliacCore_pModuleIFS="${IFS}"

_SheliacCore_pModules=""
_SheliacCore_pModuleLocations=""

SheliacCore_AddpModuleLocation(){
    _SheliacCore_pModuleLocations="${_SheliacCore_pModuleLocations}":"$1"
    _SheliacCore_pModuleLocations=$(printf "$_SheliacCore_pModuleLocations" |  sed s/^://)
}

SheliacCore_ClearpModuleLocation(){
    _SheliacCore_pModuleLocations=$(printf "$_SheliacCore_pModuleLocations" | sed s/"$1"// | sed s/::/:/ | sed s/^:// | sed s/:$//)
}

SheliacCore_LoadpModules(){
    IFS=$':\n\t'
    for location in $_SheliacCore_pModuleLocations
    do
        for script in "$location"/*
        do
            . "$script"
            _SheliacCore_pModules="${_SheliacCore_pModules}":"${script}"
        done
    done
    IFS="${_SheliacCore_pModuleIFS}"
}

SheliacCore_GetpModules(){
    SheliacCore_ReturnVal="${_SheliacCore_pModules}"
}

SheliacCore_pModuleInstall(){
    server="$1"
    package="$2"
    IFS=$':\n\t'
    for module in $_SheliacCore_pModules
    do
        "${module}"_canrun "$server"
        if [ "$Sheliac_pRetval" -eq $(true) ]
        then
            "${module}"_install "${package}"
            if [ "$Sheliac_pRetval" == "" ]
            then
                "${module}"_update "${package}"
                if [ "${Sheliac_pRetval}" == "" ]
                then
                    SheliacCore_ReturnVal=""
                fi
            else
                SheliacCore_ReturnVal="${Sheliac_pRetval}"
            fi
            break
        fi
    done
    IFS="${_SheliacCore_pModuleIFS}"
}

SheliacCore_pModuleRemove(){
    server="$1"
    package="$2"
    IFS=$':\n\t'
    for module in $_SheliacCore_pModules
    do
        "${module}"_canrun "$server"
        if [ "$Sheliac_pRetval" -eq $(true) ]
        then
            "${module}"_remove "${package}"
            SheliacCore_ReturnVal="${Sheliac_pRetval}"
            break
        fi
    done
    IFS="${_SheliacCore_pModuleIFS}"
}

SheliacCore_pModuleUpdate(){
    server="$1"
    package="$2"
    IFS=$':\n\t'
    for module in $_SheliacCore_pModules
    do
        "${module}"_canrun "$server"
        if [ "$Sheliac_pRetval" -eq $(true) ]
        then
            "${module}"_update "${package}"
            SheliacCore_ReturnVal="${Sheliac_pRetval}"
            break
        fi
    done
    IFS="${_SheliacCore_pModuleIFS}"
}

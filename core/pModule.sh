#!/bin/sh

set -eu
IFS='\n\t'
_SheliacCore_pModuleIFS="${IFS}"

_SheliacCore_pModules=""
_SheliacCore_pModuleLocations=""

Sheliac_pRetval=""
SheliacCore_AddpModuleLocation(){
    _SheliacCore_pModuleLocations="$1":"${_SheliacCore_pModuleLocations}"
    _SheliacCore_pModuleLocations=$(printf "$_SheliacCore_pModuleLocations" |  sed s/^://)
}

SheliacCore_ClearpModuleLocation(){
    _SheliacCore_pModuleLocations=$(printf "$_SheliacCore_pModuleLocations" | sed s/"$1"// | sed s/::/:/ | sed s/^:// | sed s/:$//)
}

SheliacCore_LoadpModules(){
    IFS=':\n'
    for location in $_SheliacCore_pModuleLocations
    do
        for script in $(ls "${location}")
        do
            . "${location}"/"${script}"
            "${script}"_setup
            _SheliacCore_pModules="${script}":"${_SheliacCore_pModules}"
        done
    done
    IFS="${_SheliacCore_pModuleIFS}"
}

SheliacCore_GetpModules(){
    SheliacCore_ReturnVal="${_SheliacCore_pModules}"
}

SheliacCore_pModuleInstall(){
    SheliacCore_ReturnVal=""
    server="$1"
    package="$2"
    IFS=':\n'
    for module in $_SheliacCore_pModules
    do
        "${module}"_canRun "${server}"
        if [ "${Sheliac_pRetval}" = "0" ]
        then
            "${module}"_install "${server}" "${package}"
            if [ "$Sheliac_pRetval" = "" ]
            then
                "${module}"_update "${server}" "${package}"
                if [ "${Sheliac_pRetval}" = "" ]
                then
                    SheliacCore_ReturnVal=""
                fi
            else
                SheliacCore_ReturnVal="${Sheliac_pRetval}"
            fi
            break
        fi
    done
    if [ "${SheliacCore_ReturnVal}" = "" ]
    then
        printf "ERROR: No usable pModule found!\n" 1>&2
        exit 1
    fi
    IFS="${_SheliacCore_pModuleIFS}"
}

SheliacCore_pModuleRemove(){
    SheliacCore_ReturnVal=""
    server="$1"
    package="$2"
    IFS=':\n'
    for module in $_SheliacCore_pModules
    do
        "${module}"_canRun "$server"
        if [ "$Sheliac_pRetval" = "0" ]
        then
            "${module}"_remove "${server}" "${package}"
            SheliacCore_ReturnVal="${Sheliac_pRetval}"
            break
        else
            SheliacCore_ReturnVal=""
        fi
    done
    if [ "${SheliacCore_ReturnVal}" = "" ]
    then
        printf "ERROR: No usable pModule found!\n" 1>&2
        exit 1
    fi
    IFS="${_SheliacCore_pModuleIFS}"
}

SheliacCore_pModuleUpdate(){
    SheliacCore_ReturnVal=""
    server="$1"
    package="$2"
    IFS=':\n'
    for module in $_SheliacCore_pModules
    do
        "${module}"_canRun "$server"
        if [ "$Sheliac_pRetval" = "0" ]
        then
            "${module}"_update "${server}" "${package}"
            SheliacCore_ReturnVal="${Sheliac_pRetval}"
            break
        else
            SheliacCore_ReturnVal=""
        fi
    done
    if [ "${SheliacCore_ReturnVal}" = "" ]
    then
        printf "ERROR: No usable pModule found!\n" 1>&2
        exit 1
    fi
    IFS="${_SheliacCore_pModuleIFS}"
}

#/bin/sh

set -eu
IFS=$'\n\t'
_SheliacCore_fModuleIFS="${IFS}"

_SheliacCore_fModules_Lang=""
_SheliacCore_fModules_Conn=""
_SheliacCore_fModuleLocations=""

_SheliacCore_fModuleDesc="Conn"
SheliacCore_AddfModuleLocation(){
    _SheliacCore_fModuleLocations="${_SheliacCore_fModuleLocations}":"$1"
    _SheliacCore_fModuleLocations=$(printf "$_SheliacCore_fModuleLocations" |  sed s/^://)
}

SheliacCore_ClearfModuleLocation(){
    _SheliacCore_fModuleLocations=$(printf "$_SheliacCore_fModuleLocations" | sed s/"$1"// | sed s/::/:/ | sed s/^:// | sed s/:$//)
}

SheliacCore_LoadfModules(){
    IFS=$':\n'
    for location in $_SheliacCore_fModuleLocations
    do
        for script in $(ls "${location}")
        do
            . "${location}"/"${script}"
            "${script}"_setup

            if [ "${_SheliacCore_fModuleDesc}" = "Conn" ]
            then
                _SheliacCore_fModules_Conn="${script}":"${_SheliacCore_fModules_Conn}"
            elif [ "${_SheliacCore_fModuleDesc}" = "Lang" ]
            then
                _SheliacCore_fModules_Lang="${script}":"${_SheliacCore_fModules_Lang}"
            fi
        done
    done
    IFS="${_SheliacCore_fModuleIFS}"
}

SheliacCore_fModuleGetConnection() {
    server="$1"
    attempt_port="$2"
    conn="$3"
    ${conn}_connect "${server}" "${attempt_port}"
    SheliacCore_ReturnVal="${Sheliac_fRetval}"
}

SheliacCore_fModuleAttemptConnection() {
    server="$1"
    attempt_port="$2"
    IFS=$':\n'
    for fModule in $_SheliacCore_fModules_Conn
    do
        IFS=$''
        "${fModule}"_canConnect "${server}" "${attempt_port}"
        IFS=$':\n'
        if [ "$?" -eq 0 ]
        then
            SheliacCore_ReturnVal="${fModule}"
            return
        else
            continue
        fi
    done
    SheliacCore_ReturnVal=1
    IFS="${_SheliacCore_fModuleIFS}"
}

SheliacCore_GetfModules(){
    SheliacCore_ReturnVal="${_SheliacCore_fModules}"
}

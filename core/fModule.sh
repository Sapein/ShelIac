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
    IFS=$':\n\t'
    for location in $_SheliacCore_fModuleLocations
    do
        for script in $location
        do
            . "$script"
            "${script}"_setup
            if [ "${_SheliacCore_fModuleDesc}" == "Conn" ]
            then
                _SheliacCore_fModules_Conn="${_SheliacCore_fModules_Conn}":"${script}"
            elif [ "${_SheliacCore_fModuleDesc}" == "Lang" ]
            then
                _SheliacCore_fModules_Lang="${_SheliacCore_fModules_Lang}":"${script}"
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
    IFS=$':\n\t'
    for fModule in $_SheliacCore_fModules_Conn
    do
        "${fModule}"_canConnect "${server}" "${attempt_port}"
        if [ "${Sheliac_fRetval}" -eq $(true) ]
        then
            SheliacCore_ReturnVal="${fModule}"
            return
        else
            continue
        fi
    done
    SheliacCore_ReturnVal=0
    IFS="${_SheliacCore_fModuleIFS}"
}

SheliacCore_GetfModules(){
    SheliacCore_ReturnVal="${_SheliacCore_fModules}"
}

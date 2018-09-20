#/bin/sh

set -eu
IFS=$'\n\t'
_SheliacCore_fModuleIFS="${IFS}"

_SheliacCore_fModules=""
_SheliacCore_fModuleLocations=""

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
            _SheliacCore_fModules="${_SheliacCore_fModules}":"${script}"
        done
    done
    IFS="${_SheliacCore_fModuleIFS}"
}

SheliacCore_GetfModules(){
    SheliacCore_ReturnVal="${_SheliacCore_fModules}"
}

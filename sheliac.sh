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

$(false) || False="$?"
$(true) && True="$?"

_shs_norun="${False}"
_shs_cache="${False}"

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
    SheliacCore_ScriptSetup "${_shs_cache}"
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

parse_options() {
    OLD_IFS="${IFS}"
    unset $IFS
    case opt in $@
        -h|--help)
            printf "Usage: sheliac.sh [options]\n"
            printf " Options:\n"
            printf "  -c/--cache: Cache SHS files and do not re-parse them otherwise. (Default)\n"
            printf "  -n/--no_cache: Do not cache SHS files and reparse SHS files.\n"
            printf "  --no_run: Do not run the parsed SHS files\n"
            ;;
        -c|--cache)
            _shs_cache="${True}"
            ;;
        -n|--no_cache)
            _shs_cache="${False}"
            ;;
        --no_run)
            _shs_norun="${True}"
            ;;
    esac
}

parse_options "$@"
startup
get_scripts
if [ "${_shs_norun}" -ne "${True}" ]
then
    run_scripts
fi

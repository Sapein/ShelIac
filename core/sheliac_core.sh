#!/bin/sh

set -eu
_SheliacCore_CacheResults=""

SheliacCore_ReturnVal=""
_SheliacCore_fModuleConn=""
if [ -z ${shs_parse_location+x} ]; then shs_parse_location=""; fi
SheliacCore_Configure() {
    server="$1"
    package="$2"
    configure_location="$3"
    install_location="$4"
    SheliacCore_fModuleConfigure "$server" "$configure_location" "$install_location" "${_SheliacCore_fModuleConn}"
    printf "${SheliacCore_ReturnVal};"
}

SheliacCore_Server() {
    server_address="${1}"
    compare="${3:-"N"}"
    if [ "${compare}" != "N" ]
    then
        server_port="${2}"
        server_var="${3}"
    else
        server_port=23
        server_var="${2}"
    fi

    SheliacCore_fModuleAttemptConnection "${server_address}" "${server_port}"
    if [ "${SheliacCore_ReturnVal}" != "1" ]
    then
        SheliacCore_fModuleConn="${SheliacCore_ReturnVal}"
        SheliacCore_fModuleGetConnection "${server_address}" "${server_port}" "${SheliacCore_ReturnVal}"
        eval "${server_var}=\"${SheliacCore_ReturnVal}\""
    else
        printf "No Connection Available!\n" 1>&2
        exit 1
    fi
}

SheliacCore_Install() {
    server="$1"
    package="$2"
    SheliacCore_pModuleInstall "$server" "$package"
    printf "${SheliacCore_ReturnVal};"
}

SheliacCore_Remove() {
    server="$1"
    package="$2"
    SheliacCore_pModuleRemove "$server" "$package"
    printf "${SheliacCore_ReturnVal};"
}

SheliacCore_Update() {
    server="$1"
    package="$2"
    SheliacCore_pModuleUpdate "$server" "$package"
    printf "${SheliacCore_ReturnVal};"
}

SheliacCore_ScriptTranslate() {
    _script_path="$1"
    _script_name="$2"
    _var_file="${shs_parse_location}.${_script_name}.vars"
    _shs_copy="${shs_parse_location}.${_script_name}.cache.shs"
    _sh_trans="${shs_parse_location}.${_script_name}.sht"
    _sh_output="${shs_parse_location}.${_script_name}.sh"
    _temporary_file="${shs_parse_location}.${_script_name}.t"

    # Cache Check
    if [ -f "${_shs_copy}" ]
    then
        _new_ver=$(cat "${_script_path}"/"${_script_name}")
        _old_ver=$(cat "${_shs_copy}")
        if [ "${_new_ver}" = "${_old_ver}" ] && [ "${_SheliacCore_CacheResults}" -eq 0 ]
        then
            return 0;
        fi
        rm "${_shs_copy}"
    fi

    #Pre-Processing Phase
    cp "${_script_path}"/"${_script_name}" "${_shs_copy}"

    #Variable Collecting Phase
    awk '$0 ~ /:=/ { FS=":="; print $1; }' "${_shs_copy}" > "${_var_file}"
    sed 's/ $//' "${_var_file}" | awk '!seen[$0]++' > "${_temporary_file}.vars"
    mv "${_temporary_file}.vars" "${_var_file}"

    #Variable Whitespace Removal
    cp "${_shs_copy}" "${_sh_trans}"
    sed s/" :="/":="/ "${_shs_copy}" | sed s/":= "/":="/ > "${_sh_trans}"

    #Function Return Change Phase
    awk '{if(index($0,":=")==0 || index($0, ")")==0) {print $0;}}
         $0 ~ /:=/ && $0 ~ /)/ { split($0,vars,":="); sub(" ", "", vars[1]); sub(")", " \"" vars[1] "\")");
         sub(vars[1], vars[1] "=0\n"); sub(":=", ""); print $0; }' "${_sh_trans}" | sed 's/^ //'  > "${_temporary_file}.sht"
    mv "${_temporary_file}.sht" "${_sh_trans}"

    #POSIX Shell function translation
    sed 's/(/ /' "${_sh_trans}" | sed 's/)/ /' | sed s/" "$// > "${_temporary_file}.sht"
    mv "${_temporary_file}.sht" "${_sh_trans}"

    #Variable Translation Part 1
    A_IFS="${IFS:-'N'}"
    unset IFS
    for var in $(cat "${_var_file}")
    do
        sed 's/[^"=]'"${var}"'[^A-Za-z0-9_"]*/ "${'"${var}"'}" /' "${_sh_trans}" > "${_temporary_file}.sht"
        mv "${_temporary_file}.sht" "${_sh_trans}"
    done

    #Variable Translation Part 2 - Assignment References
    for var in $(cat "${_var_file}")
    do
        sed 's/:='"${var}"'[^A-Za-z0-9_]*/:="${'"${var}"'}"/' "${_sh_trans}" > "${_temporary_file}.sht"
        mv "${_temporary_file}.sht" "${_sh_trans}"
    done
    if [ "${A_IFS}" != "N" ]; then IFS="${A_IFS}"; fi

    #Translation to POSIX Shell Variable assignments
    sed 's/:=/=/g' "${_sh_trans}" > "${_temporary_file}.sht"
    mv "${_temporary_file}.sht" "${_sh_trans}"

    #Translate Built-Ins to the written counterparts
    sed 's/install/SheliacCore_Install/g' "${_sh_trans}" > "${_temporary_file}.sht"
    mv "${_temporary_file}.sht" "${_sh_trans}"

    sed 's/remove/SheliacCore_Remove/g' "${_sh_trans}" > "${_temporary_file}.sht"
    mv "${_temporary_file}.sht" "${_sh_trans}"

    sed 's/update/SheliacCore_Update/g' "${_sh_trans}" > "${_temporary_file}.sht"
    mv "${_temporary_file}.sht" "${_sh_trans}"

    sed 's/server/SheliacCore_Server/g' "${_sh_trans}" > "${_temporary_file}.sht"
    mv "${_temporary_file}.sht" "${_sh_trans}"

    sed 's/configure/SheliacCore_Configure/g' "${_sh_trans}" > "${_temporary_file}.sht"
    mv "${_temporary_file}.sht" "${_sh_trans}"

    #Turn to proper POSIX Shell file
    printf "#!/bin/sh\n" > "${_sh_output}"
    cat "${_sh_trans}" >> "${_sh_output}"
    chmod +x "${_sh_output}"

    #Cleanup
    rm "${_sh_trans}"
    rm "${_var_file}"
    $(exit "${_SheliacCore_CacheResults}") || rm "${_shs_copy}"

}

SheliacCore_ScriptRun() {
    script="$1"
    . "${script}" > .output
    SheliacCore_ReturnVal=$(cat .output)
    rm .output
}

SheliacCore_ScriptSetup() {
    _docache="$1"
    _SheliacCore_CacheResults="${_docache}"
    unset "_docache"
}

#!/bin/sh

set -eu

SheliacCore_Install() {
    server="$1"
    package="$2"
    SheliacCore_pModuleInstall "$server" "$package"
}

SheliacCore_Remove() {
    server="$1"
    package="$2"
    SheliacCore_pModuleRemove "$server" "$package"
}

SheliacCore_Update() {
    server="$1"
    package="$2"
    SheliacCore_pModuleUpdate "$server" "$package"
}

SheliacCore_ScriptTranslate() {
    _script_path="$1"
    _script_name="$2"
    _var_file=".${_script_name}.vars"
    _shs_copy=".${_script_name}.cache.shs"
    _sh_trans=".${_script_name}.sht"
    _sh_output=".${_script_name}.sh"
    _temporary_file=".${_script_name}.t"

    cp "${_script_path}" "${_shs_copy}"

    awk '$0 ~ /:=/ { FS=":="; print $1; }' "${_shs_copy}" > "${_var_file}"
    sed 's/ $//' "${_var_file}" | awk '!seen[$0]++' > "${_temporary_file}.vars"
    mv "${_temporary_file}.vars" "${_var_file}"

    cp "${_shs_copy}" "${_sh_trans}"
    sed s/" :="/":="/ "${_shs_copy}" | sed s/":= "/":="/ > "${_sh_trans}"

    awk '{if(index($0,":=")==0 || index($0, ")")==0) {print $0;}}
         $0 ~ /:=/ && $0 ~ /)/ { split($0,vars,":="); sub(" ", "", vars[1]); sub(")", " \"" vars[1] "\")");
         sub(vars[1], ""); sub(":=", ""); print $0; }' "${_sh_trans}" | sed 's/^ //'  > "${_temporary_file}.sht"
    mv "${_temporary_file}.sht" "${_sh_trans}"

    sed 's/(/ /' "${_sh_trans}" | sed 's/)/ /' | sed s/" "$// > "${_temporary_file}.sht"
    mv "${_temporary_file}.sht" "${_sh_trans}"

    A_IFS="${IFS:-'N'}"
    unset IFS
    for var in $(cat "${_var_file}")
    do
        sed 's/[^"=]'"${var}"'[^A-Za-z0-9_]*/ "${'"${var}"'}" /' "${_sh_trans}" > "${_temporary_file}.sht"
        mv "${_temporary_file}.sht" "${_sh_trans}"
    done

    for var in $(cat "${_var_file}")
    do
        sed 's/:='"${var}"'[^A-Za-z0-9_]*/:="${'"${var}"'}"/' "${_sh_trans}" > "${_temporary_file}.sht"
        mv "${_temporary_file}.sht" "${_sh_trans}"
    done
    if [ "${A_IFS}" != "N" ]; then IFS="${A_IFS}"; fi

    sed 's/:=/=/g' "${_sh_trans}" > "${_temporary_file}.sht"
    mv "${_temporary_file}.sht" "${_sh_trans}"

    # Do Built-in functions
    sed 's/install/SheliacCore_Install/g' "${_sh_trans}" > "${_temporary_file}.sht"
    mv "${_temporary_file}.sht" "${_sh_trans}"

    sed 's/remove/SheliacCore_Remove/g' "${_sh_trans}" > "${_temporary_file}.sht"
    mv "${_temporary_file}.sht" "${_sh_trans}"

    sed 's/update/SheliacCore_Update/g' "${_sh_trans}" > "${_temporary_file}.sht"
    mv "${_temporary_file}.sht" "${_sh_trans}"

    #Finish Translation
    printf "#!/bin/sh\n" > "${_sh_output}"
    cat "${_sh_trans}" >> "${_sh_output}"
    chmod +x "${_sh_output}"

    #Cleanup
    rm "${_shs_copy}"
    rm "${_sh_trans}"
    rm "${_var_file}"
}

SheliacCore_ScriptRun() {
    true
}

SheliacCore_ScriptTranslate "./test_script.shs" "test_script"

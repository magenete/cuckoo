#
# A desktop-oriented virtual machines management system written in Shell.
#
# Code is available online at https://github.com/magenete/cuckoo
# See LICENSE for licensing information, and README for details.
#
# Copyright (C) 2016 Magenete Systems OÜ.
#


# Delete CUCKOO_ARCH and CUCKOO_OS if empty
cuckoo_hd_recursive_delete_dir()
{
    if [ -d "${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}" ] && [ "${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}" != "$CUCKOO_HD_ARCH_OS_DIR" ] && [ ! -L "${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}" ]
    then
        local dv_dir="$(dirname "$CUCKOO_DIST_VERSION_DIR")"

        if [ "$dv_dir" != "." ] && [ "$dv_dir" != "/" ]
        then
            CUCKOO_DIST_VERSION_DIR="$dv_dir"

            cuckoo_hd_recursive_delete_dir
        fi
    fi

    if [ -z "$(ls "$CUCKOO_HD_ARCH_OS_DIR")" ]
    then
        rm -rf "$CUCKOO_HD_ARCH_OS_DIR"

        [ -z "$(ls "$CUCKOO_HD_ARCH_DIR")" ] && rm -rf "$CUCKOO_HD_ARCH_DIR"
    fi
}


# Export recursive find by directory
cuckoo_hd_recursive_export_find_files()
{
    for dir_file in $(ls "$1")
    do
        if [ -d "${1}${dir_file}" ] && [ ! -L "${1}${dir_file}" ]
        then
            cuckoo_hd_recursive_export_find_files "${1}${dir_file}/"
        else
            if [ -f "${1}/${dir_file}" ] && [ "$(basename "$dir_file" .config)" = "$dir_file" ]
            then
                cuckoo_dist_version_define_by_file_path "$cuckoo_hd_recursive_export_find_dir" "$1"

                cuckoo_dist_version_var_file_name

                CUCKOO_HD_DEFINE_FILE="${CUCKOO_OS}-${cuckoo_dist_version_env}-${cuckoo_dist_version}_${CUCKOO_ARCH}.tar.bz2"

                if [ -f "${CUCKOO_HD_FILE_PATH}${CUCKOO_HD_DEFINE_FILE}" ]
                then
                    continue
                else
                    tar -cvSj -f "${CUCKOO_HD_FILE_PATH}${CUCKOO_HD_DEFINE_FILE}" -C "$1" .
                fi
            fi
        fi
    done
}


# Export recursive file(s)
cuckoo_hd_recursive_export()
{
    cuckoo_hd_recursive_export_find_dir="$1"

    cuckoo_hd_recursive_export_find_files "$1"
}


# HD create
cuckoo_hd_create()
{
    if [ -d "$CUCKOO_HD_ARCH_OS_CLEAN_DIR" ]
    then
        for hd_file in $(ls "${CUCKOO_HD_ARCH_OS_CLEAN_DIR}")
        do
            if [ -f "${CUCKOO_HD_ARCH_OS_CLEAN_DIR}${hd_file}" ]
            then
                mkdir -p "${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}"

                cp "${CUCKOO_HD_ARCH_OS_CLEAN_DIR}${hd_file}" "${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}${hd_file}"
                if [ $? -gt 0 ]
                then
                    cuckoo_error "HD file was not created from '${CUCKOO_HD_ARCH_OS_CLEAN_DIR}${hd_file}' to '${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}${hd_file}'"
                fi
            fi
        done
    else
        cuckoo_error "Directory '${CUCKOO_HD_ARCH_OS_CLEAN_DIR}' does not exist"
    fi
}


# HD tar file import or download
cuckoo_hd_import_or_download()
{
    CUCKOO_ENV_NO="yes"

    cuckoo_variables

    local cuckoo_hd_dir_sys_path="${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}"

    mkdir -p "$cuckoo_hd_dir_sys_path"

    if [ -z "$CUCKOO_HD_FILE_NET" ]
    then
        if [ -f "$CUCKOO_HD_FILE_PATH" ]
        then
            tar -jvx -f "$CUCKOO_HD_FILE_PATH" -C "$cuckoo_hd_dir_sys_path"
        else
            for hd_file in $(ls "$CUCKOO_HD_FILE_PATH")
            do
                if [ -f "${CUCKOO_HD_FILE_PATH}/${hd_file}" ]
                then
                    cp -v "${CUCKOO_HD_FILE_PATH}/${hd_file}" "${cuckoo_hd_dir_sys_path}${hd_file}"
                fi
            done
        fi
    else
        curl -SL "$CUCKOO_HD_FILE_PATH" | tar -jvx -C "$cuckoo_hd_dir_sys_path"
    fi
    if [ $? -gt 0 ]
    then
        cuckoo_error "HD file was not set from '$CUCKOO_HD_FILE_PATH' to '${cuckoo_hd_dir_sys_path}'"
    fi

    chmod 0600 "$cuckoo_hd_dir_sys_path"*

    cuckoo_message "HD tar file was set in '${cuckoo_hd_dir_sys_path}'"
}


# Export file(s)
cuckoo_hd_export()
{
    CUCKOO_ENV_NO="yes"

    echo ""
    if [ -z "$CUCKOO_DIST_VERSION" ]
    then
        for cuckoo_arch in $CUCKOO_ACTION_ARCH_LIST
        do
            for cuckoo_os in $CUCKOO_ACTION_OS_LIST
            do
                CUCKOO_OS="$cuckoo_os"
                CUCKOO_ARCH="$cuckoo_arch"

                cuckoo_variables

                if [ -d "$CUCKOO_HD_ARCH_OS_DIR" ]
                then
                    cuckoo_hd_recursive_export "${CUCKOO_HD_ARCH_OS_DIR}"

                    echo "HD file(s) exported in '${CUCKOO_HD_ARCH_OS_DIR}'"
                else
                    echo "WARNING: HD file(s) not exported for OS: ${CUCKOO_OS}, arch: ${CUCKOO_ARCH}"
                fi
            done
        done
    else
        CUCKOO_ARCH="$CUCKOO_ACTION_ARCH_LIST"
        CUCKOO_OS="$CUCKOO_ACTION_OS_LIST"

        cuckoo_variables

        if [ -d "${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}" ]
        then
            cuckoo_dist_version_env="$CUCKOO_DIST_VERSION"

            cuckoo_hd_recursive_export "${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}"

            echo ""
            echo "HD file(s) exported from '${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}' to '${CUCKOO_HD_FILE_PATH}'"
        else
            echo "WARNING: HD file(s) '${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}' not exported"
        fi
    fi
    echo ""
}


# HD list
cuckoo_hd_list()
{
    CUCKOO_ENV_NO="yes"

    echo ""
    for cuckoo_arch in $CUCKOO_ACTION_ARCH_LIST
    do
        for cuckoo_os in $CUCKOO_ACTION_OS_LIST
        do
            CUCKOO_ARCH="$cuckoo_arch"
            CUCKOO_OS="$cuckoo_os"

            cuckoo_dist_version="$CUCKOO_DIST_VERSION"

            cuckoo_variables

            if [ -z "$cuckoo_dist_version" ]
            then
                CUCKOO_DIST_VERSION=""
                CUCKOO_DIST_VERSION_DIR=""
            fi

            if [ -d "${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}" ]
            then
                echo "HD file(s) found in '${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}':"

                for hd_file in $(ls -R -h -x --file-type "${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}" 2> /dev/null)
                do
                    echo "    $hd_file"
                done

                echo ""
            else
                echo "WARNING: HD file(s) not found for OS: ${CUCKOO_OS}, arch: ${CUCKOO_ARCH}"
                echo ""
            fi
        done
    done
}


# HD delete
cuckoo_hd_delete()
{
    CUCKOO_ENV_NO="yes"

    echo ""
    if [ -z "$CUCKOO_DIST_VERSION" ]
    then
        for cuckoo_arch in $CUCKOO_ACTION_ARCH_LIST
        do
            for cuckoo_os in $CUCKOO_ACTION_OS_LIST
            do
                CUCKOO_OS="$cuckoo_os"
                CUCKOO_ARCH="$cuckoo_arch"

                cuckoo_variables

                if [ -d "$CUCKOO_HD_ARCH_OS_DIR" ]
                then
                    rm -rf "$CUCKOO_HD_ARCH_OS_DIR"*

                    echo "HD deleted in directory '${CUCKOO_HD_ARCH_OS_DIR}'"

                    cuckoo_hd_recursive_delete_dir
                else
                    echo "WARNING: HD not deleted for OS: ${CUCKOO_OS}, arch: ${CUCKOO_ARCH}"
                fi
            done
        done
    else
        CUCKOO_ARCH="$CUCKOO_ACTION_ARCH_LIST"
        CUCKOO_OS="$CUCKOO_ACTION_OS_LIST"

        cuckoo_variables

        if [ -d "${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}" ]
        then
            rm -rf "${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}"*

            if [ -f "${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_CONFIG_FILE}" ]
            then
                cuckoo_dist_version_config_delete
            fi

            echo "HD deleted in directory '${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}'"

            cuckoo_hd_recursive_delete_dir
        else
            echo "WARNING: HD deleted in directory '${CUCKOO_HD_ARCH_OS_DIR}'"
        fi
    fi
    echo ""
}

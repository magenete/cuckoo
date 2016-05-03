#
# A desktop-oriented virtual machines management system written in Shell.
#
# Code is available online at https://github.com/magenete/cuckoo
# See LICENSE for licensing information, and README for details.
#
# Copyright (C) 2016 Magenete Systems OÜ.
#


# Delete CUCKOO_ARCH and CUCKOO_OS if empty
cuckoo_iso_recursive_delete_dir()
{
    if [ -d "${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}" ] && [ "${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}" != "$CUCKOO_ISO_ARCH_OS_DIR" ] && [ ! -L "${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}" ]
    then
        local dv_dir="$(dirname "$CUCKOO_DIST_VERSION_DIR")"

        if [ "$dv_dir" != "." ] && [ "$dv_dir" != "/" ]
        then
            CUCKOO_DIST_VERSION_DIR="$dv_dir"

            cuckoo_iso_recursive_delete_dir
        fi
    fi

    if [ -z "$(ls "$CUCKOO_ISO_ARCH_OS_DIR")" ]
    then
        rm -rf "$CUCKOO_ISO_ARCH_OS_DIR"

        [ -z "$(ls "$CUCKOO_ISO_ARCH_DIR")" ] && rm -rf "$CUCKOO_ISO_ARCH_DIR"
    fi
}


# Export recursive find by directory
cuckoo_iso_recursive_export_find_files()
{
    for dir_file in $(ls "$1")
    do
        if [ -d "${1}${dir_file}" ] && [ ! -L "${1}${dir_file}" ]
        then
            cuckoo_iso_recursive_export_find_files "${1}${dir_file}/"
        else
            cuckoo_dist_version_define_by_file_path "$cuckoo_iso_recursive_export_find_dir" "${1}/$(basename "$dir_file" .iso)"
            cuckoo_iso_define_file_name

            cp -v "${1}${dir_file}" "${CUCKOO_ISO_FILE_PATH}${CUCKOO_ISO_DEFINE_FILE}"
        fi
    done
}


# Export recursive file(s)
cuckoo_iso_recursive_export()
{
    cuckoo_iso_recursive_export_find_dir="$1"

    cuckoo_iso_recursive_export_find_files "$1"
}


# Define file name
cuckoo_iso_define_file_name()
{
    cuckoo_dist_version_var_file_name

    if [ -z "$cuckoo_dist_version_env" ]
    then
        CUCKOO_ISO_DEFINE_FILE="${CUCKOO_OS}-${cuckoo_dist_version}${cuckoo_version_basename}_${CUCKOO_ARCH}.iso"
    else
        CUCKOO_ISO_DEFINE_FILE="${CUCKOO_OS}-${cuckoo_dist_version_env}-${cuckoo_dist_version}_${CUCKOO_ARCH}.iso"
    fi
}


# Import or download file
cuckoo_iso_import_or_download()
{
    CUCKOO_ENV_NO="yes"

    cuckoo_variables

    CUCKOO_ISO_FILE_SYS_PATH="${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_ISO_FILE}"
    CUCKOO_ISO_FILE_DIR="$(dirname "$CUCKOO_ISO_FILE_SYS_PATH")/"
    CUCKOO_ISO_FILE="$(basename "$CUCKOO_ISO_FILE_SYS_PATH")"

    mkdir -p "${CUCKOO_ISO_FILE_DIR}"

    if [ -z "$CUCKOO_ISO_FILE_NET" ]
    then
        cp -f "$CUCKOO_ISO_FILE_PATH" "$CUCKOO_ISO_FILE_SYS_PATH"
    else
        curl -SL -o "$CUCKOO_ISO_FILE_SYS_PATH" "$CUCKOO_ISO_FILE_PATH"
    fi
    if [ $? -gt 0 ]
    then
        cuckoo_error "ISO file was not set from '$CUCKOO_ISO_FILE_PATH' to '${CUCKOO_ISO_FILE_SYS_PATH}'"
    fi

    chmod 0600 "$CUCKOO_ISO_FILE_SYS_PATH"

    cuckoo_message "ISO file was set as '${CUCKOO_ISO_FILE_SYS_PATH}'"
}


# Export file(s)
cuckoo_iso_export()
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

                if [ -d "$CUCKOO_ISO_ARCH_OS_DIR" ]
                then
                    cuckoo_iso_recursive_export "${CUCKOO_ISO_ARCH_OS_DIR}"

                    echo "ISO file(s) exported in '${CUCKOO_ISO_ARCH_OS_DIR}'"
                else
                    echo "WARNING: ISO file(s) not exported for OS: ${CUCKOO_OS}, arch: ${CUCKOO_ARCH}"
                fi
            done
        done
    else
        CUCKOO_ARCH="$CUCKOO_ACTION_ARCH_LIST"
        CUCKOO_OS="$CUCKOO_ACTION_OS_LIST"

        cuckoo_variables

        if [ -d "${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}" ]
        then
            cuckoo_dist_version_env="$CUCKOO_DIST_VERSION"

            cuckoo_iso_recursive_export "${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}"

            echo ""
            echo "ISO file(s) exported from '${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}' to '${CUCKOO_ISO_FILE_PATH}${CUCKOO_DIST_VERSION_DIR}'"
        else
            if [ -f "${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_ISO_FILE}" ]
            then
                cuckoo_iso_define_file_name

                cp -v "${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_ISO_FILE}" "${CUCKOO_ISO_FILE_PATH}${CUCKOO_ISO_DEFINE_FILE}"

                echo "ISO file '${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_ISO_FILE}' was exported"
            else
                echo "WARNING: ISO file '${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_ISO_FILE}' was not exported"
            fi
        fi
    fi
    echo ""
}


# ISO delete
cuckoo_iso_delete()
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

                if [ -d "$CUCKOO_ISO_ARCH_OS_DIR" ]
                then
                    rm -rf "$CUCKOO_ISO_ARCH_OS_DIR"*

                    echo "ISO file(s) deleted in '${CUCKOO_ISO_ARCH_OS_DIR}'"

                    cuckoo_iso_recursive_delete_dir
                else
                    echo "WARNING: ISO file(s) not deleted for OS: ${CUCKOO_OS}, arch: ${CUCKOO_ARCH}"
                fi
            done
        done
    else
        CUCKOO_ARCH="$CUCKOO_ACTION_ARCH_LIST"
        CUCKOO_OS="$CUCKOO_ACTION_OS_LIST"

        cuckoo_variables

        if [ -f "${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_ISO_FILE}" ]
        then
            rm -f "${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_ISO_FILE}"

            local dv_dir="$(dirname "$CUCKOO_DIST_VERSION_DIR")"

            if [ "$dv_dir" != "." ] && [ "$dv_dir" != "/" ]
            then
                CUCKOO_DIST_VERSION_DIR="$dv_dir"
            fi

            echo "ISO file '${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_ISO_FILE}' was deleted"

            cuckoo_iso_recursive_delete_dir
        else
            if [ -d "${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}" ]
            then
                cuckoo_iso_recursive_delete_dir

                echo "ISO file(s) deleted in '${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}'"
            else
                    echo "WARNING: ISO file '${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_ISO_FILE}' was not deleted"
            fi
        fi
    fi
    echo ""
}


# ISO list
cuckoo_iso_list()
{
    CUCKOO_ENV_NO="yes"

    echo ""
    for cuckoo_arch in $CUCKOO_ACTION_ARCH_LIST
    do
        for cuckoo_os in $CUCKOO_ACTION_OS_LIST
        do
            CUCKOO_OS="$cuckoo_os"
            CUCKOO_ARCH="$cuckoo_arch"

            cuckoo_dist_version="$CUCKOO_DIST_VERSION"

            cuckoo_variables

            if [ -z "$cuckoo_dist_version" ]
            then
                CUCKOO_DIST_VERSION=""
                CUCKOO_DIST_VERSION_DIR=""
            fi

            if [ -d "${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}" ]
            then
                echo "ISO file(s) found in '${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}':"

                for iso_file in $(ls -R -h -x --file-type "${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}" 2> /dev/null)
                do
                    echo "    $iso_file"
                done

                echo ""
            else
                echo "WARNING: ISO file(s) not found for OS: ${CUCKOO_OS}, arch: ${CUCKOO_ARCH}"
                echo ""
            fi
        done
    done
}

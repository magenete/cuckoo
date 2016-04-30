#
# A desktop-oriented virtual machines management system written in Shell.
#
# Code is available online at https://github.com/magenete/cuckoo
# See LICENSE for licensing information, and README for details.
#
# Copyright (C) 2016 Magenete Systems OÜ.
#


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
                    cuckoo_error "HD file has not been created from '${CUCKOO_HD_ARCH_OS_CLEAN_DIR}${hd_file}' to '${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}${hd_file}'"
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

    CUCKOO_HD_DIR_SYS_PATH="${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}"

    mkdir -p "${CUCKOO_HD_DIR_SYS_PATH}"

    if [ -z "$CUCKOO_HD_FILE_NET" ]
    then
        tar -jvx -f "$CUCKOO_HD_FILE_PATH" -C "$CUCKOO_HD_DIR_SYS_PATH"
    else
        curl -SL "$CUCKOO_HD_FILE_PATH" | tar -jvx -C "$CUCKOO_HD_DIR_SYS_PATH"
    fi
    if [ $? -gt 0 ]
    then
        cuckoo_error "HD file has not been setuped from '$CUCKOO_HD_FILE_PATH' to '${CUCKOO_HD_DIR_SYS_PATH}'"
    fi

    chmod 0600 "$CUCKOO_HD_DIR_SYS_PATH"*

    cuckoo_message "HD tar file has been setuped in '${CUCKOO_HD_DIR_SYS_PATH}'"
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
                echo "HD file(s) has been found in '${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}':"

                for hd_file in $(ls -R -h -x --file-type "${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}" 2> /dev/null)
                do
                    echo "    $hd_file"
                done

                echo ""
            else
                echo "WARNING: HD file(s) has not been found for OS: ${CUCKOO_OS}, arch: ${CUCKOO_ARCH}"
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

                    echo "HD has been deleted in directory '${CUCKOO_HD_ARCH_OS_DIR}'"
                else
                    echo "WARNING: HD has not been deleted for OS: ${CUCKOO_OS}, arch: ${CUCKOO_ARCH}"
                fi
            done
        done
    else
        CUCKOO_ARCH="$CUCKOO_ACTION_ARCH_LIST"
        CUCKOO_OS="$CUCKOO_ACTION_OS_LIST"

        cuckoo_variables

        if [ -d "${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}" ]
        then
            rm -rf "${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}"
            cuckoo_dist_version_config_delete

            echo "HD has been deleted in directory '${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}'"
        else
            if [ -f "${CUCKOO_HD_ARCH_OS_DIR}" ]
            then
                rm -f "${CUCKOO_HD_ARCH_OS_DIR}"
                cuckoo_dist_version_config_delete

                echo "HD directory '${CUCKOO_HD_ARCH_OS_DIR}' has been deleted"
            else
                echo "WARNING: HD has been deleted in directory '${CUCKOO_HD_ARCH_OS_DIR}'"
            fi
        fi
    fi
    echo ""
}

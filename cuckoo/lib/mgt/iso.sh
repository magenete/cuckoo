#
# A desktop-oriented virtual machines management system written in Shell.
#
# Code is available online at https://github.com/magenete/cuckoo
# See LICENSE for licensing information, and README for details.
#
# Copyright (C) 2016 Magenete Systems OÜ.
#


# ISO file import or download
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
        cuckoo_error "ISO file has not been setuped from '$CUCKOO_ISO_FILE_PATH' to '${CUCKOO_ISO_FILE_SYS_PATH}'"
    fi

    chmod 0600 "$CUCKOO_ISO_FILE_SYS_PATH"

    cuckoo_message "ISO file has been setuped as '${CUCKOO_ISO_FILE_SYS_PATH}'"
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

                    echo "ISO file(s) has been deleted in '${CUCKOO_ISO_ARCH_OS_DIR}'"
                else
                    echo "WARNING: ISO file(s) has not been deleted for OS: ${CUCKOO_OS}, arch: ${CUCKOO_ARCH}"
                fi
            done
        done
    else
        CUCKOO_ARCH="$CUCKOO_ACTION_ARCH_LIST"
        CUCKOO_OS="$CUCKOO_ACTION_OS_LIST"

        cuckoo_variables

        if [ -d "${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}" ]
        then
            rm -rf "${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}"

            echo "ISO file(s) has been deleted in '${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}'"
        else
            if [ -f "${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_ISO_FILE}" ]
            then
                rm -f "${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_ISO_FILE}"

                echo "ISO file '${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_ISO_FILE}' has been deleted"
            else
                echo "WARNING: ISO file '${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_ISO_FILE}' has not been deleted"
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
                echo "ISO file(s) has been found in '${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}':"

                for iso_file in $(ls -R -h -x --file-type "${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}" 2> /dev/null)
                do
                    echo "    $iso_file"
                done

                echo ""
            else
                echo "WARNING: ISO file(s) has not been found for OS: ${CUCKOO_OS}, arch: ${CUCKOO_ARCH}"
                echo ""
            fi
        done
    done
}

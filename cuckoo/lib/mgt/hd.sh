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
    if [ -e "$CUCKOO_HD_ARCH_OS_CLEAN_DIR" ] && [ -d "$CUCKOO_HD_ARCH_OS_CLEAN_DIR" ]
    then
        for hd_file in $(ls "${CUCKOO_HD_ARCH_OS_CLEAN_DIR}")
        do
            if [ -f "${CUCKOO_HD_ARCH_OS_CLEAN_DIR}${hd_file}" ]
            then
                cp "${CUCKOO_HD_ARCH_OS_CLEAN_DIR}${hd_file}" "${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}${hd_file}"
            fi
        done
    else
        cuckoo_error "Directory '${CUCKOO_HD_ARCH_OS_CLEAN_DIR}' does not exist"
    fi
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

                if [ -e "$CUCKOO_HD_ARCH_OS_DIR" ] && [ -d "$CUCKOO_HD_ARCH_OS_DIR" ]
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

        if [ -e "${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}" ] && [ -d "${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}" ]
        then
            rm -rf "${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}"
            cuckoo_dist_version_config_delete

            echo "HD has been deleted in directory '${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}'"
        else
            if [ -e "${CUCKOO_HD_ARCH_OS_DIR}" ] && [ -f "${CUCKOO_HD_ARCH_OS_DIR}" ]
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

            if [ -e "${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}" ] && [ -d "${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}" ]
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

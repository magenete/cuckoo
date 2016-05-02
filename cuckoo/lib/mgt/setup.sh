#
# A desktop-oriented virtual machines management system written in Shell.
#
# Code is available online at https://github.com/magenete/cuckoo
# See LICENSE for licensing information, and README for details.
#
# Copyright (C) 2016 Magenete Systems OÜ.
#


# ISO copy
cuckoo_setup_iso()
{
    CUCKOO_ENV_NO="yes"

    if [ -z "$CUCKOO_DIST_VERSION" ]
    then
        for cuckoo_arch in $CUCKOO_ACTION_ARCH_LIST
        do
            for cuckoo_os in $CUCKOO_ACTION_OS_LIST
            do
                CUCKOO_ARCH="$cuckoo_arch"
                CUCKOO_OS="$cuckoo_os"

                cuckoo_variables

                if [ -d "$CUCKOO_ISO_ARCH_OS_DIR" ]
                then
                    mkdir -p "${CUCKOO_SETUP_DIR}cuckoo/iso/${CUCKOO_ARCH}/"
                    cp -rv "$CUCKOO_ISO_ARCH_OS_DIR" "${CUCKOO_SETUP_DIR}cuckoo/iso/${CUCKOO_ARCH}/"

                    echo "      ...from '${CUCKOO_ISO_ARCH_OS_DIR}'"
                else
                    echo "      WARNING: ISO file(s) not copyed for OS: ${CUCKOO_OS}, arch: ${CUCKOO_ARCH}"
                fi
            done
        done
    else
        CUCKOO_ARCH="$CUCKOO_ACTION_ARCH_LIST"
        CUCKOO_OS="$CUCKOO_ACTION_OS_LIST"

        cuckoo_variables

        if [ -d "${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}" ]
        then
            mkdir -p "${CUCKOO_SETUP_DIR}cuckoo/iso/${CUCKOO_ARCH}/${CUCKOO_OS}/"
            cp -rv "${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}" "${CUCKOO_SETUP_DIR}cuckoo/iso/${CUCKOO_ARCH}/${CUCKOO_OS}/${CUCKOO_DIST_VERSION_DIR}"

            echo "      ...from '${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}'"
        else
            if [ -f "${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_ISO_FILE}" ]
            then
                mkdir -p "${CUCKOO_SETUP_DIR}cuckoo/iso/${CUCKOO_ARCH}/${CUCKOO_OS}/${CUCKOO_DIST_VERSION_DIR}"
                cp -v "${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_ISO_FILE}" "${CUCKOO_SETUP_DIR}cuckoo/iso/${CUCKOO_ARCH}/${CUCKOO_OS}/${CUCKOO_ISO_FILE}"

                echo "      ...from '${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_ISO_FILE}'"
            else
                echo "      WARNING: ISO file '${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_ISO_FILE}' has not been copyed"
            fi
        fi
    fi
}


# HD copy
cuckoo_setup_hd()
{
    CUCKOO_ENV_NO="yes"

    if [ -z "$CUCKOO_DIST_VERSION" ]
    then
        for cuckoo_arch in $CUCKOO_ACTION_ARCH_LIST
        do
            for cuckoo_os in $CUCKOO_ACTION_OS_LIST
            do
                CUCKOO_ARCH="$cuckoo_arch"
                CUCKOO_OS="$cuckoo_os"

                cuckoo_variables

                if [ -d "$CUCKOO_HD_ARCH_OS_DIR" ]
                then
                    mkdir -p "${CUCKOO_SETUP_DIR}cuckoo/hd/${CUCKOO_ARCH}/"
                    cp -rv "$CUCKOO_HD_ARCH_OS_DIR" "${CUCKOO_SETUP_DIR}cuckoo/hd/${CUCKOO_ARCH}/"

                    echo "      ...from '${CUCKOO_HD_ARCH_OS_DIR}'"
                else
                    echo "      WARNING: HD(s) not copyed for OS: ${CUCKOO_OS}, arch: ${CUCKOO_ARCH}"
                fi
            done
        done
    else
        CUCKOO_ARCH="$CUCKOO_ACTION_ARCH_LIST"
        CUCKOO_OS="$CUCKOO_ACTION_OS_LIST"

        cuckoo_variables

        if [ -d "${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}" ]
        then
            mkdir -p "${CUCKOO_SETUP_DIR}cuckoo/hd/${CUCKOO_ARCH}/${CUCKOO_OS}/${CUCKOO_DIST_VERSION_DIR}"
            cp -rv "${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}" "${CUCKOO_SETUP_DIR}cuckoo/hd/${CUCKOO_ARCH}/${CUCKOO_OS}/$(dirname ${CUCKOO_DIST_VERSION_DIR})"

            if [ -f "${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_CONFIG_FILE}" ]
            then
                cp -v "${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_CONFIG_FILE}" "$(dirname "${CUCKOO_SETUP_DIR}cuckoo/hd/${CUCKOO_ARCH}/${CUCKOO_OS}/${CUCKOO_DIST_VERSION_DIR}")"
            fi

            echo "      ...from '${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}'"
        else
            echo "      WARNING: HD(s) not copyed for OS: ${CUCKOO_OS}, arch: ${CUCKOO_ARCH}"
        fi
    fi
}


# Cuckoo directory
cuckoo_setup_cuckoo_dir()
{
    echo "  Directory cuckoo/: copying..."
    mkdir "${CUCKOO_SETUP_DIR}cuckoo/"

    echo ""
    echo "    Directory bin/: copying..."
    cp -rv "${CUCKOO_DIR}bin/" "${CUCKOO_SETUP_DIR}cuckoo/"

    echo ""
    echo "    Directory etc/: copying..."
    cp -rv "${CUCKOO_DIR}etc/" "${CUCKOO_SETUP_DIR}cuckoo/"

    echo ""
    echo "    Directory lib/: copying..."
    cp -rv "${CUCKOO_DIR}lib/" "${CUCKOO_SETUP_DIR}cuckoo/"

    echo ""
    echo "    Directory os/: copying..."
    cp -rv "${CUCKOO_DIR}os/" "${CUCKOO_SETUP_DIR}cuckoo/"

    echo ""
    echo "    ISO structure from iso/: copying..."
    mkdir "${CUCKOO_SETUP_DIR}cuckoo/iso/"
    cuckoo_setup_iso

    echo ""
    echo "    HD(s) structure from hd/: copying..."
    mkdir "${CUCKOO_SETUP_DIR}cuckoo/hd/"
    cuckoo_setup_hd

    echo ""
    echo "    Management and installation files: copying..."
    cp -v $(ls "${CUCKOO_DIR}"*.bat) "${CUCKOO_SETUP_DIR}cuckoo/"
    cp -v $(ls "${CUCKOO_DIR}"*.sh) "${CUCKOO_SETUP_DIR}cuckoo/"

    echo ""
}


# Setup
cuckoo_setup()
{
    CUCKOO_SETUP_DIR="${CUCKOO_SETUP_DIR}cuckoo/"
    CUCKOO_ENV_NO="yes"

    mkdir -p "$CUCKOO_SETUP_DIR"
    echo ""

    echo "  Main file: copying..."
    cp -v "${CUCKOO_DIR}../README.md" "$CUCKOO_SETUP_DIR"
    cp -v "${CUCKOO_DIR}../LICENSE" "$CUCKOO_SETUP_DIR"

    echo ""

    cuckoo_message "Cuckoo was set in '${CUCKOO_SETUP_DIR}'"
}

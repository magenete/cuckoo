#
# A desktop-oriented virtual machines management system written in Shell.
#
# Code is available online at https://github.com/magenete/cuckoo
# See LICENSE for licensing information, and README for details.
#
# Copyright (C) 2016 Magenete Systems OÜ.
#


# Cuckoo variables
cuckoo_variables()
{
    [ -z "$CUCKOO_ENV_NO" ] && cuckoo_env

    CUCKOO_OS="${CUCKOO_OS:=linux}"
    CUCKOO_ARCH="${CUCKOO_ARCH:=x86_64}"
    CUCKOO_DIST_VERSION="${CUCKOO_DIST_VERSION:=debian/8.4}"
    if [ -z "$CUCKOO_DIST_VERSION" ]
    then
        CUCKOO_ISO_FILE=""
        CUCKOO_DIST_VERSION_DIR=""
        CUCKOO_DIST_VERSION_CONFIG_FILE=""
    else
        CUCKOO_ISO_FILE="${CUCKOO_DIST_VERSION}.iso"
        CUCKOO_DIST_VERSION_DIR="${CUCKOO_DIST_VERSION}/"
        CUCKOO_DIST_VERSION_CONFIG_FILE="${CUCKOO_DIST_VERSION}.config"
    fi
    CUCKOO_TMP_DIR="${TMPDIR:=/tmp}/cuckoo/"
    CUCKOO_BIN_DIR="${CUCKOO_DIR}bin/"
    CUCKOO_BIN_INSTALL_DIR="${CUCKOO_BIN_DIR}install/"
    CUCKOO_BIN_RUN_DIR="${CUCKOO_BIN_DIR}run/"
    CUCKOO_ETC_DIR="${CUCKOO_DIR}etc/"
    CUCKOO_ETC_VERSION_FILE="${CUCKOO_ETC_DIR}VERSION"
    CUCKOO_HD_DIR="${CUCKOO_DIR}hd/"
    CUCKOO_HD_ARCH_DIR="${CUCKOO_HD_DIR}${CUCKOO_ARCH}/"
    CUCKOO_HD_ARCH_OS_DIR="${CUCKOO_HD_ARCH_DIR}${CUCKOO_OS}/"
    CUCKOO_HD_ARCH_OS_CLEAN_DIR="${CUCKOO_HD_ARCH_OS_DIR}.clean/"
    CUCKOO_ISO_DIR="${CUCKOO_DIR}iso/"
    CUCKOO_ISO_ARCH_DIR="${CUCKOO_ISO_DIR}${CUCKOO_ARCH}/"
    CUCKOO_ISO_ARCH_OS_DIR="${CUCKOO_ISO_ARCH_DIR}${CUCKOO_OS}/"
    CUCKOO_LIB_DIR="${CUCKOO_DIR}lib/"
    CUCKOO_OS_DIR="${CUCKOO_DIR}os/"
    CUCKOO_OS_COMMON_DIR="${CUCKOO_OS_DIR}common/"
    CUCKOO_OS_OS_DIR="${CUCKOO_OS_DIR}${CUCKOO_OS}/"
}


# Cuckoo variables check
cuckoo_variables_check()
{
    [ -z "$CUCKOO_ACTION" ] && CUCKOO_ACTION="$CUCKOO_ACTION_DEFAULT"

    if [ "$CUCKOO_ACTION" = "run" ] || [ "$CUCKOO_ACTION" = "install" ]
    then
        [ -z "$CUCKOO_OS" ] && CUCKOO_OS="$CUCKOO_OS_DEFAULT"
        [ -z "$CUCKOO_DIST_VERSION" ] && CUCKOO_DIST_VERSION="$CUCKOO_DIST_VERSION_DEFAULT"

        if [ -z "$CUCKOO_ARCH" ]
        then
            cuckoo_env
            CUCKOO_ARCH="$CUCKOO_ARCH"
        fi

        if [ -z "$CUCKOO_CPU_CORES" ]
        then
            if [ "$CUCKOO_ARCH" = "x86" ]
            then
                CUCKOO_CPU_CORES=$((CUCKOO_CPU_CORES_DEFAULT/2))
            else
                CUCKOO_CPU_CORES=$CUCKOO_CPU_CORES_DEFAULT
            fi
        fi

        [ -z "$CUCKOO_CPU_THREADS" ] && CUCKOO_CPU_THREADS=$CUCKOO_CPU_THREADS_DEFAULT
        [ -z "$CUCKOO_CPU_SOCKETS" ] && CUCKOO_CPU_SOCKETS=$CUCKOO_CPU_SOCKETS_DEFAULT
        [ -z "$CUCKOO_HD_TYPE" ] && CUCKOO_HD_TYPE="$CUCKOO_HD_TYPE_DEFAULT"
        [ -z "$CUCKOO_MEMORY_SIZE" ] && CUCKOO_MEMORY_SIZE="$CUCKOO_MEMORY_SIZE_DEFAULT"
    else
        if [ -z "$CUCKOO_OS" ]
        then
            if [ -z "$CUCKOO_DIST_VERSION" ]
            then
                CUCKOO_ACTION_OS_LIST="$CUCKOO_OS_LIST"
            else
                CUCKOO_ACTION_OS_LIST="$CUCKOO_OS_DEFAULT"
            fi
        else
            CUCKOO_ACTION_OS_LIST="$CUCKOO_OS"
        fi

        if [ -z "$CUCKOO_ARCH" ]
        then
            if [ -z "$CUCKOO_DIST_VERSION" ]
            then
                CUCKOO_ACTION_ARCH_LIST="$CUCKOO_ARCH_LIST"
            else
                cuckoo_env
                CUCKOO_ACTION_ARCH_LIST="$CUCKOO_ARCH"
            fi
        else
            CUCKOO_ACTION_ARCH_LIST="$CUCKOO_ARCH"
        fi
    fi
}

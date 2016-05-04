#
# A desktop-oriented virtual machines management system written in Shell.
#
# Code is available online at https://github.com/magenete/cuckoo
# See LICENSE for licensing information, and README for details.
#
# Copyright (C) 2016 Magenete Systems OÜ.
#


# Variables
qemu_variables()
{
    [ -z "$QEMU_ENV_NO" ] && qemu_env

    QEMU_HD_TYPE="${QEMU_HD_TYPE:=$QEMU_HD_TYPE_DEFAULT}"
    QEMU_CPU_CORES=${QEMU_CPU_CORES:=$QEMU_CPU_CORES_DEFAULT}
    QEMU_CPU_THREADS=${QEMU_CPU_THREADS:=$QEMU_CPU_THREADS_DEFAULT}
    QEMU_CPU_SOCKETS=${QEMU_CPU_SOCKETS:=$QEMU_CPU_SOCKETS_DEFAULT}
    QEMU_MEMORY_SIZE="${QEMU_MEMORY_SIZE:=$QEMU_MEMORY_SIZE_DEFAULT}"
    QEMU_CDROM_FILE="${QEMU_CDROM_FILE:=}"
    QEMU_SMB_DIR="${QEMU_SMB_DIR:=}"
    QEMU_FULL_SCREEN="${QEMU_FULL_SCREEN:=}"
    QEMU_DAEMONIZE_NO="${QEMU_DAEMONIZE_NO:=}"
    QEMU_ENABLE_KVM_NO="${QEMU_ENABLE_KVM_NO:=}"

    case "$QEMU_ARCH" in
        x86_64 )
            QEMU_ARCH_BIN_FILE="$QEMU_ARCH"
            QEMU_CPU_MODEL="qemu64"
        ;;
        x86 )
            QEMU_ARCH_BIN_FILE="i386"
            QEMU_CPU_MODEL="qemu32"
        ;;
    esac

    QEMU_BUILD_BRANCH="${QEMU_BUILD_BRANCH:=$QEMU_BUILD_BRANCH_DEFAULT}"
    QEMU_BUILD_ARCH_TARGET="${QEMU_ARCH_BIN_FILE}-softmmu"
    QEMU_BUILD_SOURCE_URL_FILE="${QEMU_BUILD_SOURCE_URL_DIR}${QEMU_BUILD_BRANCH}.tar.gz"

    QEMU_TMP_DIR="${TMPDIR:=/tmp}/qemu/"

    QEMU_LIB_DIR="${QEMU_DIR}lib/"

    QEMU_BIN_FILE="bin/qemu-system-${QEMU_ARCH_BIN_FILE}"
    if [ -z "$QEMU_SYSTEM" ]
    then
        QEMU_BIN_DIR="${QEMU_DIR}bin/"
        QEMU_BIN_ARCH_DIR="${QEMU_BIN_DIR}${QEMU_ARCH}/"
        QEMU_BIN_ARCH_OS_DIR="${QEMU_BIN_ARCH_DIR}${QEMU_OS}/"
        QEMU_BIN_ARCH_OS_TMP_DIR="${QEMU_BIN_ARCH_OS_DIR}.tmp/"
        QEMU_BIN_ARCH_OS_TMP_BRANCH_DIR="${QEMU_BIN_ARCH_OS_TMP_DIR}qemu-${QEMU_BUILD_BRANCH}/"
        QEMU_BIN_ARCH_OS_VERSION_FILE="${QEMU_BIN_ARCH_OS_DIR}VERSION"
        QEMU_BIN_ARCH_OS_VERSION="$(cat "$QEMU_BIN_ARCH_OS_VERSION_FILE" 2> /dev/null)"

        if [ -z "$QEMU_BIN_ARCH_OS_VERSION" ]
        then
            QEMU_BIN_ARCH_OS_VERSION_DIR=""
        else
            QEMU_BIN_ARCH_OS_VERSION_DIR="${QEMU_BIN_ARCH_OS_DIR}${QEMU_BIN_ARCH_OS_VERSION}/"
        fi
    else
        QEMU_BIN_FILE="$(basename "$QEMU_BIN_FILE" 2> /dev/null)"
        QEMU_BIN_DIR="$(dirname "$(which "$QEMU_BIN_FILE")" 2> /dev/null)/"
        QEMU_BIN_ARCH_DIR=""
        QEMU_BIN_ARCH_OS_DIR=""
        QEMU_BIN_ARCH_OS_VERSION_FILE=""
        QEMU_BIN_ARCH_OS_VERSION="$("${QEMU_BIN_DIR}${QEMU_BIN_FILE}" -version 2> /dev/null)"
        QEMU_BIN_ARCH_OS_VERSION_DIR=""
    fi

    QEMU_OPTS_EXT="${QEMU_OPTS_EXT:=}"
    QEMU_TITLE="${QEMU_TITLE:=$QEMU_BIN_ARCH_OS_VERSION}"
}


# Variables check
qemu_variables_check()
{
    QEMU_ACTION="${QEMU_ACTION:=$QEMU_ACTION_DEFAULT}"

    case "$QEMU_ACTION" in
        build | delete | setup | list | version )

            QEMU_ENV_NO="yes"

            if [ -z "$QEMU_OS" ]
            then
                QEMU_ACTION_OS_LIST="$QEMU_OS_LIST"
            else
                QEMU_ACTION_OS_LIST="$QEMU_OS"
            fi

            if [ -z "$QEMU_ARCH" ]
            then
                QEMU_ACTION_ARCH_LIST="$QEMU_ARCH_LIST"
            else
                QEMU_ACTION_ARCH_LIST="$QEMU_ARCH"
            fi
        ;;
        * )
            QEMU_OS="${QEMU_OS:=$QEMU_OS_DEFAULT}"
            QEMU_ARCH="${QEMU_ARCH:=$QEMU_ARCH_DEFAULT}"
        ;;
    esac
}

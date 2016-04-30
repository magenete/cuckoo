#
# A desktop-oriented virtual machines management system written in Shell.
#
# Code is available online at https://github.com/magenete/cuckoo
# See LICENSE for licensing information, and README for details.
#
# Copyright (C) 2016 Magenete Systems OÜ.
#


# Create
cuckoo_dist_version_config_create()
{
    mkdir -p "$(dirname "${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_CONFIG_FILE}")"

    cat > "${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_CONFIG_FILE}" << _C_O_F_I_G
CUCKOO_OS="$CUCKOO_OS"
CUCKOO_ARCH="$CUCKOO_ARCH"
CUCKOO_DIST_VERSION="$CUCKOO_DIST_VERSION"
CUCKOO_DIST_VERSION_DIR="$CUCKOO_DIST_VERSION_DIR"
CUCKOO_ISO_FILE="$CUCKOO_ISO_FILE"

CUCKOO_MEMORY_SIZE="$CUCKOO_MEMORY_SIZE"
CUCKOO_CPU_CORES=$CUCKOO_CPU_CORES
CUCKOO_CPU_THREADS=$CUCKOO_CPU_THREADS
CUCKOO_CPU_SOCKETS=$CUCKOO_CPU_SOCKETS
CUCKOO_HD_TYPE="$CUCKOO_HD_TYPE"
CUCKOO_FULL_SCREEN="$CUCKOO_FULL_SCREEN"
CUCKOO_DAEMONIZE_NO="$CUCKOO_DAEMONIZE_NO"
CUCKOO_SMB_DIR="$CUCKOO_SMB_DIR"

CUCKOO_ADD_CDROM_FILE="$CUCKOO_ADD_CDROM_FILE"
CUCKOO_OPTS_EXT="$CUCKOO_OPTS_EXT"
_C_O_F_I_G
}


# Load
cuckoo_dist_version_config_load()
{
    if [ -f "${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_CONFIG_FILE}" ]
    then
        . "${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_CONFIG_FILE}"
    fi
}


# Merge variables
cuckoo_dist_version_config_merge()
{
    CUCKOO_OS__C_O_N_F_I_G="$CUCKOO_OS"
    CUCKOO_ARCH__C_O_N_F_I_G="$CUCKOO_ARCH"
    CUCKOO_DIST_VERSION__C_O_N_F_I_G="$CUCKOO_DIST_VERSION"
    CUCKOO_DIST_VERSION_DIR__C_O_N_F_I_G="$CUCKOO_DIST_VERSION_DIR"
    CUCKOO_ISO_FILE__C_O_N_F_I_G="$CUCKOO_ISO_FILE"

    CUCKOO_MEMORY_SIZE__C_O_N_F_I_G="$CUCKOO_MEMORY_SIZE"
    CUCKOO_CPU_CORES__C_O_N_F_I_G=$CUCKOO_CPU_CORES
    CUCKOO_CPU_THREADS__C_O_N_F_I_G=$CUCKOO_CPU_THREADS
    CUCKOO_CPU_SOCKETS__C_O_N_F_I_G=$CUCKOO_CPU_SOCKETS
    CUCKOO_HD_TYPE__C_O_N_F_I_G="$CUCKOO_HD_TYPE"
    CUCKOO_FULL_SCREEN__C_O_N_F_I_G="$CUCKOO_FULL_SCREEN"
    CUCKOO_DAEMONIZE_NO__C_O_N_F_I_G="$CUCKOO_DAEMONIZE_NO"
    CUCKOO_SMB_DIR__C_O_N_F_I_G="$CUCKOO_SMB_DIR"

    CUCKOO_ADD_CDROM_FILE__C_O_N_F_I_G="$CUCKOO_ADD_CDROM_FILE"
    CUCKOO_OPTS_EXT__C_O_N_F_I_G="$CUCKOO_OPTS_EXT"

    cuckoo_dist_version_config_load

    [ "$CUCKOO_OS" != "$CUCKOO_OS__C_O_N_F_I_G" ] && CUCKOO_OS="$CUCKOO_OS__C_O_N_F_I_G"
    [ "$CUCKOO_ARCH" != "$CUCKOO_ARCH_CONFIG_TMP" ] && CUCKOO_ARCH="$CUCKOO_ARCH__C_O_N_F_I_G"
    [ "$CUCKOO_DIST_VERSION" != "$CUCKOO_DIST_VERSION__C_O_N_F_I_G" ] && CUCKOO_DIST_VERSION="$CUCKOO_DIST_VERSION__C_O_N_F_I_G"
    [ "$CUCKOO_DIST_VERSION_DIR" != "$CUCKOO_DIST_VERSION_DIR__C_O_N_F_I_G" ] && CUCKOO_DIST_VERSION_DIR="$CUCKOO_DIST_VERSION_DIR__C_O_N_F_I_G"
    [ "$CUCKOO_ISO_FILE" != "$CUCKOO_ISO_FILE__C_O_N_F_I_G" ] && CUCKOO_ISO_FILE="$CUCKOO_ISO_FILE__C_O_N_F_I_G"

    [ "$CUCKOO_MEMORY_SIZE" != "$CUCKOO_MEMORY_SIZE__C_O_N_F_I_G" ] && CUCKOO_MEMORY_SIZE="$CUCKOO_MEMORY_SIZE__C_O_N_F_I_G"
    [ "$CUCKOO_CPU_CORES" != "$CUCKOO_CPU_CORES__C_O_N_F_I_G" ] && CUCKOO_CPU_CORES="$CUCKOO_CPU_CORES__C_O_N_F_I_G"
    [ "$CUCKOO_CPU_THREADS" != "$CUCKOO_CPU_THREADS__C_O_N_F_I_G" ] && CUCKOO_CPU_THREADS="$CUCKOO_CPU_THREADS__C_O_N_F_I_G"
    [ "$CUCKOO_CPU_SOCKETS" != "$CUCKOO_CPU_SOCKETS__C_O_N_F_I_G" ] && CUCKOO_CPU_SOCKETS="$CUCKOO_CPU_SOCKETS__C_O_N_F_I_G"
    [ "$CUCKOO_HD_TYPE" != "$CUCKOO_HD_TYPE__C_O_N_F_I_G" ] && CUCKOO_HD_TYPE="$CUCKOO_HD_TYPE__C_O_N_F_I_G"
    [ "$CUCKOO_FULL_SCREEN" != "$CUCKOO_FULL_SCREEN__C_O_N_F_I_G" ] && CUCKOO_FULL_SCREEN="$CUCKOO_FULL_SCREEN__C_O_N_F_I_G"
    [ "$CUCKOO_DAEMONIZE_NO" != "$CUCKOO_DAEMONIZE_NO__C_O_N_F_I_G" ] && CUCKOO_DAEMONIZE_NO="$CUCKOO_DAEMONIZE_NO__C_O_N_F_I_G"
    [ "$CUCKOO_SMB_DIR" != "$CUCKOO_SMB_DIR__C_O_N_F_I_G" ] && CUCKOO_SMB_DIR="$CUCKOO_SMB_DIR__C_O_N_F_I_G"

    [ "$CUCKOO_ADD_CDROM_FILE" != "$CUCKOO_ADD_CDROM_FILE__C_O_N_F_I_G" ] && CUCKOO_ADD_CDROM_FILE="$CUCKOO_ADD_CDROM_FILE__C_O_N_F_I_G"
    [ "$CUCKOO_OPTS_EXT" != "$CUCKOO_OPTS_EXT__C_O_N_F_I_G" ] && CUCKOO_OPTS_EXT="$CUCKOO_OPTS_EXT__C_O_N_F_I_G"
}


# Delete
cuckoo_dist_version_config_delete()
{
    if [ -f "${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_CONFIG_FILE}" ]
    then
        rm -f "${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_CONFIG_FILE}"
        if [ $? -gt 0 ]
        then
            cuckoo_error "Config file '${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_CONFIG_FILE}' has not been deleted"
        else
            cuckoo_message "Config file '${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_CONFIG_FILE}' has been deleted"
        fi
    else
        cuckoo_error "Config file '${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_CONFIG_FILE}' does not exist"
    fi
}


# Manage
cuckoo_dist_version_config()
{
    cuckoo_variables

    case "$CUCKOO_DIST_VERSION_CONFIG" in
        create )
            cuckoo_dist_version_config_create

            cuckoo_message "Config has been created in '${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_CONFIG_FILE}'"
        ;;
        update )
            if [ -f "${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_CONFIG_FILE}" ]
            then
                cuckoo_dist_version_config_merge
                cuckoo_dist_version_config_create

                cuckoo_message "Config has been updated in '${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_CONFIG_FILE}'"
            fi
        ;;
        delete )
            cuckoo_dist_version_config_delete
        ;;
        * )
            cuckoo_dist_version_config_load
        ;;
    esac
}

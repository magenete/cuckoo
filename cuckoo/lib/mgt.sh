#
# A desktop-oriented virtual machines management system written in Shell.
#
# Code is available online at https://github.com/magenete/cuckoo
# See LICENSE for licensing information, and README for details.
#
# Copyright (C) 2016 Magenete Systems OÜ.
#


CUCKOO_DIR="${CUCKOO_DIR:=$(cd "$(dirname "$0")/.." && pwd -P)}/"

CUCKOO_EMULATOR_VERSION=""
CUCKOO_EMULATOR_SYSTEM=""
CUCKOO_EMULATOR_ACTION=""
CUCKOO_EMULATOR_ARCH_LIST=""
CUCKOO_EMULATOR_ARCH_REAL=""
CUCKOO_EMULATOR_ARCH=""
CUCKOO_EMULATOR_OS_LIST=""
CUCKOO_EMULATOR_OS_REAL=""
CUCKOO_EMULATOR_OS=""
CUCKOO_EMULATOR_NAME=""
CUCKOO_EMULATOR=""
CUCKOO_ACTION=""
CUCKOO_ACTION_ARCH_LIST=""
CUCKOO_ACTION_OS_LIST=""
CUCKOO_OS=""
CUCKOO_OS_NAME=""
CUCKOO_OS_SUB_NAME=""
CUCKOO_ARCH=""
CUCKOO_DIST_VERSION=""
CUCKOO_ISO_FILE=""
CUCKOO_ISO_FILE_NET=""
CUCKOO_ISO_FILE_PATH=""
CUCKOO_MEMORY_SIZE=""
CUCKOO_CPU_CORES=
CUCKOO_CPU_THREADS=
CUCKOO_CPU_SOCKETS=
CUCKOO_SETUP_DIR=""
CUCKOO_CDROM_ADD_FILE=""
CUCKOO_CDROM_BOOT_FILE=""
CUCKOO_FLOPPY_BOOT_FILE=""
CUCKOO_FULL_SCREEN=""
CUCKOO_DAEMONIZE_NO=""
CUCKOO_HD_TYPE=""
CUCKOO_HD_FILE_PATH=""
CUCKOO_HD_FILE_NET=""
CUCKOO_HD_DEFINE_FILE=""
CUCKOO_DIST_VERSION_DESKTOP=""
CUCKOO_DIST_VERSION_DESKTOP_FILE=""
CUCKOO_DIST_VERSION_DESKTOP_STYLE=""
CUCKOO_DIST_VERSION_DESKTOP_ICON_FILE=""
CUCKOO_DIST_VERSION_DESKTOP_LAUNCHER_FILE=""
CUCKOO_DIST_VERSION_CONFIG=""
CUCKOO_DIST_VERSION_CONFIG_FILE=""


# Load all Cuckoo MGT libs
for mgt_lib_file in $(ls "${CUCKOO_DIR}lib/mgt/"*.sh)
do
    . "$mgt_lib_file"
done


# Initialize all VM libs
for emulator_lib in $CUCKOO_EMULATOR_LIST
do
    cuckoo_${emulator_lib}_init
done


# Cuckoo actions
cuckoo_actions()
{
    cuckoo_variables_check

    case "$CUCKOO_ACTION" in
        run | install )
            cuckoo_${CUCKOO_EMULATOR}_mapping
            cuckoo_run_or_install

            cuckoo_${CUCKOO_EMULATOR}_mapping
            ${CUCKOO_EMULATOR}_actions
        ;;
        setup )
            cuckoo_setup

            cuckoo_${CUCKOO_EMULATOR}_mapping
            ${CUCKOO_EMULATOR}_actions
        ;;
        iso-setup )
            cuckoo_iso_import_or_download
        ;;
        iso-export )
            cuckoo_iso_export
        ;;
        iso-list )
            cuckoo_iso_list
        ;;
        iso-delete )
            cuckoo_iso_delete
        ;;
        hd-setup )
            cuckoo_hd_import_or_download
        ;;
        hd-export )
            cuckoo_hd_export
        ;;
        hd-list )
            cuckoo_hd_list
        ;;
        hd-delete )
            cuckoo_hd_delete
        ;;
        config )
            cuckoo_dist_version_config
        ;;
        desktop )
            cuckoo_dist_version_desktop
        ;;
        * )
            cuckoo_error "Cuckoo action '${CUCKOO_ACTION}' is not supported"
        ;;
    esac
}


# Options
cuckoo_args $@


# Actions
cuckoo_actions

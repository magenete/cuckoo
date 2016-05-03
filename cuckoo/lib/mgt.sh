#
# A desktop-oriented virtual machines management system written in Shell.
#
# Code is available online at https://github.com/magenete/cuckoo
# See LICENSE for licensing information, and README for details.
#
# Copyright (C) 2016 Magenete Systems OÜ.
#


VIRT_EMULATOR_SYSTEM=""
VIRT_EMULATOR_ACTION=""
VIRT_EMULATOR_ARCH_LIST=""
VIRT_EMULATOR_ARCH=""
VIRT_EMULATOR_OS_LIST=""
VIRT_EMULATOR_OS=""
VIRT_EMULATOR=""


CUCKOO_ACTION=""
CUCKOO_ACTION_ARCH_LIST=""
CUCKOO_ACTION_OS_LIST=""
CUCKOO_DIR="${CUCKOO_DIR:=$(cd "$(dirname "$0")/.." && pwd -P)}/"
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
for vm_lib in $VIRT_EMULATOR_LIST
do
    cuckoo_${vm_lib}_init
done


# Cuckoo actions
cuckoo_actions()
{
    [ -z "$VIRT_EMULATOR" ] && VIRT_EMULATOR="$VIRT_EMULATOR_DEFAULT"

    cuckoo_variables_check

    case "$CUCKOO_ACTION" in
        run | install )
            cuckoo_${VIRT_EMULATOR}_mapping
            cuckoo_run_or_install

            cuckoo_${VIRT_EMULATOR}_mapping
            ${VIRT_EMULATOR}_actions
        ;;
        setup )
            cuckoo_setup

            cuckoo_${VIRT_EMULATOR}_mapping
            ${VIRT_EMULATOR}_actions
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

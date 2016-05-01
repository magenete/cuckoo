#
# A desktop-oriented virtual machines management system written in Shell.
#
# Code is available online at https://github.com/magenete/cuckoo
# See LICENSE for licensing information, and README for details.
#
# Copyright (C) 2016 Magenete Systems OÜ.
#


VIRT_EMULATOR_SYSTEM=""
VIRT_EMULATOR=""


CUCKOO_ACTION=""
CUCKOO_ACTION_ARCH_LIST=""
CUCKOO_ACTION_OS_LIST=""
CUCKOO_DIR="${CUCKOO_DIR:=$(cd "$(dirname "$0")/.." && pwd -P)}/"
CUCKOO_OS=""
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
CUCKOO_DIST_VERSION_DESKTOP=""
CUCKOO_DIST_VERSION_DESKTOP_FILE=""
CUCKOO_DIST_VERSION_DESKTOP_ICON_FILE=""
CUCKOO_DIST_VERSION_DESKTOP_LAUNCHER_FILE=""
CUCKOO_DIST_VERSION_CONFIG=""
CUCKOO_DIST_VERSION_CONFIG_FILE=""


QEMU_ACTION=""
QEMU_ACTION_ARCH_LIST=""
QEMU_ACTION_OS_LIST=""
QEMU_DIR="${QEMU_DIR:=${CUCKOO_DIR}../qemu}/"
QEMU_OS=""
QEMU_ARCH=""


# Load all MGT libs
for mgt_lib_file in $(ls "${CUCKOO_DIR}lib/mgt/"*.sh)
do
    . "$mgt_lib_file"
done


# Cuckoo actions
cuckoo_actions()
{
    case "$CUCKOO_ACTION" in
        run | install )
            case "$VIRT_EMULATOR" in
                qemu )
                    qemu_run
                ;;
                * )
                    cuckoo_error "QEMU action '${QEMU_ACTION}' does not supported"
                ;;
            esac
        ;;
        setup )
            cuckoo_setup
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
            cuckoo_error "Cuckoo action '${CUCKOO_ACTION}' does not supported"
        ;;
    esac
}


# Cuckoo
cuckoo()
{
    # Options
    cuckoo_args $@

    # Variables checking
    [ -z "$VIRT_EMULATOR" ] && VIRT_EMULATOR="$VIRT_EMULATOR_DEFAULT"

    qemu_variables_check

    cuckoo_variables_check

    # Actions running
    qemu_actions

    cuckoo_actions
}


# Main
cuckoo $@

#
# A desktop-oriented virtual machines management system written in Shell.
#
# Code is available online at https://github.com/magenete/cuckoo
# See LICENSE for licensing information, and README for details.
#
# Copyright (C) 2016 Magenete Systems OÜ.
#


# Run
cuckoo_run_or_install()
{
    cuckoo_variables

    if [ "$CUCKOO_ACTION" = "install" ]
    then
        CUCKOO_CDROM_BOOT_FILE="${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_ISO_FILE}"

        if [ -f "$CUCKOO_CDROM_BOOT_FILE" ]
        then
            cuckoo_hd_create
        else
            cuckoo_error "ISO file '${2}' does not exist, so it can not be used for installation"
        fi
    fi
}

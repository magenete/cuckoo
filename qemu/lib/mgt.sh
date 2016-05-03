#
# A desktop-oriented virtual machines management system written in Shell.
#
# Code is available online at https://github.com/magenete/cuckoo
# See LICENSE for licensing information, and README for details.
#
# Copyright (C) 2016 Magenete Systems OÜ.
#


QEMU_ACTION=""
QEMU_ACTION_ARCH_LIST=""
QEMU_ACTION_OS_LIST=""
QEMU_DIR="${QEMU_DIR:=$(cd "$(dirname "$0")/.." && pwd -P)}/"
QEMU_OS=""
QEMU_ARCH=""
QEMU_SETUP_DIR=""
QEMU_HD_TYPE=""


# Load all MGT libs
for mgt_lib_file in $(ls "${QEMU_DIR}lib/mgt/"*.sh)
do
    . "$mgt_lib_file"
done


# Actions
qemu_actions()
{
    qemu_variables_check

    case "$QEMU_ACTION" in
        run )
            QEMU_OS_REAL="yes"

            qemu_variables

            [ "$QEMU_OS" != "linux" ] && QEMU_ENABLE_KVM_NO="yes"

            qemu_run
        ;;
        run-system )
            QEMU_SYSTEM="yes"
            QEMU_OS_REAL="yes"

            qemu_variables
            qemu_run
        ;;
        build )
            QEMU_OS_REAL="yes"
            qemu_env
            QEMU_OS_REAL=""

            if [ "$QEMU_OS" != "linux" ]
            then
                qemu_error "QEMU building done only on GNU/Linux!"
            else
                qemu_variables
                qemu_build
            fi
        ;;
        list )
            qemu_variables
            qemu_versions_list
        ;;
        delete )
            qemu_variables
            qemu_delete
        ;;
        setup )
            qemu_variables

            qemu_setup_dir
            qemu_setup
        ;;
        * )
            qemu_error "QEMU action '${QEMU_ACTION}' is not supported"
        ;;
    esac
}

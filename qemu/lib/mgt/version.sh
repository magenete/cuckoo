#
# A desktop-oriented virtual machines management system written in Shell.
#
# Code is available online at https://github.com/magenete/cuckoo
# See LICENSE for licensing information, and README for details.
#
# Copyright (C) 2016 Magenete Systems OÜ.
#


# Version list
qemu_version_list()
{
    echo ""

    for qemu_arch in $QEMU_ACTION_ARCH_LIST
    do
        for qemu_os in $QEMU_ACTION_OS_LIST
        do
            QEMU_ARCH="$qemu_arch"
            QEMU_OS="$qemu_os"

            qemu_variables

            if [ -d "$QEMU_BIN_ARCH_OS_DIR" ]
            then
                echo "QEMU version defined for OS '${qemu_os}' and arch '${qemu_arch}':"

                for dir_version in $(ls "$QEMU_BIN_ARCH_OS_DIR")
                do
                    if [ -d "${QEMU_BIN_ARCH_OS_DIR}${dir_version}" ]
                    then
                         if [ ! -z "$QEMU_BIN_ARCH_OS_VERSION" ] && [ "$dir_version" = "$QEMU_BIN_ARCH_OS_VERSION" ]
                         then
                             echo "  * $dir_version"
                         else
                             echo "    $dir_version"
                         fi
                    fi
                done
                echo ""
            else
                echo "QEMU version not defined for OS: ${qemu_os}, arch: ${qemu_arch}"
            fi
        done
    done

    echo ""
}


# Version
qemu_version_setup()
{
    local qemu_version_defined=""

    echo ""

    for qemu_arch in $QEMU_ACTION_ARCH_LIST
    do
        for qemu_os in $QEMU_ACTION_OS_LIST
        do
            QEMU_ARCH="$qemu_arch"
            QEMU_OS="$qemu_os"

            qemu_variables

            if [ -d "$QEMU_BIN_ARCH_OS_DIR" ]
            then
                qemu_version_defined=""

                for dir_version in $(ls "$QEMU_BIN_ARCH_OS_DIR")
                do
                    if [ -d "${QEMU_BIN_ARCH_OS_DIR}${dir_version}" ]
                    then
                         if [ ! -z "$QEMU_VERSION" ] && [ "$dir_version" = "$QEMU_VERSION" ]
                         then
                            qemu_version_defined="$QEMU_VERSION"

                            printf "$QEMU_VERSION" > "$QEMU_BIN_ARCH_OS_VERSION_FILE"

                            echo "QEMU version set for OS '${qemu_os}' and arch '${qemu_arch}': ${dir_version}"
                         fi
                    fi
                done

                if [ "$qemu_version_defined" = "" ]
                then
                    echo "WARNING: QEMU version '${QEMU_VERSION}' not found for OS: ${qemu_os}, arch: ${qemu_arch}"
                fi
            else
                echo "WARNING: QEMU version not set for OS: ${qemu_os}, arch: ${qemu_arch}"
            fi
        done
    done

    echo ""
}

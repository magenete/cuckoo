#
# A desktop-oriented virtual machines management system written in Shell.
#
# Code is available online at https://github.com/magenete/cuckoo
# See LICENSE for licensing information, and README for details.
#
# Copyright (C) 2016 Magenete Systems OÜ.
#


# Create desktop
cuckoo_dist_version_desktop_create_desktop()
{
    mkdir -p "$CUCKOO_USER_HOME_DESKTOP_DIR"

    cat > "${CUCKOO_USER_HOME_DESKTOP_DIR}${CUCKOO_DIST_VERSION_DESKTOP_FILE}" << _D_E_S_K_T_O_P
[Desktop Entry]
Version=1.0
Name=${CUCKOO_OS} ${CUCKOO_DIST_VERSION} ${CUCKOO_ARCH} launcher
GenericName=Cuckoo - ${CUCKOO_OS_NAME} ${CUCKOO_OS_SUB_NAME} ${CUCKOO_ARCH}
Type=Application
Exec=${CUCKOO_LAUNCHERS_DESKTOP_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DESKTOP_LAUNCHER_FILE}
Keywords=virtualization;
Icon=${CUCKOO_DIST_VERSION_DESKTOP_ICON_FILE}
Categories=Emulator;System;
Comment=Run ${CUCKOO_OS} inside of QEMU-based virtualization system
_D_E_S_K_T_O_P

    echo "Desktop file '${CUCKOO_USER_HOME_DESKTOP_DIR}${CUCKOO_DIST_VERSION_DESKTOP_FILE}' was created"
}


# Create launcher
cuckoo_dist_version_desktop_create_launcher()
{
    mkdir -p "$CUCKOO_LAUNCHERS_DESKTOP_ARCH_OS_DIR"

    cat > "${CUCKOO_LAUNCHERS_DESKTOP_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DESKTOP_LAUNCHER_FILE}" << _L_A_U_N_C_H_E_R

cuckoo --run --arch ${CUCKOO_ARCH} --os-name ${CUCKOO_OS} --dist-version ${CUCKOO_DIST_VERSION}
_L_A_U_N_C_H_E_R

    chmod 0700 "${CUCKOO_LAUNCHERS_DESKTOP_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DESKTOP_LAUNCHER_FILE}"

    cuckoo_message "Laucher was created in '${CUCKOO_LAUNCHERS_DESKTOP_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DESKTOP_LAUNCHER_FILE}'"
}


# Delete desktop
cuckoo_dist_version_desktop_delete_desktop()
{
    if [ -f "${CUCKOO_USER_HOME_DESKTOP_DIR}${CUCKOO_DIST_VERSION_DESKTOP_FILE}" ]
    then
        rm -f "${CUCKOO_USER_HOME_DESKTOP_DIR}${CUCKOO_DIST_VERSION_DESKTOP_FILE}"
        if [ $? -gt 0 ]
        then
            echo "Desktop file '${CUCKOO_USER_HOME_DESKTOP_DIR}${CUCKOO_DIST_VERSION_DESKTOP_FILE}' was not deleted"
        else
            echo "Desktop file '${CUCKOO_USER_HOME_DESKTOP_DIR}${CUCKOO_DIST_VERSION_DESKTOP_FILE}' was deleted"
        fi
    else
        echo "Desktop file '${CUCKOO_USER_HOME_DESKTOP_DIR}${CUCKOO_DIST_VERSION_DESKTOP_FILE}' does not exist"
    fi
}


# Delete launcher
cuckoo_dist_version_desktop_delete_launcher()
{
    if [ -f "${CUCKOO_LAUNCHERS_DESKTOP_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DESKTOP_LAUNCHER_FILE}" ]
    then
        rm -f "${CUCKOO_LAUNCHERS_DESKTOP_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DESKTOP_LAUNCHER_FILE}"
        if [ $? -gt 0 ]
        then
            cuckoo_message "Launcher file '${CUCKOO_LAUNCHERS_DESKTOP_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DESKTOP_LAUNCHER_FILE}' was not deleted"
        else
            cuckoo_message "Launcher file '${CUCKOO_LAUNCHERS_DESKTOP_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DESKTOP_LAUNCHER_FILE}' was deleted"

            if [ -z "$(ls "$CUCKOO_LAUNCHERS_DESKTOP_ARCH_OS_DIR")" ]
            then
                rm -rf "$CUCKOO_LAUNCHERS_DESKTOP_ARCH_OS_DIR"

                [ -z "$(ls "$CUCKOO_LAUNCHERS_DESKTOP_ARCH_DIR")" ] && rm -rf "$CUCKOO_LAUNCHERS_DESKTOP_ARCH_DIR"
            fi
        fi
    else
        cuckoo_message "Launcher file '${CUCKOO_LAUNCHERS_DESKTOP_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DESKTOP_LAUNCHER_FILE}' does not exist"
    fi
}


# Setup desktop and launcher
cuckoo_dist_version_desktop()
{
    cuckoo_variables

    cuckoo_dist_version_var_file_name

    CUCKOO_DIST_VERSION_DESKTOP_FILE="cuckoo-${CUCKOO_OS}-${cuckoo_dist_version}_${CUCKOO_ARCH}.desktop"
    CUCKOO_DIST_VERSION_DESKTOP_LAUNCHER_FILE="${cuckoo_dist_version}.sh"

    if [ -f "${CUCKOO_ETC_ICON_DIR}${CUCKOO_OS}/${cuckoo_dist_version_tmp}.svg" ]
    then
        CUCKOO_DIST_VERSION_DESKTOP_ICON_FILE="${CUCKOO_ETC_ICON_DIR}${CUCKOO_OS}/${cuckoo_dist_version_tmp}.svg"
        CUCKOO_OS_SUB_NAME="$(cat "${CUCKOO_ETC_OS_DIR}${CUCKOO_OS}/${cuckoo_dist_version_tmp}.name" 2> /dev/null)"
    elif [ -f "${CUCKOO_ETC_ICON_DIR}${CUCKOO_OS}.svg" ]
    then
        CUCKOO_DIST_VERSION_DESKTOP_ICON_FILE="${CUCKOO_ETC_ICON_DIR}${CUCKOO_OS}.svg"
        CUCKOO_OS_SUB_NAME="$cuckoo_dist_version_tmp"
    else
        CUCKOO_DIST_VERSION_DESKTOP_ICON_FILE="$CUCKOO_OS"
    fi

    echo ""
    case "$CUCKOO_DIST_VERSION_DESKTOP" in
        create )
            cuckoo_dist_version_desktop_create_desktop
            cuckoo_dist_version_desktop_create_launcher
        ;;
        delete )
            cuckoo_dist_version_desktop_delete_desktop
            cuckoo_dist_version_desktop_delete_launcher
        ;;
    esac
}

#
# A desktop-oriented virtual machines management system written in Shell.
#
# Code is available online at https://github.com/magenete/cuckoo
# See LICENSE for licensing information, and README for details.
#
# Copyright (C) 2016 Magenete Systems OÜ.
#


# Print error message and exit
error_message()
{
    help_message

    echo ""
    echo "ERROR: $1"
    echo ""

    exit 1
}


# Installation run
if [ "$(whoami)" = "$USER" ] && [ "$(basename $HOME)" = "$USER" ]
then
    CUCKOO_GIT_BRANCH="master"
    CUCKOO_GIT_URL="https://github.com/magenete/cuckoo/archive/${CUCKOO_GIT_BRANCH}.tar.gz"

    CUCKOO_ARCH_LIST="x86 x86_64"
    CUCKOO_INSTALL_DIR=".cuckoo/"
    CUCKOO_DIR="${CUCKOO_INSTALL_DIR}cuckoo-${CUCKOO_GIT_BRANCH}/cuckoo/"
    CUCKOO_LIB_DIR="${CUCKOO_DIR}lib/"
    CUCKOO_BIN_DIR="${CUCKOO_DIR}bin/"
    CUCKOO_ISO_DIR="${CUCKOO_DIR}iso/"
    CUCKOO_ETC_DIR="${CUCKOO_DIR}etc/"
    CUCKOO_ETC_DESKTOP_DIR="${CUCKOO_ETC_DIR}desktop/"
    CUCKOO_ETC_DESKTOP_INSTALL_DIR="${CUCKOO_ETC_DESKTOP_DIR}install/"
    CUCKOO_ETC_DESKTOP_RUN_DIR="${CUCKOO_ETC_DESKTOP_DIR}run/"
    CUCKOO_BIN_FILE="${CUCKOO_BIN_DIR}cuckoo"

    QEMU_ARCH_LIST="x86 x86_64"
    QEMU_DIR="${CUCKOO_DIR}../qemu/"
    QEMU_LIB_DIR="${QEMU_DIR}lib/"
    QEMU_BIN_DIR="${QEMU_DIR}bin/"
    QEMU_BUILD_DIR="${QEMU_DIR}build/"

    HOME_SHELL_PROFILE_FILES=".bash_profile .bashrc .mkshrc .profile .zlogin .zshrc"


    # Make project directory and download source from Git
    mkdir -p "${HOME}/${CUCKOO_INSTALL_DIR}" && cd "${HOME}/${CUCKOO_INSTALL_DIR}" && curl -SL "$CUCKOO_GIT_URL" | tar xz

    if [ -e "${HOME}/${CUCKOO_BIN_FILE}" ] && [ -f "${HOME}/${CUCKOO_BIN_FILE}" ]
    then
        ## Cuckoo

        # Bin files
        chmod 700 "${HOME}/${CUCKOO_INSTALL_DIR}"
        chmod 700 "${HOME}/${CUCKOO_DIR}../"
        chmod 700 "${HOME}/${CUCKOO_DIR}"
        chmod 700 "${HOME}/${CUCKOO_DIR}../"*.sh
        chmod 600 "${HOME}/${CUCKOO_DIR}../"*.bat
        chmod 700 "${HOME}/${CUCKOO_BIN_FILE}"
        chmod 700 "${HOME}/${CUCKOO_BIN_DIR}"*.sh
        chmod 600 "${HOME}/${CUCKOO_BIN_DIR}"*.bat

        # Etc files
        chmod 700 "${HOME}/${CUCKOO_ETC_DESKTOP_DIR}"
        chmod 700 "${HOME}/${CUCKOO_ETC_DESKTOP_INSTALL_DIR}"
        chmod 700 "${HOME}/${CUCKOO_ETC_DESKTOP_RUN_DIR}"
        for cuckoo_arch in $CUCKOO_ARCH_LIST
        do
            chmod 700 "${HOME}/${CUCKOO_ETC_DESKTOP_INSTALL_DIR}${cuckoo_arch}/"
            chmod 600 "${HOME}/${CUCKOO_ETC_DESKTOP_INSTALL_DIR}${cuckoo_arch}/"*
            chmod 700 "${HOME}/${CUCKOO_ETC_DESKTOP_RUN_DIR}${cuckoo_arch}/"
            chmod 600 "${HOME}/${CUCKOO_ETC_DESKTOP_RUN_DIR}${cuckoo_arch}/"*
        done

        # ISO files
        chmod 700 "${HOME}/${CUCKOO_ISO_DIR}"
        for cuckoo_arch in $CUCKOO_ARCH_LIST
        do
            chmod 700 "${HOME}/${CUCKOO_ISO_DIR}${cuckoo_arch}/"
            chmod 700 "${HOME}/${CUCKOO_ISO_DIR}${cuckoo_arch}/"*
        done

        # Lib files
        chmod 600 "${HOME}/${CUCKOO_LIB_DIR}"*.sh

        ## QEMU

        # Bin directory
        chmod 700 "${HOME}/${QEMU_BIN_DIR}"

        # Lib files
        chmod 700 "${HOME}/${QEMU_LIB_DIR}"
        chmod 600 "${HOME}/${QEMU_LIB_DIR}"*.sh

        # Build files
        chmod 700 "${HOME}/${QEMU_BUILD_DIR}"
        for qemu_arch in $QEMU_ARCH_LIST
        do
            chmod 700 "${HOME}/${QEMU_BUILD_DIR}${qemu_arch}/"*.sh
        done

        ## Add Cuckoo bin path in PATH
        for shell_profile_file in $HOME_SHELL_PROFILE_FILES
        do
            if [ -e "${HOME}/${shell_profile_file}" ] && [ -f "${HOME}/${shell_profile_file}" ]
            then
                echo "" >> "${HOME}/${shell_profile_file}"
                echo "export PATH=\"\${PATH}:\${HOME}/${CUCKOO_BIN_DIR}\"  # Add Cuckoo to PATH for scripting" >> "${HOME}/${shell_profile_file}"
            fi
        done

        # Export new PATH
        export PATH="${PATH}:${HOME}/${CUCKOO_BIN_DIR}"
    else
        error_message "Bin file '${HOME}/${CUCKOO_BIN_FILE}' does not exist"
    fi
else
    error_message "Invalid ENV of current user '$USER'"
fi

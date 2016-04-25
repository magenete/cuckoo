#!/bin/sh


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

    CUCKOO_INSTALL_DIR=".cuckoo/"
    CUCKOO_DIR="${CUCKOO_INSTALL_DIR}cuckoo-${CUCKOO_GIT_BRANCH}/cuckoo/"
    CUCKOO_BIN_FILE="${CUCKOO_DIR}bin/cuckoo"

    HOME_SHELL_PROFILE_FILES=".mkshrc .bash_profile .bashrc .mkshrc .profile .zlogin .zshrc"


    mkdir -p "${HOME}/${CUCKOO_INSTALL_DIR}" && cd "${HOME}/${CUCKOO_INSTALL_DIR}" && curl -SL "$CUCKOO_GIT_URL" | tar xz

    if [ -e "${HOME}/${CUCKOO_BIN_FILE}" ] && [ -f "${HOME}/${CUCKOO_BIN_FILE}" ]
    then
        chmod 0750 "${HOME}/${CUCKOO_BIN_FILE}"

        for shell_profile_file in $HOME_SHELL_PROFILE_FILES
        do
            if [ -e "${HOME}/${shell_profile_file}" ] && [ -f "${HOME}/${shell_profile_file}" ]
            then
                echo "" >> "${HOME}/${shell_profile_file}"
                echo "export PATH=\"\${PATH}:\${HOME}/${CUCKOO_DIR}bin\"  # Add Cuckoo to PATH for scripting" >> "${HOME}/${shell_profile_file}"
                echo "" >> "${HOME}/${shell_profile_file}"
            fi
        done

        export PATH="${PATH}:${HOME}/${CUCKOO_DIR}bin"
    else
        error_message "Bin file '${HOME}/${CUCKOO_BIN_FILE}' does not exist"
    fi
else
    error_message "Invalid ENV of current user '$USER'"
fi

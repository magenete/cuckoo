#
# A desktop-oriented virtual machines management system written in Shell.
#
# Code is available online at https://github.com/magenete/cuckoo
# See LICENSE for licensing information, and README for details.
#
# Copyright (C) 2016 Magenete Systems OÜ.
#


# Answer for removing
cuckoo_removing_answer()
{
    printf "This will completely uninstall cuckoo. Continue? (y/N):"
    read answer

    case $answer in
        Y | y | Yes | yes )
            rm -rf "${HOME}/${CUCKOO_UNINSTALL_DIR}"

            echo ""
            echo "Directory '${HOME}/${CUCKOO_UNINSTALL_DIR}' has been removed"
            echo ""
            shift 1
        ;;
        "" | N | n | No | no )
            echo ""
            echo "Directory '${HOME}/${CUCKOO_UNINSTALL_DIR}' has not been removed"
            echo ""
            shift 1
        ;;
        * )
            echo "Please use Y | y | Yes | yes | N | n | No | no or just enter (by default No)."
            cuckoo_removing_answer
            shift 1
        ;;
    esac
}


# Uninstallation run
if [ "$(whoami)" = "$USER" ] && [ "$(basename $HOME)" = "$USER" ]
then
    CUCKOO_UNINSTALL_DIR=".cuckoo/"

    HOME_SHELL_PROFILE_FILES=".bash_profile .bashrc .mkshrc .profile .zlogin .zshrc"


    # Information about Cuckoo bin path removing in profile files
    echo ""
    echo "Please remove Cuckoo Bin path from PATH in the following files:"
    for shell_profile_file in $HOME_SHELL_PROFILE_FILES
    do
        if [ -e "${HOME}/${shell_profile_file}" ] && [ -f "${HOME}/${shell_profile_file}" ]
        then
            echo "    ${HOME}/${shell_profile_file}"
        fi
    done
    echo ""

    # Getting answer for directory removing
    echo "All will bee removed in '${HOME}/${CUCKOO_UNINSTALL_DIR}'"
    if [ -e "${HOME}/${CUCKOO_UNINSTALL_DIR}" ] && [ -d "${HOME}/${CUCKOO_UNINSTALL_DIR}" ]
    then
        cuckoo_removing_answer
    else
        echo ""
        echo "Directory '${HOME}/${CUCKOO_UNINSTALL_DIR}' does not exist"
        echo ""
    fi
fi

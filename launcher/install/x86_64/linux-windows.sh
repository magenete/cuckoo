#
# A desktop-oriented virtual machines management system written in Shell.
#
# Code is available online at https://github.com/magenete/cuckoo
# See LICENSE for licensing information, and README for details.
#
# Copyright (C) 2016 Magenete Systems OÜ.
#


CUCKOO_DIST_VERSION="${CUCKOO_DIST_VERSION:=10/en}"
CUCKOO_DIR="${CUCKOO_DIR:=$(realpath "$(readlink -f "$(dirname "$0")")/../../../cuckoo")}"


. "${CUCKOO_DIR}/lib/mgt.sh" --install --arch x86_64 --os-name windows --dist-version $CUCKOO_DIST_VERSION

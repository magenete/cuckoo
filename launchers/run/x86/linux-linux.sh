#
# A desktop-oriented virtual machines management system written in Shell.
#
# Code is available online at https://github.com/magenete/cuckoo
# See LICENSE for licensing information, and README for details.
#
# Copyright (C) 2016 Magenete Systems OÜ.
#


CUCKOO_DIST_VERSION="${CUCKOO_DIST_VERSION:=debian-8.4}"
CUCKOO_DIR="${CUCKOO_DIR:=$(realpath "$(readlink -f "$(dirname "$0")")/../../../cuckoo")}"


. "${CUCKOO_DIR}/lib/mgt.sh" --run --arch x86 --os-name linux --dist-version $CUCKOO_DIST_VERSION --cpu-cores 2

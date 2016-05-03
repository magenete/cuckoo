#
# A desktop-oriented virtual machines management system written in Shell.
#
# Code is available online at https://github.com/magenete/cuckoo
# See LICENSE for licensing information, and README for details.
#
# Copyright (C) 2016 Magenete Systems OÜ.
#


CUCKOO_ACTION="${CUCKOO_ACTION:=--run}"
CUCKOO_DIST_VERSION="${CUCKOO_DIST_VERSION:=10.11}"
CUCKOO_DIR="$(cd "$(dirname "$0")/../cuckoo" && pwd -P)"


. "${CUCKOO_DIR}/lib/mgt.sh" $CUCKOO_ACTION --os-name macosx --dist-version $CUCKOO_DIST_VERSION $@

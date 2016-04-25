#
# A desktop-oriented virtual machines management system written in Shell.
#
# Code is available online at https://github.com/magenete/cuckoo
# See LICENSE for licensing information, and README for details.
#
# Copyright (C) 2016 Magenete Systems OÜ.
#


CUCKOO_ACTION="${CUCKOO_ACTION:=--run}"
CUCKOO_DIST_VERSION="${CUCKOO_DIST_VERSION:=5.9}"
CUCKOO_DIR="$(cd "$(dirname "$0")/.." && pwd -P)"

. "${CUCKOO_DIR}/manage.sh" $CUCKOO_ACTION --os-name $(basename $0 .sh) --dist-version $CUCKOO_DIST_VERSION --cpu-cores 1 --cpu-threads 1 $@

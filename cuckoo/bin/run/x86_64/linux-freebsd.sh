#
# A desktop-oriented virtual machines management system written in Shell.
#
# Code is available online at https://github.com/magenete/cuckoo
# See LICENSE for licensing information, and README for details.
#
# Copyright (C) 2016 Magenete Systems OÜ.
#


CUCKOO_DIST_VERSION="${CUCKOO_DIST_VERSION:=10.3}"
CUCKOO_DIR="${CUCKOO_DIR:=$(realpath "$(readlink -f "$(dirname "$0")")/../../..")}"

"${CUCKOO_DIR}/manage.sh" --run --arch x86_64 --os-name freebsd --dist-version $CUCKOO_DIST_VERSION --cpu-cores 1 --cpu-threads 1

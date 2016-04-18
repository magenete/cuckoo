
CUCKOO_OS="${CUCKOO_OS:=linux}"
CUCKOO_DIST_VERSION="${CUCKOO_DIST_VERSION:=}"
if [ -z "$CUCKOO_DIST_VERSION" ]
then
    CUCKOO_DIST_VERSION_DIR=""
else
    CUCKOO_DIST_VERSION_DIR="${CUCKOO_DIST_VERSION}/"
fi
CUCKOO_HD_DIR="$(cd "$(dirname "$0")/.." && pwd -P)/hd/${CUCKOO_OS}/"
CUCKOO_HD_CLEAN_DIR="${CUCKOO_HD_DIR}clean/"

QEMU_ISO_FILE="${QEMU_ISO_FILE:=}"
if [ ! -z "$QEMU_ISO_FILE" ] && [ -z "$CUCKOO_DIST_VERSION" ]
then
    CUCKOO_DIST_VERSION="$QEMU_ISO_FILE"
    CUCKOO_DIST_VERSION_DIR="${CUCKOO_DIST_VERSION}/"
fi


if [ ! -d "$CUCKOO_HD_CLEAN_DIR" ]
then
    echo "ERROR: Directory '${CUCKOO_HD_CLEAN_DIR}' does not exist"
    exit 1
fi

if [ -z "$CUCKOO_DIST_VERSION" ]
then
    for hd_file in $(ls "$CUCKOO_HD_DIR")
    do
        if [ -f "${CUCKOO_HD_DIR}${hd_file}" ]
        then
            rm -f "${CUCKOO_HD_DIR}${hd_file}"
        fi
    done
else
    rm -rf "${CUCKOO_HD_DIR}${CUCKOO_DIST_VERSION_DIR}"
    mkdir "${CUCKOO_HD_DIR}${CUCKOO_DIST_VERSION_DIR}"
fi


for hd_file in $(ls "${CUCKOO_HD_CLEAN_DIR}")
do
    if [ -f "${CUCKOO_HD_CLEAN_DIR}${hd_file}" ]
    then
        cp "${CUCKOO_HD_CLEAN_DIR}${hd_file}" "${CUCKOO_HD_DIR}${CUCKOO_DIST_VERSION_DIR}${hd_file}"
    fi
done

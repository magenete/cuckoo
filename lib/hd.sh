
CUCKOO_OS="${CUCKOO_OS:=linux}"
CUCKOO_DIST_VERSION="${CUCKOO_DIST_VERSION:=}"
if [ -z "$CUCKOO_DIST_VERSION" ]
then
    CUCKOO_DIST_VERSION_DIR=""
else
    CUCKOO_DIST_VERSION_DIR="${CUCKOO_DIST_VERSION}/"
fi
CUCKOO_ISO_FILE="${CUCKOO_ISO_FILE:=}"
if [ ! -z "$CUCKOO_ISO_FILE" ] && [ -z "$CUCKOO_DIST_VERSION" ]
then
    CUCKOO_DIST_VERSION="$CUCKOO_ISO_FILE"
    CUCKOO_DIST_VERSION_DIR="${CUCKOO_DIST_VERSION}/"
fi

QEMU_HD_DIR="$(cd "$(dirname "$0")/.." && pwd -P)/hd/${CUCKOO_OS}/"
QEMU_HD_CLEAN_DIR="${QEMU_HD_DIR}clean/"

if [ ! -d "$QEMU_HD_CLEAN_DIR" ]
then
    echo "ERROR: Directory '${QEMU_HD_CLEAN_DIR}' does not exist"
    exit 1
fi


if [ -z "$CUCKOO_DIST_VERSION" ]
then
    for hd_file in $(ls "$QEMU_HD_DIR")
    do
        if [ -f "${QEMU_HD_DIR}${hd_file}" ]
        then
            rm -f "${QEMU_HD_DIR}${hd_file}"
        fi
    done
else
    rm -rf "${QEMU_HD_DIR}${CUCKOO_DIST_VERSION_DIR}"
    mkdir -p "${QEMU_HD_DIR}${CUCKOO_DIST_VERSION_DIR}"
fi


for hd_file in $(ls "${QEMU_HD_CLEAN_DIR}")
do
    if [ -f "${QEMU_HD_CLEAN_DIR}${hd_file}" ]
    then
        cp "${QEMU_HD_CLEAN_DIR}${hd_file}" "${QEMU_HD_DIR}${CUCKOO_DIST_VERSION_DIR}${hd_file}"
    fi
done

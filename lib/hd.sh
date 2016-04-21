
. "${CUCKOO_DIR}lib/var.sh"


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
    rm -rf "$QEMU_HD_DIR"
    mkdir -p "$QEMU_HD_DIR"
fi


for hd_file in $(ls "${QEMU_HD_CLEAN_DIR}")
do
    if [ -f "${QEMU_HD_CLEAN_DIR}${hd_file}" ]
    then
        cp "${QEMU_HD_CLEAN_DIR}${hd_file}" "${QEMU_HD_DIR}${hd_file}"
    fi
done

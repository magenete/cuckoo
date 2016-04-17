
CUCKOO_OS="${CUCKOO_OS:=linux}"
CUCKOO_HD_DIR="$(cd "$(dirname "$0")" && pwd -P)/../hd/${CUCKOO_OS}/"
CUCKOO_HD_CLEAN_DIR="${CUCKOO_HD_DIR}clean/"


for hd_file in $(ls "$CUCKOO_HD_DIR")
do
    if [ -f "${CUCKOO_HD_DIR}${hd_file}" ]
    then
        rm -f "${CUCKOO_HD_DIR}${hd_file}"
    fi
done

for hd_file in $(ls "${CUCKOO_HD_CLEAN_DIR}")
do
    if [ -f "${CUCKOO_HD_CLEAN_DIR}${hd_file}" ]
    then
        cp "${CUCKOO_HD_CLEAN_DIR}${hd_file}" "${CUCKOO_HD_DIR}${hd_file}"
    fi
done

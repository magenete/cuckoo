
CUCKOO_DIR="${CUCKOO_DIR:=$(realpath "$(readlink -f "$(dirname "$0")")/../../..")/}"

if [ -z "$QEMU_ARCH_BIN_OS_DIR" ]
then
    . "${CUCKOO_DIR}lib/var.sh"
fi

QEMU_VERSION=""                                         # We build all QEMU versions listed
QEMU_BRANCH="master"                                    # Branch NAME in Git
QEMU_ARCH_LIST="${QEMU_ARCH_BIN_FILE}-softmmu"          # What to emulate
QEMU_GIT_URL="https://github.com/qemu/qemu/archive/${QEMU_BRANCH}.tar.gz"
QEMU_ARCH_BIN_OS_TMP_DIR="${QEMU_ARCH_BIN_OS_DIR}tmp/"  # By default emulators are built in /tmp
QEMU_ARCH_BIN_OS_BRANCH_TMP_DIR="${QEMU_ARCH_BIN_OS_TMP_DIR}qemu-${QEMU_BRANCH}/"


# Preinstall
rm -rf "$QEMU_ARCH_BIN_OS_TMP_DIR"
mkdir -p "$QEMU_ARCH_BIN_OS_TMP_DIR"

echo ""
echo "System packages will be installed for QEMU building ..."
echo ""

# System packages install
. /etc/os-release
case "$ID" in
    debian | ubuntu )
        sudo apt-get install -y libiscsi-dev libsdl2-dev libcap-dev libattr1-dev libpixman-1-dev flex
    ;;
    arch )
        sudo pacman -S --noconfirm libiscsi sdl libcap attr pixman flex
    ;;
    * )
        echo "WARNING: System packages were not installed for '${ID}'!"
    ;;
esac


echo ""
echo "QEMU will be downloaded into '${QEMU_ARCH_BIN_OS_BRANCH_TMP_DIR}' folder ..."
echo ""

# Download
cd "$QEMU_ARCH_BIN_OS_TMP_DIR"
curl -L "$QEMU_GIT_URL" | tar xz


# QEMU version definition
QEMU_VERSION="$(cat --squeeze-blank "${QEMU_ARCH_BIN_OS_BRANCH_TMP_DIR}/VERSION")"


echo ""
echo "QEMU '${QEMU_VERSION}' will be builded into '${QEMU_ARCH_BIN_OS_DIR}${QEMU_VERSION}' folder ..."
echo ""

# QEMU Build
cd "${QEMU_ARCH_BIN_OS_BRANCH_TMP_DIR}"
./configure \
    --prefix=${QEMU_ARCH_BIN_OS_DIR}${QEMU_VERSION} \
    --target-list=${QEMU_ARCH_LIST} \
    --python=/usr/bin/python2 \
    --enable-sdl \
    --enable-kvm \
    --enable-vnc \
    --enable-virtfs \
    --enable-libiscsi \
    --enable-system
make && make install


# VERSION file create
printf "${QEMU_VERSION}" > "${QEMU_ARCH_BIN_OS_DIR}VERSION"


# Clean
rm -rf "$QEMU_ARCH_BIN_OS_TMP_DIR"

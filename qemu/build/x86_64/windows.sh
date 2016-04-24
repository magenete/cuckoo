
QEMU_DIR="${QEMU_DIR:=$(realpath "$(readlink -f "$(dirname "$0")")/../..")/}"


if [ -z "$QEMU_BIN_ARCH_OS_DIR" ]
then
    . "${QEMU_DIR}lib/var.sh"
fi


QEMU_BIN_ARCH_OS_VERSION=""                             # We build all QEMU versions listed
QEMU_BRANCH="master"                                    # Branch NAME in Git
QEMU_ARCH_BUILD_TARGET="${QEMU_ARCH_BIN_FILE}-softmmu"  # What to emulate
QEMU_GIT_URL="https://github.com/qemu/qemu/archive/${QEMU_BRANCH}.tar.gz"
QEMU_BIN_ARCH_OS_TMP_DIR="${QEMU_BIN_ARCH_OS_DIR}tmp/"  # By default emulators are built in /tmp
QEMU_BIN_ARCH_OS_TMP_BRANCH_DIR="${QEMU_BIN_ARCH_OS_TMP_DIR}qemu-${QEMU_BRANCH}/"


# Preinstall
rm -rf "$QEMU_BIN_ARCH_OS_TMP_DIR"
mkdir -p "$QEMU_BIN_ARCH_OS_TMP_DIR"


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
echo "QEMU will be downloaded into '${QEMU_BIN_ARCH_OS_TMP_BRANCH_DIR}' folder ..."
echo ""


# Download
cd "$QEMU_BIN_ARCH_OS_TMP_DIR"
curl -L "$QEMU_GIT_URL" | tar xz


# QEMU version definition
QEMU_BIN_ARCH_OS_VERSION="$(cat --squeeze-blank "${QEMU_BIN_ARCH_OS_TMP_BRANCH_DIR}/VERSION")"
QEMU_BIN_ARCH_OS_VERSION_DIR="${QEMU_BIN_ARCH_OS_DIR}${QEMU_BIN_ARCH_OS_VERSION}/"


echo ""
echo "QEMU '${QEMU_BIN_ARCH_OS_VERSION}' will be builded into '${QEMU_BIN_ARCH_OS_VERSION_DIR}' folder ..."
echo ""


# QEMU Build
cd "${QEMU_BIN_ARCH_OS_TMP_BRANCH_DIR}"
./configure \
    --prefix=${QEMU_BIN_ARCH_OS_DIR}${QEMU_BIN_ARCH_OS_VERSION} \
    --target-list=${QEMU_ARCH_BUILD_TARGET} \
    --python=/usr/bin/python2 \
    --enable-sdl \
    --enable-kvm \
    --enable-vnc \
    --enable-virtfs \
    --enable-libiscsi \
    --enable-system
make && make install


# VERSION file create
printf "${QEMU_BIN_ARCH_OS_VERSION}" > "$QEMU_BIN_ARCH_OS_VERSION_FILE"


# Clean
rm -rf "$QEMU_BIN_ARCH_OS_TMP_DIR"

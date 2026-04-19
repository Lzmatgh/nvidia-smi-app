#!/usr/bin/env bash
set -euo pipefail

VERSION="${1:-0.1.0}"
PACKAGE_NAME="gpu-monitor"
ARCH="all"

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_ROOT="${PROJECT_ROOT}/build/${PACKAGE_NAME}_${VERSION}_${ARCH}"
OUTPUT_DIR="${PROJECT_ROOT}/dist"
OUTPUT_FILE="${OUTPUT_DIR}/${PACKAGE_NAME}_${VERSION}_${ARCH}.deb"

DEFAULT_MAINTAINER_NAME="GPU Monitor Maintainers"
DEFAULT_MAINTAINER_EMAIL="noreply@users.noreply.github.com"
MAINTAINER_NAME="${DEBFULLNAME:-${DEFAULT_MAINTAINER_NAME}}"
MAINTAINER_EMAIL="${DEBEMAIL:-${DEFAULT_MAINTAINER_EMAIL}}"
MAINTAINER="${MAINTAINER_NAME} <${MAINTAINER_EMAIL}>"

rm -rf "${BUILD_ROOT}"
mkdir -p \
  "${BUILD_ROOT}/DEBIAN" \
  "${BUILD_ROOT}/usr/bin" \
  "${BUILD_ROOT}/usr/share/applications" \
  "${BUILD_ROOT}/usr/share/icons/hicolor/scalable/apps" \
  "${BUILD_ROOT}/usr/share/doc/${PACKAGE_NAME}" \
  "${OUTPUT_DIR}"

install -m 0755 "${PROJECT_ROOT}/src/gpu-monitor" "${BUILD_ROOT}/usr/bin/gpu-monitor"
install -m 0755 "${PROJECT_ROOT}/src/gpu-monitor-launcher" "${BUILD_ROOT}/usr/bin/gpu-monitor-launcher"
install -m 0644 "${PROJECT_ROOT}/assets/gpu-monitor.desktop" "${BUILD_ROOT}/usr/share/applications/gpu-monitor.desktop"
install -m 0644 "${PROJECT_ROOT}/assets/gpu-monitor.svg" "${BUILD_ROOT}/usr/share/icons/hicolor/scalable/apps/gpu-monitor.svg"
install -m 0644 "${PROJECT_ROOT}/README.md" "${BUILD_ROOT}/usr/share/doc/${PACKAGE_NAME}/README.md"

cat > "${BUILD_ROOT}/DEBIAN/control" <<EOF
Package: ${PACKAGE_NAME}
Version: ${VERSION}
Section: utils
Priority: optional
Architecture: ${ARCH}
Depends: bash, procps
Maintainer: ${MAINTAINER}
Description: Desktop launcher for watch -n 1 nvidia-smi
 A tiny GPU monitor that opens a terminal window and runs
 watch -n 1 nvidia-smi.
EOF

chmod 0755 "${BUILD_ROOT}/DEBIAN"
chmod 0644 "${BUILD_ROOT}/DEBIAN/control"

dpkg-deb --build --root-owner-group "${BUILD_ROOT}" "${OUTPUT_FILE}"

echo "Built package: ${OUTPUT_FILE}"

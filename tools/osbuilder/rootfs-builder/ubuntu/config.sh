# Copyright (c) 2018 Yash Jain, 2022 IBM Corp.
#
# SPDX-License-Identifier: Apache-2.0

source /etc/os-release
OS_NAME=ubuntu
# This should be Ubuntu's code name, e.g. "focal" (Focal Fossa) for 20.04
OS_VERSION=${OS_VERSION:-${UBUNTU_CODENAME}}
PACKAGES="chrony iptables dbus libprotobuf-dev libprotobuf-c-dev protobuf-c-compiler protobuf-compiler python3-protobuf pkg-config libnet1-dev build-essential libnl-3-dev libcap-dev libgpgme-dev libseccomp-dev libbtrfs-dev"
[ "$AGENT_INIT" = no ] && PACKAGES+=" init"
[ "$MEASURED_ROOTFS" = yes ] && PACKAGES+=" cryptsetup-bin e2fsprogs"
[ "$SECCOMP" = yes ] && PACKAGES+=" libseccomp2"
REPO_URL=http://ports.ubuntu.com

case "$ARCH" in
	aarch64) DEB_ARCH=arm64;;
	ppc64le) DEB_ARCH=ppc64el;;
	s390x) DEB_ARCH="$ARCH";;
	x86_64) DEB_ARCH=amd64; REPO_URL=http://archive.ubuntu.com/ubuntu;;
	*) die "$ARCH not supported"
esac

if [ "$(uname -m)" != "$ARCH" ]; then
	case "$ARCH" in
		ppc64le) cc_arch=powerpc64le;;
		x86_64) cc_arch=x86-64;;
		*) cc_arch="$ARCH"
	esac
	export CC="$cc_arch-linux-gnu-gcc"
fi

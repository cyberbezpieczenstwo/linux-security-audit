#!/usr/bin/env bash

# ------------------------------------------------------------
# updates-check.sh
#
# Linux Updates Security Audit
# Author: Marek "Netbe" Lampart
# GitHub: https://github.com/cyberbezpieczenstwo
# ------------------------------------------------------------

set -euo pipefail

GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
BLUE="\033[0;34m"
NC="\033[0m"

header() {
    echo
    echo -e "${BLUE}====================================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}====================================================${NC}"
}

ok() {
    echo -e "${GREEN}[OK]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

echo
echo "Linux Updates Security Audit"
echo "Author: Marek \"Netbe\" Lampart"
echo

############################################################
header "Operating System"

if [ -f /etc/os-release ]; then

    . /etc/os-release

    echo "Distribution: $PRETTY_NAME"

else

    warn "Cannot detect distribution"

fi


############################################################
header "Kernel Information"

uname -r

############################################################
header "Package Manager Detection"


if command -v apt >/dev/null 2>&1; then

    echo "Package manager: APT"

    echo

    UPDATES=$(apt list --upgradable 2>/dev/null | grep -v "Listing..." | wc -l)

    if [ "$UPDATES" -eq 0 ]; then

        ok "System is up to date"

    else

        warn "$UPDATES package updates available"

        apt list --upgradable 2>/dev/null

    fi


elif command -v dnf >/dev/null 2>&1; then

    echo "Package manager: DNF"

    UPDATES=$(dnf check-update -q || true)

    if [ -z "$UPDATES" ]; then

        ok "System is up to date"

    else

        warn "Updates available"

        dnf check-update

    fi


elif command -v pacman >/dev/null 2>&1; then

    echo "Package manager: Pacman"

    if command -v checkupdates >/dev/null 2>&1; then

        UPDATES=$(checkupdates || true)

        if [ -z "$UPDATES" ]; then

            ok "System is up to date"

        else

            warn "Updates available"

            echo "$UPDATES"

        fi

    else

        warn "Install pacman-contrib for checkupdates"

    fi


elif command -v zypper >/dev/null 2>&1; then

    echo "Package manager: Zypper"

    UPDATES=$(zypper list-updates 2>/dev/null)

    echo "$UPDATES"


else

    error "Unsupported package manager"

fi


############################################################
header "Automatic Updates"


if systemctl list-unit-files | grep -q unattended-upgrades; then

    systemctl status unattended-upgrades --no-pager | head -10

elif systemctl list-unit-files | grep -q dnf-automatic; then

    systemctl status dnf-automatic --no-pager | head -10

else

    warn "No automatic update service detected"

fi


############################################################
header "Last System Update"

if command -v journalctl >/dev/null 2>&1; then

    journalctl --list-boots | head -5

fi


############################################################
header "Security Recommendations"

echo

echo "- Install security updates regularly"
echo "- Enable automatic security updates on servers"
echo "- Reboot after kernel updates"
echo "- Remove unsupported software versions"
echo "- Monitor security advisories"

echo

ok "Update audit completed successfully."

echo

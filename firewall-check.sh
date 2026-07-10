#!/usr/bin/env bash

# ------------------------------------------------------------
# firewall-check.sh
#
# Linux Firewall Audit Script
# Author: Marek "Netbe" Lampart
# GitHub: https://github.com/cyberbezpieczenstwo
# ------------------------------------------------------------

set -e

GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[1;33m"
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

err() {
    echo -e "${RED}[ERROR]${NC} $1"
}

echo
echo "Linux Firewall Audit"
echo "Author: Marek \"Netbe\" Lampart"
echo

#######################################################
header "Operating System"

if [ -f /etc/os-release ]; then
    grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"'
fi

#######################################################
header "UFW"

if command -v ufw >/dev/null 2>&1; then

    STATUS=$(sudo ufw status | head -n1)

    ok "UFW installed"

    echo "$STATUS"

else

    warn "UFW not installed"

fi

#######################################################
header "Firewalld"

if command -v firewall-cmd >/dev/null 2>&1; then

    if systemctl is-active --quiet firewalld; then

        ok "Firewalld is running"

        firewall-cmd --get-default-zone

    else

        warn "Firewalld installed but inactive"

    fi

else

    warn "Firewalld not installed"

fi

#######################################################
header "nftables"

if command -v nft >/dev/null 2>&1; then

    if systemctl is-active --quiet nftables 2>/dev/null; then
        ok "nftables service is active"
    else
        warn "nftables installed"
    fi

    sudo nft list ruleset 2>/dev/null | head -20

else

    warn "nftables not installed"

fi

#######################################################
header "iptables"

if command -v iptables >/dev/null 2>&1; then

    ok "iptables installed"

    sudo iptables -L -n | head -30

else

    warn "iptables not installed"

fi

#######################################################
header "Listening TCP Ports"

if command -v ss >/dev/null 2>&1; then

    sudo ss -tulnp

else

    netstat -tulnp 2>/dev/null

fi

#######################################################
header "Open SSH"

if ss -tln | grep -q ":22 "; then

    warn "SSH port is listening"

else

    ok "SSH not listening"

fi

#######################################################
header "Summary"

echo

echo "Review the following:"

echo "- Firewall enabled"

echo "- Only required ports are listening"

echo "- Remove unused firewall software"

echo "- Disable unnecessary services"

echo "- Restrict SSH access"

echo

ok "Firewall audit completed."

echo

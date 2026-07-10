#!/usr/bin/env bash

# ------------------------------------------------------------
# ssh-hardening.sh
#
# Linux SSH Security Audit
# Author: Marek "Netbe" Lampart
# GitHub: https://github.com/cyberbezpieczenstwo
# ------------------------------------------------------------

set -euo pipefail

GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
BLUE="\033[0;34m"
NC="\033[0m"

SSH_CONFIG="/etc/ssh/sshd_config"

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
echo "Linux SSH Security Audit"
echo "Author: Marek \"Netbe\" Lampart"
echo


############################################################
header "SSH Service Status"


if systemctl list-unit-files | grep -q ssh; then

    if systemctl is-active --quiet ssh || systemctl is-active --quiet sshd; then

        ok "SSH service is running"

    else

        warn "SSH service installed but inactive"

    fi

else

    warn "SSH service not detected"

fi


############################################################
header "SSH Version"


if command -v sshd >/dev/null 2>&1; then

    sshd -V 2>&1

else

    warn "sshd binary not found"

fi


############################################################
header "SSH Configuration"


if [ -f "$SSH_CONFIG" ]; then

    ok "Found $SSH_CONFIG"


    echo
    echo "Important settings:"
    echo


    grep -Ei \
    "PermitRootLogin|PasswordAuthentication|PubkeyAuthentication|PermitEmptyPasswords|MaxAuthTries|X11Forwarding|AllowUsers|AllowGroups|Protocol" \
    "$SSH_CONFIG" 2>/dev/null || true


else

    error "SSH configuration not found"

fi


############################################################
header "Root Login Check"


if grep -Ei "^PermitRootLogin yes" "$SSH_CONFIG" >/dev/null 2>&1; then

    warn "Direct root login over SSH is enabled"

else

    ok "Root SSH login appears restricted"

fi


############################################################
header "Password Authentication"


if grep -Ei "^PasswordAuthentication yes" "$SSH_CONFIG" >/dev/null 2>&1; then

    warn "Password authentication enabled"

    echo "Consider using SSH keys"

else

    ok "Password authentication disabled or restricted"

fi


############################################################
header "Empty Password Check"


if grep -Ei "^PermitEmptyPasswords yes" "$SSH_CONFIG" >/dev/null 2>&1; then

    error "Empty passwords are allowed"

else

    ok "Empty passwords disabled"

fi


############################################################
header "SSH Keys"


for USER_HOME in /home/*; do

    USER=$(basename "$USER_HOME")

    if [ -d "$USER_HOME/.ssh" ]; then

        echo

        echo "User: $USER"

        ls -la "$USER_HOME/.ssh"

    fi

done


############################################################
header "Failed SSH Attempts"


if command -v journalctl >/dev/null 2>&1; then

    journalctl -u ssh --no-pager 2>/dev/null | \
    grep -Ei "failed|invalid" | tail -20 || true

fi


############################################################
header "Listening SSH Port"


if command -v ss >/dev/null 2>&1; then

    ss -tlnp | grep ssh || warn "SSH port not detected"

fi


############################################################
header "Security Recommendations"


echo

echo "- Disable direct root login"
echo "- Use SSH keys instead of passwords"
echo "- Disable empty passwords"
echo "- Consider changing default SSH port only as noise reduction"
echo "- Limit users with AllowUsers or AllowGroups"
echo "- Use Fail2ban or another brute-force protection"
echo "- Keep OpenSSH updated"

echo

ok "SSH security audit completed."

echo

#!/usr/bin/env bash

# ------------------------------------------------------------
# users-audit.sh
#
# Linux User Security Audit
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
echo "Linux Users Security Audit"
echo "Author: Marek \"Netbe\" Lampart"
echo

###############################################################
header "System Information"

if [ -f /etc/os-release ]; then
    grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"'
fi

###############################################################
header "Users with UID 0"

awk -F: '$3 == 0 {print $1}' /etc/passwd

###############################################################
header "Users with Login Shell"

awk -F: '$7 !~ /(nologin|false)$/ {print $1 " -> " $7}' /etc/passwd

###############################################################
header "Users in sudo / wheel"

if getent group sudo >/dev/null; then
    getent group sudo
fi

if getent group wheel >/dev/null; then
    getent group wheel
fi

###############################################################
header "Locked Accounts"

passwd -Sa 2>/dev/null | awk '$2=="L"{print $1}'

###############################################################
header "Accounts Without Password"

awk -F: '($2==""){print $1}' /etc/shadow 2>/dev/null || true

###############################################################
header "Password Expiration"

if command -v chage >/dev/null 2>&1; then

    while IFS=: read -r USER _; do

        if id "$USER" >/dev/null 2>&1; then
            echo
            echo "User: $USER"
            chage -l "$USER" | head -5
        fi

    done < /etc/passwd

fi

###############################################################
header "Last Logins"

if command -v last >/dev/null 2>&1; then

    last -a | head -15

fi

###############################################################
header "Currently Logged Users"

who

###############################################################
header "Users with SSH Keys"

for HOME in /home/*; do

    USER=$(basename "$HOME")

    if [ -f "$HOME/.ssh/authorized_keys" ]; then

        ok "$USER has authorized_keys"

    fi

done

###############################################################
header "Root SSH Login"

if [ -f /etc/ssh/sshd_config ]; then

    grep -Ei "^PermitRootLogin" /etc/ssh/sshd_config || \
    warn "PermitRootLogin not explicitly configured"

fi

###############################################################
header "Accounts with Empty Login Shell"

awk -F: '($7==""){print $1}' /etc/passwd

###############################################################
header "Summary"

echo

echo "Recommended checks:"
echo

echo "- Verify only expected users exist"
echo "- Remove unused accounts"
echo "- Disable direct root SSH login"
echo "- Use SSH keys instead of passwords"
echo "- Review sudo/wheel membership"
echo "- Lock inactive accounts"
echo "- Monitor last login activity"

echo

ok "User audit completed successfully."

echo

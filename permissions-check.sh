#!/usr/bin/env bash

# ------------------------------------------------------------
# permissions-check.sh
#
# Linux Permissions Security Audit
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

echo
echo "Linux Permissions Security Audit"
echo "Author: Marek \"Netbe\" Lampart"
echo

###########################################################
header "Critical file permissions"

for FILE in /etc/passwd /etc/shadow /etc/group /etc/gshadow /etc/sudoers
do
    if [ -e "$FILE" ]; then
        stat -c "%a %U:%G %n" "$FILE"
    fi
done

###########################################################
header "SUID files (first 50)"

find / -xdev -type f -perm -4000 2>/dev/null | head -50

###########################################################
header "SGID files (first 50)"

find / -xdev -type f -perm -2000 2>/dev/null | head -50

###########################################################
header "World writable files (first 50)"

find / -xdev -type f -perm -0002 2>/dev/null | head -50

###########################################################
header "World writable directories (first 50)"

find / -xdev -type d -perm -0002 2>/dev/null | head -50

###########################################################
header "Files without owner"

find / -xdev -nouser 2>/dev/null | head -50

###########################################################
header "Files without group"

find / -xdev -nogroup 2>/dev/null | head -50

###########################################################
header "Home directory permissions"

for DIR in /home/*
do
    [ -d "$DIR" ] || continue
    stat -c "%a %U:%G %n" "$DIR"
done

###########################################################
header "SSH directory permissions"

find /home -maxdepth 2 -type d -name ".ssh" 2>/dev/null | while read DIR
do
    stat -c "%a %U:%G %n" "$DIR"

    if [ -f "$DIR/authorized_keys" ]; then
        stat -c "%a %U:%G %n" "$DIR/authorized_keys"
    fi

    if [ -f "$DIR/id_rsa" ]; then
        stat -c "%a %U:%G %n" "$DIR/id_rsa"
    fi
done

###########################################################
header "Current umask"

umask

###########################################################
header "777 permissions (first 50)"

find / -xdev -perm 777 2>/dev/null | head -50

###########################################################
header "Summary"

echo

echo "Recommended actions:"
echo

echo "- Review unnecessary SUID/SGID binaries"
echo "- Remove world-writable permissions where possible"
echo "- Check files without valid owner/group"
echo "- Ensure ~/.ssh permissions are restrictive"
echo "- Verify critical system files have correct permissions"
echo "- Avoid using 777 permissions"

echo

ok "Permissions audit completed successfully."

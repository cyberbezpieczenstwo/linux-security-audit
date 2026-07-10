#!/usr/bin/env bash

# ------------------------------------------------------------
# run.sh
#
# Linux Security Audit Toolkit Launcher
#
# Author: Marek "Netbe" Lampart
#
# Usage:
# ./run.sh
# ------------------------------------------------------------

set -euo pipefail


GREEN="\033[0;32m"
RED="\033[0;31m"
BLUE="\033[0;34m"
NC="\033[0m"


SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

AUDIT_SCRIPT="$SCRIPT_DIR/scripts/system-security-check.sh"


echo
echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE} Linux Security Audit Toolkit${NC}"
echo -e "${BLUE}============================================${NC}"
echo
echo "Author: Marek \"Netbe\" Lampart"
echo


############################################################
# Check root privileges
############################################################


if [ "$EUID" -ne 0 ]; then

    echo -e "${RED}[ERROR]${NC} This tool requires root privileges."
    echo
    echo "Run:"
    echo
    echo "sudo ./run.sh"
    echo

    exit 1

fi


############################################################
# Check main script
############################################################


if [ ! -f "$AUDIT_SCRIPT" ]; then

    echo -e "${RED}[ERROR]${NC} Missing system-security-check.sh"

    echo
    echo "Expected location:"
    echo "$AUDIT_SCRIPT"

    exit 1

fi


############################################################
# Set executable permissions
############################################################


chmod +x "$SCRIPT_DIR"/scripts/*.sh 2>/dev/null || true



############################################################
# Start audit
############################################################


echo -e "${GREEN}[INFO]${NC} Starting security audit..."
echo


bash "$AUDIT_SCRIPT"



echo
echo -e "${GREEN}[OK]${NC} Audit finished."
echo

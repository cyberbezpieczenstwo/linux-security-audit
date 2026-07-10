#!/usr/bin/env bash

# ------------------------------------------------------------
# system-security-check.sh
#
# Linux Security Audit Toolkit - Main Launcher
#
# Author: Marek "Netbe" Lampart
# GitHub: https://github.com/cyberbezpieczenstwo
#
# Description:
# Runs multiple Linux security audits and generates a report.
# ------------------------------------------------------------

set -euo pipefail


GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
BLUE="\033[0;34m"
NC="\033[0m"


SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

HOSTNAME=$(hostname)

DATE=$(date +"%Y-%m-%d_%H-%M-%S")

REPORT="security-report-${HOSTNAME}-${DATE}.txt"


header() {

    echo
    echo -e "${BLUE}====================================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}====================================================${NC}"

}


info() {

    echo -e "${GREEN}[INFO]${NC} $1"

}


warn() {

    echo -e "${YELLOW}[WARN]${NC} $1"

}


error() {

    echo -e "${RED}[ERROR]${NC} $1"

}



############################################################
# Start
############################################################


clear

echo
echo "Linux Security Audit Toolkit"
echo "Author: Marek \"Netbe\" Lampart"
echo
echo "Host: $HOSTNAME"
echo "Date: $(date)"
echo



############################################################
# System Information
############################################################


{

header "SYSTEM INFORMATION"


echo

echo "Hostname:"
hostname


echo

echo "Kernel:"
uname -r


echo

echo "Architecture:"
uname -m


echo

if [ -f /etc/os-release ]; then

    cat /etc/os-release

fi


} | tee "$REPORT"



############################################################
# Modules
############################################################


MODULES=(

"firewall-check.sh"
"users-audit.sh"
"permissions-check.sh"
"updates-check.sh"
"ssh-hardening.sh"

)



############################################################
# Run audits
############################################################


for MODULE in "${MODULES[@]}"
do


    MODULE_PATH="$SCRIPT_DIR/$MODULE"


    if [ -f "$MODULE_PATH" ]; then


        {

        echo

        echo "Running module: $MODULE"

        echo


        bash "$MODULE_PATH"


        } | tee -a "$REPORT"


    else


        warn "Missing module: $MODULE" | tee -a "$REPORT"


    fi


done



############################################################
# Final summary
############################################################


{


header "FINAL SECURITY CHECK SUMMARY"


echo

echo "Completed modules:"

for MODULE in "${MODULES[@]}"
do

    echo "- $MODULE"

done


echo

echo "Report location:"
echo "$(pwd)/$REPORT"


echo

echo "Recommended actions:"
echo "- Review warnings"
echo "- Fix unnecessary exposed services"
echo "- Keep packages updated"
echo "- Use SSH keys"
echo "- Review user permissions"
echo "- Maintain regular backups"


} | tee -a "$REPORT"



echo

info "Security audit completed."

echo
echo "Report saved:"
echo "$REPORT"

echo

# Linux Security Audit Toolkit

![Linux](https://img.shields.io/badge/Linux-Security-blue)
![Bash](https://img.shields.io/badge/Bash-Script-green)
![Version](https://img.shields.io/badge/version-1.0.0-orange)

A lightweight **Linux security auditing toolkit** written in Bash.

The project provides a collection of scripts designed to help Linux administrators, system engineers, and security enthusiasts perform basic security checks and identify common configuration issues.

Created by:

**Marek "Netbe" Lampart**

Cybersecurity | Linux | Infrastructure

---

## About the project

Linux systems are widely considered secure, but security depends heavily on proper configuration, maintenance, and regular auditing.

This toolkit performs non-invasive security checks including:

- firewall configuration review,
- user account auditing,
- file permission analysis,
- system update checks,
- SSH security review.

The scripts are designed to be:

- simple,
- transparent,
- easy to modify,
- suitable for learning Linux security fundamentals.

---

# Features

## Firewall Audit

Checks:

- UFW status,
- Firewalld status,
- nftables configuration,
- iptables rules,
- listening network ports.

---

## User Security Audit

Checks:

- accounts with UID 0,
- sudo/wheel membership,
- locked accounts,
- users with login shells,
- SSH authorized keys,
- last login activity.

---

## Permissions Audit

Checks:

- SUID binaries,
- SGID files,
- world-writable files,
- world-writable directories,
- files without owners,
- files without groups,
- SSH directory permissions.

---

## Update Security Audit

Checks:

- available system updates,
- Linux kernel version,
- package manager status,
- automatic update configuration.

Supported systems:

- Debian
- Ubuntu
- Linux Mint
- Fedora
- RHEL
- Rocky Linux
- AlmaLinux
- Arch Linux
- openSUSE

---

## SSH Security Audit

Checks:

- SSH service status,
- OpenSSH version,
- root login configuration,
- password authentication,
- empty password settings,
- SSH keys,
- failed login attempts.

---

# Installation

Clone the repository:

```bash
git clone https://github.com/cyberbezpieczenstwo/linux-security-audit.git
```

Enter the directory:

```bash
cd linux-security-audit
```

Make scripts executable:

```bash
chmod +x run.sh scripts/*.sh
```

---

# Usage

Run the complete security audit:

```bash
sudo ./run.sh
```

The toolkit will generate a report:

```
security-report-hostname-date.txt
```

Example:

```
security-report-server01-2026-07-10_16-30-00.txt
```

---

# Project Structure

```
linux-security-audit/

├── run.sh
├── VERSION
├── README.md
│
├── scripts/
│   ├── system-security-check.sh
│   ├── firewall-check.sh
│   ├── users-audit.sh
│   ├── permissions-check.sh
│   ├── updates-check.sh
│   └── ssh-hardening.sh
│
└── docs/
```

---

# Requirements

Recommended:

- Linux operating system
- Bash 4+
- root privileges

Most commands are available by default on modern Linux distributions.

---

# Security Philosophy

This toolkit follows a simple principle:

> Security starts with visibility.

Before improving security, you need to understand the current state of your system.

The scripts do not automatically modify system configuration.

They only collect information and provide recommendations.

Always review findings before applying changes.

---

# Roadmap

Planned features:

- [ ] HTML security report generation
- [ ] Docker security checks
- [ ] Kernel hardening audit
- [ ] Fail2ban detection
- [ ] SELinux/AppArmor checks
- [ ] CIS Benchmark checks
- [ ] Network security module
- [ ] Log analysis module

---

# Disclaimer

This project is intended for:

- educational purposes,
- system administration,
- security auditing.

Always test security changes in a controlled environment before applying them to production systems.

---

# License

MIT License

---

# Author

Marek "Netbe" Lampart

Linux | Cybersecurity | Infrastructure

# 🛡️ Linux Security Audit Toolkit

A practical Linux security auditing and host-hardening toolkit built as part of my **Cloud Security Engineering journey**.

The project automates common Linux security checks and produces useful information for security assessment, system hardening, and incident investigation.

> **Project Status:** 🚧 In Development

---

## 🎯 Project Objective

The goal of this project is to build a lightweight Linux security auditing tool that can help identify:

- Suspicious or unnecessary users
- Privileged accounts
- Dangerous file permissions
- SUID/SGID binaries
- Listening network services
- Running processes
- Security-relevant system services
- Important authentication and system logs
- Security baseline violations
- Potential indicators of compromise

This project is intentionally being developed **step-by-step**, with each module tested on a real Linux system.

---

## 🧠 Security Concepts Covered

This project applies practical knowledge of:

- Linux users and groups
- Linux file permissions
- `sudo` and privilege escalation
- SUID / SGID / Sticky Bit
- ACLs
- SELinux
- `systemd`
- Linux processes
- Network sockets
- `firewalld`
- SSH hardening
- `journalctl`
- Apache logs
- `auditd`
- File integrity monitoring
- Incident response
- Security baselines

---

## 🏗️ Project Architecture

```text
                 Linux Host
                     │
                     ▼
            ┌─────────────────┐
            │ Security Audit  │
            │    Toolkit      │
            └────────┬────────┘
                     │
       ┌─────────────┼─────────────┐
       │             │             │
       ▼             ▼             ▼
   System         User &        Network
   Audit         Privilege       Audit
       │             │             │
       └─────────────┼─────────────┘
                     │
                     ▼
                Process Audit
                     │
                     ▼
                  Log Audit
                     │
                     ▼
              Security Baseline
                     │
                     ▼
              Risk Assessment
                     │
                     ▼
              Security Report






linux-security-audit-toolkit/
│
├── README.md
│
├── scripts/
│   ├── system_audit.sh
│   ├── user_audit.sh
│   ├── network_audit.sh
│   ├── process_audit.sh
│   └── log_audit.sh
│
├── config/
│   └── security-baseline.conf
│
├── reports/
│   └── sample-report.txt
│
├── docs/
│   ├── methodology.md
│   ├── findings.md
│   └── incident-response.md
│
└── LICENSE

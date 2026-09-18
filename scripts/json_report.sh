#!/bin/bash

OUTPUT="reports/security-report.json"

mkdir -p reports

HOSTNAME=$(hostname)
TIMESTAMP=$(date -Iseconds)

# SSH
if systemctl is-active --quiet sshd; then
    SSH_STATUS="RUNNING"
else
    SSH_STATUS="SKIP"
fi

# Firewall
if sudo firewall-cmd --state 2>/dev/null | grep -q "running"; then
    FIREWALL_STATUS="PASS"
else
    FIREWALL_STATUS="FAIL"
fi

# SELinux
SELINUX_STATUS=$(getenforce 2>/dev/null)

if [ "$SELINUX_STATUS" = "Enforcing" ]; then
    SELINUX_RESULT="PASS"
elif [ "$SELINUX_STATUS" = "Permissive" ]; then
    SELINUX_RESULT="WARN"
else
    SELINUX_RESULT="FAIL"
fi

# auditd
if systemctl is-active --quiet auditd; then
    AUDITD_STATUS="PASS"
else
    AUDITD_STATUS="FAIL"
fi

# UID 0
ROOT_ACCOUNTS=$(awk -F: '$3 == 0 {print $1}' /etc/passwd)

if [ "$ROOT_ACCOUNTS" = "root" ]; then
    ROOT_STATUS="PASS"
else
    ROOT_STATUS="FAIL"
fi

# SUID
SUID_COUNT=$(sudo find / -xdev -perm -4000 -type f 2>/dev/null | wc -l)

if [ "$SUID_COUNT" -lt 50 ]; then
    SUID_STATUS="PASS"
else
    SUID_STATUS="WARN"
fi

cat > "$OUTPUT" <<EOF
{
  "tool": "Linux Security Audit Toolkit",
  "timestamp": "$TIMESTAMP",
  "host": "$HOSTNAME",
  "checks": {
    "ssh": "$SSH_STATUS",
    "firewall": "$FIREWALL_STATUS",
    "selinux": "$SELINUX_RESULT",
    "auditd": "$AUDITD_STATUS",
    "uid_0_accounts": "$ROOT_STATUS",
    "suid": "$SUID_STATUS"
  },
  "details": {
    "selinux_mode": "$SELINUX_STATUS",
    "uid_0_accounts": "$ROOT_ACCOUNTS",
    "suid_count": $SUID_COUNT
  }
}
EOF

echo "JSON report generated:"
echo "$OUTPUT"

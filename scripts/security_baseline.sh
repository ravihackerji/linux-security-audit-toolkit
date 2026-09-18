#!/bin/bash

echo "=========================================="
echo "       LINUX SECURITY BASELINE SCAN"
echo "=========================================="

PASS=0
WARN=0
FAIL=0

pass_check() {
    echo "[PASS] $1"
    ((PASS++))
}

warn_check() {
    echo "[WARN] $1"
    ((WARN++))
}

fail_check() {
    echo "[FAIL] $1"
    ((FAIL++))
}


echo
echo "[1] SSH HARDENING"

if systemctl is-active --quiet sshd; then

    SSH_CONFIG=$(sudo sshd -T 2>/dev/null)

    if [ -z "$SSH_CONFIG" ]; then
        warn_check "Unable to determine effective SSH configuration"
    else

        if echo "$SSH_CONFIG" | grep -q "^permitrootlogin no$"; then
            pass_check "SSH root login disabled"
        else
            fail_check "SSH root login is enabled"
        fi

        if echo "$SSH_CONFIG" | grep -q "^passwordauthentication no$"; then
            pass_check "SSH password authentication disabled"
        else
            fail_check "SSH password authentication enabled"
        fi

        if echo "$SSH_CONFIG" | grep -q "^pubkeyauthentication yes$"; then
            pass_check "SSH public-key authentication enabled"
        else
            warn_check "SSH public-key authentication not enabled"
        fi

    fi

else
    echo "[INFO] SSH server is not running"
    echo "[SKIP] SSH configuration checks"
fi

echo
echo "[2] FIREWALL"

if sudo firewall-cmd --state 2>/dev/null | grep -q "running"; then
    pass_check "firewalld is running"
else
    fail_check "firewalld is not running"
fi

echo
echo "[3] SELINUX"

SELINUX_STATUS=$(getenforce 2>/dev/null)

if [ "$SELINUX_STATUS" = "Enforcing" ]; then
    pass_check "SELinux is enforcing"
elif [ "$SELINUX_STATUS" = "Permissive" ]; then
    warn_check "SELinux is permissive"
else
    fail_check "SELinux is disabled or unavailable"
fi

echo
echo "[4] AUDITD"

if systemctl is-active --quiet auditd; then
    pass_check "auditd is running"
else
    fail_check "auditd is not running"
fi

echo
echo "[5] ROOT ACCOUNTS"

ROOT_ACCOUNTS=$(awk -F: '$3 == 0 {print $1}' /etc/passwd)
ROOT_COUNT=$(echo "$ROOT_ACCOUNTS" | wc -l)

if [ "$ROOT_COUNT" -eq 1 ]; then
    pass_check "Only one UID 0 account detected: root"
else
    warn_check "Multiple UID 0 accounts detected: $ROOT_ACCOUNTS"
fi

echo
echo "[6] SUID BINARIES"

SUID_COUNT=$(sudo find / -xdev -perm -4000 -type f 2>/dev/null | wc -l)

echo "SUID binaries detected: $SUID_COUNT"

if [ "$SUID_COUNT" -lt 50 ]; then
    pass_check "SUID binary count appears within expected range"
else
    warn_check "Large number of SUID binaries detected"
fi

echo
echo "=========================================="
echo "             SCAN SUMMARY"
echo "=========================================="

echo "PASS : $PASS"
echo "WARN : $WARN"
echo "FAIL : $FAIL"

echo
echo "=========================================="
echo "        SECURITY BASELINE COMPLETE"
echo "=========================================="

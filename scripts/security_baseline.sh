#!/bin/bash

BASELINE_FILE="config/security-baseline.conf"

echo "===================================="
echo "       LINUX SECURITY BASELINE"
echo "===================================="

if [ ! -f "$BASELINE_FILE" ]; then
    echo "[ERROR] Baseline configuration not found:"
    echo "$BASELINE_FILE"
    exit 1
fi

source "$BASELINE_FILE"

PASS=0
WARN=0
FAIL=0
SKIP=0

check_pass() {
    echo "[PASS] $1"
    ((PASS++))
}

check_warn() {
    echo "[WARN] $1"
    ((WARN++))
}

check_fail() {
    echo "[FAIL] $1"
    ((FAIL++))
}

check_skip() {
    echo "[SKIP] $1"
    ((SKIP++))
}

echo
echo "[+] Checking SSH Service"

SSH_STATUS=$(systemctl is-active sshd 2>/dev/null)

if [ "$SSH_STATUS" = "active" ]; then

    echo "[+] SSH server is active"

    SSH_ROOT=$(sudo sshd -T 2>/dev/null | awk '/^permitrootlogin / {print $2}')

    if [ -n "$SSH_ROOT" ]; then
        if [ "$SSH_ROOT" = "$SSH_ROOT_LOGIN" ]; then
            check_pass "SSH root login is disabled"
        else
            check_fail "SSH root login configuration is: $SSH_ROOT"
        fi
    else
        check_warn "Unable to determine SSH root login configuration"
    fi

    SSH_PASSWORD=$(sudo sshd -T 2>/dev/null | awk '/^passwordauthentication / {print $2}')

    if [ -n "$SSH_PASSWORD" ]; then
        if [ "$SSH_PASSWORD" = "$SSH_PASSWORD_AUTH" ]; then
            check_pass "SSH password authentication is disabled"
        else
            check_fail "SSH password authentication is enabled"
        fi
    else
        check_warn "Unable to determine SSH password authentication configuration"
    fi

else

    check_skip "SSH server is not active; SSH configuration checks skipped"

fi


echo
echo "[+] Checking SELinux"

SELINUX=$(getenforce 2>/dev/null)

if [ "$SELINUX" = "$SELINUX_MODE" ]; then
    check_pass "SELinux is enforcing"
else
    check_fail "SELinux mode is $SELINUX"
fi


echo
echo "[+] Checking Firewall"

FIREWALL=$(sudo firewall-cmd --state 2>/dev/null | tr -d '[:space:]')

if [ "$FIREWALL" = "running" ]; then
    check_pass "firewalld is running"
else
    check_fail "firewalld is not running"
fi


echo
echo "[+] Checking Auditd"

AUDITD=$(systemctl is-active auditd 2>/dev/null)

if [ "$AUDITD_REQUIRED" = "yes" ] && [ "$AUDITD" = "active" ]; then
    check_pass "auditd is active"
else
    check_fail "auditd is not active"
fi


echo
echo "[+] Checking UID 0 Accounts"

UID0=$(awk -F: '$3 == 0 {print $1}' /etc/passwd)

echo "$UID0"

UID0_COUNT=$(echo "$UID0" | wc -l)

if [ "$UID0_COUNT" -eq 1 ]; then
    check_pass "Only one UID 0 account detected"
else
    check_warn "Multiple UID 0 accounts detected"
fi


echo
echo "===================================="
echo "          SECURITY SUMMARY"
echo "===================================="

echo "PASS : $PASS"
echo "WARN : $WARN"
echo "FAIL : $FAIL"
echo "SKIP : $SKIP"

echo
echo "===================================="
echo "       BASELINE SCAN COMPLETE"
echo "===================================="

#!/bin/bash
#!/bin/bash

# ==========================================
# Linux Security Audit Toolkit
# Findings Engine
# ==========================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
REPORT_DIR="$PROJECT_ROOT/reports"

FINDINGS_FILE="$REPORT_DIR/findings.txt"

mkdir -p "$REPORT_DIR"

# Start a fresh findings file
> "$FINDINGS_FILE"

add_finding() {
    local ID="$1"
    local CATEGORY="$2"
    local SEVERITY="$3"
    local TITLE="$4"
    local EVIDENCE="$5"
    local RECOMMENDATION="$6"

    {
        echo "=========================================="
        echo "FINDING ID    : $ID"
        echo "CATEGORY      : $CATEGORY"
        echo "SEVERITY      : $SEVERITY"
        echo "TITLE         : $TITLE"
        echo
        echo "EVIDENCE:"
        echo "$EVIDENCE"
        echo
        echo "RECOMMENDATION:"
        echo "$RECOMMENDATION"
        echo
        echo "STATUS        : OPEN"
        echo "=========================================="
        echo
    } >> "$FINDINGS_FILE"
}

echo "Findings engine initialized."
echo "Output: $FINDINGS_FILE"
REPORT="reports/security-report.txt"

mkdir -p reports

> "$REPORT"

echo "==========================================" | tee -a "$REPORT"
echo "       LINUX SECURITY AUDIT REPORT"       | tee -a "$REPORT"
echo "==========================================" | tee -a "$REPORT"

echo "Generated: $(date)" | tee -a "$REPORT"
echo "Host: $(hostname)" | tee -a "$REPORT"
echo

PASS=0
WARN=0
FAIL=0
SKIP=0

finding() {
    ID="$1"
    SEVERITY="$2"
    CATEGORY="$3"
    TITLE="$4"
    EVIDENCE="$5"
    RECOMMENDATION="$6"

    echo "------------------------------------------" | tee -a "$REPORT"
    echo "Finding ID     : $ID" | tee -a "$REPORT"
    echo "Severity       : $SEVERITY" | tee -a "$REPORT"
    echo "Category       : $CATEGORY" | tee -a "$REPORT"
    echo "Title          : $TITLE" | tee -a "$REPORT"
    echo "Evidence       : $EVIDENCE" | tee -a "$REPORT"
    echo "Recommendation : $RECOMMENDATION" | tee -a "$REPORT"
    echo "------------------------------------------" | tee -a "$REPORT"
}

echo
echo "[1] SSH SECURITY" | tee -a "$REPORT"

if systemctl is-active --quiet sshd; then

    SSH_CONFIG=$(sudo sshd -T 2>/dev/null)

    if [ -z "$SSH_CONFIG" ]; then
        finding \
        "LSA-SSH-001" \
        "MEDIUM" \
        "SSH" \
        "Unable to determine effective SSH configuration" \
        "sshd -T returned no configuration" \
        "Validate the SSH server configuration and host key setup."

        ((WARN++))
    else

        if echo "$SSH_CONFIG" | grep -q "^permitrootlogin no$"; then
            echo "[PASS] SSH root login disabled" | tee -a "$REPORT"
            ((PASS++))
        else
            finding \
            "LSA-SSH-002" \
            "HIGH" \
            "SSH" \
            "SSH root login is enabled" \
            "permitrootlogin is not set to no" \
            "Disable direct SSH login for the root account."
            ((FAIL++))
        fi

        if echo "$SSH_CONFIG" | grep -q "^passwordauthentication no$"; then
            echo "[PASS] SSH password authentication disabled" | tee -a "$REPORT"
            ((PASS++))
        else
            finding \
            "LSA-SSH-003" \
            "HIGH" \
            "SSH" \
            "SSH password authentication is enabled" \
            "passwordauthentication is not set to no" \
            "Use SSH public-key authentication and disable password authentication where appropriate."
            ((FAIL++))
        fi

    fi

else
    echo "[SKIP] SSH server is not running" | tee -a "$REPORT"
    ((SKIP++))
fi


echo
echo "[2] FIREWALL SECURITY" | tee -a "$REPORT"

if sudo firewall-cmd --state 2>/dev/null | grep -q "running"; then
    echo "[PASS] firewalld is running" | tee -a "$REPORT"
    ((PASS++))
else
    finding \
    "LSA-FW-001" \
    "HIGH" \
    "Firewall" \
    "Host firewall is not running" \
    "firewalld is inactive" \
    "Enable and configure a host-based firewall."
    ((FAIL++))
fi


echo
echo "[3] SELINUX SECURITY" | tee -a "$REPORT"

SELINUX_STATUS=$(getenforce 2>/dev/null)

if [ "$SELINUX_STATUS" = "Enforcing" ]; then
    echo "[PASS] SELinux is enforcing" | tee -a "$REPORT"
    ((PASS++))
elif [ "$SELINUX_STATUS" = "Permissive" ]; then
    finding \
    "LSA-SEL-001" \
    "MEDIUM" \
    "SELinux" \
    "SELinux is running in permissive mode" \
    "SELinux status: Permissive" \
    "Review SELinux policies and move to enforcing mode when operationally appropriate."
    ((WARN++))
else
    finding \
    "LSA-SEL-002" \
    "HIGH" \
    "SELinux" \
    "SELinux is disabled or unavailable" \
    "SELinux status: $SELINUX_STATUS" \
    "Enable and configure a mandatory access control system."
    ((FAIL++))
fi


echo
echo "[4] AUDITD SECURITY" | tee -a "$REPORT"

if systemctl is-active --quiet auditd; then
    echo "[PASS] auditd is running" | tee -a "$REPORT"
    ((PASS++))
else
    finding \
    "LSA-AUD-001" \
    "HIGH" \
    "Auditing" \
    "auditd is not running" \
    "auditd service is inactive" \
    "Enable auditd and configure persistent security audit rules."
    ((FAIL++))
fi


echo
echo "[5] PRIVILEGED ACCOUNTS" | tee -a "$REPORT"

ROOT_ACCOUNTS=$(awk -F: '$3 == 0 {print $1}' /etc/passwd)

if [ "$ROOT_ACCOUNTS" = "root" ]; then
    echo "[PASS] Only root has UID 0" | tee -a "$REPORT"
    ((PASS++))
else
    finding \
    "LSA-ACC-001" \
    "HIGH" \
    "Identity" \
    "Multiple UID 0 accounts detected" \
    "$ROOT_ACCOUNTS" \
    "Review all UID 0 accounts and remove unnecessary privileged identities."
    ((FAIL++))
fi


echo
echo "[6] SUID SECURITY" | tee -a "$REPORT"

SUID_COUNT=$(sudo find / -xdev -perm -4000 -type f 2>/dev/null | wc -l)

echo "SUID binaries detected: $SUID_COUNT" | tee -a "$REPORT"

if [ "$SUID_COUNT" -lt 50 ]; then
    echo "[PASS] SUID count is within the current baseline" | tee -a "$REPORT"
    ((PASS++))
else
    finding \
    "LSA-SUID-001" \
    "MEDIUM" \
    "File Permissions" \
    "Large number of SUID binaries detected" \
    "$SUID_COUNT SUID binaries found" \
    "Review SUID binaries and remove the SUID bit from unnecessary executables."
    ((WARN++))
fi


echo
echo "==========================================" | tee -a "$REPORT"
echo "              SUMMARY"                    | tee -a "$REPORT"
echo "==========================================" | tee -a "$REPORT"

echo "PASS : $PASS" | tee -a "$REPORT"
echo "WARN : $WARN" | tee -a "$REPORT"
echo "FAIL : $FAIL" | tee -a "$REPORT"
echo "SKIP : $SKIP" | tee -a "$REPORT"

echo
echo "Report saved to: $REPORT" | tee -a "$REPORT"

echo "==========================================" | tee -a "$REPORT"
echo "          AUDIT REPORT COMPLETE"           | tee -a "$REPORT"
echo "==========================================" | tee -a "$REPORT"

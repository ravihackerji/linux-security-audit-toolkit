#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

PASS=0
FAIL=0
SKIP=0

echo "=========================================="
echo "       LINUX SECURITY AUDIT TOOLKIT"
echo "=========================================="
echo "Host: $(hostname)"
echo "Date: $(date)"
echo

run_module() {
    local MODULE="$1"
    local NAME="$2"

    echo
    echo "=========================================="
    echo "[+] $NAME"
    echo "=========================================="

    if [ ! -f "$SCRIPT_DIR/$MODULE" ]; then
        echo "[SKIP] Module not found: $MODULE"
        SKIP=$((SKIP + 1))
        return
    fi

    if [ ! -x "$SCRIPT_DIR/$MODULE" ]; then
        chmod +x "$SCRIPT_DIR/$MODULE"
    fi

    if "$SCRIPT_DIR/$MODULE"; then
        PASS=$((PASS + 1))
    else
        FAIL=$((FAIL + 1))
        echo "[FAIL] $NAME returned an error"
    fi
}

run_module "system_audit.sh" "System Audit"
run_module "user_audit.sh" "User & Privilege Audit"
run_module "network_audit.sh" "Network Audit"
run_module "process_audit.sh" "Process Audit"
run_module "log_audit.sh" "Log Audit"
run_module "service_audit.sh" "Service Audit"
run_module "persistence_audit.sh" "Persistence Audit"
run_module "security_baseline.sh" "Security Baseline"

echo
echo "=========================================="
echo "             AUDIT SUMMARY"
echo "=========================================="
echo "Modules completed : $PASS"
echo "Modules failed    : $FAIL"
echo "Modules skipped   : $SKIP"
echo
echo "Reports directory:"
echo "$PROJECT_ROOT/reports"
echo
echo "=========================================="
echo "       SECURITY ASSESSMENT COMPLETE"
echo "=========================================="

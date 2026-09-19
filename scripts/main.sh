#!/bin/bash

# ==========================================
# Linux Security Audit Toolkit
# Main Controller
# ==========================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "=========================================="
echo "       LINUX SECURITY AUDIT TOOLKIT"
echo "=========================================="

echo
echo "[+] Project:"
echo "$PROJECT_ROOT"

echo
echo "[+] Starting security assessment..."

run_module() {
    local MODULE="$1"
    local DESCRIPTION="$2"

    echo
    echo "------------------------------------------"
    echo "[+] $DESCRIPTION"
    echo "------------------------------------------"

    if [ -x "$SCRIPT_DIR/$MODULE" ]; then
        "$SCRIPT_DIR/$MODULE"
    else
        echo "[SKIP] $MODULE not found or not executable"
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
echo "       SECURITY ASSESSMENT COMPLETE"
echo "=========================================="

echo
echo "[+] Generated reports are stored in:"
echo "$PROJECT_ROOT/reports"

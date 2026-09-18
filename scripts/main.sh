#!/bin/bash

# ==========================================
# Linux Security Audit Toolkit
# Main Orchestrator
# ==========================================

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SCRIPTS="$PROJECT_ROOT/scripts"

echo "=========================================="
echo "     LINUX SECURITY AUDIT TOOLKIT"
echo "=========================================="
echo
echo "Host       : $(hostname)"
echo "User       : $(whoami)"
echo "Date       : $(date)"
echo "Project    : $PROJECT_ROOT"
echo

run_module() {
    MODULE="$1"

    echo
    echo "=========================================="
    echo "Running: $MODULE"
    echo "=========================================="

    if [ -x "$SCRIPTS/$MODULE" ]; then
        "$SCRIPTS/$MODULE"
    else
        echo "[ERROR] Module not found or not executable:"
        echo "$SCRIPTS/$MODULE"
    fi
}

run_module "system_audit.sh"
run_module "user_audit.sh"
run_module "network_audit.sh"
run_module "process_audit.sh"
run_module "log_audit.sh"
run_module "service_audit.sh"
run_module "persistence_audit.sh"
run_module "file_integrity.sh"
run_module "security_baseline.sh"
run_module "findings_engine.sh"
run_module "json_report.sh"

echo
echo "=========================================="
echo "       FULL SECURITY AUDIT COMPLETE"
echo "=========================================="

echo
echo "Reports:"
echo "  Text : $PROJECT_ROOT/reports/security-report.txt"
echo "  JSON : $PROJECT_ROOT/reports/security-report.json"

echo
echo "Toolkit execution completed."

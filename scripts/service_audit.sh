#!/bin/bash

# ==========================================
# Linux Security Audit Toolkit
# Service Security Audit
# ==========================================

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CONFIG_FILE="$PROJECT_ROOT/config/allowed-services.conf"

echo "=========================================="
echo "        LINUX SERVICE SECURITY AUDIT"
echo "=========================================="

if [ ! -f "$CONFIG_FILE" ]; then
    echo "[ERROR] Allowed services configuration not found:"
    echo "$CONFIG_FILE"
    exit 1
fi

echo
echo "[+] Configuration:"
echo "$CONFIG_FILE"

echo
echo "[1] RUNNING SERVICES"

systemctl list-units \
    --type=service \
    --state=running \
    --no-pager

echo
echo "[2] ENABLED SERVICES"

systemctl list-unit-files \
    --type=service \
    --state=enabled \
    --no-pager

echo
echo "[3] FAILED SERVICES"

systemctl --failed --no-pager

echo
echo "[4] NETWORK LISTENING SERVICES"

sudo ss -lntup

echo
echo "[5] APPROVED SERVICE BASELINE"

grep -vE '^[[:space:]]*(#|$)' "$CONFIG_FILE"

echo
echo "[6] BASELINE CHECK"

RUNNING_SERVICES=$(systemctl list-units \
    --type=service \
    --state=running \
    --no-legend \
    --no-pager | awk '{print $1}' | sed 's/\.service$//')

PASS_COUNT=0
WARN_COUNT=0

while read -r SERVICE; do

    [ -z "$SERVICE" ] && continue
    [[ "$SERVICE" =~ ^# ]] && continue

    if echo "$RUNNING_SERVICES" | grep -qx "$SERVICE"; then
        echo "[PASS] $SERVICE is running and approved"
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        echo "[INFO] $SERVICE is approved but not currently running"
    fi

done < "$CONFIG_FILE"

echo
echo "[7] NETWORK LISTENER SUMMARY"

sudo ss -lntup | grep LISTEN || echo "No TCP listeners detected."

echo
echo "=========================================="
echo "          SERVICE AUDIT SUMMARY"
echo "=========================================="

echo "Approved running services : $PASS_COUNT"
echo "Warnings                  : $WARN_COUNT"

echo
echo "=========================================="
echo "        SERVICE AUDIT COMPLETE"
echo "=========================================="

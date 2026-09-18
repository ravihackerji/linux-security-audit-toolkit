#!/bin/bash

echo "=========================================="
echo "        LINUX SERVICE SECURITY AUDIT"
echo "=========================================="

echo
echo "[+] Running Services"
systemctl list-units --type=service --state=running --no-pager

echo
echo "[+] Enabled Services"
systemctl list-unit-files --type=service --state=enabled --no-pager

echo
echo "[+] Failed Services"
systemctl --failed --no-pager

echo
echo "[+] Network Listening Services"
sudo ss -lntup

echo
echo "[+] Service-to-Port Mapping"
sudo ss -lntup | grep LISTEN

echo
echo "[+] Recently Failed Service Logs"
sudo journalctl -p err -b --no-pager | tail -n 20

echo
echo "=========================================="
echo "        SERVICE AUDIT COMPLETE"
echo "=========================================="

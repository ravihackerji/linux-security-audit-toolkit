#!/bin/bash

echo "===================================="
echo "     LINUX SECURITY SYSTEM AUDIT"
echo "===================================="

echo
echo "[+] Hostname"
hostname

echo
echo "[+] Kernel"
uname -r

echo
echo "[+] Operating System"
cat /etc/os-release

echo
echo "[+] Uptime"
uptime

echo
echo "[+] Current User"
whoami

echo
echo "[+] Current Identity"
id

echo
echo "[+] IP Addresses"
ip addr

echo
echo "[+] Listening Ports"
sudo ss -lntp

echo
echo "[+] Running Services"
systemctl list-units --type=service --state=running

echo
echo "===================================="
echo "          AUDIT COMPLETE"
echo "===================================="

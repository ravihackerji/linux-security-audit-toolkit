#!/bin/bash

echo "====================================="
echo "   LINUX NETWORK SECURITY AUDIT"
echo "======================================"

echo 
echo "[+] Network Interfaces"
ip -br addr

echo 
echo "[+] Default Route"
ip route | grep default

echo 
echo "[+] Listening TCP/UDP Ports"
sudo ss -tulnp

echo
echo "[+] Firewall status"
sudo firewall-cmd --state 2>/dev/null || echo "firewall not running/not installed"

echo 
echo "[+] Active Firewall Zone"
sudo firewall-cmd --get-active-zones 2>/dev/null

echo
echo "[+] Firewall Services"
sudo firewall-cmd --list-services 2>/dev/null

echo
echo "[+] Firewall Ports"
sudo firewall-cmd --list-ports 2>/dev/null

echo 
echo "[+] Established Network Connections"
sudo ss -tunp state established

echo 
echo "======================================"
echo "  NETWORK AUDIT COMPLETE "
echo "======================================"

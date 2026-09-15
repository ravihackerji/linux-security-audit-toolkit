#!/bin/bash

echo "================================"
echo "USER & PRIVILEGE SECURITY"
echo "================================"

echo 
echo "[+] Current User"
whoami

echo
echo "[+] UID 0 Accounts"
awk -F: '$3 == 0 {pint $1}' /etc/passwd

echo 
echo "[+] Users in wheel group"
getent group wheel

echo 
echo "[+] Interractive Login Uses"
awk -F: '$7 !~ /(nologin|false)$/ {print $1 ":" $7}' /etc/passwd

echo 
echo "[+] SUID Files"
sudo find / -xdev -perm -4000 -type f 2>/dev/null

echo 
echo "[+] SGID Files"
sudo find / -xdev -perm -2000 -type f 2>/dev/null

echo 
echo "============================="
echo "   USER AUDIT COMPLETE"
echo "============================="

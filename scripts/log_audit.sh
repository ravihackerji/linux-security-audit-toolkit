#!/bin/bash

echo "===================================="
echo "          LINUX LOG SECURITY AUDIT"
echo "===================================="

echo
echo "[+] Recent SSH Successful Logins"
sudo journalctl -u sshd --no-pager | grep -E "Accepted|session opened" | tail -n 20

echo
echo "[+] Recent SSH Failed Authentication"
sudo journalctl -u sshd --no-pager | grep -Ei "Failed|authentication failure|invalid user" | tail -n 20

echo
echo "[+] Recent Sudo Activity"
sudo journalctl --no-pager | grep -Ei "sudo:|COMMAND=" | tail -n 20

echo
echo "[+] User Management Activity"
sudo ausearch -k user_management -i 2>/dev/null | tail -n 30

echo
echo "[+] Privilege Change Activity"
sudo ausearch -k privilege_changes -i 2>/dev/null | tail -n 30

echo
echo "[+] Identity Changes"
sudo ausearch -k identity_changes -i 2>/dev/null | tail -n 30

echo
echo "[+] Recent System Errors"
sudo journalctl -p err -b --no-pager | tail -n 20

echo
echo "[+] Auditd Status"
sudo auditctl -s 2>/dev/null

echo
echo "[+] Apache Access Log"
if [ -f /var/log/httpd/access_log ]; then
    sudo tail -n 20 /var/log/httpd/access_log
else
    echo "Apache access log not found"
fi

echo
echo "[+] Apache Error Log"
if [ -f /var/log/httpd/error_log ]; then
    sudo tail -n 20 /var/log/httpd/error_log
else
    echo "Apache error log not found"
fi

echo
echo "===================================="
echo "          LOG AUDIT COMPLETE"
echo "===================================="

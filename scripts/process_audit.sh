#!/bin/bash

echo "================================"
echo "   LINUX PROCESS SECURITY AUDIT"
echo "================================="


echo 
echo "[+] Current User"
whoami

echo 
echo "[+] Top CPU-Consuming Processess"
ps aux --sort=-%cpu | head -n 11

echo 
echo "[+] Top Memory-Consuming Processes"
ps aux --sort=-%mem | head -n 11

echo
echo "[+] Root-Owned Processes"
ps -eo user,pid,ppid,stat,%cpu,%mem,comm,args | awk '$1 == "root"'

echo 
echo "[+] Processes With Ntwork Connections"
sudo ss -tunp


echo
echo "[+] Process Tree"
pstree -p

echo 
echo"[+] Recently Started Processes"
ps -eo pid,lstart,user,comm,args --sort=start_time | tail -n 15

echo
echo "====================================="
echo "    PROCESS AUDIT COMPLETE"
echo "====================================="

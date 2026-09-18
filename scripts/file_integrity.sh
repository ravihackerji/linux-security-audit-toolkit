#!/bin/bash

BASELINE="reports/file-integrity-baseline.sha256"
CURRENT="reports/file-integrity-current.sha256"

FILES=(
    "/etc/passwd"
    "/etc/shadow"
    "/etc/group"
    "/etc/sudoers"
    "/etc/ssh/sshd_config"
)

echo "=========================================="
echo "        FILE INTEGRITY MONITOR"
echo "=========================================="

mkdir -p reports

echo
echo "[+] Files being monitored"

for FILE in "${FILES[@]}"; do
    if [ -f "$FILE" ]; then
        echo "[MONITOR] $FILE"
    else
        echo "[SKIP] $FILE not found"
    fi
done

echo
echo "[+] Generating current hashes"

> "$CURRENT"

for FILE in "${FILES[@]}"; do
    if [ -f "$FILE" ]; then
        sudo sha256sum "$FILE" >> "$CURRENT"
    fi
done

if [ ! -f "$BASELINE" ]; then

    echo
    echo "[INFO] No baseline exists."
    echo "[+] Creating baseline..."

    cp "$CURRENT" "$BASELINE"

    echo
    echo "[PASS] Baseline created:"
    echo "$BASELINE"

else

    echo
    echo "[+] Comparing current state with baseline..."

    if diff -u "$BASELINE" "$CURRENT" > /tmp/file-integrity-diff.txt; then

        echo "[PASS] No monitored files have changed."

    else

        echo "[ALERT] File integrity changes detected!"
        echo
        cat /tmp/file-integrity-diff.txt

    fi
fi

echo
echo "=========================================="
echo "       FILE INTEGRITY CHECK COMPLETE"
echo "=========================================="

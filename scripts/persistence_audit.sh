#!/bin/bash

echo "=========================================="
echo "        LINUX PERSISTENCE AUDIT"
echo "=========================================="

echo
echo "[1] SYSTEM CRON JOBS"

for FILE in /etc/crontab /etc/cron.d/* /etc/cron.daily/* /etc/cron.hourly/*; do
    if [ -f "$FILE" ]; then
        echo "----- $FILE -----"
        sudo cat "$FILE"
    fi
done

echo
echo "[2] USER CRONTABS"

while IFS=: read -r USER _ UID _ _ HOME _; do
    if sudo crontab -u "$USER" -l 2>/dev/null | grep -v "^#" | grep -q .; then
        echo "----- $USER -----"
        sudo crontab -u "$USER" -l 2>/dev/null
    fi
done < /etc/passwd

echo
echo "[3] SYSTEMD TIMERS"

systemctl list-timers --all --no-pager

echo
echo "[4] ENABLED SYSTEMD SERVICES"

systemctl list-unit-files --type=service --state=enabled --no-pager

echo
echo "[5] SSH AUTHORIZED KEYS"

while IFS=: read -r USER _ UID _ _ HOME _; do
    KEY_FILE="$HOME/.ssh/authorized_keys"

    if [ -f "$KEY_FILE" ]; then
        echo "----- $USER : $KEY_FILE -----"
        sudo cat "$KEY_FILE"
    fi
done < /etc/passwd

echo
echo "[6] USER SHELL STARTUP FILES"

for HOME_DIR in /home/*; do
    if [ -d "$HOME_DIR" ]; then
        for FILE in "$HOME_DIR/.bashrc" "$HOME_DIR/.bash_profile" "$HOME_DIR/.profile"; do
            if [ -f "$FILE" ]; then
                echo "----- $FILE -----"
                grep -nEv '^[[:space:]]*(#|$)' "$FILE"
            fi
        done
    fi
done

echo
echo "[7] SYSTEM STARTUP LOCATIONS"

for DIR in /etc/profile.d /etc/rc.d /etc/systemd/system; do
    echo "----- $DIR -----"
    sudo find "$DIR" -maxdepth 2 -type f -print 2>/dev/null
done

echo
echo "=========================================="
echo "       PERSISTENCE AUDIT COMPLETE"
echo "=========================================="

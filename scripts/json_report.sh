#!/bin/bash

# ==========================================
# Linux Security Audit Toolkit
# JSON Report Generator
# ==========================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

REPORT_DIR="$PROJECT_ROOT/reports"
INPUT_FILE="$REPORT_DIR/findings.txt"
OUTPUT_FILE="$REPORT_DIR/security-report.json"

mkdir -p "$REPORT_DIR"

if [ ! -f "$INPUT_FILE" ]; then
    echo "[ERROR] Findings file not found:"
    echo "$INPUT_FILE"
    exit 1
fi

echo "[" > "$OUTPUT_FILE"

FIRST=true

while IFS= read -r LINE; do

    case "$LINE" in

        "FINDING ID    :"*)
            ID="${LINE#*: }"
            ;;

        "CATEGORY      :"*)
            CATEGORY="${LINE#*: }"
            ;;

        "SEVERITY      :"*)
            SEVERITY="${LINE#*: }"
            ;;

        "TITLE         :"*)
            TITLE="${LINE#*: }"
            ;;

        "STATUS        :"*)
            STATUS="${LINE#*: }"

            if [ "$FIRST" = false ]; then
                echo "," >> "$OUTPUT_FILE"
            fi

            cat >> "$OUTPUT_FILE" <<EOF
  {
    "id": "$ID",
    "category": "$CATEGORY",
    "severity": "$SEVERITY",
    "title": "$TITLE",
    "status": "$STATUS"
  }
EOF

            FIRST=false
            ;;

    esac

done < "$INPUT_FILE"

echo "]" >> "$OUTPUT_FILE"

echo "[+] JSON report generated:"
echo "$OUTPUT_FILE"

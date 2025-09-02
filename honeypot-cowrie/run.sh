#!/usr/bin/env bash
set -euo pipefail

LOG_REAL="var/log/cowrie/cowrie.json"
LOG_DEMO="samples/cowrie_sample.json"
OUT_DIR="results"

mkdir -p "$OUT_DIR"

if [ -f "$LOG_REAL" ]; then
  LOG="$LOG_REAL"; echo "[*] Using real Cowrie logs: $LOG"
else
  LOG="$LOG_DEMO"; echo "[*] Using demo logs: $LOG"
fi

# Requires jq (Linux: sudo apt install -y jq; macOS: brew install jq)
jq -r '
  select(.eventid=="cowrie.login.failed" or .eventid=="cowrie.login.success")
  | [.timestamp, .src_ip, (.username // ""), (.password // ""), .eventid]
  | @csv
' "$LOG" > "$OUT_DIR/events.csv"

jq -r '
  select(.eventid=="cowrie.login.failed") | .src_ip
' "$LOG" \
  | sort | uniq -c | sort -nr | awk '{print $2","$1}' > "$OUT_DIR/top_attackers.csv"

# Optional: export any post-login commands
jq -r '
  select(.eventid=="cowrie.command.input")
  | [.timestamp, .src_ip, (.input // "")]
  | @csv
' "$LOG" > "$OUT_DIR/commands.csv" || true

echo "[*] Wrote $OUT_DIR/events.csv, $OUT_DIR/top_attackers.csv, $OUT_DIR/commands.csv"
# Make it executable (once):
# chmod +x run.sh

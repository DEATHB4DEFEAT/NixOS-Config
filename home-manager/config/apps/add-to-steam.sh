#!/usr/bin/env bash
set -euo pipefail

[ $# -lt 1 ] && exit 1

VDF_PATH="$HOME/.local/share/Steam/userdata/917064496/config/shortcuts.vdf"
TARGET="$(realpath "$1")"
START_DIR="$(dirname "$TARGET")/"
BASE="$(basename "$TARGET")"
NAME="${BASE%.*}"

# Use parent folder name for generic executable names
case "${NAME,,}" in
  game|start|launch|launcher|run)
    NAME="$(basename "$(dirname "$TARGET")")"
    ;;
esac

# Generate Steam's 32-bit unsigned AppID (CRC32 of quoted exe + name | 0x80000000)
QUOTED_EXE="\"$TARGET\""
CRC_HEX=$(python3 -c 'import sys,zlib; print(f"{(zlib.crc32(sys.argv[1].encode())|0x80000000):08x}")' "${QUOTED_EXE}${NAME}" 2>/dev/null || \
  printf '%08x' $(( ($(printf '%s' "${QUOTED_EXE}${NAME}" | gzip -c | tail -c 8 | od -An -tu4 | awk '{print $1}') | 0x80000000) & 0xFFFFFFFF )))

# Convert 8-char big-endian hex AppID to 4 little-endian raw bytes
APPID_BYTES="\x${CRC_HEX:6:2}\x${CRC_HEX:4:2}\x${CRC_HEX:2:2}\x${CRC_HEX:0:2}"

# Ensure shortcuts.vdf exists with valid header + 2 closing 0x08 bytes
if [ ! -f "$VDF_PATH" ] || [ ! -s "$VDF_PATH" ]; then
  mkdir -p "$(dirname "$VDF_PATH")"
  printf '\x00shortcuts\x00\x08\x08' > "$VDF_PATH"
fi

# Back up existing file
cp "$VDF_PATH" "${VDF_PATH}.bak"

# Find the highest numeric shortcut index (supports multi-digit indices like 13, 14, etc.)
LAST_IDX=$(grep -aPo '\x00\K[0-9]+(?=\x00\x02appid\x00)' "$VDF_PATH" | sort -n | tail -n 1 || true)
if [ -z "$LAST_IDX" ]; then
  NEXT_IDX=0
else
  NEXT_IDX=$((LAST_IDX + 1))
fi

# Strip the final 2 closing 0x08 bytes (end of 'shortcuts' map and root map)
truncate -s -2 "$VDF_PATH"

# Append the new binary VDF shortcut entry + 2 closing 0x08 bytes
{
  printf '\x00%s\x00' "$NEXT_IDX"
  printf '\x02appid\x00'"$APPID_BYTES"
  printf '\x01AppName\x00%s\x00' "$NAME"
  printf '\x01Exe\x00%s\x00' "$QUOTED_EXE"
  printf '\x01StartDir\x00%s\x00' "$START_DIR"
  printf '\x01icon\x00\x00'
  printf '\x01ShortcutPath\x00\x00'
  printf '\x01LaunchOptions\x00\x00'
  printf '\x02IsHidden\x00\x00\x00\x00\x00'
  printf '\x02AllowDesktopConfig\x00\x01\x00\x00\x00'
  printf '\x02AllowOverlay\x00\x01\x00\x00\x00'
  printf '\x02OpenVR\x00\x00\x00\x00\x00'
  printf '\x02Devkit\x00\x00\x00\x00\x00'
  printf '\x01DevkitGameID\x00\x00'
  printf '\x02DevkitOverrideAppID\x00\x00\x00\x00\x00'
  printf '\x02LastPlayTime\x00\x00\x00\x00\x00'
  printf '\x01FlatpakAppID\x00\x00'
  printf '\x01sortas\x00\x00'
  printf '\x00tags\x00\x08'
  printf '\x08' # End of entry map
  printf '\x08\x08' # End of 'shortcuts' map and root VDF
} >> "$VDF_PATH"

hyprctl notify "1 2500 rgb(ffffff) fontsize:50 Added to Steam $NAME"

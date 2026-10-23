#!/usr/bin/env bash
set -euo pipefail

PROJECT="$(cd "$(dirname "$0")" && pwd)"
SOURCE="${1:-$HOME/Downloads/OpenLogi-MX-Master-3.png}"
OUTPUT="$PROJECT/design/icon/custom-mx-master-3"
ICONSET="$OUTPUT/OpenLogi.iconset"
TARGET="$PROJECT/crates/openlogi-desktop/icon/AppIcon.icns"

if [[ ! -f "$SOURCE" ]]; then
  echo "ERROR: PNG not found: $SOURCE"
  exit 1
fi

if [[ ! -d "$PROJECT/crates/openlogi-desktop" ]]; then
  echo "ERROR: OpenLogi project not found"
  exit 1
fi

mkdir -p "$ICONSET"

echo "Generating icon sizes..."

for spec in \
  "16:16" \
  "16@2x:32" \
  "32:32" \
  "32@2x:64" \
  "128:128" \
  "128@2x:256" \
  "256:256" \
  "256@2x:512" \
  "512:512" \
  "512@2x:1024"
do
  name="${spec%%:*}"
  size="${spec##*:}"
  sips -s format png -z "$size" "$size" \
    "$SOURCE" \
    --out "$ICONSET/icon_${name}.png" >/dev/null
done

echo "Creating AppIcon.icns..."
iconutil -c icns "$ICONSET" \
  -o "$OUTPUT/AppIcon.icns"

if [[ -f "$TARGET" ]]; then
  BACKUP="${TARGET}.backup.$(date +%Y%m%d-%H%M%S)"
  cp "$TARGET" "$BACKUP"
  echo "Backup: $BACKUP"
fi

mkdir -p "$(dirname "$TARGET")"
cp "$OUTPUT/AppIcon.icns" "$TARGET"

echo ""
echo "SUCCESS"
echo "Generated: $OUTPUT/AppIcon.icns"
echo "Installed: $TARGET"
echo ""
echo "NOTE: Assets.car and openlogi.icon are unchanged."

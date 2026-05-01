#!/usr/bin/env bash
# prepare-svg.sh — Validate and split an SVG into numbered layers for Icon Composer
set -euo pipefail

usage() {
  echo "Usage: $(basename "$0") <input.svg> [output-dir]"
  echo ""
  echo "Validates an SVG file and splits top-level <g> layers into"
  echo "numbered SVG files ready to drag into Icon Composer."
  echo ""
  echo "  input.svg   — SVG exported from Figma / Sketch / Illustrator"
  echo "  output-dir  — Where to write split files (default: ./icon-layers)"
  exit 1
}

[[ $# -lt 1 ]] && usage
command -v xmllint &>/dev/null || { echo "Error: xmllint not found (should be built into macOS)"; exit 1; }

SVG_FILE="$1"
OUTPUT_DIR="${2:-./icon-layers}"
WARNINGS=0

[[ -f "$SVG_FILE" ]] || { echo "Error: File not found: $SVG_FILE"; exit 1; }

warn() { echo "⚠️  $*"; ((WARNINGS++)) || true; }
ok()   { echo "✅ $*"; }
info() { echo "ℹ️  $*"; }

echo ""
echo "🎨 Icon Composer SVG Prep — $(basename "$SVG_FILE")"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# ── Canvas size ──────────────────────────────────────────────────────────────

VIEWBOX=$(xmllint --xpath "string(/*/@viewBox)" "$SVG_FILE" 2>/dev/null || true)
WIDTH=$(xmllint --xpath "string(/*/@width)" "$SVG_FILE" 2>/dev/null || true)
HEIGHT=$(xmllint --xpath "string(/*/@height)" "$SVG_FILE" 2>/dev/null || true)

# Fall back to viewBox dimensions if width/height attributes are absent
if [[ -z "$WIDTH" && -n "$VIEWBOX" ]]; then
  WIDTH=$(echo "$VIEWBOX" | awk '{print $3}')
  HEIGHT=$(echo "$VIEWBOX" | awk '{print $4}')
fi

# Strip units (px, pt, etc.)
WIDTH_NUM=$(echo "$WIDTH" | sed 's/[^0-9.]//g')
HEIGHT_NUM=$(echo "$HEIGHT" | sed 's/[^0-9.]//g')

echo "📐 Canvas: ${WIDTH_NUM}×${HEIGHT_NUM}px"
if [[ "$WIDTH_NUM" == "1024" && "$HEIGHT_NUM" == "1024" ]]; then
  ok "Correct size for iPhone / iPad / Mac (1024×1024)"
elif [[ "$WIDTH_NUM" == "1088" && "$HEIGHT_NUM" == "1088" ]]; then
  ok "Correct size for Apple Watch (1088×1088)"
else
  warn "Unexpected canvas size. Expected 1024×1024 (iPhone/iPad/Mac) or 1088×1088 (Watch)"
fi

# ── Text elements (must be outlines) ─────────────────────────────────────────

echo ""
TEXT_COUNT=$(xmllint --xpath "count(//*[local-name()='text'])" "$SVG_FILE" 2>/dev/null || echo 0)
if [[ "$TEXT_COUNT" -gt 0 ]]; then
  warn "$TEXT_COUNT <text> element(s) found — convert text to outlines in your design tool before importing"
else
  ok "No unresolved text elements"
fi

# ── Filter effects (blurs, drop shadows) ─────────────────────────────────────

FILTER_COUNT=$(xmllint --xpath "count(//*[local-name()='filter'])" "$SVG_FILE" 2>/dev/null || echo 0)
if [[ "$FILTER_COUNT" -gt 0 ]]; then
  warn "$FILTER_COUNT <filter> element(s) found — remove blurs/shadows and re-apply them in Icon Composer"
else
  ok "No filter effects (blur/shadow) found"
fi

# ── Clip paths and masks ──────────────────────────────────────────────────────

CLIP_COUNT=$(xmllint --xpath "count(//*[local-name()='clipPath']) + count(//*[local-name()='mask'])" "$SVG_FILE" 2>/dev/null || echo 0)
if [[ "$CLIP_COUNT" -gt 0 ]]; then
  warn "$CLIP_COUNT clip path / mask element(s) found — do not include the rounded-rect or circle canvas mask; the system applies it automatically"
else
  ok "No clip paths or masks found"
fi

# ── Opacity set on layers ─────────────────────────────────────────────────────

OPACITY_COUNT=$(xmllint --xpath "count(/*/*[local-name()='g'][@opacity])" "$SVG_FILE" 2>/dev/null || echo 0)
if [[ "$OPACITY_COUNT" -gt 0 ]]; then
  warn "$OPACITY_COUNT layer(s) have opacity set — consider removing and tuning opacity in Icon Composer instead"
fi

# ── Layer groups ──────────────────────────────────────────────────────────────

echo ""
LAYER_COUNT=$(xmllint --xpath "count(/*/*[local-name()='g'])" "$SVG_FILE" 2>/dev/null || echo 0)
echo "🗂  Top-level layer groups: $LAYER_COUNT"

if [[ "$LAYER_COUNT" -eq 0 ]]; then
  warn "No top-level <g> groups found — your artwork may be on a single flat layer. Separate into layers in your design tool for maximum control in Icon Composer."
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "$WARNINGS warning(s). No files written."
  echo ""
  exit 0
fi

if [[ "$LAYER_COUNT" -gt 4 ]]; then
  warn "Icon Composer supports a maximum of 4 groups — merge some layers before importing"
fi

# ── Split layers into numbered SVG files ──────────────────────────────────────

mkdir -p "$OUTPUT_DIR"
echo ""
echo "✂️  Splitting into $OUTPUT_DIR/"
echo ""

# Grab all <defs> from the source so referenced gradients/symbols work in each split file
DEFS=$(xmllint --xpath "(//*[local-name()='defs'])[1]" "$SVG_FILE" 2>/dev/null || echo "<defs/>")

# Forward any extra namespace declarations from the source root (e.g. xmlns:inkscape, xmlns:sketch)
EXTRA_NS=$(head -20 "$SVG_FILE" | grep -o 'xmlns:[a-zA-Z]*="[^"]*"' | tr '\n' ' ')

for i in $(seq 1 "$LAYER_COUNT"); do
  LAYER_ID=$(xmllint --xpath "string((/*/*[local-name()='g'])[$i]/@id)" "$SVG_FILE" 2>/dev/null || true)
  LAYER_LABEL=$(xmllint --xpath "string((/*/*[local-name()='g'])[$i]/@*[local-name()='label'])" "$SVG_FILE" 2>/dev/null || true)

  # Prefer the human-readable label (Inkscape/Illustrator) over the raw id
  DISPLAY_NAME="${LAYER_LABEL:-${LAYER_ID:-layer}}"
  SAFE_NAME=$(echo "$DISPLAY_NAME" | sed 's/[^a-zA-Z0-9_-]/-/g' | sed 's/--*/-/g' | sed 's/^-//;s/-$//')
  FILENAME="$(printf '%02d' "$i")-${SAFE_NAME}.svg"

  GROUP=$(xmllint --xpath "(/*/*[local-name()='g'])[$i]" "$SVG_FILE" 2>/dev/null)

  cat > "$OUTPUT_DIR/$FILENAME" <<SVGEOF
<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" $EXTRA_NS viewBox="$VIEWBOX" width="$WIDTH" height="$HEIGHT">
$DEFS
$GROUP
</svg>
SVGEOF

  echo "  → $FILENAME"
done

# ── Summary ───────────────────────────────────────────────────────────────────

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [[ "$WARNINGS" -eq 0 ]]; then
  echo "✅ All checks passed."
  echo ""
  info "Next: drag all files from $OUTPUT_DIR/ into the Icon Composer sidebar."
  info "Files are numbered back→front (01 = background, $LAYER_COUNT$(printf '%02d' "$LAYER_COUNT" | sed 's/./0/g') = foreground)."
else
  echo "⚠️  $WARNINGS warning(s) — review above before importing into Icon Composer."
fi
echo ""

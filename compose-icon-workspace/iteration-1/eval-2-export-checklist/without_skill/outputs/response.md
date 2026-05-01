# Figma Export Checklist & Layer Naming for Icon Composer

## Layer Naming Scheme

Icon Composer (Apple's tool for building `.icns` and app icon sets) works best when your layers are clearly named and grouped. Use the following conventions:

```
icon-root (Frame, 1024×1024)
├── background          ← Gradient background layer
├── shape               ← Main shape / foreground element
└── label               ← Text label
```

### Naming Rules
- Use **lowercase-kebab-case** for all layer names
- Avoid spaces, special characters, or emoji in layer names
- Group related sub-layers under a named parent group (e.g., `shape/body`, `shape/shadow`)
- Avoid default Figma names like "Rectangle 3" or "Group 14"

---

## Export Checklist

### Canvas & Frame Setup
- [ ] Root frame is exactly **1024×1024 px** (this is the master size for app icons)
- [ ] Frame has **no border**, no drop shadow, no clip content issues
- [ ] Color space is set to **sRGB** (Figma default; avoid P3 unless targeting Display P3 icons)

### Background Layer
- [ ] Layer named `background`
- [ ] Gradient is a **fill** on a rectangle that covers the full 1024×1024 frame (not a separate background image)
- [ ] No transparency/opacity less than 100% unless intentional
- [ ] Gradient angles and stops are finalized — Figma gradients export differently than CoreGraphics gradients, so verify visually after export

### Shape Layer
- [ ] Layer named `shape` (or `shape/body`, `shape/highlight` if composite)
- [ ] Vector paths are **flattened/outlined** (no live boolean operations that may not render cleanly on export)
- [ ] Strokes are **outlined** (Outline Stroke) so they export as filled paths
- [ ] Effects (drop shadows, inner shadows) are either flattened in or verified to export correctly as PNG

### Text / Label Layer
- [ ] Layer named `label`
- [ ] Text is **outlined to vector** (Right-click → Outline Stroke, or use Flatten) — embedded fonts may not render correctly
- [ ] Final text size and position is pixel-aligned
- [ ] Color contrast is verified at small sizes (e.g., 16×16, 32×32)

### Export Settings
- [ ] Export format: **PNG**
- [ ] Export at **1x** from the 1024×1024 frame (Icon Composer handles all size generation)
- [ ] No "Include in export" clipping masks or hidden layers unless intentional
- [ ] Each logical layer exported as a **separate PNG** if Icon Composer expects layered input, or as a **flat merged PNG** if a single file is expected
- [ ] File names match layer names: `background.png`, `shape.png`, `label.png`

### Final Validation Before Handing Off
- [ ] Preview each exported PNG at 1024×1024 and at 16×16 (zoom out) for legibility
- [ ] Verify transparent areas (if any) show correct alpha in Preview.app or an alpha-aware viewer
- [ ] Confirm no white fringing on anti-aliased edges (common with "flatten" on complex paths)
- [ ] Run a quick sanity-check in Icon Composer by importing and generating the icon set before final delivery

---

## Quick Reference: File Naming

| Layer Purpose   | Figma Layer Name | Exported File       |
|-----------------|------------------|---------------------|
| Gradient BG     | `background`     | `background.png`    |
| Main shape      | `shape`          | `shape.png`         |
| Text label      | `label`          | `label.png`         |
| Full composite  | `icon-preview`   | `icon-preview.png`  |

---

## Tips
- **Gradient backgrounds**: Figma exports gradients perfectly in PNG, but if you later need to recreate them as native SwiftUI/CoreGraphics gradients, document your stop colors and positions in the Figma annotation panel.
- **Text at small sizes**: Consider removing the text label for icon sizes below 32×32 — it becomes illegible. Icon Composer allows per-size layer overrides.
- **Retina**: If you export manually, export at 2x (2048×2048) for `@2x` assets, but since you're starting at 1024, a single 1x export is standard for Icon Composer input.

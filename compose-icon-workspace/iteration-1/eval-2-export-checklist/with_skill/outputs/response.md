# Figma Export Checklist & Layer Naming for Icon Composer

Here's a specific checklist and naming scheme tailored to your icon (gradient background, main shape, text label).

---

## Layer Naming Scheme

Use numbered names so Icon Composer auto-sorts layers correctly (lower number = further back):

```
01-background     ← your gradient bg — DO NOT export (set directly in Icon Composer)
02-main-shape     ← your primary graphic shape → export as SVG
03-text-label     ← your text — convert to outlines first → export as SVG
```

If you have any shadow or secondary elements between the background and main shape, slot them in:

```
01-background     ← skip export
02-shadow-shape   ← optional drop-shadow element → SVG
03-main-shape     ← primary graphic → SVG
04-text-label     ← text outlines → SVG
```

---

## Export Checklist

### Canvas
- [ ] Canvas is **1024 × 1024 px** (iPhone/iPad/Mac) or **1088 × 1088 px** (Apple Watch)
- [ ] Layers are exported at **full canvas size** — do NOT crop to the content bounds

### What NOT to export
- [ ] **Do not export** the gradient background — set it directly in Icon Composer instead
- [ ] **Do not export** the rounded-rect mask — the system applies it automatically
- [ ] **Do not bake in** blur, shadows, specular highlights, or translucency — these are Icon Composer properties

### Before exporting
- [ ] Text layer (`03-text-label`) converted to **outlines** (Type → Create Outlines in Figma)
- [ ] Any blur or shadow effects removed from Figma layers (keep art flat and opaque)

### Format per layer
| Layer | Format | Why |
|---|---|---|
| `02-main-shape` | **SVG** | Vector path — fully scalable |
| `03-text-label` | **SVG** (outlines) | Vector after outline conversion |
| Any raster/photo content | **PNG** | Transparent background, lossless |
| Gradient if SVG can't express it | **PNG** | Use only if Figma's gradient export looks wrong |

### File quality check
- [ ] SVG files open correctly and show no missing fonts
- [ ] PNG layers have **transparent backgrounds** (no white fill behind artwork)
- [ ] File names match your numbering scheme: `02-main-shape.svg`, `03-text-label.svg`

---

## Quick Summary

Your gradient background is the one element you **skip exporting entirely** — just recreate it as a background gradient in Icon Composer's Inspector. Export only the two artwork layers (`main-shape` and `text-label`) as SVGs at full 1024×1024 canvas size, with text converted to outlines first.

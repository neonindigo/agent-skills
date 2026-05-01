# compose-icon — Reference

## Icon Composer interface overview

| Area | Purpose |
|------|---------|
| **Sidebar (left)** | Canvas, groups, layers — drag to reorder, double-click to rename |
| **Canvas (centre)** | Preview panel + platform/appearance selector at bottom |
| **Inspector (right)** | Appearance properties (Color, Liquid Glass, Composition) + Document settings |

**Toolbar controls (above canvas)**
- Background color well + Background Image pop-up (supports your own images via "Add Background")
- Grid toggle (Light/Dark) — overlay for alignment
- Lighting angle dial — rotate to see specular move
- Preview size selector + Zoom level

---

## Liquid Glass properties — group level

| Property | What it does | Tips |
|----------|-------------|------|
| **Mode** | Individual = glass per layer; Combined = group as one object | Use Combined for tightly grouped shapes |
| **Specular** | Adds blur + edge highlight (the "glass rim") | Turn off for narrow/complex shapes that go pillowy |
| **Blur** | Background blur behind the glass | Higher = more frosted; test on real wallpapers |
| **Translucency** | How much background shows through | Keep low for dark backgrounds |
| **Shadow** | Neutral (default) or Chromatic (color-tinted) | Chromatic looks great on white; switch to neutral for dark/mono via variant |

---

## Color inspector — layer level

| Setting | Options | Notes |
|---------|---------|-------|
| **Fill** | Automatic / None / Solid / Gradient | Automatic pulls from SVG source; override for dark/mono |
| **Opacity** | 0–100% | Useful for revealing layers beneath |
| **Blend Mode** | Standard blend modes | Vary per appearance for maximum control |

To enter exact values: type an equation in any number field (e.g. `35*3` or `*2` to double).

---

## Composition inspector — layer/group level

| Setting | Notes |
|---------|-------|
| **x, y position** | Drag in canvas or enter values; use arrow keys for 1pt nudges |
| **Scale** | Resize within Icon Composer without re-exporting |
| **Visible** | Toggle layer/group visibility per platform |

---

## Per-appearance and per-platform variants

**Scoping a setting to one appearance:**
1. Select the appearance in the canvas (e.g. iOS / Dark)
2. In the inspector, change the Color pop-up from **All** to **Dark** — controls now only affect dark
3. Or: with **All** selected, click **+** next to a property → **Vary for Dark**

**Removing a custom variant:** click the **×** next to the appearance name below the setting.

**Copy/paste styles:** Control-click a layer or group → **Copy Style / Paste Style** (or Edit menu).

---

## Common appearance fixes

### Dark mode — color lost against black
- Select the layer → Color inspector → Fill → change to Solid/Gradient with a lighter value
- If it's a PNG and can't be recolored: create a dark variant in your design tool and import it; use "Replace" in the Image pop-up to swap per-appearance

### Mono — poor contrast
- Icon Composer auto-converts to grayscale — always review it
- Set the primary recognizable element's fill to **white** explicitly
- Map secondary elements to progressively darker grays
- Preview with Tinted on AND off (Mono → Options dialog)

### Specular over-inflating narrow shapes (e.g. Calendar date numbers)
- Select the group → toggle **Specular** off
- Or select the specific layer → toggle **Effects** off under Liquid Glass

### Watch — elements clipped by circle
- Scale up layers that touch the rounded-rect edge until they touch the circle edge
- Or in your design tool, extend artwork to bleed beyond the 1088px circle boundary

---

## Supported import formats

| Format | Use for |
|--------|---------|
| SVG | All flat vector shapes (preferred) |
| PNG | Raster images, complex gradients, elements with transparency |
| JPEG | Photographic backgrounds (no transparency) |

Icon Composer also accepts folders — the folder name becomes the group name, files become layers.

---

## Xcode delivery checklist

- [ ] File saved as `.icon` (not exported — just File → Save)
- [ ] Dragged into Xcode Project navigator into the correct target folder
- [ ] **General → App Icons and Launch Screen → App Icon** field matches filename (no extension)
- [ ] Only one `.icon` file matches the App Icon field name
- [ ] Built and tested in Simulator on all supported platforms
- [ ] Appearance toggled in Simulator settings (Settings → Developer → Dark Appearance)

**Legacy OS support:** Xcode auto-generates backward-compatible icon images at build time from the `.icon` file. If you need your *old* icon on older OS versions, keep using asset catalogs instead of Icon Composer.

---

## Resources

- [Apple Design Resources](https://developer.apple.com/design/resources/) — Figma, Sketch, Photoshop, Illustrator templates
- Illustrator layer-to-SVG export script — downloadable from Apple Design Resources
- WWDC session: *Say hello to the new look of app icons*
- WWDC session: *Create icons with Icon Composer*
- [Human Interface Guidelines — App icons](https://developer.apple.com/design/human-interface-guidelines/app-icons)
- [Adopting Liquid Glass — App icons](https://developer.apple.com/documentation/technologyoverviews/adopting-liquid-glass)

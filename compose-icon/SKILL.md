---
name: compose-icon
description: Guide for creating Liquid Glass app icons using Apple's Icon Composer tool, covering the full pipeline from design tool to Xcode delivery. Use when user mentions Icon Composer, Liquid Glass icons, app icon design, iOS icon, macOS icon, or watchOS icon.
---

# compose-icon

## Quick start — a 2-layer icon (e.g. Messages-style)

1. In Figma/Sketch/Illustrator, draw a **background** layer and a **foreground** layer (e.g. speech bubble) on a 1024×1024 canvas
2. Export each as an SVG (outlines only — no masks, no shadows, no blurs)
3. Open Icon Composer: **Xcode → Open Developer Tool → Icon Composer**
4. Drag both SVGs into the sidebar → they land in one group
5. Select the canvas → pick a background color or system preset in the inspector
6. Select the group → tune **Liquid Glass** (Specular, Blur, Translucency, Shadow)
7. Check all 3 mandatory appearance checkpoints (see below)
8. **File → Save** as `AppIcon.icon` → drag into Xcode Project navigator

---

## Workflow stages

Ask the user which stage they're at, then guide from there:

- **[A] Designing** — canvas size, layer strategy, what to defer to Icon Composer
- **[B] Exporting** — SVG vs PNG, naming conventions, what NOT to export
- **[C] Importing & organising** — groups, layer order, max 4 groups
- **[D] Tuning glass** — per-group Liquid Glass properties, per-appearance variants
- **[E] Appearance review** — dark mode fills, mono legibility, Watch composition
- **[F] Delivery** — save `.icon`, add to Xcode, verify in Simulator

---

## Stage A — Designing

- Use a vector tool (Figma, Sketch, Illustrator, Photoshop)
- Download Apple's icon template from **Apple Design Resources** for the correct grid
- Canvas: **1024×1024** for iPhone/iPad/Mac, **1088×1088** for Watch
- Layers represent **Z-depth** (back = background, front = foreground)
- Separate colors and shapes that you'll want to control independently in Icon Composer
- **Leave for Icon Composer:** blurs, shadows, specular highlights, opacity, translucency, background fills/gradients

## Stage B — Exporting

- Export as **SVG** whenever possible (best scalability)
- Use **PNG** (transparent background) for: raster images, gradients, custom fonts, unsupported SVG features
- Convert text to outlines before SVG export
- Number files in Z-order (e.g. `01-background.svg`, `02-bubble.svg`) — Icon Composer sorts alphabetically
- **Do NOT export** the rounded-rectangle or circle mask — the system applies it automatically

## Stage C — Importing & organising

- Drag SVG/PNG files (or folders) into the sidebar
- Max **4 groups** — each group becomes a layer of glass depth
- Reorder by dragging; rename by double-clicking
- Simple background colors/gradients: set on the **canvas** in the inspector, not as a layer
- In **Document inspector** (top-right button), deselect platforms your app doesn't support

## Stage D — Tuning Liquid Glass

At the **layer** level:
- Toggle **Effects** on/off per layer
- Set **Fill** (None / Solid / Gradient) and **Opacity** under Color

At the **group** level:
- **Mode**: Individual (glass per layer) vs Combined (group as one object)
- **Specular**: on by default — turn off if shapes look too pillowy in narrow areas
- **Blur**, **Translucency**, **Shadow**: dial in for each appearance
- **Chromatic shadows**: great for vibrant colors on white backgrounds; use neutral shadows for dark/mono
- Use **Vary for [appearance]** (click + icon next to any setting) to create per-mode overrides

## Stage E — Mandatory appearance checklist ✓

Work through each platform/appearance combo in the canvas bottom bar:

**Dark mode**
- [ ] Check fills — vibrant colors can get lost against black (change Fill in Color inspector)
- [ ] If using PNG layers that can't be recolored, export a dark variant and import as a variant layer

**Mono (tinted/clear)**
- [ ] At least one element (the most recognizable part) should be **white**
- [ ] Other elements mapped to tones of gray — tune Icon Composer's auto-conversion for contrast
- [ ] Preview over a real wallpaper using **Add Background** in the toolbar

**Watch (circle platform)**
- [ ] Compare rounded-rect vs circle — most icons transfer automatically
- [ ] If elements touch the canvas edge, scale them up to touch the circle edge too
- [ ] Or design with bleed in the source art

## Stage F — Delivery

1. **File → Save** — produces `AppIcon.icon`
2. Drag `.icon` file into Xcode's Project navigator (target folder)
3. In **Project Editor → General → App Icons and Launch Screen**, confirm the App Icon field matches the filename (without extension)
4. Run in Simulator; use **Appearance** settings to test all modes
5. Note: Xcode auto-generates legacy icon images for older OS deployments

---

See [REFERENCE.md](REFERENCE.md) for detailed Liquid Glass property explanations, inspector controls, and advanced variant customisation.

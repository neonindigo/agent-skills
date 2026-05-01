---
name: compose-icon
description: Expert guide for Apple's Icon Composer tool — used to build multilayer Liquid Glass app icons for iOS, iPadOS, macOS, and watchOS from a single .icon file. Use this skill for questions about Icon Composer itself (groups, layers, Individual vs Combined mode, Liquid Glass settings, specular, blur, translucency), preparing and exporting icon artwork from Figma/Sketch/Illustrator/Photoshop (canvas sizes, SVG vs PNG, layer naming), customising appearance variants (dark mode, mono, tinted, clear), platform differences (iPhone vs Mac vs Watch canvas), and adding .icon files to Xcode projects. Also use it when someone asks about the puffy glass effect on their icon, grey blobs in tinted mode, icon colours disappearing in dark mode, backwards compatibility with older iOS, or whether their asset catalog and .icon file will conflict. Do NOT use for: SF Symbols, tvOS/visionOS asset catalogs, widget icons, alternate app icons (UIApplication.setAlternateIconName), tab bar or toolbar icons, or marketing export sizes for web/print.
license: CC-BY-4.0
metadata:
  author: Michael Robinson
  version: 1.0.0
---

# Compose Icon

Help users design, build, and deliver Apple app icons using Icon Composer — Apple's 2025 tool for creating multilayer Liquid Glass icons that adapt across platforms and appearances.

This skill covers the full journey: preparing artwork in design tools → exporting layers → working in Icon Composer → delivering to Xcode. It also helps generate artifacts like layer naming schemes, export checklists, and appearance variant plans.

## Context: What Icon Composer Is

Icon Composer replaces the old approach of generating many icon sizes. You create **one `.icon` file** that the system uses to render your icon at every size, platform, and appearance automatically. Xcode generates compatibility assets for older OS versions at build time.

If your app still supports older OS versions, Icon Composer replaces any existing `AppIcon` asset catalog. If you want your legacy icon to appear on older releases, keep using asset catalogs instead.

Icon Composer is available in beta — launch it from **Xcode → Open Developer Tool → Icon Composer**, or download it standalone from Apple.

## The Workflow at a Glance

```
Design tool (Figma / Sketch / Illustrator / Photoshop)
    ↓  Export layers as SVG or PNG
Icon Composer
    ↓  Tune Liquid Glass, appearances, platforms
Save .icon file
    ↓  Drag into Xcode project
Build & run
```

---

## Phase 1: Designing in Your Design Tool

### Canvas sizes

| Platform | Canvas size |
|---|---|
| iPhone, iPad, Mac | 1024 × 1024 px |
| Apple Watch | 1088 × 1088 px |

Watch uses a larger canvas so the artwork overshoots the rounded-rect mask, matching the same underlying grid as iPhone/Mac. This means designs translate easily between platforms without rescaling — unless elements touch the canvas edge (see Platform Considerations).

Use the official **Apple Design Resources** templates (available for Figma, Sketch, Photoshop, Illustrator) which include the updated grid, shape, and canvas size.

### Layer strategy

Think in **Z-depth**: background at the bottom, foreground elements stacking on top. Each layer becomes a piece of Liquid Glass.

Separate things you'll want to control independently:
- Different colours → separate layers (so you can swap fills in dark/mono mode without re-exporting)
- Text → separate layer (convert to outlines before export, since SVG doesn't preserve fonts)
- Elements that need different opacity or blur → separate layers

**Good rule of thumb:** if you might want to change the fill, opacity, or blend mode of something for dark mode, it should be its own layer.

### What to defer to Icon Composer

Don't bake these into your source file — they're dynamic properties you'll add later:
- Blur, specular highlights, shadows
- Translucency and opacity tweaks
- Background colours and gradients

Keep source art **flat, opaque, graphic**. The simpler the layers, the more control you have in Icon Composer.

### Generating a layer naming plan

When asked to help plan layers, suggest a naming scheme like:

```
01-background     (solid fill or gradient, set in Icon Composer — don't export)
02-shadow-shape   (optional, for drop-shadow elements)
03-mid-element    (secondary graphic)
04-foreground     (most prominent / recognisable element)
05-text           (if any — convert to outlines)
```

Number layers front-to-back (lower = further back) so Icon Composer auto-sorts them correctly on import.

---

## Phase 2: Exporting Layers

### Format choice

| Content | Format |
|---|---|
| Vector shapes, paths | **SVG** (preferred — fully scalable) |
| Raster images, photos, unsupported SVG features | **PNG** (lossless, supports transparency) |
| Text | Convert to outlines → SVG |
| Custom gradients / blend modes that SVG can't express | PNG |

**Always export at canvas size** so layers drop into position automatically in Icon Composer.

**Never export the rounded-rect or circle mask** — the system applies it automatically.

Background colours and simple gradients don't need exporting — set them directly in Icon Composer.

### Illustrator tip
Apple provides a layer-to-SVG export script for Illustrator that automates the process. Download it from Apple Design Resources.

---

## Phase 3: Working in Icon Composer

### Interface overview

| Area | What it does |
|---|---|
| **Sidebar** (left) | Canvas settings, groups, layers — drag files here to import |
| **Canvas** (centre) | Live preview with platform/appearance selector at bottom, simulation controls at top |
| **Inspector** (right) | Appearance properties (Color, Liquid Glass, Composition) + Document settings |

### Initial setup

1. Open Icon Composer, name and save the file (e.g. `AppIcon.icon`)
2. Open **Document inspector** → choose which platforms your app targets (hides irrelevant controls)
3. Select the canvas in the sidebar → Inspector → set background colour or gradient (use a system preset for optimised light/dark backgrounds)

### Importing layers

**Drag and drop** SVG/PNG files into the sidebar — they land in a default group. You can also drag entire folders; folders become groups, files within become layers.

Alternatively: **+ button → New Image** to browse for files.

To replace a layer's graphic later: select the layer → Inspector → Image pop-up → Replace.

### Organising into groups

Groups control Z-depth and Liquid Glass properties. Maximum **4 groups** (Apple's recommended cap for visual complexity).

| Action | How |
|---|---|
| Create group | + → New Group |
| Move layers into groups | Drag in sidebar |
| Reorder | Drag up/down, or Arrange menu |
| Rename | Double-click |
| Hide/show | Hover → eye icon |

Groups render from bottom to top in the sidebar (bottom = furthest back).

### Positioning and scaling

Drag layers directly in the canvas. For precision: Inspector → Composition → Layout (x, y, scale). Use arrow keys for 1pt nudges. **Math works in number fields** — type `35*3` or `*2` to double the current value, `/2` to halve it.

Enable the grid overlay (toolbar Grid button) for alignment. Use **Arrange → Align** and **Arrange → Distribute** for multi-element alignment.

To move multiple elements: Command-click in sidebar or drag a selection box in canvas.

### Inspector tips

- **Copy/Paste Style:** Control-click any setting or section → Copy/Paste [Setting | Section]. Or Control-click a layer/group in the sidebar → Copy Style / Paste Style (also Edit menu). Great for replicating a dark-mode treatment across layers.
- **Undo any Inspector change:** Edit > Undo.

---

## Phase 4: Customising Appearances

### The six appearances

| Appearance | Notes |
|---|---|
| **Default** | Standard light appearance |
| **Dark** | Dark background variant |
| **Clear Light** | Translucent over light wallpaper |
| **Clear Dark** | Translucent over dark wallpaper |
| **Tinted Light** | System colour tint, light |
| **Tinted Dark** | System colour tint, dark |

Icon Composer shows **Default, Dark, and Mono** as the three editing modes. Mono produces all four clear/tinted variants automatically. Click Mono → Options to preview with a specific tint colour or background.

### Appearance controls in the Inspector

The **Color pop-up** (All / Default / Dark / Mono) filters which variant you're editing. Choose **All** to see and manage custom variants in one place.

To create a variant for a specific appearance:
1. **Select that appearance in the canvas first** — this is the key step; the Inspector enables controls for whatever is selected
2. Click the **⊕ icon** next to the property in the Inspector → choose **Vary for [appearance]**
3. A sub-row appears labelled with the appearance; it only applies to that mode

**Shortcut:** Choose the appearance name directly from the Color or Liquid Glass section pop-up (instead of All). Then every control in that section applies only to that appearance. Switch back to **All** to see all variants at once.

To remove a variant: click the X next to the appearance name.

### Common dark mode fixes

**Lost colour:** If a colour disappears against a dark background, add a fill variant for the dark appearance on that layer.

**Missing identity colour:** If your distinctive brand colour gets lost in dark, change the fill for dark mode — don't just rely on the default conversion.

**PNG layers:** If you can't change the fill (e.g., an imported PNG), create a dark-mode version in your design tool and import it as a variant image.

### Mono/tinted considerations

At least one prominent element should be **white** in mono so it reads strongly. Other elements map to grey tones — Icon Composer does an automatic conversion, but tune it for contrast. Avoid all elements being mid-grey.

---

## Phase 5: Liquid Glass

### Group-level controls

Select a group to access Liquid Glass settings:

| Setting | What it does |
|---|---|
| **Mode** | Individual — glass applied per layer. Combined — group treated as one object. |
| **Specular** | Subtle blur + highlight around edges. Toggle off if shapes look too "pillowy" in narrow areas. |
| **Blur** | Background blur visible through translucent areas. |
| **Translucency** | How much background shows through. |
| **Shadow** | Neutral shadows work on any background. Use **Chromatic shadows** when the icon has colour against white — it spills the art colour onto the background for a lighting effect. Add a variant for dark/mono to switch back to neutral there. |

### Layer-level Liquid Glass

Select a layer → Inspector → **Liquid Glass → Effects** toggle. Turn off for individual layers that shouldn't have glass (e.g., a flat opaque background element).

### Tips

- If a layer looks too complex or pillowy in narrow areas → toggle Specular off on its group, or toggle Effects off on the layer entirely.
- Try **Individual** vs **Combined** mode for each group — Combined often looks cleaner for icon elements that should read as one shape.
- Some properties are pre-configured per-appearance (opacity, blend mode, fill) and others apply to all. Use "Vary for" to add per-appearance exceptions.

---

## Phase 6: Platform Considerations

### Rounded rect vs Circle

Watch uses a circle mask; iPhone/iPad/Mac use a rounded rectangle. In most cases the new Watch canvas (1088px) with the same grid means designs translate cleanly.

**Watch-specific checks:**
- Any elements touching the canvas edge → scale them up so they reach the circle edge too
- Consider optical adjustments for the circle shape — a composition that works centred in a rounded rect might feel off in a circle
- Alternatively, design with "bleed" built into the source art

### Platform variants

Use **Composition pop-up → [platform]** in the Inspector to create platform-specific layout variants (position, scale) without affecting appearances. This keeps colour/glass consistent while allowing geometry to vary per platform.

---

## Phase 7: Previewing and Simulating

Toolbar controls (affect preview only, not the icon itself):

| Control | Purpose |
|---|---|
| Background colour well | Test against different solid colours |
| Background Image pop-up | Test against wallpapers / Add your own |
| Background toggle | Switch between colour and image |
| Grid (Light / Dark) | Overlay alignment grid |
| Lighting angle dial | Simulate how light moves across the icon |
| Preview size pop-up | See the icon at specific sizes |
| Zoom | Zoom in/out |

To test Clear/Tinted modes against your own wallpaper: select Mono, toggle Tinted off in Options, then set a custom background image.

---

## Phase 8: Delivering to Xcode

1. **Save** the `.icon` file (File → Save, or click Untitled in toolbar)
2. **Drag** the file into Xcode's Project navigator (into a target folder), or use the + button → Add Files
3. In the **Project Editor**: select your target → General tab → **App Icons and Launch Screen** → confirm the App Icon field matches your file name (without extension)
4. Build and run — verify across platforms and appearances in Simulator
5. In Simulator, use **Appearance settings** to switch Dark/Light and verify all modes

**Note:** One Icon Composer file per App Icon slot. You can have multiple files in the project, but only one matches the name in the App Icon field.

If your app supports older iOS/macOS releases, Xcode auto-generates backwards-compatible icon images from the `.icon` file at build time. If you want a different look on older releases, continue using asset catalogs.

---

## Generating Artifacts on Request

When asked to generate a layer naming plan, export checklist, or appearance variant table, use the formats below.

### Export checklist template

```
□ Canvas: 1024×1024px (iOS/iPadOS/macOS) or 1088×1088px (watchOS)
□ Text layers converted to outlines
□ Mask (rounded rect / circle) NOT exported
□ Background colour NOT exported (set in Icon Composer)
□ Blur / shadow / specular effects removed from source
□ Layers numbered front-to-back: 01-background, 02-..., etc.
□ SVG for vector shapes; PNG for raster/unsupported content
□ PNG layers have transparent backgrounds
□ Exported at full canvas size (not cropped to content)
```

### Appearance variant planning table

| Layer | Default | Dark | Mono |
|---|---|---|---|
| background | [colour] | [darker colour] | auto |
| primary-shape | auto | auto | white |
| secondary-shape | [colour] | [adjusted colour] | mid-grey |
| text/label | white | white | white |

Fill this in with the user's actual layer names and intended colour decisions.

---

## For detailed information, see:

- `references/appearances.md` — Detailed appearance customisation reference, all six modes, tinted previewing
- `references/liquid-glass.md` — Full Liquid Glass settings reference with use cases

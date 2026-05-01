# Getting Started with Icon Composer: Dark Mode & Tinted Appearance

Great news: a simple two-layer icon (background + graphic mark) is the ideal starting point for Icon Composer. Here's how to think about it and where to begin.

---

## The Mental Model: Three Appearances, Two Layers

Icon Composer has three editing modes that cover all six system appearances:

| Mode | What it covers |
|---|---|
| **Default** | Standard light appearance |
| **Dark** | Dark background variant |
| **Mono** | Produces all four clear/tinted variants automatically |

Your background and your graphic mark each become their own layer — and you can vary the fill, opacity, and behaviour of each one per appearance. That's the core of what makes this powerful.

---

## Step 1: Prepare Your Artwork (Before Opening Icon Composer)

Set up your design at **1024 × 1024 px**. Keep things separate and flat:

- **Background layer** — don't export this. You'll set the background colour or gradient directly inside Icon Composer.
- **Graphic mark layer** — export as **SVG** if it's vector (preferred), or **PNG** if it's raster. Export at full canvas size with a transparent background; do NOT crop to the mark itself.

**Don't bake in blur, shadows, glows, or translucency** — those are Liquid Glass properties you control in Icon Composer. Keep the source art flat and opaque.

A simple naming scheme for your two layers:

```
01-background     ← set in Icon Composer, no export needed
02-mark           ← export as SVG or PNG
```

---

## Step 2: Set Up in Icon Composer

1. **Open Icon Composer** (Xcode → Open Developer Tool → Icon Composer, or download standalone from Apple).
2. Name and save your file (e.g. `AppIcon.icon`).
3. Open the **Document inspector** and select your target platforms — this hides irrelevant controls.
4. Select the canvas → **Inspector → Color** → set your background colour or gradient. Use a system preset for automatic light/dark optimisation, or set a custom colour.
5. **Drag your graphic mark SVG/PNG** into the sidebar. It lands in a default group.

---

## Step 3: Think About Dark Mode

With a coloured background + mark, here's what you need to decide:

**Background:**
- If you used a system background preset, it adapts automatically. ✓
- If you chose a custom colour, you'll want to add a **Dark variant**: select the canvas, switch the appearance preview to Dark, then in the Inspector click ⊕ → **Vary for Dark** and choose a darker or adjusted version of your brand colour.

**Graphic mark:**
- If your mark is white or very light, it'll read well on a dark background — you may need no changes.
- If your mark is a colour that could get lost on a dark background, add a Dark variant for that layer's fill: select the layer, switch to Dark appearance, Inspector → ⊕ → **Vary for Dark**.
- If it's a PNG (so you can't change the fill in Inspector), you'll need to create a dark-mode version of the mark in your design tool and import it as a variant image.

---

## Step 4: Think About Tinted/Mono Appearance

The Mono mode automatically converts your icon to greyscale — but you need to ensure it reads well:

- **Your graphic mark should be white** (or become white) in Mono so it stands out against the system-applied tint colour.
- Your background in Mono becomes a medium tone — the system handles this, but you should preview it.
- To preview: click **Mono → Options** and set a tint colour to simulate what it'll look like with a user's chosen system accent colour.

The most important thing in Mono: **avoid your mark and background landing at similar grey tones**. You want contrast. If the automatic conversion looks flat, nudge the mark's Mono fill toward white.

---

## Step 5: Liquid Glass

For your simple two-layer setup:

- **Your mark layer** will have Liquid Glass applied by default — this gives it a subtle specular highlight and sense of depth. This usually looks great for a clean graphic mark.
- **Your background** typically shouldn't have Liquid Glass effects — it should feel solid. Select the layer → Inspector → Liquid Glass → toggle **Effects off**.
- Try **Combined** mode on your group for a clean read (treats the group as one unified glass object rather than individual pieces).

---

## Quick Summary: What to Set Up

| Task | Where |
|---|---|
| Background colour (light) | Canvas → Inspector → Color |
| Background colour (dark variant) | Vary for Dark on canvas color |
| Import graphic mark | Drag SVG/PNG into sidebar |
| Mark fill variant for dark (if needed) | Layer → Inspector → Vary for Dark |
| Mark in Mono (should be white) | Layer → Inspector → Vary for Mono |
| Preview tinted appearance | Mono → Options → set tint colour |
| Liquid Glass on mark | Group → Inspector → Liquid Glass |
| Turn off glass on background | Layer → Inspector → Effects off |

Start with Default, get it right, then switch the canvas to Dark and tweak. Finally, switch to Mono and confirm contrast. That's the whole loop for a simple two-layer icon.

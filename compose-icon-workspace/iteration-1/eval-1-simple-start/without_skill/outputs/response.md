# Getting Started with Icon Composer: Dark Mode & Tinted Appearance

## The Core Concept: Layers Are Everything

Icon Composer (introduced with Xcode 16 / iOS 18) works around a **layered architecture** that lets the system adapt your icon for different appearances. For a simple icon with a colored background and a single graphic mark, you're working with two layers:

- **Background layer** — the solid colored fill behind everything
- **Foreground layer** — your graphic mark

These two layers are treated independently per appearance, which is exactly what enables dark mode and tinting to work well.

---

## Setting Up Your Layers

### 1. Open Icon Composer
In Xcode, select your `AppIcon` asset in the asset catalog and click **Open in Icon Composer** (or launch Icon Composer directly). You'll see a canvas with three appearance tabs: **Light**, **Dark**, and **Tinted**.

### 2. Structure your artwork as separate layers
Even though your design is simple, **do not flatten your background and mark into a single image**. Icon Composer needs them separated:
- Import your graphic mark as the **Foreground** layer (usually an SVG or PDF vector, or a high-res PNG)
- Define the **Background** layer separately — typically a solid color, gradient, or simple shape

Using vector formats (SVG/PDF) for your mark gives you the cleanest results across all sizes and appearances.

---

## Thinking Through Each Appearance

### Light (baseline)
This is your current design. Set the background to your brand color and place the mark on top. This is your starting point — get it looking right here first.

### Dark
For dark mode, the system expects a **darker, moodier feel**. Think about:
- **Background**: Switch to a darker variant of your brand color, a deep neutral, or near-black. High contrast between background and mark is critical.
- **Foreground mark**: Often lightened or made white/near-white so it pops on the dark background. If your mark was dark-on-light, invert that relationship.
- Avoid dark marks on dark backgrounds — the icon will disappear.

### Tinted
This is the most important appearance to reason about carefully:
- The system **ignores your colors entirely** and applies a single monochromatic tint chosen by the user (or derived from their wallpaper).
- Your icon is effectively rendered as a **two-tone silhouette**: light areas and dark areas, recolored by the system.
- What matters is **luminance contrast between layers**, not hue.
- Your mark needs to read clearly as a **shape/silhouette** — fine color details, gradients within the mark, or color-coded elements will all collapse to a single tone.
- The background layer gets the darker tint value; the foreground mark gets the lighter (or you can reverse this, but be consistent).

**Practical tip for tinted**: Squint at your icon. If the mark is still readable as a distinct shape against the background when all color is removed, you're in good shape.

---

## Key Decisions to Make Upfront

| Decision | Why it matters |
|---|---|
| **Foreground as vector vs. raster** | Vectors scale perfectly and look sharp at every size and resolution |
| **Background as a solid color swatch vs. image** | Solid colors are easiest to adapt; if using an image, it must work dark and desaturated |
| **Mark complexity** | Highly detailed or color-dependent marks often look muddy in tinted mode; simpler is better |
| **Contrast ratio** | Must be legible at small sizes (e.g., Spotlight, Settings) in all three modes |
| **Padding/safe zones** | iOS applies a corner radius mask — keep important mark elements away from the edges |

---

## Workflow Suggestion

1. **Start in Light mode** — nail your existing design first.
2. **Switch to Dark** — adjust background to a dark variant, lighten the mark.
3. **Switch to Tinted** — preview how the system renders it. If the mark disappears into the background, increase luminance contrast between your two layers.
4. **Preview at small sizes** — use the size previews in Icon Composer to check legibility at Spotlight/Settings sizes, not just the large App Store size.
5. **Export and test on device** — always check on a real device or simulator with Dark Mode and the "Tinted icons" setting enabled (Settings → Wallpaper → Customize → Icons).

---

## Quick Mental Model

Think of your icon as having **two materials**:
- A **background material** that the system can darken or tint
- A **foreground material** (your mark) that the system can lighten or tint differently

Your job is to make sure those two materials have enough contrast in every appearance so the mark always reads clearly — regardless of the user's chosen tint color or display mode.

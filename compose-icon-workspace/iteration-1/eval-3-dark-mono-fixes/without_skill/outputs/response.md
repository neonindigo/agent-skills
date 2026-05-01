# Fixing Dark Mode and Tinted Mode Issues in Icon Composer

## Problem 1: Bright Orange Disappears in Dark Mode

The issue is insufficient contrast between your orange element and the dark background. In Icon Composer, dark mode icons use a dark background (near-black), and a bright orange can paradoxically lose visibility if it lacks contrast definition at its edges.

**Fixes:**

1. **Edit the Dark variant directly** — In Icon Composer, select the **Dark** appearance tab. Your layers are independent per variant, so changes here won't affect your default icon.

2. **Deepen or warm the orange** — Shift the orange toward a richer, more saturated value (e.g., increase saturation, reduce lightness slightly). Neon/bright oranges can wash out on dark backgrounds at small sizes.

3. **Add a subtle inner glow or stroke** — Apply a very thin (1–2pt) darker outline or a soft inner shadow to the orange element. This gives the eye an edge to lock onto.

4. **Introduce a mid-tone background layer** — Rather than placing the orange directly over pure black, add a dark charcoal or deep grey card/shape behind it. This creates a contrast stepping stone: black → dark grey → orange.

5. **Check luminance, not just hue** — Use the color picker's HSL view. Your dark-mode background will be around L 10–15%. Aim for your orange to sit at L 55–70% in the dark variant so the luminance gap is wide enough.

---

## Problem 2: Everything Looks Like a Grey Blob in Tinted Mode

Tinted mode applies a **monochromatic system tint** to your icon — it desaturates your artwork and overlays the user's chosen accent color. If all your layers are at similar luminance values, they flatten into an undifferentiated mass.

**How tinted mode works:** Icon Composer uses your icon's **luminance (brightness) map**, not its colors, to drive the tinted render. Colors are discarded; only the light/dark structure survives.

**Fixes:**

1. **Create strong luminance separation between layers** — Your background, mid-ground, and foreground elements must differ significantly in brightness. A good target: background ~15–20% luminance, secondary elements ~45–55%, primary elements ~80–90%.

2. **Use the Tinted preview in Icon Composer** — Click the **Tinted** tab while editing. This shows exactly what the monochromatic render will look like. Use it as a live guide while adjusting layer brightness.

3. **Avoid similar-brightness layers** — If your orange element and its background are both "medium" brightness (just different hues), they'll merge in tinted mode. Explicitly darken the background or lighten the foreground in your tinted variant.

4. **Edit the Tinted variant independently** — Icon Composer lets you supply a separate artwork stack for the Tinted appearance. If auto-desaturation of your Default artwork is the problem, switch to the Tinted tab and manually repaint layers using pure greyscale values chosen for contrast.

5. **Leverage the two-layer foreground/background split** — Icon Composer's tinted rendering relies on a clear foreground vs. background separation. Make sure your primary element (the orange shape) is on its own layer, distinctly brighter than whatever sits behind it.

---

## Quick Checklist

| Issue | Root Cause | Fix |
|---|---|---|
| Orange disappears in dark | Low edge contrast against dark bg | Deepen orange, add stroke, add mid-tone bg layer |
| Grey blob in tinted | Layers have similar luminance | Increase luminance spread; use Tinted variant tab |

Both issues are fundamentally about **contrast** — color contrast for dark mode, luminance contrast for tinted mode. Icon Composer's per-variant editing gives you full control over both without touching your default icon.

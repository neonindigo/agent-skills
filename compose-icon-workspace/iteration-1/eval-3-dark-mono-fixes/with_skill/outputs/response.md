# Fixing Dark Mode and Tinted Mode in Icon Composer

Great news — both of these are well-supported workflows in Icon Composer. Here's exactly what to do for each.

---

## Problem 1: Bright orange disappears in dark mode

This is the most common dark mode issue. A saturated, vibrant colour (like your orange) becomes invisible or muddy against a dark background because of how it contrasts with black — the problem isn't your design, it's just that the same fill that pops on white disappears on dark.

**Fix: Add a Dark fill variant for that layer.**

1. In Icon Composer, select **Dark** in the appearance selector at the bottom of the canvas.
2. Select the layer with your orange element in the sidebar.
3. In the **Inspector → Color section**, hover over the **Fill** property — a **⊕ (plus) icon** appears next to it.
4. Click it and choose **Vary for Dark**.
5. A new sub-row appears labelled "Dark" — click the colour swatch and pick a brighter, lighter, or shifted version of your orange that reads well on a dark background.

The original fill continues to apply in Default mode; only Dark gets the new colour. You don't need to re-export anything from your design tool.

> **Tip:** Try boosting the lightness and reducing saturation slightly — pure vivid orange can look harsh on dark; a slightly lighter, warmer orange usually reads better.

**If your orange layer is a PNG** (not vector), you can't remap the fill directly. Instead:
1. Create a dark-optimised version of the artwork in your design tool.
2. Export it.
3. In Icon Composer: select the layer → Inspector → Composition → **Image pop-up → Replace** → pick the dark-version file. This replaces the image only for the currently-selected appearance.

---

## Problem 2: Everything looks like a grey blob in tinted mode

Tinted mode (and Clear mode) are both generated from the **Mono** appearance in Icon Composer — Icon Composer auto-converts your colours to greyscale, which is why it becomes a blob if you haven't tuned it. The fix is to take control of the greyscale mapping manually.

**Fix: Set explicit grey values per layer in Mono.**

1. Select **Mono** in the appearance selector at the bottom of the canvas.
2. For your **most prominent/recognisable element** (likely your orange shape): select it in the sidebar → Inspector → Color → **Fill** → set it to **white** (or near-white). This is the key step — your primary foreground element must be white so it reads strongly over any tint colour.
3. For secondary elements: set them to **50–70% grey** so they're visible but clearly subordinate.
4. Make sure not everything ends up at the same grey value — that's what causes the "grey blob" effect.

**To preview with an actual tint colour:**
1. With Mono selected, click **Options** (it appears near the appearance selector).
2. Toggle **Tinted** on.
3. Select Light or Dark, and drag the colour sliders.
4. Test with the default system blue and also with a red or orange — different tints reveal different contrast problems.

---

## Quick appearance variant plan for your icon

| Layer | Default | Dark | Mono |
|---|---|---|---|
| background | [your light bg colour] | [dark bg colour] | near-black |
| orange element (your key shape) | bright orange | lighter/shifted orange | **white** |
| secondary elements | as designed | check legibility | 50–70% grey |

---

## Summary

| Problem | Root cause | Fix |
|---|---|---|
| Orange disappears in dark | Same fill doesn't work on dark bg | Add a "Vary for Dark" fill variant on that layer |
| Grey blob in tinted mode | Auto greyscale mapping → no contrast | Set primary element to white in Mono; map others to distinct greys |

Both fixes are non-destructive — your Default appearance stays exactly as you designed it.

# Appearances Reference

Detailed reference for all six Icon Composer appearances and how to work with them.

## The Six Appearances Explained

Apple platforms support three base appearances, each with two light/dark variants:

| Appearance | Platform | How it shows |
|---|---|---|
| **Default** | iOS, macOS | Standard light — the base appearance everyone sees |
| **Dark** | iOS, macOS | Explicit dark mode |
| **Clear Light** | iOS, macOS | Wallpaper shows through (light wallpaper context) |
| **Clear Dark** | iOS, macOS | Wallpaper shows through (dark wallpaper context) |
| **Tinted Light** | iOS | System-chosen tint colour over light |
| **Tinted Dark** | iOS | System-chosen tint colour over dark |
| *(none)* | watchOS | No appearance variants on Watch |

In Icon Composer, you edit three modes: **Default**, **Dark**, and **Mono**. The Mono mode produces all four Clear/Tinted variants automatically from one set of settings.

---

## Editing Appearances

### Selecting an appearance to edit

Use the controls at the **bottom of the canvas**:
- Left side: platform (iOS / macOS / watchOS)
- Right side: appearance (Default / Dark / Mono)

What you see in the Inspector and canvas reflects the currently selected combination.

### The Color / Liquid Glass / Composition pop-ups

Each section in the Inspector has a pop-up that controls scope:

| Pop-up value | Meaning |
|---|---|
| **All** | Shows main setting plus any custom per-appearance/platform variants |
| **Default / Dark / Mono** | Only the controls for that appearance are active |
| **iOS / macOS** | Only the controls for that platform are active (Composition section) |

**Best workflow:** Keep the pop-up on **All** while reviewing, switch to the specific appearance pop-up when actively tweaking a variant.

---

## Adding Per-Appearance Variants

To vary a property for a specific appearance:

1. **Select the target appearance in the canvas first** — this enables the Inspector controls for that mode
2. Click the **⊕ icon** next to the property → choose **Vary for [appearance]**
3. A sub-row appears labelled with the appearance; it only applies to that mode

The main setting continues to apply to appearances without a custom variant.

**Shortcut:** Choose the appearance name directly from the Color or Liquid Glass pop-up (instead of All). Every control in that section then scopes to that appearance only. Switch back to All to see all variants.

To remove a variant: click the **X** next to the appearance label.

**Copy/paste style:** Control-click a property or section → Copy/Paste [Setting | Section]. Or Control-click a layer/group → Copy Style / Paste Style (also Edit menu).

---

## Dark Appearance: What to Check

### The two most common dark mode problems

**1. Saturated colour disappears against black**
Symptoms: A vibrant red, blue, or yellow element becomes invisible or muddy.
Fix: Add a fill variant for Dark — brighten or shift the hue so it reads on a dark background.

**2. Brand colour loses its identity**
Symptoms: The distinctive colour that makes your icon recognisable is gone.
Fix: Same as above — don't just rely on the auto-conversion. Actively pick a dark-optimised version of your brand colour.

### Per-property variants for dark

Any colour-related property can vary per appearance:
- **Fill** — most commonly used; change the layer colour for dark
- **Opacity** — sometimes an element needs to be more or less transparent on dark
- **Blend mode** — change how a layer composites in a dark context

### When you can't use Fill (PNG layers)

If the layer is a PNG and you can't remap its colours via Fill, create a dark-variant version of the artwork in your design tool, export it, and import it as a variant:

1. Select the layer in the sidebar
2. Inspector → Composition → Image pop-up → **Replace** → select dark-version PNG
3. This replaces the image for the currently-selected appearance only

---

## Mono Appearance: What to Check

Mono is the most demanding appearance to tune. Icon Composer auto-converts colours to greyscale, but you must review:

### Contrast hierarchy

Set your most prominent/recognisable element to **white** — it needs to pop against any tint colour. Map secondary elements to progressively darker greys so there's clear contrast hierarchy.

Rules of thumb:
- Primary foreground element: white or near-white
- Secondary elements: 50–70% grey
- Background: dark grey or near-black (for tinted) / let the system handle it (for clear)

### Greyscale mapping

The Fill control works in mono just like dark mode — you can set a specific grey value for each layer:
1. Select the layer
2. In Inspector → Color section, ensure the appearance is set to Mono
3. Change Fill to Solid and pick a specific grey

### Previewing tint colours

To check a specific tint:
1. Select Mono in the canvas
2. Click **Options** (appears when Mono is selected)
3. Toggle Tinted on, select Light or Dark, drag the colour sliders

Try the default system blue and also a red/orange — tints across the spectrum reveal contrast problems.

### Clear vs Tinted in preview

Tinted off = Clear mode (no colour overlay, just translucency)
Tinted on = Tinted mode (system colour overlaid)

For Clear mode, set a wallpaper background image in the toolbar to see how translucency reads over a real photo.

---

## watchOS: No Appearances

Watch icons don't have appearance variants. Design once in Icon Composer and verify it works on the circular canvas.

---

## Appearances Quick-Reference Checklist

```
Default
  □ Colours look vibrant against light background
  □ Specular and glass effects look intentional

Dark  
  □ All elements are legible against dark background
  □ Brand colour is still recognisable
  □ No elements "disappear" (check saturated colours especially)
  □ Shadows variant: neutral (not chromatic) on dark

Mono / Clear
  □ Tested over a real photo background
  □ Icon is legible over light AND dark wallpapers
  □ Primary element is white or very light

Mono / Tinted
  □ Primary element still reads over a coloured tint
  □ Tested with multiple tint colours (blue, red, orange)
  □ Contrast hierarchy is clear (not everything the same grey)
```

# Liquid Glass Reference

Detailed reference for Liquid Glass settings in Icon Composer.

## What Liquid Glass Is

Liquid Glass is the dynamic material system Apple introduced in 2025 that gives app icons their depth, translucency, and responsiveness to backgrounds and lighting. It's distinct from static icons — Liquid Glass icons literally respond to the wallpaper and system appearance behind them.

When you import a graphic file, Icon Composer automatically applies Liquid Glass to that layer. The real work is tuning it to look right for your specific artwork.

---

## Settings at the Group Level

Select a group in the sidebar to see these controls in the Inspector under **Liquid Glass**.

### Mode

| Value | Behaviour |
|---|---|
| **Individual** | Each layer in the group gets its own glass shell. Use when layers represent distinct separate objects (e.g., Home's separate room layers). |
| **Combined** | All layers in the group are treated as one shape for glass purposes. Use when layers form a single visual unit (e.g., a shape with a highlight on top). |

Try both — the visual difference can be dramatic. Individual tends to look more intricate; Combined often reads as cleaner and more unified.

### Specular

The specular highlight is the subtle brightening and edge glow that makes the icon look like it's sitting under a light source. It also introduces a slight background blur behind the element.

Toggle it **off** when:
- Shapes have very narrow sections where the effect becomes "pillowy" or overpowering
- The element is meant to look flat or matte

The Calendar icon's day number is the canonical example: speculars in narrow numeric shapes look awkward.

### Blur

Controls how much the wallpaper/background blurs through translucent areas of the glass. Higher blur = softer background impression behind the glass.

Use to control how "see-through" the icon feels — heavy blur makes backgrounds less recognisable, low blur makes backgrounds more prominent.

### Translucency

How much of the background shows through the glass layers. 0 = fully opaque (no background visible); 1 = fully translucent (maximum background bleeding through).

Works in tandem with Blur. High translucency + low blur = crisp background showing through. High translucency + high blur = soft glow from the background.

### Shadow

Two shadow types:

| Type | When to use |
|---|---|
| **Neutral** | Default. Works on any background. Use for dark appearances and mono. |
| **Chromatic** | The artwork's colour "spills" onto the background, creating a glowing halo. Best when the icon has strong colour against white. |

**Pattern for chromatic shadows:** Enable chromatic shadow in Default appearance, then add a Dark and Mono variant that switches back to Neutral shadows. This way the colour halo only appears on the light default appearance where it reads well.

To add the variant: with the default appearance selected, apply chromatic shadow. Then select Dark in the canvas → click ⊕ → Vary for Dark → switch to Neutral.

---

## Settings at the Layer Level

Select a layer to see the layer-level Liquid Glass control.

### Effects toggle

Under **Liquid Glass → Effects**, this is an on/off switch for whether the layer participates in Liquid Glass at all.

Turn it **off** for:
- Flat, opaque background elements that should look solid
- Elements where the glass effect looks wrong regardless of group settings
- Any layer where you want no dynamic behaviour

This is different from the group-level Specular toggle — disabling Effects on a layer removes all glass processing for that layer, not just the specular highlight.

---

## Liquid Glass + Appearances

Some Liquid Glass properties are **pre-configured to apply per appearance** (they already differ between Default, Dark, and Mono):
- Opacity
- Blend mode
- Fill

Others apply **to all appearances** by default because they're usually consistent:
- Specular
- Blur
- Translucency
- Shadow

You can always override this by creating a per-appearance variant of any property.

---

## Troubleshooting Liquid Glass

### "The glass effect makes a narrow element look too puffy or rounded"

Options, in order of mildness:
1. Toggle Specular off on the group → removes the highlight/glow without affecting translucency
2. Toggle Effects off on the layer → removes all glass from that layer
3. Separate the narrow element into its own group with Combined mode and minimal settings

### "The background is too visible through my icon"

Reduce Translucency on the group, or increase Blur (blurring the background makes it feel less intrusive even at higher translucency).

### "Chromatic shadows look weird in dark mode"

Add a Vary for Dark variant on the Shadow setting and switch it to Neutral. Same for Mono. See Shadow section above.

### "I can't tell if Individual or Combined mode is better"

Combined is usually better when the group represents one visual object. Individual is better when the group contains genuinely separate objects at different depths. If in doubt, preview both — the canvas updates instantly.

### "My icon looks flat even with Liquid Glass on"

Check:
- Specular is on (the glow and edge highlights contribute a lot)
- Translucency is above 0 (even a small amount adds depth)
- The group Mode is set correctly (try Individual if using Combined, or vice versa)
- Blur is greater than 0 (a little blur softens the background bleed and makes glass feel more physical)

---

## Liquid Glass Checklist

```
Per group:
  □ Mode set (Individual vs Combined) — tried both?
  □ Specular: on unless narrow shapes look "pillowy"
  □ Blur: tuned (0 = crisp, higher = softer background)
  □ Translucency: tuned (0 = opaque, higher = more see-through)
  □ Shadow: Neutral for dark/mono, Chromatic for default if colour icon on white

Per layer:
  □ Effects toggle checked — any layers that should be fully flat?

Per appearance:
  □ Dark: shadows using Neutral (not Chromatic)?
  □ Mono: does translucency look right over a coloured wallpaper?
```

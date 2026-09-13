# DockHub Visual Identity Reference

[Português (Brasil)](./VISUAL-IDENTITY.pt-BR.md)

This document is the color specification for the Theme subsystem currently implemented in DockHub. It is intentionally separate from the Theme architecture documentation so that the palette can also be used as a visual reference by other projects that intentionally adopt the same visual language.

The source values in this document were cross-checked against `TDockHubTheme` and the expected palettes used by `TDockHubThemeTests`.

## 1. Color format

DockHub uses Delphi `TAlphaColor` values in the form:

```text
$AARRGGBB
```

where `AA` is alpha, followed by red, green and blue. For reuse outside Delphi, this document also shows CSS/Web hexadecimal values. Fully opaque colors use `#RRGGBB`; colors with transparency use CSS eight-digit hexadecimal `#RRGGBBAA`.

`Transparent` is `$00000000` and is represented as `#00000000`.

## 2. Semantic token model

The palette is defined by semantic roles rather than by component-specific color names. The current public roles are grouped as:

- surfaces and separators;
- text;
- accent and informational badges;
- primary, danger and ghost buttons;
- background gradient endpoints;
- status colors;
- status badges;
- transparent utility color.

The same semantic token may intentionally resolve to different colors in different themes. Components should consume the semantic role appropriate to their purpose rather than copying a hexadecimal value locally.

## 3. Blue theme

`Blue` is the default theme created by `TDockHubTheme.New`.

### Surfaces

| Token | Delphi `TAlphaColor` | CSS/Web | Alpha |
| --- | --- | --- | ---: |
| `Background` | `$FF0F172A` | `#0F172A` | 100.0% |
| `SurfaceCard` | `$FF1E293B` | `#1E293B` | 100.0% |
| `SurfaceElevated` | `$FF273449` | `#273449` | 100.0% |
| `Border` | `$FF334155` | `#334155` | 100.0% |
| `Divider` | `$FF2A3441` | `#2A3441` | 100.0% |

### Text

| Token | Delphi `TAlphaColor` | CSS/Web | Alpha |
| --- | --- | --- | ---: |
| `TextPrimary` | `$FFF1F5F9` | `#F1F5F9` | 100.0% |
| `TextSecondary` | `$FF94A3B8` | `#94A3B8` | 100.0% |
| `TextDisabled` | `$FF64748B` | `#64748B` | 100.0% |

### Accent and information

| Token | Delphi `TAlphaColor` | CSS/Web | Alpha |
| --- | --- | --- | ---: |
| `Accent` | `$FF3B82F6` | `#3B82F6` | 100.0% |
| `AccentHover` | `$FF2563EB` | `#2563EB` | 100.0% |
| `AccentLight` | `$FF60A5FA` | `#60A5FA` | 100.0% |
| `BadgeInfoBg` | `$263B82F6` | `#3B82F626` | 14.9% |
| `BadgeInfoText` | `$FF60A5FA` | `#60A5FA` | 100.0% |

### Primary button

| Token | Delphi `TAlphaColor` | CSS/Web | Alpha |
| --- | --- | --- | ---: |
| `ButtonPrimaryBg` | `$FF3B82F6` | `#3B82F6` | 100.0% |
| `ButtonPrimaryHoverBg` | `$FF2563EB` | `#2563EB` | 100.0% |
| `ButtonPrimaryText` | `$FFFFFFFF` | `#FFFFFF` | 100.0% |

### Gradient

| Token | Delphi `TAlphaColor` | CSS/Web | Alpha |
| --- | --- | --- | ---: |
| `GradientStart` | `$FF0F172A` | `#0F172A` | 100.0% |
| `GradientEnd` | `$FF1E293B` | `#1E293B` | 100.0% |

### Utility

| Token | Delphi `TAlphaColor` | CSS/Web | Alpha |
| --- | --- | --- | ---: |
| `Transparent` | `$00000000` | `#00000000` | 0.0% |

### Status

| Token | Delphi `TAlphaColor` | CSS/Web | Alpha |
| --- | --- | --- | ---: |
| `StatusSuccess` | `$FF22C55E` | `#22C55E` | 100.0% |
| `StatusDanger` | `$FFEF4444` | `#EF4444` | 100.0% |
| `StatusWarning` | `$FFF59E0B` | `#F59E0B` | 100.0% |
| `StatusNeutral` | `$FF64748B` | `#64748B` | 100.0% |

### Status badges

| Token | Delphi `TAlphaColor` | CSS/Web | Alpha |
| --- | --- | --- | ---: |
| `BadgeSuccessBg` | `$2622C55E` | `#22C55E26` | 14.9% |
| `BadgeSuccessText` | `$FF4ADE80` | `#4ADE80` | 100.0% |
| `BadgeDangerBg` | `$26EF4444` | `#EF444426` | 14.9% |
| `BadgeDangerText` | `$FFF87171` | `#F87171` | 100.0% |
| `BadgeWarningBg` | `$26F59E0B` | `#F59E0B26` | 14.9% |
| `BadgeWarningText` | `$FFFBBF24` | `#FBBF24` | 100.0% |
| `BadgeNeutralBg` | `$2664748B` | `#64748B26` | 14.9% |
| `BadgeNeutralText` | `$FF94A3B8` | `#94A3B8` | 100.0% |

### Danger and ghost buttons

| Token | Delphi `TAlphaColor` | CSS/Web | Alpha |
| --- | --- | --- | ---: |
| `ButtonDangerBg` | `$FFEF4444` | `#EF4444` | 100.0% |
| `ButtonDangerHoverBg` | `$FFDC2626` | `#DC2626` | 100.0% |
| `ButtonDangerText` | `$FFFFFFFF` | `#FFFFFF` | 100.0% |
| `ButtonDangerOutlineText` | `$FFF87171` | `#F87171` | 100.0% |
| `ButtonGhostText` | `$FF94A3B8` | `#94A3B8` | 100.0% |

## 4. Teal theme

### Surfaces

| Token | Delphi `TAlphaColor` | CSS/Web | Alpha |
| --- | --- | --- | ---: |
| `Background` | `$FF0A1717` | `#0A1717` | 100.0% |
| `SurfaceCard` | `$FF132424` | `#132424` | 100.0% |
| `SurfaceElevated` | `$FF1B3131` | `#1B3131` | 100.0% |
| `Border` | `$FF2A4545` | `#2A4545` | 100.0% |
| `Divider` | `$FF1F3535` | `#1F3535` | 100.0% |

### Text

| Token | Delphi `TAlphaColor` | CSS/Web | Alpha |
| --- | --- | --- | ---: |
| `TextPrimary` | `$FFF0F5F5` | `#F0F5F5` | 100.0% |
| `TextSecondary` | `$FF8FA8A8` | `#8FA8A8` | 100.0% |
| `TextDisabled` | `$FF5C7373` | `#5C7373` | 100.0% |

### Accent and information

| Token | Delphi `TAlphaColor` | CSS/Web | Alpha |
| --- | --- | --- | ---: |
| `Accent` | `$FF008080` | `#008080` | 100.0% |
| `AccentHover` | `$FF006666` | `#006666` | 100.0% |
| `AccentLight` | `$FF2DD4D4` | `#2DD4D4` | 100.0% |
| `BadgeInfoBg` | `$2E008080` | `#0080802E` | 18.0% |
| `BadgeInfoText` | `$FF2DD4D4` | `#2DD4D4` | 100.0% |

### Primary button

| Token | Delphi `TAlphaColor` | CSS/Web | Alpha |
| --- | --- | --- | ---: |
| `ButtonPrimaryBg` | `$FF008080` | `#008080` | 100.0% |
| `ButtonPrimaryHoverBg` | `$FF006666` | `#006666` | 100.0% |
| `ButtonPrimaryText` | `$FFFFFFFF` | `#FFFFFF` | 100.0% |

### Gradient

| Token | Delphi `TAlphaColor` | CSS/Web | Alpha |
| --- | --- | --- | ---: |
| `GradientStart` | `$FF0A1717` | `#0A1717` | 100.0% |
| `GradientEnd` | `$FF1B3131` | `#1B3131` | 100.0% |

### Utility

| Token | Delphi `TAlphaColor` | CSS/Web | Alpha |
| --- | --- | --- | ---: |
| `Transparent` | `$00000000` | `#00000000` | 0.0% |

### Status

| Token | Delphi `TAlphaColor` | CSS/Web | Alpha |
| --- | --- | --- | ---: |
| `StatusSuccess` | `$FF22C55E` | `#22C55E` | 100.0% |
| `StatusDanger` | `$FFEF4444` | `#EF4444` | 100.0% |
| `StatusWarning` | `$FFF59E0B` | `#F59E0B` | 100.0% |
| `StatusNeutral` | `$FF64748B` | `#64748B` | 100.0% |

### Status badges

| Token | Delphi `TAlphaColor` | CSS/Web | Alpha |
| --- | --- | --- | ---: |
| `BadgeSuccessBg` | `$2622C55E` | `#22C55E26` | 14.9% |
| `BadgeSuccessText` | `$FF4ADE80` | `#4ADE80` | 100.0% |
| `BadgeDangerBg` | `$26EF4444` | `#EF444426` | 14.9% |
| `BadgeDangerText` | `$FFF87171` | `#F87171` | 100.0% |
| `BadgeWarningBg` | `$26F59E0B` | `#F59E0B26` | 14.9% |
| `BadgeWarningText` | `$FFFBBF24` | `#FBBF24` | 100.0% |
| `BadgeNeutralBg` | `$2664748B` | `#64748B26` | 14.9% |
| `BadgeNeutralText` | `$FF94A3B8` | `#94A3B8` | 100.0% |

### Danger and ghost buttons

| Token | Delphi `TAlphaColor` | CSS/Web | Alpha |
| --- | --- | --- | ---: |
| `ButtonDangerBg` | `$FFEF4444` | `#EF4444` | 100.0% |
| `ButtonDangerHoverBg` | `$FFDC2626` | `#DC2626` | 100.0% |
| `ButtonDangerText` | `$FFFFFFFF` | `#FFFFFF` | 100.0% |
| `ButtonDangerOutlineText` | `$FFF87171` | `#F87171` | 100.0% |
| `ButtonGhostText` | `$FF94A8A8` | `#94A8A8` | 100.0% |

## 5. Light theme

### Surfaces

| Token | Delphi `TAlphaColor` | CSS/Web | Alpha |
| --- | --- | --- | ---: |
| `Background` | `$FFE8E8E8` | `#E8E8E8` | 100.0% |
| `SurfaceCard` | `$FFFFFFFF` | `#FFFFFF` | 100.0% |
| `SurfaceElevated` | `$FFF5F5F5` | `#F5F5F5` | 100.0% |
| `Border` | `$FFD4D4D4` | `#D4D4D4` | 100.0% |
| `Divider` | `$FFE0E0E0` | `#E0E0E0` | 100.0% |

### Text

| Token | Delphi `TAlphaColor` | CSS/Web | Alpha |
| --- | --- | --- | ---: |
| `TextPrimary` | `$FF1A1A1A` | `#1A1A1A` | 100.0% |
| `TextSecondary` | `$FF595959` | `#595959` | 100.0% |
| `TextDisabled` | `$FFA6A6A6` | `#A6A6A6` | 100.0% |

### Accent and information

| Token | Delphi `TAlphaColor` | CSS/Web | Alpha |
| --- | --- | --- | ---: |
| `Accent` | `$FF3B82F6` | `#3B82F6` | 100.0% |
| `AccentHover` | `$FF2563EB` | `#2563EB` | 100.0% |
| `AccentLight` | `$FF60A5FA` | `#60A5FA` | 100.0% |
| `BadgeInfoBg` | `$FFDBEAFE` | `#DBEAFE` | 100.0% |
| `BadgeInfoText` | `$FF2563EB` | `#2563EB` | 100.0% |

### Primary button

| Token | Delphi `TAlphaColor` | CSS/Web | Alpha |
| --- | --- | --- | ---: |
| `ButtonPrimaryBg` | `$FF3B82F6` | `#3B82F6` | 100.0% |
| `ButtonPrimaryHoverBg` | `$FF2563EB` | `#2563EB` | 100.0% |
| `ButtonPrimaryText` | `$FFFFFFFF` | `#FFFFFF` | 100.0% |

### Gradient

| Token | Delphi `TAlphaColor` | CSS/Web | Alpha |
| --- | --- | --- | ---: |
| `GradientStart` | `$FFE8E8E8` | `#E8E8E8` | 100.0% |
| `GradientEnd` | `$FFF5F5F5` | `#F5F5F5` | 100.0% |

### Utility

| Token | Delphi `TAlphaColor` | CSS/Web | Alpha |
| --- | --- | --- | ---: |
| `Transparent` | `$00000000` | `#00000000` | 0.0% |

### Status

| Token | Delphi `TAlphaColor` | CSS/Web | Alpha |
| --- | --- | --- | ---: |
| `StatusSuccess` | `$FF15803D` | `#15803D` | 100.0% |
| `StatusDanger` | `$FFB91C1C` | `#B91C1C` | 100.0% |
| `StatusWarning` | `$FFB45309` | `#B45309` | 100.0% |
| `StatusNeutral` | `$FF6B7280` | `#6B7280` | 100.0% |

### Status badges

| Token | Delphi `TAlphaColor` | CSS/Web | Alpha |
| --- | --- | --- | ---: |
| `BadgeSuccessBg` | `$FFDCFCE7` | `#DCFCE7` | 100.0% |
| `BadgeSuccessText` | `$FF15803D` | `#15803D` | 100.0% |
| `BadgeDangerBg` | `$FFFEE2E2` | `#FEE2E2` | 100.0% |
| `BadgeDangerText` | `$FFB91C1C` | `#B91C1C` | 100.0% |
| `BadgeWarningBg` | `$FFFEF3C7` | `#FEF3C7` | 100.0% |
| `BadgeWarningText` | `$FFB45309` | `#B45309` | 100.0% |
| `BadgeNeutralBg` | `$FFF3F4F6` | `#F3F4F6` | 100.0% |
| `BadgeNeutralText` | `$FF4B5563` | `#4B5563` | 100.0% |

### Danger and ghost buttons

| Token | Delphi `TAlphaColor` | CSS/Web | Alpha |
| --- | --- | --- | ---: |
| `ButtonDangerBg` | `$FFDC2626` | `#DC2626` | 100.0% |
| `ButtonDangerHoverBg` | `$FFB91C1C` | `#B91C1C` | 100.0% |
| `ButtonDangerText` | `$FFFFFFFF` | `#FFFFFF` | 100.0% |
| `ButtonDangerOutlineText` | `$FFB91C1C` | `#B91C1C` | 100.0% |
| `ButtonGhostText` | `$FF595959` | `#595959` | 100.0% |

## 6. Dark theme

### Surfaces

| Token | Delphi `TAlphaColor` | CSS/Web | Alpha |
| --- | --- | --- | ---: |
| `Background` | `$FF303030` | `#303030` | 100.0% |
| `SurfaceCard` | `$FF3D3D3D` | `#3D3D3D` | 100.0% |
| `SurfaceElevated` | `$FF474747` | `#474747` | 100.0% |
| `Border` | `$FF525252` | `#525252` | 100.0% |
| `Divider` | `$FF3A3A3A` | `#3A3A3A` | 100.0% |

### Text

| Token | Delphi `TAlphaColor` | CSS/Web | Alpha |
| --- | --- | --- | ---: |
| `TextPrimary` | `$FFF5F5F5` | `#F5F5F5` | 100.0% |
| `TextSecondary` | `$FFB0B0B0` | `#B0B0B0` | 100.0% |
| `TextDisabled` | `$FF757575` | `#757575` | 100.0% |

### Accent and information

| Token | Delphi `TAlphaColor` | CSS/Web | Alpha |
| --- | --- | --- | ---: |
| `Accent` | `$FF3B82F6` | `#3B82F6` | 100.0% |
| `AccentHover` | `$FF2563EB` | `#2563EB` | 100.0% |
| `AccentLight` | `$FF60A5FA` | `#60A5FA` | 100.0% |
| `BadgeInfoBg` | `$263B82F6` | `#3B82F626` | 14.9% |
| `BadgeInfoText` | `$FF60A5FA` | `#60A5FA` | 100.0% |

### Primary button

| Token | Delphi `TAlphaColor` | CSS/Web | Alpha |
| --- | --- | --- | ---: |
| `ButtonPrimaryBg` | `$FF3B82F6` | `#3B82F6` | 100.0% |
| `ButtonPrimaryHoverBg` | `$FF2563EB` | `#2563EB` | 100.0% |
| `ButtonPrimaryText` | `$FFFFFFFF` | `#FFFFFF` | 100.0% |

### Gradient

| Token | Delphi `TAlphaColor` | CSS/Web | Alpha |
| --- | --- | --- | ---: |
| `GradientStart` | `$FF303030` | `#303030` | 100.0% |
| `GradientEnd` | `$FF474747` | `#474747` | 100.0% |

### Utility

| Token | Delphi `TAlphaColor` | CSS/Web | Alpha |
| --- | --- | --- | ---: |
| `Transparent` | `$00000000` | `#00000000` | 0.0% |

### Status

| Token | Delphi `TAlphaColor` | CSS/Web | Alpha |
| --- | --- | --- | ---: |
| `StatusSuccess` | `$FF22C55E` | `#22C55E` | 100.0% |
| `StatusDanger` | `$FFEF4444` | `#EF4444` | 100.0% |
| `StatusWarning` | `$FFF59E0B` | `#F59E0B` | 100.0% |
| `StatusNeutral` | `$FF64748B` | `#64748B` | 100.0% |

### Status badges

| Token | Delphi `TAlphaColor` | CSS/Web | Alpha |
| --- | --- | --- | ---: |
| `BadgeSuccessBg` | `$2E22C55E` | `#22C55E2E` | 18.0% |
| `BadgeSuccessText` | `$FF4ADE80` | `#4ADE80` | 100.0% |
| `BadgeDangerBg` | `$2EEF4444` | `#EF44442E` | 18.0% |
| `BadgeDangerText` | `$FFF87171` | `#F87171` | 100.0% |
| `BadgeWarningBg` | `$2EF59E0B` | `#F59E0B2E` | 18.0% |
| `BadgeWarningText` | `$FFFBBF24` | `#FBBF24` | 100.0% |
| `BadgeNeutralBg` | `$2E64748B` | `#64748B2E` | 18.0% |
| `BadgeNeutralText` | `$FFB0B0B0` | `#B0B0B0` | 100.0% |

### Danger and ghost buttons

| Token | Delphi `TAlphaColor` | CSS/Web | Alpha |
| --- | --- | --- | ---: |
| `ButtonDangerBg` | `$FFEF4444` | `#EF4444` | 100.0% |
| `ButtonDangerHoverBg` | `$FFDC2626` | `#DC2626` | 100.0% |
| `ButtonDangerText` | `$FFFFFFFF` | `#FFFFFF` | 100.0% |
| `ButtonDangerOutlineText` | `$FFF87171` | `#F87171` | 100.0% |
| `ButtonGhostText` | `$FFB0B0B0` | `#B0B0B0` | 100.0% |

## 7. Current token relationships

The implementation intentionally derives some values from other theme tokens:

- `ButtonPrimaryBg` follows `Accent`;
- `ButtonPrimaryHoverBg` follows `AccentHover`;
- `GradientStart` follows `Background` in all four themes;
- `GradientEnd` follows `SurfaceCard` in Blue and `SurfaceElevated` in Teal, Light and Dark;
- Blue, Light and Dark currently share the same blue accent family;
- Teal uses its own teal accent family;
- `Transparent` is theme-independent and always returns `$00000000`.

These relationships are part of the current implementation and should not be generalized beyond what the source code defines.

## 8. Maintenance rule

An intentional palette change must update the same semantic value in all artifacts that define or validate the current visual specification:

1. `src/view/Theme/Impl/DockHub.View.Theme.Impl.pas`;
2. `tests/View/DockHub.Tests.View.Theme.pas` expected palette data;
3. this document;
4. `VISUAL-IDENTITY.pt-BR.md`.

The production implementation remains the executable source. The test data is the regression baseline. This document is the human-readable and cross-project visual reference.

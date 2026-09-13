# Referência de Identidade Visual do DockHub

[English — Official](./VISUAL-IDENTITY.md)

Este documento é a especificação de cores do subsistema de Theme atualmente implementado no DockHub. Ele foi separado propositalmente da documentação arquitetural do Theme para que a paleta também possa servir como referência visual para outros projetos que decidam adotar a mesma linguagem visual.

Os valores deste documento foram conferidos com `TDockHubTheme` e com as paletas esperadas utilizadas por `TDockHubThemeTests`.

## 1. Formato das cores

O DockHub utiliza valores Delphi `TAlphaColor` no formato:

```text
$AARRGGBB
```

onde `AA` representa o alpha, seguido de vermelho, verde e azul. Para reutilização fora do Delphi, este documento também apresenta os valores hexadecimais para CSS/Web. Cores totalmente opacas utilizam `#RRGGBB`; cores com transparência utilizam o hexadecimal CSS de oito dígitos `#RRGGBBAA`.

`Transparent` corresponde a `$00000000` e é representado como `#00000000`.

## 2. Modelo de tokens semânticos

A paleta é definida por papéis semânticos, e não por nomes de cores específicos de componentes. Os papéis públicos atuais estão organizados em:

- superfícies e separadores;
- texto;
- accent e badges informativos;
- botões primário, danger e ghost;
- extremidades do gradiente de fundo;
- cores de status;
- badges de status;
- cor utilitária transparente.

O mesmo token semântico pode propositalmente resultar em cores diferentes conforme o tema. Os componentes devem consumir o papel semântico apropriado à sua finalidade, em vez de copiar localmente um valor hexadecimal.

## 3. Tema Blue

`Blue` é o tema default criado por `TDockHubTheme.New`.

### Superfícies

| Token | Delphi `TAlphaColor` | CSS/Web | Alpha |
| --- | --- | --- | ---: |
| `Background` | `$FF0F172A` | `#0F172A` | 100.0% |
| `SurfaceCard` | `$FF1E293B` | `#1E293B` | 100.0% |
| `SurfaceElevated` | `$FF273449` | `#273449` | 100.0% |
| `Border` | `$FF334155` | `#334155` | 100.0% |
| `Divider` | `$FF2A3441` | `#2A3441` | 100.0% |

### Texto

| Token | Delphi `TAlphaColor` | CSS/Web | Alpha |
| --- | --- | --- | ---: |
| `TextPrimary` | `$FFF1F5F9` | `#F1F5F9` | 100.0% |
| `TextSecondary` | `$FF94A3B8` | `#94A3B8` | 100.0% |
| `TextDisabled` | `$FF64748B` | `#64748B` | 100.0% |

### Accent e informação

| Token | Delphi `TAlphaColor` | CSS/Web | Alpha |
| --- | --- | --- | ---: |
| `Accent` | `$FF3B82F6` | `#3B82F6` | 100.0% |
| `AccentHover` | `$FF2563EB` | `#2563EB` | 100.0% |
| `AccentLight` | `$FF60A5FA` | `#60A5FA` | 100.0% |
| `BadgeInfoBg` | `$263B82F6` | `#3B82F626` | 14.9% |
| `BadgeInfoText` | `$FF60A5FA` | `#60A5FA` | 100.0% |

### Botão primário

| Token | Delphi `TAlphaColor` | CSS/Web | Alpha |
| --- | --- | --- | ---: |
| `ButtonPrimaryBg` | `$FF3B82F6` | `#3B82F6` | 100.0% |
| `ButtonPrimaryHoverBg` | `$FF2563EB` | `#2563EB` | 100.0% |
| `ButtonPrimaryText` | `$FFFFFFFF` | `#FFFFFF` | 100.0% |

### Gradiente

| Token | Delphi `TAlphaColor` | CSS/Web | Alpha |
| --- | --- | --- | ---: |
| `GradientStart` | `$FF0F172A` | `#0F172A` | 100.0% |
| `GradientEnd` | `$FF1E293B` | `#1E293B` | 100.0% |

### Utilitário

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

### Badges de status

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

### Botões danger e ghost

| Token | Delphi `TAlphaColor` | CSS/Web | Alpha |
| --- | --- | --- | ---: |
| `ButtonDangerBg` | `$FFEF4444` | `#EF4444` | 100.0% |
| `ButtonDangerHoverBg` | `$FFDC2626` | `#DC2626` | 100.0% |
| `ButtonDangerText` | `$FFFFFFFF` | `#FFFFFF` | 100.0% |
| `ButtonDangerOutlineText` | `$FFF87171` | `#F87171` | 100.0% |
| `ButtonGhostText` | `$FF94A3B8` | `#94A3B8` | 100.0% |

## 4. Tema Teal

### Superfícies

| Token | Delphi `TAlphaColor` | CSS/Web | Alpha |
| --- | --- | --- | ---: |
| `Background` | `$FF0A1717` | `#0A1717` | 100.0% |
| `SurfaceCard` | `$FF132424` | `#132424` | 100.0% |
| `SurfaceElevated` | `$FF1B3131` | `#1B3131` | 100.0% |
| `Border` | `$FF2A4545` | `#2A4545` | 100.0% |
| `Divider` | `$FF1F3535` | `#1F3535` | 100.0% |

### Texto

| Token | Delphi `TAlphaColor` | CSS/Web | Alpha |
| --- | --- | --- | ---: |
| `TextPrimary` | `$FFF0F5F5` | `#F0F5F5` | 100.0% |
| `TextSecondary` | `$FF8FA8A8` | `#8FA8A8` | 100.0% |
| `TextDisabled` | `$FF5C7373` | `#5C7373` | 100.0% |

### Accent e informação

| Token | Delphi `TAlphaColor` | CSS/Web | Alpha |
| --- | --- | --- | ---: |
| `Accent` | `$FF008080` | `#008080` | 100.0% |
| `AccentHover` | `$FF006666` | `#006666` | 100.0% |
| `AccentLight` | `$FF2DD4D4` | `#2DD4D4` | 100.0% |
| `BadgeInfoBg` | `$2E008080` | `#0080802E` | 18.0% |
| `BadgeInfoText` | `$FF2DD4D4` | `#2DD4D4` | 100.0% |

### Botão primário

| Token | Delphi `TAlphaColor` | CSS/Web | Alpha |
| --- | --- | --- | ---: |
| `ButtonPrimaryBg` | `$FF008080` | `#008080` | 100.0% |
| `ButtonPrimaryHoverBg` | `$FF006666` | `#006666` | 100.0% |
| `ButtonPrimaryText` | `$FFFFFFFF` | `#FFFFFF` | 100.0% |

### Gradiente

| Token | Delphi `TAlphaColor` | CSS/Web | Alpha |
| --- | --- | --- | ---: |
| `GradientStart` | `$FF0A1717` | `#0A1717` | 100.0% |
| `GradientEnd` | `$FF1B3131` | `#1B3131` | 100.0% |

### Utilitário

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

### Badges de status

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

### Botões danger e ghost

| Token | Delphi `TAlphaColor` | CSS/Web | Alpha |
| --- | --- | --- | ---: |
| `ButtonDangerBg` | `$FFEF4444` | `#EF4444` | 100.0% |
| `ButtonDangerHoverBg` | `$FFDC2626` | `#DC2626` | 100.0% |
| `ButtonDangerText` | `$FFFFFFFF` | `#FFFFFF` | 100.0% |
| `ButtonDangerOutlineText` | `$FFF87171` | `#F87171` | 100.0% |
| `ButtonGhostText` | `$FF94A8A8` | `#94A8A8` | 100.0% |

## 5. Tema Light

### Superfícies

| Token | Delphi `TAlphaColor` | CSS/Web | Alpha |
| --- | --- | --- | ---: |
| `Background` | `$FFE8E8E8` | `#E8E8E8` | 100.0% |
| `SurfaceCard` | `$FFFFFFFF` | `#FFFFFF` | 100.0% |
| `SurfaceElevated` | `$FFF5F5F5` | `#F5F5F5` | 100.0% |
| `Border` | `$FFD4D4D4` | `#D4D4D4` | 100.0% |
| `Divider` | `$FFE0E0E0` | `#E0E0E0` | 100.0% |

### Texto

| Token | Delphi `TAlphaColor` | CSS/Web | Alpha |
| --- | --- | --- | ---: |
| `TextPrimary` | `$FF1A1A1A` | `#1A1A1A` | 100.0% |
| `TextSecondary` | `$FF595959` | `#595959` | 100.0% |
| `TextDisabled` | `$FFA6A6A6` | `#A6A6A6` | 100.0% |

### Accent e informação

| Token | Delphi `TAlphaColor` | CSS/Web | Alpha |
| --- | --- | --- | ---: |
| `Accent` | `$FF3B82F6` | `#3B82F6` | 100.0% |
| `AccentHover` | `$FF2563EB` | `#2563EB` | 100.0% |
| `AccentLight` | `$FF60A5FA` | `#60A5FA` | 100.0% |
| `BadgeInfoBg` | `$FFDBEAFE` | `#DBEAFE` | 100.0% |
| `BadgeInfoText` | `$FF2563EB` | `#2563EB` | 100.0% |

### Botão primário

| Token | Delphi `TAlphaColor` | CSS/Web | Alpha |
| --- | --- | --- | ---: |
| `ButtonPrimaryBg` | `$FF3B82F6` | `#3B82F6` | 100.0% |
| `ButtonPrimaryHoverBg` | `$FF2563EB` | `#2563EB` | 100.0% |
| `ButtonPrimaryText` | `$FFFFFFFF` | `#FFFFFF` | 100.0% |

### Gradiente

| Token | Delphi `TAlphaColor` | CSS/Web | Alpha |
| --- | --- | --- | ---: |
| `GradientStart` | `$FFE8E8E8` | `#E8E8E8` | 100.0% |
| `GradientEnd` | `$FFF5F5F5` | `#F5F5F5` | 100.0% |

### Utilitário

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

### Badges de status

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

### Botões danger e ghost

| Token | Delphi `TAlphaColor` | CSS/Web | Alpha |
| --- | --- | --- | ---: |
| `ButtonDangerBg` | `$FFDC2626` | `#DC2626` | 100.0% |
| `ButtonDangerHoverBg` | `$FFB91C1C` | `#B91C1C` | 100.0% |
| `ButtonDangerText` | `$FFFFFFFF` | `#FFFFFF` | 100.0% |
| `ButtonDangerOutlineText` | `$FFB91C1C` | `#B91C1C` | 100.0% |
| `ButtonGhostText` | `$FF595959` | `#595959` | 100.0% |

## 6. Tema Dark

### Superfícies

| Token | Delphi `TAlphaColor` | CSS/Web | Alpha |
| --- | --- | --- | ---: |
| `Background` | `$FF303030` | `#303030` | 100.0% |
| `SurfaceCard` | `$FF3D3D3D` | `#3D3D3D` | 100.0% |
| `SurfaceElevated` | `$FF474747` | `#474747` | 100.0% |
| `Border` | `$FF525252` | `#525252` | 100.0% |
| `Divider` | `$FF3A3A3A` | `#3A3A3A` | 100.0% |

### Texto

| Token | Delphi `TAlphaColor` | CSS/Web | Alpha |
| --- | --- | --- | ---: |
| `TextPrimary` | `$FFF5F5F5` | `#F5F5F5` | 100.0% |
| `TextSecondary` | `$FFB0B0B0` | `#B0B0B0` | 100.0% |
| `TextDisabled` | `$FF757575` | `#757575` | 100.0% |

### Accent e informação

| Token | Delphi `TAlphaColor` | CSS/Web | Alpha |
| --- | --- | --- | ---: |
| `Accent` | `$FF3B82F6` | `#3B82F6` | 100.0% |
| `AccentHover` | `$FF2563EB` | `#2563EB` | 100.0% |
| `AccentLight` | `$FF60A5FA` | `#60A5FA` | 100.0% |
| `BadgeInfoBg` | `$263B82F6` | `#3B82F626` | 14.9% |
| `BadgeInfoText` | `$FF60A5FA` | `#60A5FA` | 100.0% |

### Botão primário

| Token | Delphi `TAlphaColor` | CSS/Web | Alpha |
| --- | --- | --- | ---: |
| `ButtonPrimaryBg` | `$FF3B82F6` | `#3B82F6` | 100.0% |
| `ButtonPrimaryHoverBg` | `$FF2563EB` | `#2563EB` | 100.0% |
| `ButtonPrimaryText` | `$FFFFFFFF` | `#FFFFFF` | 100.0% |

### Gradiente

| Token | Delphi `TAlphaColor` | CSS/Web | Alpha |
| --- | --- | --- | ---: |
| `GradientStart` | `$FF303030` | `#303030` | 100.0% |
| `GradientEnd` | `$FF474747` | `#474747` | 100.0% |

### Utilitário

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

### Badges de status

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

### Botões danger e ghost

| Token | Delphi `TAlphaColor` | CSS/Web | Alpha |
| --- | --- | --- | ---: |
| `ButtonDangerBg` | `$FFEF4444` | `#EF4444` | 100.0% |
| `ButtonDangerHoverBg` | `$FFDC2626` | `#DC2626` | 100.0% |
| `ButtonDangerText` | `$FFFFFFFF` | `#FFFFFF` | 100.0% |
| `ButtonDangerOutlineText` | `$FFF87171` | `#F87171` | 100.0% |
| `ButtonGhostText` | `$FFB0B0B0` | `#B0B0B0` | 100.0% |

## 7. Relações atuais entre tokens

A implementação deriva propositalmente alguns valores de outros tokens do tema:

- `ButtonPrimaryBg` acompanha `Accent`;
- `ButtonPrimaryHoverBg` acompanha `AccentHover`;
- `GradientStart` acompanha `Background` nos quatro temas;
- `GradientEnd` acompanha `SurfaceCard` em Blue e `SurfaceElevated` em Teal, Light e Dark;
- Blue, Light e Dark compartilham atualmente a mesma família de accent azul;
- Teal utiliza sua própria família de accent teal;
- `Transparent` é independente do tema e sempre retorna `$00000000`.

Essas relações pertencem à implementação atual e não devem ser generalizadas além do que o código-fonte define.

## 8. Regra de manutenção

Uma alteração intencional de paleta deve atualizar o mesmo valor semântico em todos os artefatos que definem ou validam a especificação visual atual:

1. `src/view/Theme/Impl/DockHub.View.Theme.Impl.pas`;
2. dados das paletas esperadas em `tests/View/DockHub.Tests.View.Theme.pas`;
3. este documento;
4. `VISUAL-IDENTITY.md`.

A implementação de produção permanece como fonte executável. Os dados dos testes formam o baseline de regressão. Este documento é a referência visual legível e reutilizável por outros projetos.

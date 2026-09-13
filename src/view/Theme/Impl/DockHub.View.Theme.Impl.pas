unit DockHub.View.Theme.Impl;

interface

uses
  System.UITypes,
  FMX.Graphics,
  DockHub.View.Theme.Types,
  DockHub.View.Theme.Contracts;

type
  TDockHubTheme = class sealed(TInterfacedObject, IDockHubTheme)
  private
    FTheme: TDockHubThemeType;

    FBackground: TAlphaColor;
    FSurfaceCard: TAlphaColor;
    FSurfaceElevated: TAlphaColor;
    FBorder: TAlphaColor;
    FDivider: TAlphaColor;

    FTextPrimary: TAlphaColor;
    FTextSecondary: TAlphaColor;
    FTextDisabled: TAlphaColor;

    FAccent: TAlphaColor;
    FAccentHover: TAlphaColor;
    FAccentLight: TAlphaColor;

    FBadgeInfoBg: TAlphaColor;
    FBadgeInfoText: TAlphaColor;

    FButtonPrimaryBg: TAlphaColor;
    FButtonPrimaryHoverBg: TAlphaColor;
    FButtonPrimaryText: TAlphaColor;

    FGradientStart: TAlphaColor;
    FGradientEnd: TAlphaColor;

    // ---------- Antes eram constantes fixas; agora variam por tema ----------
    FStatusSuccess: TAlphaColor;
    FStatusDanger: TAlphaColor;
    FStatusWarning: TAlphaColor;
    FStatusNeutral: TAlphaColor;

    FBadgeSuccessBg: TAlphaColor;
    FBadgeSuccessText: TAlphaColor;
    FBadgeDangerBg: TAlphaColor;
    FBadgeDangerText: TAlphaColor;
    FBadgeWarningBg: TAlphaColor;
    FBadgeWarningText: TAlphaColor;
    FBadgeNeutralBg: TAlphaColor;
    FBadgeNeutralText: TAlphaColor;

    FButtonDangerBg: TAlphaColor;
    FButtonDangerHoverBg: TAlphaColor;
    FButtonDangerText: TAlphaColor;
    FButtonDangerOutlineText: TAlphaColor;
    FButtonGhostText: TAlphaColor;

    procedure ConfigureGradientBrush(AFill: TBrush);
    procedure ConfigureGradientColors(AFill: TBrush);
    procedure ConfigureGradientPositions(AFill: TBrush; const AAngle: Single);


    procedure ApplyBlueSurfaces;
    procedure ApplyBlueText;
    procedure ApplyBlueAccent;
    procedure ApplyBlueButtons;
    procedure ApplyBlueGradient;
    procedure ApplyBlueStatus;
    procedure ApplyBlueBadges;
    procedure ApplyBlue;

    procedure ApplyTealSurfaces;
    procedure ApplyTealText;
    procedure ApplyTealAccent;
    procedure ApplyTealButtons;
    procedure ApplyTealGradient;
    procedure ApplyTealStatus;
    procedure ApplyTealBadges;
    procedure ApplyTeal;

    procedure ApplyLightSurfaces;
    procedure ApplyLightText;
    procedure ApplyLightAccent;
    procedure ApplyLightButtons;
    procedure ApplyLightGradient;
    procedure ApplyLightStatus;
    procedure ApplyLightBadges;
    procedure ApplyLight;

    procedure ApplyDarkSurfaces;
    procedure ApplyDarkText;
    procedure ApplyDarkAccent;
    procedure ApplyDarkButtons;
    procedure ApplyDarkGradient;
    procedure ApplyDarkStatus;
    procedure ApplyDarkBadges;
    procedure ApplyDark;
  protected
    function Theme: TDockHubThemeType; overload;
    function Theme(const AValue: TDockHubThemeType): IDockHubTheme; overload;

    function Background: TAlphaColor;
    function SurfaceCard: TAlphaColor;
    function SurfaceElevated: TAlphaColor;
    function Border: TAlphaColor;
    function Divider: TAlphaColor;

    function TextPrimary: TAlphaColor;
    function TextSecondary: TAlphaColor;
    function TextDisabled: TAlphaColor;

    function Accent: TAlphaColor;
    function AccentHover: TAlphaColor;
    function AccentLight: TAlphaColor;

    function BadgeInfoBg: TAlphaColor;
    function BadgeInfoText: TAlphaColor;

    function ButtonPrimaryBg: TAlphaColor;
    function ButtonPrimaryHoverBg: TAlphaColor;
    function ButtonPrimaryText: TAlphaColor;

    function GradientStart: TAlphaColor;
    function GradientEnd: TAlphaColor;

    function Transparent: TAlphaColor;

    function StatusSuccess: TAlphaColor;
    function StatusDanger: TAlphaColor;
    function StatusWarning: TAlphaColor;
    function StatusNeutral: TAlphaColor;

    function BadgeSuccessBg: TAlphaColor;
    function BadgeSuccessText: TAlphaColor;
    function BadgeDangerBg: TAlphaColor;
    function BadgeDangerText: TAlphaColor;
    function BadgeWarningBg: TAlphaColor;
    function BadgeWarningText: TAlphaColor;
    function BadgeNeutralBg: TAlphaColor;
    function BadgeNeutralText: TAlphaColor;

    function ButtonDangerBg: TAlphaColor;
    function ButtonDangerHoverBg: TAlphaColor;
    function ButtonDangerText: TAlphaColor;
    function ButtonDangerOutlineText: TAlphaColor;
    function ButtonGhostText: TAlphaColor;

    function BackgroundGradient(AFill: TBrush;
      const AAngle: Single): IDockHubTheme; overload;

    function BackgroundGradient(AFill: TBrush): IDockHubTheme; overload;


    function BadgeBackground(const AStatusOk: Boolean): TAlphaColor;
    function BadgeText(const AStatusOk: Boolean): TAlphaColor;

    constructor Create;
  public
    class function New: IDockHubTheme; static;


  end;

implementation

uses
  System.Math,
  FMX.Types;

{ TDockHubTheme }

constructor TDockHubTheme.Create;
begin
  inherited;
  ApplyBlue;
end;

class function TDockHubTheme.New: IDockHubTheme;
begin
  Result := TDockHubTheme.Create;
end;

procedure TDockHubTheme.ApplyBlueSurfaces;
begin
  FBackground := TAlphaColor($FF0F172A);
  FSurfaceCard := TAlphaColor($FF1E293B);
  FSurfaceElevated := TAlphaColor($FF273449);
  FBorder := TAlphaColor($FF334155);
  FDivider := TAlphaColor($FF2A3441);
end;

procedure TDockHubTheme.ApplyBlueText;
begin
  FTextPrimary := TAlphaColor($FFF1F5F9);
  FTextSecondary := TAlphaColor($FF94A3B8);
  FTextDisabled := TAlphaColor($FF64748B);
end;

procedure TDockHubTheme.ApplyBlueAccent;
begin
  FAccent := TAlphaColor($FF3B82F6);
  FAccentHover := TAlphaColor($FF2563EB);
  FAccentLight := TAlphaColor($FF60A5FA);

  FBadgeInfoBg := TAlphaColor($263B82F6);
  FBadgeInfoText := TAlphaColor($FF60A5FA);
end;

procedure TDockHubTheme.ApplyBlueButtons;
begin
  FButtonPrimaryBg := FAccent;
  FButtonPrimaryHoverBg := FAccentHover;
  FButtonPrimaryText := TAlphaColor($FFFFFFFF);

  FButtonDangerBg := TAlphaColor($FFEF4444);
  FButtonDangerHoverBg := TAlphaColor($FFDC2626);
  FButtonDangerText := TAlphaColor($FFFFFFFF);
  FButtonDangerOutlineText := TAlphaColor($FFF87171);

  FButtonGhostText := TAlphaColor($FF94A3B8);
end;

procedure TDockHubTheme.ApplyBlueGradient;
begin
  FGradientStart := FBackground;
  FGradientEnd := FSurfaceCard;
end;

procedure TDockHubTheme.ApplyBlueStatus;
begin
  FStatusSuccess := TAlphaColor($FF22C55E);
  FStatusDanger := TAlphaColor($FFEF4444);
  FStatusWarning := TAlphaColor($FFF59E0B);
  FStatusNeutral := TAlphaColor($FF64748B);
end;

procedure TDockHubTheme.ApplyBlueBadges;
begin
  FBadgeSuccessBg := TAlphaColor($2622C55E);
  FBadgeSuccessText := TAlphaColor($FF4ADE80);

  FBadgeDangerBg := TAlphaColor($26EF4444);
  FBadgeDangerText := TAlphaColor($FFF87171);

  FBadgeWarningBg := TAlphaColor($26F59E0B);
  FBadgeWarningText := TAlphaColor($FFFBBF24);

  FBadgeNeutralBg := TAlphaColor($2664748B);
  FBadgeNeutralText := TAlphaColor($FF94A3B8);
end;


procedure TDockHubTheme.ApplyBlue;
begin
  FTheme := TDockHubThemeType.Blue;

  ApplyBlueSurfaces;
  ApplyBlueText;
  ApplyBlueAccent;
  ApplyBlueButtons;
  ApplyBlueGradient;
  ApplyBlueStatus;
  ApplyBlueBadges;

end;

procedure TDockHubTheme.ApplyDarkSurfaces;
begin
  FBackground := TAlphaColor($FF303030);
  FSurfaceCard := TAlphaColor($FF3D3D3D);
  FSurfaceElevated := TAlphaColor($FF474747);
  FBorder := TAlphaColor($FF525252);
  FDivider := TAlphaColor($FF3A3A3A);
end;

procedure TDockHubTheme.ApplyDarkText;
begin
  FTextPrimary := TAlphaColor($FFF5F5F5);
  FTextSecondary := TAlphaColor($FFB0B0B0);
  FTextDisabled := TAlphaColor($FF757575);
end;

procedure TDockHubTheme.ApplyDarkAccent;
begin
  // Accent mantido igual ao Blue, para preservar identidade do app
  FAccent := TAlphaColor($FF3B82F6);
  FAccentHover := TAlphaColor($FF2563EB);
  FAccentLight := TAlphaColor($FF60A5FA);

  FBadgeInfoBg := TAlphaColor($263B82F6);
  FBadgeInfoText := TAlphaColor($FF60A5FA);
end;

procedure TDockHubTheme.ApplyDarkButtons;
begin
  FButtonPrimaryBg := FAccent;
  FButtonPrimaryHoverBg := FAccentHover;
  FButtonPrimaryText := TAlphaColor($FFFFFFFF);

  FButtonDangerBg := TAlphaColor($FFEF4444);
  FButtonDangerHoverBg := TAlphaColor($FFDC2626);
  FButtonDangerText := TAlphaColor($FFFFFFFF);
  FButtonDangerOutlineText := TAlphaColor($FFF87171);

  FButtonGhostText := TAlphaColor($FFB0B0B0);
end;

procedure TDockHubTheme.ApplyDarkGradient;
begin
  FGradientStart := FBackground;
  FGradientEnd := FSurfaceElevated;
end;

procedure TDockHubTheme.ApplyDarkStatus;
begin
  // Status para tema escuro
  FStatusSuccess := TAlphaColor($FF22C55E);
  FStatusDanger := TAlphaColor($FFEF4444);
  FStatusWarning := TAlphaColor($FFF59E0B);
  FStatusNeutral := TAlphaColor($FF64748B);
end;

procedure TDockHubTheme.ApplyDarkBadges;
begin
  // Fundo translúcido + texto claro
  FBadgeSuccessBg := TAlphaColor($2E22C55E);
  FBadgeSuccessText := TAlphaColor($FF4ADE80);

  FBadgeDangerBg := TAlphaColor($2EEF4444);
  FBadgeDangerText := TAlphaColor($FFF87171);

  FBadgeWarningBg := TAlphaColor($2EF59E0B);
  FBadgeWarningText := TAlphaColor($FFFBBF24);

  FBadgeNeutralBg := TAlphaColor($2E64748B);
  FBadgeNeutralText := TAlphaColor($FFB0B0B0);
end;

procedure TDockHubTheme.ApplyDark;
begin
  FTheme := TDockHubThemeType.Dark;

  ApplyDarkSurfaces;
  ApplyDarkText;
  ApplyDarkAccent;
  ApplyDarkButtons;
  ApplyDarkGradient;
  ApplyDarkStatus;
  ApplyDarkBadges;
end;


procedure TDockHubTheme.ApplyTealSurfaces;
begin
  FBackground := TAlphaColor($FF0A1717);
  FSurfaceCard := TAlphaColor($FF132424);
  FSurfaceElevated := TAlphaColor($FF1B3131);
  FBorder := TAlphaColor($FF2A4545);
  FDivider := TAlphaColor($FF1F3535);
end;

procedure TDockHubTheme.ApplyTealText;
begin
  FTextPrimary := TAlphaColor($FFF0F5F5);
  FTextSecondary := TAlphaColor($FF8FA8A8);
  FTextDisabled := TAlphaColor($FF5C7373);
end;

procedure TDockHubTheme.ApplyTealAccent;
begin
  FAccent := TAlphaColor($FF008080);
  FAccentHover := TAlphaColor($FF006666);
  FAccentLight := TAlphaColor($FF2DD4D4);

  FBadgeInfoBg := TAlphaColor($2E008080);
  FBadgeInfoText := TAlphaColor($FF2DD4D4);
end;

procedure TDockHubTheme.ApplyTealButtons;
begin
  FButtonPrimaryBg := FAccent;
  FButtonPrimaryHoverBg := FAccentHover;
  FButtonPrimaryText := TAlphaColor($FFFFFFFF);

  FButtonDangerBg := TAlphaColor($FFEF4444);
  FButtonDangerHoverBg := TAlphaColor($FFDC2626);
  FButtonDangerText := TAlphaColor($FFFFFFFF);
  FButtonDangerOutlineText := TAlphaColor($FFF87171);

  FButtonGhostText := TAlphaColor($FF94A8A8);
end;

procedure TDockHubTheme.ApplyTealGradient;
begin
  FGradientStart := FBackground;
  FGradientEnd := FSurfaceElevated;
end;

procedure TDockHubTheme.ApplyTealStatus;
begin
  FStatusSuccess := TAlphaColor($FF22C55E);
  FStatusDanger := TAlphaColor($FFEF4444);
  FStatusWarning := TAlphaColor($FFF59E0B);
  FStatusNeutral := TAlphaColor($FF64748B);
end;

procedure TDockHubTheme.ApplyTealBadges;
begin
  FBadgeSuccessBg := TAlphaColor($2622C55E);
  FBadgeSuccessText := TAlphaColor($FF4ADE80);

  FBadgeDangerBg := TAlphaColor($26EF4444);
  FBadgeDangerText := TAlphaColor($FFF87171);

  FBadgeWarningBg := TAlphaColor($26F59E0B);
  FBadgeWarningText := TAlphaColor($FFFBBF24);

  FBadgeNeutralBg := TAlphaColor($2664748B);
  FBadgeNeutralText := TAlphaColor($FF94A3B8);
end;

procedure TDockHubTheme.ApplyTeal;
begin
  FTheme := TDockHubThemeType.Teal;

  ApplyTealSurfaces;
  ApplyTealText;
  ApplyTealAccent;
  ApplyTealButtons;
  ApplyTealGradient;
  ApplyTealStatus;
  ApplyTealBadges;
end;

procedure TDockHubTheme.ApplyLightSurfaces;
begin
  FBackground := TAlphaColor($FFE8E8E8);
  FSurfaceCard := TAlphaColor($FFFFFFFF);
  FSurfaceElevated := TAlphaColor($FFF5F5F5);
  FBorder := TAlphaColor($FFD4D4D4);
  FDivider := TAlphaColor($FFE0E0E0);
end;

procedure TDockHubTheme.ApplyLightText;
begin
  FTextPrimary := TAlphaColor($FF1A1A1A);
  FTextSecondary := TAlphaColor($FF595959);
  FTextDisabled := TAlphaColor($FFA6A6A6);
end;

procedure TDockHubTheme.ApplyLightAccent;
begin
  // Accent mantido igual ao Blue, para preservar identidade do app
  FAccent := TAlphaColor($FF3B82F6);
  FAccentHover := TAlphaColor($FF2563EB);
  FAccentLight := TAlphaColor($FF60A5FA);

  // Fundo sólido claro + texto escuro
  FBadgeInfoBg := TAlphaColor($FFDBEAFE);
  FBadgeInfoText := TAlphaColor($FF2563EB);
end;

procedure TDockHubTheme.ApplyLightButtons;
begin
  FButtonPrimaryBg := FAccent;
  FButtonPrimaryHoverBg := FAccentHover;
  FButtonPrimaryText := TAlphaColor($FFFFFFFF);

  FButtonDangerBg := TAlphaColor($FFDC2626);
  FButtonDangerHoverBg := TAlphaColor($FFB91C1C);
  FButtonDangerText := TAlphaColor($FFFFFFFF);
  FButtonDangerOutlineText := TAlphaColor($FFB91C1C);

  FButtonGhostText := TAlphaColor($FF595959);
end;

procedure TDockHubTheme.ApplyLightGradient;
begin
  FGradientStart := FBackground;
  FGradientEnd := FSurfaceElevated;
end;

procedure TDockHubTheme.ApplyLightStatus;
begin
  // Cores mais escuras/saturadas para contraste sobre fundo claro
  FStatusSuccess := TAlphaColor($FF15803D);
  FStatusDanger := TAlphaColor($FFB91C1C);
  FStatusWarning := TAlphaColor($FFB45309);
  FStatusNeutral := TAlphaColor($FF6B7280);
end;

procedure TDockHubTheme.ApplyLightBadges;
begin
  // Fundo sólido claro + texto escuro
  FBadgeSuccessBg := TAlphaColor($FFDCFCE7);
  FBadgeSuccessText := TAlphaColor($FF15803D);

  FBadgeDangerBg := TAlphaColor($FFFEE2E2);
  FBadgeDangerText := TAlphaColor($FFB91C1C);

  FBadgeWarningBg := TAlphaColor($FFFEF3C7);
  FBadgeWarningText := TAlphaColor($FFB45309);

  FBadgeNeutralBg := TAlphaColor($FFF3F4F6);
  FBadgeNeutralText := TAlphaColor($FF4B5563);
end;

procedure TDockHubTheme.ApplyLight;
begin
  FTheme := TDockHubThemeType.Light;

  ApplyLightSurfaces;
  ApplyLightText;
  ApplyLightAccent;
  ApplyLightButtons;
  ApplyLightGradient;
  ApplyLightStatus;
  ApplyLightBadges;
end;

function TDockHubTheme.Theme: TDockHubThemeType;
begin
  Result := FTheme;
end;

function TDockHubTheme.Theme(
  const AValue: TDockHubThemeType): IDockHubTheme;
begin
  case AValue of
    TDockHubThemeType.Blue: ApplyBlue;
    TDockHubThemeType.Teal: ApplyTeal;
    TDockHubThemeType.Light: ApplyLight;
    TDockHubThemeType.Dark : ApplyDark;
  end;

  Result := Self;
end;

function TDockHubTheme.Background: TAlphaColor;
begin
  Result := FBackground;
end;

function TDockHubTheme.BackgroundGradient(AFill: TBrush): IDockHubTheme;
begin
  Result := BackgroundGradient(AFill, 65);
end;

function TDockHubTheme.SurfaceCard: TAlphaColor;
begin
  Result := FSurfaceCard;
end;

function TDockHubTheme.SurfaceElevated: TAlphaColor;
begin
  Result := FSurfaceElevated;
end;

function TDockHubTheme.Border: TAlphaColor;
begin
  Result := FBorder;
end;

function TDockHubTheme.Divider: TAlphaColor;
begin
  Result := FDivider;
end;

function TDockHubTheme.TextPrimary: TAlphaColor;
begin
  Result := FTextPrimary;
end;

function TDockHubTheme.TextSecondary: TAlphaColor;
begin
  Result := FTextSecondary;
end;

function TDockHubTheme.TextDisabled: TAlphaColor;
begin
  Result := FTextDisabled;
end;

function TDockHubTheme.Accent: TAlphaColor;
begin
  Result := FAccent;
end;

function TDockHubTheme.AccentHover: TAlphaColor;
begin
  Result := FAccentHover;
end;

function TDockHubTheme.AccentLight: TAlphaColor;
begin
  Result := FAccentLight;
end;

function TDockHubTheme.BadgeInfoBg: TAlphaColor;
begin
  Result := FBadgeInfoBg;
end;

function TDockHubTheme.BadgeInfoText: TAlphaColor;
begin
  Result := FBadgeInfoText;
end;

function TDockHubTheme.ButtonPrimaryBg: TAlphaColor;
begin
  Result := FButtonPrimaryBg;
end;

function TDockHubTheme.ButtonPrimaryHoverBg: TAlphaColor;
begin
  Result := FButtonPrimaryHoverBg;
end;

function TDockHubTheme.ButtonPrimaryText: TAlphaColor;
begin
  Result := FButtonPrimaryText;
end;

function TDockHubTheme.GradientStart: TAlphaColor;
begin
  Result := FGradientStart;
end;

function TDockHubTheme.GradientEnd: TAlphaColor;
begin
  Result := FGradientEnd;
end;

function TDockHubTheme.Transparent: TAlphaColor;
begin
  Result := TAlphaColor($00000000);
end;

function TDockHubTheme.StatusSuccess: TAlphaColor;
begin
  Result := FStatusSuccess;
end;

function TDockHubTheme.StatusDanger: TAlphaColor;
begin
  Result := FStatusDanger;
end;

function TDockHubTheme.StatusWarning: TAlphaColor;
begin
  Result := FStatusWarning;
end;

function TDockHubTheme.StatusNeutral: TAlphaColor;
begin
  Result := FStatusNeutral;
end;

function TDockHubTheme.BadgeSuccessBg: TAlphaColor;
begin
  Result := FBadgeSuccessBg;
end;

function TDockHubTheme.BadgeSuccessText: TAlphaColor;
begin
  Result := FBadgeSuccessText;
end;

function TDockHubTheme.BadgeDangerBg: TAlphaColor;
begin
  Result := FBadgeDangerBg;
end;

function TDockHubTheme.BadgeDangerText: TAlphaColor;
begin
  Result := FBadgeDangerText;
end;

function TDockHubTheme.BadgeWarningBg: TAlphaColor;
begin
  Result := FBadgeWarningBg;
end;

function TDockHubTheme.BadgeWarningText: TAlphaColor;
begin
  Result := FBadgeWarningText;
end;

function TDockHubTheme.BadgeNeutralBg: TAlphaColor;
begin
  Result := FBadgeNeutralBg;
end;

function TDockHubTheme.BadgeNeutralText: TAlphaColor;
begin
  Result := FBadgeNeutralText;
end;

function TDockHubTheme.ButtonDangerBg: TAlphaColor;
begin
  Result := FButtonDangerBg;
end;

function TDockHubTheme.ButtonDangerHoverBg: TAlphaColor;
begin
  Result := FButtonDangerHoverBg;
end;

function TDockHubTheme.ButtonDangerText: TAlphaColor;
begin
  Result := FButtonDangerText;
end;

function TDockHubTheme.ButtonDangerOutlineText: TAlphaColor;
begin
  Result := FButtonDangerOutlineText;
end;

function TDockHubTheme.ButtonGhostText: TAlphaColor;
begin
  Result := FButtonGhostText;
end;

procedure TDockHubTheme.ConfigureGradientBrush(AFill: TBrush);
begin
  AFill.Kind := TBrushKind.Gradient;
  AFill.Gradient.Style := TGradientStyle.Linear;
  AFill.Gradient.Points.Clear;
end;

procedure TDockHubTheme.ConfigureGradientColors(AFill: TBrush);
var
  LPoint: TGradientPoint;
begin
  LPoint := TGradientPoint(AFill.Gradient.Points.Add);
  LPoint.Color := FGradientStart;
  LPoint.Offset := 0;

  LPoint := TGradientPoint(AFill.Gradient.Points.Add);
  LPoint.Color := FGradientEnd;
  LPoint.Offset := 1;
end;

procedure TDockHubTheme.ConfigureGradientPositions(
  AFill: TBrush; const AAngle: Single);
var
  LAngle: Double;
  LX: Double;
  LY: Double;
  LMax: Double;
  LScale: Double;
begin
  LAngle := DegToRad(AAngle);

  LX := Cos(LAngle);
  LY := Sin(LAngle);

  LMax := Max(Abs(LX), Abs(LY));

  if SameValue(LMax, 0) then
    Exit;

  LScale := 0.5 / LMax;

  AFill.Gradient.StartPosition.X := 0.5 - (LX * LScale);
  AFill.Gradient.StartPosition.Y := 0.5 - (LY * LScale);

  AFill.Gradient.StopPosition.X := 0.5 + (LX * LScale);
  AFill.Gradient.StopPosition.Y := 0.5 + (LY * LScale);
end;

function TDockHubTheme.BackgroundGradient(
  AFill: TBrush; const AAngle: Single): IDockHubTheme;
begin
  Result := Self;

  if not Assigned(AFill) then
    Exit;

  ConfigureGradientBrush(AFill);
  ConfigureGradientColors(AFill);
  ConfigureGradientPositions(AFill, AAngle);
end;

function TDockHubTheme.BadgeBackground(
  const AStatusOk: Boolean): TAlphaColor;
begin
  if AStatusOk then
    Result := FBadgeSuccessBg
  else
    Result := FBadgeDangerBg;
end;

function TDockHubTheme.BadgeText(
  const AStatusOk: Boolean): TAlphaColor;
begin
  if AStatusOk then
    Result := FBadgeSuccessText
  else
    Result := FBadgeDangerText;
end;

end.

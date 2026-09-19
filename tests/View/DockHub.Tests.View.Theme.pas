unit DockHub.Tests.View.Theme;

interface

uses
  DUnitX.TestFramework,

  System.Classes,
  System.UITypes,

  DockHub.View.Theme.Types,
  DockHub.View.Theme.Contracts;

type
  TDockHubExpectedTheme = record
    ThemeType: TDockHubThemeType;

    Background: TAlphaColor;
    SurfaceCard: TAlphaColor;
    SurfaceElevated: TAlphaColor;
    Border: TAlphaColor;
    Divider: TAlphaColor;

    TextPrimary: TAlphaColor;
    TextSecondary: TAlphaColor;
    TextDisabled: TAlphaColor;

    Accent: TAlphaColor;
    AccentHover: TAlphaColor;
    AccentLight: TAlphaColor;

    BadgeInfoBg: TAlphaColor;
    BadgeInfoText: TAlphaColor;

    ButtonPrimaryBg: TAlphaColor;
    ButtonPrimaryHoverBg: TAlphaColor;
    ButtonPrimaryText: TAlphaColor;

    GradientStart: TAlphaColor;
    GradientEnd: TAlphaColor;

    Transparent: TAlphaColor;

    StatusSuccess: TAlphaColor;
    StatusDanger: TAlphaColor;
    StatusWarning: TAlphaColor;
    StatusNeutral: TAlphaColor;

    BadgeSuccessBg: TAlphaColor;
    BadgeSuccessText: TAlphaColor;
    BadgeDangerBg: TAlphaColor;
    BadgeDangerText: TAlphaColor;
    BadgeWarningBg: TAlphaColor;
    BadgeWarningText: TAlphaColor;
    BadgeNeutralBg: TAlphaColor;
    BadgeNeutralText: TAlphaColor;

    ButtonDangerBg: TAlphaColor;
    ButtonDangerHoverBg: TAlphaColor;
    ButtonDangerText: TAlphaColor;
    ButtonDangerOutlineText: TAlphaColor;
    ButtonGhostText: TAlphaColor;
  end;

  [TestFixture]
  TDockHubThemeTests = class
  private
    FTheme: IDockHubTheme;

    function ExpectedBlue: TDockHubExpectedTheme;
    function ExpectedTeal: TDockHubExpectedTheme;
    function ExpectedLight: TDockHubExpectedTheme;
    function ExpectedDark: TDockHubExpectedTheme;

    { Asserts agrupados por área da paleta - cada um cobre um subconjunto
      coeso de campos, mantendo os métodos curtos e de baixa complexidade. }
    procedure AssertSurfaceColors(
      const AExpected: TDockHubExpectedTheme;
      const AActual: IDockHubTheme);

    procedure AssertTextColors(
      const AExpected: TDockHubExpectedTheme;
      const AActual: IDockHubTheme);

    procedure AssertAccentColors(
      const AExpected: TDockHubExpectedTheme;
      const AActual: IDockHubTheme);

    procedure AssertBadgeInfoColors(
      const AExpected: TDockHubExpectedTheme;
      const AActual: IDockHubTheme);

    procedure AssertButtonPrimaryColors(
      const AExpected: TDockHubExpectedTheme;
      const AActual: IDockHubTheme);

    procedure AssertGradientColors(
      const AExpected: TDockHubExpectedTheme;
      const AActual: IDockHubTheme);

    procedure AssertStatusColors(
      const AExpected: TDockHubExpectedTheme;
      const AActual: IDockHubTheme);

    procedure AssertBadgeStatusColors(
      const AExpected: TDockHubExpectedTheme;
      const AActual: IDockHubTheme);

    procedure AssertButtonDangerColors(
      const AExpected: TDockHubExpectedTheme;
      const AActual: IDockHubTheme);

    procedure AssertThemePalette(
      const AExpected: TDockHubExpectedTheme;
      const AActual: IDockHubTheme);

    procedure AssertPositionEquals(
      const AExpected: Single;
      const AActual: Single;
      const AName: string);
  public
    [Setup]
    procedure Setup;

    [TearDown]
    procedure TearDown;

    [Test]
    procedure New_DefaultTheme_IsBlue;

    [Test]
    procedure New_DefaultTheme_HasExpectedBluePalette;

    [Test]
    procedure Theme_ChangesFromBlueToTeal;

    [Test]
    procedure Theme_ChangesFromBlueToLight;

    [Test]
    procedure Theme_ChangesFromBlueToDark;

    [Test]
    procedure Theme_ChangesBackToBlue;

    [Test]
    procedure Theme_SequentialChanges_UpdateEntirePalette;

    [Test]
    procedure BackgroundGradient_ConfiguresGradientBrush;

    [Test]
    procedure BackgroundGradient_ChangesWithTheme;

    [Test]
    procedure BackgroundGradient_DefaultAngle_Equals65Degrees;

    [Test]
    procedure BackgroundGradient_ZeroDegrees;

    [Test]
    procedure BackgroundGradient_NinetyDegrees;

    [Test]
    procedure BackgroundGradient_Nil_DoesNotRaiseException;

    [Test]
    procedure BadgeBackground_True_ReturnsSuccess;

    [Test]
    procedure BadgeBackground_False_ReturnsDanger;

    [Test]
    procedure BadgeText_True_ReturnsSuccess;

    [Test]
    procedure BadgeText_False_ReturnsDanger;
  end;

implementation

uses
  System.SysUtils,
  System.Math,
  FMX.Graphics,
  FMX.Types,
  DockHub.View.Theme.Impl;

const
  _POSITION_TOLERANCE = 0.0001;

{ -----------------------------------------------------------------------
  Dados de paleta esperados por tema.

  Em vez de funções procedimentais com ~35 atribuições sequenciais
  (Result.Campo := Valor), os valores são declarados como CONSTANTES
  TIPADAS. Isso separa DADO de LÓGICA: as funções Expected* abaixo
  passam a ser apenas "Result := CExpectedXxx", eliminando o excesso
  de linhas/repetição que gerava a alta toxicidade.
  ----------------------------------------------------------------------- }

const
  _MAP_THEME_BLUE: TDockHubExpectedTheme = (
    ThemeType: TDockHubThemeType.Blue;

    Background: TAlphaColor($FF0F172A);
    SurfaceCard: TAlphaColor($FF1E293B);
    SurfaceElevated: TAlphaColor($FF273449);
    Border: TAlphaColor($FF334155);
    Divider: TAlphaColor($FF2A3441);

    TextPrimary: TAlphaColor($FFF1F5F9);
    TextSecondary: TAlphaColor($FF94A3B8);
    TextDisabled: TAlphaColor($FF64748B);

    Accent: TAlphaColor($FF3B82F6);
    AccentHover: TAlphaColor($FF2563EB);
    AccentLight: TAlphaColor($FF60A5FA);

    BadgeInfoBg: TAlphaColor($263B82F6);
    BadgeInfoText: TAlphaColor($FF60A5FA);

    ButtonPrimaryBg: TAlphaColor($FF3B82F6);
    ButtonPrimaryHoverBg: TAlphaColor($FF2563EB);
    ButtonPrimaryText: TAlphaColor($FFFFFFFF);

    GradientStart: TAlphaColor($FF0F172A);
    GradientEnd: TAlphaColor($FF1E293B);

    Transparent: TAlphaColor($00000000);

    StatusSuccess: TAlphaColor($FF22C55E);
    StatusDanger: TAlphaColor($FFEF4444);
    StatusWarning: TAlphaColor($FFF59E0B);
    StatusNeutral: TAlphaColor($FF64748B);

    BadgeSuccessBg: TAlphaColor($2622C55E);
    BadgeSuccessText: TAlphaColor($FF4ADE80);
    BadgeDangerBg: TAlphaColor($26EF4444);
    BadgeDangerText: TAlphaColor($FFF87171);
    BadgeWarningBg: TAlphaColor($26F59E0B);
    BadgeWarningText: TAlphaColor($FFFBBF24);
    BadgeNeutralBg: TAlphaColor($2664748B);
    BadgeNeutralText: TAlphaColor($FF94A3B8);

    ButtonDangerBg: TAlphaColor($FFEF4444);
    ButtonDangerHoverBg: TAlphaColor($FFDC2626);
    ButtonDangerText: TAlphaColor($FFFFFFFF);
    ButtonDangerOutlineText: TAlphaColor($FFF87171);
    ButtonGhostText: TAlphaColor($FF94A3B8);
  );

  _MAP_THEME_TEAL: TDockHubExpectedTheme = (
    ThemeType: TDockHubThemeType.Teal;

    Background: TAlphaColor($FF0A1717);
    SurfaceCard: TAlphaColor($FF132424);
    SurfaceElevated: TAlphaColor($FF1B3131);
    Border: TAlphaColor($FF2A4545);
    Divider: TAlphaColor($FF1F3535);

    TextPrimary: TAlphaColor($FFF0F5F5);
    TextSecondary: TAlphaColor($FF8FA8A8);
    TextDisabled: TAlphaColor($FF5C7373);

    Accent: TAlphaColor($FF008080);
    AccentHover: TAlphaColor($FF006666);
    AccentLight: TAlphaColor($FF2DD4D4);

    BadgeInfoBg: TAlphaColor($2E008080);
    BadgeInfoText: TAlphaColor($FF2DD4D4);

    ButtonPrimaryBg: TAlphaColor($FF008080);
    ButtonPrimaryHoverBg: TAlphaColor($FF006666);
    ButtonPrimaryText: TAlphaColor($FFFFFFFF);

    GradientStart: TAlphaColor($FF0A1717);
    GradientEnd: TAlphaColor($FF1B3131);

    Transparent: TAlphaColor($00000000);

    StatusSuccess: TAlphaColor($FF22C55E);
    StatusDanger: TAlphaColor($FFEF4444);
    StatusWarning: TAlphaColor($FFF59E0B);
    StatusNeutral: TAlphaColor($FF64748B);

    BadgeSuccessBg: TAlphaColor($2622C55E);
    BadgeSuccessText: TAlphaColor($FF4ADE80);
    BadgeDangerBg: TAlphaColor($26EF4444);
    BadgeDangerText: TAlphaColor($FFF87171);
    BadgeWarningBg: TAlphaColor($26F59E0B);
    BadgeWarningText: TAlphaColor($FFFBBF24);
    BadgeNeutralBg: TAlphaColor($2664748B);
    BadgeNeutralText: TAlphaColor($FF94A3B8);

    ButtonDangerBg: TAlphaColor($FFEF4444);
    ButtonDangerHoverBg: TAlphaColor($FFDC2626);
    ButtonDangerText: TAlphaColor($FFFFFFFF);
    ButtonDangerOutlineText: TAlphaColor($FFF87171);
    ButtonGhostText: TAlphaColor($FF94A8A8);
  );

  _MAP_THEME_LIGHT: TDockHubExpectedTheme = (
    ThemeType: TDockHubThemeType.Light;

    Background: TAlphaColor($FFE8E8E8);
    SurfaceCard: TAlphaColor($FFFFFFFF);
    SurfaceElevated: TAlphaColor($FFF5F5F5);
    Border: TAlphaColor($FFD4D4D4);
    Divider: TAlphaColor($FFE0E0E0);

    TextPrimary: TAlphaColor($FF1A1A1A);
    TextSecondary: TAlphaColor($FF595959);
    TextDisabled: TAlphaColor($FFA6A6A6);

    Accent: TAlphaColor($FF3B82F6);
    AccentHover: TAlphaColor($FF2563EB);
    AccentLight: TAlphaColor($FF60A5FA);

    BadgeInfoBg: TAlphaColor($FFDBEAFE);
    BadgeInfoText: TAlphaColor($FF2563EB);

    ButtonPrimaryBg: TAlphaColor($FF3B82F6);
    ButtonPrimaryHoverBg: TAlphaColor($FF2563EB);
    ButtonPrimaryText: TAlphaColor($FFFFFFFF);

    GradientStart: TAlphaColor($FFE8E8E8);
    GradientEnd: TAlphaColor($FFF5F5F5);

    Transparent: TAlphaColor($00000000);

    StatusSuccess: TAlphaColor($FF15803D);
    StatusDanger: TAlphaColor($FFB91C1C);
    StatusWarning: TAlphaColor($FFB45309);
    StatusNeutral: TAlphaColor($FF6B7280);

    BadgeSuccessBg: TAlphaColor($FFDCFCE7);
    BadgeSuccessText: TAlphaColor($FF15803D);
    BadgeDangerBg: TAlphaColor($FFFEE2E2);
    BadgeDangerText: TAlphaColor($FFB91C1C);
    BadgeWarningBg: TAlphaColor($FFFEF3C7);
    BadgeWarningText: TAlphaColor($FFB45309);
    BadgeNeutralBg: TAlphaColor($FFF3F4F6);
    BadgeNeutralText: TAlphaColor($FF4B5563);

    ButtonDangerBg: TAlphaColor($FFDC2626);
    ButtonDangerHoverBg: TAlphaColor($FFB91C1C);
    ButtonDangerText: TAlphaColor($FFFFFFFF);
    ButtonDangerOutlineText: TAlphaColor($FFB91C1C);
    ButtonGhostText: TAlphaColor($FF595959);
  );

  _MAP_THEME_DARK: TDockHubExpectedTheme = (
    ThemeType: TDockHubThemeType.Dark;

    Background: TAlphaColor($FF303030);
    SurfaceCard: TAlphaColor($FF3D3D3D);
    SurfaceElevated: TAlphaColor($FF474747);
    Border: TAlphaColor($FF525252);
    Divider: TAlphaColor($FF3A3A3A);

    TextPrimary: TAlphaColor($FFF5F5F5);
    TextSecondary: TAlphaColor($FFB0B0B0);
    TextDisabled: TAlphaColor($FF757575);

    Accent: TAlphaColor($FF3B82F6);
    AccentHover: TAlphaColor($FF2563EB);
    AccentLight: TAlphaColor($FF60A5FA);

    BadgeInfoBg: TAlphaColor($263B82F6);
    BadgeInfoText: TAlphaColor($FF60A5FA);

    ButtonPrimaryBg: TAlphaColor($FF3B82F6);
    ButtonPrimaryHoverBg: TAlphaColor($FF2563EB);
    ButtonPrimaryText: TAlphaColor($FFFFFFFF);

    GradientStart: TAlphaColor($FF303030);
    GradientEnd: TAlphaColor($FF474747);

    Transparent: TAlphaColor($00000000);

    StatusSuccess: TAlphaColor($FF22C55E);
    StatusDanger: TAlphaColor($FFEF4444);
    StatusWarning: TAlphaColor($FFF59E0B);
    StatusNeutral: TAlphaColor($FF64748B);

    BadgeSuccessBg: TAlphaColor($2E22C55E);
    BadgeSuccessText: TAlphaColor($FF4ADE80);
    BadgeDangerBg: TAlphaColor($2EEF4444);
    BadgeDangerText: TAlphaColor($FFF87171);
    BadgeWarningBg: TAlphaColor($2EF59E0B);
    BadgeWarningText: TAlphaColor($FFFBBF24);
    BadgeNeutralBg: TAlphaColor($2E64748B);
    BadgeNeutralText: TAlphaColor($FFB0B0B0);

    ButtonDangerBg: TAlphaColor($FFEF4444);
    ButtonDangerHoverBg: TAlphaColor($FFDC2626);
    ButtonDangerText: TAlphaColor($FFFFFFFF);
    ButtonDangerOutlineText: TAlphaColor($FFF87171);
    ButtonGhostText: TAlphaColor($FFB0B0B0);
  );

{ TDockHubThemeTests }

procedure TDockHubThemeTests.Setup;
begin
  FTheme := TDockHubTheme.New;
end;

procedure TDockHubThemeTests.TearDown;
begin
  FTheme := nil;
end;

function TDockHubThemeTests.ExpectedBlue: TDockHubExpectedTheme;
begin
  Result := _MAP_THEME_BLUE;
end;

function TDockHubThemeTests.ExpectedTeal: TDockHubExpectedTheme;
begin
  Result := _MAP_THEME_TEAL;
end;

function TDockHubThemeTests.ExpectedLight: TDockHubExpectedTheme;
begin
  Result := _MAP_THEME_LIGHT;
end;

function TDockHubThemeTests.ExpectedDark: TDockHubExpectedTheme;
begin
  Result := _MAP_THEME_DARK;
end;

{ -----------------------------------------------------------------------
  Asserts agrupados por área da paleta.

  AssertThemePalette deixa de concentrar ~35 Assert.AreEqual em um único
  corpo e passa a orquestrar chamadas a métodos menores, cada um
  responsável por um subconjunto coeso de campos.
  ----------------------------------------------------------------------- }

procedure TDockHubThemeTests.AssertSurfaceColors(
  const AExpected: TDockHubExpectedTheme;
  const AActual: IDockHubTheme);
begin
  Assert.AreEqual<TDockHubThemeType>(AExpected.ThemeType, AActual.Theme);

  Assert.AreEqual<TAlphaColor>(AExpected.Background, AActual.Background);
  Assert.AreEqual<TAlphaColor>(AExpected.SurfaceCard, AActual.SurfaceCard);
  Assert.AreEqual<TAlphaColor>(AExpected.SurfaceElevated, AActual.SurfaceElevated);
  Assert.AreEqual<TAlphaColor>(AExpected.Border, AActual.Border);
  Assert.AreEqual<TAlphaColor>(AExpected.Divider, AActual.Divider);
end;

procedure TDockHubThemeTests.AssertTextColors(
  const AExpected: TDockHubExpectedTheme;
  const AActual: IDockHubTheme);
begin
  Assert.AreEqual<TAlphaColor>(AExpected.TextPrimary, AActual.TextPrimary);
  Assert.AreEqual<TAlphaColor>(AExpected.TextSecondary, AActual.TextSecondary);
  Assert.AreEqual<TAlphaColor>(AExpected.TextDisabled, AActual.TextDisabled);
end;

procedure TDockHubThemeTests.AssertAccentColors(
  const AExpected: TDockHubExpectedTheme;
  const AActual: IDockHubTheme);
begin
  Assert.AreEqual<TAlphaColor>(AExpected.Accent, AActual.Accent);
  Assert.AreEqual<TAlphaColor>(AExpected.AccentHover, AActual.AccentHover);
  Assert.AreEqual<TAlphaColor>(AExpected.AccentLight, AActual.AccentLight);
end;

procedure TDockHubThemeTests.AssertBadgeInfoColors(
  const AExpected: TDockHubExpectedTheme;
  const AActual: IDockHubTheme);
begin
  Assert.AreEqual<TAlphaColor>(AExpected.BadgeInfoBg, AActual.BadgeInfoBg);
  Assert.AreEqual<TAlphaColor>(AExpected.BadgeInfoText, AActual.BadgeInfoText);
end;

procedure TDockHubThemeTests.AssertButtonPrimaryColors(
  const AExpected: TDockHubExpectedTheme;
  const AActual: IDockHubTheme);
begin
  Assert.AreEqual<TAlphaColor>(AExpected.ButtonPrimaryBg, AActual.ButtonPrimaryBg);
  Assert.AreEqual<TAlphaColor>(AExpected.ButtonPrimaryHoverBg, AActual.ButtonPrimaryHoverBg);
  Assert.AreEqual<TAlphaColor>(AExpected.ButtonPrimaryText, AActual.ButtonPrimaryText);
end;

procedure TDockHubThemeTests.AssertGradientColors(
  const AExpected: TDockHubExpectedTheme;
  const AActual: IDockHubTheme);
begin
  Assert.AreEqual<TAlphaColor>(AExpected.GradientStart, AActual.GradientStart);
  Assert.AreEqual<TAlphaColor>(AExpected.GradientEnd, AActual.GradientEnd);
  Assert.AreEqual<TAlphaColor>(AExpected.Transparent, AActual.Transparent);
end;

procedure TDockHubThemeTests.AssertStatusColors(
  const AExpected: TDockHubExpectedTheme;
  const AActual: IDockHubTheme);
begin
  Assert.AreEqual<TAlphaColor>(AExpected.StatusSuccess, AActual.StatusSuccess);
  Assert.AreEqual<TAlphaColor>(AExpected.StatusDanger, AActual.StatusDanger);
  Assert.AreEqual<TAlphaColor>(AExpected.StatusWarning, AActual.StatusWarning);
  Assert.AreEqual<TAlphaColor>(AExpected.StatusNeutral, AActual.StatusNeutral);
end;

procedure TDockHubThemeTests.AssertBadgeStatusColors(
  const AExpected: TDockHubExpectedTheme;
  const AActual: IDockHubTheme);
begin
  Assert.AreEqual<TAlphaColor>(AExpected.BadgeSuccessBg, AActual.BadgeSuccessBg);
  Assert.AreEqual<TAlphaColor>(AExpected.BadgeSuccessText, AActual.BadgeSuccessText);
  Assert.AreEqual<TAlphaColor>(AExpected.BadgeDangerBg, AActual.BadgeDangerBg);
  Assert.AreEqual<TAlphaColor>(AExpected.BadgeDangerText, AActual.BadgeDangerText);
  Assert.AreEqual<TAlphaColor>(AExpected.BadgeWarningBg, AActual.BadgeWarningBg);
  Assert.AreEqual<TAlphaColor>(AExpected.BadgeWarningText, AActual.BadgeWarningText);
  Assert.AreEqual<TAlphaColor>(AExpected.BadgeNeutralBg, AActual.BadgeNeutralBg);
  Assert.AreEqual<TAlphaColor>(AExpected.BadgeNeutralText, AActual.BadgeNeutralText);
end;

procedure TDockHubThemeTests.AssertButtonDangerColors(
  const AExpected: TDockHubExpectedTheme;
  const AActual: IDockHubTheme);
begin
  Assert.AreEqual<TAlphaColor>(AExpected.ButtonDangerBg, AActual.ButtonDangerBg);
  Assert.AreEqual<TAlphaColor>(AExpected.ButtonDangerHoverBg, AActual.ButtonDangerHoverBg);
  Assert.AreEqual<TAlphaColor>(AExpected.ButtonDangerText, AActual.ButtonDangerText);
  Assert.AreEqual<TAlphaColor>(AExpected.ButtonDangerOutlineText, AActual.ButtonDangerOutlineText);
  Assert.AreEqual<TAlphaColor>(AExpected.ButtonGhostText, AActual.ButtonGhostText);
end;

procedure TDockHubThemeTests.AssertThemePalette(
  const AExpected: TDockHubExpectedTheme;
  const AActual: IDockHubTheme);
begin
  AssertSurfaceColors(AExpected, AActual);
  AssertTextColors(AExpected, AActual);
  AssertAccentColors(AExpected, AActual);
  AssertBadgeInfoColors(AExpected, AActual);
  AssertButtonPrimaryColors(AExpected, AActual);
  AssertGradientColors(AExpected, AActual);
  AssertStatusColors(AExpected, AActual);
  AssertBadgeStatusColors(AExpected, AActual);
  AssertButtonDangerColors(AExpected, AActual);
end;

procedure TDockHubThemeTests.AssertPositionEquals(
  const AExpected: Single;
  const AActual: Single;
  const AName: string);
begin
  Assert.IsTrue(
    SameValue(AExpected, AActual, _POSITION_TOLERANCE),
    Format('%s: expected %.6f, actual %.6f', [AName, AExpected, AActual])
  );
end;

procedure TDockHubThemeTests.New_DefaultTheme_IsBlue;
begin
  Assert.AreEqual<TDockHubThemeType>(
    TDockHubThemeType.Blue,
    FTheme.Theme
  );
end;

procedure TDockHubThemeTests.New_DefaultTheme_HasExpectedBluePalette;
begin
  AssertThemePalette(ExpectedBlue, FTheme);
end;

procedure TDockHubThemeTests.Theme_ChangesFromBlueToTeal;
var
  LPreviousBackground: TAlphaColor;
begin
  LPreviousBackground := FTheme.Background;

  FTheme.Theme(TDockHubThemeType.Teal);

  Assert.IsTrue(LPreviousBackground <> FTheme.Background);
  AssertThemePalette(ExpectedTeal, FTheme);
end;

procedure TDockHubThemeTests.Theme_ChangesFromBlueToLight;
var
  LPreviousBackground: TAlphaColor;
begin
  LPreviousBackground := FTheme.Background;

  FTheme.Theme(TDockHubThemeType.Light);

  Assert.IsTrue(LPreviousBackground <> FTheme.Background);
  AssertThemePalette(ExpectedLight, FTheme);
end;

procedure TDockHubThemeTests.Theme_ChangesFromBlueToDark;
var
  LPreviousBackground: TAlphaColor;
begin
  LPreviousBackground := FTheme.Background;

  FTheme.Theme(TDockHubThemeType.Dark);

  Assert.IsTrue(LPreviousBackground <> FTheme.Background);
  AssertThemePalette(ExpectedDark, FTheme);
end;

procedure TDockHubThemeTests.Theme_ChangesBackToBlue;
var
  LPreviousBackground: TAlphaColor;
begin
  FTheme.Theme(TDockHubThemeType.Dark);
  LPreviousBackground := FTheme.Background;

  FTheme.Theme(TDockHubThemeType.Blue);

  Assert.IsTrue(LPreviousBackground <> FTheme.Background);
  AssertThemePalette(ExpectedBlue, FTheme);
end;

procedure TDockHubThemeTests.Theme_SequentialChanges_UpdateEntirePalette;
var
  LPreviousBackground: TAlphaColor;
begin
  AssertThemePalette(ExpectedBlue, FTheme);

  LPreviousBackground := FTheme.Background;
  FTheme.Theme(TDockHubThemeType.Teal);
  Assert.IsTrue(LPreviousBackground <> FTheme.Background);
  AssertThemePalette(ExpectedTeal, FTheme);

  LPreviousBackground := FTheme.Background;
  FTheme.Theme(TDockHubThemeType.Dark);
  Assert.IsTrue(LPreviousBackground <> FTheme.Background);
  AssertThemePalette(ExpectedDark, FTheme);

  LPreviousBackground := FTheme.Background;
  FTheme.Theme(TDockHubThemeType.Light);
  Assert.IsTrue(LPreviousBackground <> FTheme.Background);
  AssertThemePalette(ExpectedLight, FTheme);

  LPreviousBackground := FTheme.Background;
  FTheme.Theme(TDockHubThemeType.Blue);
  Assert.IsTrue(LPreviousBackground <> FTheme.Background);
  AssertThemePalette(ExpectedBlue, FTheme);
end;

procedure TDockHubThemeTests.BackgroundGradient_ConfiguresGradientBrush;
var
  LBrush: TBrush;
begin
  LBrush := TBrush.Create(TBrushKind.Solid, TAlphaColor($00000000));
  try
    FTheme.BackgroundGradient(LBrush);

    Assert.AreEqual<TBrushKind>(TBrushKind.Gradient, LBrush.Kind);
    Assert.AreEqual<TGradientStyle>(TGradientStyle.Linear, LBrush.Gradient.Style);
    Assert.AreEqual(2, LBrush.Gradient.Points.Count);

    Assert.AreEqual<TAlphaColor>(FTheme.GradientStart, LBrush.Gradient.Points[0].Color);
    Assert.AreEqual<TAlphaColor>(FTheme.GradientEnd, LBrush.Gradient.Points[1].Color);

    AssertPositionEquals(0, LBrush.Gradient.Points[0].Offset, 'Gradient.Points[0].Offset');
    AssertPositionEquals(1, LBrush.Gradient.Points[1].Offset, 'Gradient.Points[1].Offset');
  finally
    LBrush.Free;
  end;
end;

procedure TDockHubThemeTests.BackgroundGradient_ChangesWithTheme;
var
  LBrush: TBrush;
  LBlue: TDockHubExpectedTheme;
  LDark: TDockHubExpectedTheme;
begin
  LBlue := ExpectedBlue;
  LDark := ExpectedDark;

  LBrush := TBrush.Create(TBrushKind.Solid, TAlphaColor($00000000));
  try
    FTheme.Theme(TDockHubThemeType.Blue);
    FTheme.BackgroundGradient(LBrush);

    Assert.AreEqual<TAlphaColor>(LBlue.GradientStart, LBrush.Gradient.Points[0].Color);
    Assert.AreEqual<TAlphaColor>(LBlue.GradientEnd, LBrush.Gradient.Points[1].Color);

    FTheme.Theme(TDockHubThemeType.Dark);
    FTheme.BackgroundGradient(LBrush);

    Assert.AreEqual<TAlphaColor>(LDark.GradientStart, LBrush.Gradient.Points[0].Color);
    Assert.AreEqual<TAlphaColor>(LDark.GradientEnd, LBrush.Gradient.Points[1].Color);
    Assert.AreEqual(2, LBrush.Gradient.Points.Count);
  finally
    LBrush.Free;
  end;
end;

procedure TDockHubThemeTests.BackgroundGradient_DefaultAngle_Equals65Degrees;
var
  LDefaultBrush: TBrush;
  LExplicitBrush: TBrush;
begin
  LDefaultBrush := TBrush.Create(TBrushKind.Solid, TAlphaColor($00000000));
  LExplicitBrush := TBrush.Create(TBrushKind.Solid, TAlphaColor($00000000));
  try
    FTheme.BackgroundGradient(LDefaultBrush);
    FTheme.BackgroundGradient(LExplicitBrush, 65);

    AssertPositionEquals(
      LExplicitBrush.Gradient.StartPosition.X,
      LDefaultBrush.Gradient.StartPosition.X,
      'Default.StartPosition.X'
    );

    AssertPositionEquals(
      LExplicitBrush.Gradient.StartPosition.Y,
      LDefaultBrush.Gradient.StartPosition.Y,
      'Default.StartPosition.Y'
    );

    AssertPositionEquals(
      LExplicitBrush.Gradient.StopPosition.X,
      LDefaultBrush.Gradient.StopPosition.X,
      'Default.StopPosition.X'
    );

    AssertPositionEquals(
      LExplicitBrush.Gradient.StopPosition.Y,
      LDefaultBrush.Gradient.StopPosition.Y,
      'Default.StopPosition.Y'
    );
  finally
    LExplicitBrush.Free;
    LDefaultBrush.Free;
  end;
end;

procedure TDockHubThemeTests.BackgroundGradient_ZeroDegrees;
var
  LBrush: TBrush;
begin
  LBrush := TBrush.Create(TBrushKind.Solid, TAlphaColor($00000000));
  try
    FTheme.BackgroundGradient(LBrush, 0);

    AssertPositionEquals(0.0, LBrush.Gradient.StartPosition.X, 'Zero.StartPosition.X');
    AssertPositionEquals(0.5, LBrush.Gradient.StartPosition.Y, 'Zero.StartPosition.Y');
    AssertPositionEquals(1.0, LBrush.Gradient.StopPosition.X, 'Zero.StopPosition.X');
    AssertPositionEquals(0.5, LBrush.Gradient.StopPosition.Y, 'Zero.StopPosition.Y');
  finally
    LBrush.Free;
  end;
end;

procedure TDockHubThemeTests.BackgroundGradient_NinetyDegrees;
var
  LBrush: TBrush;
begin
  LBrush := TBrush.Create(TBrushKind.Solid, TAlphaColor($00000000));
  try
    FTheme.BackgroundGradient(LBrush, 90);

    AssertPositionEquals(0.5, LBrush.Gradient.StartPosition.X, 'Ninety.StartPosition.X');
    AssertPositionEquals(0.0, LBrush.Gradient.StartPosition.Y, 'Ninety.StartPosition.Y');
    AssertPositionEquals(0.5, LBrush.Gradient.StopPosition.X, 'Ninety.StopPosition.X');
    AssertPositionEquals(1.0, LBrush.Gradient.StopPosition.Y, 'Ninety.StopPosition.Y');
  finally
    LBrush.Free;
  end;
end;

procedure TDockHubThemeTests.BackgroundGradient_Nil_DoesNotRaiseException;
begin
  FTheme.BackgroundGradient(nil);

  Assert.AreEqual<TDockHubThemeType>(
    TDockHubThemeType.Blue,
    FTheme.Theme
  );
end;

procedure TDockHubThemeTests.BadgeBackground_True_ReturnsSuccess;
begin
  Assert.AreEqual<TAlphaColor>(
    FTheme.BadgeSuccessBg,
    FTheme.BadgeBackground(True)
  );
end;

procedure TDockHubThemeTests.BadgeBackground_False_ReturnsDanger;
begin
  Assert.AreEqual<TAlphaColor>(
    FTheme.BadgeDangerBg,
    FTheme.BadgeBackground(False)
  );
end;

procedure TDockHubThemeTests.BadgeText_True_ReturnsSuccess;
begin
  Assert.AreEqual<TAlphaColor>(
    FTheme.BadgeSuccessText,
    FTheme.BadgeText(True)
  );
end;

procedure TDockHubThemeTests.BadgeText_False_ReturnsDanger;
begin
  Assert.AreEqual<TAlphaColor>(
    FTheme.BadgeDangerText,
    FTheme.BadgeText(False)
  );
end;

initialization
  TDUnitX.RegisterTestFixture(
    TDockHubThemeTests
  );

end.

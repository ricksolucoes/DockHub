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
  Result.ThemeType := TDockHubThemeType.Blue;

  Result.Background := TAlphaColor($FF0F172A);
  Result.SurfaceCard := TAlphaColor($FF1E293B);
  Result.SurfaceElevated := TAlphaColor($FF273449);
  Result.Border := TAlphaColor($FF334155);
  Result.Divider := TAlphaColor($FF2A3441);

  Result.TextPrimary := TAlphaColor($FFF1F5F9);
  Result.TextSecondary := TAlphaColor($FF94A3B8);
  Result.TextDisabled := TAlphaColor($FF64748B);

  Result.Accent := TAlphaColor($FF3B82F6);
  Result.AccentHover := TAlphaColor($FF2563EB);
  Result.AccentLight := TAlphaColor($FF60A5FA);

  Result.BadgeInfoBg := TAlphaColor($263B82F6);
  Result.BadgeInfoText := TAlphaColor($FF60A5FA);

  Result.ButtonPrimaryBg := TAlphaColor($FF3B82F6);
  Result.ButtonPrimaryHoverBg := TAlphaColor($FF2563EB);
  Result.ButtonPrimaryText := TAlphaColor($FFFFFFFF);

  Result.GradientStart := TAlphaColor($FF0F172A);
  Result.GradientEnd := TAlphaColor($FF1E293B);

  Result.Transparent := TAlphaColor($00000000);

  Result.StatusSuccess := TAlphaColor($FF22C55E);
  Result.StatusDanger := TAlphaColor($FFEF4444);
  Result.StatusWarning := TAlphaColor($FFF59E0B);
  Result.StatusNeutral := TAlphaColor($FF64748B);

  Result.BadgeSuccessBg := TAlphaColor($2622C55E);
  Result.BadgeSuccessText := TAlphaColor($FF4ADE80);
  Result.BadgeDangerBg := TAlphaColor($26EF4444);
  Result.BadgeDangerText := TAlphaColor($FFF87171);
  Result.BadgeWarningBg := TAlphaColor($26F59E0B);
  Result.BadgeWarningText := TAlphaColor($FFFBBF24);
  Result.BadgeNeutralBg := TAlphaColor($2664748B);
  Result.BadgeNeutralText := TAlphaColor($FF94A3B8);

  Result.ButtonDangerBg := TAlphaColor($FFEF4444);
  Result.ButtonDangerHoverBg := TAlphaColor($FFDC2626);
  Result.ButtonDangerText := TAlphaColor($FFFFFFFF);
  Result.ButtonDangerOutlineText := TAlphaColor($FFF87171);
  Result.ButtonGhostText := TAlphaColor($FF94A3B8);
end;

function TDockHubThemeTests.ExpectedTeal: TDockHubExpectedTheme;
begin
  Result.ThemeType := TDockHubThemeType.Teal;

  Result.Background := TAlphaColor($FF0A1717);
  Result.SurfaceCard := TAlphaColor($FF132424);
  Result.SurfaceElevated := TAlphaColor($FF1B3131);
  Result.Border := TAlphaColor($FF2A4545);
  Result.Divider := TAlphaColor($FF1F3535);

  Result.TextPrimary := TAlphaColor($FFF0F5F5);
  Result.TextSecondary := TAlphaColor($FF8FA8A8);
  Result.TextDisabled := TAlphaColor($FF5C7373);

  Result.Accent := TAlphaColor($FF008080);
  Result.AccentHover := TAlphaColor($FF006666);
  Result.AccentLight := TAlphaColor($FF2DD4D4);

  Result.BadgeInfoBg := TAlphaColor($2E008080);
  Result.BadgeInfoText := TAlphaColor($FF2DD4D4);

  Result.ButtonPrimaryBg := TAlphaColor($FF008080);
  Result.ButtonPrimaryHoverBg := TAlphaColor($FF006666);
  Result.ButtonPrimaryText := TAlphaColor($FFFFFFFF);

  Result.GradientStart := TAlphaColor($FF0A1717);
  Result.GradientEnd := TAlphaColor($FF1B3131);

  Result.Transparent := TAlphaColor($00000000);

  Result.StatusSuccess := TAlphaColor($FF22C55E);
  Result.StatusDanger := TAlphaColor($FFEF4444);
  Result.StatusWarning := TAlphaColor($FFF59E0B);
  Result.StatusNeutral := TAlphaColor($FF64748B);

  Result.BadgeSuccessBg := TAlphaColor($2622C55E);
  Result.BadgeSuccessText := TAlphaColor($FF4ADE80);
  Result.BadgeDangerBg := TAlphaColor($26EF4444);
  Result.BadgeDangerText := TAlphaColor($FFF87171);
  Result.BadgeWarningBg := TAlphaColor($26F59E0B);
  Result.BadgeWarningText := TAlphaColor($FFFBBF24);
  Result.BadgeNeutralBg := TAlphaColor($2664748B);
  Result.BadgeNeutralText := TAlphaColor($FF94A3B8);

  Result.ButtonDangerBg := TAlphaColor($FFEF4444);
  Result.ButtonDangerHoverBg := TAlphaColor($FFDC2626);
  Result.ButtonDangerText := TAlphaColor($FFFFFFFF);
  Result.ButtonDangerOutlineText := TAlphaColor($FFF87171);
  Result.ButtonGhostText := TAlphaColor($FF94A8A8);
end;

function TDockHubThemeTests.ExpectedLight: TDockHubExpectedTheme;
begin
  Result.ThemeType := TDockHubThemeType.Light;

  Result.Background := TAlphaColor($FFE8E8E8);
  Result.SurfaceCard := TAlphaColor($FFFFFFFF);
  Result.SurfaceElevated := TAlphaColor($FFF5F5F5);
  Result.Border := TAlphaColor($FFD4D4D4);
  Result.Divider := TAlphaColor($FFE0E0E0);

  Result.TextPrimary := TAlphaColor($FF1A1A1A);
  Result.TextSecondary := TAlphaColor($FF595959);
  Result.TextDisabled := TAlphaColor($FFA6A6A6);

  Result.Accent := TAlphaColor($FF3B82F6);
  Result.AccentHover := TAlphaColor($FF2563EB);
  Result.AccentLight := TAlphaColor($FF60A5FA);

  Result.BadgeInfoBg := TAlphaColor($FFDBEAFE);
  Result.BadgeInfoText := TAlphaColor($FF2563EB);

  Result.ButtonPrimaryBg := TAlphaColor($FF3B82F6);
  Result.ButtonPrimaryHoverBg := TAlphaColor($FF2563EB);
  Result.ButtonPrimaryText := TAlphaColor($FFFFFFFF);

  Result.GradientStart := TAlphaColor($FFE8E8E8);
  Result.GradientEnd := TAlphaColor($FFF5F5F5);

  Result.Transparent := TAlphaColor($00000000);

  Result.StatusSuccess := TAlphaColor($FF15803D);
  Result.StatusDanger := TAlphaColor($FFB91C1C);
  Result.StatusWarning := TAlphaColor($FFB45309);
  Result.StatusNeutral := TAlphaColor($FF6B7280);

  Result.BadgeSuccessBg := TAlphaColor($FFDCFCE7);
  Result.BadgeSuccessText := TAlphaColor($FF15803D);
  Result.BadgeDangerBg := TAlphaColor($FFFEE2E2);
  Result.BadgeDangerText := TAlphaColor($FFB91C1C);
  Result.BadgeWarningBg := TAlphaColor($FFFEF3C7);
  Result.BadgeWarningText := TAlphaColor($FFB45309);
  Result.BadgeNeutralBg := TAlphaColor($FFF3F4F6);
  Result.BadgeNeutralText := TAlphaColor($FF4B5563);

  Result.ButtonDangerBg := TAlphaColor($FFDC2626);
  Result.ButtonDangerHoverBg := TAlphaColor($FFB91C1C);
  Result.ButtonDangerText := TAlphaColor($FFFFFFFF);
  Result.ButtonDangerOutlineText := TAlphaColor($FFB91C1C);
  Result.ButtonGhostText := TAlphaColor($FF595959);
end;

function TDockHubThemeTests.ExpectedDark: TDockHubExpectedTheme;
begin
  Result.ThemeType := TDockHubThemeType.Dark;

  Result.Background := TAlphaColor($FF303030);
  Result.SurfaceCard := TAlphaColor($FF3D3D3D);
  Result.SurfaceElevated := TAlphaColor($FF474747);
  Result.Border := TAlphaColor($FF525252);
  Result.Divider := TAlphaColor($FF3A3A3A);

  Result.TextPrimary := TAlphaColor($FFF5F5F5);
  Result.TextSecondary := TAlphaColor($FFB0B0B0);
  Result.TextDisabled := TAlphaColor($FF757575);

  Result.Accent := TAlphaColor($FF3B82F6);
  Result.AccentHover := TAlphaColor($FF2563EB);
  Result.AccentLight := TAlphaColor($FF60A5FA);

  Result.BadgeInfoBg := TAlphaColor($263B82F6);
  Result.BadgeInfoText := TAlphaColor($FF60A5FA);

  Result.ButtonPrimaryBg := TAlphaColor($FF3B82F6);
  Result.ButtonPrimaryHoverBg := TAlphaColor($FF2563EB);
  Result.ButtonPrimaryText := TAlphaColor($FFFFFFFF);

  Result.GradientStart := TAlphaColor($FF303030);
  Result.GradientEnd := TAlphaColor($FF474747);

  Result.Transparent := TAlphaColor($00000000);

  Result.StatusSuccess := TAlphaColor($FF22C55E);
  Result.StatusDanger := TAlphaColor($FFEF4444);
  Result.StatusWarning := TAlphaColor($FFF59E0B);
  Result.StatusNeutral := TAlphaColor($FF64748B);

  Result.BadgeSuccessBg := TAlphaColor($2E22C55E);
  Result.BadgeSuccessText := TAlphaColor($FF4ADE80);
  Result.BadgeDangerBg := TAlphaColor($2EEF4444);
  Result.BadgeDangerText := TAlphaColor($FFF87171);
  Result.BadgeWarningBg := TAlphaColor($2EF59E0B);
  Result.BadgeWarningText := TAlphaColor($FFFBBF24);
  Result.BadgeNeutralBg := TAlphaColor($2E64748B);
  Result.BadgeNeutralText := TAlphaColor($FFB0B0B0);

  Result.ButtonDangerBg := TAlphaColor($FFEF4444);
  Result.ButtonDangerHoverBg := TAlphaColor($FFDC2626);
  Result.ButtonDangerText := TAlphaColor($FFFFFFFF);
  Result.ButtonDangerOutlineText := TAlphaColor($FFF87171);
  Result.ButtonGhostText := TAlphaColor($FFB0B0B0);
end;

procedure TDockHubThemeTests.AssertThemePalette(
  const AExpected: TDockHubExpectedTheme;
  const AActual: IDockHubTheme);
begin
  Assert.AreEqual<TDockHubThemeType>(AExpected.ThemeType, AActual.Theme);

  Assert.AreEqual<TAlphaColor>(AExpected.Background, AActual.Background);
  Assert.AreEqual<TAlphaColor>(AExpected.SurfaceCard, AActual.SurfaceCard);
  Assert.AreEqual<TAlphaColor>(AExpected.SurfaceElevated, AActual.SurfaceElevated);
  Assert.AreEqual<TAlphaColor>(AExpected.Border, AActual.Border);
  Assert.AreEqual<TAlphaColor>(AExpected.Divider, AActual.Divider);

  Assert.AreEqual<TAlphaColor>(AExpected.TextPrimary, AActual.TextPrimary);
  Assert.AreEqual<TAlphaColor>(AExpected.TextSecondary, AActual.TextSecondary);
  Assert.AreEqual<TAlphaColor>(AExpected.TextDisabled, AActual.TextDisabled);

  Assert.AreEqual<TAlphaColor>(AExpected.Accent, AActual.Accent);
  Assert.AreEqual<TAlphaColor>(AExpected.AccentHover, AActual.AccentHover);
  Assert.AreEqual<TAlphaColor>(AExpected.AccentLight, AActual.AccentLight);

  Assert.AreEqual<TAlphaColor>(AExpected.BadgeInfoBg, AActual.BadgeInfoBg);
  Assert.AreEqual<TAlphaColor>(AExpected.BadgeInfoText, AActual.BadgeInfoText);

  Assert.AreEqual<TAlphaColor>(AExpected.ButtonPrimaryBg, AActual.ButtonPrimaryBg);
  Assert.AreEqual<TAlphaColor>(AExpected.ButtonPrimaryHoverBg, AActual.ButtonPrimaryHoverBg);
  Assert.AreEqual<TAlphaColor>(AExpected.ButtonPrimaryText, AActual.ButtonPrimaryText);

  Assert.AreEqual<TAlphaColor>(AExpected.GradientStart, AActual.GradientStart);
  Assert.AreEqual<TAlphaColor>(AExpected.GradientEnd, AActual.GradientEnd);

  Assert.AreEqual<TAlphaColor>(AExpected.Transparent, AActual.Transparent);

  Assert.AreEqual<TAlphaColor>(AExpected.StatusSuccess, AActual.StatusSuccess);
  Assert.AreEqual<TAlphaColor>(AExpected.StatusDanger, AActual.StatusDanger);
  Assert.AreEqual<TAlphaColor>(AExpected.StatusWarning, AActual.StatusWarning);
  Assert.AreEqual<TAlphaColor>(AExpected.StatusNeutral, AActual.StatusNeutral);

  Assert.AreEqual<TAlphaColor>(AExpected.BadgeSuccessBg, AActual.BadgeSuccessBg);
  Assert.AreEqual<TAlphaColor>(AExpected.BadgeSuccessText, AActual.BadgeSuccessText);
  Assert.AreEqual<TAlphaColor>(AExpected.BadgeDangerBg, AActual.BadgeDangerBg);
  Assert.AreEqual<TAlphaColor>(AExpected.BadgeDangerText, AActual.BadgeDangerText);
  Assert.AreEqual<TAlphaColor>(AExpected.BadgeWarningBg, AActual.BadgeWarningBg);
  Assert.AreEqual<TAlphaColor>(AExpected.BadgeWarningText, AActual.BadgeWarningText);
  Assert.AreEqual<TAlphaColor>(AExpected.BadgeNeutralBg, AActual.BadgeNeutralBg);
  Assert.AreEqual<TAlphaColor>(AExpected.BadgeNeutralText, AActual.BadgeNeutralText);

  Assert.AreEqual<TAlphaColor>(AExpected.ButtonDangerBg, AActual.ButtonDangerBg);
  Assert.AreEqual<TAlphaColor>(AExpected.ButtonDangerHoverBg, AActual.ButtonDangerHoverBg);
  Assert.AreEqual<TAlphaColor>(AExpected.ButtonDangerText, AActual.ButtonDangerText);
  Assert.AreEqual<TAlphaColor>(AExpected.ButtonDangerOutlineText, AActual.ButtonDangerOutlineText);
  Assert.AreEqual<TAlphaColor>(AExpected.ButtonGhostText, AActual.ButtonGhostText);
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

unit DockHub.View.Theme.Contracts;

interface

uses
  System.UITypes,
  FMX.Graphics,
  DockHub.View.Theme.Types;

type
  IDockHubTheme = interface(IInterface)
    ['{FABB29CC-76DA-4B97-8443-6341356B740E}']

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
  end;

implementation

end.

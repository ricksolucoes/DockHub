unit DockHub.View.Page.Impl.Main.Composition;

interface

uses
  System.Classes,
  System.UITypes,

  FMX.Objects,
  FMX.StdCtrls,

  DockHub.Core.Language.Contracts,
  DockHub.View.Theme.Contracts,

  Rick.UIBuilder.Interfaces,
  DockHub.View.Page.Contracts,
  DockHub.View.Page.Composition.Impl.Base;

type
  TPageMainComposition = class(TPageCompositionBase, IPageCompositionMain)
  private
    FCard: TRectangle;

    FTitleLabel: TLabel;
    FSubtitleLabel: TLabel;
    FHeaderDivider: TRectangle;

    FServiceLabel: TLabel;
    FApiLabel: TLabel;
    FPortLabel: TLabel;
    FEnvironmentLabel: TLabel;
    FServiceBadge: IRickUIBuilderBadgeHandle;
    FApiBadge: IRickUIBuilderBadgeHandle;
    FPortValue: TLabel;
    FEnvironmentValue: TLabel;
    FStatusDivider: TRectangle;

    FInstallButton: IRickUIBuilderButtonHandle;
    FUninstallButton: IRickUIBuilderButtonHandle;
    FStartButton: IRickUIBuilderButtonHandle;
    FStopButton: IRickUIBuilderButtonHandle;
    FConfigButton: IRickUIBuilderButtonHandle;
    FLogsButton: IRickUIBuilderButtonHandle;

    procedure BuildSurface;
    procedure BuildHeader;
    procedure BuildRuntimeStatus;
    procedure BuildActions;
    procedure BuildServiceActions;
    procedure BuildResourceActions;

    procedure ApplySurfaceTheme;
    procedure ApplyTextTheme;
    procedure ApplyBadgeTheme;
    procedure ApplyActionTheme;
  protected
    procedure DoBuild; override;
    procedure DoApplyTheme; override;
    procedure DoApplyLanguage(const ALanguage: IDockHubLanguage); override;
  public
    class function New: IPageCompositionMain; static;
  end;

implementation

uses
  FMX.Types,
  FMX.Graphics,

  System.SysUtils,

  DockHub.Core.Language.Keys.View.Main,

  Rick.UIBuilder;

const
  _CARD_WIDTH = 428;
  _CARD_HEIGHT = 470;
  _CARD_RADIUS = 24;
  _CARD_BORDER_THICKNESS = 2;

  _CONTENT_MARGIN = 21;
  _CONTENT_WIDTH = 385;
  _CONTENT_RIGHT = _CONTENT_MARGIN + _CONTENT_WIDTH;
  _VALUE_WIDTH = 110;
  _VALUE_LEFT = _CONTENT_RIGHT - _VALUE_WIDTH;

  _ACTION_BUTTON_HEIGHT = 40;
  _ACTION_BUTTON_GAP = 10;
  _ACTION_BUTTON_WIDTH = (_CONTENT_WIDTH - _ACTION_BUTTON_GAP) / 2;
  _ACTION_RIGHT_LEFT = _CONTENT_MARGIN + _ACTION_BUTTON_WIDTH +
    _ACTION_BUTTON_GAP;

  _DISABLED_OPACITY = 0.45;

{ TPageMainComposition }

class function TPageMainComposition.New: IPageCompositionMain;
begin
  Result := TPageMainComposition.Create;
end;

procedure TPageMainComposition.DoBuild;
begin
  BuildSurface;
  BuildHeader;
  BuildRuntimeStatus;
  BuildActions;
end;

procedure TPageMainComposition.DoApplyTheme;
begin
  FCurrentTheme.BackgroundGradient(FForm.Fill);

  ApplySurfaceTheme;
  ApplyTextTheme;
  ApplyBadgeTheme;
  ApplyActionTheme;
end;

procedure TPageMainComposition.DoApplyLanguage(
  const ALanguage: IDockHubLanguage);
begin
  FForm.Caption := ALanguage.Translate(_VIEW_MAIN_CAPTION);

  FSubtitleLabel.Text := ALanguage.Translate(_VIEW_MAIN_SUBTITLE);
  FServiceLabel.Text := ALanguage.Translate(_VIEW_MAIN_SERVICE);
  FApiLabel.Text := ALanguage.Translate(_VIEW_MAIN_API);
  FPortLabel.Text := ALanguage.Translate(_VIEW_MAIN_PORT);
  FEnvironmentLabel.Text := ALanguage.Translate(_VIEW_MAIN_ENVIRONMENT);

  FServiceBadge.TextLabel.Text :=
    ALanguage.Translate(_VIEW_MAIN_STATUS_UNVERIFIED);
  FApiBadge.TextLabel.Text :=
    ALanguage.Translate(_VIEW_MAIN_STATUS_UNVERIFIED);

  FInstallButton.TextLabel.Text := ALanguage.Translate(_VIEW_MAIN_INSTALL);
  FUninstallButton.TextLabel.Text := ALanguage.Translate(_VIEW_MAIN_UNINSTALL);
  FStartButton.TextLabel.Text := ALanguage.Translate(_VIEW_MAIN_START);
  FStopButton.TextLabel.Text := ALanguage.Translate(_VIEW_MAIN_STOP);
  FConfigButton.TextLabel.Text := ALanguage.Translate(_VIEW_MAIN_OPEN_CONFIGURATION);
  FLogsButton.TextLabel.Text := ALanguage.Translate(_VIEW_MAIN_OPEN_LOGS);
end;

procedure TPageMainComposition.BuildSurface;
begin
  FCard := TRectangle.Create(FForm);
  FCard.Parent := FForm;
  FCard.Align := TAlignLayout.Center;
  FCard.Width := _CARD_WIDTH;
  FCard.Height := _CARD_HEIGHT;
  FCard.XRadius := _CARD_RADIUS;
  FCard.YRadius := _CARD_RADIUS;
  FCard.Fill.Kind := TBrushKind.Solid;
  FCard.Fill.Color := TAlphaColors.Null;
  FCard.Stroke.Kind := TBrushKind.Solid;
  FCard.Stroke.Color := TAlphaColors.Null;
  FCard.Stroke.Thickness := _CARD_BORDER_THICKNESS;
end;

procedure TPageMainComposition.BuildHeader;
begin
  FTitleLabel := TRickUIBuilder.Label_
    .Text('DockHub')
    .Position(_CONTENT_MARGIN, 18)
    .Size(183, 30)
    .FontSize(21)
    .Build(FCard);

  FSubtitleLabel := TRickUIBuilder.Label_
    .Text(EmptyStr)
    .Position(_CONTENT_MARGIN, 48)
    .Size(220, 24)
    .FontSize(16)
    .Build(FCard);

  FHeaderDivider := TRickUIBuilder.Divider
    .Position(0, 89)
    .Width(_CARD_WIDTH)
    .Build(FCard);
end;

procedure TPageMainComposition.BuildRuntimeStatus;
begin
  FServiceLabel := TRickUIBuilder.Label_
    .Text(EmptyStr)
    .Position(_CONTENT_MARGIN, 112)
    .Size(173, 26)
    .FontSize(15)
    .Build(FCard);

  FApiLabel := TRickUIBuilder.Label_
    .Text(EmptyStr)
    .Position(_CONTENT_MARGIN, 151)
    .Size(173, 26)
    .FontSize(15)
    .Build(FCard);

  FPortLabel := TRickUIBuilder.Label_
    .Text(EmptyStr)
    .Position(_CONTENT_MARGIN, 186)
    .Size(173, 26)
    .FontSize(15)
    .Build(FCard);

  FEnvironmentLabel := TRickUIBuilder.Label_
    .Text(EmptyStr)
    .Position(_CONTENT_MARGIN, 219)
    .Size(173, 26)
    .FontSize(15)
    .Build(FCard);

  FServiceBadge := TRickUIBuilder.Badge
    .Text(EmptyStr)
    .Position(_VALUE_LEFT, 113)
    .Size(_VALUE_WIDTH, 27)
    .Pill(True)
    .FontSize(14)
    .Build(FCard);

  FApiBadge := TRickUIBuilder.Badge
    .Text(EmptyStr)
    .Position(_VALUE_LEFT, 152)
    .Size(_VALUE_WIDTH, 27)
    .Pill(True)
    .FontSize(14)
    .Build(FCard);

  FPortValue := TRickUIBuilder.Label_
    .Text('-')
    .Position(_VALUE_LEFT, 186)
    .Size(_VALUE_WIDTH, 26)
    .FontSize(15)
    .Align(TTextAlign.Trailing)
    .Build(FCard);

  FEnvironmentValue := TRickUIBuilder.Label_
    .Text('-')
    .Position(_VALUE_LEFT, 219)
    .Size(_VALUE_WIDTH, 26)
    .FontSize(15)
    .Align(TTextAlign.Trailing)
    .Build(FCard);

  FStatusDivider := TRickUIBuilder.Divider
    .Position(_CONTENT_MARGIN, 266)
    .Width(_CONTENT_WIDTH)
    .Build(FCard);
end;

procedure TPageMainComposition.BuildActions;
begin
  BuildServiceActions;
  BuildResourceActions;
end;

procedure TPageMainComposition.BuildServiceActions;
begin
  FInstallButton := TRickUIBuilder.Button
    .Caption(EmptyStr)
    .Position(_CONTENT_MARGIN, 290)
    .Size(_ACTION_BUTTON_WIDTH, _ACTION_BUTTON_HEIGHT)
    .CornerRadius(16)
    .Enabled(False)
    .DisabledOpacity(_DISABLED_OPACITY)
    .Cursor(crDefault)
    .BuildHandle(FCard);

  FUninstallButton := TRickUIBuilder.Button
    .Caption(EmptyStr)
    .Position(_ACTION_RIGHT_LEFT, 290)
    .Size(_ACTION_BUTTON_WIDTH, _ACTION_BUTTON_HEIGHT)
    .CornerRadius(16)
    .Enabled(False)
    .DisabledOpacity(_DISABLED_OPACITY)
    .Cursor(crDefault)
    .BuildHandle(FCard);

  FStartButton := TRickUIBuilder.Button
    .Caption(EmptyStr)
    .Position(_CONTENT_MARGIN, 348)
    .Size(_ACTION_BUTTON_WIDTH, _ACTION_BUTTON_HEIGHT)
    .CornerRadius(16)
    .Enabled(False)
    .DisabledOpacity(_DISABLED_OPACITY)
    .Cursor(crDefault)
    .BuildHandle(FCard);

  FStopButton := TRickUIBuilder.Button
    .Caption(EmptyStr)
    .Position(_ACTION_RIGHT_LEFT, 348)
    .Size(_ACTION_BUTTON_WIDTH, _ACTION_BUTTON_HEIGHT)
    .CornerRadius(16)
    .Enabled(False)
    .DisabledOpacity(_DISABLED_OPACITY)
    .Cursor(crDefault)
    .BuildHandle(FCard);
end;

procedure TPageMainComposition.BuildResourceActions;
begin
  FConfigButton := TRickUIBuilder.Button
    .Caption(EmptyStr)
    .Position(_CONTENT_MARGIN, 409)
    .Size(_ACTION_BUTTON_WIDTH, 36)
    .CornerRadius(16)
    .FontSize(15)
    .Enabled(False)
    .DisabledOpacity(_DISABLED_OPACITY)
    .Cursor(crDefault)
    .BuildHandle(FCard);

  FLogsButton := TRickUIBuilder.Button
    .Caption(EmptyStr)
    .Position(_ACTION_RIGHT_LEFT, 409)
    .Size(_ACTION_BUTTON_WIDTH, 36)
    .CornerRadius(16)
    .FontSize(15)
    .Enabled(False)
    .DisabledOpacity(_DISABLED_OPACITY)
    .Cursor(crDefault)
    .BuildHandle(FCard);
end;

procedure TPageMainComposition.ApplySurfaceTheme;
begin
  FCard.Fill.Kind := TBrushKind.Solid;
  FCard.Fill.Color := FCurrentTheme.SurfaceCard;
  FCard.Stroke.Kind := TBrushKind.Solid;
  FCard.Stroke.Color := FCurrentTheme.Border;
  FCard.Stroke.Thickness := _CARD_BORDER_THICKNESS;

  FHeaderDivider.Fill.Color := FCurrentTheme.Divider;
  FStatusDivider.Fill.Color := FCurrentTheme.Divider;
end;

procedure TPageMainComposition.ApplyTextTheme;
begin
  FTitleLabel.TextSettings.FontColor := FCurrentTheme.TextPrimary;
  FSubtitleLabel.TextSettings.FontColor := FCurrentTheme.TextSecondary;

  FServiceLabel.TextSettings.FontColor := FCurrentTheme.TextSecondary;
  FApiLabel.TextSettings.FontColor := FCurrentTheme.TextSecondary;
  FPortLabel.TextSettings.FontColor := FCurrentTheme.TextSecondary;
  FEnvironmentLabel.TextSettings.FontColor := FCurrentTheme.TextSecondary;

  FPortValue.TextSettings.FontColor := FCurrentTheme.TextPrimary;
  FEnvironmentValue.TextSettings.FontColor := FCurrentTheme.TextPrimary;
end;

procedure TPageMainComposition.ApplyBadgeTheme;
begin
  FServiceBadge.Container.Fill.Kind := TBrushKind.Solid;
  FServiceBadge.Container.Fill.Color := FCurrentTheme.BadgeNeutralBg;
  FServiceBadge.Container.Stroke.Kind := TBrushKind.None;
  FServiceBadge.TextLabel.TextSettings.FontColor :=
    FCurrentTheme.BadgeNeutralText;

  FApiBadge.Container.Fill.Kind := TBrushKind.Solid;
  FApiBadge.Container.Fill.Color := FCurrentTheme.BadgeNeutralBg;
  FApiBadge.Container.Stroke.Kind := TBrushKind.None;
  FApiBadge.TextLabel.TextSettings.FontColor := FCurrentTheme.BadgeNeutralText;
end;

procedure TPageMainComposition.ApplyActionTheme;
begin
  ApplyButtonTheme(FInstallButton,
    FCurrentTheme.Transparent, FCurrentTheme.Border, FCurrentTheme.TextSecondary);

  ApplyButtonTheme(FUninstallButton,
    FCurrentTheme.Transparent, FCurrentTheme.ButtonDangerOutlineText,
    FCurrentTheme.ButtonDangerOutlineText);

  ApplyButtonTheme(FStartButton,
    FCurrentTheme.ButtonPrimaryBg, FCurrentTheme.Transparent,
    FCurrentTheme.ButtonPrimaryText);

  ApplyButtonTheme(FStopButton,
    FCurrentTheme.ButtonDangerBg, FCurrentTheme.Transparent,
    FCurrentTheme.ButtonDangerText);

  ApplyButtonTheme(FConfigButton,
    FCurrentTheme.Transparent, FCurrentTheme.Transparent,
    FCurrentTheme.ButtonGhostText);

  ApplyButtonTheme(FLogsButton,
    FCurrentTheme.Transparent, FCurrentTheme.Transparent,
    FCurrentTheme.ButtonGhostText);
end;

end.

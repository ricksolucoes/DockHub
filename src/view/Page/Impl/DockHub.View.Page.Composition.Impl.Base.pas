unit DockHub.View.Page.Composition.Impl.Base;

interface

uses
  System.Classes,
  System.UITypes,

  FMX.Forms,
  FMX.Types,
  FMX.Objects,

  DockHub.Core.Language.Contracts,
  DockHub.View.Theme.Contracts,

  Rick.UIBuilder.Interfaces,
  DockHub.View.Page.Types,
  DockHub.View.Page.Contracts;

type
  TPageCompositionBase = class abstract(TInterfacedObject, IPageComposition)
  strict private
    FState: TPageCompositionState;
    FOnMinimize: TNotifyEvent;
    FOnClose: TNotifyEvent;

    FMinimizeButton: IRickUIBuilderButtonHandle;
    FCloseButton: IRickUIBuilderButtonHandle;

    procedure CheckConfiguring;
    procedure CheckBuilt;
    procedure ValidateBuildConfiguration;

    procedure BuildWindowControls;
    procedure ApplyWindowTheme;

    procedure WindowButtonMouseEnter(Sender: TObject);
    procedure WindowButtonMouseLeave(Sender: TObject);
  protected
    FForm: TForm;
    FCurrentTheme: IDockHubTheme;

    procedure ApplyButtonTheme(const AButton: IRickUIBuilderButtonHandle;
      AFillColor, ABorderColor, ATextColor: TAlphaColor);

    procedure DoBuild; virtual; abstract;
    procedure DoApplyTheme; virtual; abstract;
    procedure DoApplyLanguage(
      const ALanguage: IDockHubLanguage); virtual; abstract;
  public
    constructor Create;

    function Form(const AForm: TForm): IPageComposition;
    function OnMinimize(
      const ANotifyEvent: TNotifyEvent): IPageComposition;
    function OnClose(const ANotifyEvent: TNotifyEvent): IPageComposition;

    function ApplyLanguage(
      const ALanguage: IDockHubLanguage): IPageComposition;
    function ApplyTheme(const ATheme: IDockHubTheme): IPageComposition;

    function Build: IPageComposition;
  end;

implementation

uses
  FMX.Graphics,

  Rick.UIBuilder;

const
  _WINDOW_BUTTON_WIDTH = 36;
  _WINDOW_BUTTON_HEIGHT = 30;
  _WINDOW_BUTTON_GAP = 4;
  _WINDOW_BUTTON_MARGIN = 8;

{ TPageCompositionBase }

constructor TPageCompositionBase.Create;
begin
  inherited;

  FState := TPageCompositionState.Configuring;
end;

procedure TPageCompositionBase.CheckConfiguring;
begin
  if FState <> TPageCompositionState.Configuring then
    raise EComponentError.Create(
      'Page composition configuration is closed after Build starts.'
    );
end;

procedure TPageCompositionBase.CheckBuilt;
begin
  if FState <> TPageCompositionState.Built then
    raise EComponentError.Create(
      'Page composition must be successfully built before this operation.'
    );
end;

procedure TPageCompositionBase.ValidateBuildConfiguration;
begin
  if not Assigned(FForm) then
    raise EComponentError.Create('Page composition requires a host form.');

  if not Assigned(FOnMinimize) then
    raise EComponentError.Create(
      'Page composition requires a minimize callback.'
    );

  if not Assigned(FOnClose) then
    raise EComponentError.Create('Page composition requires a close callback.');
end;

function TPageCompositionBase.Form(const AForm: TForm): IPageComposition;
begin
  Result := Self;
  CheckConfiguring;

  if not Assigned(AForm) then
    raise EComponentError.Create('Page composition host form cannot be nil.');

  FForm := AForm;
end;

function TPageCompositionBase.OnMinimize(
  const ANotifyEvent: TNotifyEvent): IPageComposition;
begin
  Result := Self;
  CheckConfiguring;

  if not Assigned(ANotifyEvent) then
    raise EComponentError.Create('Minimize callback cannot be nil.');

  FOnMinimize := ANotifyEvent;
end;

function TPageCompositionBase.OnClose(
  const ANotifyEvent: TNotifyEvent): IPageComposition;
begin
  Result := Self;
  CheckConfiguring;

  if not Assigned(ANotifyEvent) then
    raise EComponentError.Create('Close callback cannot be nil.');

  FOnClose := ANotifyEvent;
end;

function TPageCompositionBase.Build: IPageComposition;
begin
  Result := Self;

  if FState = TPageCompositionState.Built then
    Exit;

  if FState <> TPageCompositionState.Configuring then
    raise EComponentError.Create(
      'Page composition cannot build from its current state.'
    );

  ValidateBuildConfiguration;
  FState := TPageCompositionState.Building;

  try
    DoBuild;
    BuildWindowControls;
    FState := TPageCompositionState.Built;
  except
    FState := TPageCompositionState.Failed;
    raise;
  end;
end;

function TPageCompositionBase.ApplyTheme(
  const ATheme: IDockHubTheme): IPageComposition;
begin
  Result := Self;
  CheckBuilt;

  if ATheme = nil then
    raise EComponentError.Create('Page composition theme cannot be nil.');

  FCurrentTheme := ATheme;
  DoApplyTheme;
  ApplyWindowTheme;
end;

function TPageCompositionBase.ApplyLanguage(
  const ALanguage: IDockHubLanguage): IPageComposition;
begin
  Result := Self;
  CheckBuilt;

  if ALanguage = nil then
    raise EComponentError.Create('Page composition language cannot be nil.');

  DoApplyLanguage(ALanguage);
end;

procedure TPageCompositionBase.ApplyButtonTheme(
  const AButton: IRickUIBuilderButtonHandle; AFillColor, ABorderColor,
  ATextColor: TAlphaColor);
begin
  AButton.Container.Fill.Kind := TBrushKind.Solid;
  AButton.Container.Fill.Color := AFillColor;

  if ABorderColor = FCurrentTheme.Transparent then
    AButton.Container.Stroke.Kind := TBrushKind.None
  else
  begin
    AButton.Container.Stroke.Kind := TBrushKind.Solid;
    AButton.Container.Stroke.Color := ABorderColor;
    AButton.Container.Stroke.Thickness := 1;
  end;

  AButton.TextLabel.TextSettings.FontColor := ATextColor;
end;

procedure TPageCompositionBase.BuildWindowControls;
begin
  FMinimizeButton := TRickUIBuilder.Button
    .Caption(#$2212)
    .Position(
      FForm.ClientWidth
        - _WINDOW_BUTTON_MARGIN
        - (_WINDOW_BUTTON_WIDTH * 2)
        - _WINDOW_BUTTON_GAP,
      _WINDOW_BUTTON_MARGIN
    )
    .Size(_WINDOW_BUTTON_WIDTH, _WINDOW_BUTTON_HEIGHT)
    .CornerRadius(8)
    .OnClick(FOnMinimize)
    .OnHover(WindowButtonMouseEnter, WindowButtonMouseLeave)
    .BuildHandle(FForm);

  FCloseButton := TRickUIBuilder.Button
    .Caption(#$00D7)
    .Position(
      FForm.ClientWidth
        - _WINDOW_BUTTON_MARGIN
        - _WINDOW_BUTTON_WIDTH,
      _WINDOW_BUTTON_MARGIN
    )
    .Size(_WINDOW_BUTTON_WIDTH, _WINDOW_BUTTON_HEIGHT)
    .CornerRadius(8)
    .OnClick(FOnClose)
    .OnHover(WindowButtonMouseEnter, WindowButtonMouseLeave)
    .BuildHandle(FForm);

  FMinimizeButton.Container.BringToFront;
  FCloseButton.Container.BringToFront;
end;

procedure TPageCompositionBase.ApplyWindowTheme;
begin
  ApplyButtonTheme(
    FMinimizeButton,
    FCurrentTheme.Transparent,
    FCurrentTheme.Transparent,
    FCurrentTheme.TextSecondary
  );

  ApplyButtonTheme(
    FCloseButton,
    FCurrentTheme.Transparent,
    FCurrentTheme.Transparent,
    FCurrentTheme.TextSecondary
  );
end;

procedure TPageCompositionBase.WindowButtonMouseEnter(Sender: TObject);
begin
  if (FCurrentTheme <> nil) and (Sender is TRectangle) then
    TRectangle(Sender).Fill.Color := FCurrentTheme.SurfaceElevated;
end;

procedure TPageCompositionBase.WindowButtonMouseLeave(Sender: TObject);
begin
  if (FCurrentTheme <> nil) and (Sender is TRectangle) then
    TRectangle(Sender).Fill.Color := FCurrentTheme.Transparent;
end;

end.

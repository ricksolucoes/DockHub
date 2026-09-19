unit DockHub.View.Page.Main;

interface

uses
  FMX.Forms,

  System.Classes,

  DockHub.Core.Language.Types,
  DockHub.Core.Language.Contracts,

  DockHub.View.Theme.Types,
  DockHub.View.Theme.Contracts,

  DockHub.View.Page.Contracts;

type
  TPageMain = class(TForm)
  private
    FLanguage: IDockHubLanguage;
    FTheme: IDockHubTheme;
    FComposition: IPageCompositionMain;

    procedure ConfigureForm;
    procedure ConfigureComposition;
    procedure ApplyLanguage;
    procedure ApplyTheme;

    procedure ChangeLanguage(const AValue: TDockHubLanguageType);
    procedure ChangeTheme(const AValue: TDockHubThemeType);

    procedure MinimizeClick(Sender: TObject);
    procedure CloseClick(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  PageMain: TPageMain;

implementation

{$R *.fmx}

uses
  System.UITypes,

  DockHub.View.Constants,

  DockHub.Core.Language.Impl,
  DockHub.View.Theme.Impl,
  DockHub.View.Page.Impl.Main.Composition;

procedure TPageMain.ApplyLanguage;
begin
  FComposition.ApplyLanguage(FLanguage);
end;

procedure TPageMain.ApplyTheme;
begin
  FComposition.ApplyTheme(FTheme);
end;

procedure TPageMain.ChangeLanguage(const AValue: TDockHubLanguageType);
begin
  if FLanguage.Language = AValue then
    Exit;

  FLanguage.Language(AValue);
  ApplyLanguage;
end;

procedure TPageMain.ChangeTheme(const AValue: TDockHubThemeType);
begin
  if FTheme.Theme = AValue then
    Exit;

  FTheme.Theme(AValue);
  ApplyTheme;
end;

procedure TPageMain.CloseClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TPageMain.ConfigureComposition;
begin
  FComposition := TPageMainComposition.New;

  FComposition
    .Form(Self)
    .OnMinimize(MinimizeClick)
    .OnClose(CloseClick)
    .Build;
end;

procedure TPageMain.ConfigureForm;
begin
  BorderStyle := TFmxFormBorderStyle.None;
  Width := _FORM_WIDTH;
  Height := _FORM_HEIGHT;
  Position := TFormPosition.ScreenCenter;
end;

constructor TPageMain.Create(AOwner: TComponent);
begin
  inherited;

  FLanguage := TDockHubLanguage.New;
  FTheme := TDockHubTheme.New;

  ConfigureForm;
  ConfigureComposition;

  ApplyLanguage;
  ApplyTheme;
end;

procedure TPageMain.MinimizeClick(Sender: TObject);
begin
  WindowState := TWindowState.wsMinimized;
end;

end.

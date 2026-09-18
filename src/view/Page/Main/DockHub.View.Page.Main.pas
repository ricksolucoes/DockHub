unit DockHub.View.Page.Main;

interface

uses
  FMX.Forms,

  System.Classes,

  DockHub.Core.Language.Types,
  DockHub.Core.Language.Contracts,

  DockHub.View.Theme.Types,
  DockHub.View.Theme.Contracts;


type
  TPageMain = class(TForm)
  private
    FLanguage: IDockHubLanguage;
    FTheme: IDockHubTheme;

    procedure ConfigureForm;
    procedure ApplyLanguage;
    procedure ApplyTheme;

    procedure ChangeLanguage(const AValue: TDockHubLanguageType);
    procedure ChangeTheme(const AValue: TDockHubThemeType);
  public


    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  PageMain: TPageMain;

implementation

{$R *.fmx}

uses
  DockHub.View.Constants,

  DockHub.Core.Language.Impl,
  DockHub.Core.Language.Keys.View.Main,

  DockHub.View.Theme.Impl;

procedure TPageMain.ApplyLanguage;
begin
  Caption := FLanguage.Translate(_VIEW_MAIN_CAPTION);
end;

procedure TPageMain.ApplyTheme;
begin
  FTheme.BackgroundGradient(Fill);
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

procedure TPageMain.ConfigureForm;
begin
  Width := _FORM_WIDTH;
  Height := _FORM_HEIGHT;
  BorderStyle := TFmxFormBorderStyle.None;
  Position := TFormPosition.ScreenCenter;
end;

constructor TPageMain.Create(AOwner: TComponent);
begin
  inherited;
  FLanguage := TDockHubLanguage.New;
  FTheme    := TDockHubTheme.New;

  ConfigureForm;
  ApplyLanguage;
  ApplyTheme;
end;

destructor TPageMain.Destroy;
begin
  FTheme := nil;
  FLanguage := nil;

  inherited;
end;

end.

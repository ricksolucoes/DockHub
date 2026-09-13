unit DockHub.View.Page.Main;

interface

uses
  FMX.Forms,

  System.Classes,

  DockHub.Core.Language.Types,
  DockHub.Core.Language.Contracts;


type
  TPageMain = class(TForm)
  private
    FLanguage: IDockHubLanguage;

    procedure ConfigureForm;
    procedure ApplyLanguage;

    procedure ChangeLanguage(const AValue: TDockHubLanguageType);
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
  DockHub.Core.Language.Keys.View.Main;

procedure TPageMain.ApplyLanguage;
begin
  Caption := FLanguage.Translate(_VIEW_MAIN_CAPTION);
end;

procedure TPageMain.ChangeLanguage(const AValue: TDockHubLanguageType);
begin
  if FLanguage.Language = AValue then
    Exit;

  FLanguage.Language(AValue);

  ApplyLanguage;
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

  ConfigureForm;
  ApplyLanguage;
end;

destructor TPageMain.Destroy;
begin

  FLanguage := nil;

  inherited;
end;

end.

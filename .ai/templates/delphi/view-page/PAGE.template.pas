unit {{PAGE_UNIT}};

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
  {{PAGE_CLASS}} = class(TForm)
  private
    FLanguage: IDockHubLanguage;
    FTheme: IDockHubTheme;
    FComposition: {{COMPOSITION_REFERENCE_TYPE}};

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
  {{PAGE_VARIABLE}}: {{PAGE_CLASS}};

implementation

{$R *.fmx}

uses
  {{PAGE_IMPLEMENTATION_USES}};

procedure {{PAGE_CLASS}}.ApplyLanguage;
begin
  FComposition.ApplyLanguage(FLanguage);
end;

procedure {{PAGE_CLASS}}.ApplyTheme;
begin
  FComposition.ApplyTheme(FTheme);
end;

procedure {{PAGE_CLASS}}.ChangeLanguage(const AValue: TDockHubLanguageType);
begin
  if FLanguage.Language = AValue then
    Exit;

  FLanguage.Language(AValue);
  ApplyLanguage;
end;

procedure {{PAGE_CLASS}}.ChangeTheme(const AValue: TDockHubThemeType);
begin
  if FTheme.Theme = AValue then
    Exit;

  FTheme.Theme(AValue);
  ApplyTheme;
end;

procedure {{PAGE_CLASS}}.CloseClick(Sender: TObject);
begin
  {{CLOSE_ACTION}}
end;

procedure {{PAGE_CLASS}}.ConfigureComposition;
begin
  FComposition := {{COMPOSITION_CLASS}}.New;

  FComposition
    .Form(Self)
    .OnMinimize(MinimizeClick)
    .OnClose(CloseClick)
    .Build;
end;

procedure {{PAGE_CLASS}}.ConfigureForm;
begin
  {{CONFIGURE_FORM_BODY}}
end;

constructor {{PAGE_CLASS}}.Create(AOwner: TComponent);
begin
  inherited;

  {{CREATE_LANGUAGE_BODY}}
  {{CREATE_THEME_BODY}}

  ConfigureForm;
  ConfigureComposition;

  ApplyLanguage;
  ApplyTheme;
end;

procedure {{PAGE_CLASS}}.MinimizeClick(Sender: TObject);
begin
  WindowState := TWindowState.wsMinimized;
end;

end.

unit DockHub.Core.Language.Translations.EnUS;

interface

uses
  DockHub.Core.Language.Types;

procedure LoadEnUSTranslations(const AAddTranslation: TAddTranslationProc);

implementation

uses
  DockHub.Core.Language.Keys.View.Main;

procedure LoadEnUSTranslations(const AAddTranslation: TAddTranslationProc);
begin
  if not Assigned(AAddTranslation) then
    raise EDockHubTranslationInvalid.Create(
      'Translation callback not assigned. Language: EnUS.'
    );

  AAddTranslation(_VIEW_MAIN_CAPTION, 'DockHub - Integration Hub');
  AAddTranslation(_VIEW_MAIN_SUBTITLE, 'API Service');
  AAddTranslation(_VIEW_MAIN_SERVICE, 'Windows Service');
  AAddTranslation(_VIEW_MAIN_API, 'API');
  AAddTranslation(_VIEW_MAIN_PORT, 'Port');
  AAddTranslation(_VIEW_MAIN_ENVIRONMENT, 'Environment');
  AAddTranslation(_VIEW_MAIN_INSTALL, 'Install');
  AAddTranslation(_VIEW_MAIN_UNINSTALL, 'Uninstall');
  AAddTranslation(_VIEW_MAIN_START, 'Start');
  AAddTranslation(_VIEW_MAIN_STOP, 'Stop');
  AAddTranslation(_VIEW_MAIN_OPEN_CONFIGURATION, 'Open configuration');
  AAddTranslation(_VIEW_MAIN_OPEN_LOGS, 'Open logs');
  AAddTranslation(_VIEW_MAIN_STATUS_UNVERIFIED, 'Not verified');
end;

end.

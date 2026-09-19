unit DockHub.Core.Language.Translations.PtBR;

interface

uses
  DockHub.Core.Language.Types;

procedure LoadPtBRTranslations(
  const AAddTranslation: TAddTranslationProc
);

implementation

uses
  DockHub.Core.Language.Keys.View.Main;

procedure LoadPtBRTranslations(
  const AAddTranslation: TAddTranslationProc
);
begin
  if not Assigned(AAddTranslation) then
    raise EDockHubTranslationInvalid.Create(
      'Translation callback not assigned. Language: PtBR.'
    );

  AAddTranslation(_VIEW_MAIN_CAPTION, 'DockHub - Hub de Integração');
  AAddTranslation(_VIEW_MAIN_SUBTITLE, 'Serviço da API');
  AAddTranslation(_VIEW_MAIN_SERVICE, 'Serviço Windows');
  AAddTranslation(_VIEW_MAIN_API, 'API');
  AAddTranslation(_VIEW_MAIN_PORT, 'Porta');
  AAddTranslation(_VIEW_MAIN_ENVIRONMENT, 'Ambiente');
  AAddTranslation(_VIEW_MAIN_INSTALL, 'Instalar');
  AAddTranslation(_VIEW_MAIN_UNINSTALL, 'Desinstalar');
  AAddTranslation(_VIEW_MAIN_START, 'Iniciar');
  AAddTranslation(_VIEW_MAIN_STOP, 'Parar');
  AAddTranslation(_VIEW_MAIN_OPEN_CONFIGURATION, 'Abrir configuração');
  AAddTranslation(_VIEW_MAIN_OPEN_LOGS, 'Abrir logs');
  AAddTranslation(_VIEW_MAIN_STATUS_UNVERIFIED, 'Não verificado');
end;

end.

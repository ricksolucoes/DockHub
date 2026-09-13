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

  AAddTranslation(
    _VIEW_MAIN_CAPTION,
    'DockHub - Hub de Integração'
  );
end;

end.

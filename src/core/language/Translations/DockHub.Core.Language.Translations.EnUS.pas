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

  AAddTranslation(
    _VIEW_MAIN_CAPTION,
    'DockHub - Integration Hub'
  );
end;

end.

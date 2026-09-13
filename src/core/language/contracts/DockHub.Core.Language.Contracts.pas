unit DockHub.Core.Language.Contracts;

interface

uses
  DockHub.Core.Language.Types;

type
  IDockHubLanguage = interface(IInterface)
    ['{7B6C1A0B-E84C-4EC0-93E1-F3C3C61873CD}']

    function Language: TDockHubLanguageType; overload;
    function Language(
      const AValue: TDockHubLanguageType): IDockHubLanguage; overload;

    function Translate(const AKey: TDockHubTranslationKey): string;
  end;

implementation

end.

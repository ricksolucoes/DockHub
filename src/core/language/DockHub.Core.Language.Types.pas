unit DockHub.Core.Language.Types;

interface

uses
  System.SysUtils,
  System.Generics.Collections;

{$SCOPEDENUMS ON}

type
  TDockHubLanguageType = (PtBR, EnUS);

  TDockHubLanguageHelper = record helper for TDockHubLanguageType
  public
    function ToString: string;
    function ToCultureCode: string;

    class function FromString(const AValue: string): TDockHubLanguageType; static;
  end;

  TDockHubTranslationKey = type string;

  TTranslationDictionary = TDictionary<TDockHubTranslationKey, string>;

  TAddTranslationProc = reference to
    procedure(const AKey: TDockHubTranslationKey; const AValue: string);

  EDockHubTranslationNotFound = class(Exception);
  EDockHubTranslationDuplicate = class(Exception);
  EDockHubTranslationInvalid = class(Exception);
  EDockHubLanguageNotSupported = class(Exception);

implementation

{ TDockHubLanguageHelper }

class function TDockHubLanguageHelper.FromString(const AValue: string)
: TDockHubLanguageType;
begin
  if SameText(AValue, 'pt-BR') or SameText(AValue, 'PtBR') then
    Exit(TDockHubLanguageType.PtBR);

  if SameText(AValue, 'en-US') or SameText(AValue, 'EnUS') then
    Exit(TDockHubLanguageType.EnUS);

  raise EArgumentException.CreateFmt('Unsupported language: %s', [AValue]);
end;

function TDockHubLanguageHelper.ToCultureCode: string;
begin
  case Self of
    TDockHubLanguageType.PtBR:
      Result := 'pt-BR';

    TDockHubLanguageType.EnUS:
      Result := 'en-US';
    else
      raise EArgumentOutOfRangeException.Create
      ('Invalid TDockHubLanguageType value');
  end;
end;

function TDockHubLanguageHelper.ToString: string;
begin
  case Self of
    TDockHubLanguageType.PtBR:
      Result := 'PtBR';

    TDockHubLanguageType.EnUS:
      Result := 'EnUS';
    else
      raise EArgumentOutOfRangeException.Create
      ('Invalid TDockHubLanguageType value');
  end;
end;

end.

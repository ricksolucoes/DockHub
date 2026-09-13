unit DockHub.Core.Language.Impl;

interface

uses
  DockHub.Core.Language.Types,
  DockHub.Core.Language.Contracts;

type
  TDockHubLanguage = class sealed(TInterfacedObject, IDockHubLanguage)
  private
    FCurrentLanguage: TDockHubLanguageType;
    FDefaultTranslations: TTranslationDictionary;
    FCurrentTranslations: TTranslationDictionary;

    procedure AddTranslation(const ALanguage: TDockHubLanguageType;
      ATranslations: TTranslationDictionary;
      const AKey: TDockHubTranslationKey; const AValue: string);

    function BuildTranslations(
      const ALanguage: TDockHubLanguageType): TTranslationDictionary;

    function TryTranslateDefault(const AKey: TDockHubTranslationKey;
      out AValue: string): Boolean;

    function TryTranslateCurrent(const AKey: TDockHubTranslationKey;
      out AValue: string): Boolean;

  protected
    function Language: TDockHubLanguageType; overload;
    function Language(
      const AValue: TDockHubLanguageType): IDockHubLanguage; overload;

    function Translate(const AKey: TDockHubTranslationKey): string;

    constructor Create;

  public
    destructor Destroy; override;

    class function New: IDockHubLanguage; static;
  end;

implementation

uses
  System.SysUtils,
  DockHub.Core.Language.Translations.PtBR,
  DockHub.Core.Language.Translations.EnUS;

constructor TDockHubLanguage.Create;
begin
  inherited;

  FCurrentLanguage := TDockHubLanguageType.PtBR;
  FDefaultTranslations := BuildTranslations(TDockHubLanguageType.PtBR);
  FCurrentTranslations := nil;
end;

destructor TDockHubLanguage.Destroy;
begin
  FCurrentTranslations.Free;
  FDefaultTranslations.Free;

  inherited;
end;

class function TDockHubLanguage.New: IDockHubLanguage;
begin
  Result := TDockHubLanguage.Create;
end;

procedure TDockHubLanguage.AddTranslation(const ALanguage: TDockHubLanguageType;
  ATranslations: TTranslationDictionary; const AKey: TDockHubTranslationKey;
  const AValue: string);
begin
  if not Assigned(ATranslations) then
    raise EDockHubTranslationInvalid.CreateFmt
    ('Invalid translation dictionary. Language: %s.', [ALanguage.ToString]);

  if string(AKey).Trim.IsEmpty then
    raise EDockHubTranslationInvalid.CreateFmt
    ('Invalid translation key. Language: %s.', [ALanguage.ToString]);

  if AValue.Trim.IsEmpty then
    raise EDockHubTranslationInvalid.CreateFmt
    ('Invalid translation value. Language: %s. Key: %s.',
      [ALanguage.ToString, string(AKey)]);

  if not ATranslations.TryAdd(AKey, AValue) then
    raise EDockHubTranslationDuplicate.CreateFmt
    ('Duplicate translation key. Language: %s. Key: %s.',
      [ALanguage.ToString, string(AKey)]);

  ATranslations.TrimExcess;
end;

function TDockHubLanguage.BuildTranslations(
  const ALanguage: TDockHubLanguageType): TTranslationDictionary;
var
  LTranslations: TTranslationDictionary;
  LAddTranslation: TAddTranslationProc;
begin
  LTranslations := TTranslationDictionary.Create;

  try
    LAddTranslation :=
      procedure(const AKey: TDockHubTranslationKey; const AValue: string)
      begin
        AddTranslation(ALanguage, LTranslations, AKey, AValue);
      end;

    case ALanguage of
      TDockHubLanguageType.PtBR:
        LoadPtBRTranslations(LAddTranslation);

      TDockHubLanguageType.EnUS:
        LoadEnUSTranslations(LAddTranslation);

      else
        raise EDockHubLanguageNotSupported.CreateFmt
        ('Language not supported: %s', [ALanguage.ToString]);
    end;

    LTranslations.TrimExcess;
    Result := LTranslations;
  except
    LTranslations.Free;
    raise;
  end;
end;

function TDockHubLanguage.TryTranslateDefault(
  const AKey: TDockHubTranslationKey; out AValue: string): Boolean;
begin
  Result := Assigned(FDefaultTranslations) and
            FDefaultTranslations.TryGetValue(AKey, AValue);
end;

function TDockHubLanguage.TryTranslateCurrent(
  const AKey: TDockHubTranslationKey; out AValue: string): Boolean;
begin
  Result := Assigned(FCurrentTranslations) and
            FCurrentTranslations.TryGetValue(AKey, AValue);
end;

function TDockHubLanguage.Language: TDockHubLanguageType;
begin
  Result := FCurrentLanguage;
end;

function TDockHubLanguage.Language(
  const AValue: TDockHubLanguageType): IDockHubLanguage;
var
  LTranslations: TTranslationDictionary;
begin
  Result := Self;

  if FCurrentLanguage = AValue then
    Exit;

  if AValue = TDockHubLanguageType.PtBR then
  begin
    FreeAndNil(FCurrentTranslations);
    FCurrentLanguage := TDockHubLanguageType.PtBR;
    Exit;
  end;

  //
  // O novo catálogo é construído antes de alterar
  // o estado atual do Language.
  //
  // Se ocorrer qualquer exceção, o idioma anterior
  // continua funcionando normalmente.
  //
  LTranslations := BuildTranslations(AValue);

  FreeAndNil(FCurrentTranslations);

  FCurrentTranslations := LTranslations;
  FCurrentLanguage := AValue;
end;

function TDockHubLanguage.Translate(const AKey: TDockHubTranslationKey): string;
begin
  //
  // PtBR é o idioma oficial.
  //
  if FCurrentLanguage = TDockHubLanguageType.PtBR then
  begin
    if TryTranslateDefault(AKey, Result) then
      Exit;

    raise EDockHubTranslationNotFound.CreateFmt
    ('Translation not found. Language: %s. Key: %s.',
      [FCurrentLanguage.ToString, string(AKey)]);
  end;

  //
  // Primeiro procura no idioma selecionado.
  //
  if TryTranslateCurrent(AKey, Result) then
    Exit;

  //
  // Se não existir, procura no catálogo oficial PtBR.
  //
  if TryTranslateDefault(AKey, Result) then
  begin
    //
    // Cacheia o fallback no idioma corrente.
    //
    // Na próxima chamada desta chave não será
    // necessário consultar novamente o PtBR.
    //
    FCurrentTranslations.TryAdd(AKey, Result);

    Exit;
  end;

  //
  // A chave não existe nem no idioma corrente
  // nem no catálogo oficial.
  //
  raise EDockHubTranslationNotFound.CreateFmt
  ('Translation not found. Language: %s. Key: %s.', [FCurrentLanguage.ToString,
      string(AKey)]);
end;

end.

unit DockHub.Tests.Core.Language;

interface

uses
  DUnitX.TestFramework,
  DockHub.Core.Language.Types,
  DockHub.Core.Language.Contracts;

type
  [TestFixture]
  TDockHubLanguageTests = class
  private
    FLanguage: IDockHubLanguage;

  public
    [Setup]
    procedure Setup;

    [TearDown]
    procedure TearDown;

    [Test]
    procedure New_DefaultLanguage_IsPtBR;

    [Test]
    procedure Language_ChangesTo_EnUS;

    [Test]
    procedure Language_ReturnsTo_PtBR;

    [Test]
    procedure Translate_PtBR_ReturnsMainViewTexts;

    [Test]
    procedure Translate_EnUS_ReturnsMainViewTexts;

    [Test]
    procedure Translate_PtBR_UnknownKey_RaisesNotFound;

    [Test]
    procedure Translate_EnUS_UnknownKey_RaisesNotFound;
  end;

implementation

uses
  DockHub.Core.Language.Impl,
  DockHub.Core.Language.Keys.View.Main;

const
  _UNKNOWN_TRANSLATION_KEY:
    TDockHubTranslationKey = 'Tests.Unknown.Translation';

{ TDockHubLanguageTests }

procedure TDockHubLanguageTests.Setup;
begin
  FLanguage := TDockHubLanguage.New;
end;

procedure TDockHubLanguageTests.TearDown;
begin
  FLanguage := nil;
end;

procedure TDockHubLanguageTests.New_DefaultLanguage_IsPtBR;
begin
  Assert.AreEqual<TDockHubLanguageType>(
    TDockHubLanguageType.PtBR,
    FLanguage.Language
  );
end;

procedure TDockHubLanguageTests.Language_ChangesTo_EnUS;
begin
  FLanguage.Language(
    TDockHubLanguageType.EnUS
  );

  Assert.AreEqual<TDockHubLanguageType>(
    TDockHubLanguageType.EnUS,
    FLanguage.Language
  );
end;

procedure TDockHubLanguageTests.Language_ReturnsTo_PtBR;
begin
  FLanguage.Language(
    TDockHubLanguageType.EnUS
  );

  FLanguage.Language(
    TDockHubLanguageType.PtBR
  );

  Assert.AreEqual<TDockHubLanguageType>(
    TDockHubLanguageType.PtBR,
    FLanguage.Language
  );
end;

procedure TDockHubLanguageTests.Translate_PtBR_ReturnsMainViewTexts;
begin
  Assert.AreEqual('DockHub - Hub de Integração',
    FLanguage.Translate(_VIEW_MAIN_CAPTION));
  Assert.AreEqual('Serviço da API',
    FLanguage.Translate(_VIEW_MAIN_SUBTITLE));
  Assert.AreEqual('Serviço Windows',
    FLanguage.Translate(_VIEW_MAIN_SERVICE));
  Assert.AreEqual('API', FLanguage.Translate(_VIEW_MAIN_API));
  Assert.AreEqual('Porta', FLanguage.Translate(_VIEW_MAIN_PORT));
  Assert.AreEqual('Ambiente', FLanguage.Translate(_VIEW_MAIN_ENVIRONMENT));
  Assert.AreEqual('Instalar', FLanguage.Translate(_VIEW_MAIN_INSTALL));
  Assert.AreEqual('Desinstalar', FLanguage.Translate(_VIEW_MAIN_UNINSTALL));
  Assert.AreEqual('Iniciar', FLanguage.Translate(_VIEW_MAIN_START));
  Assert.AreEqual('Parar', FLanguage.Translate(_VIEW_MAIN_STOP));
  Assert.AreEqual('Abrir configuração',
    FLanguage.Translate(_VIEW_MAIN_OPEN_CONFIGURATION));
  Assert.AreEqual('Abrir logs', FLanguage.Translate(_VIEW_MAIN_OPEN_LOGS));
  Assert.AreEqual('Não verificado',
    FLanguage.Translate(_VIEW_MAIN_STATUS_UNVERIFIED));
end;

procedure TDockHubLanguageTests.Translate_EnUS_ReturnsMainViewTexts;
begin
  FLanguage.Language(TDockHubLanguageType.EnUS);

  Assert.AreEqual('DockHub - Integration Hub',
    FLanguage.Translate(_VIEW_MAIN_CAPTION));
  Assert.AreEqual('API Service', FLanguage.Translate(_VIEW_MAIN_SUBTITLE));
  Assert.AreEqual('Windows Service', FLanguage.Translate(_VIEW_MAIN_SERVICE));
  Assert.AreEqual('API', FLanguage.Translate(_VIEW_MAIN_API));
  Assert.AreEqual('Port', FLanguage.Translate(_VIEW_MAIN_PORT));
  Assert.AreEqual('Environment', FLanguage.Translate(_VIEW_MAIN_ENVIRONMENT));
  Assert.AreEqual('Install', FLanguage.Translate(_VIEW_MAIN_INSTALL));
  Assert.AreEqual('Uninstall', FLanguage.Translate(_VIEW_MAIN_UNINSTALL));
  Assert.AreEqual('Start', FLanguage.Translate(_VIEW_MAIN_START));
  Assert.AreEqual('Stop', FLanguage.Translate(_VIEW_MAIN_STOP));
  Assert.AreEqual('Open configuration',
    FLanguage.Translate(_VIEW_MAIN_OPEN_CONFIGURATION));
  Assert.AreEqual('Open logs', FLanguage.Translate(_VIEW_MAIN_OPEN_LOGS));
  Assert.AreEqual('Not verified',
    FLanguage.Translate(_VIEW_MAIN_STATUS_UNVERIFIED));
end;

procedure TDockHubLanguageTests.Translate_PtBR_UnknownKey_RaisesNotFound;
begin
  Assert.WillRaise(
    procedure
    begin
      FLanguage.Translate(
        _UNKNOWN_TRANSLATION_KEY
      );
    end,
    EDockHubTranslationNotFound
  );
end;

procedure TDockHubLanguageTests.Translate_EnUS_UnknownKey_RaisesNotFound;
begin
  FLanguage.Language(
    TDockHubLanguageType.EnUS
  );

  Assert.WillRaise(
    procedure
    begin
      FLanguage.Translate(
        _UNKNOWN_TRANSLATION_KEY
      );
    end,
    EDockHubTranslationNotFound
  );
end;

initialization
  TDUnitX.RegisterTestFixture(
    TDockHubLanguageTests
  );

end.

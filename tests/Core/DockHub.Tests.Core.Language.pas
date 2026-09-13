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
    procedure Translate_PtBR_ReturnsPortugueseCaption;

    [Test]
    procedure Translate_EnUS_ReturnsEnglishCaption;

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

procedure TDockHubLanguageTests.Translate_PtBR_ReturnsPortugueseCaption;
begin
  Assert.AreEqual(
    'DockHub - Hub de Integração',
    FLanguage.Translate(
      _VIEW_MAIN_CAPTION
    )
  );
end;

procedure TDockHubLanguageTests.Translate_EnUS_ReturnsEnglishCaption;
begin
  FLanguage.Language(
    TDockHubLanguageType.EnUS
  );

  Assert.AreEqual(
    'DockHub - Integration Hub',
    FLanguage.Translate(
      _VIEW_MAIN_CAPTION
    )
  );
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

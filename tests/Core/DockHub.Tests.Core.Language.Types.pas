unit DockHub.Tests.Core.Language.Types;

interface

uses
  DUnitX.TestFramework,
  DockHub.Core.Language.Types;

type
  [TestFixture]
  TDockHubLanguageTypeTests = class
  public
    [Test]
    procedure PtBR_ToString;

    [Test]
    procedure EnUS_ToString;

    [Test]
    procedure PtBR_ToCultureCode;

    [Test]
    procedure EnUS_ToCultureCode;

    [Test]
    procedure FromString_PtBR_CultureCode;

    [Test]
    procedure FromString_PtBR_EnumName;

    [Test]
    procedure FromString_EnUS_CultureCode;

    [Test]
    procedure FromString_EnUS_EnumName;

    [Test]
    procedure FromString_IsCaseInsensitive;

    [Test]
    procedure FromString_Invalid_RaisesException;
  end;

implementation

uses
  System.SysUtils;

procedure TDockHubLanguageTypeTests.PtBR_ToString;
begin
  Assert.AreEqual(
    'PtBR',
    TDockHubLanguageType.PtBR.ToString
  );
end;

procedure TDockHubLanguageTypeTests.EnUS_ToString;
begin
  Assert.AreEqual(
    'EnUS',
    TDockHubLanguageType.EnUS.ToString
  );
end;

procedure TDockHubLanguageTypeTests.PtBR_ToCultureCode;
begin
  Assert.AreEqual(
    'pt-BR',
    TDockHubLanguageType.PtBR.ToCultureCode
  );
end;

procedure TDockHubLanguageTypeTests.EnUS_ToCultureCode;
begin
  Assert.AreEqual(
    'en-US',
    TDockHubLanguageType.EnUS.ToCultureCode
  );
end;

procedure TDockHubLanguageTypeTests.FromString_PtBR_CultureCode;
begin
  Assert.AreEqual<TDockHubLanguageType>(
    TDockHubLanguageType.PtBR,
    TDockHubLanguageType.FromString('pt-BR')
  );
end;

procedure TDockHubLanguageTypeTests.FromString_PtBR_EnumName;
begin
  Assert.AreEqual<TDockHubLanguageType>(
    TDockHubLanguageType.PtBR,
    TDockHubLanguageType.FromString('PtBR')
  );
end;

procedure TDockHubLanguageTypeTests.FromString_EnUS_CultureCode;
begin
  Assert.AreEqual<TDockHubLanguageType>(
    TDockHubLanguageType.EnUS,
    TDockHubLanguageType.FromString('en-US')
  );
end;

procedure TDockHubLanguageTypeTests.FromString_EnUS_EnumName;
begin
  Assert.AreEqual<TDockHubLanguageType>(
    TDockHubLanguageType.EnUS,
    TDockHubLanguageType.FromString('EnUS')
  );
end;

procedure TDockHubLanguageTypeTests.FromString_IsCaseInsensitive;
begin
  Assert.AreEqual<TDockHubLanguageType>(
    TDockHubLanguageType.PtBR,
    TDockHubLanguageType.FromString('PT-br')
  );

  Assert.AreEqual<TDockHubLanguageType>(
    TDockHubLanguageType.EnUS,
    TDockHubLanguageType.FromString('EN-us')
  );
end;

procedure TDockHubLanguageTypeTests.FromString_Invalid_RaisesException;
begin
  Assert.WillRaise(
    procedure
    begin
      TDockHubLanguageType.FromString('es-ES');
    end,
    EArgumentException
  );
end;

initialization
  TDUnitX.RegisterTestFixture(
    TDockHubLanguageTypeTests
  );

end.

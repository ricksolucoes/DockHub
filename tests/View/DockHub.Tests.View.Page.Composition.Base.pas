unit DockHub.Tests.View.Page.Composition.Base;

interface

uses
  DUnitX.TestFramework,

  System.Classes,
  System.SysUtils,
  System.UITypes,

  FMX.Forms,
  FMX.Types,
  FMX.Objects,
  FMX.StdCtrls,

  DockHub.Core.Language.Contracts,
  DockHub.View.Theme.Contracts,
  DockHub.View.Page.Contracts,
  DockHub.View.Page.Composition.Impl.Base;

type
  ETestPageCompositionBuild = class(Exception);

  TTestPageComposition = class(TPageCompositionBase)
  private
    FBuildCount: Integer;
    FThemeCount: Integer;
    FLanguageCount: Integer;
    FFailBuild: Boolean;
  protected
    procedure DoBuild; override;
    procedure DoApplyTheme; override;
    procedure DoApplyLanguage(const ALanguage: IDockHubLanguage); override;
  public
    property BuildCount: Integer read FBuildCount;
    property ThemeCount: Integer read FThemeCount;
    property LanguageCount: Integer read FLanguageCount;
    property FailBuild: Boolean read FFailBuild write FFailBuild;
  end;

  [TestFixture]
  [Category('Contract')]
  TDockHubPageCompositionBaseTests = class
  private
    FHostForm: TForm;
    FImplementation: TTestPageComposition;
    FComposition: IPageComposition;
    FLanguage: IDockHubLanguage;
    FTheme: IDockHubTheme;
    FMinimizeCount: Integer;
    FCloseCount: Integer;

    procedure HandleMinimize(Sender: TObject);
    procedure HandleClose(Sender: TObject);
    procedure ConfigureValidComposition;
    procedure BuildValidComposition;
    procedure ConfigureHostWithDistinctClientArea;
    procedure AssertButtonInsideClientBounds(const AButton: TRectangle);

    function FindLabelByText(AParent: TFmxObject;
      const AText: string): TLabel;
    function FindButtonByCaption(const ACaption: string): TRectangle;
  public
    [Setup]
    procedure Setup;

    [TearDown]
    procedure TearDown;

    [Test]
    procedure Form_Nil_Raises;

    [Test]
    procedure OnMinimize_Nil_Raises;

    [Test]
    procedure OnClose_Nil_Raises;

    [Test]
    procedure Build_WithoutForm_Raises;

    [Test]
    procedure Build_WithoutMinimize_Raises;

    [Test]
    procedure Build_WithoutClose_Raises;

    [Test]
    procedure ApplyTheme_BeforeBuild_Raises;

    [Test]
    procedure ApplyLanguage_BeforeBuild_Raises;

    [Test]
    procedure ApplyTheme_NilAfterBuild_Raises;

    [Test]
    procedure ApplyLanguage_NilAfterBuild_Raises;

    [Test]
    procedure Configuration_AfterBuild_Raises;

    [Test]
    procedure Build_SecondCall_DoesNotRebuild;

    [Test]
    procedure Build_Failure_BlocksRetry;

    [Test]
    procedure WindowButtons_InvokeConfiguredCallbacks;

    [Test]
    procedure WindowButtons_AreVisibleAndInsideClientBounds;

    [Test]
    procedure WindowHover_UsesCurrentThemeAfterRuntimeChange;
  end;

implementation

uses
  DockHub.Core.Language.Impl,
  DockHub.View.Theme.Impl,
  DockHub.View.Theme.Types;

{ TTestPageComposition }

procedure TTestPageComposition.DoBuild;
begin
  Inc(FBuildCount);

  if FFailBuild then
    raise ETestPageCompositionBuild.Create('Expected test build failure.');
end;

procedure TTestPageComposition.DoApplyTheme;
begin
  Inc(FThemeCount);
end;

procedure TTestPageComposition.DoApplyLanguage(
  const ALanguage: IDockHubLanguage);
begin
  Inc(FLanguageCount);
end;

{ TDockHubPageCompositionBaseTests }

procedure TDockHubPageCompositionBaseTests.Setup;
begin
  FHostForm := TForm.CreateNew(nil);
  FHostForm.Width := 750;
  FHostForm.Height := 550;

  FImplementation := TTestPageComposition.Create;
  FComposition := FImplementation;
  FLanguage := TDockHubLanguage.New;
  FTheme := TDockHubTheme.New;

  FMinimizeCount := 0;
  FCloseCount := 0;
end;

procedure TDockHubPageCompositionBaseTests.TearDown;
begin
  FTheme := nil;
  FLanguage := nil;

  FHostForm.Free;
  FHostForm := nil;

  FComposition := nil;
  FImplementation := nil;
end;

procedure TDockHubPageCompositionBaseTests.HandleMinimize(Sender: TObject);
begin
  Inc(FMinimizeCount);
end;

procedure TDockHubPageCompositionBaseTests.HandleClose(Sender: TObject);
begin
  Inc(FCloseCount);
end;

procedure TDockHubPageCompositionBaseTests.ConfigureValidComposition;
begin
  FComposition
    .Form(FHostForm)
    .OnMinimize(HandleMinimize)
    .OnClose(HandleClose);
end;

procedure TDockHubPageCompositionBaseTests.BuildValidComposition;
begin
  ConfigureValidComposition;
  FComposition.Build;
end;

procedure TDockHubPageCompositionBaseTests.ConfigureHostWithDistinctClientArea;
const
  _TEST_CLIENT_WIDTH = 700;
  _TEST_CLIENT_HEIGHT = 500;
begin
  FHostForm.BorderStyle := TFmxFormBorderStyle.Sizeable;
  FHostForm.ClientWidth := _TEST_CLIENT_WIDTH;
  FHostForm.ClientHeight := _TEST_CLIENT_HEIGHT;

  if FHostForm.Width = FHostForm.ClientWidth then
  begin
    FHostForm.BorderStyle := TFmxFormBorderStyle.Single;
    FHostForm.ClientWidth := _TEST_CLIENT_WIDTH;
    FHostForm.ClientHeight := _TEST_CLIENT_HEIGHT;
  end;

  Assert.IsTrue(
    FHostForm.Width > FHostForm.ClientWidth,
    'Test scenario must make Width greater than ClientWidth.'
  );
end;

procedure TDockHubPageCompositionBaseTests.AssertButtonInsideClientBounds(
  const AButton: TRectangle);
begin
  Assert.IsTrue(AButton.Position.X >= 0);
  Assert.IsTrue(AButton.Position.Y >= 0);
  Assert.IsTrue(
    AButton.Position.X + AButton.Width <= FHostForm.ClientWidth
  );
  Assert.IsTrue(
    AButton.Position.Y + AButton.Height <= FHostForm.ClientHeight
  );
end;

function TDockHubPageCompositionBaseTests.FindLabelByText(
  AParent: TFmxObject; const AText: string): TLabel;
var
  I: Integer;
  LFound: TLabel;
begin
  Result := nil;

  for I := 0 to AParent.ChildrenCount - 1 do
  begin
    if (AParent.Children[I] is TLabel) and
       (TLabel(AParent.Children[I]).Text = AText) then
      Exit(TLabel(AParent.Children[I]));

    LFound := FindLabelByText(AParent.Children[I], AText);

    if Assigned(LFound) then
      Exit(LFound);
  end;
end;

function TDockHubPageCompositionBaseTests.FindButtonByCaption(
  const ACaption: string): TRectangle;
var
  LCaption: TLabel;
begin
  LCaption := FindLabelByText(FHostForm, ACaption);

  if Assigned(LCaption) and (LCaption.Parent is TRectangle) then
    Exit(TRectangle(LCaption.Parent));

  Result := nil;
end;

procedure TDockHubPageCompositionBaseTests.Form_Nil_Raises;
begin
  Assert.WillRaise(
    procedure
    begin
      FComposition.Form(nil);
    end,
    EComponentError
  );
end;

procedure TDockHubPageCompositionBaseTests.OnMinimize_Nil_Raises;
begin
  Assert.WillRaise(
    procedure
    begin
      FComposition.OnMinimize(nil);
    end,
    EComponentError
  );
end;

procedure TDockHubPageCompositionBaseTests.OnClose_Nil_Raises;
begin
  Assert.WillRaise(
    procedure
    begin
      FComposition.OnClose(nil);
    end,
    EComponentError
  );
end;

procedure TDockHubPageCompositionBaseTests.Build_WithoutForm_Raises;
begin
  FComposition
    .OnMinimize(HandleMinimize)
    .OnClose(HandleClose);

  Assert.WillRaise(
    procedure
    begin
      FComposition.Build;
    end,
    EComponentError
  );
end;

procedure TDockHubPageCompositionBaseTests.Build_WithoutMinimize_Raises;
begin
  FComposition
    .Form(FHostForm)
    .OnClose(HandleClose);

  Assert.WillRaise(
    procedure
    begin
      FComposition.Build;
    end,
    EComponentError
  );
end;

procedure TDockHubPageCompositionBaseTests.Build_WithoutClose_Raises;
begin
  FComposition
    .Form(FHostForm)
    .OnMinimize(HandleMinimize);

  Assert.WillRaise(
    procedure
    begin
      FComposition.Build;
    end,
    EComponentError
  );
end;

procedure TDockHubPageCompositionBaseTests.ApplyTheme_BeforeBuild_Raises;
begin
  Assert.WillRaise(
    procedure
    begin
      FComposition.ApplyTheme(FTheme);
    end,
    EComponentError
  );
end;

procedure TDockHubPageCompositionBaseTests.ApplyLanguage_BeforeBuild_Raises;
begin
  Assert.WillRaise(
    procedure
    begin
      FComposition.ApplyLanguage(FLanguage);
    end,
    EComponentError
  );
end;

procedure TDockHubPageCompositionBaseTests.ApplyTheme_NilAfterBuild_Raises;
begin
  BuildValidComposition;

  Assert.WillRaise(
    procedure
    begin
      FComposition.ApplyTheme(nil);
    end,
    EComponentError
  );
end;

procedure TDockHubPageCompositionBaseTests.ApplyLanguage_NilAfterBuild_Raises;
begin
  BuildValidComposition;

  Assert.WillRaise(
    procedure
    begin
      FComposition.ApplyLanguage(nil);
    end,
    EComponentError
  );
end;

procedure TDockHubPageCompositionBaseTests.Configuration_AfterBuild_Raises;
begin
  BuildValidComposition;

  Assert.WillRaise(
    procedure
    begin
      FComposition.Form(FHostForm);
    end,
    EComponentError
  );

  Assert.WillRaise(
    procedure
    begin
      FComposition.OnMinimize(HandleMinimize);
    end,
    EComponentError
  );

  Assert.WillRaise(
    procedure
    begin
      FComposition.OnClose(HandleClose);
    end,
    EComponentError
  );
end;

procedure TDockHubPageCompositionBaseTests.Build_SecondCall_DoesNotRebuild;
var
  LChildrenBefore: Integer;
begin
  BuildValidComposition;
  LChildrenBefore := FHostForm.ChildrenCount;

  FComposition.Build;

  Assert.AreEqual(1, FImplementation.BuildCount);
  Assert.AreEqual(LChildrenBefore, FHostForm.ChildrenCount);
end;

procedure TDockHubPageCompositionBaseTests.Build_Failure_BlocksRetry;
begin
  ConfigureValidComposition;
  FImplementation.FailBuild := True;

  Assert.WillRaise(
    procedure
    begin
      FComposition.Build;
    end,
    ETestPageCompositionBuild
  );

  FImplementation.FailBuild := False;

  Assert.WillRaise(
    procedure
    begin
      FComposition.Build;
    end,
    EComponentError
  );

  Assert.AreEqual(1, FImplementation.BuildCount);
end;

procedure TDockHubPageCompositionBaseTests.WindowButtons_InvokeConfiguredCallbacks;
var
  LMinimizeButton: TRectangle;
  LCloseButton: TRectangle;
begin
  BuildValidComposition;

  LMinimizeButton := FindButtonByCaption(#$2212);
  LCloseButton := FindButtonByCaption(#$00D7);

  Assert.IsNotNull(LMinimizeButton);
  Assert.IsNotNull(LCloseButton);
  Assert.IsTrue(Assigned(LMinimizeButton.OnClick));
  Assert.IsTrue(Assigned(LCloseButton.OnClick));

  LMinimizeButton.OnClick(LMinimizeButton);
  LCloseButton.OnClick(LCloseButton);

  Assert.AreEqual(1, FMinimizeCount);
  Assert.AreEqual(1, FCloseCount);
end;

procedure TDockHubPageCompositionBaseTests.WindowButtons_AreVisibleAndInsideClientBounds;
var
  LMinimizeButton: TRectangle;
  LCloseButton: TRectangle;
begin
  ConfigureHostWithDistinctClientArea;
  BuildValidComposition;

  LMinimizeButton := FindButtonByCaption(#$2212);
  LCloseButton := FindButtonByCaption(#$00D7);

  Assert.IsNotNull(LMinimizeButton);
  Assert.IsNotNull(LCloseButton);
  Assert.IsTrue(LMinimizeButton.Visible);
  Assert.IsTrue(LCloseButton.Visible);
  Assert.IsTrue(
    FHostForm.Width - FHostForm.ClientWidth >
    FHostForm.ClientWidth - (LCloseButton.Position.X + LCloseButton.Width),
    'Test scenario must detect Width-based right positioning.'
  );
  AssertButtonInsideClientBounds(LMinimizeButton);
  AssertButtonInsideClientBounds(LCloseButton);
  Assert.IsTrue(LMinimizeButton.Position.X < LCloseButton.Position.X);
  Assert.IsTrue(
    LMinimizeButton.Position.X + LMinimizeButton.Width <=
    LCloseButton.Position.X
  );
end;

procedure TDockHubPageCompositionBaseTests.WindowHover_UsesCurrentThemeAfterRuntimeChange;
var
  LMinimizeButton: TRectangle;
begin
  BuildValidComposition;
  FComposition.ApplyTheme(FTheme);

  FTheme.Theme(TDockHubThemeType.Teal);
  FComposition.ApplyTheme(FTheme);

  LMinimizeButton := FindButtonByCaption(#$2212);
  Assert.IsNotNull(LMinimizeButton);

  LMinimizeButton.OnMouseEnter(LMinimizeButton);
  Assert.AreEqual<TAlphaColor>(
    FTheme.SurfaceElevated,
    LMinimizeButton.Fill.Color
  );

  LMinimizeButton.OnMouseLeave(LMinimizeButton);
  Assert.AreEqual<TAlphaColor>(FTheme.Transparent, LMinimizeButton.Fill.Color);
end;

initialization
  TDUnitX.RegisterTestFixture(TDockHubPageCompositionBaseTests);

end.


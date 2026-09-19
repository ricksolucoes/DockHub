unit DockHub.Tests.View.Page.Main.Composition;

interface

uses
  DUnitX.TestFramework,

  System.Classes,
  System.UITypes,

  FMX.Forms,
  FMX.Types,
  FMX.Objects,
  FMX.StdCtrls,

  DockHub.Core.Language.Contracts,
  DockHub.View.Theme.Contracts,
  DockHub.View.Page.Contracts,
  DockHub.View.Page.Impl.Main.Composition;

type
  [TestFixture]
  [Category('Integration')]
  TDockHubPageMainCompositionTests = class
  private
    FHostForm: TForm;
    FComposition: IPageCompositionMain;
    FLanguage: IDockHubLanguage;
    FTheme: IDockHubTheme;
    FMinimizeCount: Integer;
    FCloseCount: Integer;

    procedure HandleMinimize(Sender: TObject);
    procedure HandleClose(Sender: TObject);

    function FindLabelByText(AParent: TFmxObject;
      const AText: string): TLabel;
    function FindButtonByCaption(const ACaption: string): TRectangle;
    function FindMainCard: TRectangle;
    function CountVisualDescendants(AParent: TFmxObject): Integer;
  public
    [Setup]
    procedure Setup;

    [TearDown]
    procedure TearDown;

    [Test]
    procedure Build_CreatesCenteredMainCard;

    [Test]
    procedure Build_SecondCall_DoesNotDuplicateVisualTree;

    [Test]
    procedure ApplyLanguage_PtBR_UpdatesMainTexts;

    [Test]
    procedure ApplyLanguage_EnUS_ReusesExistingControls;

    [Test]
    procedure ApplyTheme_RuntimeChange_UpdatesMainCard;

    [Test]
    procedure WindowHover_UsesCurrentThemeAfterRuntimeChange;

    [Test]
    procedure Build_UnimplementedActions_AreDisabled;

    [Test]
    procedure WindowButtons_InvokeConfiguredCallbacks;

    [Test]
    procedure FreeHost_WithBuiltComposition_DoesNotRaise;
  end;

implementation

uses
  DockHub.Core.Language.Impl,
  DockHub.Core.Language.Types,
  DockHub.View.Theme.Impl,
  DockHub.View.Theme.Types;

const
  _EXPECTED_CARD_WIDTH = 428;
  _EXPECTED_CARD_HEIGHT = 470;

{ TDockHubPageMainCompositionTests }

procedure TDockHubPageMainCompositionTests.Setup;
begin
  FHostForm := TForm.CreateNew(nil);
  FHostForm.Width := 750;
  FHostForm.Height := 550;

  FMinimizeCount := 0;
  FCloseCount := 0;
  FLanguage := TDockHubLanguage.New;
  FTheme := TDockHubTheme.New;

  FComposition := TPageMainComposition.New;

  FComposition
    .Form(FHostForm)
    .OnMinimize(HandleMinimize)
    .OnClose(HandleClose)
    .Build;
end;

procedure TDockHubPageMainCompositionTests.TearDown;
begin
  FTheme := nil;
  FLanguage := nil;

  FHostForm.Free;
  FHostForm := nil;
  FComposition := nil;
end;

procedure TDockHubPageMainCompositionTests.HandleMinimize(Sender: TObject);
begin
  Inc(FMinimizeCount);
end;

procedure TDockHubPageMainCompositionTests.HandleClose(Sender: TObject);
begin
  Inc(FCloseCount);
end;

function TDockHubPageMainCompositionTests.FindLabelByText(
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

function TDockHubPageMainCompositionTests.FindButtonByCaption(
  const ACaption: string): TRectangle;
var
  LCaption: TLabel;
begin
  LCaption := FindLabelByText(FHostForm, ACaption);

  if Assigned(LCaption) and (LCaption.Parent is TRectangle) then
    Exit(TRectangle(LCaption.Parent));

  Result := nil;
end;

function TDockHubPageMainCompositionTests.FindMainCard: TRectangle;
var
  I: Integer;
begin
  Result := nil;

  for I := 0 to FHostForm.ChildrenCount - 1 do
    if (FHostForm.Children[I] is TRectangle) and
       (TRectangle(FHostForm.Children[I]).Align = TAlignLayout.Center) then
      Exit(TRectangle(FHostForm.Children[I]));
end;

function TDockHubPageMainCompositionTests.CountVisualDescendants(
  AParent: TFmxObject): Integer;
var
  I: Integer;
begin
  Result := AParent.ChildrenCount;

  for I := 0 to AParent.ChildrenCount - 1 do
    Inc(Result, CountVisualDescendants(AParent.Children[I]));
end;

procedure TDockHubPageMainCompositionTests.Build_CreatesCenteredMainCard;
var
  LCard: TRectangle;
begin
  LCard := FindMainCard;

  Assert.IsNotNull(LCard);
  Assert.AreEqual<Single>(_EXPECTED_CARD_WIDTH, LCard.Width);
  Assert.AreEqual<Single>(_EXPECTED_CARD_HEIGHT, LCard.Height);
end;

procedure TDockHubPageMainCompositionTests.Build_SecondCall_DoesNotDuplicateVisualTree;
var
  LBefore: Integer;
  LAfter: Integer;
begin
  LBefore := CountVisualDescendants(FHostForm);

  FComposition.Build;

  LAfter := CountVisualDescendants(FHostForm);

  Assert.AreEqual(LBefore, LAfter);
end;

procedure TDockHubPageMainCompositionTests.ApplyLanguage_PtBR_UpdatesMainTexts;
begin
  FComposition.ApplyLanguage(FLanguage);

  Assert.IsNotNull(FindLabelByText(FHostForm, 'Serviço da API'));
  Assert.IsNotNull(FindLabelByText(FHostForm, 'Serviço Windows'));
  Assert.IsNotNull(FindLabelByText(FHostForm, 'Não verificado'));
  Assert.IsNotNull(FindButtonByCaption('Instalar'));
  Assert.IsNotNull(FindButtonByCaption('Abrir logs'));
end;

procedure TDockHubPageMainCompositionTests.ApplyLanguage_EnUS_ReusesExistingControls;
var
  LSubtitle: TLabel;
begin
  FComposition.ApplyLanguage(FLanguage);
  LSubtitle := FindLabelByText(FHostForm, 'Serviço da API');

  FLanguage.Language(TDockHubLanguageType.EnUS);
  FComposition.ApplyLanguage(FLanguage);

  Assert.IsNotNull(LSubtitle);
  Assert.AreEqual('API Service', LSubtitle.Text);
  Assert.IsNotNull(FindButtonByCaption('Install'));
  Assert.IsNotNull(FindButtonByCaption('Open logs'));
end;

procedure TDockHubPageMainCompositionTests.ApplyTheme_RuntimeChange_UpdatesMainCard;
var
  LCard: TRectangle;
begin
  LCard := FindMainCard;
  Assert.IsNotNull(LCard);

  FComposition.ApplyTheme(FTheme);
  Assert.AreEqual<TAlphaColor>(FTheme.SurfaceCard, LCard.Fill.Color);

  FTheme.Theme(TDockHubThemeType.Teal);
  FComposition.ApplyTheme(FTheme);

  Assert.AreEqual<TAlphaColor>(FTheme.SurfaceCard, LCard.Fill.Color);
  Assert.AreEqual<TAlphaColor>(FTheme.Border, LCard.Stroke.Color);
end;

procedure TDockHubPageMainCompositionTests.WindowHover_UsesCurrentThemeAfterRuntimeChange;
var
  LMinimizeButton: TRectangle;
begin
  LMinimizeButton := FindButtonByCaption(#$2212);
  Assert.IsNotNull(LMinimizeButton);

  FComposition.ApplyTheme(FTheme);

  FTheme.Theme(TDockHubThemeType.Teal);
  FComposition.ApplyTheme(FTheme);

  LMinimizeButton.OnMouseEnter(LMinimizeButton);
  Assert.AreEqual<TAlphaColor>(
    FTheme.SurfaceElevated,
    LMinimizeButton.Fill.Color
  );

  LMinimizeButton.OnMouseLeave(LMinimizeButton);
  Assert.AreEqual<TAlphaColor>(FTheme.Transparent, LMinimizeButton.Fill.Color);
end;

procedure TDockHubPageMainCompositionTests.Build_UnimplementedActions_AreDisabled;
const
  LCaptions: array[0..5] of string = (
    'Instalar',
    'Desinstalar',
    'Iniciar',
    'Parar',
    'Abrir configuração',
    'Abrir logs'
  );
var
  I: Integer;
  LButton: TRectangle;
begin
  FComposition.ApplyLanguage(FLanguage);

  for I := Low(LCaptions) to High(LCaptions) do
  begin
    LButton := FindButtonByCaption(LCaptions[I]);
    Assert.IsNotNull(LButton);
    Assert.IsFalse(LButton.Enabled);
  end;
end;

procedure TDockHubPageMainCompositionTests.WindowButtons_InvokeConfiguredCallbacks;
var
  LMinimizeButton: TRectangle;
  LCloseButton: TRectangle;
begin
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

procedure TDockHubPageMainCompositionTests.FreeHost_WithBuiltComposition_DoesNotRaise;
begin
  FHostForm.Free;
  FHostForm := nil;
  FComposition := nil;
end;

initialization
  TDUnitX.RegisterTestFixture(TDockHubPageMainCompositionTests);

end.

unit DockHub.Tests.Runner.FMX;

interface

procedure RunDockHubTests;

implementation

uses
  DUnitX.Extensibility,
  DUnitX.Loggers.XML.NUnit,
  DUnitX.TestFramework,

  FMX.Controls,
  FMX.Controls.Presentation,
  FMX.Edit,
  FMX.Forms,
  FMX.Layouts,
  FMX.ListBox,
  FMX.Memo,
  FMX.Objects,
  FMX.StdCtrls,
  FMX.TreeView,
  FMX.Types,

  System.Classes,
  System.IniFiles,
  System.IOUtils,
  System.StrUtils,
  System.SysUtils,
  System.UITypes, FMX.Graphics;

type
  TResultFilter = (
    rfAll,
    rfFailure,
    rfError,
    rfMemoryLeak,
    rfIgnored
  );

  TResultSummaryKind = (
    skFound,
    skPassed,
    skIgnored,
    skMemoryLeak,
    skFailed,
    skError
  );

  TSelectionItemKind = (
    sikFixture,
    sikTest
  );

  TRunnerThemeKind = (
    rtkDark,
    rtkLight
  );

  TRunnerStatusTone = (
    rstNeutral,
    rstAccent,
    rstPass,
    rstFailure,
    rstError,
    rstWarning
  );

  TRunnerPalette = record
    Background: TAlphaColor;
    Surface: TAlphaColor;
    ControlSurface: TAlphaColor;
    Border: TAlphaColor;
    TextPrimary: TAlphaColor;
    TextSecondary: TAlphaColor;
    Accent: TAlphaColor;
    ButtonSurface: TAlphaColor;
    ResultColors: array[TTestResultType] of TAlphaColor;
    ResultBackgrounds: array[TTestResultType] of TAlphaColor;
    SummaryColors: array[TResultSummaryKind] of TAlphaColor;
  end;

  TTestResultListItem = class(TListBoxItem)
  private
    FResult: ITestResult;
    FBackground: TRectangle;
    FIndicator: TRectangle;
    FStatusText: TText;
    FNameText: TText;

    procedure BuildBackground;
    procedure BuildIndicator;
    procedure BuildStatusText;
    procedure BuildNameText;
  public
    constructor CreateResult(
      AOwner: TComponent;
      const AResult: ITestResult); reintroduce;
    procedure ApplyPalette(const APalette: TRunnerPalette);

    property TestResult: ITestResult read FResult;
  end;

  TTestSelectionTreeItem = class(TTreeViewItem)
  private
    FItemKind: TSelectionItemKind;
    FFixture: ITestFixture;
    FTest: ITest;
  public
    constructor CreateFixture(
      AOwner: TComponent;
      const AFixture: ITestFixture);
    constructor CreateTest(
      AOwner: TComponent;
      const ATest: ITest);

    function IsFixture: Boolean;
    function IsTest: Boolean;

    property Fixture: ITestFixture read FFixture;
    property Test: ITest read FTest;
  end;

  TDockHubTestsRunnerForm = class(TForm)
  private
    FCurrentTheme: TRunnerThemeKind;
    FPalette: TRunnerPalette;
    FStatusTone: TRunnerStatusTone;
    FToolbar: TRectangle;
    FToolbarTitle: TText;
    FThemeLabel: TText;
    FThemeSelector: TComboBox;
    FRunAllButton: TButton;
    FRunSelectedButton: TButton;
    FStatusLabel: TText;
    FSummaryGrid: TGridPanelLayout;
    FSummaryCards: array[TResultSummaryKind] of TRectangle;
    FSummaryAccents: array[TResultSummaryKind] of TRectangle;
    FSummaryCaptions: array[TResultSummaryKind] of TText;
    FSummaryValues: array[TResultSummaryKind] of TText;
    FFilterCaption: TText;
    FFilterButtons: array[TResultFilter] of TButton;
    FResultPanel: TRectangle;
    FResultList: TListBox;
    FDetailsPanel: TRectangle;
    FDetailsTitle: TText;
    FDetailsMemo: TMemo;
    FSelectionPanel: TRectangle;
    FSelectionTitle: TText;
    FSelectionSearch: TEdit;
    FSelectionTree: TTreeView;
    FSelectionCount: TText;
    FSelectAllButton: TButton;
    FSelectNoneButton: TButton;
    FInvertSelectionButton: TButton;
    FSelectionFixtures: ITestFixtureList;
    FResults: IRunResults;
    FActiveFilter: TResultFilter;
    FRunning: Boolean;
    FUpdatingSelection: Boolean;

    procedure ConfigureForm;
    procedure BuildUI;
    procedure LoadThemePreference;
    function SaveThemePreference: Boolean;
    function ThemeConfigFileName: string;
    procedure SetTheme(const ATheme: TRunnerThemeKind);
    procedure ApplyTheme;
    procedure ApplyThemeToChrome;
    procedure ApplyThemeToSummary;
    procedure ApplyThemeToSelection;
    procedure ApplyThemeToResults;
    procedure ApplyThemeToButtons;
    procedure ApplyThemeToTreeItems;
    procedure ApplyThemeToResultItems;
    procedure ApplyStyledControlTheme(const AControl: TControl);
    function ApplyControlBackground(const AControl: TControl): Boolean;
    function EnsureThemeBackground(const AParent: TFmxObject): TRectangle;
    procedure ApplyControlTextColor(const AControl: TControl);
    procedure HandleStyledControlApplyStyleLookup(Sender: TObject);
    procedure HandleThemeChange(Sender: TObject);

    procedure BuildToolbar;
    function CreateToolbar: TRectangle;
    procedure BuildToolbarTitle(const AParent: TFmxObject);
    procedure BuildToolbarThemeSelector(const AParent: TFmxObject);
    procedure BuildToolbarThemeLabel(const AParent: TFmxObject);
    procedure BuildToolbarRunButtons(const AParent: TFmxObject);
    function CreateToolbarRunButton(
      const AParent: TFmxObject;
      const ACaption: string;
      const AHandler: TNotifyEvent): TButton;
    procedure BuildToolbarStatus(const AParent: TFmxObject);

    function CreateSummaryWrapper: TLayout;
    function CreateSummaryGrid(const AParent: TFmxObject): TGridPanelLayout;
    procedure ConfigureSummaryGridRows(const AGrid: TGridPanelLayout);
    procedure ConfigureSummaryGridColumns(const AGrid: TGridPanelLayout);

    procedure BuildSummary;
    function CreateSummaryCard(
      const AParent: TFmxObject;
      const AKind: TResultSummaryKind): TText;
    function CreateSummaryCardContainer(
      const AParent: TFmxObject): TRectangle;
    function BuildSummaryCardAccent(
      const AParent: TFmxObject;
      const AColor: TAlphaColor): TRectangle;
    function BuildSummaryCardCaption(
      const AParent: TFmxObject;
      const ACaption: string): TText;
    function BuildSummaryCardValue(
      const AParent: TFmxObject;
      const AColor: TAlphaColor): TText;

    procedure BuildFilters;
    procedure BuildFilterCaption(const AParent: TFmxObject);
    procedure BuildFilterButtons(const AParent: TFmxObject);
    function CreateFilterButton(
      const AParent: TFmxObject;
      const AFilter: TResultFilter): TButton;

    procedure BuildDetails;
    function CreateDetailsPanel: TRectangle;
    procedure BuildDetailsTitle(const AParent: TFmxObject);
    procedure BuildDetailsMemo(const AParent: TFmxObject);

    procedure BuildWorkspace;
    procedure BuildSelectionPanel(const AParent: TFmxObject);
    function CreateSelectionPanel(const AParent: TFmxObject): TRectangle;
    procedure BuildSelectionHeader(const AParent: TFmxObject);
    procedure BuildSelectionTitle(const AParent: TFmxObject);
    procedure BuildSelectionCount(const AParent: TFmxObject);
    procedure BuildSelectionSearch(const AParent: TFmxObject);
    procedure BuildSelectionActions(const AParent: TFmxObject);
    function CreateSelectionActionButton(
      const AParent: TFmxObject;
      const ACaption: string;
      const AWidth: Single;
      const AHandler: TNotifyEvent): TButton;
    procedure BuildSelectionTree(const AParent: TFmxObject);
    procedure BuildResults(const AParent: TFmxObject);


    procedure LoadTestCatalog;
    procedure RebuildSelectionTree;
    procedure AddFixtureSelectionNode(
      const AFixture: ITestFixture;
      const AParent: TTreeViewItem;
      const ASearchText: string);
    procedure AddFixtureTests(
      const AFixture: ITestFixture;
      const AParent: TTreeViewItem;
      const ASearchText: string;
      const AShowAll: Boolean);
    procedure AddChildFixtures(
      const AFixture: ITestFixture;
      const AParent: TTreeViewItem;
      const ASearchText: string;
      const AShowAll: Boolean);
    function FixtureNameMatchesSearch(
      const AFixture: ITestFixture;
      const ASearchText: string): Boolean;
    function FixtureHasTestMatchingSearch(
      const AFixture: ITestFixture;
      const ASearchText: string): Boolean;
    function FixtureHasChildMatchingSearch(
      const AFixture: ITestFixture;
      const ASearchText: string): Boolean;
    function FixtureMatchesSearch(
      const AFixture: ITestFixture;
      const ASearchText: string): Boolean;
    function TestMatchesSearch(
      const ATest: ITest;
      const ASearchText: string): Boolean;

    procedure HandleRunAllClick(Sender: TObject);
    procedure HandleRunSelectedClick(Sender: TObject);
    procedure HandleFilterClick(Sender: TObject);
    procedure HandleResultSelection(Sender: TObject);
    procedure HandleSearchChange(Sender: TObject);
    procedure HandleSelectionCheck(Sender: TObject);
    procedure HandleSelectAllClick(Sender: TObject);
    procedure HandleSelectNoneClick(Sender: TObject);
    procedure HandleInvertSelectionClick(Sender: TObject);
    procedure HandleSelectionDoubleClick(Sender: TObject);

    procedure SetRunning(const AValue: Boolean);
    procedure SetStatus(const AText: string; const ATone: TRunnerStatusTone);
    function StatusColor(const ATone: TRunnerStatusTone): TAlphaColor;
    procedure ResetOutput;
    procedure ResetSummary;
    procedure ClearDetails;

    procedure SetAllCatalogTests(const AEnabled: Boolean);
    procedure SetFixtureTests(
      const AFixture: ITestFixture;
      const AEnabled: Boolean);
    procedure InvertCatalogTests;
    procedure InvertFixtureTests(const AFixture: ITestFixture);
    procedure UpdateCatalogFixtureStates;
    function UpdateFixtureEnabledState(const AFixture: ITestFixture): Boolean;
    procedure UpdateSelectionTreeState;
    procedure UpdateSelectionTreeItem(const AItem: TTestSelectionTreeItem);
    procedure UpdateFixtureTreeItem(const AItem: TTestSelectionTreeItem);
    procedure UpdateSelectionCount;
    function CountSelectedTests: Integer;
    function CountFixtureTests(
      const AFixture: ITestFixture;
      const ASelectedOnly: Boolean): Integer;

    procedure ExecuteAllTests;
    procedure ExecuteSelectedTests;
    procedure ExecuteSingleTest(const ATestFullName: string);
    procedure ExecuteTests(const ATestNames: TStrings);
    procedure RunSuite(const ATestNames: TStrings);
    function CreateTestRunner: ITestRunner;
    procedure ApplyExecutionSelection(
      const AFixtures: ITestFixtureList;
      const ATestNames: TStrings);
    function ApplyFixtureExecutionSelection(
      const AFixture: ITestFixture;
      const ATestNames: TStrings): Boolean;
    function CaptureSelectedTestNames: TStringList;
    procedure CaptureFixtureTestNames(
      const AFixture: ITestFixture;
      const ATarget: TStrings);
    procedure ApplyExecutionResult(const AResults: IRunResults);
    procedure HandleExecutionException(const AException: Exception);

    procedure UpdateSummary(const AResults: IRunResults);
    procedure RebuildResultList;
    procedure AddFilteredResult(
      const AResult: ITestResult;
      var ACurrentFixture: string);
    procedure AddFixtureHeader(const AFixtureName: string);
    procedure AddResultItem(const AResult: ITestResult);
    procedure UpdateFilterButtons;

    function MatchesFilter(const AResult: ITestResult): Boolean;
    procedure ShowResultDetails(const AResult: ITestResult);
    procedure AddComparableDetails(const AResult: ITestResult);
    procedure AddStackTrace(const AResult: ITestResult);
  public
    constructor Create(AOwner: TComponent); override;
  end;

const
  _THEME_SECTION = 'Appearance';
  _THEME_KEY = 'Theme';
  _THEME_DARK = 'Dark';
  _THEME_LIGHT = 'Light';
  _THEME_CONFIG_FILE = 'DockHub.Tests.ini';

  _RESULT_LABELS: array[TTestResultType] of string = (
    'APROVADO',
    'FALHA',
    'ERRO',
    'IGNORADO',
    'LEAK',
    'AVISO'
  );

  _FILTER_CAPTIONS: array[TResultFilter] of string = (
    'Todos',
    'Falhas',
    'Erros',
    'Leaks',
    'Ignorados'
  );

  _SUMMARY_CAPTIONS: array[TResultSummaryKind] of string = (
    'Encontrados',
    'Aprovados',
    'Ignorados',
    'Leaks',
    'Falhas',
    'Erros'
  );

procedure ConfigureLightBase(var APalette: TRunnerPalette);
begin
  APalette.Background := TAlphaColor($FFF5F7FA);
  APalette.Surface := TAlphaColor($FFFFFFFF);
  APalette.ControlSurface := TAlphaColor($FFF8FAFC);
  APalette.Border := TAlphaColor($FFE1E6EC);
  APalette.TextPrimary := TAlphaColor($FF20262E);
  APalette.TextSecondary := TAlphaColor($FF667085);
  APalette.Accent := TAlphaColor($FF2563EB);
  APalette.ButtonSurface := TAlphaColor($FFF8FAFC);
end;

procedure ConfigureLightResults(var APalette: TRunnerPalette);
begin
  APalette.ResultColors[TTestResultType.Pass] := TAlphaColor($FF16803C);
  APalette.ResultColors[TTestResultType.Failure] := TAlphaColor($FFC62828);
  APalette.ResultColors[TTestResultType.Error] := TAlphaColor($FFD9480F);
  APalette.ResultColors[TTestResultType.Ignored] := TAlphaColor($FF667085);
  APalette.ResultColors[TTestResultType.MemoryLeak] := TAlphaColor($FFB7791F);
  APalette.ResultColors[TTestResultType.Warning] := TAlphaColor($FFB7791F);
end;

procedure ConfigureLightResultBackgrounds(var APalette: TRunnerPalette);
begin
  APalette.ResultBackgrounds[TTestResultType.Pass] := TAlphaColor($FFEAF7EF);
  APalette.ResultBackgrounds[TTestResultType.Failure] := TAlphaColor($FFFDECEC);
  APalette.ResultBackgrounds[TTestResultType.Error] := TAlphaColor($FFFFF1E8);
  APalette.ResultBackgrounds[TTestResultType.Ignored] := TAlphaColor($FFF1F3F5);
  APalette.ResultBackgrounds[TTestResultType.MemoryLeak] := TAlphaColor($FFFFF6DD);
  APalette.ResultBackgrounds[TTestResultType.Warning] := TAlphaColor($FFFFF6DD);
end;

procedure ConfigureDarkBase(var APalette: TRunnerPalette);
begin
  APalette.Background := TAlphaColor($FF0F172A);
  APalette.Surface := TAlphaColor($FF111827);
  APalette.ControlSurface := TAlphaColor($FF1F2937);
  APalette.Border := TAlphaColor($FF334155);
  APalette.TextPrimary := TAlphaColor($FFF8FAFC);
  APalette.TextSecondary := TAlphaColor($FF94A3B8);
  APalette.Accent := TAlphaColor($FF60A5FA);
  APalette.ButtonSurface := TAlphaColor($FF1E293B);
end;

procedure ConfigureDarkResults(var APalette: TRunnerPalette);
begin
  APalette.ResultColors[TTestResultType.Pass] := TAlphaColor($FF4ADE80);
  APalette.ResultColors[TTestResultType.Failure] := TAlphaColor($FFF87171);
  APalette.ResultColors[TTestResultType.Error] := TAlphaColor($FFFB923C);
  APalette.ResultColors[TTestResultType.Ignored] := TAlphaColor($FF94A3B8);
  APalette.ResultColors[TTestResultType.MemoryLeak] := TAlphaColor($FFFBBF24);
  APalette.ResultColors[TTestResultType.Warning] := TAlphaColor($FFFBBF24);
end;

procedure ConfigureDarkResultBackgrounds(var APalette: TRunnerPalette);
begin
  APalette.ResultBackgrounds[TTestResultType.Pass] := TAlphaColor($FF123222);
  APalette.ResultBackgrounds[TTestResultType.Failure] := TAlphaColor($FF3A171B);
  APalette.ResultBackgrounds[TTestResultType.Error] := TAlphaColor($FF3A2114);
  APalette.ResultBackgrounds[TTestResultType.Ignored] := TAlphaColor($FF1E293B);
  APalette.ResultBackgrounds[TTestResultType.MemoryLeak] := TAlphaColor($FF3A2D12);
  APalette.ResultBackgrounds[TTestResultType.Warning] := TAlphaColor($FF3A2D12);
end;

procedure ConfigureSummaryColors(var APalette: TRunnerPalette);
begin
  APalette.SummaryColors[TResultSummaryKind.skFound] := APalette.Accent;
  APalette.SummaryColors[TResultSummaryKind.skPassed] := APalette.ResultColors[TTestResultType.Pass];
  APalette.SummaryColors[TResultSummaryKind.skIgnored] := APalette.ResultColors[TTestResultType.Ignored];
  APalette.SummaryColors[TResultSummaryKind.skMemoryLeak] := APalette.ResultColors[TTestResultType.MemoryLeak];
  APalette.SummaryColors[TResultSummaryKind.skFailed] := APalette.ResultColors[TTestResultType.Failure];
  APalette.SummaryColors[TResultSummaryKind.skError] := APalette.ResultColors[TTestResultType.Error];
end;

function BuildRunnerPalette(const ATheme: TRunnerThemeKind): TRunnerPalette;
begin
  if ATheme = TRunnerThemeKind.rtkLight then
  begin
    ConfigureLightBase(Result);
    ConfigureLightResults(Result);
    ConfigureLightResultBackgrounds(Result);
  end
  else
  begin
    ConfigureDarkBase(Result);
    ConfigureDarkResults(Result);
    ConfigureDarkResultBackgrounds(Result);
  end;
  ConfigureSummaryColors(Result);
end;

function ThemeToStoredValue(const ATheme: TRunnerThemeKind): string;
begin
  if ATheme = TRunnerThemeKind.rtkLight then
    Result := _THEME_LIGHT
  else
    Result := _THEME_DARK;
end;

function StoredValueToTheme(const AValue: string): TRunnerThemeKind;
begin
  Result := TRunnerThemeKind.rtkDark;
  if SameText(Trim(AValue), _THEME_LIGHT) then
    Result := TRunnerThemeKind.rtkLight;
end;

var
  DockHubTestsRunnerForm: TDockHubTestsRunnerForm;

{ TTestResultListItem }

constructor TTestResultListItem.CreateResult(
  AOwner: TComponent;
  const AResult: ITestResult);
begin
  inherited Create(AOwner);
  FResult := AResult;
  Height := 36;
  Text := EmptyStr;
  BuildBackground;
  BuildIndicator;
  BuildStatusText;
  BuildNameText;
end;

procedure TTestResultListItem.BuildBackground;
begin
  FBackground := TRectangle.Create(Self);
  FBackground.Parent := Self;
  FBackground.Align := TAlignLayout.Client;
  FBackground.HitTest := False;
  FBackground.Stroke.Kind := TBrushKind.None;
  FBackground.Fill.Kind := TBrushKind.Solid;
  FBackground.SendToBack;
end;

procedure TTestResultListItem.BuildIndicator;
begin
  FIndicator := TRectangle.Create(Self);
  FIndicator.Parent := Self;
  FIndicator.Align := TAlignLayout.Left;
  FIndicator.Width := 4;
  FIndicator.HitTest := False;
  FIndicator.Stroke.Kind := TBrushKind.None;
  FIndicator.Fill.Kind := TBrushKind.Solid;
end;

procedure TTestResultListItem.BuildStatusText;
begin
  FStatusText := TText.Create(Self);
  FStatusText.Parent := Self;
  FStatusText.Align := TAlignLayout.Left;
  FStatusText.Width := 108;
  FStatusText.Margins.Left := 10;
  FStatusText.HitTest := False;
  FStatusText.HorzTextAlign := TTextAlign.Leading;
  FStatusText.VertTextAlign := TTextAlign.Center;
  FStatusText.TextSettings.Font.Size := 11;
  FStatusText.TextSettings.Font.Style := [TFontStyle.fsBold];
  FStatusText.Text := _RESULT_LABELS[FResult.ResultType];
end;

procedure TTestResultListItem.BuildNameText;
begin
  FNameText := TText.Create(Self);
  FNameText.Parent := Self;
  FNameText.Align := TAlignLayout.Client;
  FNameText.Margins.Left := 8;
  FNameText.Margins.Right := 8;
  FNameText.HitTest := False;
  FNameText.HorzTextAlign := TTextAlign.Leading;
  FNameText.VertTextAlign := TTextAlign.Center;
  FNameText.TextSettings.Font.Size := 12;
  FNameText.Text := FResult.Test.Name;
end;

procedure TTestResultListItem.ApplyPalette(
  const APalette: TRunnerPalette);
begin
  FBackground.Fill.Color := APalette.ResultBackgrounds[FResult.ResultType];
  FIndicator.Fill.Color := APalette.ResultColors[FResult.ResultType];
  FStatusText.TextSettings.FontColor := APalette.ResultColors[FResult.ResultType];
  FNameText.TextSettings.FontColor := APalette.TextPrimary;
end;

{ TTestSelectionTreeItem }

constructor TTestSelectionTreeItem.CreateFixture(
  AOwner: TComponent;
  const AFixture: ITestFixture);
begin
  inherited Create(AOwner);
  FItemKind := TSelectionItemKind.sikFixture;
  FFixture := AFixture;
  Text := AFixture.Name;
  TextSettings.Font.Style := [TFontStyle.fsBold];
end;

constructor TTestSelectionTreeItem.CreateTest(
  AOwner: TComponent;
  const ATest: ITest);
begin
  inherited Create(AOwner);
  FItemKind := TSelectionItemKind.sikTest;
  FTest := ATest;
  Text := ATest.Name;
end;

function TTestSelectionTreeItem.IsFixture: Boolean;
begin
  Result := FItemKind = TSelectionItemKind.sikFixture;
end;

function TTestSelectionTreeItem.IsTest: Boolean;
begin
  Result := FItemKind = TSelectionItemKind.sikTest;
end;

{ TDockHubTestsRunnerForm }

constructor TDockHubTestsRunnerForm.Create(AOwner: TComponent);
begin
  inherited CreateNew(AOwner);
  FActiveFilter := TResultFilter.rfAll;
  LoadThemePreference;
  ConfigureForm;
  BuildUI;
  LoadTestCatalog;
  ResetOutput;
  ApplyTheme;
end;

procedure TDockHubTestsRunnerForm.ConfigureForm;
begin
  Caption := 'DockHub Tests';
  Width := 1280;
  Height := 800;
  Position := TFormPosition.ScreenCenter;
  Fill.Kind := TBrushKind.Solid;
  Fill.Color := FPalette.Background;
end;

procedure TDockHubTestsRunnerForm.BuildUI;
begin
  BuildToolbar;
  BuildSummary;
  BuildFilters;
  BuildDetails;
  BuildWorkspace;
end;

procedure TDockHubTestsRunnerForm.LoadThemePreference;
var
  LIni: TMemIniFile;
  LFileName: string;
begin
  FCurrentTheme := TRunnerThemeKind.rtkDark;

  LFileName := ThemeConfigFileName;

  if Not LFileName.Trim.IsEmpty then
  begin
    try
      LIni := TMemIniFile.Create(LFileName);
      try
        FCurrentTheme := StoredValueToTheme(
          LIni.ReadString(_THEME_SECTION, _THEME_KEY, _THEME_DARK));
      finally
        LIni.Free;
      end;
    except
      FCurrentTheme := TRunnerThemeKind.rtkDark;
    end;
  end;

  FPalette := BuildRunnerPalette(FCurrentTheme);
end;

function TDockHubTestsRunnerForm.SaveThemePreference: Boolean;
var
  LIni: TMemIniFile;
  LFileName: string;
begin
  Result := False;
  LFileName := ThemeConfigFileName;

  if LFileName.trim.IsEmpty then
    Exit;

  try
    LIni := TMemIniFile.Create(LFileName);
    try
      LIni.WriteString(_THEME_SECTION, _THEME_KEY, ThemeToStoredValue(FCurrentTheme));
      LIni.UpdateFile;
      Result := True;
    finally
      LIni.Free;
    end;
  except
    Result := False;
  end;
end;

function TDockHubTestsRunnerForm.ThemeConfigFileName: string;
var
  LHomePath: string;
begin
  Result := EmptyStr;

  try
    LHomePath := TPath.GetDirectoryName(ParamStr(0));
    if not LHomePath.Trim.IsEmpty then
      Result := TPath.Combine(LHomePath, _THEME_CONFIG_FILE);
  except
    Result := EmptyStr;
  end;
end;

procedure TDockHubTestsRunnerForm.SetTheme(
  const ATheme: TRunnerThemeKind);
begin
  FCurrentTheme := ATheme;
  FPalette := BuildRunnerPalette(ATheme);
  if (FThemeSelector <> nil) and
    (FThemeSelector.ItemIndex <> Ord(ATheme)) then
    FThemeSelector.ItemIndex := Ord(ATheme);
  ApplyTheme;
end;

procedure TDockHubTestsRunnerForm.ApplyTheme;
begin
  ApplyThemeToChrome;
  ApplyThemeToSummary;
  ApplyThemeToSelection;
  ApplyThemeToResults;
  ApplyThemeToButtons;
  ApplyThemeToTreeItems;
  ApplyThemeToResultItems;
end;

procedure TDockHubTestsRunnerForm.ApplyThemeToChrome;
begin
  Fill.Color := FPalette.Background;
  FToolbar.Fill.Color := FPalette.Surface;
  FToolbar.Stroke.Color := FPalette.Border;
  FToolbarTitle.TextSettings.FontColor := FPalette.TextPrimary;
  FThemeLabel.TextSettings.FontColor := FPalette.TextSecondary;
  FFilterCaption.TextSettings.FontColor := FPalette.TextSecondary;
  FDetailsPanel.Fill.Color := FPalette.Surface;
  FDetailsPanel.Stroke.Color := FPalette.Border;
  SetStatus(FStatusLabel.Text, FStatusTone);
end;

procedure TDockHubTestsRunnerForm.ApplyThemeToSummary;
var
  LKind: TResultSummaryKind;
begin
  for LKind := Low(TResultSummaryKind) to High(TResultSummaryKind) do
  begin
    FSummaryCards[LKind].Fill.Color := FPalette.Surface;
    FSummaryCards[LKind].Stroke.Color := FPalette.Border;
    FSummaryAccents[LKind].Fill.Color := FPalette.SummaryColors[LKind];
    FSummaryCaptions[LKind].TextSettings.FontColor := FPalette.TextSecondary;
    FSummaryValues[LKind].TextSettings.FontColor := FPalette.SummaryColors[LKind];
  end;
end;

procedure TDockHubTestsRunnerForm.ApplyThemeToSelection;
begin
  FSelectionPanel.Fill.Color := FPalette.Surface;
  FSelectionPanel.Stroke.Color := FPalette.Border;
  FSelectionTitle.TextSettings.FontColor := FPalette.TextPrimary;
  FSelectionCount.TextSettings.FontColor := FPalette.TextSecondary;
  ApplyStyledControlTheme(FSelectionSearch);
  ApplyStyledControlTheme(FSelectionTree);
end;

procedure TDockHubTestsRunnerForm.ApplyThemeToResults;
begin
  FResultPanel.Fill.Color := FPalette.Surface;
  FResultPanel.Stroke.Color := FPalette.Border;
  FDetailsTitle.TextSettings.FontColor := FPalette.TextSecondary;
  if FResultList.Selected is TTestResultListItem then
    FDetailsTitle.TextSettings.FontColor := FPalette.ResultColors[
      TTestResultListItem(FResultList.Selected).TestResult.ResultType];
  ApplyStyledControlTheme(FResultList);
  ApplyStyledControlTheme(FDetailsMemo);
end;

procedure TDockHubTestsRunnerForm.ApplyThemeToButtons;
var
  LFilter: TResultFilter;
begin
  ApplyStyledControlTheme(FRunAllButton);
  ApplyStyledControlTheme(FRunSelectedButton);
  ApplyStyledControlTheme(FSelectAllButton);
  ApplyStyledControlTheme(FSelectNoneButton);
  ApplyStyledControlTheme(FInvertSelectionButton);
  for LFilter := Low(TResultFilter) to High(TResultFilter) do
    ApplyStyledControlTheme(FFilterButtons[LFilter]);
end;

procedure TDockHubTestsRunnerForm.ApplyThemeToTreeItems;
var
  LIndex: Integer;
  LItem: TTreeViewItem;
begin
  for LIndex := 0 to FSelectionTree.GlobalCount - 1 do
  begin
    LItem := FSelectionTree.ItemByGlobalIndex(LIndex);
    LItem.StyledSettings := LItem.StyledSettings - [TStyledSetting.FontColor];
    LItem.TextSettings.FontColor := FPalette.TextPrimary;
  end;
end;

procedure TDockHubTestsRunnerForm.ApplyThemeToResultItems;
var
  LIndex: Integer;
  LItem: TListBoxItem;
begin
  for LIndex := 0 to FResultList.Count - 1 do
  begin
    LItem := FResultList.ListItems[LIndex];
    if LItem is TTestResultListItem then
      TTestResultListItem(LItem).ApplyPalette(FPalette)
    else if LItem is TListBoxGroupHeader then
    begin
      ApplyStyledControlTheme(LItem);
      LItem.StyledSettings := LItem.StyledSettings - [TStyledSetting.FontColor];
      LItem.TextSettings.FontColor := FPalette.TextSecondary;
    end;
  end;
end;

procedure TDockHubTestsRunnerForm.ApplyStyledControlTheme(
  const AControl: TControl);
begin
  if AControl = nil then
    Exit;
  if ApplyControlBackground(AControl) then
    ApplyControlTextColor(AControl);
end;

function TDockHubTestsRunnerForm.ApplyControlBackground(
  const AControl: TControl): Boolean;
var
  LBackground: TFmxObject;
  LThemeBackground: TRectangle;
  LColor: TAlphaColor;
begin
  LBackground := AControl.FindStyleResource('background');
  Result := LBackground <> nil;
  if not Result then
    Exit;
  LColor := FPalette.ControlSurface;
  if AControl is TButton then
    LColor := FPalette.ButtonSurface;
  LThemeBackground := EnsureThemeBackground(LBackground);
  LThemeBackground.Fill.Color := LColor;
end;

function TDockHubTestsRunnerForm.EnsureThemeBackground(
  const AParent: TFmxObject): TRectangle;
var
  LIndex: Integer;
begin
  for LIndex := 0 to AParent.ChildrenCount - 1 do
    if (AParent.Children[LIndex] is TRectangle) and
      (AParent.Children[LIndex].StyleName = 'dockhubthemebg') then
      Exit(TRectangle(AParent.Children[LIndex]));
  Result := TRectangle.Create(AParent);
  Result.StyleName := 'dockhubthemebg';
  Result.Parent := AParent;
  Result.Align := TAlignLayout.Contents;
  Result.HitTest := False;
  Result.Stroke.Kind := TBrushKind.None;
  Result.Fill.Kind := TBrushKind.Solid;
  Result.SendToBack;
end;

procedure TDockHubTestsRunnerForm.ApplyControlTextColor(
  const AControl: TControl);
begin
  if AControl is TButton then
  begin
    TButton(AControl).StyledSettings := TButton(AControl).StyledSettings - [TStyledSetting.FontColor];
    TButton(AControl).TextSettings.FontColor := FPalette.TextPrimary;
  end
  else if AControl is TEdit then
  begin
    TEdit(AControl).StyledSettings := TEdit(AControl).StyledSettings - [TStyledSetting.FontColor];
    TEdit(AControl).TextSettings.FontColor := FPalette.TextPrimary;
  end
  else if AControl is TMemo then
  begin
    TMemo(AControl).StyledSettings := TMemo(AControl).StyledSettings - [TStyledSetting.FontColor];
    TMemo(AControl).TextSettings.FontColor := FPalette.TextPrimary;
  end

end;

procedure TDockHubTestsRunnerForm.HandleStyledControlApplyStyleLookup(
  Sender: TObject);
begin
  if Sender is TControl then
    ApplyStyledControlTheme(TControl(Sender));
end;

procedure TDockHubTestsRunnerForm.HandleThemeChange(Sender: TObject);
var
  LTheme: TRunnerThemeKind;
begin
  if FThemeSelector.ItemIndex = Ord(TRunnerThemeKind.rtkLight) then
    LTheme := TRunnerThemeKind.rtkLight
  else
    LTheme := TRunnerThemeKind.rtkDark;
  if LTheme = FCurrentTheme then
    Exit;
  SetTheme(LTheme);
  SaveThemePreference;
end;

procedure TDockHubTestsRunnerForm.BuildToolbar;
begin
  FToolbar := CreateToolbar;
  BuildToolbarTitle(FToolbar);
  BuildToolbarThemeSelector(FToolbar);
  BuildToolbarRunButtons(FToolbar);
  BuildToolbarStatus(FToolbar);

  FRunAllButton.Align := TAlignLayout.Left;
  FRunSelectedButton.Align := TAlignLayout.Left;

  FRunAllButton.Align := TAlignLayout.Right;
  FRunSelectedButton.Align := TAlignLayout.Right;
end;

function TDockHubTestsRunnerForm.CreateToolbar: TRectangle;
begin
  Result := TRectangle.Create(Self);
  Result.Parent := Self;
  Result.Align := TAlignLayout.Top;
  Result.Height := 56;
  Result.Fill.Kind := TBrushKind.Solid;
  Result.Fill.Color := FPalette.Surface;
  Result.Stroke.Kind := TBrushKind.Solid;
  Result.Stroke.Color := FPalette.Border;
end;

procedure TDockHubTestsRunnerForm.BuildToolbarTitle(
  const AParent: TFmxObject);
begin
  FToolbarTitle := TText.Create(AParent);
  FToolbarTitle.Parent := AParent;
  FToolbarTitle.Align := TAlignLayout.Left;
  FToolbarTitle.Width := 210;
  FToolbarTitle.Margins.Left := 16;
  FToolbarTitle.HitTest := False;
  FToolbarTitle.HorzTextAlign := TTextAlign.Leading;
  FToolbarTitle.VertTextAlign := TTextAlign.Center;
  FToolbarTitle.TextSettings.Font.Size := 18;
  FToolbarTitle.TextSettings.Font.Style := [TFontStyle.fsBold];
  FToolbarTitle.TextSettings.FontColor := FPalette.TextPrimary;
  FToolbarTitle.Text := 'DockHub Tests';
end;

procedure TDockHubTestsRunnerForm.BuildToolbarThemeSelector(
  const AParent: TFmxObject);
begin
  FThemeSelector := TComboBox.Create(AParent);
  FThemeSelector.Parent := AParent;
  FThemeSelector.Align := TAlignLayout.Right;
  FThemeSelector.Width := 112;
  FThemeSelector.Margins.Top := 15;
  FThemeSelector.Margins.Right := 20;
  FThemeSelector.Margins.Bottom := 15;
  FThemeSelector.Margins.Left := 10;
  FThemeSelector.Items.Add('Escuro');
  FThemeSelector.Items.Add('Claro');
  FThemeSelector.ItemIndex := Ord(FCurrentTheme);
  FThemeSelector.OnChange := HandleThemeChange;
  BuildToolbarThemeLabel(AParent);
end;

procedure TDockHubTestsRunnerForm.BuildToolbarThemeLabel(
  const AParent: TFmxObject);
begin
  FThemeLabel := TText.Create(AParent);
  FThemeLabel.Parent := AParent;
  FThemeLabel.Align := TAlignLayout.Right;
  FThemeLabel.Width := 48;
  FThemeLabel.HitTest := False;
  FThemeLabel.HorzTextAlign := TTextAlign.Trailing;
  FThemeLabel.VertTextAlign := TTextAlign.Center;
  FThemeLabel.TextSettings.Font.Size := 11;
  FThemeLabel.Text := 'Tema:';
end;

procedure TDockHubTestsRunnerForm.BuildToolbarRunButtons(
  const AParent: TFmxObject);
begin
  FRunAllButton := CreateToolbarRunButton(
    AParent,
    'Executar todos',
    HandleRunAllClick);
  FRunSelectedButton := CreateToolbarRunButton(
    AParent,
    'Executar selecionados',
    HandleRunSelectedClick);
  FRunSelectedButton.Width := 175;
end;

function TDockHubTestsRunnerForm.CreateToolbarRunButton(
  const AParent: TFmxObject;
  const ACaption: string;
  const AHandler: TNotifyEvent): TButton;
begin
  Result := TButton.Create(AParent);
  Result.Parent := AParent;
  Result.Align := TAlignLayout.Right;
  Result.Width := 145;
  Result.Margins.Top := 10;
  Result.Margins.Right := 8;
  Result.Margins.Bottom := 10;
  Result.Text := ACaption;
  Result.OnClick := AHandler;
  Result.OnApplyStyleLookup := HandleStyledControlApplyStyleLookup;
end;

procedure TDockHubTestsRunnerForm.BuildToolbarStatus(
  const AParent: TFmxObject);
begin
  FStatusLabel := TText.Create(AParent);
  FStatusLabel.Parent := AParent;
  FStatusLabel.Align := TAlignLayout.Client;
  FStatusLabel.Margins.Left := 12;
  FStatusLabel.Margins.Right := 12;
  FStatusLabel.HitTest := False;
  FStatusLabel.HorzTextAlign := TTextAlign.Leading;
  FStatusLabel.VertTextAlign := TTextAlign.Center;
  FStatusLabel.TextSettings.Font.Size := 12;
end;

function TDockHubTestsRunnerForm.CreateSummaryWrapper: TLayout;
begin
  Result := TLayout.Create(Self);
  Result.Parent := Self;
  Result.Align := TAlignLayout.Top;
  Result.Height := 92;
  Result.Margins.Bottom := 8;
end;

function TDockHubTestsRunnerForm.CreateSummaryGrid(
  const AParent: TFmxObject): TGridPanelLayout;
begin
  Result := TGridPanelLayout.Create(Self);
  Result.Parent := AParent;
  Result.Align := TAlignLayout.Client;
  Result.Padding.Left := 8;
  Result.Padding.Top := 8;
  Result.Padding.Right := 8;
  Result.Padding.Bottom := 8;
end;

procedure TDockHubTestsRunnerForm.ConfigureSummaryGridRows(
  const AGrid: TGridPanelLayout);
var
  LRow: TGridPanelLayout.TRowItem;
begin
  AGrid.RowCollection.BeginUpdate;
  try
    AGrid.RowCollection.Clear;
    LRow := AGrid.RowCollection.Add;
    LRow.SizeStyle := TGridPanelLayout.TSizeStyle.Percent;
    LRow.Value := 100;
  finally
    AGrid.RowCollection.EndUpdate;
  end;
end;

procedure TDockHubTestsRunnerForm.ConfigureSummaryGridColumns(
  const AGrid: TGridPanelLayout);
var
  LKind: TResultSummaryKind;
  LColumn: TGridPanelLayout.TColumnItem;
  LColumnWidth: Single;
begin
  LColumnWidth := 100 / (Ord(High(TResultSummaryKind)) - Ord(Low(TResultSummaryKind)) + 1);

  AGrid.ColumnCollection.BeginUpdate;
  try
    AGrid.ColumnCollection.Clear;
    for LKind := Low(TResultSummaryKind) to High(TResultSummaryKind) do
    begin
      LColumn := AGrid.ColumnCollection.Add;
      LColumn.SizeStyle := TGridPanelLayout.TSizeStyle.Percent;
      LColumn.Value := LColumnWidth;
    end;
  finally
    AGrid.ColumnCollection.EndUpdate;
  end;
end;

procedure TDockHubTestsRunnerForm.BuildSummary;
var
  LWrapper: TLayout;
  LGrid: TGridPanelLayout;
  LKind: TResultSummaryKind;
begin
  LWrapper := CreateSummaryWrapper;
  LGrid := CreateSummaryGrid(LWrapper);
  ConfigureSummaryGridRows(LGrid);
  ConfigureSummaryGridColumns(LGrid);
  FSummaryGrid := LGrid;

  for LKind := Low(TResultSummaryKind) to High(TResultSummaryKind) do
    FSummaryValues[LKind] := CreateSummaryCard(LGrid, LKind);
end;

function TDockHubTestsRunnerForm.CreateSummaryCard(
  const AParent: TFmxObject;
  const AKind: TResultSummaryKind): TText;
begin
  FSummaryCards[AKind] := CreateSummaryCardContainer(AParent);
  FSummaryAccents[AKind] := BuildSummaryCardAccent(
    FSummaryCards[AKind],
    FPalette.SummaryColors[AKind]);
  FSummaryCaptions[AKind] := BuildSummaryCardCaption(
    FSummaryCards[AKind],
    _SUMMARY_CAPTIONS[AKind]);
  Result := BuildSummaryCardValue(
    FSummaryCards[AKind],
    FPalette.SummaryColors[AKind]);
end;

function TDockHubTestsRunnerForm.CreateSummaryCardContainer(
  const AParent: TFmxObject): TRectangle;
begin
  Result := TRectangle.Create(Self);
  Result.Parent := AParent;
  Result.Align := TAlignLayout.Client;
  Result.Margins.Left := 6;
  Result.Margins.Right := 6;
  Result.Margins.Top := 4;
  Result.Margins.Bottom := 4;
  Result.Fill.Kind := TBrushKind.Solid;
  Result.Fill.Color := FPalette.Surface;
  Result.Stroke.Kind := TBrushKind.Solid;
  Result.Stroke.Color := FPalette.Border;
  Result.XRadius := 6;
  Result.YRadius := 6;
end;

function TDockHubTestsRunnerForm.BuildSummaryCardAccent(
  const AParent: TFmxObject;
  const AColor: TAlphaColor): TRectangle;
begin
  Result := TRectangle.Create(AParent);
  Result.Parent := AParent;
  Result.Align := TAlignLayout.Top;
  Result.Height := 4;
  Result.HitTest := False;
  Result.Fill.Kind := TBrushKind.Solid;
  Result.Fill.Color := AColor;
  Result.Stroke.Kind := TBrushKind.None;
end;

function TDockHubTestsRunnerForm.BuildSummaryCardCaption(
  const AParent: TFmxObject;
  const ACaption: string): TText;
begin
  Result := TText.Create(AParent);
  Result.Parent := AParent;
  Result.Align := TAlignLayout.Top;
  Result.Height := 24;
  Result.Margins.Left := 12;
  Result.Margins.Top := 6;
  Result.HitTest := False;
  Result.HorzTextAlign := TTextAlign.Leading;
  Result.VertTextAlign := TTextAlign.Center;
  Result.TextSettings.Font.Size := 10;
  Result.TextSettings.FontColor := FPalette.TextSecondary;
  Result.Text := ACaption;
end;

function TDockHubTestsRunnerForm.BuildSummaryCardValue(
  const AParent: TFmxObject;
  const AColor: TAlphaColor): TText;
begin
  Result := TText.Create(AParent);
  Result.Parent := AParent;
  Result.Align := TAlignLayout.Client;
  Result.Margins.Left := 12;
  Result.Margins.Right := 8;
  Result.Margins.Bottom := 6;
  Result.HitTest := False;
  Result.HorzTextAlign := TTextAlign.Leading;
  Result.VertTextAlign := TTextAlign.Center;
  Result.TextSettings.Font.Size := 20;
  Result.TextSettings.Font.Style := [TFontStyle.fsBold];
  Result.TextSettings.FontColor := AColor;
end;

procedure TDockHubTestsRunnerForm.BuildFilters;
var
  LFlow: TFlowLayout;
begin
  LFlow := TFlowLayout.Create(Self);
  LFlow.Parent := Self;
  LFlow.Align := TAlignLayout.Top;
  LFlow.Height := 44;
  LFlow.Padding.Left := 8;
  LFlow.Padding.Top := 4;
  LFlow.Padding.Right := 8;
  LFlow.Padding.Bottom := 4;
  BuildFilterCaption(LFlow);
  BuildFilterButtons(LFlow);
end;

procedure TDockHubTestsRunnerForm.BuildFilterCaption(
  const AParent: TFmxObject);
begin
  FFilterCaption := TText.Create(AParent);
  FFilterCaption.Parent := AParent;
  FFilterCaption.Width := 62;
  FFilterCaption.Height := 34;
  FFilterCaption.HitTest := False;
  FFilterCaption.HorzTextAlign := TTextAlign.Leading;
  FFilterCaption.VertTextAlign := TTextAlign.Center;
  FFilterCaption.TextSettings.Font.Size := 11;
  FFilterCaption.TextSettings.FontColor := FPalette.TextSecondary;
  FFilterCaption.Text := 'Exibir:';
end;

procedure TDockHubTestsRunnerForm.BuildFilterButtons(
  const AParent: TFmxObject);
var
  LFilter: TResultFilter;
begin
  for LFilter := Low(TResultFilter) to High(TResultFilter) do
    FFilterButtons[LFilter] := CreateFilterButton(AParent, LFilter);
end;

function TDockHubTestsRunnerForm.CreateFilterButton(
  const AParent: TFmxObject;
  const AFilter: TResultFilter): TButton;
begin
  Result := TButton.Create(AParent);
  Result.Parent := AParent;
  Result.Width := 104;
  Result.Height := 34;
  Result.Margins.Right := 6;
  Result.Tag := Ord(AFilter);
  Result.OnClick := HandleFilterClick;
  Result.OnApplyStyleLookup := HandleStyledControlApplyStyleLookup;
end;

procedure TDockHubTestsRunnerForm.BuildDetails;
begin
  FDetailsPanel := CreateDetailsPanel;
  BuildDetailsTitle(FDetailsPanel);
  BuildDetailsMemo(FDetailsPanel);
end;

function TDockHubTestsRunnerForm.CreateDetailsPanel: TRectangle;
begin
  Result := TRectangle.Create(Self);
  Result.Parent := Self;
  Result.Align := TAlignLayout.Bottom;
  Result.Height := 190;
  Result.Margins.Left := 8;
  Result.Margins.Right := 8;
  Result.Margins.Bottom := 8;
  Result.Fill.Kind := TBrushKind.Solid;
  Result.Fill.Color := FPalette.Surface;
  Result.Stroke.Kind := TBrushKind.Solid;
  Result.Stroke.Color := FPalette.Border;
  Result.XRadius := 6;
  Result.YRadius := 6;
end;

procedure TDockHubTestsRunnerForm.BuildDetailsTitle(
  const AParent: TFmxObject);
begin
  FDetailsTitle := TText.Create(AParent);
  FDetailsTitle.Parent := AParent;
  FDetailsTitle.Align := TAlignLayout.Top;
  FDetailsTitle.Height := 34;
  FDetailsTitle.Margins.Left := 12;
  FDetailsTitle.Margins.Right := 12;
  FDetailsTitle.HitTest := False;
  FDetailsTitle.HorzTextAlign := TTextAlign.Leading;
  FDetailsTitle.VertTextAlign := TTextAlign.Center;
  FDetailsTitle.TextSettings.Font.Size := 12;
  FDetailsTitle.TextSettings.Font.Style := [TFontStyle.fsBold];
end;

procedure TDockHubTestsRunnerForm.BuildDetailsMemo(
  const AParent: TFmxObject);
begin
  FDetailsMemo := TMemo.Create(AParent);
  FDetailsMemo.Parent := AParent;
  FDetailsMemo.Align := TAlignLayout.Client;
  FDetailsMemo.Margins.Left := 8;
  FDetailsMemo.Margins.Right := 8;
  FDetailsMemo.Margins.Bottom := 8;
  FDetailsMemo.ReadOnly := True;
  FDetailsMemo.WordWrap := True;
  FDetailsMemo.OnApplyStyleLookup := HandleStyledControlApplyStyleLookup;
end;

procedure TDockHubTestsRunnerForm.BuildWorkspace;
var
  LWorkspace: TLayout;
begin
  LWorkspace := TLayout.Create(Self);
  LWorkspace.Parent := Self;
  LWorkspace.Align := TAlignLayout.Client;
  BuildSelectionPanel(LWorkspace);
  BuildResults(LWorkspace);
end;

procedure TDockHubTestsRunnerForm.BuildSelectionPanel(
  const AParent: TFmxObject);
begin
  FSelectionPanel := CreateSelectionPanel(AParent);
  BuildSelectionHeader(FSelectionPanel);
  BuildSelectionSearch(FSelectionPanel);
  BuildSelectionActions(FSelectionPanel);
  BuildSelectionTree(FSelectionPanel);
end;

function TDockHubTestsRunnerForm.CreateSelectionPanel(
  const AParent: TFmxObject): TRectangle;
begin
  Result := TRectangle.Create(AParent);
  Result.Parent := AParent;
  Result.Align := TAlignLayout.Left;
  Result.Width := 370;
  Result.Margins.Left := 8;
  Result.Margins.Right := 8;
  Result.Margins.Bottom := 8;
  Result.Fill.Kind := TBrushKind.Solid;
  Result.Fill.Color := FPalette.Surface;
  Result.Stroke.Kind := TBrushKind.Solid;
  Result.Stroke.Color := FPalette.Border;
  Result.XRadius := 6;
  Result.YRadius := 6;
end;

procedure TDockHubTestsRunnerForm.BuildSelectionHeader(
  const AParent: TFmxObject);
begin
  BuildSelectionTitle(AParent);
  BuildSelectionCount(AParent);
end;

procedure TDockHubTestsRunnerForm.BuildSelectionTitle(
  const AParent: TFmxObject);
begin
  FSelectionTitle := TText.Create(AParent);
  FSelectionTitle.Parent := AParent;
  FSelectionTitle.Align := TAlignLayout.Top;
  FSelectionTitle.Height := 30;
  FSelectionTitle.Margins.Left := 10;
  FSelectionTitle.Margins.Top := 5;
  FSelectionTitle.HitTest := False;
  FSelectionTitle.HorzTextAlign := TTextAlign.Leading;
  FSelectionTitle.VertTextAlign := TTextAlign.Center;
  FSelectionTitle.TextSettings.Font.Size := 12;
  FSelectionTitle.TextSettings.Font.Style := [TFontStyle.fsBold];
  FSelectionTitle.TextSettings.FontColor := FPalette.TextPrimary;
  FSelectionTitle.Text := 'Seleção de testes';
end;

procedure TDockHubTestsRunnerForm.BuildSelectionCount(
  const AParent: TFmxObject);
begin
  FSelectionCount := TText.Create(AParent);
  FSelectionCount.Parent := AParent;
  FSelectionCount.Align := TAlignLayout.Top;
  FSelectionCount.Height := 24;
  FSelectionCount.Margins.Left := 10;
  FSelectionCount.HitTest := False;
  FSelectionCount.HorzTextAlign := TTextAlign.Leading;
  FSelectionCount.VertTextAlign := TTextAlign.Center;
  FSelectionCount.TextSettings.Font.Size := 10;
  FSelectionCount.TextSettings.FontColor := FPalette.TextSecondary;
end;

procedure TDockHubTestsRunnerForm.BuildSelectionSearch(
  const AParent: TFmxObject);
begin
  FSelectionSearch := TEdit.Create(AParent);
  FSelectionSearch.Parent := AParent;
  FSelectionSearch.Align := TAlignLayout.Top;
  FSelectionSearch.Height := 34;
  FSelectionSearch.Margins.Left := 8;
  FSelectionSearch.Margins.Right := 8;
  FSelectionSearch.Margins.Bottom := 6;
  FSelectionSearch.TextPrompt := 'Pesquisar fixture ou teste...';
  FSelectionSearch.OnChange := HandleSearchChange;
  FSelectionSearch.OnApplyStyleLookup := HandleStyledControlApplyStyleLookup;
end;

procedure TDockHubTestsRunnerForm.BuildSelectionActions(
  const AParent: TFmxObject);
var
  LFlow: TFlowLayout;
begin
  LFlow := TFlowLayout.Create(AParent);
  LFlow.Parent := AParent;
  LFlow.Align := TAlignLayout.Top;
  LFlow.Height := 38;
  LFlow.Padding.Left := 8;
  LFlow.Padding.Right := 8;

  FSelectAllButton := CreateSelectionActionButton(
    LFlow,
    'Todos',
    94,
    HandleSelectAllClick);
  FSelectNoneButton := CreateSelectionActionButton(
    LFlow,
    'Nenhum',
    94,
    HandleSelectNoneClick);
  FInvertSelectionButton := CreateSelectionActionButton(
    LFlow,
    'Inverter',
    104,
    HandleInvertSelectionClick);
end;

function TDockHubTestsRunnerForm.CreateSelectionActionButton(
  const AParent: TFmxObject;
  const ACaption: string;
  const AWidth: Single;
  const AHandler: TNotifyEvent): TButton;
begin
  Result := TButton.Create(AParent);
  Result.Parent := AParent;
  Result.Width := AWidth;
  Result.Height := 30;
  Result.Margins.Right := 6;
  Result.Text := ACaption;
  Result.OnClick := AHandler;
  Result.OnApplyStyleLookup := HandleStyledControlApplyStyleLookup;
end;

procedure TDockHubTestsRunnerForm.BuildSelectionTree(
  const AParent: TFmxObject);
begin
  FSelectionTree := TTreeView.Create(AParent);
  FSelectionTree.Parent := AParent;
  FSelectionTree.Align := TAlignLayout.Client;
  FSelectionTree.Margins.Left := 6;
  FSelectionTree.Margins.Right := 6;
  FSelectionTree.Margins.Bottom := 6;
  FSelectionTree.ShowCheckboxes := True;
  FSelectionTree.OnChangeCheck := HandleSelectionCheck;
  FSelectionTree.OnApplyStyleLookup := HandleStyledControlApplyStyleLookup;
end;

procedure TDockHubTestsRunnerForm.BuildResults(const AParent: TFmxObject);
begin
  FResultPanel := TRectangle.Create(AParent);
  FResultPanel.Parent := AParent;
  FResultPanel.Align := TAlignLayout.Client;
  FResultPanel.Margins.Right := 8;
  FResultPanel.Margins.Bottom := 8;
  FResultPanel.Fill.Kind := TBrushKind.Solid;
  FResultPanel.Stroke.Kind := TBrushKind.Solid;
  FResultPanel.XRadius := 6;
  FResultPanel.YRadius := 6;

  FResultList := TListBox.Create(FResultPanel);
  FResultList.Parent := FResultPanel;
  FResultList.Align := TAlignLayout.Client;
  FResultList.Margins.Left := 4;
  FResultList.Margins.Top := 4;
  FResultList.Margins.Right := 4;
  FResultList.Margins.Bottom := 4;
  FResultList.OnChange := HandleResultSelection;
  FResultList.OnApplyStyleLookup := HandleStyledControlApplyStyleLookup;
end;

procedure TDockHubTestsRunnerForm.LoadTestCatalog;
var
  LRunner: ITestRunner;
begin
  LRunner := CreateTestRunner;
  FSelectionFixtures := LRunner.BuildFixtures as ITestFixtureList;
  RebuildSelectionTree;
  UpdateSelectionCount;
end;

procedure TDockHubTestsRunnerForm.RebuildSelectionTree;
var
  LFixture: ITestFixture;
  LSearchText: string;
begin
  if FSelectionFixtures = nil then
    Exit;

  LSearchText := Trim(FSelectionSearch.Text);
  FUpdatingSelection := True;
  try
    FSelectionTree.Clear;
    for LFixture in FSelectionFixtures do
      AddFixtureSelectionNode(LFixture, nil, LSearchText);
    FSelectionTree.ExpandAll;
    UpdateSelectionTreeState;
    ApplyThemeToTreeItems;
  finally
    FUpdatingSelection := False;
  end;
end;

procedure TDockHubTestsRunnerForm.AddFixtureSelectionNode(
  const AFixture: ITestFixture;
  const AParent: TTreeViewItem;
  const ASearchText: string);
var
  LNode: TTestSelectionTreeItem;
  LShowAll: Boolean;
begin
  if not FixtureMatchesSearch(AFixture, ASearchText) then
    Exit;

  LNode := TTestSelectionTreeItem.CreateFixture(FSelectionTree, AFixture);
  if AParent = nil then
    LNode.Parent := FSelectionTree
  else
    LNode.Parent := AParent;

  LShowAll := (ASearchText.Trim.IsEmpty) or ContainsText(AFixture.FullName, ASearchText);
  AddFixtureTests(AFixture, LNode, ASearchText, LShowAll);
  AddChildFixtures(AFixture, LNode, ASearchText, LShowAll);
end;

procedure TDockHubTestsRunnerForm.AddFixtureTests(
  const AFixture: ITestFixture;
  const AParent: TTreeViewItem;
  const ASearchText: string;
  const AShowAll: Boolean);
var
  LTest: ITest;
  LNode: TTestSelectionTreeItem;
begin
  for LTest in AFixture.Tests do
  begin
    if not AShowAll and not TestMatchesSearch(LTest, ASearchText) then
      Continue;

    LNode := TTestSelectionTreeItem.CreateTest(FSelectionTree, LTest);
    LNode.Parent := AParent;
    LNode.OnDblClick := HandleSelectionDoubleClick;
  end;
end;

procedure TDockHubTestsRunnerForm.AddChildFixtures(
  const AFixture: ITestFixture;
  const AParent: TTreeViewItem;
  const ASearchText: string;
  const AShowAll: Boolean);
var
  LChild: ITestFixture;
  LSearch: string;
begin
  if not AFixture.HasChildFixtures then
    Exit;

  if AShowAll then
    LSearch := EmptyStr
  else
    LSearch := ASearchText;

  for LChild in AFixture.Children do
    AddFixtureSelectionNode(LChild, AParent, LSearch);
end;

function TDockHubTestsRunnerForm.FixtureNameMatchesSearch(
  const AFixture: ITestFixture;
  const ASearchText: string): Boolean;
begin
  Result := ContainsText(AFixture.FullName, ASearchText);
end;

function TDockHubTestsRunnerForm.FixtureHasTestMatchingSearch(
  const AFixture: ITestFixture;
  const ASearchText: string): Boolean;
var
  LTest: ITest;
begin
  for LTest in AFixture.Tests do
    if TestMatchesSearch(LTest, ASearchText) then
      Exit(True);

  Result := False;
end;

function TDockHubTestsRunnerForm.FixtureHasChildMatchingSearch(
  const AFixture: ITestFixture;
  const ASearchText: string): Boolean;
var
  LChild: ITestFixture;
begin
  for LChild in AFixture.Children do
    if FixtureMatchesSearch(LChild, ASearchText) then
      Exit(True);

  Result := False;
end;

function TDockHubTestsRunnerForm.FixtureMatchesSearch(
  const AFixture: ITestFixture;
  const ASearchText: string): Boolean;
begin
  if ASearchText.Trim.IsEmpty then
    Exit(True);

  Result :=
    FixtureNameMatchesSearch(AFixture, ASearchText) or
    FixtureHasTestMatchingSearch(AFixture, ASearchText) or
    FixtureHasChildMatchingSearch(AFixture, ASearchText);
end;

function TDockHubTestsRunnerForm.TestMatchesSearch(
  const ATest: ITest;
  const ASearchText: string): Boolean;
begin
  Result := (ASearchText.Trim.IsEmpty) or ContainsText(ATest.FullName, ASearchText);
end;

procedure TDockHubTestsRunnerForm.HandleRunAllClick(Sender: TObject);
begin
  ExecuteAllTests;
end;

procedure TDockHubTestsRunnerForm.HandleRunSelectedClick(Sender: TObject);
begin
  ExecuteSelectedTests;
end;

procedure TDockHubTestsRunnerForm.HandleFilterClick(Sender: TObject);
begin
  FActiveFilter := TResultFilter(TButton(Sender).Tag);
  UpdateFilterButtons;
  RebuildResultList;
end;

procedure TDockHubTestsRunnerForm.HandleResultSelection(Sender: TObject);
var
  LItem: TListBoxItem;
begin
  LItem := FResultList.Selected;
  if LItem is TTestResultListItem then
    ShowResultDetails(TTestResultListItem(LItem).TestResult)
  else
    ClearDetails;
end;

procedure TDockHubTestsRunnerForm.HandleSearchChange(Sender: TObject);
begin
  if not FRunning then
    RebuildSelectionTree;
end;

procedure TDockHubTestsRunnerForm.HandleSelectionCheck(Sender: TObject);
var
  LItem: TTestSelectionTreeItem;
begin
  if FUpdatingSelection or not (Sender is TTestSelectionTreeItem) then
    Exit;

  LItem := TTestSelectionTreeItem(Sender);
  if LItem.IsFixture then
    SetFixtureTests(LItem.Fixture, LItem.IsChecked)
  else if LItem.IsTest then
    LItem.Test.Enabled := LItem.IsChecked;

  UpdateCatalogFixtureStates;
  UpdateSelectionTreeState;
  UpdateSelectionCount;
end;

procedure TDockHubTestsRunnerForm.HandleSelectAllClick(Sender: TObject);
begin
  SetAllCatalogTests(True);
  UpdateCatalogFixtureStates;
  UpdateSelectionTreeState;
  UpdateSelectionCount;
end;

procedure TDockHubTestsRunnerForm.HandleSelectNoneClick(Sender: TObject);
begin
  SetAllCatalogTests(False);
  UpdateCatalogFixtureStates;
  UpdateSelectionTreeState;
  UpdateSelectionCount;
end;

procedure TDockHubTestsRunnerForm.HandleInvertSelectionClick(Sender: TObject);
begin
  InvertCatalogTests;
  UpdateCatalogFixtureStates;
  UpdateSelectionTreeState;
  UpdateSelectionCount;
end;

procedure TDockHubTestsRunnerForm.HandleSelectionDoubleClick(Sender: TObject);
var
  LItem: TTestSelectionTreeItem;
begin
  if FRunning or not (Sender is TTestSelectionTreeItem) then
    Exit;

  LItem := TTestSelectionTreeItem(Sender);
  if LItem.IsTest then
    ExecuteSingleTest(LItem.Test.FullName);
end;

procedure TDockHubTestsRunnerForm.SetRunning(const AValue: Boolean);
var
  LFilter: TResultFilter;
begin
  FRunning := AValue;
  FRunAllButton.Enabled := not AValue;
  FRunSelectedButton.Enabled := not AValue;
  FThemeSelector.Enabled := not AValue;
  FSelectionSearch.Enabled := not AValue;
  FSelectionTree.Enabled := not AValue;
  FSelectAllButton.Enabled := not AValue;
  FSelectNoneButton.Enabled := not AValue;
  FInvertSelectionButton.Enabled := not AValue;

  for LFilter := Low(TResultFilter) to High(TResultFilter) do
    FFilterButtons[LFilter].Enabled := not AValue;

  if AValue then
    SetStatus('Executando...', TRunnerStatusTone.rstAccent);
end;

procedure TDockHubTestsRunnerForm.SetStatus(
  const AText: string;
  const ATone: TRunnerStatusTone);
begin
  FStatusTone := ATone;
  FStatusLabel.Text := AText;
  FStatusLabel.TextSettings.FontColor := StatusColor(ATone);
end;

function TDockHubTestsRunnerForm.StatusColor(
  const ATone: TRunnerStatusTone): TAlphaColor;
begin
  case ATone of
    TRunnerStatusTone.rstAccent:
      Result := FPalette.Accent;
    TRunnerStatusTone.rstPass:
      Result := FPalette.ResultColors[TTestResultType.Pass];
    TRunnerStatusTone.rstFailure:
      Result := FPalette.ResultColors[TTestResultType.Failure];
    TRunnerStatusTone.rstError:
      Result := FPalette.ResultColors[TTestResultType.Error];
    TRunnerStatusTone.rstWarning:
      Result := FPalette.ResultColors[TTestResultType.Warning];
  else
    Result := FPalette.TextSecondary;
  end;
end;

procedure TDockHubTestsRunnerForm.ResetOutput;
begin
  FResults := nil;
  FResultList.Clear;
  ResetSummary;
  ClearDetails;
  UpdateFilterButtons;
  SetStatus('Pronto', TRunnerStatusTone.rstNeutral);
  System.ExitCode := EXIT_OK;
end;

procedure TDockHubTestsRunnerForm.ResetSummary;
var
  LKind: TResultSummaryKind;
begin
  for LKind := Low(TResultSummaryKind) to High(TResultSummaryKind) do
    FSummaryValues[LKind].Text := '-';
end;

procedure TDockHubTestsRunnerForm.ClearDetails;
begin
  FDetailsTitle.Text := 'Detalhes';
  FDetailsTitle.TextSettings.FontColor := FPalette.TextSecondary;
  FDetailsMemo.Lines.Text := 'Selecione um teste executado para visualizar os detalhes.';
end;

procedure TDockHubTestsRunnerForm.SetAllCatalogTests(const AEnabled: Boolean);
var
  LFixture: ITestFixture;
begin
  for LFixture in FSelectionFixtures do
    SetFixtureTests(LFixture, AEnabled);
end;

procedure TDockHubTestsRunnerForm.SetFixtureTests(
  const AFixture: ITestFixture;
  const AEnabled: Boolean);
var
  LTest: ITest;
  LChild: ITestFixture;
begin
  AFixture.Enabled := AEnabled;
  for LTest in AFixture.Tests do
    LTest.Enabled := AEnabled;

  for LChild in AFixture.Children do
    SetFixtureTests(LChild, AEnabled);
end;

procedure TDockHubTestsRunnerForm.InvertCatalogTests;
var
  LFixture: ITestFixture;
begin
  for LFixture in FSelectionFixtures do
    InvertFixtureTests(LFixture);
end;

procedure TDockHubTestsRunnerForm.InvertFixtureTests(
  const AFixture: ITestFixture);
var
  LTest: ITest;
  LChild: ITestFixture;
begin
  for LTest in AFixture.Tests do
    LTest.Enabled := not LTest.Enabled;

  for LChild in AFixture.Children do
    InvertFixtureTests(LChild);
end;

procedure TDockHubTestsRunnerForm.UpdateCatalogFixtureStates;
var
  LFixture: ITestFixture;
begin
  for LFixture in FSelectionFixtures do
    UpdateFixtureEnabledState(LFixture);
end;

function TDockHubTestsRunnerForm.UpdateFixtureEnabledState(
  const AFixture: ITestFixture): Boolean;
var
  LTest: ITest;
  LChild: ITestFixture;
begin
  Result := False;

  for LTest in AFixture.Tests do
    Result := Result or LTest.Enabled;

  for LChild in AFixture.Children do
    Result := UpdateFixtureEnabledState(LChild) or Result;

  AFixture.Enabled := Result;
end;

procedure TDockHubTestsRunnerForm.UpdateSelectionTreeState;
var
  LIndex: Integer;
  LItem: TTreeViewItem;
begin
  FUpdatingSelection := True;
  try
    for LIndex := 0 to FSelectionTree.GlobalCount - 1 do
    begin
      LItem := FSelectionTree.ItemByGlobalIndex(LIndex);
      if LItem is TTestSelectionTreeItem then
        UpdateSelectionTreeItem(TTestSelectionTreeItem(LItem));
    end;
  finally
    FUpdatingSelection := False;
  end;
end;

procedure TDockHubTestsRunnerForm.UpdateSelectionTreeItem(
  const AItem: TTestSelectionTreeItem);
begin
  if AItem.IsTest then
  begin
    AItem.IsChecked := AItem.Test.Enabled;
    Exit;
  end;

  UpdateFixtureTreeItem(AItem);
end;

procedure TDockHubTestsRunnerForm.UpdateFixtureTreeItem(
  const AItem: TTestSelectionTreeItem);
var
  LSelected: Integer;
  LTotal: Integer;
begin
  LSelected := CountFixtureTests(AItem.Fixture, True);
  LTotal := CountFixtureTests(AItem.Fixture, False);
  AItem.IsChecked := (LTotal > 0) and (LSelected = LTotal);
  AItem.Text := Format('%s (%d/%d)', [AItem.Fixture.Name, LSelected, LTotal]);
end;

procedure TDockHubTestsRunnerForm.UpdateSelectionCount;
var
  LSelected: Integer;
  LTotal: Integer;
  LFixture: ITestFixture;
begin
  LSelected := CountSelectedTests;
  LTotal := 0;

  for LFixture in FSelectionFixtures do
    Inc(LTotal, CountFixtureTests(LFixture, False));

  FSelectionCount.Text := Format('%d de %d selecionados', [LSelected, LTotal]);
  FRunSelectedButton.Enabled := (LSelected > 0) and not FRunning;
end;

function TDockHubTestsRunnerForm.CountSelectedTests: Integer;
var
  LFixture: ITestFixture;
begin
  Result := 0;
  for LFixture in FSelectionFixtures do
    Inc(Result, CountFixtureTests(LFixture, True));
end;

function TDockHubTestsRunnerForm.CountFixtureTests(
  const AFixture: ITestFixture;
  const ASelectedOnly: Boolean): Integer;
var
  LTest: ITest;
  LChild: ITestFixture;
begin
  Result := 0;

  for LTest in AFixture.Tests do
    if not ASelectedOnly or LTest.Enabled then
      Inc(Result);

  for LChild in AFixture.Children do
    Inc(Result, CountFixtureTests(LChild, ASelectedOnly));
end;

procedure TDockHubTestsRunnerForm.ExecuteAllTests;
begin
  ExecuteTests(nil);
end;

procedure TDockHubTestsRunnerForm.ExecuteSelectedTests;
var
  LNames: TStringList;
begin
  LNames := CaptureSelectedTestNames;
  try
    if LNames.Count = 0 then
    begin
      SetStatus('Nenhum teste selecionado', TRunnerStatusTone.rstWarning);
      Exit;
    end;

    ExecuteTests(LNames);
  finally
    LNames.Free;
  end;
end;

procedure TDockHubTestsRunnerForm.ExecuteSingleTest(
  const ATestFullName: string);
var
  LNames: TStringList;
begin
  LNames := TStringList.Create;
  try
    LNames.Add(ATestFullName);
    ExecuteTests(LNames);
  finally
    LNames.Free;
  end;
end;

procedure TDockHubTestsRunnerForm.ExecuteTests(const ATestNames: TStrings);
begin
  if FRunning then
    Exit;

  SetRunning(True);
  try
    RunSuite(ATestNames);
  finally
    SetRunning(False);
    UpdateSelectionCount;
  end;
end;

procedure TDockHubTestsRunnerForm.RunSuite(const ATestNames: TStrings);
var
  LRunner: ITestRunner;
  LFixtures: ITestFixtureList;
  LResults: IRunResults;
  LXmlLogger: ITestLogger;
begin
  try
    ResetOutput;
    SetStatus('Executando...', TRunnerStatusTone.rstAccent);
    Application.ProcessMessages;
    LRunner := CreateTestRunner;
    LXmlLogger := TDUnitXXMLNUnitFileLogger.Create(TDUnitX.Options.XMLOutputFile);
    LRunner.AddLogger(LXmlLogger);
    LFixtures := LRunner.BuildFixtures as ITestFixtureList;
    ApplyExecutionSelection(LFixtures, ATestNames);
    LResults := LRunner.Execute;
    ApplyExecutionResult(LResults);
  except
    on E: Exception do
      HandleExecutionException(E);
  end;
end;

function TDockHubTestsRunnerForm.CreateTestRunner: ITestRunner;
begin
  Result := TDUnitX.CreateRunner;
  Result.UseRTTI := True;
  Result.FailsOnNoAsserts := False;
end;

procedure TDockHubTestsRunnerForm.ApplyExecutionSelection(
  const AFixtures: ITestFixtureList;
  const ATestNames: TStrings);
var
  LFixture: ITestFixture;
begin
  if ATestNames = nil then
    Exit;

  for LFixture in AFixtures do
    ApplyFixtureExecutionSelection(LFixture, ATestNames);
end;

function TDockHubTestsRunnerForm.ApplyFixtureExecutionSelection(
  const AFixture: ITestFixture;
  const ATestNames: TStrings): Boolean;
var
  LTest: ITest;
  LChild: ITestFixture;
begin
  Result := False;

  for LTest in AFixture.Tests do
  begin
    LTest.Enabled := ATestNames.IndexOf(LTest.FullName) >= 0;
    Result := Result or LTest.Enabled;
  end;

  for LChild in AFixture.Children do
    Result := ApplyFixtureExecutionSelection(LChild, ATestNames) or Result;

  AFixture.Enabled := Result;
end;

function TDockHubTestsRunnerForm.CaptureSelectedTestNames: TStringList;
var
  LFixture: ITestFixture;
begin
  Result := TStringList.Create;
  Result.Sorted := True;
  Result.Duplicates := TDuplicates.dupIgnore;

  for LFixture in FSelectionFixtures do
    CaptureFixtureTestNames(LFixture, Result);
end;

procedure TDockHubTestsRunnerForm.CaptureFixtureTestNames(
  const AFixture: ITestFixture;
  const ATarget: TStrings);
var
  LTest: ITest;
  LChild: ITestFixture;
begin
  for LTest in AFixture.Tests do
    if LTest.Enabled then
      ATarget.Add(LTest.FullName);

  for LChild in AFixture.Children do
    CaptureFixtureTestNames(LChild, ATarget);
end;

procedure TDockHubTestsRunnerForm.ApplyExecutionResult(
  const AResults: IRunResults);
begin
  FResults := AResults;
  UpdateSummary(AResults);
  RebuildResultList;

  if not AResults.AllPassed then
    System.ExitCode := EXIT_ERRORS;
end;

procedure TDockHubTestsRunnerForm.HandleExecutionException(
  const AException: Exception);
begin
  System.ExitCode := EXIT_ERRORS;
  SetStatus('Erro durante a execução', TRunnerStatusTone.rstError);
  FDetailsTitle.Text := 'Erro no runner';
  FDetailsTitle.TextSettings.FontColor := FPalette.ResultColors[TTestResultType.Error];
  FDetailsMemo.Lines.Text := AException.ClassName + ': ' + AException.Message;
end;

procedure TDockHubTestsRunnerForm.UpdateSummary(const AResults: IRunResults);
begin
  FSummaryValues[TResultSummaryKind.skFound].Text := IntToStr(AResults.TestCount);
  FSummaryValues[TResultSummaryKind.skPassed].Text := IntToStr(AResults.PassCount);
  FSummaryValues[TResultSummaryKind.skIgnored].Text := IntToStr(AResults.IgnoredCount);
  FSummaryValues[TResultSummaryKind.skMemoryLeak].Text := IntToStr(AResults.MemoryLeakCount);
  FSummaryValues[TResultSummaryKind.skFailed].Text := IntToStr(AResults.FailureCount);
  FSummaryValues[TResultSummaryKind.skError].Text := IntToStr(AResults.ErrorCount);

  if AResults.AllPassed then
    SetStatus('Concluído - todos os testes aprovados', TRunnerStatusTone.rstPass)
  else
    SetStatus('Concluído - existem problemas na suíte', TRunnerStatusTone.rstFailure);
end;

procedure TDockHubTestsRunnerForm.RebuildResultList;
var
  LResult: ITestResult;
  LCurrentFixture: string;
begin
  FResultList.Clear;
  ClearDetails;

  if FResults = nil then
    Exit;

  LCurrentFixture := EmptyStr;
  for LResult in FResults.GetAllTestResults do
    AddFilteredResult(LResult, LCurrentFixture);
end;

procedure TDockHubTestsRunnerForm.AddFilteredResult(
  const AResult: ITestResult;
  var ACurrentFixture: string);
var
  LFixtureName: string;
begin
  if not MatchesFilter(AResult) then
    Exit;

  LFixtureName := AResult.Test.Fixture.FullName;
  if ACurrentFixture <> LFixtureName then
  begin
    AddFixtureHeader(LFixtureName);
    ACurrentFixture := LFixtureName;
  end;

  AddResultItem(AResult);
end;

procedure TDockHubTestsRunnerForm.AddFixtureHeader(const AFixtureName: string);
var
  LHeader: TListBoxGroupHeader;
begin
  LHeader := TListBoxGroupHeader.Create(FResultList);
  LHeader.Parent := FResultList;
  LHeader.Height := 30;
  LHeader.Text := AFixtureName;
  LHeader.OnApplyStyleLookup := HandleStyledControlApplyStyleLookup;
  LHeader.StyledSettings := LHeader.StyledSettings - [TStyledSetting.FontColor];
  LHeader.TextSettings.FontColor := FPalette.TextSecondary;
end;

procedure TDockHubTestsRunnerForm.AddResultItem(const AResult: ITestResult);
var
  LItem: TTestResultListItem;
begin
  LItem := TTestResultListItem.CreateResult(FResultList, AResult);
  LItem.Parent := FResultList;
  LItem.ApplyPalette(FPalette);
end;

procedure TDockHubTestsRunnerForm.UpdateFilterButtons;
var
  LFilter: TResultFilter;
begin
  for LFilter := Low(TResultFilter) to High(TResultFilter) do
  begin
    if LFilter = FActiveFilter then
      FFilterButtons[LFilter].Text := '> ' + _FILTER_CAPTIONS[LFilter]
    else
      FFilterButtons[LFilter].Text := _FILTER_CAPTIONS[LFilter];
  end;
end;

function TDockHubTestsRunnerForm.MatchesFilter(
  const AResult: ITestResult): Boolean;
begin
  case FActiveFilter of
    TResultFilter.rfAll:
      Result := True;
    TResultFilter.rfFailure:
      Result := AResult.ResultType = TTestResultType.Failure;
    TResultFilter.rfError:
      Result := AResult.ResultType = TTestResultType.Error;
    TResultFilter.rfMemoryLeak:
      Result := AResult.ResultType = TTestResultType.MemoryLeak;
    TResultFilter.rfIgnored:
      Result := AResult.ResultType = TTestResultType.Ignored;
  else
    Result := False;
  end;
end;

procedure TDockHubTestsRunnerForm.ShowResultDetails(const AResult: ITestResult);
begin
  FDetailsTitle.Text := 'Detalhes - ' + _RESULT_LABELS[AResult.ResultType];
  FDetailsTitle.TextSettings.FontColor := FPalette.ResultColors[AResult.ResultType];

  FDetailsMemo.Lines.BeginUpdate;
  try
    FDetailsMemo.Lines.Clear;
    FDetailsMemo.Lines.Add('Teste: ' + AResult.Test.FullName);
    FDetailsMemo.Lines.Add('Status: ' + _RESULT_LABELS[AResult.ResultType]);
    if NOT AResult.Message.Trim.IsEmpty then
      FDetailsMemo.Lines.Add('Mensagem: ' + AResult.Message);

    AddComparableDetails(AResult);
    AddStackTrace(AResult);
  finally
    FDetailsMemo.Lines.EndUpdate;
  end;
end;

procedure TDockHubTestsRunnerForm.AddComparableDetails(
  const AResult: ITestResult);
var
  LError: ITestError;
begin
  if not Supports(AResult, ITestError, LError) then
    Exit;

  if not LError.IsComparable then
    Exit;

  FDetailsMemo.Lines.Add('Esperado: ' + LError.Expected);
  FDetailsMemo.Lines.Add('Obtido: ' + LError.Actual);
end;

procedure TDockHubTestsRunnerForm.AddStackTrace(const AResult: ITestResult);
begin
  if AResult.StackTrace.Trim.IsEmpty then
    Exit;

  FDetailsMemo.Lines.Add(EmptyStr);
  FDetailsMemo.Lines.Add('Stack trace:');
  FDetailsMemo.Lines.Add(AResult.StackTrace);
end;

procedure RunDockHubTests;
begin
  TDUnitX.CheckCommandLine;
  Application.Initialize;
  Application.CreateForm(TDockHubTestsRunnerForm, DockHubTestsRunnerForm);
  Application.Run;
end;

end.

program DockHub.Tests;

{$STRONGLINKTYPES ON}

uses
  System.SysUtils,
  DUnitX.TestFramework,
  DockHub.Tests.Runner.FMX in 'Runner\DockHub.Tests.Runner.FMX.pas',
  DockHub.Tests.Core.Language.Types in 'Core\DockHub.Tests.Core.Language.Types.pas',
  DockHub.Tests.Core.Language in 'Core\DockHub.Tests.Core.Language.pas',
  DockHub.Tests.View.Theme in 'View\DockHub.Tests.View.Theme.pas',
  DockHub.Tests.View.Page.Composition.Base in 'View\DockHub.Tests.View.Page.Composition.Base.pas',
  DockHub.Tests.View.Page.Main.Composition in 'View\DockHub.Tests.View.Page.Main.Composition.pas';

{$R *.res}


begin
  DockHub.Tests.Runner.FMX.RunDockHubTests;
end.

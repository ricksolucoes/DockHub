program DockHub;

uses
  System.StartUpCopy,
  FMX.Forms,
  DockHub.View.Theme.Types in 'src\view\Theme\DockHub.View.Theme.Types.pas',
  DockHub.View.Theme.Contracts in 'src\view\Theme\Contracts\DockHub.View.Theme.Contracts.pas',
  DockHub.View.Theme.Impl in 'src\view\Theme\Impl\DockHub.View.Theme.Impl.pas',
  DockHub.View.Constants in 'src\view\Constants\DockHub.View.Constants.pas',
  DockHub.Core.Language.Types in 'src\core\language\DockHub.Core.Language.Types.pas',
  DockHub.Core.Language.Impl in 'src\core\language\Impl\DockHub.Core.Language.Impl.pas',
  DockHub.Core.Language.Keys.View.Main in 'src\core\language\keys\DockHub.Core.Language.Keys.View.Main.pas',
  DockHub.Core.Language.Contracts in 'src\core\language\contracts\DockHub.Core.Language.Contracts.pas',
  DockHub.Core.Language.Translations.PtBR in 'src\core\language\Translations\DockHub.Core.Language.Translations.PtBR.pas',
  DockHub.Core.Language.Translations.EnUS in 'src\core\language\Translations\DockHub.Core.Language.Translations.EnUS.pas',
  DockHub.View.Page.Main in 'src\view\Page\DockHub.View.Page.Main.pas' {PageMain},
  DockHub.View.Page.Impl.Main.Composition in 'src\view\Page\Impl\Main\DockHub.View.Page.Impl.Main.Composition.pas',
  DockHub.View.Page.Contracts in 'src\view\Page\Contracts\DockHub.View.Page.Contracts.pas',
  DockHub.View.Page.Composition.Impl.Base in 'src\view\Page\Impl\DockHub.View.Page.Composition.Impl.Base.pas',
  DockHub.View.Page.Types in 'src\view\Page\Types\DockHub.View.Page.Types.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TPageMain, PageMain);
  Application.Run;
end.

unit DockHub.View.Page.Contracts;

interface

uses
  FMX.Forms,

  DockHub.View.Theme.Contracts,
  DockHub.Core.Language.Contracts,

  System.Classes;

type
  IPageComposition = interface(IInterface)
    ['{DA83870C-E8B1-4CB1-960A-128F61ACB285}']

    function Form(const AForm: TForm): IPageComposition;
    function OnMinimize(const ANotifyEvent: TNotifyEvent): IPageComposition;
    function OnClose(const ANotifyEvent: TNotifyEvent): IPageComposition;

    function ApplyLanguage(
      const ALanguage: IDockHubLanguage): IPageComposition;
    function ApplyTheme(const ATheme: IDockHubTheme): IPageComposition;

    function Build: IPageComposition;
  end;

  { Specific Main contract intentionally retained as the extension point for
    the actions that belong to this page when those behaviors are defined. }
  IPageCompositionMain = interface(IPageComposition)
    ['{D0F92A34-4041-4018-9968-01702038FDE8}']
  end;

implementation

end.

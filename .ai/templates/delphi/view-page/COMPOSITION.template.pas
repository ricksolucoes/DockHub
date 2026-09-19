unit {{COMPOSITION_UNIT}};

interface

uses
  DockHub.Core.Language.Contracts,
  DockHub.View.Theme.Contracts,
  DockHub.View.Page.Contracts,
  DockHub.View.Page.Composition.Impl.Base;

type
  {{COMPOSITION_CLASS}} = class(TPageCompositionBase{{OPTIONAL_COMPOSITION_INTERFACE_SUFFIX}})
  {{COMPOSITION_PRIVATE_SECTION}}
  protected
    procedure DoBuild; override;
    procedure DoApplyTheme; override;
    procedure DoApplyLanguage(const ALanguage: IDockHubLanguage); override;
  public
    class function New: {{COMPOSITION_REFERENCE_TYPE}}; static;
  end;

implementation

{{COMPOSITION_IMPLEMENTATION_USES}}

class function {{COMPOSITION_CLASS}}.New: {{COMPOSITION_REFERENCE_TYPE}};
begin
  Result := {{COMPOSITION_CLASS}}.Create;
end;

procedure {{COMPOSITION_CLASS}}.DoBuild;
begin
  {{BUILD_BODY}}
end;

procedure {{COMPOSITION_CLASS}}.DoApplyLanguage(
  const ALanguage: IDockHubLanguage);
begin
  {{APPLY_LANGUAGE_BODY}}
end;

procedure {{COMPOSITION_CLASS}}.DoApplyTheme;
begin
  {{APPLY_THEME_BODY}}
end;

end.

unit {{IMPLEMENTATION_UNIT}};

interface

{{IMPLEMENTATION_INTERFACE_USES}}
type
  {{IMPLEMENTATION_NAME}} = class sealed(TInterfacedObject, {{CONTRACT_NAME}})
  
{{PRIVATE_SECTION}}
  protected
    constructor Create;

{{INTERFACE_METHOD_DECLARATIONS}}
  public
    class function New: {{CONTRACT_NAME}}; static;
  end;

implementation

{{IMPLEMENTATION_USES}}
constructor {{IMPLEMENTATION_NAME}}.Create;
begin
  inherited Create;

{{CONSTRUCTOR_BODY}}
end;

class function {{IMPLEMENTATION_NAME}}.New: {{CONTRACT_NAME}};
begin
  Result := {{IMPLEMENTATION_NAME}}.Create;
end;

{{INTERFACE_METHOD_IMPLEMENTATIONS}}
end.

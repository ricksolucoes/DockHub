unit {{CONTRACT_UNIT}};

interface

{{CONTRACT_INTERFACE_USES}}
type
  {{CONTRACT_NAME}} = interface(IInterface)
    ['{{INTERFACE_GUID}}']

{{CONTRACT_METHOD_DECLARATIONS}}
  end;

implementation

end.

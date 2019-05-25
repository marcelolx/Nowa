unit NowaSQLAdapterImpl;

interface

uses
  NowaSQLAdapter;

type
  TNowaSQLAdapter = class(TInterfacedObject, INowaSQLAdapter)
  public
    function Ref: INowaSQLAdapter;
  end;

implementation

{ TNowaSQLAdapter }

function TNowaSQLAdapter.Ref: INowaSQLAdapter;
begin
  Result := Self;
end;

end.

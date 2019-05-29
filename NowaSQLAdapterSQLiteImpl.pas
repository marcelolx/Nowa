unit NowaSQLAdapterSQLiteImpl;

interface

uses
  NowaSQLAdapter;

type
  TNowaSQLAdapterSQLite = class(TInterfacedObject, INowaSQLAdapter)
  public
    function Ref: INowaSQLAdapter;
    function NewKeyValue(const SequenceName: string): String;
  end;

implementation

{ TNowaSQLAdapterSQLite }

function TNowaSQLAdapterSQLite.NewKeyValue(const SequenceName: string): String;
begin
  Result := 'SELECT last_insert_rowid() + 1';
end;

function TNowaSQLAdapterSQLite.Ref: INowaSQLAdapter;
begin
  Result := Self;
end;

end.

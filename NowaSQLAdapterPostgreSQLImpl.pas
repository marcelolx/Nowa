unit NowaSQLAdapterPostgreSQLImpl;

interface

uses
  NowaSQLAdapter,
  System.SysUtils;

type
  TNowaSQLAdapterPostgreSQL = class(TInterfacedObject, INowaSQLAdapter)
  public
    function Ref: INowaSQLAdapter;
    function NewKeyValue(const SequenceName: string): String;
  end;

implementation

{ TNowaSQLAdapterSQLite }

function TNowaSQLAdapterPostgreSQL.NewKeyValue(const SequenceName: string): String;
begin
  Result := 'select nextval(' + QuotedStr(LowerCase(SequenceName)) + ')';
end;

function TNowaSQLAdapterPostgreSQL.Ref: INowaSQLAdapter;
begin
  Result := Self;
end;

end.


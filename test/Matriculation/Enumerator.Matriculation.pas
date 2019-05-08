unit Enumerator.Matriculation;

interface

uses
  Nowa.Enumerator;

type
  TEMatriculation = (temSequential, temPersonSequential, temDate, temUser);

  TEnumMatriculation = class(TEnumAbstract<TEMatriculation>, IEnum<TEMatriculation>)
  public
    function Column(const EnumeratedField: TEMatriculation): string; override;
    function Table: string; override;
    function TableAlias(const Alias: string = ''): string; override;
    function Sequence: string; override;
    function AllColumns: TArray<TEMatriculation>; override;
    function PrimaryKey: TArray<TEMatriculation>; override;
    function Ref: IEnum<TEMatriculation>; override;
  end;

implementation

uses
  System.SysUtils;

{ TEnumMatriculation }

function TEnumMatriculation.AllColumns: TArray<TEMatriculation>;
var
  Field: TEMatriculation;
begin
  SetLength(Result, 0);

  for Field := low(TEMatriculation) to high(TEMatriculation) do
  begin
    SetLength(Result, Succ(Length(Result)));
    Result[Pred(Length(Result))] := Field;
  end;
end;

function TEnumMatriculation.Column(const EnumeratedField: TEMatriculation): string;
begin
  Result := EmptyStr;

  case EnumeratedField of
    temSequential:
      Result := 'NR_SEQUENTIAL';

    temPersonSequential:
      Result := 'NR_PERSONSEQUENTIAL';

    temDate:
      Result := 'DT_DATA';

    temUser:
      Result := 'CD_USER';
  else
    raise Exception.Create('Enumerated field doesn''t have a column.');
  end;
end;

function TEnumMatriculation.PrimaryKey: TArray<TEMatriculation>;
begin
  Result := [temSequential];
end;

function TEnumMatriculation.Ref: IEnum<TEMatriculation>;
begin
  Result := Self;
end;

function TEnumMatriculation.Sequence: string;
begin
  Result := 'GEN_MATRICULATION';
end;

function TEnumMatriculation.Table: string;
begin
  Result := 'TB_MATRICULATION';
end;

function TEnumMatriculation.TableAlias(const Alias: string): string;
begin
  Result := Alias;

  if Result.IsEmpty then
    Result := 'MATRICULATION';
end;

end.

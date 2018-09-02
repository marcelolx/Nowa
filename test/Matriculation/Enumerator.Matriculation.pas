unit Enumerator.Matriculation;

interface

uses
  Enumerator;

type
  TEMatriculation = (temSequential, temPersonSequential, temDate, temUser);

  TEnumMatriculation = class(TEnumAbstract<TEMatriculation>, IEnum<TEMatriculation>)
  public
    function Column(const AEnumeratedField: TEMatriculation): String; override;
    function ColumnAlias(const AEnumeratedField: TEMatriculation): String; override;
    function Table: String; override;
    function TableAlias(const AAlias: String = ''): String; override;
    function AllColumns: TArray<TEMatriculation>; override;
    function Ref: IEnum<TEMatriculation>; override;
  end;

implementation

uses
  System.SysUtils;

{ TEnumMatriculation }

function TEnumMatriculation.AllColumns: TArray<TEMatriculation>;
var
  oEField: TEMatriculation;
begin
  SetLength(Result, 0);

  for oEField := Low(TEMatriculation) to High(TEMatriculation) do
  begin
    SetLength(Result, Succ(Length(Result)));
    Result[Pred(Length(Result))] := oEField;
  end;
end;



function TEnumMatriculation.Column(const AEnumeratedField: TEMatriculation): String;
begin
  Result := EmptyStr;

  case AEnumeratedField of
    temSequential:
      Result := 'NR_SEQUENTIAL';

    temPersonSequential:
      Result := 'NR_PERSONSEQUENTIAL';

    temDate:
      Result := 'DT_DATE';

    temUser:
      Result := 'CD_USER';
  else
    raise Exception.Create('Enumerated field doesn''t have a column.');
  end;
end;



function TEnumMatriculation.ColumnAlias(const AEnumeratedField: TEMatriculation): String;
begin
  Result := EmptyStr;

  case AEnumeratedField of
    temSequential:
      Result := 'MATRICULATION_SEQUENTIAL';

    temPersonSequential:
      Result := 'MATRICULATION_PERSONSEQUENTIAL';

    temDate:
      Result := 'MATRICULATION_DATE';

    temUser:
      Result := 'PERSON_USER';
  else
    raise Exception.Create('Enumerated field doesn''t have a column.');
  end;
end;



function TEnumMatriculation.Ref: IEnum<TEMatriculation>;
begin
  Result := Self;
end;



function TEnumMatriculation.Table: String;
begin
  Result := 'TB_MATRICULATION';
end;



function TEnumMatriculation.TableAlias(const AAlias: String): String;
begin
  Result := AAlias;

  if (Result.IsEmpty) then
    Result := 'MATRICULATION';
end;



end.

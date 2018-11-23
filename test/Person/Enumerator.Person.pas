unit Enumerator.Person;

interface

uses
  Enumerator;

type
  TEPerson = (tepSequential, tepName, tepBirthDate, tepEMail, tepPassword);

  TEnumPerson = class(TEnumAbstract<TEPerson>, IEnum<TEPerson>)
  public
    function Column(const AEnumeratedField: TEPerson): String; override;
    function Table: String; override;
    function TableAlias(const AAlias: String = ''): String; override;
    function Sequence: String; override;
    function AllColumns: TArray<TEPerson>; override;
    function PrimaryKey: TArray<TEPerson>; override;
    function Ref: IEnum<TEPerson>; override;
  end;

implementation

uses
  System.SysUtils;

{ TEnumPerson }

function TEnumPerson.Column(const AEnumeratedField: TEPerson): String;
begin
  Result := EmptyStr;

  case AEnumeratedField of
    tepSequential:
      Result := 'NR_SEQUENTIAL';

    tepName:
      Result := 'FL_NAME';

    tepBirthDate:
      Result := 'DT_BIRTHDATE';

    tepEMail:
      Result := 'TX_EMAIL';

    tepPassword:
      Result := 'TX_PASSWORD';
  else
    raise Exception.Create('Enumerated field doesn''t have a column.');
  end;
end;



function TEnumPerson.PrimaryKey: TArray<TEPerson>;
begin
  Result := [tepSequential];
end;



function TEnumPerson.AllColumns: TArray<TEPerson>;
var
  oEField: TEPerson;
begin
  SetLength(Result, 0);

  for oEField := Low(TEPerson) to High(TEPerson) do
  begin
    SetLength(Result, Succ(Length(Result)));
    Result[Pred(Length(Result))] := oEField;
  end;
end;



function TEnumPerson.Ref: IEnum<TEPerson>;
begin
  Result := Self;
end;



function TEnumPerson.Sequence: String;
begin
  Result := 'GEN_PERSON';
end;



function TEnumPerson.Table: String;
begin
  Result := 'TB_PERSON';
end;



function TEnumPerson.TableAlias(const AAlias: String): String;
begin
  Result := AAlias;

  if (Result.IsEmpty) then
    Result := 'PERSON';
end;

end.

unit Enumerator.Person;

interface

uses
  Nowa.Enumerator;

type
  TEPerson = (tepSequential, tepName, tepBirthDate, tepEMail, tepPassword);

  TEnumPerson = class(TEnumAbstract<TEPerson>, IEnum<TEPerson>)
  public
    function Column(const EnumeratedField: TEPerson): string; override;
    function Table: string; override;
    function TableAlias(const Alias: string = ''): string; override;
    function Sequence: string; override;
    function AllColumns: TArray<TEPerson>; override;
    function PrimaryKey: TArray<TEPerson>; override;
    function Ref: IEnum<TEPerson>; override;
  end;

implementation

uses
  System.SysUtils;

{ TEnumPerson }

function TEnumPerson.Column(const EnumeratedField: TEPerson): string;
begin
  Result := EmptyStr;

  case EnumeratedField of
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
  Field: TEPerson;
begin
  SetLength(Result, 0);

  for Field := low(TEPerson) to high(TEPerson) do
  begin
    SetLength(Result, Succ(Length(Result)));
    Result[Pred(Length(Result))] := Field;
  end;
end;

function TEnumPerson.Ref: IEnum<TEPerson>;
begin
  Result := Self;
end;

function TEnumPerson.Sequence: string;
begin
  Result := 'GEN_PERSON';
end;

function TEnumPerson.Table: string;
begin
  Result := 'TB_PERSON';
end;

function TEnumPerson.TableAlias(const Alias: string): string;
begin
  Result := Alias;

  if Result.IsEmpty then
    Result := 'PERSON';
end;

end.

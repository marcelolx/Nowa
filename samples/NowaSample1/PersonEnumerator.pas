unit PersonEnumerator;

interface

uses
  NowaEnumerator,
  NowaException,
  System.SysUtils;

type
  TEPerson = (pId, pFirstName, pLastName, pBirthdate, pGenre, pEmail, pPassword);

  TEnumPerson = class(TEnumAbstract<TEPerson>, IEnum<TEPerson>)
  public
    function Column(const EnumeratedField: TEPerson): String; override;
    function Table: String; override;
    function TableAlias(const Alias: String = 'P'): String; override;
    function Sequence: String; override;
    function AllColumns: TArray<TEPerson>; override;
    function PrimaryKey: TArray<TEPerson>; override;
    function Ref: IEnum<TEPerson>; override;
  end;

implementation

{ TEnumPerson }

function TEnumPerson.AllColumns: TArray<TEPerson>;
var
  Field: TEPerson;
begin
  SetLength(Result, 0);
  for Field := Low(TEPerson) to High(TEPerson) do
  begin
    SetLength(Result, Succ(Length(Result)));
    Result[Pred(Length(Result))] := Field;
  end;
end;

function TEnumPerson.Column(const EnumeratedField: TEPerson): String;
begin
  case EnumeratedField of
    pId: Result := 'person_id';
    pFirstName: Result := 'firstname';
    pLastName: Result := 'lastname';
    pBirthdate: Result := 'birthdate';
    pGenre: Result := 'genre';
    pEmail: Result := 'email';
    pPassword: Result := 'password';
  else
    raise EntityFieldException.Create('TEPerson');
  end;
end;

function TEnumPerson.PrimaryKey: TArray<TEPerson>;
begin
  Result := [pId];
end;

function TEnumPerson.Ref: IEnum<TEPerson>;
begin
  Result := Self;
end;

function TEnumPerson.Sequence: String;
begin
  Result := EmptyStr;
end;

function TEnumPerson.Table: String;
begin
  Result := 'person';
end;

function TEnumPerson.TableAlias(const Alias: String): String;
begin
  Result := Alias;
end;

end.

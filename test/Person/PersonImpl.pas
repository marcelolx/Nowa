unit PersonImpl;

interface

uses
  Person,
  NowaEntityImpl,
  NowaEnumerator,
  Enumerator.Person,
  Enumerator.Matriculation,
  NowaEntity,
  SysUtils,
  MatriculationImpl,
  NowaException;

type
  TPerson = class(TEntity<TEPerson>, IPerson<TEPerson>)
  private
    Sequential: Int64;
    Name: string;
    BirthDate: TDateTime;
    Email: string;
    Password: string;

    Matriculation: IEntity<TEMatriculation>;
  public
    constructor Create; reintroduce;
    function Ref: IPerson<TEPerson>;

    procedure SetValue(const Field: TEPerson; const Value: Variant); reintroduce; overload;
    function GetValue(const Field: TEPerson): Variant; reintroduce; overload;

    procedure SetValue(const Field: TEMatriculation; const Value: Variant); reintroduce; overload;
    function GetValue(const Field: TEMatriculation): Variant; reintroduce; overload;
  end;

implementation

{ TPerson }

constructor TPerson.Create;
begin
  inherited Create(TEnumPerson.Create.Ref);

  Matriculation := TMatriculation.Create;
end;

function TPerson.GetValue(const Field: TEPerson): Variant;
begin
  Result := 0;

  case Field of
    tepSequential:
      Result := Sequential;
    tepName:
      Result := Name;
    tepBirthDate:
      Result := BirthDate;
    tepEMail:
      Result := Email;
    tepPassword:
      Result := Password;
  else
    raise EntityFieldException.Create('TEPerson');
  end;
end;

procedure TPerson.SetValue(const Field: TEPerson; const Value: Variant);
begin
  case Field of
    tepSequential:
      Sequential := Value;
    tepName:
      Name := Value;
    tepBirthDate:
      BirthDate := Value;
    tepEMail:
      Email := Value;
    tepPassword:
      Password := Value;
  else
    raise EntityFieldException.Create('TEPerson');
  end;
end;

function TPerson.GetValue(const Field: TEMatriculation): Variant;
begin
  Result := Matriculation.GetValue(Field);
end;

function TPerson.Ref: IPerson<TEPerson>;
begin
  Result := Self;
end;

procedure TPerson.SetValue(const Field: TEMatriculation; const Value: Variant);
begin
  Matriculation.SetValue(Field, Value);
end;

end.

unit PersonImpl;

interface

uses
  NowaEntity,
  NowaEntityImpl,
  PersonEnumerator,
  NowaException;

type
  TPerson = class(TEntity<TEPerson>, IEntity<TEPerson>)
  private
    Id: Int64;
    FirstName: string;
    LastName: string;
    Birthdate: TDate;
    Genre: string;
    Email: string;
    Password: string;
  public
    constructor Create; reintroduce;

    procedure SetValue(const Field: TEPerson; const Value: Variant); override;
    function GetValue(const Field: TEPerson): Variant; override;
  end;

implementation

{ TPerson }

constructor TPerson.Create;
begin
  inherited Create(TEnumPerson.Create.Ref);
end;

function TPerson.GetValue(const Field: TEPerson): Variant;
begin
  case Field of
    pId: Result := Id;
    pFirstName: Result := FirstName;
    pLastName: Result := LastName;
    pBirthdate: Result := Birthdate;
    pGenre: Result := Genre;
    pEmail: Result := Email;
    pPassword: Result := Password;
  else
    raise EntityFieldException.Create('TEPerson');
  end;
end;

procedure TPerson.SetValue(const Field: TEPerson; const Value: Variant);
begin
  case Field of
    pId: Id := Value;
    pFirstName: FirstName := Value;
    pLastName: LastName := Value;
    pBirthdate: Birthdate := Value;
    pGenre: Genre := Value;
    pEmail: Email := Value;
    pPassword: Password := Value;
  else
    raise EntityFieldException.Create('TEPerson');
  end;
end;

end.

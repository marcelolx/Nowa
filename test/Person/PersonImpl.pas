unit PersonImpl;

interface

uses
  Person,
  Nowa.ModelImpl,
  Nowa.Enumerator,
  Enumerator.Person,
  Enumerator.Matriculation,
  Nowa.Model;

type
  TPerson = class(TModel<TEPerson>, IPerson<TEPerson>)
  private
    Sequential: Int64;
    Name: string;
    BirthDate: TDateTime;
    Email: string;
    Password: string;

    Matriculation: IModel<TEMatriculation>;
  public
    constructor Create; reintroduce;
    function Ref: IPerson<TEPerson>;

    procedure SetValue(const Field: TEPerson; const Value: Variant); reintroduce; overload;
    function GetValue(const Field: TEPerson): Variant; reintroduce; overload;

    procedure SetValue(const Field: TEMatriculation; const Value: Variant); reintroduce; overload;
    function GetValue(const Field: TEMatriculation): Variant; reintroduce; overload;
  end;

implementation

uses
  SysUtils,
  MatriculationImpl;

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
      Result := name;

    tepBirthDate:
      Result := BirthDate;

    tepEMail:
      Result := Email;

    tepPassword:
      Result := Password;
  else
    raise Exception.Create('TEPerson field doesn''t have relationship with model atributte.');
  end;
end;

procedure TPerson.SetValue(const Field: TEPerson; const Value: Variant);
begin
  case Field of
    tepSequential:
      Sequential := Value;

    tepName:
      name := Value;

    tepBirthDate:
      BirthDate := Value;

    tepEMail:
      Email := Value;

    tepPassword:
      Password := Value;
  else
    raise Exception.Create('TEPerson field doesn''t have relationship with model atributte.');
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

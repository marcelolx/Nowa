unit PersonImpl;

interface

uses
  Person,
  Nowa.ModelImpl,
  Enumerator,
  Enumerator.Person,
  Enumerator.Matriculation,
  Nowa.Model;

type
  TPerson = class(TModel<TEPerson>, IPerson<TEPerson>)
  private
    Sequential: Int64;
    Name: String;
    BirthDate: TDateTime;
    Email: String;
    Password: String;

    Matriculation: IModel<TEMatriculation>;
  public
    constructor Create; reintroduce;
    function Ref: IPerson<TEPerson>;

    procedure SetValue(const AField: TEPerson; const AValue: Variant); reintroduce; overload;
    function GetValue(const AField: TEPerson): Variant; reintroduce; overload;

    procedure SetValue(const AField: TEMatriculation; const AValue: Variant); reintroduce; overload;
    function GetValue(const AField: TEMatriculation): Variant; reintroduce; overload;

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



function TPerson.GetValue(const AField: TEPerson): Variant;
begin
  Result := 0;

  case AField of
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
    raise Exception.Create('TEPerson field doesn''t have relationship with model atributte.');
  end;
end;



procedure TPerson.SetValue(const AField: TEPerson; const AValue: Variant);
begin
  case AField of
    tepSequential:
      Sequential := AValue;

    tepName:
      Name := AValue;

    tepBirthDate:
      BirthDate := AValue;

    tepEMail:
      Email := AValue;

    tepPassword:
      Password := AValue;
  else
    raise Exception.Create('TEPerson field doesn''t have relationship with model atributte.');
  end;
end;

function TPerson.GetValue(const AField: TEMatriculation): Variant;
begin
  Result := Matriculation.GetValue(AField);
end;



function TPerson.Ref: IPerson<TEPerson>;
begin
  Result := Self;
end;



procedure TPerson.SetValue(const AField: TEMatriculation; const AValue: Variant);
begin
  Matriculation.SetValue(AField, AValue);
end;

end.

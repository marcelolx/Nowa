unit PersonImpl;

interface

uses
  Model,
  ModelImpl,
  Enumerator,
  Enumerator.Person;

type
  TPerson = class(TModel<TEPerson>, IModel<TEPerson>)
  private
    Sequential: Integer;
    Name: String;
    BirthDate: TDateTime;
    Email: String;
    Password: String;
  public
    constructor Create; reintroduce;

    procedure SetValue(const AField: TEPerson; const AValue: Variant); reintroduce;

    function GetValue(const AField: TEPerson): Variant; reintroduce;
  end;

implementation

uses
  SysUtils;

{ TPerson }

constructor TPerson.Create;
begin
  inherited Create(TEnumPerson.Create.Ref);
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

end.

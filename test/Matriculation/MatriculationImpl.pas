unit MatriculationImpl;

interface

uses
  NowaModel,
  NowaModelImpl,
  NowaEnumerator,
  Enumerator.Matriculation,
  SysUtils;

type
  TMatriculation = class(TModel<TEMatriculation>, IModel<TEMatriculation>)
  private
    Sequential: Integer;
    PersonSequential: Integer;
    RegisterDate: TDateTime;
    User: Integer;
  public
    constructor Create; reintroduce;

    procedure SetValue(const Field: TEMatriculation; const Value: Variant); reintroduce;

    function GetValue(const Field: TEMatriculation): Variant; reintroduce;
  end;

implementation

{ TMatriculation }

constructor TMatriculation.Create;
begin
  inherited Create(TEnumMatriculation.Create.Ref);
end;

function TMatriculation.GetValue(const Field: TEMatriculation): Variant;
begin
  Result := 0;

  case Field of
    temSequential:
      Result := Sequential;
    temPersonSequential:
      Result := PersonSequential;
    temDate:
      Result := RegisterDate;
    temUser:
      Result := User;
  else
    raise Exception.Create('TEMatriculation field doesn''t have relationship with model atributte.');
  end;
end;

procedure TMatriculation.SetValue(const Field: TEMatriculation; const Value: Variant);
begin
  case Field of
    temSequential:
      Sequential := Value;
    temPersonSequential:
      PersonSequential := Value;
    temDate:
      RegisterDate := Value;
    temUser:
      User := Value;
  else
    raise Exception.Create('TEMatriculation field doesn''t have relationship with model atributte.');
  end;
end;

end.

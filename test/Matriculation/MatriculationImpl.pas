unit MatriculationImpl;

interface

uses
  Nowa.Model,
  Nowa.ModelImpl,
  Enumerator,
  Enumerator.Matriculation;

type
  TMatriculation = class(TModel<TEMatriculation>, IModel<TEMatriculation>)
  private
    Sequential: Integer;
    PersonSequential: Integer;
    RegisterDate: TDateTime;
    User: Integer;
  public
    constructor Create; reintroduce;

    procedure SetValue(const AField: TEMatriculation; const AValue: Variant); reintroduce;

    function GetValue(const AField: TEMatriculation): Variant; reintroduce;
  end;

implementation

uses
  SysUtils;

{ TMatriculation }

constructor TMatriculation.Create;
begin
  inherited Create(TEnumMatriculation.Create.Ref);
end;



function TMatriculation.GetValue(const AField: TEMatriculation): Variant;
begin
  Result := 0;

  case AField of
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



procedure TMatriculation.SetValue(const AField: TEMatriculation; const AValue: Variant);
begin
  case AField of
    temSequential:
      Sequential := AValue;

    temPersonSequential:
      PersonSequential := AValue;

    temDate:
      RegisterDate := AValue;

    temUser:
      User := AValue;
  else
    raise Exception.Create('TEMatriculation field doesn''t have relationship with model atributte.');
  end;
end;

end.

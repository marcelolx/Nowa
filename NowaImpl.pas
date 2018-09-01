unit NowaImpl;

interface

uses
  Nowa,
  Nowa.Records;

type
  TSQL = class(TInterfacedObject, ISQL)
  strict protected const
    Space = ' ';
    CommaSpace = ', ';
    &As = ' as ';
    Point = '.';
    sFrom = ' from ';
    sEqual = ' = ';
    sDifferent = ' <> ';
    sGreater = ' > ';
    sGreaterOrEqual = ' >= ';
    sLess = ' < ';
    sLessOrEqual = ' <= ';
  public
    function Build: String; virtual; abstract;
  end;

  TSQLWhere = class(TSQL, ISQLWhere)
  strict private
    sWhere: String;     //TODO: Do Implement
  public
    function Field(const AFieldPrefix, AField: string): ISQLWhere;
    function Equal: ISQLWhere; overload;
    function Equal(const AValue: Variant): ISQLWhere; overload;
    function Different: ISQLWhere; overload;
    function Different(const AValue: Variant): ISQLWhere; overload;
    function Greater: ISQLWhere; overload;
    function Greater(const AValue: Variant): ISQLWhere; overload;
    function GreaterOrEqual: ISQLWhere; overload;
    function GreaterOrEqual(const AValue: Variant): ISQLWhere; overload;
    function Less: ISQLWhere; overload;
    function Less(const AValue: Variant): ISQLWhere; overload;
    function LessOrEqual: ISQLWhere; overload;
    function LessOrEqual(const AValue: Variant): ISQLWhere; overload;

    function Build: string; override;

    function Ref: ISQLWhere;
    constructor Create; reintroduce;
  end;

  TSQLSelect = class(TSQL, ISQLSelect)
  strict private
    sSelect: string;
  public
    function Fields(const AModelsFieldsPrepared: TArray<RFieldsPrepared>): ISQLSelect;
    function From(const ATable, ATableAlias: String): ISQLSelect;
    function Where(const AWhereCondition: ISQLWhere): ISQLSelect;

    function Build: string; override;

    function Ref: ISQLSelect;
    constructor Create; reintroduce;
  end;


implementation

uses
  System.SysUtils,
  System.Variants;

{ TSQLWhere }

function TSQLWhere.Build: string;
begin
  Result := sWhere;
end;



constructor TSQLWhere.Create;
begin
  sWhere := ' where ';
end;



function TSQLWhere.Different(const AValue: Variant): ISQLWhere;
begin
  Result := Self;
  sWhere := sWhere + sDifferent + VarToStr(AValue);
end;



function TSQLWhere.Different: ISQLWhere;
begin
  Result := Self;
  sWhere := sWhere + sDifferent;
end;



function TSQLWhere.Equal(const AValue: Variant): ISQLWhere;
begin
  Result := Self;
  sWhere := sWhere + sEqual + VarToStr(AValue);
end;



function TSQLWhere.Equal: ISQLWhere;
begin
  Result := Self;
  sWhere := sWhere + sEqual;
end;



function TSQLWhere.Field(const AFieldPrefix, AField: string): ISQLWhere;
begin
  Result := Self;
  sWhere := sWhere + AFieldPrefix + Point + AField;
end;



function TSQLWhere.Greater(const AValue: Variant): ISQLWhere;
begin
  Result := Self;
  sWhere := sWhere + sGreater + VarToStr(AValue);
end;



function TSQLWhere.Greater: ISQLWhere;
begin
  Result := Self;
  sWhere := sWhere + sGreater;
end;



function TSQLWhere.GreaterOrEqual(const AValue: Variant): ISQLWhere;
begin
  Result := Self;
  sWhere := sWhere + sGreaterOrEqual + VarToStr(AValue);
end;



function TSQLWhere.GreaterOrEqual: ISQLWhere;
begin
  Result := Self;
  sWhere := sWhere + sGreaterOrEqual;
end;



function TSQLWhere.Less(const AValue: Variant): ISQLWhere;
begin
  Result := Self;
  sWhere := sWhere + sLess + VarToStr(AValue);
end;



function TSQLWhere.Less: ISQLWhere;
begin
  Result := Self;
  sWhere := sWhere + sLess;
end;



function TSQLWhere.LessOrEqual(const AValue: Variant): ISQLWhere;
begin
  Result := Self;
  sWhere := sWhere + sLessOrEqual + VarToStr(AValue);
end;



function TSQLWhere.LessOrEqual: ISQLWhere;
begin
  Result := Self;
  sWhere := sWhere + sLessOrEqual;
end;



function TSQLWhere.Ref: ISQLWhere;
begin
  Result := Self;
end;


{ TSQLSelect }

function TSQLSelect.Build: string;
begin
  Result := sSelect;
end;



constructor TSQLSelect.Create;
begin
  sSelect := 'select';
end;



function TSQLSelect.Fields(const AModelsFieldsPrepared: TArray<RFieldsPrepared>): ISQLSelect;
var
  fFieldsPrepared: RFieldsPrepared;
  sField, sFieldAlias, sFieldsPrepared: string;
  iIndex: Integer;
begin
  Result := Self;

  for fFieldsPrepared in AModelsFieldsPrepared do
  begin
    for iIndex := Low(fFieldsPrepared.Fields) to High(fFieldsPrepared.Fields) do
    begin
      sField      := fFieldsPrepared.Fields[iIndex];
      sFieldAlias := fFieldsPrepared.FieldsAlias[iIndex];

      if (not(sFieldsPrepared.IsEmpty)) then
        sFieldsPrepared := sFieldsPrepared + CommaSpace;

      sFieldsPrepared := sFieldsPrepared + fFieldsPrepared.TableAlias + Point + sField + &As + sFieldAlias;
    end;
  end;

  sSelect := sSelect + Space + sFieldsPrepared;
end;



function TSQLSelect.From(const ATable, ATableAlias: String): ISQLSelect;
begin
  Result  := Self;
  sSelect := sSelect + sFrom + ATable + &As + ATableAlias;
end;



function TSQLSelect.Ref: ISQLSelect;
begin
  Result := Self;
end;



function TSQLSelect.Where(const AWhereCondition: ISQLWhere): ISQLSelect;
begin
  Result  := Self;
  sSelect := sSelect + AWhereCondition.Build;
end;

end.

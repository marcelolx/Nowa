unit NowaImpl;

interface

uses
  Nowa,
  Nowa.Records,
  Nowa.Model;

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

  TCommand<T> = class(TSQL, ICommand<T>)
  strict private
    sCommand: String;
  public
    function Select(const AModel: IModel<T>): ICommand<T>;
    function Insert(const AModel: IModel<T>): ICommand<T>;
    function Update(const AModel: IModel<T>): ICommand<T>;
    function Delete(const AModelKey: T): ICommand<T>;
    function WhereKey(const AModel: IModel<T>; const AModelKey: T): ICommand<T>;
    function DoInsert(const AModel: IModel<T>; const AModelKey: T): Boolean;
    function NewKeyValue(const ASequenceName: String): Int64;

    function Build: string; override;

    function Ref: TCommand<T>;
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


{ TCommand<T> }

function TCommand<T>.Build: string;
begin
  Result := sCommand;
end;



constructor TCommand<T>.Create;
begin
  sCommand := EmptyStr;
end;



function TCommand<T>.Delete(const AModelKey: T): ICommand<T>;
begin
  Result := Self;
  //TODO: Do implement
end;



function TCommand<T>.DoInsert(const AModel: IModel<T>; const AModelKey: T): Boolean;
begin
  Result := False;
  //TODO: Do implement
end;



function TCommand<T>.Insert(const AModel: IModel<T>): ICommand<T>;
var
  oEField: T;
  sFields: String;
begin
  Result  := Self;
  sFields := EmptyStr;

  for oEField in AModel.EnumFields do
  begin
    if (not(sFields.IsEmpty)) then
      sFields := sFields + ', ';

    sFields := sFields + LowerCase(AModel.FieldName(oEField));
  end;

  sCommand := 'insert into ' + LowerCase(AModel.Table) + ' (' + sFields + ') values (';

  sFields := EmptyStr;
  for oEField in AModel.EnumFields do
  begin
    if (not(sFields.IsEmpty)) then
      sFields := sFields + ', ';

    sFields := sFields + ':' + AModel.FieldAliasName(oEField);
  end;

  sCommand := sCommand + sFields + ')';
end;



function TCommand<T>.NewKeyValue(const ASequenceName: String): Int64;
begin
  Result := 0;
  //TODO: Do implement
end;



function TCommand<T>.Ref: TCommand<T>;
begin
  Result := Self;
end;



function TCommand<T>.Select(const AModel: IModel<T>): ICommand<T>;
begin
  Result := Self;
  //TODO: Do implement
end;



function TCommand<T>.Update(const AModel: IModel<T>): ICommand<T>;
begin
  Result := Self;
  //TODO: Do implement
end;



function TCommand<T>.WhereKey(const AModel: IModel<T>; const AModelKey: T): ICommand<T>;
begin
  Result := Self;
  //TODO: Do implement
end;

end.

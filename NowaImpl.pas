unit NowaImpl;

interface

uses
  Nowa,
  Nowa.Records,
  Nowa.Model,
  Nowa.Enumerators;

type
  TSQL = class(TInterfacedObject, ISQL)
  strict protected const
    Space = ' ';
    CommaSpace = ', ';
    sAs = ' as ';
    Point = '.';
    sFrom = ' from ';
    sEqual = ' = ';
    sDifferent = ' <> ';
    sGreater = ' > ';
    sGreaterOrEqual = ' >= ';
    sLess = ' < ';
    sLessOrEqual = ' <= ';
    sOn = ' on ';
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
    function Like(const AOperator: TSQLLikeOperator; const AValue: Variant): ISQLWhere;
    function NotLike(const AOperator: TSQLLikeOperator; const AValue: Variant): ISQLWhere;
    function IsNull: ISQLWhere;
    function IsNotNull: ISQLWhere;
    function InList(const AArray: TArray<Variant>): ISQLWhere;
    function &Not: ISQLWhere;
    function Between(const AStartValue, AEndValue: Variant): ISQLWhere;

    function Build: string; override;

    function Ref: ISQLWhere;
    constructor Create; reintroduce;
  end;

  TSQLBy<T> = class(TSQL, ISQLBy<T>)
  strict private
    ByCommand: String;
  public
    function Column(const AColumn: T): ISQLBy<T>;
    function Columns(const AColumn: TArray<T>): ISQLBy<T>;

    function Build: string; override;

    function Ref: ISQLBy<T>;
    constructor Create; reintroduce;
  end;

  TSQLJoin = class(TSQL, ISQLJoin)
  strict private
    JoinCommand: String;
  public
    function Table(const ATableAlias, ATableName: String): ISQLJoin;
    function &On(const ACondition: ISQLCondition): ISQLJoin;
    function &And(const ACondition: ISQLCondition): ISQLJoin;
    function &Or(const ACondition: ISQLCondition): ISQLJoin;

    function Build: string; override;

    function Ref: ISQLJoin;
    constructor Create; reintroduce;
  end;

  TSQLCondition = class(TSQL, ISQLCondition)
  strict private
    ConditionCommand: String;
  public
    function LeftTerm(const ATerm: String): ISQLCondition;
    function RightTerm(const ATerm: string): ISQLCondition;
    function Op(const AOperator: TSQLOperator): ISQLCondition;

    function Build: string; override;

    function Ref: ISQLCondition;
    constructor Create; reintroduce;
  end;

  TSQLSelect = class(TSQL, ISQLSelect)
  strict private
    sSelect: string;
  public
    function Fields(const AModelsFieldsPrepared: TArray<RFieldsPrepared>): ISQLSelect;
    function From(const ATable, ATableAlias: String): ISQLSelect;
    function Where(const AWhereCondition: ISQLWhere): ISQLSelect;
    function Having(const AHavingQuery: ISQLSelect): ISQLSelect;
    function GroupBy(const AGroupBy: ISQLBy<TObject>): ISQLSelect;
    function OrderBy(const AOrderBy: ISQLBy<TObject>): ISQLSelect;
    function Union: ISQLSelect;
    function UnionAll: ISQLSelect;
    function InnerJoin(const AJoin: ISQLJoin): ISQLSelect;
    function LeftJoin(const AJoin: ISQLJoin): ISQLSelect;
    function LeftOuterJoin(const AJoin: ISQLJoin): ISQLSelect;
    function RightJoin(const AJoin: ISQLJoin): ISQLSelect;
    function RightOuterJoin(const AJoin: ISQLJoin): ISQLSelect;

    function Build: string; override;

    function Ref: ISQLSelect;
    constructor Create; reintroduce;
  end;

  TSQLCommand<T> = class(TSQL, ISQLCommand<T>)
  strict private
    sCommand: String;
  public
    function Insert(const AModel: IModel<T>): ISQLCommand<T>;
    function Update(const AModel: IModel<T>): ISQLCommand<T>;
    function Delete(const AModel: IModel<T>): ISQLCommand<T>;
    function WhereKey(const AModel: IModel<T>; const AModelKey: T): ISQLCommand<T>;
    function NewKeyValue(const ASequenceName: String): ISQLCommand<T>;
    function Find(const AModel: IModel<T>; const AModelKey: T; const AKeyValue: Int64): ISQLCommand<T>;
    function DoInsert(const AModel: IModel<T>; const AModelKey: T): Boolean;
    function Exists(const AModel: IModel<T>; const AModelKey: T): ISQLCommand<T>;

    function Build: string; override;

    function Ref: TSQLCommand<T>;
    constructor Create; reintroduce;
  end;


implementation

uses
  System.SysUtils,
  System.Variants;

{ TSQLWhere }

function TSQLWhere.&Not: ISQLWhere;
begin
  Result := Self;
  sWhere := sWhere + ' not ';
end;



function TSQLWhere.Between(const AStartValue, AEndValue: Variant): ISQLWhere;
begin
  Result := Self;
  {TODO -oMarcelo -cImplement : Implementar}
end;



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



function TSQLWhere.InList(const AArray: TArray<Variant>): ISQLWhere;
var
  iIndex: Integer;
begin
  Result := Self;

  if (Length(AArray) = 0) then
    raise Exception.Create('Error: InList need array with length >= 1');

  sWhere := sWhere + ' in (';

  for iIndex := Low(AArray) to High(AArray) do
  begin
    sWhere := sWhere + VarToStr(AArray[iIndex]);

    if (iIndex < High(AArray)) then
      sWhere := sWhere + ',';
  end;

  sWhere := sWhere + ')';
end;



function TSQLWhere.IsNotNull: ISQLWhere;
begin
  Result := Self;
  //TODO: Do Implement
end;



function TSQLWhere.IsNull: ISQLWhere;
begin
  Result := Self;
  //TODO: DO Implement
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



function TSQLWhere.Like(const AOperator: TSQLLikeOperator; const AValue: Variant): ISQLWhere;
begin
  Result := Self;
  //TODO: Do Implement
end;



function TSQLWhere.NotLike(const AOperator: TSQLLikeOperator; const AValue: Variant): ISQLWhere;
begin
  Result := Self;
  //TODO: Do Implement
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

      sFieldsPrepared := sFieldsPrepared + fFieldsPrepared.TableAlias + Point + sField + sAs + sFieldAlias;
    end;
  end;

  sSelect := sSelect + Space + sFieldsPrepared;
end;



function TSQLSelect.From(const ATable, ATableAlias: String): ISQLSelect;
begin
  Result  := Self;
  sSelect := sSelect + sFrom + ATable + sAs + ATableAlias;
end;



function TSQLSelect.GroupBy(const AGroupBy: ISQLBy<TObject>): ISQLSelect;
begin
  Result := Self;
  {TODO -oMarcelo -cGeneral : Implementar}
end;



function TSQLSelect.Having(const AHavingQuery: ISQLSelect): ISQLSelect;
begin
  Result := Self;
  {TODO -oMarcelo -cGeneral : Implementar}
end;



function TSQLSelect.InnerJoin(const AJoin: ISQLJoin): ISQLSelect;
begin
  Result := Self;
  sSelect := sSelect + ' inner join ' + AJoin.Build;
end;



function TSQLSelect.LeftJoin(const AJoin: ISQLJoin): ISQLSelect;
begin
  Result := Self;
  {TODO -oMarcelo -cGeneral : Implementar}
end;



function TSQLSelect.LeftOuterJoin(const AJoin: ISQLJoin): ISQLSelect;
begin
  Result := Self;
  {TODO -oMarcelo -cGeneral : Implementar}
end;



function TSQLSelect.OrderBy(const AOrderBy: ISQLBy<TObject>): ISQLSelect;
begin
  Result := Self;
  {TODO -oMarcelo -cGeneral : Implementar}
end;



function TSQLSelect.Ref: ISQLSelect;
begin
  Result := Self;
end;



function TSQLSelect.RightJoin(const AJoin: ISQLJoin): ISQLSelect;
begin
  Result := Self;
  {TODO -oMarcelo -cGeneral : Implementar}
end;



function TSQLSelect.RightOuterJoin(const AJoin: ISQLJoin): ISQLSelect;
begin
  Result := Self;
  {TODO -oMarcelo -cGeneral : Implementar}
end;



function TSQLSelect.Union: ISQLSelect;
begin
  Result := Self;
  {TODO -oMarcelo -cGeneral : Implementar}
end;



function TSQLSelect.UnionAll: ISQLSelect;
begin
  Result := Self;
  {TODO -oMarcelo -cGeneral : Implementar}
end;



function TSQLSelect.Where(const AWhereCondition: ISQLWhere): ISQLSelect;
begin
  Result  := Self;
  sSelect := sSelect + AWhereCondition.Build;
end;


{ TCommand<T> }

function TSQLCommand<T>.Build: string;
begin
  Result := sCommand;
end;



constructor TSQLCommand<T>.Create;
begin
  sCommand := EmptyStr;
end;



function TSQLCommand<T>.Delete(const AModel: IModel<T>): ISQLCommand<T>;
begin
  Result   := Self;
  sCommand := 'delete' + sFrom + LowerCase(AModel.Table);
end;



function TSQLCommand<T>.DoInsert(const AModel: IModel<T>; const AModelKey: T): Boolean;
var
  sValue: String;
begin
  Result := False;
  sValue := VarToStr(AModel.GetValue(AModelKey));

  if (not((sValue.IsEmpty) or (sValue.Equals('0')))) then
    Result := False
  else
    Result := True;
end;



function TSQLCommand<T>.Exists(const AModel: IModel<T>; const AModelKey: T): ISQLCommand<T>;
begin
  Result := Self;
  //TODO: Do Implement
end;



function TSQLCommand<T>.Find(const AModel: IModel<T>; const AModelKey: T; const AKeyValue: Int64): ISQLCommand<T>;
var
  oEField: T;
  sFind: string;
begin
  Result := Self;

  sCommand := TSQLSelect.Create.Ref
    .Fields([AModel.PreparedFields])
    .From(AModel.Table, AModel.TableAlias)
    .Where(
      TSQLWhere.Create.Ref
        .Field(AModel.TableAlias, AModel.Field(AModelKey).Name)
        .Equal(AKeyValue)
    ).Build;
end;



function TSQLCommand<T>.Insert(const AModel: IModel<T>): ISQLCommand<T>;
var
  oEField: T;
  sFields: String;
begin
  Result   := Self;
  sFields  := EmptyStr;
  sCommand := EmptyStr;

  for oEField in AModel.EnumFields do
  begin
    if (not(sFields.IsEmpty)) then
      sFields := sFields + CommaSpace;

    sFields := sFields + LowerCase(AModel.Field(oEField).Name);
  end;

  sCommand := 'insert into ' + LowerCase(AModel.Table) + ' (' + sFields + ') values (';

  sFields := EmptyStr;
  for oEField in AModel.EnumFields do
  begin
    if (not(sFields.IsEmpty)) then
      sFields := sFields + CommaSpace;

    sFields := sFields + ':' + AModel.Field(oEField).Alias;
  end;

  sCommand := sCommand + sFields + ')';
end;



function TSQLCommand<T>.NewKeyValue(const ASequenceName: String): ISQLCommand<T>;
begin
  Result   := Self;
  sCommand := 'select nextval(' + QuotedStr(LowerCase(ASequenceName)) + ') as sequence';
end;



function TSQLCommand<T>.Ref: TSQLCommand<T>;
begin
  Result := Self;

  {TODO -oMarcelo -cImplement : Implement}
end;



function TSQLCommand<T>.Update(const AModel: IModel<T>): ISQLCommand<T>;
var
  oEField: T;
begin
  Result   := Self;
  sCommand := EmptyStr;

  for oEField in AModel.EnumFields do
  begin
    if (not(sCommand.IsEmpty)) then
      sCommand := sCommand + CommaSpace;

    sCommand := sCommand + LowerCase(AModel.Field(oEField).Name) + ' = :' + AModel.Field(oEField).Alias;
  end;

  sCommand := 'update ' + LowerCase(AModel.Table) + ' set ' + sCommand;
end;



function TSQLCommand<T>.WhereKey(const AModel: IModel<T>; const AModelKey: T): ISQLCommand<T>;
begin
  Result := Self;
  sCommand := sCommand + ' where ' + LowerCase(AModel.Field(AModelKey).Name) + ' = :' + AModel.Field(AModelKey).Alias;
end;


{ TSQLGroupBy<T> }

function TSQLBy<T>.Build: string;
begin
  Result := ByCommand;
end;



function TSQLBy<T>.Column(const AColumn: T): ISQLBy<T>;
begin
  Result := Self;

  {TODO -oMarcelo -cImplement : Implement}
end;



function TSQLBy<T>.Columns(const AColumn: TArray<T>): ISQLBy<T>;
begin
  Result := Self;

  {TODO -oMarcelo -cImplement : Implement}
end;



constructor TSQLBy<T>.Create;
begin
  ByCommand := EmptyStr;
end;



function TSQLBy<T>.Ref: ISQLBy<T>;
begin
  Result := Self;
end;



{ TSQLJoin }

function TSQLJoin.&And(const ACondition: ISQLCondition): ISQLJoin;
begin
  Result := Self;

  {TODO -oMarcelo -cImplement : Implement}
end;



function TSQLJoin.Build: string;
begin
  Result := JoinCommand;
end;



constructor TSQLJoin.Create;
begin
  JoinCommand := EmptyStr;
end;



function TSQLJoin.&On(const ACondition: ISQLCondition): ISQLJoin;
begin
  Result := Self;
  JoinCommand := JoinCommand + sOn + ACondition.Build;
end;



function TSQLJoin.&Or(const ACondition: ISQLCondition): ISQLJoin;
begin
  Result := Self;

  {TODO -oMarcelo -cImplement : Implement}
end;



function TSQLJoin.Ref: ISQLJoin;
begin
  Result := Self;
end;



function TSQLJoin.Table(const ATableAlias, ATableName: String): ISQLJoin;
begin
  Result := Self;
  JoinCommand := JoinCommand + Space + ATableName + sAs + ATableAlias;
end;



{ TSQLCondition }

function TSQLCondition.Build: string;
begin
  Result := '(' + ConditionCommand + ')';
end;



constructor TSQLCondition.Create;
begin
  ConditionCommand := EmptyStr;
end;



function TSQLCondition.LeftTerm(const ATerm: String): ISQLCondition;
begin
  Result := Self;
  ConditionCommand := ConditionCommand + ATerm;
end;



function TSQLCondition.Op(const AOperator: TSQLOperator): ISQLCondition;
begin
  Result := Self;
  ConditionCommand := ConditionCommand + TNowaEnumerators.GetOperator(AOperator);
end;



function TSQLCondition.Ref: ISQLCondition;
begin
  Result := Self;
end;



function TSQLCondition.RightTerm(const ATerm: string): ISQLCondition;
begin
  Result := Self;
  ConditionCommand := ConditionCommand + ATerm;
end;

end.

unit NowaImpl;

interface

uses
  Nowa,
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
    function Field(const AIField: IField): ISQLWhere;
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
    function Table(const ATable: ITable): ISQLJoin;
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
    function LeftTerm(const AIField: IField): ISQLCondition;
    function RightTerm(const AIField: IField): ISQLCondition;
    function Op(const AOperator: TSQLOperator): ISQLCondition;

    function Build: string; override;

    function Ref: ISQLCondition;
    constructor Create; reintroduce;
  end;

  TSQLSelect = class(TSQL, ISQLSelect)
  strict private
    sSelect: string;

    function GetTableFieldAlias(const AIField: IField): String;
  public
    function Fields(const AModelsFieldsPrepared: TArray<TArray<IField>>): ISQLSelect;
    function From(const ATable: ITable): ISQLSelect;
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
    function Insert(const AIModel: IModel<T>): ISQLCommand<T>;
    function Update(const AIModel: IModel<T>): ISQLCommand<T>;
    function Delete(const AIModel: IModel<T>): ISQLCommand<T>;
    function WhereKey(const AIModel: IModel<T>; const AModelKey: TArray<T>): ISQLCommand<T>;
    function NewKeyValue(const ASequenceName: String): ISQLCommand<T>;
    function Find(const AIModel: IModel<T>; const AModelKey: T; const AKeyValue: Int64): ISQLCommand<T>;
    function Exists(const AIModel: IModel<T>; const AModelKey: T): ISQLCommand<T>;

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



function TSQLWhere.Field(const AIField: IField): ISQLWhere;
begin
  Result := Self;
  sWhere := sWhere + AIField.Table.Alias + Point + AIField.Name;
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



function TSQLSelect.Fields(const AModelsFieldsPrepared: TArray<TArray<IField>>): ISQLSelect;
var
  fFieldsPrepared: TArray<IField>;
  oIField: IField;
  sFieldsPrepared: string;
begin
  Result := Self;

  for fFieldsPrepared in AModelsFieldsPrepared do
  begin
    for oIField in fFieldsPrepared do
    begin
      if (not(sFieldsPrepared.IsEmpty)) then
        sFieldsPrepared := sFieldsPrepared + CommaSpace;

      sFieldsPrepared := sFieldsPrepared + GetTableFieldAlias(oIField);
    end;
  end;

  sSelect := sSelect + Space + sFieldsPrepared;
end;



function TSQLSelect.From(const ATable: ITable): ISQLSelect;
begin
  Result  := Self;
  sSelect := sSelect + sFrom + ATable.Name + sAs + ATable.Alias;
end;



function TSQLSelect.GetTableFieldAlias(const AIField: IField): String;
begin
  Result := AIField.Table.Alias + Point + AIField.Name + sAs + AIField.Alias;
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



function TSQLCommand<T>.Delete(const AIModel: IModel<T>): ISQLCommand<T>;
begin
  Result   := Self;
  sCommand := 'delete' + sFrom + LowerCase(AIModel.Table.Name);
end;



function TSQLCommand<T>.Exists(const AIModel: IModel<T>; const AModelKey: T): ISQLCommand<T>;
begin
  Result := Self;
  //TODO: Do Implement
end;



function TSQLCommand<T>.Find(const AIModel: IModel<T>; const AModelKey: T; const AKeyValue: Int64): ISQLCommand<T>;
var
  oEField: T;
  sFind: string;
begin
  Result := Self;

  sCommand := TSQLSelect.Create.Ref
    .Fields([AIModel.Fields])
    .From(AIModel.Table)
    .Where(
      TSQLWhere.Create.Ref
        .Field(AIModel.Field(AModelKey))
        .Equal(AKeyValue)
    ).Build;
end;



function TSQLCommand<T>.Insert(const AIModel: IModel<T>): ISQLCommand<T>;
var
  oIField: IField;
  sFields, sParamFields: String;
begin
  Result       := Self;
  sFields      := EmptyStr;
  sParamFields := EmptyStr;
  sCommand     := EmptyStr;

  for oIField in AIModel.Fields do
  begin
    if (not(sFields.IsEmpty)) then
      sFields := sFields + CommaSpace;

    sFields := sFields + LowerCase(oIField.Name);

    if (not(sParamFields.IsEmpty)) then
      sParamFields := sParamFields + CommaSpace;

    sParamFields := sParamFields + ':' + oIField.Alias;
  end;

  sCommand := 'insert into ' + LowerCase(AIModel.Table.Name) + ' (' + sFields + ') values (' + sParamFields + ')';
end;



function TSQLCommand<T>.NewKeyValue(const ASequenceName: String): ISQLCommand<T>;
begin
  Result   := Self;
  sCommand := 'select nextval(' + QuotedStr(LowerCase(ASequenceName)) + ') as sequence';
end;



function TSQLCommand<T>.Ref: TSQLCommand<T>;
begin
  Result := Self;
end;



function TSQLCommand<T>.Update(const AIModel: IModel<T>): ISQLCommand<T>;
var
  oEField: T;
  oIField: IField;
begin
  Result   := Self;
  sCommand := EmptyStr;

  for oIField in AIModel.Fields do
  begin
    if (not(sCommand.IsEmpty)) then
      sCommand := sCommand + CommaSpace;

    sCommand := sCommand + LowerCase(oIField.Name) + ' = :' + oIField.Alias;
  end;

  sCommand := 'update ' + LowerCase(AIModel.Table.Name) + ' set ' + sCommand;
end;



function TSQLCommand<T>.WhereKey(const AIModel: IModel<T>; const AModelKey: TArray<T>): ISQLCommand<T>;
var
  oEFieldKey: T;
  Condition: String;
begin
  Result := Self;
  Condition := EmptyStr;

  for oEFieldKey in AModelKey do
  begin
    if (not(Condition.IsEmpty)) then
      Condition := Condition + ' and ';

    Condition := Condition + LowerCase(AIModel.Field(oEFieldKey).Name) + ' = :' + AIModel.Field(oEFieldKey).Alias;
  end;

  sCommand := sCommand + ' where ' + Condition;
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



function TSQLJoin.Table(const ATable: ITable): ISQLJoin;
begin
  Result := Self;
  JoinCommand := JoinCommand + Space + ATable.Name + sAs + ATable.Alias;
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



function TSQLCondition.LeftTerm(const AIField: IField): ISQLCondition;
begin
  Result := Self;
  ConditionCommand := ConditionCommand + AIField.Table.Alias + Point + AIField.Name;
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



function TSQLCondition.RightTerm(const AIField: IField): ISQLCondition;
begin
  Result := Self;
  ConditionCommand := ConditionCommand + AIField.Table.Alias + Point + AIField.Name;
end;

end.

unit NowaImpl;

interface

uses
  Nowa,
  Nowa.Model,
  Nowa.Enumerators;

type
  TSQL = class(TInterfacedObject, ISQL)
  protected const
    SpaceSQL = ' ';
    CommaSpaceSQL = ', ';
    AsSQL = ' as ';
    PointSQL = '.';
    FromSQL = ' from ';
    EqualSQL = ' = ';
    DifferentSQL = ' <> ';
    GreaterSQL = ' > ';
    GreaterOrEqualSQL = ' >= ';
    LessSQL = ' < ';
    LessOrEqualSQL = ' <= ';
    OnSQL = ' on ';
    NotSQL = ' not ';
    SelectSQL = ' select ';
    WhereSQL = ' where ';
    UpdateSQL = ' update ';
    InnerJoinSQL = ' inner join ';
    LeftJoinSQL = ' left join ';
    LeftOuterJoinSQL = ' left outer join ';
    RightJoinSQL = ' right join ';
    RightOuterJoinSQL = ' right outer join ';
    AndSQL = ' and ';
    SetSQL = ' set ';
    InsertSQL = ' insert ';
    DeleteSQL = ' delete ';
    UnionAllSelectSQL = ' union all select ';
    UnionSelectSQL = ' union select ';
  public
    function Build: string; virtual; abstract;
  end;

  TSQLWhere = class(TSQL, ISQLWhere)
  strict private
    FWhere: string; // TODO: Do Implement
  public
    function Field(const Field: IField): ISQLWhere;
    function Equal: ISQLWhere; overload;
    function Equal(const Value: Variant): ISQLWhere; overload;
    function Different: ISQLWhere; overload;
    function Different(const Value: Variant): ISQLWhere; overload;
    function Greater: ISQLWhere; overload;
    function Greater(const Value: Variant): ISQLWhere; overload;
    function GreaterOrEqual: ISQLWhere; overload;
    function GreaterOrEqual(const Value: Variant): ISQLWhere; overload;
    function Less: ISQLWhere; overload;
    function Less(const Value: Variant): ISQLWhere; overload;
    function LessOrEqual: ISQLWhere; overload;
    function LessOrEqual(const Value: Variant): ISQLWhere; overload;
    function Like(const operator: TSQLLikeOperator; const Value: Variant): ISQLWhere;
    function NotLike(const operator: TSQLLikeOperator; const Value: Variant): ISQLWhere;
    function IsNull: ISQLWhere;
    function IsNotNull: ISQLWhere;
    function InList(const Value: TArray<Variant>): ISQLWhere;
    function &Not: ISQLWhere;
    function Between(const StartValue, EndValue: Variant): ISQLWhere;

    function Build: string; override;

    function Ref: ISQLWhere;
    constructor Create; reintroduce;
  end;

  TSQLBy<T> = class(TSQL, ISQLBy<T>)
  strict private
    FByCommand: string;
  public
    function Column(const Column: T): ISQLBy<T>;
    function Columns(const Column: TArray<T>): ISQLBy<T>;

    function Build: string; override;

    function Ref: ISQLBy<T>;
    constructor Create; reintroduce;
  end;

  TSQLJoin = class(TSQL, ISQLJoin)
  strict private
    FJoinCommand: string;
  public
    function Table(const Table: ITable): ISQLJoin;
    function &On(const Condition: ISQLCondition): ISQLJoin;
    function &And(const Condition: ISQLCondition): ISQLJoin;
    function &Or(const Condition: ISQLCondition): ISQLJoin;

    function Build: string; override;

    function Ref: ISQLJoin;
    constructor Create; reintroduce;
  end;

  TSQLCondition = class(TSQL, ISQLCondition)
  strict private
    FConditionCommand: string;
  public
    function LeftTerm(const Field: IField): ISQLCondition;
    function RightTerm(const Field: IField): ISQLCondition;
    function Op(const operator: TSQLOperator): ISQLCondition;

    function Build: string; override;

    function Ref: ISQLCondition;
  end;

  TSQLSelect = class(TSQL, ISQLSelect)
  strict private
    FSelect: string;

    function GetTableFieldAlias(const Field: IField): string;
  public
    function Fields(const ModelsFieldsPrepared: TArray < TArray < IField >> ): ISQLSelect;
    function From(const Table: ITable): ISQLSelect;
    function Where(const WhereCondition: ISQLWhere): ISQLSelect;
    function Having(const HavingQuery: ISQLSelect): ISQLSelect;
    function GroupBy(const GroupBy: ISQLBy<TObject>): ISQLSelect;
    function OrderBy(const OrderBy: ISQLBy<TObject>): ISQLSelect;
    function Union: ISQLSelect;
    function UnionAll: ISQLSelect;
    function InnerJoin(const Join: ISQLJoin): ISQLSelect;
    function LeftJoin(const Join: ISQLJoin): ISQLSelect;
    function LeftOuterJoin(const Join: ISQLJoin): ISQLSelect;
    function RightJoin(const Join: ISQLJoin): ISQLSelect;
    function RightOuterJoin(const Join: ISQLJoin): ISQLSelect;

    function Build: string; override;

    function Ref: ISQLSelect;
    constructor Create; reintroduce;
  end;

  TSQLCommand<T> = class(TSQL, ISQLCommand<T>)
  strict private
    FCommand: string;
  public
    function Insert(const Model: IModel<T>): ISQLCommand<T>;
    function Update(const Model: IModel<T>): ISQLCommand<T>;
    function Delete(const Model: IModel<T>): ISQLCommand<T>;
    function WhereKey(const Model: IModel<T>; const ModelKey: TArray<T>): ISQLCommand<T>;
    function NewKeyValue(const SequenceName: string): ISQLCommand<T>;
    function Find(const Model: IModel<T>; const ModelKey: T; const KeyValue: Int64): ISQLCommand<T>;
    function Exists(const Model: IModel<T>; const ModelKey: TArray<T>): ISQLCommand<T>;

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
  FWhere := FWhere + NotSQL;
end;

function TSQLWhere.Between(const StartValue, EndValue: Variant): ISQLWhere;
begin
  Result := Self;
  { TODO -oMarcelo -cImplement : Implementar }
end;

function TSQLWhere.Build: string;
begin
  Result := FWhere;
end;

constructor TSQLWhere.Create;
begin
  FWhere := WhereSQL;
end;

function TSQLWhere.Different(const Value: Variant): ISQLWhere;
begin
  Result := Self;
  FWhere := FWhere + DifferentSQL + VarToStr(Value);
end;

function TSQLWhere.Different: ISQLWhere;
begin
  Result := Self;
  FWhere := FWhere + DifferentSQL;
end;

function TSQLWhere.Equal(const Value: Variant): ISQLWhere;
begin
  Result := Self;
  FWhere := FWhere + EqualSQL + VarToStr(Value); // TODO: When string, whe need QuotedStr!!
end;

function TSQLWhere.Equal: ISQLWhere;
begin
  Result := Self;
  FWhere := FWhere + EqualSQL;
end;

function TSQLWhere.Field(const Field: IField): ISQLWhere;
begin
  Result := Self;
  FWhere := FWhere + Field.Table.Alias + PointSQL + Field.Name;
end;

function TSQLWhere.Greater(const Value: Variant): ISQLWhere;
begin
  Result := Self;
  FWhere := FWhere + GreaterSQL + VarToStr(Value);
end;

function TSQLWhere.Greater: ISQLWhere;
begin
  Result := Self;
  FWhere := FWhere + GreaterSQL;
end;

function TSQLWhere.GreaterOrEqual(const Value: Variant): ISQLWhere;
begin
  Result := Self;
  FWhere := FWhere + GreaterOrEqualSQL + VarToStr(Value);
end;

function TSQLWhere.InList(const Value: TArray<Variant>): ISQLWhere;
var
  Index: Integer;
begin
  Result := Self;

  if Length(Value) = 0 then
    raise Exception.Create('Error: InList need array with length >= 1');

  FWhere := FWhere + ' in (';

  for Index := low(Value) to high(Value) do
  begin
    FWhere := FWhere + VarToStr(Value[Index]);

    if Index < high(Value) then
      FWhere := FWhere + ',';
  end;

  FWhere := FWhere + ')';
end;

function TSQLWhere.IsNotNull: ISQLWhere;
begin
  Result := Self;
  // TODO: Do Implement
end;

function TSQLWhere.IsNull: ISQLWhere;
begin
  Result := Self;
  // TODO: DO Implement
end;

function TSQLWhere.GreaterOrEqual: ISQLWhere;
begin
  Result := Self;
  FWhere := FWhere + GreaterOrEqualSQL;
end;

function TSQLWhere.Less(const Value: Variant): ISQLWhere;
begin
  Result := Self;
  FWhere := FWhere + LessSQL + VarToStr(Value);
end;

function TSQLWhere.Less: ISQLWhere;
begin
  Result := Self;
  FWhere := FWhere + LessSQL;
end;

function TSQLWhere.LessOrEqual(const Value: Variant): ISQLWhere;
begin
  Result := Self;
  FWhere := FWhere + LessOrEqualSQL + VarToStr(Value);
end;

function TSQLWhere.Like(const operator: TSQLLikeOperator; const Value: Variant): ISQLWhere;
begin
  Result := Self;
  // TODO: Do Implement
end;

function TSQLWhere.NotLike(const operator: TSQLLikeOperator; const Value: Variant): ISQLWhere;
begin
  Result := Self;
  // TODO: Do Implement
end;

function TSQLWhere.LessOrEqual: ISQLWhere;
begin
  Result := Self;
  FWhere := FWhere + LessOrEqualSQL;
end;

function TSQLWhere.Ref: ISQLWhere;
begin
  Result := Self;
end;

{ TSQLSelect }

function TSQLSelect.Build: string;
begin
  Result := FSelect;
end;

constructor TSQLSelect.Create;
begin
  FSelect := SelectSQL.Trim;
end;

function TSQLSelect.Fields(const ModelsFieldsPrepared: TArray < TArray < IField >> ): ISQLSelect;
var
  FieldsPrepared: TArray<IField>;
  Field: IField;
  QueryFieldsPrepared: string;
begin
  Result := Self;

  for FieldsPrepared in ModelsFieldsPrepared do
  begin
    for Field in FieldsPrepared do
    begin
      if not(QueryFieldsPrepared.IsEmpty) then
        QueryFieldsPrepared := QueryFieldsPrepared + CommaSpaceSQL;

      QueryFieldsPrepared := QueryFieldsPrepared + GetTableFieldAlias(Field);
    end;
  end;

  FSelect := FSelect + SpaceSQL + QueryFieldsPrepared;
end;

function TSQLSelect.From(const Table: ITable): ISQLSelect;
begin
  Result := Self;
  FSelect := FSelect + FromSQL + Table.Name + AsSQL + Table.Alias;
end;

function TSQLSelect.GetTableFieldAlias(const Field: IField): string;
begin
  Result := Field.Table.Alias + PointSQL + Field.Name + AsSQL + Field.Alias;
end;

function TSQLSelect.GroupBy(const GroupBy: ISQLBy<TObject>): ISQLSelect;
begin
  Result := Self;
  { TODO -oMarcelo -cGeneral : Implementar }
end;

function TSQLSelect.Having(const HavingQuery: ISQLSelect): ISQLSelect;
begin
  Result := Self;
  { TODO -oMarcelo -cGeneral : Implementar }
end;

function TSQLSelect.InnerJoin(const Join: ISQLJoin): ISQLSelect;
begin
  Result := Self;
  FSelect := FSelect + InnerJoinSQL + Join.Build;
end;

function TSQLSelect.LeftJoin(const Join: ISQLJoin): ISQLSelect;
begin
  Result := Self;
  FSelect := FSelect + LeftJoinSQL + Join.Build;
end;

function TSQLSelect.LeftOuterJoin(const Join: ISQLJoin): ISQLSelect;
begin
  Result := Self;
  FSelect := FSelect + LeftOuterJoinSQL + Join.Build;
end;

function TSQLSelect.OrderBy(const OrderBy: ISQLBy<TObject>): ISQLSelect;
begin
  Result := Self;
  { TODO -oMarcelo -cGeneral : Implementar }
end;

function TSQLSelect.Ref: ISQLSelect;
begin
  Result := Self;
end;

function TSQLSelect.RightJoin(const Join: ISQLJoin): ISQLSelect;
begin
  Result := Self;
  FSelect := FSelect + RightJoinSQL + Join.Build;
end;

function TSQLSelect.RightOuterJoin(const Join: ISQLJoin): ISQLSelect;
begin
  Result := Self;
  FSelect := FSelect + RightOuterJoinSQL + Join.Build;
end;

function TSQLSelect.Union: ISQLSelect;
begin
  Result := Self;
  FSelect := FSelect + UnionSelectSQL;
end;

function TSQLSelect.UnionAll: ISQLSelect;
begin
  Result := Self;
  FSelect := FSelect + UnionAllSelectSQL;
end;

function TSQLSelect.Where(const WhereCondition: ISQLWhere): ISQLSelect;
begin
  Result := Self;
  FSelect := FSelect + WhereCondition.Build;
end;

{ TCommand<T> }

function TSQLCommand<T>.Build: string;
begin
  Result := FCommand;
end;

constructor TSQLCommand<T>.Create;
begin
  FCommand := EmptyStr;
end;

function TSQLCommand<T>.Delete(const Model: IModel<T>): ISQLCommand<T>;
begin
  Result := Self;
  FCommand := DeleteSQL.Trim + FromSQL + LowerCase(Model.Table.Name);
end;

function TSQLCommand<T>.Exists(const Model: IModel<T>; const ModelKey: TArray<T>): ISQLCommand<T>;
begin
  Result := Self;
  // TODO: Do Implement
end;

function TSQLCommand<T>.Find(const Model: IModel<T>; const ModelKey: T; const KeyValue: Int64): ISQLCommand<T>;
begin
  Result := Self;

  FCommand := TSQLSelect.Create.Ref
    .Fields([Model.Fields])
    .From(Model.Table)
    .Where(
      TSQLWhere.Create.Ref
        .Field(Model.Field(ModelKey))
        .Equal(KeyValue)
    ).Build;
end;

function TSQLCommand<T>.Insert(const Model: IModel<T>): ISQLCommand<T>;
var
  Field: IField;
  Fields, ParamFields: string;
begin
  Result := Self;
  Fields := EmptyStr;
  ParamFields := EmptyStr;
  FCommand := EmptyStr;

  for Field in Model.Fields do
  begin
    if not(Fields.IsEmpty) then
      Fields := Fields + CommaSpaceSQL;

    Fields := Fields + LowerCase(Field.Name);

    if not(ParamFields.IsEmpty) then
      ParamFields := ParamFields + CommaSpaceSQL;

    ParamFields := ParamFields + ':' + Field.Alias;
  end;

  FCommand := InsertSQL.TrimLeft + 'into ' + LowerCase(Model.Table.Name) + ' (' + Fields + ') values (' + ParamFields + ')';
end;

function TSQLCommand<T>.NewKeyValue(const SequenceName: string): ISQLCommand<T>;
begin
  Result := Self;
  FCommand := SelectSQL.TrimLeft + 'nextval(' + QuotedStr(LowerCase(SequenceName)) + ') as sequence';
end;

function TSQLCommand<T>.Ref: TSQLCommand<T>;
begin
  Result := Self;
end;

function TSQLCommand<T>.Update(const Model: IModel<T>): ISQLCommand<T>;
var
  Field: IField;
begin
  Result := Self;
  FCommand := EmptyStr;

  for Field in Model.Fields do
  begin
    if not(FCommand.IsEmpty) then
      FCommand := FCommand + CommaSpaceSQL;

    FCommand := FCommand + LowerCase(Field.Name) + ' = :' + Field.Alias;
  end;

  FCommand := UpdateSQL.TrimLeft + LowerCase(Model.Table.Name) + SetSQL + FCommand;
end;

function TSQLCommand<T>.WhereKey(const Model: IModel<T>; const ModelKey: TArray<T>): ISQLCommand<T>;
var
  FieldKey: T;
  Condition: string;
begin
  Result := Self;
  Condition := EmptyStr;

  for FieldKey in ModelKey do
  begin
    if not(Condition.IsEmpty) then
      Condition := Condition + AndSQL;

    Condition := Condition + LowerCase(Model.Field(FieldKey).Name) + ' = :' + Model.Field(FieldKey).Alias;
  end;

  FCommand := FCommand + WhereSQL + Condition;
end;

{ TSQLGroupBy<T> }

function TSQLBy<T>.Build: string;
begin
  Result := FByCommand;
end;

function TSQLBy<T>.Column(const Column: T): ISQLBy<T>;
begin
  Result := Self;

  { TODO -oMarcelo -cImplement : Implement }
end;

function TSQLBy<T>.Columns(const Column: TArray<T>): ISQLBy<T>;
begin
  Result := Self;

  { TODO -oMarcelo -cImplement : Implement }
end;

constructor TSQLBy<T>.Create;
begin
  FByCommand := EmptyStr;
end;

function TSQLBy<T>.Ref: ISQLBy<T>;
begin
  Result := Self;
end;

{ TSQLJoin }

function TSQLJoin.&And(const Condition: ISQLCondition): ISQLJoin;
begin
  Result := Self;

  { TODO -oMarcelo -cImplement : Implement }
end;

function TSQLJoin.Build: string;
begin
  Result := FJoinCommand;
end;

constructor TSQLJoin.Create;
begin
  FJoinCommand := EmptyStr;
end;

function TSQLJoin.&On(const Condition: ISQLCondition): ISQLJoin;
begin
  Result := Self;
  FJoinCommand := FJoinCommand + OnSQL + Condition.Build;
end;

function TSQLJoin.&Or(const Condition: ISQLCondition): ISQLJoin;
begin
  Result := Self;

  { TODO -oMarcelo -cImplement : Implement }
end;

function TSQLJoin.Ref: ISQLJoin;
begin
  Result := Self;
end;

function TSQLJoin.Table(const Table: ITable): ISQLJoin;
begin
  Result := Self;
  FJoinCommand := FJoinCommand + Table.Name + AsSQL + Table.Alias;
end;

{ TSQLCondition }

function TSQLCondition.Build: string;
begin
  Result := '(' + FConditionCommand + ')';
end;

function TSQLCondition.LeftTerm(const Field: IField): ISQLCondition;
begin
  Result := Self;
  FConditionCommand := Field.Table.Alias + PointSQL + Field.Name;
end;

function TSQLCondition.Op(const operator: TSQLOperator): ISQLCondition;
begin
  Result := Self;
  FConditionCommand := FConditionCommand + TNowaEnumerators.GetOperator(operator);
end;

function TSQLCondition.Ref: ISQLCondition;
begin
  Result := Self;
end;

function TSQLCondition.RightTerm(const Field: IField): ISQLCondition;
begin
  Result := Self;
  FConditionCommand := FConditionCommand + Field.Table.Alias + PointSQL + Field.Name;
end;

end.

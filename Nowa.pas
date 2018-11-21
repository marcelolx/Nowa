unit Nowa;

interface

uses
  Nowa.Model,
  Nowa.Enumerators;

type
  ISQL = interface
  ['{72B34C65-F30B-4F21-9A41-A3C025054CAD}']
    function Build: String;
  end;

  ISQLWhere = interface(ISQL)
  ['{DD8BC762-B0BD-4A88-A24B-1CC53E2BD938}']
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
  end;

  ISQLBy<T> = interface(ISQL)
  ['{08FBAA7E-DEFB-45A7-BF5D-B3A5681BF561}']
    function Column(const AColumn: T): ISQLBy<T>;
    function Columns(const AColumn: TArray<T>): ISQLBy<T>;
  end;

  ISQLCondition = interface(ISQL)
  ['{04DF0E7C-783C-47C1-A033-6E19F8AE870D}']
    function LeftTerm(const AIField: IField): ISQLCondition;
    function RightTerm(const AIField: IField): ISQLCondition;
    function Op(const AOperator: TSQLOperator): ISQLCondition;
  end;

  ISQLJoin = interface(ISQL)
  ['{56C4AB65-E682-4273-91C1-CF3B10BF74F1}']
    function Table(const ATable: ITable): ISQLJoin;
    function &On(const ACondition: ISQLCondition): ISQLJoin;
    function &And(const ACondition: ISQLCondition): ISQLJoin;
    function &Or(const ACondition: ISQLCondition): ISQLJoin;
  end;

  ISQLSelect = interface(ISQL)
  ['{DF1D25A9-3A66-4C9D-A3DD-12A74B4E49DE}']
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
  end;

  ISQLCommand<T> = interface(ISQL)
  ['{56F3B298-6CBA-4DB6-824A-5C3F329C63CF}']
    function Insert(const AModel: IModel<T>): ISQLCommand<T>;
    function Update(const AModel: IModel<T>): ISQLCommand<T>;
    function Delete(const AModel: IModel<T>): ISQLCommand<T>;
    function Find(const AModel: IModel<T>; const AModelKey: T; const AKeyValue: Int64): ISQLCommand<T>;
    function WhereKey(const AModel: IModel<T>; const AModelKey: T): ISQLCommand<T>;
    function NewKeyValue(const ASequenceName: String): ISQLCommand<T>;
    function Exists(const AModel: IModel<T>; const AModelKey: T): ISQLCommand<T>;
    function DoInsert(const AModel: IModel<T>; const AModelKey: T): Boolean;
  end;

implementation

end.

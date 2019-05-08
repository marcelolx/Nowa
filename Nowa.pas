unit Nowa;

interface

uses
  NowaModel,
  NowaEnumerators;

type
  ISQL = interface
  ['{72B34C65-F30B-4F21-9A41-A3C025054CAD}']
    function Build: String;
  end;

  ISQLWhere = interface(ISQL)
  ['{DD8BC762-B0BD-4A88-A24B-1CC53E2BD938}']
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
    function Like(const Operator: TSQLLikeOperator; const Value: Variant): ISQLWhere;
    function NotLike(const Operator: TSQLLikeOperator; const Value: Variant): ISQLWhere;
    function IsNull: ISQLWhere;
    function IsNotNull: ISQLWhere;
    function InList(const Value: TArray<Variant>): ISQLWhere;
    function &Not: ISQLWhere;
    function Between(const StartValue, EndValue: Variant): ISQLWhere;
  end;

  ISQLBy<T> = interface(ISQL)
  ['{08FBAA7E-DEFB-45A7-BF5D-B3A5681BF561}']
    function Column(const Column: T): ISQLBy<T>;
    function Columns(const Column: TArray<T>): ISQLBy<T>;
  end;

  ISQLCondition = interface(ISQL)
  ['{04DF0E7C-783C-47C1-A033-6E19F8AE870D}']
    function LeftTerm(const Field: IField): ISQLCondition;
    function RightTerm(const Field: IField): ISQLCondition;
    function Op(const Operator: TSQLOperator): ISQLCondition;
  end;

  ISQLJoin = interface(ISQL)
  ['{56C4AB65-E682-4273-91C1-CF3B10BF74F1}']
    function Table(const Table: ITable): ISQLJoin;
    function &On(const Condition: ISQLCondition): ISQLJoin;
    function &And(const Condition: ISQLCondition): ISQLJoin;
    function &Or(const Condition: ISQLCondition): ISQLJoin;
  end;

  ISQLSelect = interface(ISQL)
  ['{DF1D25A9-3A66-4C9D-A3DD-12A74B4E49DE}']
    function Fields(const ModelsFieldsPrepared: TArray<TArray<IField>>): ISQLSelect;
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
  end;

  ISQLCommand<T> = interface(ISQL)
  ['{56F3B298-6CBA-4DB6-824A-5C3F329C63CF}']
    function Insert(const Model: IModel<T>): ISQLCommand<T>;
    function Update(const Model: IModel<T>): ISQLCommand<T>;
    function Delete(const Model: IModel<T>): ISQLCommand<T>;
    function Find(const Model: IModel<T>; const ModelKey: T; const KeyValue: Int64): ISQLCommand<T>;
    function WhereKey(const Model: IModel<T>; const ModelKey: TArray<T>): ISQLCommand<T>;
    function NewKeyValue(const SequenceName: String): ISQLCommand<T>;
    function Exists(const Model: IModel<T>; const ModelKey: TArray<T>): ISQLCommand<T>;
  end;

implementation

end.

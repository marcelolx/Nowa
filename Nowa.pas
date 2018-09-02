unit Nowa;

interface

uses
  Nowa.Records,
  Nowa.Model;

type
  ISQL = interface
  ['{72B34C65-F30B-4F21-9A41-A3C025054CAD}']
    function Build: String;
  end;

  ISQLWhere = interface(ISQL)
  ['{DD8BC762-B0BD-4A88-A24B-1CC53E2BD938}']
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
  end;

  ISQLSelect = interface(ISQL)
  ['{DF1D25A9-3A66-4C9D-A3DD-12A74B4E49DE}']
    function Fields(const AModelsFieldsPrepared: TArray<RFieldsPrepared>): ISQLSelect;
    function From(const ATable, ATableAlias: String): ISQLSelect;
    function Where(const AWhereCondition: ISQLWhere): ISQLSelect;
  end;

  ICommand<T> = interface(ISQL)
  ['{56F3B298-6CBA-4DB6-824A-5C3F329C63CF}']
    function Select(const AModel: IModel<T>): ICommand<T>;
    function Insert(const AModel: IModel<T>): ICommand<T>;
    function Update(const AModel: IModel<T>): ICommand<T>;
    function Delete(const AModelKey: T): ICommand<T>;
    function WhereKey(const AModel: IModel<T>; const AModelKey: T): ICommand<T>;
    function DoInsert(const AModel: IModel<T>; const AModelKey: T): Boolean;
    function NewKeyValue(const ASequenceName: String): Int64;
  end;

implementation

end.

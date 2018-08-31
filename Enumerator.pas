unit Enumerator;

interface

type
  IEnum<T> = interface
  ['{DA92220F-BE96-405B-8BDB-546139C2D417}']
    function Column(const AEnumeratedField: T): String;
    function ColumnAlias(const AEnumeratedField: T): String;
    function Columns(const AEnumeratedFields: TArray<T>): TArray<String>;
    function ColumnsAlias(const AEnumeratedFields: TArray<T>): TArray<String>;
    function Table: String;
    function TableAlias(const AAlias: String = ''): String;
    function Ref: IEnum<T>;
  end;

  TEnumAbstract<T> = class(TInterfacedObject, IEnum<T>)
  public
    function Column(const AEnumeratedField: T): String; virtual; abstract;
    function ColumnAlias(const AEnumeratedField: T): String; virtual; abstract;
    function Columns(const AEnumeratedFields: TArray<T>): TArray<String>; virtual; abstract;
    function ColumnsAlias(const AEnumeratedFields: TArray<T>): TArray<String>; virtual; abstract;
    function Table: String; virtual; abstract;
    function TableAlias(const AAlias: String = ''): String; virtual; abstract;
    function Ref: IEnum<T>; virtual; abstract;
  end;

implementation

end.

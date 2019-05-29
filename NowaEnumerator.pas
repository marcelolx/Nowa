unit NowaEnumerator;

interface

type
  IEnum<T> = interface
  ['{DA92220F-BE96-405B-8BDB-546139C2D417}']
    function Column(const EnumeratedField: T): String;
    function Columns(const EnumeratedFields: TArray<T>): TArray<String>;
    function Table: String;
    function TableAlias(const Alias: String = ''): String;
    function Sequence: String;
    function AllColumns: TArray<T>;
    function PrimaryKey: TArray<T>;
    function Ref: IEnum<T>;
  end;

  TEnumAbstract<T> = class(TInterfacedObject, IEnum<T>)
  public
    function Column(const EnumeratedField: T): String; virtual; abstract;
    function Columns(const EnumeratedFields: TArray<T>): TArray<String>; virtual; final;
    function Table: String; virtual; abstract;
    function TableAlias(const Alias: String = ''): String; virtual; abstract;
    function Sequence: String; virtual; abstract;
    function AllColumns: TArray<T>; virtual; abstract; //TODO: Need find a way to implement this method here :mindblown:
    function PrimaryKey: TArray<T>; virtual; abstract;
    function Ref: IEnum<T>; virtual; abstract;
  end;

implementation

{ TEnumAbstract<T> }

function TEnumAbstract<T>.Columns(const EnumeratedFields: TArray<T>): TArray<String>;
var
  InternalArray: TArray<T>;
  Field: T;
begin
  SetLength(Result, 0);

  if Length(EnumeratedFields) = 0 then
    InternalArray := AllColumns
  else
    InternalArray := EnumeratedFields;

  for Field in InternalArray do
  begin
    SetLength(Result, Succ(Length(Result)));
    Result[Pred(Length(Result))] := Column(Field);
  end;
end;

end.

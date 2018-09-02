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
    function AllColumns: TArray<T>;
    function Ref: IEnum<T>;
  end;

  TEnumAbstract<T> = class(TInterfacedObject, IEnum<T>)
  public
    function Column(const AEnumeratedField: T): String; virtual; abstract;
    function ColumnAlias(const AEnumeratedField: T): String; virtual; abstract;
    function Columns(const AEnumeratedFields: TArray<T>): TArray<String>; virtual; final;
    function ColumnsAlias(const AEnumeratedFields: TArray<T>): TArray<String>; virtual; final;
    function Table: String; virtual; abstract;
    function TableAlias(const AAlias: String = ''): String; virtual; abstract;
    function AllColumns: TArray<T>; virtual; abstract;
    function Ref: IEnum<T>; virtual; abstract;
  end;

implementation

{ TEnumAbstract<T> }

function TEnumAbstract<T>.Columns(const AEnumeratedFields: TArray<T>): TArray<String>;
var
  oInternalArray: TArray<T>;
  oEField: T;
begin
  SetLength(Result, 0);

  if (Length(AEnumeratedFields) = 0) then
    oInternalArray := AllColumns
  else
    oInternalArray := AEnumeratedFields;

  for oEField in oInternalArray do
  begin
    SetLength(Result, Succ(Length(Result)));
    Result[Pred(Length(Result))] := Column(oEField);
  end;
end;



function TEnumAbstract<T>.ColumnsAlias(const AEnumeratedFields: TArray<T>): TArray<String>;
var
  oInternalArray: TArray<T>;
  oEField: T;
begin
  SetLength(Result, 0);

  if (Length(AEnumeratedFields) = 0) then
    oInternalArray := AllColumns
  else
    oInternalArray := AEnumeratedFields;

  for oEField in oInternalArray do
  begin
    SetLength(Result, Succ(Length(Result)));
    Result[Pred(Length(Result))] := ColumnAlias(oEField);
  end;
end;

end.

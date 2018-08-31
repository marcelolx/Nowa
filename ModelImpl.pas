unit ModelImpl;

interface

uses
  Model,
  Enumerator;

type
  TModel<T> = class(TInterfacedObject, IModel<T>)
  strict private
    fIModelEnumerator: IEnum<T>;

    Fields: TArray<String>;
    FieldsAlias: TArray<String>;
    Table: String;
    TableAlias: String;
  public
    constructor Create(const AIModelEnumerator: IEnum<T>); reintroduce;

    procedure PrepareModel(const ATableAlias: String = ''; const AFields: TArray<T> = []);
    procedure SetValue(const AField: T; const AValue: Variant); virtual; abstract;

    function GetValue(const AField: T): Variant; virtual; abstract;
    function FieldName(const AField: T): String;
    function FieldAliasName(const AField: T): string;
    function GetFields: TArray<String>;
    function GetFieldsAlias: TArray<String>;
    function GetTable: String;
    function GetTableAlias: String;
  end;

implementation

{ TModel<T> }

constructor TModel<T>.Create(const AIModelEnumerator: IEnum<T>);
begin
  fIModelEnumerator := AIModelEnumerator;
end;


procedure TModel<T>.PrepareModel(const ATableAlias: String; const AFields: TArray<T>);
begin
  Fields      := fIModelEnumerator.Columns(AFields);
  FieldsAlias := fIModelEnumerator.ColumnsAlias(AFields);
  Table       := fIModelEnumerator.Table;
  TableAlias  := fIModelEnumerator.TableAlias(ATableAlias);
end;



function TModel<T>.FieldAliasName(const AField: T): string;
begin
  Result := fIModelEnumerator.ColumnAlias(AField);
end;



function TModel<T>.FieldName(const AField: T): String;
begin
  Result := fIModelEnumerator.Column(AField);
end;



function TModel<T>.GetFields: TArray<String>;
begin
  Result := Fields;
end;



function TModel<T>.GetFieldsAlias: TArray<String>;
begin
  Result := FieldsAlias;
end;



function TModel<T>.GetTable: String;
begin
  Result := Table;
end;



function TModel<T>.GetTableAlias: String;
begin
  Result := TableAlias;
end;

end.



unit Nowa.ModelImpl;

interface

uses
  Nowa.Model,
  Enumerator,
  Nowa.Records,
  System.Generics.Collections;

type
  TGetString = function: string of object;

  TModel<T> = class(TInterfacedObject, IModel<T>)
  strict private
    fIModelEnumerator: IEnum<T>;

    Fields2: TDictionary<T, IField>;
    Fields: TArray<String>;
    FieldsAlias: TArray<String>;
    Table: String;
    TableAlias: String;
    SequenceName: String;
  public
    constructor Create(const AIModelEnumerator: IEnum<T>); reintroduce;
    destructor Destroy; override;

    procedure PrepareModel(const ATableAlias: String = ''; const AFields: TArray<T> = []);
    procedure SetValue(const AField: T; const AValue: Variant); virtual; abstract;

    function GetValue(const AField: T): Variant; virtual; abstract;
    function PreparedFields: RFieldsPrepared;

    //Need that PrepareModel called
    function Field(const AField: T): IField;


    function GetFields: TArray<String>;
    function GetEnumeratedFields: TArray<T>;
    function GetFieldsAlias: TArray<String>;
    function GetTable: String;
    function GetTableAlias: String;
    function GetSequence: String;
  end;

  TField = class(TInterfacedObject, IField)
  strict private
    FieldName: String;
    FieldAlias: String;
    TableName: TGetString;
    TableAliasName: TGetString;
  public
    constructor Create(const AFieldName, AFieldAlias: String; const ATableName, ATableAlias: TGetString); reintroduce;
    function Ref: IField;

    function Name: String;
    function Alias: String;
    function Table: String;
    function TableAlias: String;
  end;

implementation

{ TModel<T> }

constructor TModel<T>.Create(const AIModelEnumerator: IEnum<T>);
begin
  fIModelEnumerator := AIModelEnumerator;
  Fields2 := TDictionary<T, IField>.Create;
end;


function TModel<T>.PreparedFields: RFieldsPrepared;
begin
  Result.Fields      := GetFields;
  Result.FieldsAlias := GetFieldsAlias;
  Result.TableAlias  := GetTableAlias;
end;



procedure TModel<T>.PrepareModel(const ATableAlias: String; const AFields: TArray<T>);
var
  oInternalArray: TArray<T>;
  oEField: T;
  oIField: IField;
begin
  Fields       := fIModelEnumerator.Columns(AFields);
  FieldsAlias  := fIModelEnumerator.ColumnsAlias(AFields);
  Table        := fIModelEnumerator.Table;
  TableAlias   := fIModelEnumerator.TableAlias(ATableAlias);
  SequenceName := fIModelEnumerator.Sequence;

  ///////New way
  Fields2.Clear;
  if (Length(AFields) = 0) then
    oInternalArray := fIModelEnumerator.AllColumns
  else
    oInternalArray := AFields;

  for oEField in oInternalArray do
  begin
    oIField := TField.Create(
      fIModelEnumerator.Column(oEField),
      fIModelEnumerator.ColumnAlias(oEField),
      GetTable,
      GetTableAlias
    );

    Fields2.Add(oEField, oIField);
  end;
end;



destructor TModel<T>.Destroy;
begin
  Fields2.Free;
  inherited;
end;



function TModel<T>.Field(const AField: T): IField;
begin
  Fields2.TryGetValue(AField, Result);
end;



function TModel<T>.GetEnumeratedFields: TArray<T>;
begin
  Result := fIModelEnumerator.AllColumns;
end;



function TModel<T>.GetFields: TArray<String>;
begin
  Result := Fields;
end;



function TModel<T>.GetFieldsAlias: TArray<String>;
begin
  Result := FieldsAlias;
end;



function TModel<T>.GetSequence: String;
begin
  Result := SequenceName;
end;



function TModel<T>.GetTable: String;
begin
  Result := Table;
end;



function TModel<T>.GetTableAlias: String;
begin
  Result := TableAlias;
end;



{ TField }

function TField.Alias: String;
begin
  Result := FieldAlias;
end;



constructor TField.Create(const AFieldName, AFieldAlias: String; const ATableName, ATableAlias: TGetString);
begin
  FieldName := AFieldName;
  FieldAlias := AFieldAlias;
  TableName := ATableName;
  TableAliasName := ATableAlias;
end;



function TField.Name: String;
begin
  Result := FieldName;
end;



function TField.Ref: IField;
begin
  Result := Self;
end;



function TField.Table: String;
begin
  Result := TableName;
end;



function TField.TableAlias: String;
begin
  Result := TableAliasName;
end;

end.



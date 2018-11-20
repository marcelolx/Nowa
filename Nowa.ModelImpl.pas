unit Nowa.ModelImpl;

interface

uses
  Nowa.Model,
  Enumerator,
  System.Generics.Collections;

type
  TModel<T> = class(TInterfacedObject, IModel<T>)
  strict private
    fIModelEnumerator: IEnum<T>;
    fTable: ITable;
    fFields: TDictionary<T, IField>;
  public
    constructor Create(const AIModelEnumerator: IEnum<T>); reintroduce;
    destructor Destroy; override;

    procedure PrepareModel(const ATableAlias: String = ''; const AFields: TArray<T> = []);
    procedure SetValue(const AField: T; const AValue: Variant); virtual; abstract;

    function GetValue(const AField: T): Variant; virtual; abstract;

    //Need that PrepareModel called
    function Field(const AField: T): IField; overload;
    function Field(const AField: IField): T; overload;
    function Fields: TArray<IField>;
    function Table: ITable;
  end;

  TField = class(TInterfacedObject, IField)
  strict private
    FieldName: String;
    FieldAlias: String;
    fTable: ITable;
  public
    constructor Create(const AFieldName, AFieldAlias: String; const ATable: ITable); reintroduce;
    function Ref: IField;

    function Name: String;
    function Alias: String;
    function Table: ITable;
  end;

  TTable = class(TInterfacedObject, ITable)
  strict private
    TableName: String;
    TableAlias: String;
    SequenceName: String;
  public
    constructor Create(const ATableName, ATableAlias, ASequenceName: String); reintroduce;
    function Ref: ITable;

    function Name: String;
    function Alias: String;
    function Sequence: String;
  end;

implementation

uses
  System.Generics.Defaults;

{ TModel<T> }

constructor TModel<T>.Create(const AIModelEnumerator: IEnum<T>);
begin
  fIModelEnumerator := AIModelEnumerator;
  fFields := TDictionary<T, IField>.Create;
  //fTable  := TTable.Create('','','');
end;



procedure TModel<T>.PrepareModel(const ATableAlias: String; const AFields: TArray<T>);
var
  oInternalArray: TArray<T>;
  oEField: T;
  oIField: IField;
begin
  fTable := TTable.Create(fIModelEnumerator.Table, fIModelEnumerator.TableAlias(ATableAlias), fIModelEnumerator.Sequence);

  fFields.Clear;
  if (Length(AFields) = 0) then
    oInternalArray := fIModelEnumerator.AllColumns
  else
    oInternalArray := AFields;

  for oEField in oInternalArray do
  begin
    oIField := TField.Create(
      fIModelEnumerator.Column(oEField),
      fIModelEnumerator.ColumnAlias(oEField),
      fTable
    );

    fFields.Add(oEField, oIField);
  end;
end;



function TModel<T>.Table: ITable;
begin
  Result := fTable;
end;



destructor TModel<T>.Destroy;
begin
  fFields.Free;
  inherited;
end;



function TModel<T>.Field(const AField: T): IField;
begin
  fFields.TryGetValue(AField, Result);
end;



function TModel<T>.Field(const AField: IField): T;
var
  oEKey: T;
begin
  //TODO: Default Result if condition not accepted?

  for oEKey in fFIelds.Keys.ToArray do
  begin
    if (fFields.Items[oEKey] = AField) then
    begin
      Result := oEKey;
      Break;
    end;
  end;
end;



function TModel<T>.Fields: TArray<IField>;
var
  oEField: T;
begin
  SetLength(Result, 0);

  for oEField in fFields.Keys do
  begin
    SetLength(Result, Succ(Length(Result)));
    Result[Pred(Length(Result))] := fFields[oEField];
  end;
end;



{ TField }

function TField.Alias: String;
begin
  Result := FieldAlias;
end;



constructor TField.Create(const AFieldName, AFieldAlias: String; const ATable: ITable);
begin
  FieldName := AFieldName;
  FieldAlias := AFieldAlias;
  fTable := ATable;
end;



function TField.Name: String;
begin
  Result := FieldName;
end;



function TField.Ref: IField;
begin
  Result := Self;
end;



function TField.Table: ITable;
begin
  Result := fTable;
end;



{ TTable }

function TTable.Alias: String;
begin
  Result := TableAlias;
end;



constructor TTable.Create(const ATableName, ATableAlias, ASequenceName: String);
begin
  TableName    := ATableName;
  TableAlias   := ATableAlias;
  SequenceName := ASequenceName;
end;



function TTable.Name: String;
begin
  Result := TableName;
end;



function TTable.Ref: ITable;
begin
  Result := Self;
end;



function TTable.Sequence: String;
begin
  Result := SequenceName;
end;

end.

unit NowaEntityImpl;

interface

uses
  NowaEntity,
  NowaEnumerator,
  System.Generics.Collections,
  System.Generics.Defaults,
  System.SysUtils;

type
  TEntity<T> = class(TInterfacedObject, IEntity<T>)
  strict private
    FEntityEnumerator: IEnum<T>;
    FTable: ITable;
    FInternalFields: TArray<T>;
    FFields: TDictionary<T, IField>;
    FPrimaryKey: TArray<T>;
  public
    constructor Create(const EntityEnumerator: IEnum<T>); reintroduce;
    destructor Destroy; override;

    procedure PrepareEntity(const TableAlias: string = ''; const Fields: TArray<T> = []);
    procedure SetValue(const Field: T; const Value: Variant); virtual; abstract;

    function GetValue(const Field: T): Variant; virtual; abstract;
    function Field(const Field: T): IField; overload;
    function Field(const Field: IField): T; overload;
    function Fields: TArray<IField>;
    function Table: ITable;
    function PrimaryKey: TArray<T>;
    function IsNew: Boolean; virtual;
  end;

  TField = class(TInterfacedObject, IField)
  strict private
    FFieldName: string;
    FTable: ITable;
  public
    constructor Create(const FieldName: string; const Table: ITable); reintroduce;
    function Ref: IField;

    function Name: string;
    function Alias: string;
    function Table: ITable;
  end;

  TTable = class(TInterfacedObject, ITable)
  strict private
    FTableName: string;
    FTableAlias: string;
    FSequenceName: string;
  public
    constructor Create(const TableName, SequenceName: string); reintroduce;
    function Ref: ITable;

    function Name: string;
    function Alias: string;
    function Sequence: string;
    procedure Prepare(const Alias: string);
  end;

implementation

{ TEntity<T> }

constructor TEntity<T>.Create(const EntityEnumerator: IEnum<T>);
var
  Field: T;
begin
  FEntityEnumerator := EntityEnumerator;
  FFields := TDictionary<T, IField>.Create;
  FTable := TTable.Create(FEntityEnumerator.Table, FEntityEnumerator.Sequence);
  FInternalFields := FEntityEnumerator.AllColumns;
  FPrimaryKey := FEntityEnumerator.PrimaryKey;

  for Field in FInternalFields do
    FFields.Add(Field, TField.Create(FEntityEnumerator.Column(Field), FTable).Ref);
end;

procedure TEntity<T>.PrepareEntity(const TableAlias: string; const Fields: TArray<T>);
begin
  FTable.Prepare(FEntityEnumerator.TableAlias(TableAlias));

  if Length(Fields) > 0 then
    FInternalFields := Fields
  else
    FInternalFields := FEntityEnumerator.AllColumns;
end;

function TEntity<T>.PrimaryKey: TArray<T>;
begin
  Result := FPrimaryKey;
end;

function TEntity<T>.Table: ITable;
begin
  Result := FTable;
end;

destructor TEntity<T>.Destroy;
begin
  FFields.Free;
  inherited;
end;

function TEntity<T>.Field(const Field: T): IField;
begin
  FFields.TryGetValue(Field, Result);
end;

function TEntity<T>.Field(const Field: IField): T;
var
  Key: T;
begin
  // FFields always have all enumerated of enumerated type

  for Key in FFields.Keys.ToArray do
  begin
    if FFields.Items[Key] = Field then
    begin
      Result := Key;
      Break;
    end;
  end;
end;

function TEntity<T>.Fields: TArray<IField>;
var
  Field: T;
begin
  SetLength(Result, 0);

  for Field in FInternalFields do
  begin
    SetLength(Result, Succ(Length(Result)));
    Result[Pred(Length(Result))] := FFields[Field];
  end;
end;

function TEntity<T>.IsNew: Boolean;
begin
  Result := False;

  if Length(FPrimaryKey) = 1 then
  begin
    try
      Result := GetValue(FPrimaryKey[0]) = 0;
    except
      raise Exception.Create
        ('IsNew: Primary Key value is not an integer valid value, provide specific implementation to validate it.');
    end;
  end;
end;

{ TField }

function TField.Alias: string;
begin
  Result := FTable.Alias + '_' + FFieldName;
end;

constructor TField.Create(const FieldName: string; const Table: ITable);
begin
  FFieldName := FieldName;
  FTable := Table;
end;

function TField.Name: string;
begin
  Result := FFieldName;
end;

function TField.Ref: IField;
begin
  Result := Self;
end;

function TField.Table: ITable;
begin
  Result := FTable;
end;

{ TTable }

function TTable.Alias: string;
begin
  Result := FTableAlias;
end;

constructor TTable.Create(const TableName, SequenceName: string);
begin
  FTableName := TableName;
  FSequenceName := SequenceName;
end;

function TTable.Name: string;
begin
  Result := FTableName;
end;

procedure TTable.Prepare(const Alias: string);
begin
  FTableAlias := Alias;
end;

function TTable.Ref: ITable;
begin
  Result := Self;
end;

function TTable.Sequence: string;
begin
  Result := FSequenceName;
end;

end.

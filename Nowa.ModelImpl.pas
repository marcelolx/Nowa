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
    oInternalFields: TArray<T>;
    fFields: TDictionary<T, IField>;
    fPrimaryKey: TArray<T>;
  public
    constructor Create(const AIModelEnumerator: IEnum<T>); reintroduce;
    destructor Destroy; override;

    procedure PrepareModel(const ATableAlias: String = ''; const AFields: TArray<T> = []);
    procedure SetValue(const AField: T; const AValue: Variant); virtual; abstract;

    function GetValue(const AField: T): Variant; virtual; abstract;
    function Field(const AField: T): IField; overload;
    function Field(const AField: IField): T; overload;
    function Fields: TArray<IField>;
    function Table: ITable;
    function PrimaryKey: TArray<T>;
    function IsNew: Boolean; virtual;
  end;

  TField = class(TInterfacedObject, IField)
  strict private
    FieldName: String;
    fTable: ITable;
  public
    constructor Create(const AFieldName: String; const ATable: ITable); reintroduce;
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
    constructor Create(const ATableName, ASequenceName: String); reintroduce;
    function Ref: ITable;

    function Name: String;
    function Alias: String;
    function Sequence: String;
    procedure Prepare(const AAlias: String);
  end;

implementation

uses
  System.Generics.Defaults,
  System.SysUtils;

{ TModel<T> }

constructor TModel<T>.Create(const AIModelEnumerator: IEnum<T>);
var
  oEField: T;
begin
  fIModelEnumerator := AIModelEnumerator;
  fFields := TDictionary<T, IField>.Create;
  fTable  := TTable.Create(fIModelEnumerator.Table, fIModelEnumerator.Sequence);
  oInternalFields := fIModelEnumerator.AllColumns;
  fPrimaryKey := fIModelEnumerator.PrimaryKey;

  for oEField in oInternalFields do
    fFields.Add(oEField, TField.Create(fIModelEnumerator.Column(oEField), fTable).Ref);
end;



procedure TModel<T>.PrepareModel(const ATableAlias: String; const AFields: TArray<T>);
begin
  fTable.Prepare(fIModelEnumerator.TableAlias(ATableAlias));

  if (Length(AFields) > 0) then
    oInternalFields := AFields
  else
    oInternalFields := fIModelEnumerator.AllColumns;
end;



function TModel<T>.PrimaryKey: TArray<T>;
begin
  Result := fPrimaryKey;
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
  //fFields always have all enumerated of enumerated type

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

  for oEField in oInternalFields do
  begin
    SetLength(Result, Succ(Length(Result)));
    Result[Pred(Length(Result))] := fFields[oEField];
  end;
end;



function TModel<T>.IsNew: Boolean;
begin
  Result := False;

  if (Length(fPrimaryKey) = 1) then
  begin
    try
      Result := (GetValue(fPrimaryKey[0]) = 0);
    except
      raise Exception.Create('IsNew: Primary Key value is not an integer valid value, provide specific implementation to validate it.');
    end;
  end;
end;

{ TField }

function TField.Alias: String;
begin
  Result := fTable.Alias + '_' + FieldName;
end;



constructor TField.Create(const AFieldName: String; const ATable: ITable);
begin
  FieldName := AFieldName;
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



constructor TTable.Create(const ATableName, ASequenceName: String);
begin
  TableName    := ATableName;
  SequenceName := ASequenceName;
end;



function TTable.Name: String;
begin
  Result := TableName;
end;



procedure TTable.Prepare(const AAlias: String);
begin
  TableAlias := AAlias;
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

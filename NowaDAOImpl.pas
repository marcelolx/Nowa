unit NowaDAOImpl;

interface

uses
  NowaEntity,
  NowaDAO,
  FireDAC.Comp.Client,
  FireDAC.Stan.Param,
  NowaImpl,
  System.SysUtils,
  System.Variants;

type
  TNowaDAO<T> = class(TInterfacedObject, INowaDAO<T>)
  strict private
    function GenerateModelKey(const SequenceName: string): Int64;

    procedure SaveModel(const Entity: IEntity<T>);
  protected
    FCommand: TFDCommand;

    procedure GenerateModelCompoundKey(const Entity: IEntity<T>); virtual; abstract;
  public
    constructor Create(const FDCommand: TFDCommand); reintroduce;
    function Ref: INowaDAO<T>;

    procedure Insert(const Entity: IEntity<T>);
    procedure Update(const Entity: IEntity<T>);
    procedure Save(const Entity: IEntity<T>);
    procedure FillModel(const Entity: IEntity<T>; const Query: TFDQuery);
  end;

implementation

{ TNowaDAO<T> }

constructor TNowaDAO<T>.Create(const FDCommand: TFDCommand);
begin
  FCommand := FDCommand;
end;

procedure TNowaDAO<T>.FillModel(const Entity: IEntity<T>; const Query: TFDQuery);
var
  Field: IField;
begin
  for Field in Entity.Fields do
    Entity.SetValue(Entity.Field(Field), Query.FieldByName(Field.Alias).AsVariant);
end;

function TNowaDAO<T>.GenerateModelKey(const SequenceName: string): Int64;
var
  Query: TFDQuery;
begin
  Result := 0;

  Query := TFDQuery.Create(nil);

  try
    Query.Connection := FCommand.Connection;
    Query.Open(TSQLCommand<T>.Create.Ref.NewKeyValue(SequenceName).Build);
    Result := Query.FieldByName('sequence').AsLargeInt;
    Query.Close;
  finally
    Query.Free;
  end;
end;

function TNowaDAO<T>.Ref: INowaDAO<T>;
begin
  Result := Self;
end;

procedure TNowaDAO<T>.Save(const Entity: IEntity<T>);
begin
  if Entity.IsNew then
  begin
    FCommand.CommandText.Text := TSQLCommand<T>.Create.Ref.Insert(Entity).Build;

    if Length(Entity.PrimaryKey) = 1 then
      Entity.SetValue(Entity.PrimaryKey[0], GenerateModelKey(Entity.Table.Sequence))
    else
      GenerateModelCompoundKey(Entity);
  end
  else
    FCommand.CommandText.Text :=
      TSQLCommand<T>.Create.Ref
      .Update(Entity)
      .WhereKey(Entity, Entity.PrimaryKey)
      .Build;

  SaveModel(Entity);
end;

procedure TNowaDAO<T>.SaveModel(const Entity: IEntity<T>);
var
  Field: IField;
begin
  for Field in Entity.Fields do
    FCommand.ParamByName(Field.Alias).Value := Entity.GetValue(Entity.Field(Field));

  FCommand.Execute;
  FCommand.Close;
end;

procedure TNowaDAO<T>.Update(const Entity: IEntity<T>);
begin
  FCommand.CommandText.Text := TSQLCommand<T>.Create.Ref.Update(Entity).WhereKey(Entity, Entity.PrimaryKey).Build;
  SaveModel(Entity);
end;

procedure TNowaDAO<T>.Insert(const Entity: IEntity<T>);
begin
  FCommand.CommandText.Text := TSQLCommand<T>.Create.Ref.Insert(Entity).Build;
  SaveModel(Entity);
end;

end.

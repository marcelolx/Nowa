unit NowaDAOImpl;

interface

uses
  NowaEntity,
  NowaDAO,
  NowaDatabaseAdapter,
  NowaMediator,
  System.SysUtils,
  System.Variants;

type
  TNowaDAO<T> = class(TInterfacedObject, INowaDAO<T>)
  strict private
    function GenerateModelKey(const SequenceName: string): Int64;

    procedure SaveModel(const Entity: IEntity<T>);
  private
    FDataAccess: INowaDataAccess;
  protected
    Mediator: INowaMediator<T>;

    function Command: INowaCommandAdapter;
    function Query: INowaQueryAdapter;

    procedure GenerateModelCompoundKey(const Entity: IEntity<T>); virtual;
  public
    constructor Create(const DataAccess: INowaDataAccess; const Mediator: INowaMediator<T>); reintroduce;
    function Ref: INowaDAO<T>;

    procedure Insert(const Entity: IEntity<T>);
    procedure Update(const Entity: IEntity<T>);
    procedure Save(const Entity: IEntity<T>);
    procedure FillModel(const Entity: IEntity<T>);
  end;

implementation

{ TNowaDAO<T> }

constructor TNowaDAO<T>.Create(const DataAccess: INowaDataAccess; const Mediator: INowaMediator<T>);
begin
  FDataAccess := DataAccess;
  Self.Mediator := Mediator;
end;

procedure TNowaDAO<T>.FillModel(const Entity: IEntity<T>);
var
  Field: IField;
begin
  for Field in Entity.Fields do
    Entity.SetValue(Entity.Field(Field), Query.FieldByName(Field.Alias).Value);
end;

procedure TNowaDAO<T>.GenerateModelCompoundKey(const Entity: IEntity<T>);
begin
  raise Exception.Create('This method need do implemented');
end;

function TNowaDAO<T>.GenerateModelKey(const SequenceName: string): Int64;
begin
  Result := 0;

  Query.DefineSQL(Mediator.SQLCommand.NewKeyValue(SequenceName).Build);
  Query.Open;
  Result := Query.FieldByName('sequence').AsLargeInt;
  Query.Close;
end;

function TNowaDAO<T>.Ref: INowaDAO<T>;
begin
  Result := Self;
end;

procedure TNowaDAO<T>.Save(const Entity: IEntity<T>);
const
  ONE_COLUMN_PRIMARY_KEY = 1;
begin
  if Entity.IsNew then
  begin
    Command.DefineSQL(Mediator.SQLCommand.Insert(Entity).Build);

    if Length(Entity.PrimaryKey) = ONE_COLUMN_PRIMARY_KEY then
      Entity.SetValue(Entity.PrimaryKey[0], GenerateModelKey(Entity.Table.Sequence))
    else
      GenerateModelCompoundKey(Entity);
  end
  else
    Command.DefineSQL(
      Mediator.SQLCommand
      .Update(Entity)
      .WhereKey(Entity, Entity.PrimaryKey)
      .Build);

  SaveModel(Entity);
end;

procedure TNowaDAO<T>.SaveModel(const Entity: IEntity<T>);
var
  Field: IField;
begin
  for Field in Entity.Fields do
    Command.ParamByName(Field.Alias).Value := Entity.GetValue(Entity.Field(Field));

  Command.Execute;
  Command.Close;
end;

procedure TNowaDAO<T>.Update(const Entity: IEntity<T>);
begin
  Command.DefineSQL(Mediator.SQLCommand.Update(Entity).WhereKey(Entity, Entity.PrimaryKey).Build);
  SaveModel(Entity);
end;

procedure TNowaDAO<T>.Insert(const Entity: IEntity<T>);
begin
  Command.DefineSQL(Mediator.SQLCommand.Insert(Entity).Build);
  SaveModel(Entity);
end;

function TNowaDAO<T>.Command: INowaCommandAdapter;
begin
  Result := FDataAccess.Command;
end;

function TNowaDAO<T>.Query: INowaQueryAdapter;
begin
  Result := FDataAccess.Query;
end;

end.

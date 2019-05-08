unit NowaDAOImpl;

interface

uses
  Nowa.Model,
  NowaDAO,
  FireDAC.Comp.Client,
  FireDAC.Stan.Param;

type
  TNowaDAO<T> = class(TInterfacedObject, INowaDAO<T>)
  strict private
    function GenerateModelKey(const SequenceName: string): Int64;

    procedure SaveModel(const Model: IModel<T>);
  strict protected
    FCommand: TFDCommand;

    procedure GenerateModelCompoundKey(const Model: IModel<T>); virtual; abstract;
  public
    constructor Create(const FDCommand: TFDCommand); reintroduce;
    function Ref: INowaDAO<T>;

    procedure Insert(const Model: IModel<T>);
    procedure Update(const Model: IModel<T>);
    procedure Save(const Model: IModel<T>);
    procedure FillModel(const Model: IModel<T>; const AQuery: TFDQuery);
  end;

implementation

uses
  NowaImpl,
  System.SysUtils,
  System.Variants;

{ TNowaDAO<T> }

constructor TNowaDAO<T>.Create(const FDCommand: TFDCommand);
begin
  FCommand := FDCommand;
end;

procedure TNowaDAO<T>.FillModel(const Model: IModel<T>; const AQuery: TFDQuery);
var
  Field: IField;
begin
  for Field in Model.Fields do
    Model.SetValue(Model.Field(Field), AQuery.FieldByName(Field.Alias).AsVariant);
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

procedure TNowaDAO<T>.Save(const Model: IModel<T>);
begin
  if Model.IsNew then
  begin
    FCommand.CommandText.Text := TSQLCommand<T>.Create.Ref.Insert(Model).Build;

    if Length(Model.PrimaryKey) = 1 then
      Model.SetValue(Model.PrimaryKey[0], GenerateModelKey(Model.Table.Sequence))
    else
      GenerateModelCompoundKey(Model);
  end
  else
    FCommand.CommandText.Text :=
      TSQLCommand<T>.Create.Ref
      .Update(Model)
      .WhereKey(Model, Model.PrimaryKey)
      .Build;

  SaveModel(Model);
end;

procedure TNowaDAO<T>.SaveModel(const Model: IModel<T>);
var
  Field: IField;
begin
  for Field in Model.Fields do
    FCommand.ParamByName(Field.Alias).Value := Model.GetValue(Model.Field(Field));

  FCommand.Execute;
  FCommand.Close;
end;

procedure TNowaDAO<T>.Update(const Model: IModel<T>);
begin
  FCommand.CommandText.Text := TSQLCommand<T>.Create.Ref.Update(Model).WhereKey(Model, Model.PrimaryKey).Build;
  SaveModel(Model);
end;

procedure TNowaDAO<T>.Insert(const Model: IModel<T>);
begin
  FCommand.CommandText.Text := TSQLCommand<T>.Create.Ref.Insert(Model).Build;
  SaveModel(Model);
end;

end.

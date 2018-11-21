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
    function DoInsert(const AModel: IModel<T>; const AModelKey: T): Boolean;
    function GenerateModelKey(const ASequenceName: String): Int64;

    procedure SaveModel(const AModel: IModel<T>);
  strict protected
    fCommand: TFDCommand;
  public
    constructor Create(const AFDCommand: TFDCommand); reintroduce;
    function Ref: INowaDAO<T>;

    procedure Insert(const AModel: IModel<T>);
    procedure Update(const AModel: IModel<T>);
    procedure Save(const AModel: IModel<T>; const AModelKey: T);
    procedure FillModel(const AModel: IModel<T>; const AQuery: TFDQuery);
  end;

implementation

uses
  NowaImpl,
  System.SysUtils,
  System.Variants;

{ TNowaDAO<T> }

constructor TNowaDAO<T>.Create(const AFDCommand: TFDCommand);
begin
  fCommand := AFDCommand;
end;



function TNowaDAO<T>.DoInsert(const AModel: IModel<T>; const AModelKey: T): Boolean;
begin
  Result := TSQLCommand<T>.Create.Ref.DoInsert(AModel, AModelKey);
end;



procedure TNowaDAO<T>.FillModel(const AModel: IModel<T>; const AQuery: TFDQuery);
var
  oIField: IField;
  oEField: T;
begin
  for oIField in AModel.Fields do
    AModel.SetValue(AModel.Field(oIField), AQuery.FieldByName(oIField.Alias).AsVariant);
end;



function TNowaDAO<T>.GenerateModelKey(const ASequenceName: String): Int64;
var
  fQuery: TFDQuery;
begin
  Result := 0;

  fQuery := TFDQuery.Create(nil);

  try
    fQuery.Connection := fCommand.Connection;
    fQuery.Open(TSQLCommand<T>.Create.Ref.NewKeyValue(ASequenceName).Build);
    Result := fQuery.FieldByName('sequence').AsLargeInt;
    fQuery.Close;
  finally
    fQuery.Free;
  end;
end;


function TNowaDAO<T>.Ref: INowaDAO<T>;
begin
  Result := Self;
end;



procedure TNowaDAO<T>.Save(const AModel: IModel<T>; const AModelKey: T);
begin
  if DoInsert(AModel, AModelKey) then
  begin
    fCommand.CommandText.Text := TSQLCommand<T>.Create.Ref.Insert(AModel).Build;
    AModel.SetValue(AModelKey, GenerateModelKey(AModel.Table.Sequence));
  end
  else
    fCommand.CommandText.Text :=
      TSQLCommand<T>.Create.Ref
        .Update(AModel)
        .WhereKey(AModel, AModelKey)
        .Build;

  SaveModel(AModel);
end;



procedure TNowaDAO<T>.SaveModel(const AModel: IModel<T>);
var
  oEField: T;
  oIField: IField;
begin
  for oIField in AModel.Fields do
    fCommand.ParamByName(oIField.Alias).Value := AModel.GetValue(AModel.Field(oIField));

  fCommand.Execute;
  fCommand.Close;
end;



procedure TNowaDAO<T>.Update(const AModel: IModel<T>);
begin
  fCommand.CommandText.Text := TSQLCommand<T>.Create.Ref.Update(AModel).Build;
  SaveModel(AModel);
end;



procedure TNowaDAO<T>.Insert(const AModel: IModel<T>);
begin
  fCommand.CommandText.Text := TSQLCommand<T>.Create.Ref.Insert(AModel).Build;
  SaveModel(AModel);
end;

end.

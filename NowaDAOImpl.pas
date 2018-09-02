unit NowaDAOImpl;

interface

uses
  NowaDAO,
  Model,
  FireDAC.Comp.Client;

type
  TNowaDAO<T> = class(TInterfacedObject, INowaDAO<T>)
  strict private
    fCommand: TFDCommand;

    function GetInsertCommand(const AModel: IModel<T>): String;
    function GetUpdateCommand(const AModel: IModel<T>): String;
    function GetWhereModelKey(const AModel: IModel<T>; const AModelKey: T): String;
    function DoInsert(const AModel: IModel<T>; const AModelKey: T): Boolean;
    function GenerateModelKey(const ASequenceName: String): Int64;

    procedure SaveModel(const AModel: IModel<T>);
  public
    constructor Create(const AFDCommand: TFDCommand); reintroduce;
    function Ref: INowaDAO<T>;

    procedure Insert(const AModel: IModel<T>);
    procedure Update(const AModel: IModel<T>);
    procedure Save(const AModel: IModel<T>; const AModelKey: T);
  end;

implementation

uses
  System.SysUtils,
  System.Variants;

{ TNowaDAO<T> }

constructor TNowaDAO<T>.Create(const AFDCommand: TFDCommand);
begin
  fCommand := AFDCommand;
end;



function TNowaDAO<T>.DoInsert(const AModel: IModel<T>; const AModelKey: T): Boolean;
var
  sValue: String;
begin
  sValue := VarToStr(AModel.GetValue(AModelKey));

  if (not((sValue.IsEmpty) or (sValue.Equals('0')))) then
    Result := False
  else
    Result := True;
end;



function TNowaDAO<T>.GenerateModelKey(const ASequenceName: String): Int64;
var
  fQuery: TFDQuery;
begin
  Result := 0;

  fQuery := TFDQuery.Create(nil);

  try
    fQuery.Connection := fCommand.Connection;
    fQuery.Open('select nextval(' + QuotedStr(ASequenceName) + ') as sequence');
    Result := fQuery.FieldByName('sequence').AsLargeInt;
    fQuery.Close;
  finally
    fQuery.Free;
  end;
end;



function TNowaDAO<T>.GetInsertCommand(const AModel: IModel<T>): String;
var
  oEField: T;
  sFields: String;
begin
  sFields := EmptyStr;

  for oEField in AModel.EnumFields do
  begin
    if (not(sFields.IsEmpty)) then
      sFields := sFields + ', ';

    sFields := sFields + LowerCase(AModel.FieldName(oEField));
  end;

  Result := 'insert into ' + LowerCase(AModel.Table) + '(' + sFields + ') values (';

  sFields := EmptyStr;
  for oEField in AModel.EnumFields do
  begin
    if (not(sFields.IsEmpty)) then
      sFields := sFields + ', ';

    sFields := sFields + ':' + AModel.FieldAliasName(oEField);
  end;

  Result := Result + sFields + ')';
end;



function TNowaDAO<T>.GetUpdateCommand(const AModel: IModel<T>): String;
var
  oEField: T;
begin
  for oEField in AModel.EnumFields do
  begin
    if (not(Result.IsEmpty)) then
      Result := Result + ', ';

    Result := Result + LowerCase(AModel.FieldName(oEField)) + ' = :' + AModel.FieldAliasName(oEField);
  end;

  Result := 'update ' + LowerCase(AModel.Table) + ' set ' + Result;
end;



function TNowaDAO<T>.GetWhereModelKey(const AModel: IModel<T>; const AModelKey: T): String;
begin
  Result := ' where ' + LowerCase(AModel.FieldName(AModelKey)) + ' = :' + AModel.FieldAliasName(AModelKey);
end;



function TNowaDAO<T>.Ref: INowaDAO<T>;
begin
  Result := Self;
end;



procedure TNowaDAO<T>.Save(const AModel: IModel<T>; const AModelKey: T);
begin
  if DoInsert(AModel, AModelKey) then
  begin
    fCommand.CommandText.Text := GetInsertCommand(AModel);
    AModel.SetValue(AModelKey, GenerateModelKey(AModel.Sequence));
  end
  else
    fCommand.CommandText.Text := GetUpdateCommand(AModel) + GetWhereModelKey(AModel, AModelKey);

  SaveModel(AModel);
end;



procedure TNowaDAO<T>.SaveModel(const AModel: IModel<T>);
var
  oEField: T;
begin
  for oEField in AModel.EnumFields do
    fCommand.ParamByName(AModel.FieldAliasName(oEField)).Value := AModel.GetValue(oEField);

  fCommand.Execute;
  fCommand.Close;
end;



procedure TNowaDAO<T>.Update(const AModel: IModel<T>);
begin
  fCommand.CommandText.Text := GetUpdateCommand(AModel);
  SaveModel(AModel);
end;



procedure TNowaDAO<T>.Insert(const AModel: IModel<T>);
begin
  fCommand.CommandText.Text := GetInsertCommand(AModel);
  SaveModel(AModel);
end;

end.

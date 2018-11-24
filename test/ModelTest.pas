unit ModelTest;

interface

uses
  TestFramework,
  Nowa.Model,
  Enumerator.Person;

type
  TModelTest = class(TTestCase)
  strict private const
    &As = ' as ';
  strict private
    function GetEnumFieldAlias(const AIModel: IModel<TEPerson>; const AEnumerated: TEPerson): String;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestCreateModel;
    procedure TestPrepareModel;
    procedure TestPrepareModelSetTableAlias;
    procedure TestPrepareModelWithoutDefineFields;
    procedure TestSetGetValue;
    procedure TestPrepareModelAndGetPreparedFields;

    procedure TestBasicField;
  end;

implementation

uses
  PersonImpl,
  System.SysUtils,
  Person,
  Nowa.ModelImpl;


{ TModelTest }

function TModelTest.GetEnumFieldAlias(const AIModel: IModel<TEPerson>; const AEnumerated: TEPerson): String;
begin
  Result := AIModel.Table.Alias + '_' + TEnumPerson.Create.Ref.Column(AEnumerated);
end;



procedure TModelTest.SetUp;
begin
  inherited;

end;



procedure TModelTest.TearDown;
begin
  inherited;

end;



procedure TModelTest.TestBasicField;
var
  oIField: IField;
  oITable: ITable;
begin
  oITable := TTable.Create('TB_PERSON', '');
  oITable.Prepare('PERSON');

  oIField := TField.Create('ID', oITable);

  CheckEquals('ID', oIField.Name);
  CheckEquals('PERSON_ID', oIField.Alias);
  CheckEquals('TB_PERSON', oIField.Table.Name);
  CheckEquals('PERSON', oIField.Table.Alias);
end;



procedure TModelTest.TestCreateModel;
var
  fIModel: IModel<TEPerson>;
begin
  fIModel := TPerson.Create;

  CheckNotNull(fIModel);
end;



procedure TModelTest.TestPrepareModel;
var
  fIModel: IModel<TEPerson>;
begin
  fIModel := TPerson.Create;
  fIModel.PrepareModel('', [tepSequential]);

  CheckEquals(1, Length(fIModel.Fields), 'More or less fields on array that should');
  CheckEquals('TB_PERSON', fIModel.Table.Name, 'Wrong table name');
  CheckEquals('PERSON', fIModel.Table.Alias, 'Wrong default table alias name');
  CheckEquals(TEnumPerson.Create.Ref.Column(tepSequential) + &As + GetEnumFieldAlias(fIModel, tepSequential), fIModel.Field(tepSequential).Name + &As + fIModel.Field(tepSequential).Alias);

  fIModel.PrepareModel('', [tepSequential, tepName, tepBirthDate, tepEmail, tepPassword]);

  CheckEquals(5, Length(fIModel.Fields), 'More or less fields on array that should');
  CheckEquals('TB_PERSON', fIModel.Table.Name, 'Wrong table name');
  CheckEquals('PERSON', fIModel.Table.Alias, 'Wrong default table alias name');
  CheckEquals(TEnumPerson.Create.Ref.Column(tepSequential) + &As + GetEnumFieldAlias(fIModel, tepSequential), fIModel.Field(tepSequential).Name + &As + fIModel.Field(tepSequential).Alias);
  CheckEquals(TEnumPerson.Create.Ref.Column(tepName) + &As + GetEnumFieldAlias(fIModel, tepName)            , fIModel.Field(tepName).Name + &As + fIModel.Field(tepName).Alias);
  CheckEquals(TEnumPerson.Create.Ref.Column(tepBirthDate) + &As + GetEnumFieldAlias(fIModel, tepBirthDate)  , fIModel.Field(tepBirthDate).Name + &As + fIModel.Field(tepBirthDate).Alias);
  CheckEquals(TEnumPerson.Create.Ref.Column(tepEmail) + &As + GetEnumFieldAlias(fIModel, tepEmail)          , fIModel.Field(tepEmail).Name + &As + fIModel.Field(tepEMail).Alias);
  CheckEquals(TEnumPerson.Create.Ref.Column(tepPassword) + &As + GetEnumFieldAlias(fIModel, tepPassword)    , fIModel.Field(tepPassword).Name + &As + fIModel.Field(tepPassword).Alias);

  CheckEquals(fIModel.Field(tepSequential).Name + &As + fIModel.Field(tepSequential).Alias , fIModel.Field(tepSequential).Name + &As + fIModel.Field(tepSequential).Alias);
  CheckEquals(fIModel.Field(tepName).Name + &As + fIModel.Field(tepName).Alias             , fIModel.Field(tepName).Name + &As + fIModel.Field(tepName).Alias);
  CheckEquals(fIModel.Field(tepBirthDate).Name + &As + fIModel.Field(tepBirthDate).Alias   , fIModel.Field(tepBirthDate).Name + &As + fIModel.Field(tepBirthDate).Alias);
  CheckEquals(fIModel.Field(tepEmail).Name + &As + fIModel.Field(tepEmail).Alias           , fIModel.Field(tepEmail).Name + &As + fIModel.Field(tepEmail).Alias);
  CheckEquals(fIModel.Field(tepPassword).Name + &As + fIModel.Field(tepPassword).Alias     , fIModel.Field(tepPassword).Name + &As + fIModel.Field(tepPassword).Alias);
end;



procedure TModelTest.TestPrepareModelAndGetPreparedFields;
var
  fIModel: IModel<TEPerson>;
begin
  fIModel := TPerson.Create;
  fIModel.PrepareModel('', [tepSequential, tepName, tepEmail]);

  CheckEquals(fIModel.Field(tepSequential).Name, fIModel.Fields[0].Name);
  CheckEquals(fIModel.Field(tepSequential).Alias, fIModel.Fields[0].Alias);
  CheckEquals(fIModel.Field(tepSequential).Table.Name, fIModel.Fields[0].Table.Name);
  CheckEquals(fIModel.Field(tepSequential).Table.Alias, fIModel.Fields[0].Table.Alias);
  CheckEquals(fIModel.Field(tepSequential).Table.Sequence, fIModel.Fields[0].Table.Sequence);
  CheckEquals(fIModel.Field(tepName).Name, fIModel.Fields[1].Name);
  CheckEquals(fIModel.Field(tepName).Alias, fIModel.Fields[1].Alias);
  CheckEquals(fIModel.Field(tepName).Table.Name, fIModel.Fields[1].Table.Name);
  CheckEquals(fIModel.Field(tepName).Table.Alias, fIModel.Fields[1].Table.Alias);
  CheckEquals(fIModel.Field(tepName).Table.Sequence, fIModel.Fields[1].Table.Sequence);
  CheckEquals(fIModel.Field(tepEmail).Name, fIModel.Fields[2].Name);
  CheckEquals(fIModel.Field(tepEmail).Alias, fIModel.Fields[2].Alias);
  CheckEquals(fIModel.Field(tepEmail).Table.Name, fIModel.Fields[2].Table.Name);
  CheckEquals(fIModel.Field(tepEmail).Table.Alias, fIModel.Fields[2].Table.Alias);
  CheckEquals(fIModel.Field(tepEmail).Table.Sequence, fIModel.Fields[2].Table.Sequence);
end;



procedure TModelTest.TestPrepareModelSetTableAlias;
var
  fIModel: IModel<TEPerson>;
begin
  fIModel := TPerson.Create;
  fIModel.PrepareModel('DEFINE_ALIAS_TABLE', [tepSequential]);

  CheckEquals(1, Length(fIModel.Fields), 'More or less fields on array that should');
  CheckEquals('TB_PERSON', fIModel.Table.Name, 'Wrong table name');
  CheckEquals('DEFINE_ALIAS_TABLE', fIModel.Table.Alias, 'Wrong default table alias name');
  CheckEquals(TEnumPerson.Create.Ref.Column(tepSequential) + &As + GetEnumFieldAlias(fIModel, tepSequential), fIModel.Field(tepSequential).Name + &As + fIModel.Field(tepSequential).Alias);
end;



procedure TModelTest.TestPrepareModelWithoutDefineFields;
var
  fIModel: IModel<TEPerson>;
begin
  fIModel := TPerson.Create;
  fIModel.PrepareModel('', []);

  CheckEquals(5, Length(fIModel.Fields), 'More or less fields on array that should');
  CheckEquals('TB_PERSON', fIModel.Table.Name, 'Wrong table name');
  CheckEquals('PERSON', fIModel.Table.Alias, 'Wrong default table alias name');
  CheckEquals(TEnumPerson.Create.Ref.Column(tepSequential) + &As + GetEnumFieldAlias(fIModel, tepSequential), fIModel.Field(tepSequential).Name + &As + fIModel.Field(tepSequential).Alias);
  CheckEquals(TEnumPerson.Create.Ref.Column(tepName) + &As + GetEnumFieldAlias(fIModel, tepName)            , fIModel.Field(tepName).Name + &As + fIModel.Field(tepName).Alias);
  CheckEquals(TEnumPerson.Create.Ref.Column(tepBirthDate) + &As + GetEnumFieldAlias(fIModel, tepBirthDate)  , fIModel.Field(tepBirthDate).Name + &As + fIModel.Field(tepBirthDate).Alias);
  CheckEquals(TEnumPerson.Create.Ref.Column(tepEmail) + &As + GetEnumFieldAlias(fIModel, tepEmail)          , fIModel.Field(tepEmail).Name + &As + fIModel.Field(tepEmail).Alias);
  CheckEquals(TEnumPerson.Create.Ref.Column(tepPassword) + &As + GetEnumFieldAlias(fIModel, tepPassword)    , fIModel.Field(tepPassword).Name + &As + fIModel.Field(tepPassword).Alias);

  CheckEquals(fIModel.Field(tepSequential).Name + &As + fIModel.Field(tepSequential).Alias , fIModel.Field(tepSequential).Name + &As + fIModel.Field(tepSequential).Alias);
  CheckEquals(fIModel.Field(tepName).Name + &As + fIModel.Field(tepName).Alias             , fIModel.Field(tepName).Name + &As + fIModel.Field(tepName).Alias);
  CheckEquals(fIModel.Field(tepBirthDate).Name + &As + fIModel.Field(tepBirthDate).Alias   , fIModel.Field(tepBirthDate).Name + &As + fIModel.Field(tepBirthDate).Alias);
  CheckEquals(fIModel.Field(tepEmail).Name + &As + fIModel.Field(tepEmail).Alias           , fIModel.Field(tepEmail).Name + &As + fIModel.Field(tepEmail).Alias);
  CheckEquals(fIModel.Field(tepPassword).Name + &As + fIModel.Field(tepPassword).Alias     , fIModel.Field(tepPassword).Name + &As + fIModel.Field(tepPassword).Alias);
end;



procedure TModelTest.TestSetGetValue;
var
  fIModel: IPerson<TEPerson>;
begin
  fIModel := TPerson.Create;
  fIModel.SetValue(tepSequential, 1);
  fIModel.SetValue(tepName, 'Marcelo Lauxen');
  fIModel.SetValue(tepBirthDate, StrToDateTime('12/01/1998'));
  fIModel.SetValue(tepEMail, 'marcelolauxen16@gmail.com');
  fIModel.SetValue(tepPassword, 'SafePassword');

  CheckEquals(1, fIModel.GetValue(tepSequential));
  CheckEquals('Marcelo Lauxen', fIModel.GetValue(tepName));
  CheckEquals('12/01/1998', fIModel.GetValue(tepBirthDate));
  CheckEquals('marcelolauxen16@gmail.com', fIModel.GetValue(tepEMail));
  CheckEquals('SafePassword', fIModel.GetValue(tepPassword));
end;

initialization

RegisterTest(TModelTest.Suite);

end.

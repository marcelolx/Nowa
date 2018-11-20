unit ModelTest;

interface

uses
  TestFramework;

type
  TModelTest = class(TTestCase)
  strict private const
    &As = ' as ';
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
  Nowa.Model,
  PersonImpl,
  Enumerator.Person,
  System.SysUtils,
  Person,
  Nowa.ModelImpl;


{ TModelTest }

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
  oITable := TTable.Create('TB_PERSON', 'PERSON', '');

  oIField := TField.Create('ID', 'PERSON_ID', oITable);

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
  CheckEquals(TEnumPerson.Create.Ref.Column(tepSequential) + &As + TEnumPerson.Create.Ref.ColumnAlias(tepSequential), fIModel.Field(tepSequential).Name + &As + fIModel.Field(tepSequential).Alias);

  fIModel.PrepareModel('', [tepSequential, tepName, tepBirthDate, tepEmail, tepPassword]);

  CheckEquals(5, Length(fIModel.Fields), 'More or less fields on array that should');
  CheckEquals('TB_PERSON', fIModel.Table.Name, 'Wrong table name');
  CheckEquals('PERSON', fIModel.Table.Alias, 'Wrong default table alias name');
  CheckEquals(TEnumPerson.Create.Ref.Column(tepSequential) + &As + TEnumPerson.Create.Ref.ColumnAlias(tepSequential), fIModel.Field(tepSequential).Name + &As + fIModel.Field(tepSequential).Alias);
  CheckEquals(TEnumPerson.Create.Ref.Column(tepName) + &As + TEnumPerson.Create.Ref.ColumnAlias(tepName)            , fIModel.Field(tepName).Name + &As + fIModel.Field(tepName).Alias);
  CheckEquals(TEnumPerson.Create.Ref.Column(tepBirthDate) + &As + TEnumPerson.Create.Ref.ColumnAlias(tepBirthDate)  , fIModel.Field(tepBirthDate).Name + &As + fIModel.Field(tepBirthDate).Alias);
  CheckEquals(TEnumPerson.Create.Ref.Column(tepEmail) + &As + TEnumPerson.Create.Ref.ColumnAlias(tepEmail)          , fIModel.Field(tepEmail).Name + &As + fIModel.Field(tepEMail).Alias);
  CheckEquals(TEnumPerson.Create.Ref.Column(tepPassword) + &As + TEnumPerson.Create.Ref.ColumnAlias(tepPassword)    , fIModel.Field(tepPassword).Name + &As + fIModel.Field(tepPassword).Alias);

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
  fIModel.PrepareModel('', []);

  CheckEquals('not implemented', '');
  //CheckEquals(fIModel.Fields[0], fIModel.PreparedFields.Fields[0]); //TODO: Increment test
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
  CheckEquals(TEnumPerson.Create.Ref.Column(tepSequential) + &As + TEnumPerson.Create.Ref.ColumnAlias(tepSequential), fIModel.Field(tepSequential).Name + &As + fIModel.Field(tepSequential).Alias);
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
  CheckEquals(TEnumPerson.Create.Ref.Column(tepSequential) + &As + TEnumPerson.Create.Ref.ColumnAlias(tepSequential), fIModel.Field(tepSequential).Name + &As + fIModel.Field(tepSequential).Alias);
  CheckEquals(TEnumPerson.Create.Ref.Column(tepName) + &As + TEnumPerson.Create.Ref.ColumnAlias(tepName)            , fIModel.Field(tepName).Name + &As + fIModel.Field(tepName).Alias);
  CheckEquals(TEnumPerson.Create.Ref.Column(tepBirthDate) + &As + TEnumPerson.Create.Ref.ColumnAlias(tepBirthDate)  , fIModel.Field(tepBirthDate).Name + &As + fIModel.Field(tepBirthDate).Alias);
  CheckEquals(TEnumPerson.Create.Ref.Column(tepEmail) + &As + TEnumPerson.Create.Ref.ColumnAlias(tepEmail)          , fIModel.Field(tepEmail).Name + &As + fIModel.Field(tepEmail).Alias);
  CheckEquals(TEnumPerson.Create.Ref.Column(tepPassword) + &As + TEnumPerson.Create.Ref.ColumnAlias(tepPassword)    , fIModel.Field(tepPassword).Name + &As + fIModel.Field(tepPassword).Alias);

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

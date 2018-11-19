unit ModelTest;

interface

uses
  TestFramework;

type
  TModelTest = class(TTestCase)
  strict private const
    &As = ' as ';
  strict private
    function TestBasicFieldGetTable: string;
    function TestBasicFieldGetTableAlias: String;
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
begin
  oIField := TField.Create('ID', 'PERSON_ID', TestBasicFieldGetTable, TestBasicFieldGetTableAlias);

  CheckEquals('ID', oIField.Name);
  CheckEquals('PERSON_ID', oIField.Alias);
  CheckEquals('TB_PERSON', oIField.Table);
  CheckEquals('PERSON', oIField.TableAlias);
end;



function TModelTest.TestBasicFieldGetTable: string;
begin
  Result := 'TB_PERSON';
end;



function TModelTest.TestBasicFieldGetTableAlias: String;
begin
  Result := 'PERSON';
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
  CheckEquals(1, Length(fIModel.FieldsAlias), 'More or less fields alias on array that should');
  CheckEquals('TB_PERSON', fIModel.Table, 'Wrong table name');
  CheckEquals('PERSON', fIModel.TableAlias, 'Wrong default table alias name');
  CheckEquals(TEnumPerson.Create.Ref.Column(tepSequential) + &As + TEnumPerson.Create.Ref.ColumnAlias(tepSequential), fIModel.Fields[0] + &As + fIModel.FieldsAlias[0]);
  CheckEquals(fIModel.Field(tepSequential).Name + &As + fIModel.Field(tepSequential).Alias, fIModel.Fields[0] + &As + fIModel.FieldsAlias[0]);

  fIModel.PrepareModel('', [tepSequential, tepName, tepBirthDate, tepEmail, tepPassword]);

  CheckEquals(5, Length(fIModel.Fields), 'More or less fields on array that should');
  CheckEquals(5, Length(fIModel.FieldsAlias), 'More or less fields alias on array that should');
  CheckEquals('TB_PERSON', fIModel.Table, 'Wrong table name');
  CheckEquals('PERSON', fIModel.TableAlias, 'Wrong default table alias name');
  CheckEquals(TEnumPerson.Create.Ref.Column(tepSequential) + &As + TEnumPerson.Create.Ref.ColumnAlias(tepSequential), fIModel.Fields[0] + &As + fIModel.FieldsAlias[0]);
  CheckEquals(TEnumPerson.Create.Ref.Column(tepName) + &As + TEnumPerson.Create.Ref.ColumnAlias(tepName)            , fIModel.Fields[1] + &As + fIModel.FieldsAlias[1]);
  CheckEquals(TEnumPerson.Create.Ref.Column(tepBirthDate) + &As + TEnumPerson.Create.Ref.ColumnAlias(tepBirthDate)  , fIModel.Fields[2] + &As + fIModel.FieldsAlias[2]);
  CheckEquals(TEnumPerson.Create.Ref.Column(tepEmail) + &As + TEnumPerson.Create.Ref.ColumnAlias(tepEmail)          , fIModel.Fields[3] + &As + fIModel.FieldsAlias[3]);
  CheckEquals(TEnumPerson.Create.Ref.Column(tepPassword) + &As + TEnumPerson.Create.Ref.ColumnAlias(tepPassword)    , fIModel.Fields[4] + &As + fIModel.FieldsAlias[4]);

  CheckEquals(fIModel.Field(tepSequential).Name + &As + fIModel.Field(tepSequential).Alias , fIModel.Fields[0] + &As + fIModel.FieldsAlias[0]);
  CheckEquals(fIModel.Field(tepName).Name + &As + fIModel.Field(tepName).Alias             , fIModel.Fields[1] + &As + fIModel.FieldsAlias[1]);
  CheckEquals(fIModel.Field(tepBirthDate).Name + &As + fIModel.Field(tepBirthDate).Alias   , fIModel.Fields[2] + &As + fIModel.FieldsAlias[2]);
  CheckEquals(fIModel.Field(tepEmail).Name + &As + fIModel.Field(tepEmail).Alias           , fIModel.Fields[3] + &As + fIModel.FieldsAlias[3]);
  CheckEquals(fIModel.Field(tepPassword).Name + &As + fIModel.Field(tepPassword).Alias     , fIModel.Fields[4] + &As + fIModel.FieldsAlias[4]);
end;



procedure TModelTest.TestPrepareModelAndGetPreparedFields;
var
  fIModel: IModel<TEPerson>;
begin
  fIModel := TPerson.Create;
  fIModel.PrepareModel('', []);

  CheckEquals(fIModel.Fields[0], fIModel.PreparedFields.Fields[0]); //TODO: Increment test
end;



procedure TModelTest.TestPrepareModelSetTableAlias;
var
  fIModel: IModel<TEPerson>;
begin
  fIModel := TPerson.Create;
  fIModel.PrepareModel('DEFINE_ALIAS_TABLE', [tepSequential]);

  CheckEquals(1, Length(fIModel.Fields), 'More or less fields on array that should');
  CheckEquals(1, Length(fIModel.FieldsAlias), 'More or less fields alias on array that should');
  CheckEquals('TB_PERSON', fIModel.Table, 'Wrong table name');
  CheckEquals('DEFINE_ALIAS_TABLE', fIModel.TableAlias, 'Wrong default table alias name');
  CheckEquals(TEnumPerson.Create.Ref.Column(tepSequential) + &As + TEnumPerson.Create.Ref.ColumnAlias(tepSequential), fIModel.Fields[0] + &As + fIModel.FieldsAlias[0]);
  CheckEquals(fIModel.Field(tepSequential).Name + &As + fIModel.Field(tepSequential).Alias, fIModel.Fields[0] + &As + fIModel.FieldsAlias[0]);
end;



procedure TModelTest.TestPrepareModelWithoutDefineFields;
var
  fIModel: IModel<TEPerson>;
begin
  fIModel := TPerson.Create;
  fIModel.PrepareModel('', []);

  CheckEquals(5, Length(fIModel.Fields), 'More or less fields on array that should');
  CheckEquals(5, Length(fIModel.FieldsAlias), 'More or less fields alias on array that should');
  CheckEquals('TB_PERSON', fIModel.Table, 'Wrong table name');
  CheckEquals('PERSON', fIModel.TableAlias, 'Wrong default table alias name');
  CheckEquals(TEnumPerson.Create.Ref.Column(tepSequential) + &As + TEnumPerson.Create.Ref.ColumnAlias(tepSequential), fIModel.Fields[0] + &As + fIModel.FieldsAlias[0]);
  CheckEquals(TEnumPerson.Create.Ref.Column(tepName) + &As + TEnumPerson.Create.Ref.ColumnAlias(tepName)            , fIModel.Fields[1] + &As + fIModel.FieldsAlias[1]);
  CheckEquals(TEnumPerson.Create.Ref.Column(tepBirthDate) + &As + TEnumPerson.Create.Ref.ColumnAlias(tepBirthDate)  , fIModel.Fields[2] + &As + fIModel.FieldsAlias[2]);
  CheckEquals(TEnumPerson.Create.Ref.Column(tepEmail) + &As + TEnumPerson.Create.Ref.ColumnAlias(tepEmail)          , fIModel.Fields[3] + &As + fIModel.FieldsAlias[3]);
  CheckEquals(TEnumPerson.Create.Ref.Column(tepPassword) + &As + TEnumPerson.Create.Ref.ColumnAlias(tepPassword)    , fIModel.Fields[4] + &As + fIModel.FieldsAlias[4]);

  CheckEquals(fIModel.Field(tepSequential).Name + &As + fIModel.Field(tepSequential).Alias , fIModel.Fields[0] + &As + fIModel.FieldsAlias[0]);
  CheckEquals(fIModel.Field(tepName).Name + &As + fIModel.Field(tepName).Alias             , fIModel.Fields[1] + &As + fIModel.FieldsAlias[1]);
  CheckEquals(fIModel.Field(tepBirthDate).Name + &As + fIModel.Field(tepBirthDate).Alias   , fIModel.Fields[2] + &As + fIModel.FieldsAlias[2]);
  CheckEquals(fIModel.Field(tepEmail).Name + &As + fIModel.Field(tepEmail).Alias           , fIModel.Fields[3] + &As + fIModel.FieldsAlias[3]);
  CheckEquals(fIModel.Field(tepPassword).Name + &As + fIModel.Field(tepPassword).Alias     , fIModel.Fields[4] + &As + fIModel.FieldsAlias[4]);
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

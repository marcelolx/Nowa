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
  end;

implementation

uses
  Model,
  PersonImpl,
  Enumerator.Person;


{ TModelTest }

procedure TModelTest.SetUp;
begin
  inherited;

end;



procedure TModelTest.TearDown;
begin
  inherited;

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
  CheckEquals(fIModel.FieldName(tepSequential) + &As + fIModel.FieldAliasName(tepSequential), fIModel.Fields[0] + &As + fIModel.FieldsAlias[0]);

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

  CheckEquals(fIModel.FieldName(tepSequential) + &As + fIModel.FieldAliasName(tepSequential) , fIModel.Fields[0] + &As + fIModel.FieldsAlias[0]);
  CheckEquals(fIModel.FieldName(tepName) + &As + fIModel.FieldAliasName(tepName)             , fIModel.Fields[1] + &As + fIModel.FieldsAlias[1]);
  CheckEquals(fIModel.FieldName(tepBirthDate) + &As + fIModel.FieldAliasName(tepBirthDate)   , fIModel.Fields[2] + &As + fIModel.FieldsAlias[2]);
  CheckEquals(fIModel.FieldName(tepEmail) + &As + fIModel.FieldAliasName(tepEmail)           , fIModel.Fields[3] + &As + fIModel.FieldsAlias[3]);
  CheckEquals(fIModel.FieldName(tepPassword) + &As + fIModel.FieldAliasName(tepPassword)     , fIModel.Fields[4] + &As + fIModel.FieldsAlias[4]);
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
  CheckEquals(fIModel.FieldName(tepSequential) + &As + fIModel.FieldAliasName(tepSequential), fIModel.Fields[0] + &As + fIModel.FieldsAlias[0]);
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

  CheckEquals(fIModel.FieldName(tepSequential) + &As + fIModel.FieldAliasName(tepSequential) , fIModel.Fields[0] + &As + fIModel.FieldsAlias[0]);
  CheckEquals(fIModel.FieldName(tepName) + &As + fIModel.FieldAliasName(tepName)             , fIModel.Fields[1] + &As + fIModel.FieldsAlias[1]);
  CheckEquals(fIModel.FieldName(tepBirthDate) + &As + fIModel.FieldAliasName(tepBirthDate)   , fIModel.Fields[2] + &As + fIModel.FieldsAlias[2]);
  CheckEquals(fIModel.FieldName(tepEmail) + &As + fIModel.FieldAliasName(tepEmail)           , fIModel.Fields[3] + &As + fIModel.FieldsAlias[3]);
  CheckEquals(fIModel.FieldName(tepPassword) + &As + fIModel.FieldAliasName(tepPassword)     , fIModel.Fields[4] + &As + fIModel.FieldsAlias[4]);
end;

initialization

RegisterTest(TModelTest.Suite);

end.

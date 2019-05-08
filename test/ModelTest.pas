unit ModelTest;

interface

uses
  TestFramework,
  Nowa.Model,
  Enumerator.Person;

type
  TModelTest = class(TTestCase)
  strict private
  const
    &As = ' as ';
  strict private
    function GetEnumFieldAlias(const Model: IModel<TEPerson>; const Enumerated: TEPerson): string;
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

function TModelTest.GetEnumFieldAlias(const Model: IModel<TEPerson>; const Enumerated: TEPerson): string;
begin
  Result := Model.Table.Alias + '_' + TEnumPerson.Create.Ref.Column(Enumerated);
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
  Field: IField;
  Table: ITable;
begin
  Table := TTable.Create('PERSON', '');
  Table.Prepare('PERSON');

  Field := TField.Create('ID', Table);

  CheckEquals('ID', Field.Name);
  CheckEquals('PERSON_ID', Field.Alias);
  CheckEquals('PERSON', Field.Table.Name);
  CheckEquals('PERSON', Field.Table.Alias);
end;

procedure TModelTest.TestCreateModel;
var
  Person: IModel<TEPerson>;
begin
  Person := TPerson.Create;

  CheckNotNull(Person);
end;

procedure TModelTest.TestPrepareModel;
var
  Person: IModel<TEPerson>;
begin
  Person := TPerson.Create;
  Person.PrepareModel('', [tepSequential]);

  CheckEquals(1, Length(Person.Fields), 'More or less fields on array that should');
  CheckEquals('PERSON', Person.Table.Name, 'Wrong table name');
  CheckEquals('P', Person.Table.Alias, 'Wrong default table alias name');
  CheckEquals(TEnumPerson.Create.Ref.Column(tepSequential) + &As + GetEnumFieldAlias(Person, tepSequential),
    Person.Field(tepSequential).Name + &As + Person.Field(tepSequential).Alias);

  Person.PrepareModel('', [tepSequential, tepName, tepBirthDate, tepEmail, tepPassword]);

  CheckEquals(5, Length(Person.Fields), 'More or less fields on array that should');
  CheckEquals('PERSON', Person.Table.Name, 'Wrong table name');
  CheckEquals('P', Person.Table.Alias, 'Wrong default table alias name');
  CheckEquals(TEnumPerson.Create.Ref.Column(tepSequential) + &As + GetEnumFieldAlias(Person, tepSequential),
    Person.Field(tepSequential).Name + &As + Person.Field(tepSequential).Alias);
  CheckEquals(TEnumPerson.Create.Ref.Column(tepName) + &As + GetEnumFieldAlias(Person, tepName),
    Person.Field(tepName).Name + &As + Person.Field(tepName).Alias);
  CheckEquals(TEnumPerson.Create.Ref.Column(tepBirthDate) + &As + GetEnumFieldAlias(Person, tepBirthDate),
    Person.Field(tepBirthDate).Name + &As + Person.Field(tepBirthDate).Alias);
  CheckEquals(TEnumPerson.Create.Ref.Column(tepEmail) + &As + GetEnumFieldAlias(Person, tepEmail),
    Person.Field(tepEmail).Name + &As + Person.Field(tepEmail).Alias);
  CheckEquals(TEnumPerson.Create.Ref.Column(tepPassword) + &As + GetEnumFieldAlias(Person, tepPassword),
    Person.Field(tepPassword).Name + &As + Person.Field(tepPassword).Alias);

  CheckEquals(Person.Field(tepSequential).Name + &As + Person.Field(tepSequential).Alias,
    Person.Field(tepSequential).Name + &As + Person.Field(tepSequential).Alias);
  CheckEquals(Person.Field(tepName).Name + &As + Person.Field(tepName).Alias, Person.Field(tepName).Name + &As +
    Person.Field(tepName).Alias);
  CheckEquals(Person.Field(tepBirthDate).Name + &As + Person.Field(tepBirthDate).Alias,
    Person.Field(tepBirthDate).Name + &As + Person.Field(tepBirthDate).Alias);
  CheckEquals(Person.Field(tepEmail).Name + &As + Person.Field(tepEmail).Alias, Person.Field(tepEmail).Name + &As +
    Person.Field(tepEmail).Alias);
  CheckEquals(Person.Field(tepPassword).Name + &As + Person.Field(tepPassword).Alias,
    Person.Field(tepPassword).Name + &As + Person.Field(tepPassword).Alias);
end;

procedure TModelTest.TestPrepareModelAndGetPreparedFields;
var
  Person: IModel<TEPerson>;
begin
  Person := TPerson.Create;
  Person.PrepareModel('', [tepSequential, tepName, tepEmail]);

  CheckEquals(Person.Field(tepSequential).Name, Person.Fields[0].Name);
  CheckEquals(Person.Field(tepSequential).Alias, Person.Fields[0].Alias);
  CheckEquals(Person.Field(tepSequential).Table.Name, Person.Fields[0].Table.Name);
  CheckEquals(Person.Field(tepSequential).Table.Alias, Person.Fields[0].Table.Alias);
  CheckEquals(Person.Field(tepSequential).Table.Sequence, Person.Fields[0].Table.Sequence);
  CheckEquals(Person.Field(tepName).Name, Person.Fields[1].Name);
  CheckEquals(Person.Field(tepName).Alias, Person.Fields[1].Alias);
  CheckEquals(Person.Field(tepName).Table.Name, Person.Fields[1].Table.Name);
  CheckEquals(Person.Field(tepName).Table.Alias, Person.Fields[1].Table.Alias);
  CheckEquals(Person.Field(tepName).Table.Sequence, Person.Fields[1].Table.Sequence);
  CheckEquals(Person.Field(tepEmail).Name, Person.Fields[2].Name);
  CheckEquals(Person.Field(tepEmail).Alias, Person.Fields[2].Alias);
  CheckEquals(Person.Field(tepEmail).Table.Name, Person.Fields[2].Table.Name);
  CheckEquals(Person.Field(tepEmail).Table.Alias, Person.Fields[2].Table.Alias);
  CheckEquals(Person.Field(tepEmail).Table.Sequence, Person.Fields[2].Table.Sequence);
end;

procedure TModelTest.TestPrepareModelSetTableAlias;
var
  Person: IModel<TEPerson>;
begin
  Person := TPerson.Create;
  Person.PrepareModel('DEFINE_ALIAS_TABLE', [tepSequential]);

  CheckEquals(1, Length(Person.Fields), 'More or less fields on array that should');
  CheckEquals('PERSON', Person.Table.Name, 'Wrong table name');
  CheckEquals('DEFINE_ALIAS_TABLE', Person.Table.Alias, 'Wrong default table alias name');
  CheckEquals(TEnumPerson.Create.Ref.Column(tepSequential) + &As + GetEnumFieldAlias(Person, tepSequential),
    Person.Field(tepSequential).Name + &As + Person.Field(tepSequential).Alias);
end;

procedure TModelTest.TestPrepareModelWithoutDefineFields;
var
  Person: IModel<TEPerson>;
begin
  Person := TPerson.Create;
  Person.PrepareModel('', []);

  CheckEquals(5, Length(Person.Fields), 'More or less fields on array that should');
  CheckEquals('PERSON', Person.Table.Name, 'Wrong table name');
  CheckEquals('P', Person.Table.Alias, 'Wrong default table alias name');
  CheckEquals(TEnumPerson.Create.Ref.Column(tepSequential) + &As + GetEnumFieldAlias(Person, tepSequential),
    Person.Field(tepSequential).Name + &As + Person.Field(tepSequential).Alias);
  CheckEquals(TEnumPerson.Create.Ref.Column(tepName) + &As + GetEnumFieldAlias(Person, tepName),
    Person.Field(tepName).Name + &As + Person.Field(tepName).Alias);
  CheckEquals(TEnumPerson.Create.Ref.Column(tepBirthDate) + &As + GetEnumFieldAlias(Person, tepBirthDate),
    Person.Field(tepBirthDate).Name + &As + Person.Field(tepBirthDate).Alias);
  CheckEquals(TEnumPerson.Create.Ref.Column(tepEmail) + &As + GetEnumFieldAlias(Person, tepEmail),
    Person.Field(tepEmail).Name + &As + Person.Field(tepEmail).Alias);
  CheckEquals(TEnumPerson.Create.Ref.Column(tepPassword) + &As + GetEnumFieldAlias(Person, tepPassword),
    Person.Field(tepPassword).Name + &As + Person.Field(tepPassword).Alias);

  CheckEquals(Person.Field(tepSequential).Name + &As + Person.Field(tepSequential).Alias,
    Person.Field(tepSequential).Name + &As + Person.Field(tepSequential).Alias);
  CheckEquals(Person.Field(tepName).Name + &As + Person.Field(tepName).Alias, Person.Field(tepName).Name + &As +
    Person.Field(tepName).Alias);
  CheckEquals(Person.Field(tepBirthDate).Name + &As + Person.Field(tepBirthDate).Alias,
    Person.Field(tepBirthDate).Name + &As + Person.Field(tepBirthDate).Alias);
  CheckEquals(Person.Field(tepEmail).Name + &As + Person.Field(tepEmail).Alias, Person.Field(tepEmail).Name + &As +
    Person.Field(tepEmail).Alias);
  CheckEquals(Person.Field(tepPassword).Name + &As + Person.Field(tepPassword).Alias,
    Person.Field(tepPassword).Name + &As + Person.Field(tepPassword).Alias);
end;

procedure TModelTest.TestSetGetValue;
var
  Person: IPerson<TEPerson>;
begin
  Person := TPerson.Create;
  Person.SetValue(tepSequential, 1);
  Person.SetValue(tepName, 'Marcelo Lauxen');
  Person.SetValue(tepBirthDate, StrToDateTime('12/01/1998'));
  Person.SetValue(tepEmail, 'marcelolauxen16@gmail.com');
  Person.SetValue(tepPassword, 'SafePassword');

  CheckEquals(1, Person.GetValue(tepSequential));
  CheckEquals('Marcelo Lauxen', Person.GetValue(tepName));
  CheckEquals('12/01/1998', Person.GetValue(tepBirthDate));
  CheckEquals('marcelolauxen16@gmail.com', Person.GetValue(tepEmail));
  CheckEquals('SafePassword', Person.GetValue(tepPassword));
end;

initialization

RegisterTest(TModelTest.Suite);

end.

unit NowaTest;

interface

uses
  TestFramework;

type
  TNowaTest = class(TTestCase)
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestSQLSelectBuild;
    procedure TestSQLSelectBuildFields;
    procedure TestSQLSelectBuildFromWithoutFields;
    procedure TestSQLSelectBuildFromWithFields;
    procedure TestBasicSelect;
  end;

implementation

uses
  Model,
  Enumerator.Person,
  PersonImpl,
  NowaImpl,
  Nowa.Records;

{ TNowaTest }

procedure TNowaTest.SetUp;
begin
  inherited;

end;



procedure TNowaTest.TearDown;
begin
  inherited;

end;



procedure TNowaTest.TestBasicSelect;
const
  sQueryExpected = 'select PERSON.NR_SEQUENTIAL as PERSON_SEQUENTIAL, PERSON.FL_NAME as PERSON_NAME, PERSON.DT_BIRTHDATE as PERSON_BIRTHDATE, PERSON.TX_EMAIL as PERSON_EMAIL, PERSON.TX_PASSWORD as PERSON_PASSWORD from TB_PERSON as PERSON';
  sQueryExpected2 = 'select PERSON.NR_SEQUENTIAL as PERSON_SEQUENTIAL from TB_PERSON as PERSON';
var
  fIModel: IModel<TEPerson>;
  sQuery: String;
begin
  fIModel := TPerson.Create;
  fIModel.PrepareModel('', []);

  sQuery := TSQLSelect.Create.Ref
    .Fields([fIModel.PreparedFields])
    .From(fIModel.Table, fIModel.TableAlias)
    .Build;

  CheckEquals(sQueryExpected, sQuery);

  fIModel.PrepareModel('', [tepSequential]);

  sQuery := TSQLSelect.Create.Ref
    .Fields([fIModel.PreparedFields])
    .From(fIModel.Table, fIModel.TableAlias)
    .Build;

  CheckEquals(sQueryExpected2, sQuery);
end;



procedure TNowaTest.TestSQLSelectBuild;
begin
  CheckEquals('select', TSQLSelect.Create.Ref.Build);
end;



procedure TNowaTest.TestSQLSelectBuildFields;
const 
  sQuery = 'select PERSON.NR_SEQUENTIAL as PERSON_SEQUENTIAL';
  sQueryExpected = 'select PERSON.NR_SEQUENTIAL as PERSON_SEQUENTIAL, PERSON.FL_NAME as PERSON_NAME, PERSON.DT_BIRTHDATE as PERSON_BIRTHDATE, PERSON.TX_EMAIL as PERSON_EMAIL, PERSON.TX_PASSWORD as PERSON_PASSWORD'; 
var
  oIModel: IModel<TEPerson>;
  fRPreparedFields: RFieldsPrepared;
begin
  oIModel := TPerson.Create;
  SetLength(fRPreparedFields.Fields, 1);
  SetLength(fRPreparedFields.FieldsAlias, 1);
  fRPreparedFields.Fields[0] := 'NR_SEQUENTIAL';
  fRPreparedFields.FieldsAlias[0] := 'PERSON_SEQUENTIAL';  
  fRPreparedFields.TableAlias := 'PERSON';

  CheckEquals(sQuery, TSQLSelect.Create.Ref.Fields([fRPreparedFields]).Build);

  SetLength(fRPreparedFields.Fields, 5);
  SetLength(fRPreparedFields.FieldsAlias, 5);
  fRPreparedFields.Fields[0] := 'NR_SEQUENTIAL';
  fRPreparedFields.Fields[1] := 'FL_NAME';
  fRPreparedFields.Fields[2] := 'DT_BIRTHDATE';
  fRPreparedFields.Fields[3] := 'TX_EMAIL';
  fRPreparedFields.Fields[4] := 'TX_PASSWORD';
  fRPreparedFields.FieldsAlias[0] := 'PERSON_SEQUENTIAL';
  fRPreparedFields.FieldsAlias[1] := 'PERSON_NAME';
  fRPreparedFields.FieldsAlias[2] := 'PERSON_BIRTHDATE';
  fRPreparedFields.FieldsAlias[3] := 'PERSON_EMAIL';
  fRPreparedFields.FieldsAlias[4] := 'PERSON_PASSWORD';
  fRPreparedFields.TableAlias := 'PERSON';
  
  CheckEquals(sQueryExpected, TSQLSelect.Create.Ref.Fields([fRPreparedFields]).Build);  

  oIModel := TPerson.Create;
  oIModel.PrepareModel('', [tepSequential]);
  CheckEquals(sQuery, TSQLSelect.Create.Ref.Fields([oIModel.PreparedFields]).Build);

  oIModel.PrepareModel('', []);
  CheckEquals(sQueryExpected, TSQLSelect.Create.Ref.Fields([oIModel.PreparedFields]).Build);
end;



procedure TNowaTest.TestSQLSelectBuildFromWithFields;
begin

end;



procedure TNowaTest.TestSQLSelectBuildFromWithoutFields;
begin

end;

initialization

RegisterTest(TNowaTest.Suite);

end.

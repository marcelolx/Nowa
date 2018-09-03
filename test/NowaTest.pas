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
    procedure TestSQLSelectBuildFromWithFields;
    procedure TestSQLSelectBuildWhere;
    procedure TestBasicSelect;
    procedure TestSQLWhereField;
    procedure TestSQLWhereEqual;
    procedure TestSQLWhereEqualValue;
    procedure TestSQLWhereDifferent;
    procedure TestSQLWhereDifferentValue;
    procedure TestSQLWhereGreater;
    procedure TestSQLWhereGreaterValue;
    procedure TestSQLWhereGreaterOrEqual;
    procedure TestSQLWhereGreaterOrEqualValue;
    procedure TestSQLWhereLess;
    procedure TestSQLWhereLessValue;
    procedure TestSQLWhereLessOrEqual;
    procedure TestSQLWhereLessOrEqualValue;
    procedure TestSQLCommandInsert;
    procedure TestSQLCommandUpdate;
    procedure TestSQLCommandUpdateWhereKey;
    procedure TestSQLCommandDelete;
    procedure TestSQLCommandDeleteWhere;
    procedure TestSQLCommandDoInsert;
    procedure TestSQLCommandNewKeyValue;
  end;

implementation

uses
  NowaImpl,
  Nowa.Model,
  Nowa.Records,
  Enumerator.Person,
  PersonImpl,
  System.SysUtils,
  Enumerator.Matriculation,
  MatriculationImpl;

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



procedure TNowaTest.TestSQLCommandDelete;
const
  sDelete = 'delete from tb_person';
var
  oIPerson: IModel<TEPerson>;
begin
  oIPerson := TPerson.Create;
  oIPerson.PrepareModel('', []);

  CheckEquals(sDelete,
    TSQLCommand<TEPerson>.Create.Ref
      .Delete(oIPerson)
      .Build
  );
end;



procedure TNowaTest.TestSQLCommandDeleteWhere;
const
  sDelete = 'delete from tb_person where nr_sequential = :PERSON_SEQUENTIAL';
var
  oIPerson: IModel<TEPerson>;
begin
  oIPerson := TPerson.Create;
  oIPerson.PrepareModel('', []);

  CheckEquals(sDelete,
    TSQLCommand<TEPerson>.Create.Ref
      .Delete(oIPerson)
      .WhereKey(oIPerson, tepSequential)
      .Build
  );
end;



procedure TNowaTest.TestSQLCommandDoInsert;
var
  oIPerson: IModel<TEPerson>;
begin
  oIPerson := TPerson.Create;
  oIPerson.PrepareModel('', []);

  CheckTrue(TSQLCommand<TEPerson>.Create.Ref.DoInsert(oIPerson, tepSequential));

  oIPerson.SetValue(tepSequential, 1);
  CheckFalse(TSQLCommand<TEPerson>.Create.Ref.DoInsert(oIPerson, tepSequential));
end;



procedure TNowaTest.TestSQLCommandInsert;
const
  sInsert = 'insert into tb_person (nr_sequential, fl_name, dt_birthdate, tx_email, tx_password) values (:PERSON_SEQUENTIAL, :PERSON_NAME, :PERSON_BIRTHDATE, :PERSON_EMAIL, :PERSON_PASSWORD)';
var
  oIPerson: IModel<TEPerson>;
begin
  oIPerson := TPerson.Create;
  oIPerson.PrepareModel('', []);

  CheckEquals(sInsert,
    TSQLCommand<TEPerson>.Create.Ref
      .Insert(oIPerson)
      .Build
  );
end;



procedure TNowaTest.TestSQLCommandNewKeyValue;
const
  sSequence = 'select nextval(''gen_person'') as sequence';
var
  oIPerson: IModel<TEPerson>;
begin
  oIPerson := TPerson.Create;
  oIPerson.PrepareModel('', []);

  CheckEquals(sSequence,
    TSQLCommand<TEPerson>.Create.Ref
      .NewKeyValue(oIPerson.Sequence)
      .Build
  );
end;



procedure TNowaTest.TestSQLCommandUpdate;
const
  sUpdate = 'update tb_person set nr_sequential = :PERSON_SEQUENTIAL, fl_name = :PERSON_NAME, dt_birthdate = :PERSON_BIRTHDATE, tx_email = :PERSON_EMAIL, tx_password = :PERSON_PASSWORD';
var
  oIPerson: IModel<TEPerson>;
begin
  oIPerson := TPerson.Create;
  oIPerson.PrepareModel('', []);

  CheckEquals(sUpdate,
    TSQLCommand<TEPerson>.Create.Ref
      .Update(oIPerson)
      .Build
  );
end;



procedure TNowaTest.TestSQLCommandUpdateWhereKey;
const
  sUpdate = 'update tb_person set nr_sequential = :PERSON_SEQUENTIAL, fl_name = :PERSON_NAME, dt_birthdate = :PERSON_BIRTHDATE,' +
    ' tx_email = :PERSON_EMAIL, tx_password = :PERSON_PASSWORD where nr_sequential = :PERSON_SEQUENTIAL';
var
  oIPerson: IModel<TEPerson>;
begin
  oIPerson := TPerson.Create;
  oIPerson.PrepareModel('', []);

  CheckEquals(sUpdate,
    TSQLCommand<TEPerson>.Create.Ref
      .Update(oIPerson)
      .WhereKey(oIPerson, tepSequential)
      .Build
  );
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
  oIPerson: IModel<TEPerson>;
  fRPreparedFields: RFieldsPrepared;
begin
  oIPerson := TPerson.Create;
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

  oIPerson := TPerson.Create;
  oIPerson.PrepareModel('', [tepSequential]);
  CheckEquals(sQuery, TSQLSelect.Create.Ref.Fields([oIPerson.PreparedFields]).Build);

  oIPerson.PrepareModel('', []);
  CheckEquals(sQueryExpected, TSQLSelect.Create.Ref.Fields([oIPerson.PreparedFields]).Build);
end;



procedure TNowaTest.TestSQLSelectBuildFromWithFields;
const
  sQuery = 'select PERSON.NR_SEQUENTIAL as PERSON_SEQUENTIAL from TB_PERSON as PERSON';
  sQueryExpected = 'select PERSON.NR_SEQUENTIAL as PERSON_SEQUENTIAL, PERSON.FL_NAME as PERSON_NAME, PERSON.DT_BIRTHDATE as PERSON_BIRTHDATE, PERSON.TX_EMAIL as PERSON_EMAIL, PERSON.TX_PASSWORD as PERSON_PASSWORD from TB_PERSON as PERSON';
var
  oIPerson: IModel<TEPerson>;
  fRPreparedFields: RFieldsPrepared;
begin
  oIPerson := TPerson.Create;
  SetLength(fRPreparedFields.Fields, 1);
  SetLength(fRPreparedFields.FieldsAlias, 1);
  fRPreparedFields.Fields[0] := 'NR_SEQUENTIAL';
  fRPreparedFields.FieldsAlias[0] := 'PERSON_SEQUENTIAL';
  fRPreparedFields.TableAlias := 'PERSON';

  CheckEquals(sQuery,
    TSQLSelect.Create.Ref
      .Fields([fRPreparedFields])
      .From('TB_PERSON', fRPreparedFields.TableAlias)
      .Build);

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

  CheckEquals(sQueryExpected,
    TSQLSelect.Create.Ref
      .Fields([fRPreparedFields])
      .From('TB_PERSON', fRPreparedFields.TableAlias)
      .Build);

  oIPerson := TPerson.Create;
  oIPerson.PrepareModel('', [tepSequential]);
  CheckEquals(sQuery,
    TSQLSelect.Create.Ref
      .Fields([oIPerson.PreparedFields])
      .From(oIPerson.Table, oIPerson.TableAlias)
      .Build);

  oIPerson.PrepareModel('', []);
  CheckEquals(sQueryExpected,
    TSQLSelect.Create.Ref
      .Fields([oIPerson.PreparedFields])
      .From(oIPerson.Table, oIPerson.TableAlias)
      .Build);
end;



procedure TNowaTest.TestSQLSelectBuildWhere;
const
  sQuery = 'select PERSON.NR_SEQUENTIAL as PERSON_SEQUENTIAL from TB_PERSON as PERSON where PERSON.NR_SEQUENTIAL = 1';
  sQueryExpected = 'select PERSON.NR_SEQUENTIAL as PERSON_SEQUENTIAL, PERSON.FL_NAME as PERSON_NAME, PERSON.DT_BIRTHDATE as PERSON_BIRTHDATE, PERSON.TX_EMAIL as PERSON_EMAIL, PERSON.TX_PASSWORD as PERSON_PASSWORD from TB_PERSON as PERSON where PERSON.NR_SEQUENTIAL = 1';
var
  oIPerson: IModel<TEPerson>;
  fRPreparedFields: RFieldsPrepared;
begin
  oIPerson := TPerson.Create;
  SetLength(fRPreparedFields.Fields, 1);
  SetLength(fRPreparedFields.FieldsAlias, 1);
  fRPreparedFields.Fields[0] := 'NR_SEQUENTIAL';
  fRPreparedFields.FieldsAlias[0] := 'PERSON_SEQUENTIAL';
  fRPreparedFields.TableAlias := 'PERSON';

  CheckEquals(sQuery,
    TSQLSelect.Create.Ref
      .Fields([fRPreparedFields])
      .From('TB_PERSON', fRPreparedFields.TableAlias)
      .Where(
        TSQLWhere.Create.Ref
          .Field(fRPreparedFields.TableAlias, fRPreparedFields.Fields[0])
          .Equal(1)
      )
      .Build
    );

  oIPerson.PrepareModel('', [tepSequential]);
  CheckEquals(sQuery,
    TSQLSelect.Create.Ref
      .Fields([oIPerson.PreparedFields])
      .From(oIPerson.Table, fRPreparedFields.TableAlias)
      .Where(
        TSQLWhere.Create.Ref
          .Field(oIPerson.TableAlias, oIPerson.FieldName(tepSequential))
          .Equal(1)
      )
      .Build
  );

  oIPerson.PrepareModel('', []);
  CheckEquals(sQueryExpected,
    TSQLSelect.Create.Ref
      .Fields([oIPerson.PreparedFields])
      .From(oIPerson.Table, fRPreparedFields.TableAlias)
      .Where(
        TSQLWhere.Create.Ref
          .Field(oIPerson.TableAlias, oIPerson.FieldName(tepSequential))
          .Equal(1)
      )
      .Build
  );
end;



procedure TNowaTest.TestSQLWhereDifferent;
const
  sQuery = ' where  <> ';
  sQuery2 = ' where T.EXAMPLE <> ';
  sQuery3 = ' where T1.EXAMPLE <> T2.EXAMPLE';
  sQuery4 = ' where PERSON.NR_SEQUENTIAL <> MATRICULATION.NR_PERSONSEQUENTIAL';
var
  oIPerson: IModel<TEPerson>;
  oIMatriculation: IModel<TEMatriculation>;
begin
  CheckEquals(sQuery,
    TSQLWhere.Create.Ref
      .Different
      .Build
  );

  CheckEquals(sQuery2,
    TSQLWhere.Create.Ref
      .Field('T', 'EXAMPLE')
      .Different
      .Build
  );

  CheckEquals(sQuery3,
    TSQLWhere.Create.Ref
      .Field('T1', 'EXAMPLE')
      .Different
      .Field('T2', 'EXAMPLE')
      .Build
  );


  oIPerson := TPerson.Create;
  oIMatriculation := TMatriculation.Create;
  oIPerson.PrepareModel('', []);
  oIMatriculation.PrepareModel('', []);
  CheckEquals(sQuery4,
    TSQLWhere.Create.Ref
      .Field(oIPerson.TableAlias, oIPerson.FieldName(tepSequential))
      .Different
      .Field(oIMatriculation.TableAlias, oIMatriculation.FieldName(temPersonSequential))
      .Build
  );

end;



procedure TNowaTest.TestSQLWhereDifferentValue;
const
  sQuery1 = ' where T.EXAMPLE <> 1';
  sQuery2 = ' where T.EXAMPLE <> ''ABC''';
  sQuery3 = ' where PERSON.NR_SEQUENTIAL <> 1';
var
  oIPerson: IModel<TEPerson>;
begin
  CheckEquals(sQuery1,
    TSQLWhere.Create.Ref
      .Field('T', 'EXAMPLE')
      .Different(1)
      .Build
  );

  CheckEquals(sQuery2,
    TSQLWhere.Create.Ref
      .Field('T', 'EXAMPLE')
      .Different(QuotedStr('ABC'))
      .Build
  );

  oIPerson := TPerson.Create;
  oIPerson.PrepareModel('', []);
  CheckEquals(sQuery3,
    TSQLWhere.Create.Ref
      .Field(oIPerson.TableAlias, oIPerson.FieldName(tepSequential))
      .Different(1)
      .Build
  );
end;



procedure TNowaTest.TestSQLWhereEqual;
const
  sQuery = ' where  = ';
  sQuery2 = ' where T.EXAMPLE = ';
begin
  CheckEquals(sQuery,
    TSQLWhere.Create.Ref
      .Equal
      .Build
  );

  CheckEquals(sQuery2,
    TSQLWhere.Create.Ref
      .Field('T', 'EXAMPLE')
      .Equal
      .Build
  );
end;



procedure TNowaTest.TestSQLWhereEqualValue;
const
  sQuery = ' where  = 1';
  sQuery2 = ' where  = ''ABC''';
  sQuery3 = ' where T.EXAMPLEVAL = 1';
  sQuery4 = ' where T.EXAMPLEVAL = ''ABC''';
  sQuery5 = ' where T1.EXAMPLE = T2.EXAMPLE';
  sQuery6 = ' where PERSON.NR_SEQUENTIAL = 1';
  sQuery7 = ' where PERSON.NR_SEQUENTIAL = MATRICULATION.NR_PERSONSEQUENTIAL';
var
  oIPerson: IModel<TEPerson>;
  oIMatriculation: IModel<TEMatriculation>;
begin
  CheckEquals(sQuery,
    TSQLWhere.Create.Ref
    .Equal(1)
    .Build
  );

  CheckEquals(sQuery2,
    TSQLWhere.Create.Ref
    .Equal(QuotedStr('ABC'))
    .Build
  );

  CheckEquals(sQuery3,
    TSQLWhere.Create.Ref
    .Field('T', 'EXAMPLEVAL')
    .Equal(1)
    .Build
  );

  CheckEquals(sQuery4,
    TSQLWhere.Create.Ref
    .Field('T', 'EXAMPLEVAL')
    .Equal(QuotedStr('ABC'))
    .Build
  );

  CheckEquals(sQuery5,
    TSQLWhere.Create.Ref
    .Field('T1', 'EXAMPLE')
    .Equal
    .Field('T2', 'EXAMPLE')
    .Build
  );

  oIPerson := TPerson.Create;
  oIPerson.PrepareModel('', []);
  CheckEquals(sQuery6,
    TSQLWhere.Create.Ref
    .Field(oIPerson.TableAlias, oIPerson.FieldName(tepSequential))
    .Equal(1)
    .Build
  );

  oIMatriculation := TMatriculation.Create;
  oIPerson.PrepareModel('', []);
  oIMatriculation.PrepareModel('', []);
  CheckEquals(sQuery7,
    TSQLWhere.Create.Ref
      .Field(oIPerson.TableAlias, oIPerson.FieldName(tepSequential))
      .Equal
      .Field(oIMatriculation.TableAlias, oIMatriculation.FieldName(temPersonSequential))
      .Build
  );
end;



procedure TNowaTest.TestSQLWhereField;
const
  sQuery = ' where T.EXAMPLE';
  sQueryPerson = ' where PERSON.FL_NAME';
var
  oIPerson: IModel<TEPerson>;
begin
  CheckEquals(sQuery,
    TSQLWhere.Create.Ref
    .Field('T', 'EXAMPLE')
    .Build
  );

  oIPerson := TPerson.Create;
  oIPerson.PrepareModel('', []);
  CheckEquals(sQueryPerson,
    TSQLWhere.Create.Ref
    .Field(oIPerson.TableAlias, oIPerson.FieldName(tepName))
    .Build
  );
end;



procedure TNowaTest.TestSQLWhereGreater;
const
  sQuery1 = ' where T.EXAMPLE > ';
  sQuery2 = ' where T1.EXAMPLE > T2.EXAMPLE';
  sQuery3 = ' where PERSON.NR_SEQUENTIAL > MATRICULATION.NR_PERSONSEQUENTIAL';
var
  oIPerson: IModel<TEPerson>;
  oIMatriculation: IModel<TEMatriculation>;
begin
  CheckEquals(sQuery1,
    TSQLWhere.Create.Ref
      .Field('T', 'EXAMPLE')
      .Greater
      .Build
  );

  CheckEquals(sQuery2,
    TSQLWhere.Create.Ref
      .Field('T1', 'EXAMPLE')
      .Greater
      .Field('T2', 'EXAMPLE')
      .Build
  );

  oIPerson := TPerson.Create;
  oIMatriculation := TMatriculation.Create;
  oIPerson.PrepareModel('', []);
  oIMatriculation.PrepareModel('', []);
  CheckEquals(sQuery3,
    TSQLWhere.Create.Ref
      .Field(oIPerson.TableAlias, oIPerson.FieldName(tepSequential))
      .Greater
      .Field(oIMatriculation.TableAlias, oIMatriculation.FieldName(temPersonSequential))
      .Build
  );
end;



procedure TNowaTest.TestSQLWhereGreaterOrEqual;
const
  sQuery1 = ' where T.EXAMPLE >= ';
  sQuery2 = ' where T1.EXAMPLE >= T2.EXAMPLE';
  sQuery3 = ' where PERSON.NR_SEQUENTIAL >= MATRICULATION.NR_PERSONSEQUENTIAL';
var
  oIPerson: IModel<TEPerson>;
  oIMatriculation: IModel<TEMatriculation>;
begin
  CheckEquals(sQuery1,
    TSQLWhere.Create.Ref
      .Field('T', 'EXAMPLE')
      .GreaterOrEqual
      .Build
  );

  CheckEquals(sQuery2,
    TSQLWhere.Create.Ref
      .Field('T1', 'EXAMPLE')
      .GreaterOrEqual
      .Field('T2', 'EXAMPLE')
      .Build
  );

  oIPerson := TPerson.Create;
  oIMatriculation := TMatriculation.Create;
  oIPerson.PrepareModel('', []);
  oIMatriculation.PrepareModel('', []);
  CheckEquals(sQuery3,
    TSQLWhere.Create.Ref
      .Field(oIPerson.TableAlias, oIPerson.FieldName(tepSequential))
      .GreaterOrEqual
      .Field(oIMatriculation.TableAlias, oIMatriculation.FieldName(temPersonSequential))
      .Build
  );
end;



procedure TNowaTest.TestSQLWhereGreaterOrEqualValue;
const
  sQuery1 = ' where T.EXAMPLE >= 1';
  sQuery2 = ' where T.EXAMPLE >= ''ABC''';
  sQuery3 = ' where PERSON.NR_SEQUENTIAL >= 1';
var
  oIPerson: IModel<TEPerson>;
begin
  CheckEquals(sQuery1,
    TSQLWhere.Create.Ref
      .Field('T', 'EXAMPLE')
      .GreaterOrEqual(1)
      .Build
  );

  CheckEquals(sQuery2,
    TSQLWhere.Create.Ref
      .Field('T', 'EXAMPLE')
      .GreaterOrEqual(QuotedStr('ABC'))
      .Build
  );

  oIPerson := TPerson.Create;
  oIPerson.PrepareModel('', []);
  CheckEquals(sQuery3,
    TSQLWhere.Create.Ref
      .Field(oIPerson.TableAlias, oIPerson.FieldName(tepSequential))
      .GreaterOrEqual(1)
      .Build
  );
end;



procedure TNowaTest.TestSQLWhereGreaterValue;
const
  sQuery1 = ' where T.EXAMPLE > 1';
  sQuery2 = ' where T.EXAMPLE > ''ABC''';
  sQuery3 = ' where PERSON.NR_SEQUENTIAL > 1';
var
  oIPerson: IModel<TEPerson>;
begin
  CheckEquals(sQuery1,
    TSQLWhere.Create.Ref
      .Field('T', 'EXAMPLE')
      .Greater(1)
      .Build
  );

  CheckEquals(sQuery2,
    TSQLWhere.Create.Ref
      .Field('T', 'EXAMPLE')
      .Greater(QuotedStr('ABC'))
      .Build
  );

  oIPerson := TPerson.Create;
  oIPerson.PrepareModel('', []);
  CheckEquals(sQuery3,
    TSQLWhere.Create.Ref
      .Field(oIPerson.TableAlias, oIPerson.FieldName(tepSequential))
      .Greater(1)
      .Build
  );
end;



procedure TNowaTest.TestSQLWhereLess;
const
  sQuery1 = ' where T.EXAMPLE < ';
  sQuery2 = ' where T1.EXAMPLE < T2.EXAMPLE';
  sQuery3 = ' where PERSON.NR_SEQUENTIAL < MATRICULATION.NR_PERSONSEQUENTIAL';
var
  oIPerson: IModel<TEPerson>;
  oIMatriculation: IModel<TEMatriculation>;
begin
  CheckEquals(sQuery1,
    TSQLWhere.Create.Ref
      .Field('T', 'EXAMPLE')
      .Less
      .Build
  );

  CheckEquals(sQuery2,
    TSQLWhere.Create.Ref
      .Field('T1', 'EXAMPLE')
      .Less
      .Field('T2', 'EXAMPLE')
      .Build
  );

  oIPerson := TPerson.Create;
  oIMatriculation := TMatriculation.Create;
  oIPerson.PrepareModel('', []);
  oIMatriculation.PrepareModel('', []);
  CheckEquals(sQuery3,
    TSQLWhere.Create.Ref
      .Field(oIPerson.TableAlias, oIPerson.FieldName(tepSequential))
      .Less
      .Field(oIMatriculation.TableAlias, oIMatriculation.FieldName(temPersonSequential))
      .Build
  );
end;



procedure TNowaTest.TestSQLWhereLessOrEqual;
const
  sQuery1 = ' where T.EXAMPLE <= ';
  sQuery2 = ' where T1.EXAMPLE <= T2.EXAMPLE';
  sQuery3 = ' where PERSON.NR_SEQUENTIAL <= MATRICULATION.NR_PERSONSEQUENTIAL';
var
  oIPerson: IModel<TEPerson>;
  oIMatriculation: IModel<TEMatriculation>;
begin
  CheckEquals(sQuery1,
    TSQLWhere.Create.Ref
      .Field('T', 'EXAMPLE')
      .LessOrEqual
      .Build
  );

  CheckEquals(sQuery2,
    TSQLWhere.Create.Ref
      .Field('T1', 'EXAMPLE')
      .LessOrEqual
      .Field('T2', 'EXAMPLE')
      .Build
  );

  oIPerson := TPerson.Create;
  oIMatriculation := TMatriculation.Create;
  oIPerson.PrepareModel('', []);
  oIMatriculation.PrepareModel('', []);
  CheckEquals(sQuery3,
    TSQLWhere.Create.Ref
      .Field(oIPerson.TableAlias, oIPerson.FieldName(tepSequential))
      .LessOrEqual
      .Field(oIMatriculation.TableAlias, oIMatriculation.FieldName(temPersonSequential))
      .Build
  );
end;


procedure TNowaTest.TestSQLWhereLessOrEqualValue;
const
  sQuery1 = ' where T.EXAMPLE <= 1';
  sQuery2 = ' where T.EXAMPLE <= ''ABC''';
  sQuery3 = ' where PERSON.NR_SEQUENTIAL <= 1';
var
  oIPerson: IModel<TEPerson>;
begin
  CheckEquals(sQuery1,
    TSQLWhere.Create.Ref
      .Field('T', 'EXAMPLE')
      .LessOrEqual(1)
      .Build
  );

  CheckEquals(sQuery2,
    TSQLWhere.Create.Ref
      .Field('T', 'EXAMPLE')
      .LessOrEqual(QuotedStr('ABC'))
      .Build
  );

  oIPerson := TPerson.Create;
  oIPerson.PrepareModel('', []);
  CheckEquals(sQuery3,
    TSQLWhere.Create.Ref
      .Field(oIPerson.TableAlias, oIPerson.FieldName(tepSequential))
      .LessOrEqual(1)
      .Build
  );
end;



procedure TNowaTest.TestSQLWhereLessValue;
const
  sQuery1 = ' where T.EXAMPLE < 1';
  sQuery2 = ' where T.EXAMPLE < ''ABC''';
  sQuery3 = ' where PERSON.NR_SEQUENTIAL < 1';
var
  oIPerson: IModel<TEPerson>;
begin
  CheckEquals(sQuery1,
    TSQLWhere.Create.Ref
      .Field('T', 'EXAMPLE')
      .Less(1)
      .Build
  );

  CheckEquals(sQuery2,
    TSQLWhere.Create.Ref
      .Field('T', 'EXAMPLE')
      .Less(QuotedStr('ABC'))
      .Build
  );

  oIPerson := TPerson.Create;
  oIPerson.PrepareModel('', []);
  CheckEquals(sQuery3,
    TSQLWhere.Create.Ref
      .Field(oIPerson.TableAlias, oIPerson.FieldName(tepSequential))
      .Less(1)
      .Build
  );
end;



initialization

RegisterTest(TNowaTest.Suite);

end.

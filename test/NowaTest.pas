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
    procedure TestSQLSelect;
    procedure TestSQLSelectFields;
    procedure TestSQLSelectFromWithFields;
    procedure TestSQLSelectWhere;
    procedure TestSQLSelectHaving;
    procedure TestSQLSelectGroupBy;
    procedure TestSQLSelectUnion;
    procedure TestSQLSelectUnionAll;
    procedure TestSQLSelectInnerJoin;
    procedure TestSQLSelectLeftJoin;
    procedure TestSQLSelectLeftOuterJoin;
    procedure TestSQLSelectRightJoin;
    procedure TestSQLSelectRightOuterJoin;

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
    procedure TestSQLWhereLike;
    procedure TestSQLWhereNotLike;
    procedure TestSQLWhereIsNull;
    procedure TestSQLWhereIsNotNull;
    procedure TestSQLWhereInList;
    procedure TestSQLWhereNot;
    procedure TestSQLWhereNotInList;
    procedure TestSQLGroupByColumn;
    procedure TestSQLGroupByColumns;
    procedure TestSQLConditionLeftTerm;
    procedure TestSQLConditionRightTerm;
    procedure TestSQLConditionOp;
    procedure TestSQLJoinTable;
    procedure TestSQLJoinOn;
    procedure TestSQLJoinAnd;
    procedure TestSQLJoinOr;
    procedure TestSQLCommandInsert;
    procedure TestSQLCommandUpdate;
    procedure TestSQLCommandUpdateWhereKey;
    procedure TestSQLCommandDelete;
    procedure TestSQLCommandDeleteWhere;
    procedure TestSQLCommandNewKeyValue;
    procedure TestSQLCommandFind;
    procedure TestSQLCommandExists;
  end;

implementation

uses
  NowaImpl,
  Nowa.Model,
  Nowa.ModelImpl,
  Nowa.Enumerators,
  Enumerator.Person,
  PersonImpl,
  System.SysUtils,
  Enumerator.Matriculation,
  MatriculationImpl,
  Person;

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
  sQueryExpected = 'select PERSON.NR_SEQUENTIAL as PERSON_NR_SEQUENTIAL, PERSON.FL_NAME as PERSON_FL_NAME, PERSON.DT_BIRTHDATE as PERSON_DT_BIRTHDATE, PERSON.TX_EMAIL as PERSON_TX_EMAIL, PERSON.TX_PASSWORD as PERSON_TX_PASSWORD from TB_PERSON as PERSON';
  sQueryExpected2 = 'select PERSON.NR_SEQUENTIAL as PERSON_NR_SEQUENTIAL from TB_PERSON as PERSON';
var
  fIModel: IModel<TEPerson>;
  sQuery: String;
begin
  fIModel := TPerson.Create;
  fIModel.PrepareModel('', []);

  sQuery := TSQLSelect.Create.Ref
    .Fields([fIModel.Fields])
    .From(fIModel.Table)
    .Build;

  CheckEquals(sQueryExpected, sQuery);

  fIModel.PrepareModel('', [tepSequential]);

  sQuery := TSQLSelect.Create.Ref
    .Fields([fIModel.Fields])
    .From(fIModel.Table)
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
  sDelete = 'delete from tb_person where nr_sequential = :PERSON_NR_SEQUENTIAL';
var
  oIPerson: IModel<TEPerson>;
begin
  oIPerson := TPerson.Create;
  oIPerson.PrepareModel('', []);

  CheckEquals(sDelete,
    TSQLCommand<TEPerson>.Create.Ref
      .Delete(oIPerson)
      .WhereKey(oIPerson, [tepSequential])
      .Build
  );
end;



procedure TNowaTest.TestSQLCommandExists;
var
  oIPerson: IModel<TEPerson>;
begin
  oIPerson := TPerson.Create;
  oIPerson.PrepareModel('', []);

  CheckEquals('not implemented',
    TSQLCommand<TEPerson>.Create.Ref
      .Exists(oIPerson, [tepSequential])
      .Build
  );
end;



procedure TNowaTest.TestSQLCommandFind;
const
  sFind = 'select PERSON.NR_SEQUENTIAL as PERSON_NR_SEQUENTIAL, PERSON.FL_NAME as PERSON_FL_NAME, PERSON.DT_BIRTHDATE as PERSON_DT_BIRTHDATE,' +
    ' PERSON.TX_EMAIL as PERSON_TX_EMAIL, PERSON.TX_PASSWORD as PERSON_TX_PASSWORD from TB_PERSON as PERSON where PERSON.NR_SEQUENTIAL = 1';
var
  oIPerson: IModel<TEPerson>;
begin
  oIPerson := TPerson.Create;
  oIPerson.PrepareModel('', []);

  CheckEquals(sFind,
    TSQLCommand<TEPerson>.Create.Ref
      .Find(oIPerson, tepSequential , 1)
      .Build
  );
end;



procedure TNowaTest.TestSQLCommandInsert;
const
  sInsert = 'insert into tb_person (nr_sequential, fl_name, dt_birthdate, tx_email, tx_password) values (:PERSON_NR_SEQUENTIAL, :PERSON_FL_NAME, :PERSON_DT_BIRTHDATE, :PERSON_TX_EMAIL, :PERSON_TX_PASSWORD)';
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
      .NewKeyValue(oIPerson.Table.Sequence)
      .Build
  );
end;



procedure TNowaTest.TestSQLCommandUpdate;
const
  sUpdate = 'update tb_person set nr_sequential = :PERSON_NR_SEQUENTIAL, fl_name = :PERSON_FL_NAME, dt_birthdate = :PERSON_DT_BIRTHDATE, tx_email = :PERSON_TX_EMAIL, tx_password = :PERSON_TX_PASSWORD';
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
  sUpdate = 'update tb_person set nr_sequential = :PERSON_NR_SEQUENTIAL, fl_name = :PERSON_FL_NAME, dt_birthdate = :PERSON_DT_BIRTHDATE,' +
    ' tx_email = :PERSON_TX_EMAIL, tx_password = :PERSON_TX_PASSWORD where nr_sequential = :PERSON_NR_SEQUENTIAL';
var
  oIPerson: IModel<TEPerson>;
begin
  oIPerson := TPerson.Create;
  oIPerson.PrepareModel('', []);

  CheckEquals(sUpdate,
    TSQLCommand<TEPerson>.Create.Ref
      .Update(oIPerson)
      .WhereKey(oIPerson, [tepSequential])
      .Build
  );
end;



procedure TNowaTest.TestSQLConditionLeftTerm;
begin
  CheckTrue(False, 'TestSQLConditionLeftTerm not implemented');
end;



procedure TNowaTest.TestSQLConditionOp;
begin
  CheckTrue(False, 'TestSQLConditionOp not implemented');
end;



procedure TNowaTest.TestSQLConditionRightTerm;
begin
  CheckTrue(False, 'TestSQLConditionRightTerm not implemented');
end;



procedure TNowaTest.TestSQLGroupByColumn;
begin
  CheckTrue(False, 'TestSQLGroupByColumn not implemented');
end;



procedure TNowaTest.TestSQLGroupByColumns;
begin
  CheckTrue(False, 'TestSQLGroupByColumns not implemented');
end;



procedure TNowaTest.TestSQLJoinAnd;
begin
  CheckTrue(False);
end;



procedure TNowaTest.TestSQLJoinOn;
begin
  CheckTrue(False);
end;



procedure TNowaTest.TestSQLJoinOr;
begin
  CheckTrue(False);
end;



procedure TNowaTest.TestSQLJoinTable;
begin
  CheckTrue(False);
end;



procedure TNowaTest.TestSQLSelect;
begin
  CheckEquals('select', TSQLSelect.Create.Ref.Build);
end;



procedure TNowaTest.TestSQLSelectFields;
const
  sQuery = 'select PERSON.NR_SEQUENTIAL as PERSON_NR_SEQUENTIAL';
  sQueryExpected = 'select PERSON.NR_SEQUENTIAL as PERSON_NR_SEQUENTIAL, PERSON.FL_NAME as PERSON_FL_NAME, PERSON.DT_BIRTHDATE as PERSON_DT_BIRTHDATE, PERSON.TX_EMAIL as PERSON_TX_EMAIL, PERSON.TX_PASSWORD as PERSON_TX_PASSWORD';
var
  oIPerson: IModel<TEPerson>;
  oITable: ITable;
  oIField: IField;
begin
  oITable := TTable.Create('TB_PERSON', 'GEN_PERSON');
  oITable.Prepare('PERSON');
  oIField := TField.Create('NR_SEQUENTIAL', oITable);

  CheckEquals(sQuery, TSQLSelect.Create.Ref.Fields([[oIField]]).Build);

  oIPerson := TPerson.Create;
  oIPerson.PrepareModel('', [tepSequential]);
  CheckEquals(sQuery, TSQLSelect.Create.Ref.Fields([oIPerson.Fields]).Build);

  oIPerson.PrepareModel('', []);
  CheckEquals(sQueryExpected, TSQLSelect.Create.Ref.Fields([oIPerson.Fields]).Build);
end;



procedure TNowaTest.TestSQLSelectFromWithFields;
const
  sQuery = 'select PERSON.NR_SEQUENTIAL as PERSON_NR_SEQUENTIAL from TB_PERSON as PERSON';
  sQueryExpected = 'select PERSON.NR_SEQUENTIAL as PERSON_NR_SEQUENTIAL, PERSON.FL_NAME as PERSON_FL_NAME, PERSON.DT_BIRTHDATE as PERSON_DT_BIRTHDATE, PERSON.TX_EMAIL as PERSON_TX_EMAIL, PERSON.TX_PASSWORD as PERSON_TX_PASSWORD from TB_PERSON as PERSON';
var
  oIPerson: IModel<TEPerson>;
begin
  oIPerson := TPerson.Create;

  oIPerson.PrepareModel('', [tepSequential]);
  CheckEquals(sQuery,
    TSQLSelect.Create.Ref
      .Fields([oIPerson.Fields])
      .From(oIPerson.Table)
      .Build);

  oIPerson.PrepareModel('', []);
  CheckEquals(sQueryExpected,
    TSQLSelect.Create.Ref
      .Fields([oIPerson.Fields])
      .From(oIPerson.Table)
      .Build);
end;



procedure TNowaTest.TestSQLSelectGroupBy;
begin
  Check(False, 'TestSQLSelectBuildGroupBy NOT IMPMPLEMENTED');
end;



procedure TNowaTest.TestSQLSelectHaving;
begin
  Check(False, 'TestSQLSelectBuildHaving NOT IMPMPLEMENTED');
end;



procedure TNowaTest.TestSQLSelectInnerJoin;
const
  sInnerJoin = 'select PERSON.NR_SEQUENTIAL as PERSON_NR_SEQUENTIAL,' +
                     ' PERSON.FL_NAME as PERSON_FL_NAME,' +
                     ' PERSON.DT_BIRTHDATE as PERSON_DT_BIRTHDATE,' +
                     ' PERSON.TX_EMAIL as PERSON_TX_EMAIL,' +
                     ' PERSON.TX_PASSWORD as PERSON_TX_PASSWORD,' +
                     ' MATRICULATION.NR_SEQUENTIAL as MATRICULATION_NR_SEQUENTIAL,' +
                     ' MATRICULATION.NR_PERSONSEQUENTIAL as MATRICULATION_NR_PERSONSEQUENTIAL,' +
                     ' MATRICULATION.DT_DATA as MATRICULATION_DT_DATA,' +
                     ' MATRICULATION.CD_USER as MATRICULATION_CD_USER' +
                ' from TB_PERSON as PERSON' +
               ' inner join TB_MATRICULATION as MATRICULATION on (MATRICULATION.NR_PERSONSEQUENTIAL = PERSON.NR_SEQUENTIAL)';
var
  oIPerson: IModel<TEPerson>;
  oIMatriculation: IModel<TEMatriculation>;
begin
  oIPerson := TPerson.Create;
  oIMatriculation := TMatriculation.Create;

  oIPerson.PrepareModel('', []);
  oIMatriculation.PrepareModel('', []);

  CheckEquals(sInnerJoin,
    TSQLSelect.Create.Ref
      .Fields([oIPerson.Fields, oIMatriculation.Fields])
      .From(oIPerson.Table)
      .InnerJoin(
        TSQLJoin.Create.Ref
          .Table(oIMatriculation.Table)
          .&On(
            TSQLCondition.Create.Ref
              .LeftTerm(oIMatriculation.Field(temPersonSequential))
              .Op(opEqual)
              .RightTerm(oIPerson.Field(tepSequential))
          )
      )
      .Build
  );
end;



procedure TNowaTest.TestSQLSelectLeftJoin;
const
  sInnerJoin = 'select PERSON.NR_SEQUENTIAL as PERSON_NR_SEQUENTIAL,' +
                     ' PERSON.FL_NAME as PERSON_FL_NAME,' +
                     ' PERSON.DT_BIRTHDATE as PERSON_DT_BIRTHDATE,' +
                     ' PERSON.TX_EMAIL as PERSON_TX_EMAIL,' +
                     ' PERSON.TX_PASSWORD as PERSON_TX_PASSWORD,' +
                     ' MATRICULATION.NR_SEQUENTIAL as MATRICULATION_NR_SEQUENTIAL,' +
                     ' MATRICULATION.NR_PERSONSEQUENTIAL as MATRICULATION_NR_PERSONSEQUENTIAL,' +
                     ' MATRICULATION.DT_DATA as MATRICULATION_DT_DATA,' +
                     ' MATRICULATION.CD_USER as MATRICULATION_CD_USER' +
                ' from TB_PERSON as PERSON' +
               ' left join TB_MATRICULATION as MATRICULATION on (MATRICULATION.NR_PERSONSEQUENTIAL = PERSON.NR_SEQUENTIAL)';
var
  oIPerson: IModel<TEPerson>;
  oIMatriculation: IModel<TEMatriculation>;
begin
  oIPerson := TPerson.Create;
  oIMatriculation := TMatriculation.Create;

  oIPerson.PrepareModel('', []);
  oIMatriculation.PrepareModel('', []);

  CheckEquals(sInnerJoin,
    TSQLSelect.Create.Ref
      .Fields([oIPerson.Fields, oIMatriculation.Fields])
      .From(oIPerson.Table)
      .LeftJoin(
        TSQLJoin.Create.Ref
          .Table(oIMatriculation.Table)
          .&On(
            TSQLCondition.Create.Ref
              .LeftTerm(oIMatriculation.Field(temPersonSequential))
              .Op(opEqual)
              .RightTerm(oIPerson.Field(tepSequential))
          )
      )
      .Build
  );
end;



procedure TNowaTest.TestSQLSelectLeftOuterJoin;
const
  sInnerJoin = 'select PERSON.NR_SEQUENTIAL as PERSON_NR_SEQUENTIAL,' +
                     ' PERSON.FL_NAME as PERSON_FL_NAME,' +
                     ' PERSON.DT_BIRTHDATE as PERSON_DT_BIRTHDATE,' +
                     ' PERSON.TX_EMAIL as PERSON_TX_EMAIL,' +
                     ' PERSON.TX_PASSWORD as PERSON_TX_PASSWORD,' +
                     ' MATRICULATION.NR_SEQUENTIAL as MATRICULATION_NR_SEQUENTIAL,' +
                     ' MATRICULATION.NR_PERSONSEQUENTIAL as MATRICULATION_NR_PERSONSEQUENTIAL,' +
                     ' MATRICULATION.DT_DATA as MATRICULATION_DT_DATA,' +
                     ' MATRICULATION.CD_USER as MATRICULATION_CD_USER' +
                ' from TB_PERSON as PERSON' +
               ' left outer join TB_MATRICULATION as MATRICULATION on (MATRICULATION.NR_PERSONSEQUENTIAL = PERSON.NR_SEQUENTIAL)';
var
  oIPerson: IModel<TEPerson>;
  oIMatriculation: IModel<TEMatriculation>;
begin
  oIPerson := TPerson.Create;
  oIMatriculation := TMatriculation.Create;

  oIPerson.PrepareModel('', []);
  oIMatriculation.PrepareModel('', []);

  CheckEquals(sInnerJoin,
    TSQLSelect.Create.Ref
      .Fields([oIPerson.Fields, oIMatriculation.Fields])
      .From(oIPerson.Table)
      .LeftOuterJoin(
        TSQLJoin.Create.Ref
          .Table(oIMatriculation.Table)
          .&On(
            TSQLCondition.Create.Ref
              .LeftTerm(oIMatriculation.Field(temPersonSequential))
              .Op(opEqual)
              .RightTerm(oIPerson.Field(tepSequential))
          )
      )
      .Build
  );
end;



procedure TNowaTest.TestSQLSelectRightJoin;
const
  sInnerJoin = 'select PERSON.NR_SEQUENTIAL as PERSON_NR_SEQUENTIAL,' +
                     ' PERSON.FL_NAME as PERSON_FL_NAME,' +
                     ' PERSON.DT_BIRTHDATE as PERSON_DT_BIRTHDATE,' +
                     ' PERSON.TX_EMAIL as PERSON_TX_EMAIL,' +
                     ' PERSON.TX_PASSWORD as PERSON_TX_PASSWORD,' +
                     ' MATRICULATION.NR_SEQUENTIAL as MATRICULATION_NR_SEQUENTIAL,' +
                     ' MATRICULATION.NR_PERSONSEQUENTIAL as MATRICULATION_NR_PERSONSEQUENTIAL,' +
                     ' MATRICULATION.DT_DATA as MATRICULATION_DT_DATA,' +
                     ' MATRICULATION.CD_USER as MATRICULATION_CD_USER' +
                ' from TB_PERSON as PERSON' +
               ' right join TB_MATRICULATION as MATRICULATION on (MATRICULATION.NR_PERSONSEQUENTIAL = PERSON.NR_SEQUENTIAL)';
var
  oIPerson: IModel<TEPerson>;
  oIMatriculation: IModel<TEMatriculation>;
begin
  oIPerson := TPerson.Create;
  oIMatriculation := TMatriculation.Create;

  oIPerson.PrepareModel('', []);
  oIMatriculation.PrepareModel('', []);

  CheckEquals(sInnerJoin,
    TSQLSelect.Create.Ref
      .Fields([oIPerson.Fields, oIMatriculation.Fields])
      .From(oIPerson.Table)
      .RightJoin(
        TSQLJoin.Create.Ref
          .Table(oIMatriculation.Table)
          .&On(
            TSQLCondition.Create.Ref
              .LeftTerm(oIMatriculation.Field(temPersonSequential))
              .Op(opEqual)
              .RightTerm(oIPerson.Field(tepSequential))
          )
      )
      .Build
  );
end;



procedure TNowaTest.TestSQLSelectRightOuterJoin;
const
  sInnerJoin = 'select PERSON.NR_SEQUENTIAL as PERSON_NR_SEQUENTIAL,' +
                     ' PERSON.FL_NAME as PERSON_FL_NAME,' +
                     ' PERSON.DT_BIRTHDATE as PERSON_DT_BIRTHDATE,' +
                     ' PERSON.TX_EMAIL as PERSON_TX_EMAIL,' +
                     ' PERSON.TX_PASSWORD as PERSON_TX_PASSWORD,' +
                     ' MATRICULATION.NR_SEQUENTIAL as MATRICULATION_NR_SEQUENTIAL,' +
                     ' MATRICULATION.NR_PERSONSEQUENTIAL as MATRICULATION_NR_PERSONSEQUENTIAL,' +
                     ' MATRICULATION.DT_DATA as MATRICULATION_DT_DATA,' +
                     ' MATRICULATION.CD_USER as MATRICULATION_CD_USER' +
                ' from TB_PERSON as PERSON' +
               ' right outer join TB_MATRICULATION as MATRICULATION on (MATRICULATION.NR_PERSONSEQUENTIAL = PERSON.NR_SEQUENTIAL)';
var
  oIPerson: IModel<TEPerson>;
  oIMatriculation: IModel<TEMatriculation>;
begin
  oIPerson := TPerson.Create;
  oIMatriculation := TMatriculation.Create;

  oIPerson.PrepareModel('', []);
  oIMatriculation.PrepareModel('', []);

  CheckEquals(sInnerJoin,
    TSQLSelect.Create.Ref
      .Fields([oIPerson.Fields, oIMatriculation.Fields])
      .From(oIPerson.Table)
      .RightOuterJoin(
        TSQLJoin.Create.Ref
          .Table(oIMatriculation.Table)
          .&On(
            TSQLCondition.Create.Ref
              .LeftTerm(oIMatriculation.Field(temPersonSequential))
              .Op(opEqual)
              .RightTerm(oIPerson.Field(tepSequential))
          )
      )
      .Build
  );
end;



procedure TNowaTest.TestSQLSelectUnion;
const
  sInnerJoin = 'select PERSON.NR_SEQUENTIAL as PERSON_NR_SEQUENTIAL,' +
                     ' PERSON.FL_NAME as PERSON_FL_NAME,' +
                     ' PERSON.DT_BIRTHDATE as PERSON_DT_BIRTHDATE,' +
                     ' PERSON.TX_EMAIL as PERSON_TX_EMAIL,' +
                     ' PERSON.TX_PASSWORD as PERSON_TX_PASSWORD,' +
                ' from TB_PERSON as PERSON' +
                ' where PERSON.FL_NAME = ''MARCELO''' +
                ' union' +
               ' select PERSON.NR_SEQUENTIAL as PERSON_NR_SEQUENTIAL,' +
                     ' PERSON.FL_NAME as PERSON_FL_NAME,' +
                     ' PERSON.DT_BIRTHDATE as PERSON_DT_BIRTHDATE,' +
                     ' PERSON.TX_EMAIL as PERSON_TX_EMAIL,' +
                     ' PERSON.TX_PASSWORD as PERSON_TX_PASSWORD,' +
                ' from TB_PERSON as PERSON' +
                ' where PERSON.FL_NAME = ''RANDOM''';
var
  oIPerson: IModel<TEPerson>;
begin
  oIPerson := TPerson.Create;
  oIPerson.PrepareModel('', []);

  CheckEquals(sInnerJoin,
    TSQLSelect.Create.Ref
      .Fields([oIPerson.Fields])
      .From(oIPerson.Table)
      .Where(
        TSQLWhere.Create.Ref
          .Field(oIPerson.Field(tepName))
          .Equal('MARCELO')
      )
      .Union
      .Fields([oIPerson.Fields])
      .From(oIPerson.Table)
      .Where(
        TSQLWhere.Create.Ref
          .Field(oIPerson.Field(tepName))
          .Equal('RANDOM')
      )
      .Build
  );
end;



procedure TNowaTest.TestSQLSelectUnionAll;
const
  sInnerJoin = 'select PERSON.NR_SEQUENTIAL as PERSON_NR_SEQUENTIAL,' +
                     ' PERSON.FL_NAME as PERSON_FL_NAME,' +
                     ' PERSON.DT_BIRTHDATE as PERSON_DT_BIRTHDATE,' +
                     ' PERSON.TX_EMAIL as PERSON_TX_EMAIL,' +
                     ' PERSON.TX_PASSWORD as PERSON_TX_PASSWORD,' +
                ' from TB_PERSON as PERSON' +
                ' where PERSON.FL_NAME = ''MARCELO''' +
                ' union all' +
               ' select PERSON.NR_SEQUENTIAL as PERSON_NR_SEQUENTIAL,' +
                     ' PERSON.FL_NAME as PERSON_FL_NAME,' +
                     ' PERSON.DT_BIRTHDATE as PERSON_DT_BIRTHDATE,' +
                     ' PERSON.TX_EMAIL as PERSON_TX_EMAIL,' +
                     ' PERSON.TX_PASSWORD as PERSON_TX_PASSWORD,' +
                ' from TB_PERSON as PERSON' +
                ' where PERSON.FL_NAME = ''RANDOM''';
var
  oIPerson: IModel<TEPerson>;
begin
  oIPerson := TPerson.Create;
  oIPerson.PrepareModel('', []);

  CheckEquals(sInnerJoin,
    TSQLSelect.Create.Ref
      .Fields([oIPerson.Fields])
      .From(oIPerson.Table)
      .Where(
        TSQLWhere.Create.Ref
          .Field(oIPerson.Field(tepName))
          .Equal('MARCELO')
      )
      .UnionAll
      .Fields([oIPerson.Fields])
      .From(oIPerson.Table)
      .Where(
        TSQLWhere.Create.Ref
          .Field(oIPerson.Field(tepName))
          .Equal('RANDOM')
      )
      .Build
  );
end;



procedure TNowaTest.TestSQLSelectWhere;
const
  sQuery = 'select PERSON.NR_SEQUENTIAL as PERSON_NR_SEQUENTIAL from TB_PERSON as PERSON where PERSON.NR_SEQUENTIAL = 1';
  sQueryExpected = 'select PERSON.NR_SEQUENTIAL as PERSON_NR_SEQUENTIAL, PERSON.FL_NAME' + ' as PERSON_FL_NAME, PERSON.DT_BIRTHDATE as PERSON_DT_BIRTHDATE, PERSON.TX_EMAIL as PERSON_TX_EMAIL, PERSON.TX_PASSWORD as PERSON_TX_PASSWORD from TB_PERSON as PERSON where PERSON.NR_SEQUENTIAL = 1';
var
  oIPerson: IModel<TEPerson>;
begin
  oIPerson := TPerson.Create;

  oIPerson.PrepareModel('', [tepSequential]);
  CheckEquals(sQuery,
    TSQLSelect.Create.Ref
      .Fields([oIPerson.Fields])
      .From(oIPerson.Table)
      .Where(
        TSQLWhere.Create.Ref
          .Field(oIPerson.Field(tepSequential))
          .Equal(1)
      )
      .Build
  );

  oIPerson.PrepareModel('', []);
  CheckEquals(sQueryExpected,
    TSQLSelect.Create.Ref
      .Fields([oIPerson.Fields])
      .From(oIPerson.Table)
      .Where(
        TSQLWhere.Create.Ref
          .Field(oIPerson.Field(tepSequential))
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
  oITable, oITable2: ITable;
begin
  oITable := TTable.Create('T', '');
  oITable.Prepare('T');

  CheckEquals(sQuery,
    TSQLWhere.Create.Ref
      .Different
      .Build
  );

  CheckEquals(sQuery2,
    TSQLWhere.Create.Ref
      .Field(TField.Create('EXAMPLE', oITable).Ref)
      .Different
      .Build
  );

  oITable2 := TTable.Create('T1', '');
  oITable2.Prepare('T1');
  oITable.Prepare('T2');

  CheckEquals(sQuery3,
    TSQLWhere.Create.Ref
      .Field(TField.Create('EXAMPLE', oITable2).Ref)
      .Different
      .Field(TField.Create('EXAMPLE', oITable).Ref)
      .Build
  );


  oIPerson := TPerson.Create;
  oIMatriculation := TMatriculation.Create;
  oIPerson.PrepareModel('', []);
  oIMatriculation.PrepareModel('', []);
  CheckEquals(sQuery4,
    TSQLWhere.Create.Ref
      .Field(oIPerson.Field(tepSequential))
      .Different
      .Field(oIMatriculation.Field(temPersonSequential))
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
  oITable: ITable;
begin
  oITable := TTable.Create('T', '');
  oITable.Prepare('T');

  CheckEquals(sQuery1,
    TSQLWhere.Create.Ref
      .Field(TField.Create('EXAMPLE', oITable).Ref)
      .Different(1)
      .Build
  );

  CheckEquals(sQuery2,
    TSQLWhere.Create.Ref
      .Field(TField.Create('EXAMPLE', oITable).Ref)
      .Different(QuotedStr('ABC'))
      .Build
  );

  oIPerson := TPerson.Create;
  oIPerson.PrepareModel('', []);
  CheckEquals(sQuery3,
    TSQLWhere.Create.Ref
      .Field(oIPerson.Field(tepSequential))
      .Different(1)
      .Build
  );
end;



procedure TNowaTest.TestSQLWhereEqual;
const
  sQuery = ' where  = ';
  sQuery2 = ' where T.EXAMPLE = ';
var
  oITable: ITable;
begin
  oITable := TTable.Create('T', '');
  oITable.Prepare('T');

  CheckEquals(sQuery,
    TSQLWhere.Create.Ref
      .Equal
      .Build
  );

  CheckEquals(sQuery2,
    TSQLWhere.Create.Ref
      .Field(TField.Create('EXAMPLE', oITable).Ref)
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
  oITable, oITable2: ITable;
begin
  oITable := TTable.Create('T', '');
  oITable.Prepare('T');

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
    .Field(TField.Create('EXAMPLEVAL', oITable).Ref)
    .Equal(1)
    .Build
  );

  CheckEquals(sQuery4,
    TSQLWhere.Create.Ref
    .Field(TField.Create('EXAMPLEVAL', oITable).Ref)
    .Equal(QuotedStr('ABC'))
    .Build
  );

  oITable2 := TTable.Create('T1', '');
  oITable2.Prepare('T1');
  oITable.Prepare('T2');

  CheckEquals(sQuery5,
    TSQLWhere.Create.Ref
    .Field(TField.Create('EXAMPLE', oITable2).Ref)
    .Equal
    .Field(TField.Create('EXAMPLE', oITable).Ref)
    .Build
  );

  oIPerson := TPerson.Create;
  oIPerson.PrepareModel('', []);
  CheckEquals(sQuery6,
    TSQLWhere.Create.Ref
    .Field(oIPerson.Field(tepSequential))
    .Equal(1)
    .Build
  );

  oIMatriculation := TMatriculation.Create;
  oIPerson.PrepareModel('', []);
  oIMatriculation.PrepareModel('', []);
  CheckEquals(sQuery7,
    TSQLWhere.Create.Ref
      .Field(oIPerson.Field(tepSequential))
      .Equal
      .Field(oIMatriculation.Field(temPersonSequential))
      .Build
  );
end;



procedure TNowaTest.TestSQLWhereField;
const
  sQuery = ' where T.EXAMPLE';
  sQueryPerson = ' where PERSON.FL_NAME';
var
  oIPerson: IModel<TEPerson>;
  oITable: ITable;
begin
  oITable := TTable.Create('T', '');
  oITable.Prepare('T');

  CheckEquals(sQuery,
    TSQLWhere.Create.Ref
    .Field(TField.Create('EXAMPLE', oITable))
    .Build
  );

  oIPerson := TPerson.Create;
  oIPerson.PrepareModel('', []);
  CheckEquals(sQueryPerson,
    TSQLWhere.Create.Ref
    .Field(oIPerson.Field(tepName))
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
  oITable, oITable2: ITable;
begin
  oITable := TTable.Create('T', '');
  oITable.Prepare('T');

  CheckEquals(sQuery1,
    TSQLWhere.Create.Ref
      .Field(TField.Create('EXAMPLE', oITable).Ref)
      .Greater
      .Build
  );


  oITable2 := TTable.Create('T1', '');
  oITable2.Prepare('T1');
  oITable.Prepare('T2');
  CheckEquals(sQuery2,
    TSQLWhere.Create.Ref
      .Field(TField.Create('EXAMPLE', oITable2).Ref)
      .Greater
      .Field(TField.Create('EXAMPLE', oITable).Ref)
      .Build
  );

  oIPerson := TPerson.Create;
  oIMatriculation := TMatriculation.Create;
  oIPerson.PrepareModel('', []);
  oIMatriculation.PrepareModel('', []);
  CheckEquals(sQuery3,
    TSQLWhere.Create.Ref
      .Field(oIPerson.Field(tepSequential))
      .Greater
      .Field(oIMatriculation.Field(temPersonSequential))
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
  oITable, oITable2: ITable;
begin
  oITable := TTable.Create('T', '');
  oITable.Prepare('T');

  CheckEquals(sQuery1,
    TSQLWhere.Create.Ref
      .Field(TField.Create('EXAMPLE', oITable).Ref)
      .GreaterOrEqual
      .Build
  );

  oITable2 := TTable.Create('T2', '');
  oITable2.Prepare('T2');
  oITable.Prepare('T1');

  CheckEquals(sQuery2,
    TSQLWhere.Create.Ref
      .Field(TField.Create('EXAMPLE', oITable).Ref)
      .GreaterOrEqual
      .Field(TField.Create('EXAMPLE', oITable2).Ref)
      .Build
  );

  oIPerson := TPerson.Create;
  oIMatriculation := TMatriculation.Create;
  oIPerson.PrepareModel('', []);
  oIMatriculation.PrepareModel('', []);
  CheckEquals(sQuery3,
    TSQLWhere.Create.Ref
      .Field(oIPerson.Field(tepSequential))
      .GreaterOrEqual
      .Field(oIMatriculation.Field(temPersonSequential))
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
  oITable: ITable;
begin
  oITable := TTable.Create('T', '');
  oITable.Prepare('T');

  CheckEquals(sQuery1,
    TSQLWhere.Create.Ref
      .Field(TField.Create('EXAMPLE', oITable).Ref)
      .GreaterOrEqual(1)
      .Build
  );

  CheckEquals(sQuery2,
    TSQLWhere.Create.Ref
      .Field(TField.Create('EXAMPLE', oITable).Ref)
      .GreaterOrEqual(QuotedStr('ABC'))
      .Build
  );

  oIPerson := TPerson.Create;
  oIPerson.PrepareModel('', []);
  CheckEquals(sQuery3,
    TSQLWhere.Create.Ref
      .Field(oIPerson.Field(tepSequential))
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
  oITable: ITable;
begin
  oITable := TTable.Create('T', '');
  oITable.Prepare('T');

  CheckEquals(sQuery1,
    TSQLWhere.Create.Ref
      .Field(TField.Create('EXAMPLE', oITable).Ref)
      .Greater(1)
      .Build
  );

  CheckEquals(sQuery2,
    TSQLWhere.Create.Ref
      .Field(TField.Create('EXAMPLE', oITable).Ref)
      .Greater(QuotedStr('ABC'))
      .Build
  );

  oIPerson := TPerson.Create;
  oIPerson.PrepareModel('', []);
  CheckEquals(sQuery3,
    TSQLWhere.Create.Ref
      .Field(oIPerson.Field(tepSequential))
      .Greater(1)
      .Build
  );
end;



procedure TNowaTest.TestSQLWhereInList;
var
  oIPerson: IModel<TEPerson>;
begin
  oIPerson := TPerson.Create;
  oIPerson.PrepareModel('', []);

  CheckEquals(' where PERSON.NR_SEQUENTIAL in (1,2,3,4)',
    TSQLWhere.Create.Ref
      .Field(oIPerson.Field(tepSequential))
      .InList([1,2,3,4])
      .Build
  );
end;



procedure TNowaTest.TestSQLWhereIsNotNull;
var
  oIPerson: IModel<TEPerson>;
begin
  oIPerson := TPerson.Create;
  oIPerson.PrepareModel('', []);

  CheckEquals('not implemented',
    TSQLWhere.Create.Ref
      .Field(oIPerson.Field(tepSequential))
      .IsNotNull
      .Build
  );
end;



procedure TNowaTest.TestSQLWhereIsNull;
var
  oIPerson: IModel<TEPerson>;
begin
  oIPerson := TPerson.Create;
  oIPerson.PrepareModel('', []);

  CheckEquals('not implemented',
    TSQLWhere.Create.Ref
      .Field(oIPerson.Field(tepSequential))
      .IsNull
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
  oITable, oITable2: ITable;
begin
  oITable := TTable.Create('T', '');
  oITable.Prepare('T');

  CheckEquals(sQuery1,
    TSQLWhere.Create.Ref
      .Field(TField.Create('EXAMPLE', oITable).Ref)
      .Less
      .Build
  );

  oITable2 := TTable.Create('T1', '');
  oITable2.Prepare('T1');
  oITable.Prepare('T2');

  CheckEquals(sQuery2,
    TSQLWhere.Create.Ref
      .Field(TField.Create('EXAMPLE', oITable2).Ref)
      .Less
      .Field(TField.Create('EXAMPLE', oITable).Ref)
      .Build
  );

  oIPerson := TPerson.Create;
  oIMatriculation := TMatriculation.Create;
  oIPerson.PrepareModel('', []);
  oIMatriculation.PrepareModel('', []);
  CheckEquals(sQuery3,
    TSQLWhere.Create.Ref
      .Field(oIPerson.Field(tepSequential))
      .Less
      .Field(oIMatriculation.Field(temPersonSequential))
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
  oITable, oITable2: ITable;
begin
  oITable := TTable.Create('T', '');
  oITable.Prepare('T');

  CheckEquals(sQuery1,
    TSQLWhere.Create.Ref
      .Field(TField.Create('EXAMPLE', oITable).Ref)
      .LessOrEqual
      .Build
  );

  oITable2 := TTable.Create('T1', '');
  oITable2.Prepare('T1');
  oITable.Prepare('T2');

  CheckEquals(sQuery2,
    TSQLWhere.Create.Ref
      .Field(TField.Create('EXAMPLE', oITable2).Ref)
      .LessOrEqual
      .Field(TField.Create('EXAMPLE', oITable).Ref)
      .Build
  );

  oIPerson := TPerson.Create;
  oIMatriculation := TMatriculation.Create;
  oIPerson.PrepareModel('', []);
  oIMatriculation.PrepareModel('', []);
  CheckEquals(sQuery3,
    TSQLWhere.Create.Ref
      .Field(oIPerson.Field(tepSequential))
      .LessOrEqual
      .Field(oIMatriculation.Field(temPersonSequential))
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
  oITable: ITable;
begin
  oITable := TTable.Create('T', '');
  oITable.Prepare('T');

  CheckEquals(sQuery1,
    TSQLWhere.Create.Ref
      .Field(TField.Create('EXAMPLE', oITable).Ref)
      .LessOrEqual(1)
      .Build
  );

  CheckEquals(sQuery2,
    TSQLWhere.Create.Ref
      .Field(TField.Create('EXAMPLE', oITable).Ref)
      .LessOrEqual(QuotedStr('ABC'))
      .Build
  );

  oIPerson := TPerson.Create;
  oIPerson.PrepareModel('', []);
  CheckEquals(sQuery3,
    TSQLWhere.Create.Ref
      .Field(oIPerson.Field(tepSequential))
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
  oITable: ITable;
begin
  oITable := TTable.Create('T', '');
  oITable.Prepare('T');

  CheckEquals(sQuery1,
    TSQLWhere.Create.Ref
      .Field(TField.Create('EXAMPLE', oITable).Ref)
      .Less(1)
      .Build
  );

  CheckEquals(sQuery2,
    TSQLWhere.Create.Ref
      .Field(TField.Create('EXAMPLE', oITable).Ref)
      .Less(QuotedStr('ABC'))
      .Build
  );

  oIPerson := TPerson.Create;
  oIPerson.PrepareModel('', []);
  CheckEquals(sQuery3,
    TSQLWhere.Create.Ref
      .Field(oIPerson.Field(tepSequential))
      .Less(1)
      .Build
  );
end;



procedure TNowaTest.TestSQLWhereLike;
var
  oIPerson: IModel<TEPerson>;
begin
  oIPerson := TPerson.Create;
  oIPerson.PrepareModel('', []);

  CheckEquals('not implemented',
    TSQLWhere.Create.Ref
      .Field(oIPerson.Field(tepName))
      .Like(loEqual, 'Marcelo')
      .Build
  );

  CheckEquals('not implemented',
    TSQLWhere.Create.Ref
      .Field(oIPerson.Field(tepName))
      .Like(loStarting, 'Marcelo')
      .Build
  );

  CheckEquals('not implemented',
    TSQLWhere.Create.Ref
      .Field(oIPerson.Field(tepName))
      .Like(loEnding, 'Marcelo')
      .Build
  );

  CheckEquals('not implemented',
    TSQLWhere.Create.Ref
      .Field(oIPerson.Field(tepName))
      .Like(loContaining, 'Marcelo')
      .Build
  );
end;



procedure TNowaTest.TestSQLWhereNot;
var
  oIPerson: IModel<TEPerson>;
begin
  oIPerson := TPerson.Create;
  oIPerson.PrepareModel('', []);

  CheckEquals(' where PERSON.NR_SEQUENTIAL not ',
    TSQLWhere.Create.Ref
      .Field(oIPerson.Field(tepSequential))
      .&Not
      .Build
  );
end;



procedure TNowaTest.TestSQLWhereNotInList;
var
  oIPerson: IModel<TEPerson>;
begin
  oIPerson := TPerson.Create;
  oIPerson.PrepareModel('', []);

  CheckEquals(' where PERSON.NR_SEQUENTIAL not  in (1,2,3,4)',
    TSQLWhere.Create.Ref
      .Field(oIPerson.Field(tepSequential))
      .&Not.InList([1,2,3,4])
      .Build
  );
end;



procedure TNowaTest.TestSQLWhereNotLike;
var
  oIPerson: IModel<TEPerson>;
begin
  oIPerson := TPerson.Create;
  oIPerson.PrepareModel('', []);

  CheckEquals('not implemented',
    TSQLWhere.Create.Ref
      .Field(oIPerson.Field(tepName))
      .NotLike(loEqual, 'Marcelo')
      .Build
  );

  CheckEquals('not implemented',
    TSQLWhere.Create.Ref
      .Field(oIPerson.Field(tepName))
      .NotLike(loStarting, 'Marcelo')
      .Build
  );

  CheckEquals('not implemented',
    TSQLWhere.Create.Ref
      .Field(oIPerson.Field(tepName))
      .NotLike(loEnding, 'Marcelo')
      .Build
  );

  CheckEquals('not implemented',
    TSQLWhere.Create.Ref
      .Field(oIPerson.Field(tepName))
      .NotLike(loContaining, 'Marcelo')
      .Build
  );
end;

initialization

RegisterTest(TNowaTest.Suite);

end.

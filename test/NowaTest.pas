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
  QueryExpected = 'select PERSON.NR_SEQUENTIAL as PERSON_NR_SEQUENTIAL, PERSON.FL_NAME as PERSON_FL_NAME, PERSON.DT_BIRTHDATE as PERSON_DT_BIRTHDATE, PERSON.TX_EMAIL as PERSON_TX_EMAIL, PERSON.TX_PASSWORD as PERSON_TX_PASSWORD from TB_PERSON as PERSON';
  QueryExpected2 = 'select PERSON.NR_SEQUENTIAL as PERSON_NR_SEQUENTIAL from TB_PERSON as PERSON';
var
  Person: IModel<TEPerson>;
  Query: String;
begin
  Person := TPerson.Create;
  Person.PrepareModel('', []);

  Query := TSQLSelect.Create.Ref
    .Fields([Person.Fields])
    .From(Person.Table)
    .Build;

  CheckEquals(QueryExpected, Query);

  Person.PrepareModel('', [tepSequential]);

  Query := TSQLSelect.Create.Ref
    .Fields([Person.Fields])
    .From(Person.Table)
    .Build;

  CheckEquals(QueryExpected2, Query);
end;



procedure TNowaTest.TestSQLCommandDelete;
const
  Delete = 'delete from tb_person';
var
  Person: IModel<TEPerson>;
begin
  Person := TPerson.Create;
  Person.PrepareModel('', []);

  CheckEquals(Delete,
    TSQLCommand<TEPerson>.Create.Ref
      .Delete(Person)
      .Build
  );
end;



procedure TNowaTest.TestSQLCommandDeleteWhere;
const
  Delete = 'delete from tb_person where nr_sequential = :PERSON_NR_SEQUENTIAL';
var
  Person: IModel<TEPerson>;
begin
  Person := TPerson.Create;
  Person.PrepareModel('', []);

  CheckEquals(Delete,
    TSQLCommand<TEPerson>.Create.Ref
      .Delete(Person)
      .WhereKey(Person, [tepSequential])
      .Build
  );
end;



procedure TNowaTest.TestSQLCommandExists;
var
  Person: IModel<TEPerson>;
begin
  Person := TPerson.Create;
  Person.PrepareModel('', []);

  CheckEquals('not implemented',
    TSQLCommand<TEPerson>.Create.Ref
      .Exists(Person, [tepSequential])
      .Build
  );
end;



procedure TNowaTest.TestSQLCommandFind;
const
  Find = 'select PERSON.NR_SEQUENTIAL as PERSON_NR_SEQUENTIAL, PERSON.FL_NAME as PERSON_FL_NAME, PERSON.DT_BIRTHDATE as PERSON_DT_BIRTHDATE,' +
    ' PERSON.TX_EMAIL as PERSON_TX_EMAIL, PERSON.TX_PASSWORD as PERSON_TX_PASSWORD from TB_PERSON as PERSON where PERSON.NR_SEQUENTIAL = 1';
var
  Person: IModel<TEPerson>;
begin
  Person := TPerson.Create;
  Person.PrepareModel('', []);

  CheckEquals(Find,
    TSQLCommand<TEPerson>.Create.Ref
      .Find(Person, tepSequential , 1)
      .Build
  );
end;



procedure TNowaTest.TestSQLCommandInsert;
const
  Insert = 'insert into tb_person (nr_sequential, fl_name, dt_birthdate, tx_email, tx_password) values (:PERSON_NR_SEQUENTIAL, :PERSON_FL_NAME, :PERSON_DT_BIRTHDATE, :PERSON_TX_EMAIL, :PERSON_TX_PASSWORD)';
var
  Person: IModel<TEPerson>;
begin
  Person := TPerson.Create;
  Person.PrepareModel('', []);

  CheckEquals(Insert,
    TSQLCommand<TEPerson>.Create.Ref
      .Insert(Person)
      .Build
  );
end;



procedure TNowaTest.TestSQLCommandNewKeyValue;
const
  Sequence = 'select nextval(''gen_person'') as sequence';
var
  Person: IModel<TEPerson>;
begin
  Person := TPerson.Create;
  Person.PrepareModel('', []);

  CheckEquals(Sequence,
    TSQLCommand<TEPerson>.Create.Ref
      .NewKeyValue(Person.Table.Sequence)
      .Build
  );
end;



procedure TNowaTest.TestSQLCommandUpdate;
const
  Update = 'update tb_person set nr_sequential = :PERSON_NR_SEQUENTIAL, fl_name = :PERSON_FL_NAME, dt_birthdate = :PERSON_DT_BIRTHDATE, tx_email = :PERSON_TX_EMAIL, tx_password = :PERSON_TX_PASSWORD';
var
  Person: IModel<TEPerson>;
begin
  Person := TPerson.Create;
  Person.PrepareModel('', []);

  CheckEquals(Update,
    TSQLCommand<TEPerson>.Create.Ref
      .Update(Person)
      .Build
  );
end;



procedure TNowaTest.TestSQLCommandUpdateWhereKey;
const
  Update = 'update tb_person set nr_sequential = :PERSON_NR_SEQUENTIAL, fl_name = :PERSON_FL_NAME, dt_birthdate = :PERSON_DT_BIRTHDATE,' +
    ' tx_email = :PERSON_TX_EMAIL, tx_password = :PERSON_TX_PASSWORD where nr_sequential = :PERSON_NR_SEQUENTIAL';
var
  Person: IModel<TEPerson>;
begin
  Person := TPerson.Create;
  Person.PrepareModel('', []);

  CheckEquals(Update,
    TSQLCommand<TEPerson>.Create.Ref
      .Update(Person)
      .WhereKey(Person, [tepSequential])
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
  Query = 'select PERSON.NR_SEQUENTIAL as PERSON_NR_SEQUENTIAL';
  QueryExpected = 'select PERSON.NR_SEQUENTIAL as PERSON_NR_SEQUENTIAL, PERSON.FL_NAME as PERSON_FL_NAME, PERSON.DT_BIRTHDATE as PERSON_DT_BIRTHDATE, PERSON.TX_EMAIL as PERSON_TX_EMAIL, PERSON.TX_PASSWORD as PERSON_TX_PASSWORD';
var
  Person: IModel<TEPerson>;
  Table: ITable;
  Field: IField;
begin
  Table := TTable.Create('TB_PERSON', 'GEN_PERSON');
  Table.Prepare('PERSON');
  Field := TField.Create('NR_SEQUENTIAL', Table);

  CheckEquals(Query, TSQLSelect.Create.Ref.Fields([[Field]]).Build);

  Person := TPerson.Create;
  Person.PrepareModel('', [tepSequential]);
  CheckEquals(Query, TSQLSelect.Create.Ref.Fields([Person.Fields]).Build);

  Person.PrepareModel('', []);
  CheckEquals(QueryExpected, TSQLSelect.Create.Ref.Fields([Person.Fields]).Build);
end;



procedure TNowaTest.TestSQLSelectFromWithFields;
const
  Query = 'select PERSON.NR_SEQUENTIAL as PERSON_NR_SEQUENTIAL from TB_PERSON as PERSON';
  QueryExpected = 'select PERSON.NR_SEQUENTIAL as PERSON_NR_SEQUENTIAL, PERSON.FL_NAME as PERSON_FL_NAME, PERSON.DT_BIRTHDATE as PERSON_DT_BIRTHDATE, PERSON.TX_EMAIL as PERSON_TX_EMAIL, PERSON.TX_PASSWORD as PERSON_TX_PASSWORD from TB_PERSON as PERSON';
var
  Person: IModel<TEPerson>;
begin
  Person := TPerson.Create;

  Person.PrepareModel('', [tepSequential]);
  CheckEquals(Query,
    TSQLSelect.Create.Ref
      .Fields([Person.Fields])
      .From(Person.Table)
      .Build);

  Person.PrepareModel('', []);
  CheckEquals(QueryExpected,
    TSQLSelect.Create.Ref
      .Fields([Person.Fields])
      .From(Person.Table)
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
  InnerJoin = 'select PERSON.NR_SEQUENTIAL as PERSON_NR_SEQUENTIAL,' +
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
  Person: IModel<TEPerson>;
  Matriculation: IModel<TEMatriculation>;
begin
  Person := TPerson.Create;
  Matriculation := TMatriculation.Create;

  Person.PrepareModel('', []);
  Matriculation.PrepareModel('', []);

  CheckEquals(InnerJoin,
    TSQLSelect.Create.Ref
      .Fields([Person.Fields, Matriculation.Fields])
      .From(Person.Table)
      .InnerJoin(
        TSQLJoin.Create.Ref
          .Table(Matriculation.Table)
          .&On(
            TSQLCondition.Create.Ref
              .LeftTerm(Matriculation.Field(temPersonSequential))
              .Op(opEqual)
              .RightTerm(Person.Field(tepSequential))
          )
      )
      .Build
  );
end;



procedure TNowaTest.TestSQLSelectLeftJoin;
const
  InnerJoin = 'select PERSON.NR_SEQUENTIAL as PERSON_NR_SEQUENTIAL,' +
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
  Person: IModel<TEPerson>;
  Matriculation: IModel<TEMatriculation>;
begin
  Person := TPerson.Create;
  Matriculation := TMatriculation.Create;

  Person.PrepareModel('', []);
  Matriculation.PrepareModel('', []);

  CheckEquals(InnerJoin,
    TSQLSelect.Create.Ref
      .Fields([Person.Fields, Matriculation.Fields])
      .From(Person.Table)
      .LeftJoin(
        TSQLJoin.Create.Ref
          .Table(Matriculation.Table)
          .&On(
            TSQLCondition.Create.Ref
              .LeftTerm(Matriculation.Field(temPersonSequential))
              .Op(opEqual)
              .RightTerm(Person.Field(tepSequential))
          )
      )
      .Build
  );
end;



procedure TNowaTest.TestSQLSelectLeftOuterJoin;
const
  InnerJoin = 'select PERSON.NR_SEQUENTIAL as PERSON_NR_SEQUENTIAL,' +
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
  Person: IModel<TEPerson>;
  Matriculation: IModel<TEMatriculation>;
begin
  Person := TPerson.Create;
  Matriculation := TMatriculation.Create;

  Person.PrepareModel('', []);
  Matriculation.PrepareModel('', []);

  CheckEquals(InnerJoin,
    TSQLSelect.Create.Ref
      .Fields([Person.Fields, Matriculation.Fields])
      .From(Person.Table)
      .LeftOuterJoin(
        TSQLJoin.Create.Ref
          .Table(Matriculation.Table)
          .&On(
            TSQLCondition.Create.Ref
              .LeftTerm(Matriculation.Field(temPersonSequential))
              .Op(opEqual)
              .RightTerm(Person.Field(tepSequential))
          )
      )
      .Build
  );
end;



procedure TNowaTest.TestSQLSelectRightJoin;
const
  InnerJoin = 'select PERSON.NR_SEQUENTIAL as PERSON_NR_SEQUENTIAL,' +
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
  Person: IModel<TEPerson>;
  Matriculation: IModel<TEMatriculation>;
begin
  Person := TPerson.Create;
  Matriculation := TMatriculation.Create;

  Person.PrepareModel('', []);
  Matriculation.PrepareModel('', []);

  CheckEquals(InnerJoin,
    TSQLSelect.Create.Ref
      .Fields([Person.Fields, Matriculation.Fields])
      .From(Person.Table)
      .RightJoin(
        TSQLJoin.Create.Ref
          .Table(Matriculation.Table)
          .&On(
            TSQLCondition.Create.Ref
              .LeftTerm(Matriculation.Field(temPersonSequential))
              .Op(opEqual)
              .RightTerm(Person.Field(tepSequential))
          )
      )
      .Build
  );
end;



procedure TNowaTest.TestSQLSelectRightOuterJoin;
const
  InnerJoin = 'select PERSON.NR_SEQUENTIAL as PERSON_NR_SEQUENTIAL,' +
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
  Person: IModel<TEPerson>;
  Matriculation: IModel<TEMatriculation>;
begin
  Person := TPerson.Create;
  Matriculation := TMatriculation.Create;

  Person.PrepareModel('', []);
  Matriculation.PrepareModel('', []);

  CheckEquals(InnerJoin,
    TSQLSelect.Create.Ref
      .Fields([Person.Fields, Matriculation.Fields])
      .From(Person.Table)
      .RightOuterJoin(
        TSQLJoin.Create.Ref
          .Table(Matriculation.Table)
          .&On(
            TSQLCondition.Create.Ref
              .LeftTerm(Matriculation.Field(temPersonSequential))
              .Op(opEqual)
              .RightTerm(Person.Field(tepSequential))
          )
      )
      .Build
  );
end;



procedure TNowaTest.TestSQLSelectUnion;
const
  InnerJoin = 'select PERSON.NR_SEQUENTIAL as PERSON_NR_SEQUENTIAL,' +
                     ' PERSON.FL_NAME as PERSON_FL_NAME,' +
                     ' PERSON.DT_BIRTHDATE as PERSON_DT_BIRTHDATE,' +
                     ' PERSON.TX_EMAIL as PERSON_TX_EMAIL,' +
                     ' PERSON.TX_PASSWORD as PERSON_TX_PASSWORD' +
                ' from TB_PERSON as PERSON' +
                ' where PERSON.FL_NAME = ''MARCELO''' +
                ' union' +
               ' select PERSON.NR_SEQUENTIAL as PERSON_NR_SEQUENTIAL,' +
                     ' PERSON.FL_NAME as PERSON_FL_NAME,' +
                     ' PERSON.DT_BIRTHDATE as PERSON_DT_BIRTHDATE,' +
                     ' PERSON.TX_EMAIL as PERSON_TX_EMAIL,' +
                     ' PERSON.TX_PASSWORD as PERSON_TX_PASSWORD' +
                ' from TB_PERSON as PERSON' +
                ' where PERSON.FL_NAME = ''RANDOM''';
var
  Person: IModel<TEPerson>;
begin
  Person := TPerson.Create;
  Person.PrepareModel('', []);

  CheckEquals(InnerJoin,
    TSQLSelect.Create.Ref
      .Fields([Person.Fields])
      .From(Person.Table)
      .Where(
        TSQLWhere.Create.Ref
          .Field(Person.Field(tepName))
          .Equal('MARCELO')
      )
      .Union
      .Fields([Person.Fields])
      .From(Person.Table)
      .Where(
        TSQLWhere.Create.Ref
          .Field(Person.Field(tepName))
          .Equal('RANDOM')
      )
      .Build
  );
end;



procedure TNowaTest.TestSQLSelectUnionAll;
const
  InnerJoin = 'select PERSON.NR_SEQUENTIAL as PERSON_NR_SEQUENTIAL,' +
                     ' PERSON.FL_NAME as PERSON_FL_NAME,' +
                     ' PERSON.DT_BIRTHDATE as PERSON_DT_BIRTHDATE,' +
                     ' PERSON.TX_EMAIL as PERSON_TX_EMAIL,' +
                     ' PERSON.TX_PASSWORD as PERSON_TX_PASSWORD' +
                ' from TB_PERSON as PERSON' +
                ' where PERSON.FL_NAME = ''MARCELO''' +
                ' union all' +
               ' select PERSON.NR_SEQUENTIAL as PERSON_NR_SEQUENTIAL,' +
                     ' PERSON.FL_NAME as PERSON_FL_NAME,' +
                     ' PERSON.DT_BIRTHDATE as PERSON_DT_BIRTHDATE,' +
                     ' PERSON.TX_EMAIL as PERSON_TX_EMAIL,' +
                     ' PERSON.TX_PASSWORD as PERSON_TX_PASSWORD' +
                ' from TB_PERSON as PERSON' +
                ' where PERSON.FL_NAME = ''RANDOM''';
var
  Person: IModel<TEPerson>;
begin
  Person := TPerson.Create;
  Person.PrepareModel('', []);

  CheckEquals(InnerJoin,
    TSQLSelect.Create.Ref
      .Fields([Person.Fields])
      .From(Person.Table)
      .Where(
        TSQLWhere.Create.Ref
          .Field(Person.Field(tepName))
          .Equal('MARCELO')
      )
      .UnionAll
      .Fields([Person.Fields])
      .From(Person.Table)
      .Where(
        TSQLWhere.Create.Ref
          .Field(Person.Field(tepName))
          .Equal('RANDOM')
      )
      .Build
  );
end;



procedure TNowaTest.TestSQLSelectWhere;
const
  Query = 'select PERSON.NR_SEQUENTIAL as PERSON_NR_SEQUENTIAL from TB_PERSON as PERSON where PERSON.NR_SEQUENTIAL = 1';
  QueryExpected =
    'select PERSON.NR_SEQUENTIAL as PERSON_NR_SEQUENTIAL, PERSON.FL_NAME as PERSON_FL_NAME, PERSON.DT_BIRTHDATE as PERSON_DT_BIRTHDATE, ' +
    'PERSON.TX_EMAIL as PERSON_TX_EMAIL, PERSON.TX_PASSWORD as PERSON_TX_PASSWORD from TB_PERSON as PERSON where PERSON.NR_SEQUENTIAL = 1';
var
  Person: IModel<TEPerson>;
begin
  Person := TPerson.Create;

  Person.PrepareModel('', [tepSequential]);
  CheckEquals(Query,
    TSQLSelect.Create.Ref
      .Fields([Person.Fields])
      .From(Person.Table)
      .Where(
        TSQLWhere.Create.Ref
          .Field(Person.Field(tepSequential))
          .Equal(1)
      )
      .Build
  );

  Person.PrepareModel('', []);
  CheckEquals(QueryExpected,
    TSQLSelect.Create.Ref
      .Fields([Person.Fields])
      .From(Person.Table)
      .Where(
        TSQLWhere.Create.Ref
          .Field(Person.Field(tepSequential))
          .Equal(1)
      )
      .Build
  );
end;



procedure TNowaTest.TestSQLWhereDifferent;
const
  Query = ' where  <> ';
  Query2 = ' where T.EXAMPLE <> ';
  Query3 = ' where T1.EXAMPLE <> T2.EXAMPLE';
  Query4 = ' where PERSON.NR_SEQUENTIAL <> MATRICULATION.NR_PERSONSEQUENTIAL';
var
  Person: IModel<TEPerson>;
  Matriculation: IModel<TEMatriculation>;
  Table, Table2: ITable;
begin
  Table := TTable.Create('T', '');
  Table.Prepare('T');

  CheckEquals(Query,
    TSQLWhere.Create.Ref
      .Different
      .Build
  );

  CheckEquals(Query2,
    TSQLWhere.Create.Ref
      .Field(TField.Create('EXAMPLE', Table).Ref)
      .Different
      .Build
  );

  Table2 := TTable.Create('T1', '');
  Table2.Prepare('T1');
  Table.Prepare('T2');

  CheckEquals(Query3,
    TSQLWhere.Create.Ref
      .Field(TField.Create('EXAMPLE', Table2).Ref)
      .Different
      .Field(TField.Create('EXAMPLE', Table).Ref)
      .Build
  );


  Person := TPerson.Create;
  Matriculation := TMatriculation.Create;
  Person.PrepareModel('', []);
  Matriculation.PrepareModel('', []);
  CheckEquals(Query4,
    TSQLWhere.Create.Ref
      .Field(Person.Field(tepSequential))
      .Different
      .Field(Matriculation.Field(temPersonSequential))
      .Build
  );

end;



procedure TNowaTest.TestSQLWhereDifferentValue;
const
  Query1 = ' where T.EXAMPLE <> 1';
  Query2 = ' where T.EXAMPLE <> ''ABC''';
  Query3 = ' where PERSON.NR_SEQUENTIAL <> 1';
var
  Person: IModel<TEPerson>;
  Table: ITable;
begin
  Table := TTable.Create('T', '');
  Table.Prepare('T');

  CheckEquals(Query1,
    TSQLWhere.Create.Ref
      .Field(TField.Create('EXAMPLE', Table).Ref)
      .Different(1)
      .Build
  );

  CheckEquals(Query2,
    TSQLWhere.Create.Ref
      .Field(TField.Create('EXAMPLE', Table).Ref)
      .Different(QuotedStr('ABC'))
      .Build
  );

  Person := TPerson.Create;
  Person.PrepareModel('', []);
  CheckEquals(Query3,
    TSQLWhere.Create.Ref
      .Field(Person.Field(tepSequential))
      .Different(1)
      .Build
  );
end;



procedure TNowaTest.TestSQLWhereEqual;
const
  Query = ' where  = ';
  Query2 = ' where T.EXAMPLE = ';
var
  Table: ITable;
begin
  Table := TTable.Create('T', '');
  Table.Prepare('T');

  CheckEquals(Query,
    TSQLWhere.Create.Ref
      .Equal
      .Build
  );

  CheckEquals(Query2,
    TSQLWhere.Create.Ref
      .Field(TField.Create('EXAMPLE', Table).Ref)
      .Equal
      .Build
  );
end;



procedure TNowaTest.TestSQLWhereEqualValue;
const
  Query = ' where  = 1';
  Query2 = ' where  = ''ABC''';
  Query3 = ' where T.EXAMPLEVAL = 1';
  Query4 = ' where T.EXAMPLEVAL = ''ABC''';
  Query5 = ' where T1.EXAMPLE = T2.EXAMPLE';
  Query6 = ' where PERSON.NR_SEQUENTIAL = 1';
  Query7 = ' where PERSON.NR_SEQUENTIAL = MATRICULATION.NR_PERSONSEQUENTIAL';
var
  Person: IModel<TEPerson>;
  Matriculation: IModel<TEMatriculation>;
  Table, Table2: ITable;
begin
  Table := TTable.Create('T', '');
  Table.Prepare('T');

  CheckEquals(Query,
    TSQLWhere.Create.Ref
    .Equal(1)
    .Build
  );

  CheckEquals(Query2,
    TSQLWhere.Create.Ref
    .Equal(QuotedStr('ABC'))
    .Build
  );

  CheckEquals(Query3,
    TSQLWhere.Create.Ref
    .Field(TField.Create('EXAMPLEVAL', Table).Ref)
    .Equal(1)
    .Build
  );

  CheckEquals(Query4,
    TSQLWhere.Create.Ref
    .Field(TField.Create('EXAMPLEVAL', Table).Ref)
    .Equal(QuotedStr('ABC'))
    .Build
  );

  Table2 := TTable.Create('T1', '');
  Table2.Prepare('T1');
  Table.Prepare('T2');

  CheckEquals(Query5,
    TSQLWhere.Create.Ref
    .Field(TField.Create('EXAMPLE', Table2).Ref)
    .Equal
    .Field(TField.Create('EXAMPLE', Table).Ref)
    .Build
  );

  Person := TPerson.Create;
  Person.PrepareModel('', []);
  CheckEquals(Query6,
    TSQLWhere.Create.Ref
    .Field(Person.Field(tepSequential))
    .Equal(1)
    .Build
  );

  Matriculation := TMatriculation.Create;
  Person.PrepareModel('', []);
  Matriculation.PrepareModel('', []);
  CheckEquals(Query7,
    TSQLWhere.Create.Ref
      .Field(Person.Field(tepSequential))
      .Equal
      .Field(Matriculation.Field(temPersonSequential))
      .Build
  );
end;



procedure TNowaTest.TestSQLWhereField;
const
  Query = ' where T.EXAMPLE';
  QueryPerson = ' where PERSON.FL_NAME';
var
  Person: IModel<TEPerson>;
  Table: ITable;
begin
  Table := TTable.Create('T', '');
  Table.Prepare('T');

  CheckEquals(Query,
    TSQLWhere.Create.Ref
    .Field(TField.Create('EXAMPLE', Table))
    .Build
  );

  Person := TPerson.Create;
  Person.PrepareModel('', []);
  CheckEquals(QueryPerson,
    TSQLWhere.Create.Ref
    .Field(Person.Field(tepName))
    .Build
  );
end;



procedure TNowaTest.TestSQLWhereGreater;
const
  Query1 = ' where T.EXAMPLE > ';
  Query2 = ' where T1.EXAMPLE > T2.EXAMPLE';
  Query3 = ' where PERSON.NR_SEQUENTIAL > MATRICULATION.NR_PERSONSEQUENTIAL';
var
  Person: IModel<TEPerson>;
  Matriculation: IModel<TEMatriculation>;
  Table, Table2: ITable;
begin
  Table := TTable.Create('T', '');
  Table.Prepare('T');

  CheckEquals(Query1,
    TSQLWhere.Create.Ref
      .Field(TField.Create('EXAMPLE', Table).Ref)
      .Greater
      .Build
  );


  Table2 := TTable.Create('T1', '');
  Table2.Prepare('T1');
  Table.Prepare('T2');
  CheckEquals(Query2,
    TSQLWhere.Create.Ref
      .Field(TField.Create('EXAMPLE', Table2).Ref)
      .Greater
      .Field(TField.Create('EXAMPLE', Table).Ref)
      .Build
  );

  Person := TPerson.Create;
  Matriculation := TMatriculation.Create;
  Person.PrepareModel('', []);
  Matriculation.PrepareModel('', []);
  CheckEquals(Query3,
    TSQLWhere.Create.Ref
      .Field(Person.Field(tepSequential))
      .Greater
      .Field(Matriculation.Field(temPersonSequential))
      .Build
  );
end;



procedure TNowaTest.TestSQLWhereGreaterOrEqual;
const
  Query1 = ' where T.EXAMPLE >= ';
  Query2 = ' where T1.EXAMPLE >= T2.EXAMPLE';
  Query3 = ' where PERSON.NR_SEQUENTIAL >= MATRICULATION.NR_PERSONSEQUENTIAL';
var
  Person: IModel<TEPerson>;
  Matriculation: IModel<TEMatriculation>;
  Table, Table2: ITable;
begin
  Table := TTable.Create('T', '');
  Table.Prepare('T');

  CheckEquals(Query1,
    TSQLWhere.Create.Ref
      .Field(TField.Create('EXAMPLE', Table).Ref)
      .GreaterOrEqual
      .Build
  );

  Table2 := TTable.Create('T2', '');
  Table2.Prepare('T2');
  Table.Prepare('T1');

  CheckEquals(Query2,
    TSQLWhere.Create.Ref
      .Field(TField.Create('EXAMPLE', Table).Ref)
      .GreaterOrEqual
      .Field(TField.Create('EXAMPLE', Table2).Ref)
      .Build
  );

  Person := TPerson.Create;
  Matriculation := TMatriculation.Create;
  Person.PrepareModel('', []);
  Matriculation.PrepareModel('', []);
  CheckEquals(Query3,
    TSQLWhere.Create.Ref
      .Field(Person.Field(tepSequential))
      .GreaterOrEqual
      .Field(Matriculation.Field(temPersonSequential))
      .Build
  );
end;



procedure TNowaTest.TestSQLWhereGreaterOrEqualValue;
const
  Query1 = ' where T.EXAMPLE >= 1';
  Query2 = ' where T.EXAMPLE >= ''ABC''';
  Query3 = ' where PERSON.NR_SEQUENTIAL >= 1';
var
  Person: IModel<TEPerson>;
  Table: ITable;
begin
  Table := TTable.Create('T', '');
  Table.Prepare('T');

  CheckEquals(Query1,
    TSQLWhere.Create.Ref
      .Field(TField.Create('EXAMPLE', Table).Ref)
      .GreaterOrEqual(1)
      .Build
  );

  CheckEquals(Query2,
    TSQLWhere.Create.Ref
      .Field(TField.Create('EXAMPLE', Table).Ref)
      .GreaterOrEqual(QuotedStr('ABC'))
      .Build
  );

  Person := TPerson.Create;
  Person.PrepareModel('', []);
  CheckEquals(Query3,
    TSQLWhere.Create.Ref
      .Field(Person.Field(tepSequential))
      .GreaterOrEqual(1)
      .Build
  );
end;



procedure TNowaTest.TestSQLWhereGreaterValue;
const
  Query1 = ' where T.EXAMPLE > 1';
  Query2 = ' where T.EXAMPLE > ''ABC''';
  Query3 = ' where PERSON.NR_SEQUENTIAL > 1';
var
  Person: IModel<TEPerson>;
  Table: ITable;
begin
  Table := TTable.Create('T', '');
  Table.Prepare('T');

  CheckEquals(Query1,
    TSQLWhere.Create.Ref
      .Field(TField.Create('EXAMPLE', Table).Ref)
      .Greater(1)
      .Build
  );

  CheckEquals(Query2,
    TSQLWhere.Create.Ref
      .Field(TField.Create('EXAMPLE', Table).Ref)
      .Greater(QuotedStr('ABC'))
      .Build
  );

  Person := TPerson.Create;
  Person.PrepareModel('', []);
  CheckEquals(Query3,
    TSQLWhere.Create.Ref
      .Field(Person.Field(tepSequential))
      .Greater(1)
      .Build
  );
end;



procedure TNowaTest.TestSQLWhereInList;
var
  Person: IModel<TEPerson>;
begin
  Person := TPerson.Create;
  Person.PrepareModel('', []);

  CheckEquals(' where PERSON.NR_SEQUENTIAL in (1,2,3,4)',
    TSQLWhere.Create.Ref
      .Field(Person.Field(tepSequential))
      .InList([1,2,3,4])
      .Build
  );
end;



procedure TNowaTest.TestSQLWhereIsNotNull;
var
  Person: IModel<TEPerson>;
begin
  Person := TPerson.Create;
  Person.PrepareModel('', []);

  CheckEquals('not implemented',
    TSQLWhere.Create.Ref
      .Field(Person.Field(tepSequential))
      .IsNotNull
      .Build
  );
end;



procedure TNowaTest.TestSQLWhereIsNull;
var
  Person: IModel<TEPerson>;
begin
  Person := TPerson.Create;
  Person.PrepareModel('', []);

  CheckEquals('not implemented',
    TSQLWhere.Create.Ref
      .Field(Person.Field(tepSequential))
      .IsNull
      .Build
  );
end;



procedure TNowaTest.TestSQLWhereLess;
const
  Query1 = ' where T.EXAMPLE < ';
  Query2 = ' where T1.EXAMPLE < T2.EXAMPLE';
  Query3 = ' where PERSON.NR_SEQUENTIAL < MATRICULATION.NR_PERSONSEQUENTIAL';
var
  Person: IModel<TEPerson>;
  Matriculation: IModel<TEMatriculation>;
  Table, Table2: ITable;
begin
  Table := TTable.Create('T', '');
  Table.Prepare('T');

  CheckEquals(Query1,
    TSQLWhere.Create.Ref
      .Field(TField.Create('EXAMPLE', Table).Ref)
      .Less
      .Build
  );

  Table2 := TTable.Create('T1', '');
  Table2.Prepare('T1');
  Table.Prepare('T2');

  CheckEquals(Query2,
    TSQLWhere.Create.Ref
      .Field(TField.Create('EXAMPLE', Table2).Ref)
      .Less
      .Field(TField.Create('EXAMPLE', Table).Ref)
      .Build
  );

  Person := TPerson.Create;
  Matriculation := TMatriculation.Create;
  Person.PrepareModel('', []);
  Matriculation.PrepareModel('', []);
  CheckEquals(Query3,
    TSQLWhere.Create.Ref
      .Field(Person.Field(tepSequential))
      .Less
      .Field(Matriculation.Field(temPersonSequential))
      .Build
  );
end;



procedure TNowaTest.TestSQLWhereLessOrEqual;
const
  Query1 = ' where T.EXAMPLE <= ';
  Query2 = ' where T1.EXAMPLE <= T2.EXAMPLE';
  Query3 = ' where PERSON.NR_SEQUENTIAL <= MATRICULATION.NR_PERSONSEQUENTIAL';
var
  Person: IModel<TEPerson>;
  Matriculation: IModel<TEMatriculation>;
  Table, Table2: ITable;
begin
  Table := TTable.Create('T', '');
  Table.Prepare('T');

  CheckEquals(Query1,
    TSQLWhere.Create.Ref
      .Field(TField.Create('EXAMPLE', Table).Ref)
      .LessOrEqual
      .Build
  );

  Table2 := TTable.Create('T1', '');
  Table2.Prepare('T1');
  Table.Prepare('T2');

  CheckEquals(Query2,
    TSQLWhere.Create.Ref
      .Field(TField.Create('EXAMPLE', Table2).Ref)
      .LessOrEqual
      .Field(TField.Create('EXAMPLE', Table).Ref)
      .Build
  );

  Person := TPerson.Create;
  Matriculation := TMatriculation.Create;
  Person.PrepareModel('', []);
  Matriculation.PrepareModel('', []);
  CheckEquals(Query3,
    TSQLWhere.Create.Ref
      .Field(Person.Field(tepSequential))
      .LessOrEqual
      .Field(Matriculation.Field(temPersonSequential))
      .Build
  );
end;


procedure TNowaTest.TestSQLWhereLessOrEqualValue;
const
  Query1 = ' where T.EXAMPLE <= 1';
  Query2 = ' where T.EXAMPLE <= ''ABC''';
  Query3 = ' where PERSON.NR_SEQUENTIAL <= 1';
var
  Person: IModel<TEPerson>;
  Table: ITable;
begin
  Table := TTable.Create('T', '');
  Table.Prepare('T');

  CheckEquals(Query1,
    TSQLWhere.Create.Ref
      .Field(TField.Create('EXAMPLE', Table).Ref)
      .LessOrEqual(1)
      .Build
  );

  CheckEquals(Query2,
    TSQLWhere.Create.Ref
      .Field(TField.Create('EXAMPLE', Table).Ref)
      .LessOrEqual(QuotedStr('ABC'))
      .Build
  );

  Person := TPerson.Create;
  Person.PrepareModel('', []);
  CheckEquals(Query3,
    TSQLWhere.Create.Ref
      .Field(Person.Field(tepSequential))
      .LessOrEqual(1)
      .Build
  );
end;



procedure TNowaTest.TestSQLWhereLessValue;
const
  Query1 = ' where T.EXAMPLE < 1';
  Query2 = ' where T.EXAMPLE < ''ABC''';
  Query3 = ' where PERSON.NR_SEQUENTIAL < 1';
var
  Person: IModel<TEPerson>;
  Table: ITable;
begin
  Table := TTable.Create('T', '');
  Table.Prepare('T');

  CheckEquals(Query1,
    TSQLWhere.Create.Ref
      .Field(TField.Create('EXAMPLE', Table).Ref)
      .Less(1)
      .Build
  );

  CheckEquals(Query2,
    TSQLWhere.Create.Ref
      .Field(TField.Create('EXAMPLE', Table).Ref)
      .Less(QuotedStr('ABC'))
      .Build
  );

  Person := TPerson.Create;
  Person.PrepareModel('', []);
  CheckEquals(Query3,
    TSQLWhere.Create.Ref
      .Field(Person.Field(tepSequential))
      .Less(1)
      .Build
  );
end;



procedure TNowaTest.TestSQLWhereLike;
var
  Person: IModel<TEPerson>;
begin
  Person := TPerson.Create;
  Person.PrepareModel('', []);

  CheckEquals('not implemented',
    TSQLWhere.Create.Ref
      .Field(Person.Field(tepName))
      .Like(loEqual, 'Marcelo')
      .Build
  );

  CheckEquals('not implemented',
    TSQLWhere.Create.Ref
      .Field(Person.Field(tepName))
      .Like(loStarting, 'Marcelo')
      .Build
  );

  CheckEquals('not implemented',
    TSQLWhere.Create.Ref
      .Field(Person.Field(tepName))
      .Like(loEnding, 'Marcelo')
      .Build
  );

  CheckEquals('not implemented',
    TSQLWhere.Create.Ref
      .Field(Person.Field(tepName))
      .Like(loContaining, 'Marcelo')
      .Build
  );
end;



procedure TNowaTest.TestSQLWhereNot;
var
  Person: IModel<TEPerson>;
begin
  Person := TPerson.Create;
  Person.PrepareModel('', []);

  CheckEquals(' where PERSON.NR_SEQUENTIAL not ',
    TSQLWhere.Create.Ref
      .Field(Person.Field(tepSequential))
      .&Not
      .Build
  );
end;



procedure TNowaTest.TestSQLWhereNotInList;
var
  Person: IModel<TEPerson>;
begin
  Person := TPerson.Create;
  Person.PrepareModel('', []);

  CheckEquals(' where PERSON.NR_SEQUENTIAL not  in (1,2,3,4)',
    TSQLWhere.Create.Ref
      .Field(Person.Field(tepSequential))
      .&Not.InList([1,2,3,4])
      .Build
  );
end;



procedure TNowaTest.TestSQLWhereNotLike;
var
  Person: IModel<TEPerson>;
begin
  Person := TPerson.Create;
  Person.PrepareModel('', []);

  CheckEquals('not implemented',
    TSQLWhere.Create.Ref
      .Field(Person.Field(tepName))
      .NotLike(loEqual, 'Marcelo')
      .Build
  );

  CheckEquals('not implemented',
    TSQLWhere.Create.Ref
      .Field(Person.Field(tepName))
      .NotLike(loStarting, 'Marcelo')
      .Build
  );

  CheckEquals('not implemented',
    TSQLWhere.Create.Ref
      .Field(Person.Field(tepName))
      .NotLike(loEnding, 'Marcelo')
      .Build
  );

  CheckEquals('not implemented',
    TSQLWhere.Create.Ref
      .Field(Person.Field(tepName))
      .NotLike(loContaining, 'Marcelo')
      .Build
  );
end;

initialization

RegisterTest(TNowaTest.Suite);

end.

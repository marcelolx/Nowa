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

    //TODO: When one of this commands need a specific sql from adapter, create new suite test for this adapter
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
  NowaEntity,
  NowaEntityImpl,
  NowaEnumerators,
  NowaSQLAdapterImpl,
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
  QueryExpected = 'select P.SEQUENTIAL as P_SEQUENTIAL, P.NAME as P_NAME, P.BIRTHDATE as P_BIRTHDATE, P.EMAIL as P_EMAIL, P.PASSWORD as P_PASSWORD from PERSON as P';
  QueryExpected2 = 'select P.SEQUENTIAL as P_SEQUENTIAL from PERSON as P';
var
  Person: IEntity<TEPerson>;
  Query: String;
begin
  Person := TPerson.Create;
  Person.PrepareEntity('', []);

  Query := TSQLSelect.Create.Ref
    .Fields([Person.Fields])
    .From(Person.Table)
    .Build;

  CheckEquals(QueryExpected, Query);

  Person.PrepareEntity('', [tepSequential]);

  Query := TSQLSelect.Create.Ref
    .Fields([Person.Fields])
    .From(Person.Table)
    .Build;

  CheckEquals(QueryExpected2, Query);
end;



procedure TNowaTest.TestSQLCommandDelete;
const
  Delete = 'delete from person';
var
  Person: IEntity<TEPerson>;
begin
  Person := TPerson.Create;
  Person.PrepareEntity('', []);

  CheckEquals(Delete,
    TSQLCommand<TEPerson>.Create(TNowaSQLAdapter.Create.Ref).Ref
      .Delete(Person)
      .Build
  );
end;



procedure TNowaTest.TestSQLCommandDeleteWhere;
const
  Delete = 'delete from person where sequential = :P_SEQUENTIAL';
var
  Person: IEntity<TEPerson>;
begin
  Person := TPerson.Create;
  Person.PrepareEntity('', []);

  CheckEquals(Delete,
    TSQLCommand<TEPerson>.Create(TNowaSQLAdapter.Create.Ref).Ref
      .Delete(Person)
      .WhereKey(Person, [tepSequential])
      .Build
  );
end;



procedure TNowaTest.TestSQLCommandExists;
var
  Person: IEntity<TEPerson>;
begin
  Person := TPerson.Create;
  Person.PrepareEntity('', []);

  CheckEquals('not implemented',
    TSQLCommand<TEPerson>.Create(TNowaSQLAdapter.Create.Ref).Ref
      .Exists(Person, [tepSequential])
      .Build
  );
end;



procedure TNowaTest.TestSQLCommandFind;
const
  Find = 'select P.SEQUENTIAL as P_SEQUENTIAL, P.NAME as P_NAME, P.BIRTHDATE as P_BIRTHDATE,' +
    ' P.EMAIL as P_EMAIL, P.PASSWORD as P_PASSWORD from PERSON as P where P.SEQUENTIAL = 1';
var
  Person: IEntity<TEPerson>;
begin
  Person := TPerson.Create;
  Person.PrepareEntity('', []);

  CheckEquals(Find,
    TSQLCommand<TEPerson>.Create(TNowaSQLAdapter.Create.Ref).Ref
      .Find(Person, tepSequential , 1)
      .Build
  );
end;



procedure TNowaTest.TestSQLCommandInsert;
const
  Insert = 'insert into person (sequential, name, birthdate, email, password) values (:P_SEQUENTIAL, :P_NAME, :P_BIRTHDATE, :P_EMAIL, :P_PASSWORD)';
var
  Person: IEntity<TEPerson>;
begin
  Person := TPerson.Create;
  Person.PrepareEntity('', []);

  CheckEquals(Insert,
    TSQLCommand<TEPerson>.Create(TNowaSQLAdapter.Create.Ref).Ref
      .Insert(Person)
      .Build
  );
end;



procedure TNowaTest.TestSQLCommandNewKeyValue;
const
  Sequence = 'select nextval(''gen_person'') as sequence';
var
  Person: IEntity<TEPerson>;
begin
  Person := TPerson.Create;
  Person.PrepareEntity('', []);

  CheckEquals(Sequence,
    TSQLCommand<TEPerson>.Create(TNowaSQLAdapter.Create.Ref).Ref
      .NewKeyValue(Person.Table.Sequence)
      .Build
  );
end;



procedure TNowaTest.TestSQLCommandUpdate;
const
  Update = 'update person set sequential = :P_SEQUENTIAL, name = :P_NAME, birthdate = :P_BIRTHDATE, email = :P_EMAIL, password = :P_PASSWORD';
var
  Person: IEntity<TEPerson>;
begin
  Person := TPerson.Create;
  Person.PrepareEntity('', []);

  CheckEquals(Update,
    TSQLCommand<TEPerson>.Create(TNowaSQLAdapter.Create.Ref).Ref
      .Update(Person)
      .Build
  );
end;



procedure TNowaTest.TestSQLCommandUpdateWhereKey;
const
  Update = 'update person set sequential = :P_SEQUENTIAL, name = :P_NAME, birthdate = :P_BIRTHDATE,' +
    ' email = :P_EMAIL, password = :P_PASSWORD where sequential = :P_SEQUENTIAL';
var
  Person: IEntity<TEPerson>;
begin
  Person := TPerson.Create;
  Person.PrepareEntity('', []);

  CheckEquals(Update,
    TSQLCommand<TEPerson>.Create(TNowaSQLAdapter.Create.Ref).Ref
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
  Query = 'select P.SEQUENTIAL as P_SEQUENTIAL';
  QueryExpected =
    'select PERSON.SEQUENTIAL as PERSON_SEQUENTIAL, PERSON.NAME as PERSON_NAME, PERSON.BIRTHDATE as PERSON_BIRTHDATE,' +
    'PERSON.EMAIL as PERSON_EMAIL, PERSON.PASSWORD as PERSON_PASSWORD';
var
  Person: IEntity<TEPerson>;
  Table: ITable;
  Field: IField;
begin
  Table := TTable.Create('PERSON', 'GEN_PERSON');
  Table.Prepare('PERSON');
  Field := TField.Create('SEQUENTIAL', Table);

  CheckEquals(Query, TSQLSelect.Create.Ref.Fields([[Field]]).Build);

  Person := TPerson.Create;
  Person.PrepareEntity('', [tepSequential]);
  CheckEquals(Query, TSQLSelect.Create.Ref.Fields([Person.Fields]).Build);

  Person.PrepareEntity('', []);
  CheckEquals(QueryExpected, TSQLSelect.Create.Ref.Fields([Person.Fields]).Build);
end;



procedure TNowaTest.TestSQLSelectFromWithFields;
const
  Query = 'select P.SEQUENTIAL as P_SEQUENTIAL from PERSON as P';
  QueryExpected = 'select P.SEQUENTIAL as P_SEQUENTIAL, P.NAME as P_NAME, P.BIRTHDATE as P_BIRTHDATE, P.EMAIL as P_EMAIL, P.PASSWORD as P_PASSWORD from PERSON as P';
var
  Person: IEntity<TEPerson>;
begin
  Person := TPerson.Create;

  Person.PrepareEntity('', [tepSequential]);
  CheckEquals(Query,
    TSQLSelect.Create.Ref
      .Fields([Person.Fields])
      .From(Person.Table)
      .Build);

  Person.PrepareEntity('', []);
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
  InnerJoin = 'select P.SEQUENTIAL as P_SEQUENTIAL, P.NAME as P_NAME,' +
    ' P.BIRTHDATE as P_BIRTHDATE, P.EMAIL as P_EMAIL, P.PASSWORD as P_PASSWORD,' +
    ' MT.SEQUENTIAL as MT_SEQUENTIAL, MT.PERSONSEQUENTIAL as MT_PERSONSEQUENTIAL,' +
    ' MT.DATA as MT_DATA, MT.USER as MT_USER from PERSON as P' +
    ' inner join MATRICULATION as MT on (MT.PERSONSEQUENTIAL = P.SEQUENTIAL)';
var
  Person: IEntity<TEPerson>;
  Matriculation: IEntity<TEMatriculation>;
begin
  Person := TPerson.Create;
  Matriculation := TMatriculation.Create;

  Person.PrepareEntity('', []);
  Matriculation.PrepareEntity('', []);

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
  InnerJoin = 'select P.SEQUENTIAL as P_SEQUENTIAL,' +
                     ' P.NAME as P_NAME,' +
                     ' P.BIRTHDATE as P_BIRTHDATE,' +
                     ' P.EMAIL as P_EMAIL,' +
                     ' P.PASSWORD as P_PASSWORD,' +
                     ' MT.SEQUENTIAL as MT_SEQUENTIAL,' +
                     ' MT.PERSONSEQUENTIAL as MT_PERSONSEQUENTIAL,' +
                     ' MT.DATA as MT_DATA,' +
                     ' MT.USER as MT_USER' +
                ' from PERSON as P' +
               ' left join MATRICULATION as MT on (MT.PERSONSEQUENTIAL = P.SEQUENTIAL)';
var
  Person: IEntity<TEPerson>;
  Matriculation: IEntity<TEMatriculation>;
begin
  Person := TPerson.Create;
  Matriculation := TMatriculation.Create;

  Person.PrepareEntity('', []);
  Matriculation.PrepareEntity('', []);

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
  InnerJoin = 'select P.SEQUENTIAL as P_SEQUENTIAL, P.NAME as P_NAME, P.BIRTHDATE as P_BIRTHDATE,' +
    ' P.EMAIL as P_EMAIL, P.PASSWORD as P_PASSWORD, MT.SEQUENTIAL as MT_SEQUENTIAL,' +
    ' MT.PERSONSEQUENTIAL as MT_PERSONSEQUENTIAL, MT.DATA as MT_DATA, MT.USER as MT_USER' +
    ' from PERSON as P left outer join MATRICULATION as MT on (MT.PERSONSEQUENTIAL = P.SEQUENTIAL)';
var
  Person: IEntity<TEPerson>;
  Matriculation: IEntity<TEMatriculation>;
begin
  Person := TPerson.Create;
  Matriculation := TMatriculation.Create;

  Person.PrepareEntity('', []);
  Matriculation.PrepareEntity('', []);

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
  InnerJoin = 'select P.SEQUENTIAL as P_SEQUENTIAL, P.NAME as P_NAME, P.BIRTHDATE as P_BIRTHDATE,' +
    ' P.EMAIL as P_EMAIL, P.PASSWORD as P_PASSWORD, MT.SEQUENTIAL as MT_SEQUENTIAL,' +
    ' MT.PERSONSEQUENTIAL as MT_PERSONSEQUENTIAL, MT.DATA as MT_DATA, MT.USER as MT_USER' +
    ' from PERSON as P right join MATRICULATION as MT on (MT.PERSONSEQUENTIAL = P.SEQUENTIAL)';
var
  Person: IEntity<TEPerson>;
  Matriculation: IEntity<TEMatriculation>;
begin
  Person := TPerson.Create;
  Matriculation := TMatriculation.Create;

  Person.PrepareEntity('', []);
  Matriculation.PrepareEntity('', []);

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
  InnerJoin = 'select P.SEQUENTIAL as P_SEQUENTIAL, P.NAME as P_NAME, P.BIRTHDATE as P_BIRTHDATE,' +
    ' P.EMAIL as P_EMAIL, P.PASSWORD as P_PASSWORD, MT.SEQUENTIAL as MT_SEQUENTIAL,' +
    ' MT.PERSONSEQUENTIAL as MT_PERSONSEQUENTIAL, MT.DATA as MT_DATA, MT.USER as MT_USER' +
    ' from PERSON as P right outer join MATRICULATION as MT on (MT.PERSONSEQUENTIAL = P.SEQUENTIAL)';
var
  Person: IEntity<TEPerson>;
  Matriculation: IEntity<TEMatriculation>;
begin
  Person := TPerson.Create;
  Matriculation := TMatriculation.Create;

  Person.PrepareEntity('', []);
  Matriculation.PrepareEntity('', []);

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
  InnerJoin = 'select P.SEQUENTIAL as P_SEQUENTIAL, P.NAME as P_NAME, P.BIRTHDATE as P_BIRTHDATE, P.EMAIL as P_EMAIL,' +
    ' P.PASSWORD as P_PASSWORD from PERSON as P where P.NAME = ''MARCELO''' +
    ' union select P.SEQUENTIAL as P_SEQUENTIAL, P.NAME as P_NAME, P.BIRTHDATE as P_BIRTHDATE, P.EMAIL as P_EMAIL,' +
    ' P.PASSWORD as P_PASSWORD from PERSON as P where P.NAME = ''RANDOM''';
var
  Person: IEntity<TEPerson>;
begin
  Person := TPerson.Create;
  Person.PrepareEntity('', []);

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
  InnerJoin = 'select P.SEQUENTIAL as P_SEQUENTIAL, P.NAME as P_NAME, P.BIRTHDATE as P_BIRTHDATE, P.EMAIL as P_EMAIL,' +
    ' P.PASSWORD as P_PASSWORD from PERSON as P where P.NAME = ''MARCELO'' union all' +
    ' select P.SEQUENTIAL as P_SEQUENTIAL, P.NAME as P_NAME, P.BIRTHDATE as P_BIRTHDATE, P.EMAIL as P_EMAIL,' +
    ' P.PASSWORD as P_PASSWORD from PERSON as P where P.NAME = ''RANDOM''';
var
  Person: IEntity<TEPerson>;
begin
  Person := TPerson.Create;
  Person.PrepareEntity('', []);

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
  Query = 'select P.SEQUENTIAL as P_SEQUENTIAL from PERSON as P where P.SEQUENTIAL = 1';
  QueryExpected =
    'select P.SEQUENTIAL as P_SEQUENTIAL, P.NAME as P_NAME, P.BIRTHDATE as P_BIRTHDATE, ' +
    'P.EMAIL as P_EMAIL, P.PASSWORD as P_PASSWORD from PERSON as P where P.SEQUENTIAL = 1';
var
  Person: IEntity<TEPerson>;
begin
  Person := TPerson.Create;

  Person.PrepareEntity('', [tepSequential]);
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

  Person.PrepareEntity('', []);
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
  Query4 = ' where P.SEQUENTIAL <> MT.PERSONSEQUENTIAL';
var
  Person: IEntity<TEPerson>;
  Matriculation: IEntity<TEMatriculation>;
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
  Person.PrepareEntity('', []);
  Matriculation.PrepareEntity('', []);
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
  Query3 = ' where P.SEQUENTIAL <> 1';
var
  Person: IEntity<TEPerson>;
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
  Person.PrepareEntity('', []);
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
  Query6 = ' where P.SEQUENTIAL = 1';
  Query7 = ' where P.SEQUENTIAL = MT.PERSONSEQUENTIAL';
var
  Person: IEntity<TEPerson>;
  Matriculation: IEntity<TEMatriculation>;
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
  Person.PrepareEntity('', []);
  CheckEquals(Query6,
    TSQLWhere.Create.Ref
    .Field(Person.Field(tepSequential))
    .Equal(1)
    .Build
  );

  Matriculation := TMatriculation.Create;
  Person.PrepareEntity('', []);
  Matriculation.PrepareEntity('', []);
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
  QueryPerson = ' where P.NAME';
var
  Person: IEntity<TEPerson>;
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
  Person.PrepareEntity('', []);
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
  Query3 = ' where P.SEQUENTIAL > MT.PERSONSEQUENTIAL';
var
  Person: IEntity<TEPerson>;
  Matriculation: IEntity<TEMatriculation>;
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
  Person.PrepareEntity('', []);
  Matriculation.PrepareEntity('', []);
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
  Query3 = ' where P.SEQUENTIAL >= MT.PERSONSEQUENTIAL';
var
  Person: IEntity<TEPerson>;
  Matriculation: IEntity<TEMatriculation>;
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
  Person.PrepareEntity('', []);
  Matriculation.PrepareEntity('', []);
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
  Query3 = ' where P.SEQUENTIAL >= 1';
var
  Person: IEntity<TEPerson>;
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
  Person.PrepareEntity('', []);
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
  Query3 = ' where P.SEQUENTIAL > 1';
var
  Person: IEntity<TEPerson>;
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
  Person.PrepareEntity('', []);
  CheckEquals(Query3,
    TSQLWhere.Create.Ref
      .Field(Person.Field(tepSequential))
      .Greater(1)
      .Build
  );
end;



procedure TNowaTest.TestSQLWhereInList;
var
  Person: IEntity<TEPerson>;
begin
  Person := TPerson.Create;
  Person.PrepareEntity('', []);

  CheckEquals(' where P.SEQUENTIAL in (1,2,3,4)',
    TSQLWhere.Create.Ref
      .Field(Person.Field(tepSequential))
      .InList([1,2,3,4])
      .Build
  );
end;



procedure TNowaTest.TestSQLWhereIsNotNull;
var
  Person: IEntity<TEPerson>;
begin
  Person := TPerson.Create;
  Person.PrepareEntity('', []);

  CheckEquals('not implemented',
    TSQLWhere.Create.Ref
      .Field(Person.Field(tepSequential))
      .IsNotNull
      .Build
  );
end;



procedure TNowaTest.TestSQLWhereIsNull;
var
  Person: IEntity<TEPerson>;
begin
  Person := TPerson.Create;
  Person.PrepareEntity('', []);

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
  Query3 = ' where P.SEQUENTIAL < MT.PERSONSEQUENTIAL';
var
  Person: IEntity<TEPerson>;
  Matriculation: IEntity<TEMatriculation>;
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
  Person.PrepareEntity('', []);
  Matriculation.PrepareEntity('', []);
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
  Query3 = ' where P.SEQUENTIAL <= MT.PERSONSEQUENTIAL';
var
  Person: IEntity<TEPerson>;
  Matriculation: IEntity<TEMatriculation>;
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
  Person.PrepareEntity('', []);
  Matriculation.PrepareEntity('', []);
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
  Query3 = ' where P.SEQUENTIAL <= 1';
var
  Person: IEntity<TEPerson>;
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
  Person.PrepareEntity('', []);
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
  Query3 = ' where P.SEQUENTIAL < 1';
var
  Person: IEntity<TEPerson>;
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
  Person.PrepareEntity('', []);
  CheckEquals(Query3,
    TSQLWhere.Create.Ref
      .Field(Person.Field(tepSequential))
      .Less(1)
      .Build
  );
end;



procedure TNowaTest.TestSQLWhereLike;
var
  Person: IEntity<TEPerson>;
begin
  Person := TPerson.Create;
  Person.PrepareEntity('', []);

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
  Person: IEntity<TEPerson>;
begin
  Person := TPerson.Create;
  Person.PrepareEntity('', []);

  CheckEquals(' where P.SEQUENTIAL not ',
    TSQLWhere.Create.Ref
      .Field(Person.Field(tepSequential))
      .&Not
      .Build
  );
end;



procedure TNowaTest.TestSQLWhereNotInList;
var
  Person: IEntity<TEPerson>;
begin
  Person := TPerson.Create;
  Person.PrepareEntity('', []);

  CheckEquals(' where P.SEQUENTIAL not  in (1,2,3,4)',
    TSQLWhere.Create.Ref
      .Field(Person.Field(tepSequential))
      .&Not.InList([1,2,3,4])
      .Build
  );
end;



procedure TNowaTest.TestSQLWhereNotLike;
var
  Person: IEntity<TEPerson>;
begin
  Person := TPerson.Create;
  Person.PrepareEntity('', []);

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

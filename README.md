# Nowa

Simple SQL query builder for Delphi, working with enumerated types.

#### Info:
* In development.

# How to build queries

1. Do you need one enumerated type.

2. One class (that inherits ```TEnumAbstract<T>``` and implements ```IEnum<T>```) to map the database fields based on the enumerated type.

3. One model that inherits ```TModel<T>``` and implements Set/GetValue functions declared on ```IModel<T>``` that are virtual on base model.

4. Use classes of _NowaImpl.pas_ unit to build the queries.
 

An Simple select example:

```pascal
procedure NowaExample.TestExample;
var
  oIPerson: IModel<TEPerson>;
begin
  oIPerson := TPerson.Create;
  oIPerson.PrepareModel('', [tepSequential, tepName, tepEmail]);

  TSQLSelect.Create.Ref
    .Fields(oIPerson.PreparedFields)
    .From(oIPerson.Table, oIPerson.TableAlias)
    .Build;
end;
```

Example select with InnerJoin:

```pascal
procedure NowaExample.TestExampleInnerJoin;
var
  oIPerson: IPerson<TEPerson>;
  oIMatriculation: IModel<TEMatriculation>;
  SelectCommand: String;
begin
  oIPerson := TPerson.Create;
  oIMatriculation := TMatriculation.Create;

  oIPerson.PrepareModel('', []);
  oIMatriculation.PrepareModel('', []);

  SelectCommand := TSQLSelect.Create.Ref
    .Fields([oIPerson.PreparedFields, oIMatriculation.PreparedFields])
    .From(oIPerson.Table, oIPerson.TableAlias)
    .InnerJoin(
      TSQLJoin.Create.Ref
        .Table(oIMatriculation.TableAlias, oIMatriculation.Table)
        .&On(
          TSQLCondition.Create.Ref
            .LeftTerm(oIMatriculation.TableAlias + '.' + oIMatriculation.FieldName(temPersonSequential))
            .Op(opEqual)
            .RightTerm(oIPerson.TableAlias + '.' + oIPerson.FieldName(tepSequential))
        )
    )
    .Build;
end;
```

The output assigned to ```SelectCommand``` is:
```
SELECT PERSON.NR_SEQUENTIAL AS PERSON_SEQUENTIAL,
      PERSON.FL_NAME AS PERSON_NAME,
      PERSON.DT_BIRTHDATE AS PERSON_BIRTHDATE,
      PERSON.TX_EMAIL AS PERSON_EMAIL,
      PERSON.TX_PASSWORD AS PERSON_PASSWORD,
      MATRICULATION.NR_SEQUENTIAL AS MATRICULATION_SEQUENTIAL,
      MATRICULATION.NR_PERSONSEQUENTIAL AS MATRICULATION_PERSONSEQUENTIAL,
      MATRICULATION.DT_DATE AS MATRICULATION_DATE,
      MATRICULATION.CD_USER AS PERSON_USER
 FROM TB_PERSON AS PERSON
INNER JOIN TB_MATRICULATION AS MATRICULATION ON (MATRICULATION.NR_PERSONSEQUENTIAL = PERSON.NR_SEQUENTIAL)
```

### _There is a lot to implement, but it is this idea that I want to follow._

# Getting Started

A. Create a unit named "Enumerator.Person".

B. Create an enumerated TEPerson, see:

```pascal
unit Enumerator.Person

interface

uses
  Enumerator;

type
  TEPerson = (tepSequential, tepName, tepBirthDate, tepEmail, tepPassword);

implementation

end.
```

C. Create a class who inherit TEnumAbstract and implements IEnum, see the class and function declarations:

```pascal
unit Enumerator.Person

interface

uses
  Enumerator;

type
  TEPerson = (tepSequential, tepName, tepBirthDate, tepEmail, tepPassword);

  TEnumPessoa = class(TEnumAbstract<TEPerson>, IEnum<TEPerson>)
  public
    function Column(const AEnumeratedField: TEPerson): String; override;
    function ColumnAlias(const AEnumeratedField: TEPerson): String; override;
    function Table: String; override;
    function TableAlias(const AAlias: String = ''): String; override;
    function Sequence: String; override;
    function AllColumns: TArray<TEPerson>; override;
    function Ref: IEnum<TEPerson>; override;
  end;

implementation

end.
```


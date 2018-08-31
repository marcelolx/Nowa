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
    procedure TestBasicSelect;
  end;

implementation

uses
  Model,
  Enumerator.Person,
  PersonImpl,
  NowaImpl;

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
end;

initialization

RegisterTest(TNowaTest.Suite);

end.

unit ModelTest;

interface

uses
  TestFramework;

type
  TModelTest = class(TTestCase)
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestCreateModel;
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

initialization

RegisterTest(TModelTest.Suite);

end.

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


end;

initialization

RegisterTest(TNowaTest.Suite);

end.

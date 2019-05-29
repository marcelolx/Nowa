unit NowaMediatorTest;

interface

uses
  TestFramework,
  NowaMediator;

type
  TNowaMediatorTest = class(TTestCase)
  private
    FNowaMediator: INowaMediator<TObject>;
  public
    procedure SetUp; override;
  published
    procedure ShouldCreateSQLWhere;
    procedure ShouldCreateSQLBy;
    procedure ShouldCreateSQLCondition;
    procedure ShouldCreateSQLJoin;
    procedure ShouldCreateSQLSelect;
    procedure ShouldCreateSQLCommand;
  end;

implementation

uses
  NowaMediatorImpl,
  NowaSQLAdapterSQLiteImpl;

{ TNowaMediatorTest }

procedure TNowaMediatorTest.ShouldCreateSQLBy;
begin
  CheckNotNull(FNowaMediator.SQLBy);
end;

procedure TNowaMediatorTest.ShouldCreateSQLCommand;
begin
  CheckNotNull(FNowaMediator.SQLCommand);
end;

procedure TNowaMediatorTest.ShouldCreateSQLCondition;
begin
  CheckNotNull(FNowaMediator.SQLCondition);
end;

procedure TNowaMediatorTest.ShouldCreateSQLJoin;
begin
  CheckNotNull(FNowaMediator.SQLJoin);
end;

procedure TNowaMediatorTest.ShouldCreateSQLSelect;
begin
  CheckNotNull(FNowaMediator.SQLSelect);
end;

procedure TNowaMediatorTest.ShouldCreateSQLWhere;
begin
  CheckNotNull(FNowaMediator.SQLWhere);
end;

procedure TNowaMediatorTest.SetUp;
begin
  inherited;
  FNowaMediator := TNowaMediator<TObject>.Create(TNowaSQLAdapterSQLite.Create.Ref);
end;

initialization

RegisterTest(TNowaMediatorTest.Suite);

end.

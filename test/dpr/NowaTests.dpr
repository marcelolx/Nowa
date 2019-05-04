program NowaTests;

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  DUnitTestRunner,
  ModelTest in '..\ModelTest.pas',
  Nowa.Model in '..\..\Nowa.Model.pas',
  Nowa.ModelImpl in '..\..\Nowa.ModelImpl.pas',
  Nowa.Enumerator in '..\..\Nowa.Enumerator.pas',
  Enumerator.Person in '..\Person\Enumerator.Person.pas',
  PersonImpl in '..\Person\PersonImpl.pas',
  Nowa in '..\..\Nowa.pas',
  NowaImpl in '..\..\NowaImpl.pas',
  NowaTest in '..\NowaTest.pas',
  Enumerator.Matriculation in '..\Matriculation\Enumerator.Matriculation.pas',
  MatriculationImpl in '..\Matriculation\MatriculationImpl.pas',
  NowaDAO in '..\DAOExample\NowaDAO.pas',
  NowaDAOImpl in '..\DAOExample\NowaDAOImpl.pas',
  Person in '..\Person\Person.pas',
  Nowa.Enumerators in '..\..\Nowa.Enumerators.pas';

{$R *.RES}

begin
  DUnitTestRunner.RunRegisteredTests;
end.


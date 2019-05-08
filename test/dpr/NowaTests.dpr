program NowaTests;

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  DUnitTestRunner,
  ModelTest in '..\ModelTest.pas',
  NowaTest in '..\NowaTest.pas',
  NowaModel in '..\..\NowaModel.pas',
  NowaModelImpl in '..\..\NowaModelImpl.pas',
  NowaEnumerator in '..\..\NowaEnumerator.pas',
  Nowa in '..\..\Nowa.pas',
  NowaImpl in '..\..\NowaImpl.pas',
  NowaEnumerators in '..\..\NowaEnumerators.pas',
  NowaDAO in '..\..\NowaDAO.pas',
  NowaDAOImpl in '..\..\NowaDAOImpl.pas',
  Enumerator.Matriculation in '..\Matriculation\Enumerator.Matriculation.pas',
  MatriculationImpl in '..\Matriculation\MatriculationImpl.pas',
  Person in '..\Person\Person.pas',
  PersonImpl in '..\Person\PersonImpl.pas',
  Enumerator.Person in '..\Person\Enumerator.Person.pas';

{$R *.RES}

begin
  DUnitTestRunner.RunRegisteredTests;
end.


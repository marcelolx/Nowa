program NowaTests;

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  DUnitTestRunner,
  EntityTest in '..\EntityTest.pas',
  NowaTest in '..\NowaTest.pas',
  NowaEntity in '..\..\NowaEntity.pas',
  NowaEntityImpl in '..\..\NowaEntityImpl.pas',
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
  Enumerator.Person in '..\Person\Enumerator.Person.pas',
  NowaResourceStrings in '..\..\NowaResourceStrings.pas',
  NowaException in '..\..\NowaException.pas',
  NowaDatabaseAdapter in '..\..\NowaDatabaseAdapter.pas',
  NowaMediator in '..\..\NowaMediator.pas',
  NowaMediatorImpl in '..\..\NowaMediatorImpl.pas',
  NowaSQLAdapter in '..\..\NowaSQLAdapter.pas',
  NowaMediatorTest in '..\NowaMediatorTest.pas',
  NowaSQLAdapterImpl in '..\..\NowaSQLAdapterImpl.pas';

{$R *.RES}

begin
  DUnitTestRunner.RunRegisteredTests;
end.


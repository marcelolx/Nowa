program NowaTests;

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  DUnitTestRunner,
  ModelTest in '..\ModelTest.pas',
  Model in '..\..\Model.pas',
  ModelImpl in '..\..\ModelImpl.pas',
  Enumerator in '..\..\Enumerator.pas',
  Enumerator.Person in '..\Person\Enumerator.Person.pas',
  PersonImpl in '..\Person\PersonImpl.pas';

{$R *.RES}


begin
  DUnitTestRunner.RunRegisteredTests;
end.

program NowaSample1;

uses
  Vcl.Forms,
  SampleMain in 'SampleMain.pas' {NowaSampleMain},
  PersonEnumerator in 'PersonEnumerator.pas',
  PersonImpl in 'PersonImpl.pas',
  PersonDAOImpl in 'PersonDAOImpl.pas',
  PersonDAO in 'PersonDAO.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TNowaSampleMain, NowaSample);
  Application.Run;
end.

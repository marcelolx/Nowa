program NowaSample1;

uses
  Vcl.Forms,
  SampleMain in '.\SampleMain.pas' {NowaSampleMain};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TNowaSampleMain, NowaSampleMain);
  Application.Run;
end.

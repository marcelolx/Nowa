unit SampleMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteDef, FireDAC.Phys.SQLite,
  Data.DB, FireDAC.Comp.Client, PersonDAO, PersonEnumerator, PersonDAOImpl, NowaDatabaseAdapterFireDAC,
  NowaMediatorImpl, NowaSQLAdapterSQLiteImpl, Vcl.StdCtrls, NowaEntity, PersonImpl;

type
  TNowaSampleMain = class(TForm)
    FDatabaseConnection: TFDConnection;
    FPhysSQLiteDriverLink: TFDPhysSQLiteDriverLink;
    btnCreatePerson: TButton;
    procedure btnCreatePersonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FPersonDAO: IPersonDAO;
  public
    { Public declarations }
  end;

var
  NowaSample: TNowaSampleMain;

implementation

{$R *.dfm}

procedure TNowaSampleMain.btnCreatePersonClick(Sender: TObject);
var
  Person: IEntity<TEPerson>;
begin
  Person := TPerson.Create;
  Person.SetValue(pFirstName, 'Marcelo');
  Person.SetValue(pLastName, 'Lauxen');
  Person.SetValue(pBirthdate, Now);
  Person.SetValue(pGenre, 'M');
  Person.SetValue(pEmail, 'test@gmail.com');
  Person.SetValue(pPassword, '123');

  FPersonDAO.Save(Person);
end;

procedure TNowaSampleMain.FormCreate(Sender: TObject);
begin
  FDatabaseConnection.LoginPrompt := False;
  FDatabaseConnection.Params.Clear;
  FDatabaseConnection.Params.Values['Database'] := ExtractFilePath(ParamStr(0)) + 'nowaSample.s3db';
  FDatabaseConnection.Params.Add('DriverID=SQLite');
  FDatabaseConnection.Params.Add('SharedCache=False');
  FDatabaseConnection.Params.Add('LockingMode=Normal');
  FDatabaseConnection.Params.Add('Synchronous=Normal');
  FDatabaseConnection.UpdateOptions.LockWait := True;

  FDatabaseConnection.Open;

  FPersonDAO := TPersonDAO.Create(TNowaDataAccess.Create(FDatabaseConnection).Ref, TNowaMediator<TEPerson>.Create(TNowaSQLAdapterSQLite.Create.Ref));
  FPersonDAO.CreateTablePersonIfNotExists;
end;

end.

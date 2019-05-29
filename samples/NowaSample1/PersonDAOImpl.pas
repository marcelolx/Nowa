unit PersonDAOImpl;

interface

uses
  PersonDAO,
  NowaDAOImpl,
  PersonEnumerator;

type
  TPersonDAO = class(TNowaDAO<TEPerson>, IPersonDAO)
  public
    procedure CreateTablePersonIfNotExists;
  end;

implementation

{ TPersonDAO }

procedure TPersonDAO.CreateTablePersonIfNotExists;
const
  CreateTable = 'CREATE TABLE IF NOT EXISTS person (person_id INTEGER PRIMARY KEY, firstname TEXT, lastname TEXT, birthdate TEXT, genre TEXT, email TEXT, password TEXT);';
begin
  Command.DefineSQL(CreateTable);
  Command.Execute;
  Command.Close;
end;

end.

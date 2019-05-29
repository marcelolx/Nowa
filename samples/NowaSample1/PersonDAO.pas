unit PersonDAO;

interface

uses
  NowaDAO,
  PersonEnumerator;

type
  IPersonDAO = interface(INowaDAO<TEPerson>)
  ['{14EEFBB1-16C2-46BE-B48C-A42E7B217130}']
    procedure CreateTablePersonIfNotExists;
  end;

implementation

end.

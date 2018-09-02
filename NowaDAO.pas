unit NowaDAO;

interface

uses
  Model;

type
  INowaDAO<T> = interface
  ['{EE817A67-A1E1-4A10-A80B-79902480A007}']
    procedure Insert(const AModel: IModel<T>);
    procedure Update(const AModel: IModel<T>);
    procedure Save(const AModel: IModel<T>; const AModelKey: T);
  end;

implementation

end.

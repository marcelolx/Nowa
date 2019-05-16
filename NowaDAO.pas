unit NowaDAO;

interface

uses
  NowaEntity,
  FireDAC.Comp.Client;

type
  INowaDAO<T> = interface
  ['{EE817A67-A1E1-4A10-A80B-79902480A007}']
    procedure Insert(const Entity: IEntity<T>);
    procedure Update(const Entity: IEntity<T>);
    procedure Save(const Entity: IEntity<T>);
    procedure FillModel(const Entity: IEntity<T>; const Query: TFDQuery);
  end;

implementation

end.

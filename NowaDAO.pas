unit NowaDAO;

interface

uses
  NowaModel,
  FireDAC.Comp.Client;

type
  INowaDAO<T> = interface
  ['{EE817A67-A1E1-4A10-A80B-79902480A007}']
    procedure Insert(const Model: IModel<T>);
    procedure Update(const Model: IModel<T>);
    procedure Save(const Model: IModel<T>);
    procedure FillModel(const Model: IModel<T>; const Query: TFDQuery);
  end;

implementation

end.

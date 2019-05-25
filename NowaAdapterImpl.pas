unit NowaMediatorImpl;

interface

uses
  NowaMediator,
  Nowa;

type
  TNowaMediator<T> = class(TInterfacedObject, INowaMediator<T>)
  public
    function SQLWhere: ISQLWhere;
    function SQLBy: ISQLBy;
    function SQLCondition: ISQLCondition;
    function SQLJoin: ISQLJoin;
    function SQLSelect: ISQLSelect;
    function SQLCommand<T>: ISQLCommand<T>;
  end;

implementation

end.

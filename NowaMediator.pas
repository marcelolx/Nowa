unit NowaMediator;

interface

uses
  Nowa;

type
  INowaMediator<T> = interface
  ['{70A2A021-8347-4A78-A27A-C3D0162F7A68}']
    function SQLWhere: ISQLWhere;
    function SQLBy: ISQLBy;
    function SQLCondition: ISQLCondition;
    function SQLJoin: ISQLJoin;
    function SQLSelect: ISQLSelect;
    function SQLCommand: ISQLCommand<T>;
  end;

implementation

end.

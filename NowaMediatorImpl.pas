unit NowaMediatorImpl;

interface

uses
  NowaMediator,
  Nowa,
  NowaSQLAdapter,
  NowaImpl;

type
  TNowaMediator<T> = class(TInterfacedObject, INowaMediator<T>)
  private
    FSQLAdapter: INowaSQLAdapter;
  public
    function SQLWhere: ISQLWhere;
    function SQLBy: ISQLBy;
    function SQLCondition: ISQLCondition;
    function SQLJoin: ISQLJoin;
    function SQLSelect: ISQLSelect;
    function SQLCommand: ISQLCommand<T>;

    function Ref: INowaMediator<T>;
    constructor Create(const SQLAdapter: INowaSQLAdapter);
  end;

implementation

{ TNowaMediator<T> }

constructor TNowaMediator<T>.Create(const SQLAdapter: INowaSQLAdapter);
begin
  FSQLAdapter := SQLAdapter;
end;

function TNowaMediator<T>.Ref: INowaMediator<T>;
begin
  Result := Self;
end;

function TNowaMediator<T>.SQLBy: ISQLBy;
begin
  Result := TSQLBy.Create;
end;

function TNowaMediator<T>.SQLCommand: ISQLCommand<T>;
begin
  Result := TSQLCommand<T>.Create(FSQLAdapter);
end;

function TNowaMediator<T>.SQLCondition: ISQLCondition;
begin
  Result := TSQLCondition.Create;
end;

function TNowaMediator<T>.SQLJoin: ISQLJoin;
begin
  Result := TSQLJoin.Create;
end;

function TNowaMediator<T>.SQLSelect: ISQLSelect;
begin
  Result :=  TSQLSelect.Create;
end;

function TNowaMediator<T>.SQLWhere: ISQLWhere;
begin
  Result := TSQLWhere.Create;
end;

end.

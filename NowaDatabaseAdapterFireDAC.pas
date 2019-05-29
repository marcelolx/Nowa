unit NowaDatabaseAdapterFireDAC;

interface

uses
  NowaDatabaseAdapter,
  FireDAC.Comp.Client,
  Data.DB,
  FireDAC.Stan.Param,
  FireDAC.DApt;

type
  TNowaParamAdapter = class(TInterfacedObject, INowaParamAdapter)
  private
    FParam: TFDParam;
  public
    function GetValue: Variant; overload;
    function AsLargeInt: Int64;
    procedure SetValue(const Value: Variant); overload;

    constructor Create(const Param: TFDParam); reintroduce;
  end;

  TNowaFieldAdapter = class(TInterfacedObject, INowaFieldAdapter)
  private
    FField: TField;
  public
    function GetValue: Variant; overload;
    procedure SetValue(const Value: Variant); overload;
    function AsLargeInt: Int64;

    constructor Create(const Field: TField); reintroduce;
  end;

  TNowaQueryAdapter = class(TInterfacedObject, INowaQueryAdapter)
  private
    FQuery: TFDQuery;
  public
    procedure DefineSQL(const Command: string);
    procedure Close;
    procedure Open;
    function FieldByName(const FieldName: string): INowaFieldAdapter;    

    constructor Create(const Connection: TFDConnection); reintroduce;
    destructor Destroy; override;
  end;

  TNowaCommandAdapter = class(TInterfacedObject, INowaCommandAdapter)
  private
    FCommand: TFDCommand;
  public
    procedure DefineSQL(const Command: string);
    procedure Close;
    procedure Execute;
    function ParamByName(const ParamName: string): INowaParamAdapter;    

    constructor Create(const Connection: TFDConnection); reintroduce;
    destructor Destroy; override;
  end;

  TNowaDataAccess = class(TInterfacedObject, INowaDataAccess)
  private
    FConnection: TFDConnection;
    FQueryAdapter: INowaQueryAdapter;
    FCommandAdapter: INowaCommandAdapter;
  public
    function Query: INowaQueryAdapter;
    function Command: INowaCommandAdapter;
    function Ref: INowaDataAccess;

    constructor Create(const Connection: TFDConnection); reintroduce;
  end;

implementation

{ TNowaParamAdapterFireDAC }

function TNowaParamAdapter.AsLargeInt: Int64;
begin
  Result := FParam.AsLargeInt;
end;

constructor TNowaParamAdapter.Create(const Param: TFDParam);
begin
  FParam := Param;
end;

function TNowaParamAdapter.GetValue: Variant;
begin
  Result := FParam.Value;
end;

procedure TNowaParamAdapter.SetValue(const Value: Variant);
begin
  FParam.Value := Value;
end;

{ TNowaQueryAdapter }

procedure TNowaQueryAdapter.Close;
begin
  FQuery.Close;
end;

constructor TNowaQueryAdapter.Create(const Connection: TFDConnection);
begin
  FQuery := TFDQuery.Create(nil);
  FQuery.Connection := Connection;
  FQuery.ConnectionName := Connection.ConnectionName;
end;

procedure TNowaQueryAdapter.DefineSQL(const Command: string);
begin
  FQuery.SQL.Text := Command;
end;

destructor TNowaQueryAdapter.Destroy;
begin
  FQuery.Free;
  inherited;
end;

function TNowaQueryAdapter.FieldByName(const FieldName: string): INowaFieldAdapter;
begin
  Result := TNowaFieldAdapter.Create(FQuery.FieldByName(FieldName));
end;

procedure TNowaQueryAdapter.Open;
begin
  FQuery.Open;
end;

{ TNowaCommandAdapter }

procedure TNowaCommandAdapter.Close;
begin
  FCommand.Close;
end;

constructor TNowaCommandAdapter.Create(const Connection: TFDConnection);
begin
  FCommand := TFDCommand.Create(nil);
  FCommand.Connection := Connection;
  FCommand.ConnectionName := Connection.ConnectionName;
end;

procedure TNowaCommandAdapter.DefineSQL(const Command: string);
begin
  FCommand.CommandText.Text := Command;
end;

destructor TNowaCommandAdapter.Destroy;
begin
  FCommand.Free;
  inherited;
end;

procedure TNowaCommandAdapter.Execute;
begin
  FCommand.Execute;
end;

function TNowaCommandAdapter.ParamByName(const ParamName: string): INowaParamAdapter;
begin
  Result := TNowaParamAdapter.Create(FCommand.ParamByName(ParamName));
end;

{ TNowaDataAccess }

function TNowaDataAccess.Command: INowaCommandAdapter;
begin
  if not Assigned(FCommandAdapter) then
    FCommandAdapter := TNowaCommandAdapter.Create(FConnection);

  Result := FCommandAdapter;
end;

constructor TNowaDataAccess.Create(const Connection: TFDConnection);
begin
  FConnection := Connection;
end;

function TNowaDataAccess.Query: INowaQueryAdapter;
begin
  if not Assigned(FQueryAdapter) then
    FQueryAdapter := TNowaQueryAdapter.Create(FConnection);

  Result := FQueryAdapter;
end;

function TNowaDataAccess.Ref: INowaDataAccess;
begin
  Result := Self;
end;

{ TNowaFieldAdapter }

function TNowaFieldAdapter.AsLargeInt: Int64;
begin
  Result := FField.AsLargeInt;
end;

constructor TNowaFieldAdapter.Create(const Field: TField);
begin
  FField := Field;
end;

function TNowaFieldAdapter.GetValue: Variant;
begin
  FField.Value
end;

procedure TNowaFieldAdapter.SetValue(const Value: Variant);
begin
  FField.Value := Value;
end;

end.

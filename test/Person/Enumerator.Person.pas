unit Enumerator.Person;

interface

uses
  Enumerator;

type
  TEPerson = (tepSequential, tepName, tepBirthDate, tepMail, tepPassword);

  TEnumPerson = class(TEnumAbstract<TEPerson>, IEnum<TEPerson>)
  public
    function Column(const AEnumeratedField: TEPerson): String; override;
    function ColumnAlias(const AEnumeratedField: TEPerson): String; override;
    function Columns(const AEnumeratedFields: TArray<TEPerson>): TArray<String>; override;
    function ColumnsAlias(const AEnumeratedFields: TArray<TEPerson>): TArray<String>; override;
    function Table: String; override;
    function TableAlias(const AAlias: String = ''): String; override;
    function Ref: IEnum<TEPerson>; override;
  end;

implementation

uses
  System.SysUtils;

{ TEnumPeople }

function TEnumPerson.Column(const AEnumeratedField: TEPerson): String;
begin
  Result := EmptyStr;
  
  case AEnumeratedField of
    tepSequential: 
      Result := 'NR_SEQUENTIAL';
      
    tepName: 
      Result := 'FL_NAME';
      
    tepBirthDate: 
      Result := 'DT_BIRTHDATE';
      
    tepMail: 
      Result := 'TX_MAIL';
      
    tepPassword: 
      Result := 'TX_PASSWORD';
  else
    raise Exception.Create('Enumerated field doesn''t have a column.');
  end;
end;



function TEnumPerson.ColumnAlias(const AEnumeratedField: TEPerson): String;
begin
  Result := EmptyStr;
  
  case AEnumeratedField of
    tepSequential: 
      Result := 'PERSON_SEQUENTIAL';
      
    tepName: 
      Result := 'PERSON_NAME';
      
    tepBirthDate: 
      Result := 'PERSON_BIRTHDATE';
      
    tepMail: 
      Result := 'PERSON_MAIL';
      
    tepPassword: 
      Result := 'PERSON_PASSWORD';
  else
    raise Exception.Create('Enumerated field doesn''t have a column.');
  end;
end;



function TEnumPerson.Columns(const AEnumeratedFields: TArray<TEPerson>): TArray<String>;
var
  oEField: TEPerson;
begin
  SetLength(Result, 0);

  for oEField in AEnumeratedFields do
  begin
    SetLength(Result, Succ(Length(Result)));
    Result[Pred(Length(Result))] := Column(oEField);
  end;
end;



function TEnumPerson.ColumnsAlias(const AEnumeratedFields: TArray<TEPerson>): TArray<String>;
var
  oEField: TEPerson;
begin
  SetLength(Result, 0);

  for oEField in AEnumeratedFields do
  begin
    SetLength(Result, Succ(Length(Result)));
    Result[Pred(Length(Result))] := ColumnAlias(oEField);
  end;
end;



function TEnumPerson.Ref: IEnum<TEPerson>;
begin
  Result := Self;
end;



function TEnumPerson.Table: String;
begin
  Result := 'TB_PERSON';
end;



function TEnumPerson.TableAlias(const AAlias: String): String;
begin
  Result := AAlias;

  if (Result.IsEmpty) then
    Result := 'PERSON';
end;

end.

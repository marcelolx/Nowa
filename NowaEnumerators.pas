unit NowaEnumerators;

interface

type
  TSQLLikeOperator = (loEqual, loStarting, loEnding, loContaining);

  TSQLOperator = (opEqual, opDifferent, opGreater, opLess, opGreaterOrEqual, opLessOrEqual, opLike, opNotLike, opIsNull, opNotNull);

  TNowaEnumerators = class
  public
    class function GetOperator(const Operator: TSQLOperator): String;
  end;

implementation

{ TNowaEnumerators }

class function TNowaEnumerators.GetOperator(const Operator: TSQLOperator): String;
begin
  case Operator of
    opEqual:
      Result := ' = ';
    opDifferent:
      Result := ' <> ';
    opGreater:
      Result := ' > ';
    opLess:
      Result := ' < ';
    opGreaterOrEqual:
      Result := ' >= ';
    opLessOrEqual:
      Result := ' <= ';
    opLike:
      Result := ' like ';
    opNotLike:
      Result := ' not like ';
    opIsNull:
      Result := ' is null ';
    opNotNull:
      Result := ' is not null ';
  end;
end;

end.

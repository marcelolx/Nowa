unit NowaException;

interface

uses
  System.SysUtils,
  NowaResourceStrings;

type
  EntityFieldException = class(Exception)
  public
    constructor Create(const EntityName: string); reintroduce;
  end;

implementation

{ EntityFieldException }

constructor EntityFieldException.Create(const EntityName: string);
begin
  inherited Create(Format(FieldDoesntHaveRelationshipWithEntityAttribute, [EntityName]));
end;

end.

unit Nowa.Model;

interface

uses
  Nowa.Records;

type
  IModel<T> = interface
  ['{C466292A-8F89-4B1F-B3BF-EE5588621D00}']
    procedure PrepareModel(const ATableAlias: String; const AFields: TArray<T>);
    procedure SetValue(const AField: T; const AValue: Variant);

    function GetValue(const AField: T): Variant;
    function FieldName(const AField: T): String;
    function FieldAliasName(const AField: T): string;
    function GetFields: TArray<String>;
    function GetEnumeratedFields: TArray<T>;
    function GetFieldsAlias: TArray<String>;
    function GetTable: String;
    function GetTableAlias: String;
    function GetSequence: String;
    function PreparedFields: RFieldsPrepared;

    property Fields: TArray<String> read GetFields;
    property EnumFields: TArray<T> read GetEnumeratedFields;
    property FieldsAlias: TArray<String> read GetFieldsAlias;
    property Table: String read GetTable;
    property TableAlias: String read GetTableAlias;
    property Sequence: String read GetSequence;
  end;

implementation

end.

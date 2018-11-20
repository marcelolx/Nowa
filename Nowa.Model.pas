unit Nowa.Model;

interface

type
  ITable = interface
  ['{FC81A8C0-DF1D-4DC2-AE14-4EAECDEE0DCD}']
    function Name: String;
    function Alias: String;
    function Sequence: String;
    procedure Prepare(const AAlias: String);
  end;

  IField = interface
  ['{B4D2955E-B979-4EE0-96AD-5B12311635C7}']
    function Name: String;
    function Alias: String;
    function Table: ITable;
  end;

  IModel<T> = interface
  ['{C466292A-8F89-4B1F-B3BF-EE5588621D00}']
    procedure PrepareModel(const ATableAlias: String; const AFields: TArray<T>);
    procedure SetValue(const AField: T; const AValue: Variant);

    function Table: ITable;
    function GetValue(const AField: T): Variant;
    function Field(const AField: T): IField; overload;
    function Field(const AField: IField): T; overload;
    function Fields: TArray<IField>;
  end;

implementation

end.

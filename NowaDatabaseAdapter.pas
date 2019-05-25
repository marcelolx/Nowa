unit NowaDatabaseAdapter;

interface

type
  INowaParamAdapter = interface
  ['{6ABA66E5-94C8-47ED-82B8-711D7860EBAC}']
    function GetValue: Variant; overload;
    function AsLargeInt: Int64;
    procedure SetValue(const Value: Variant); overload;

    property Value: Variant read GetValue write SetValue;
  end;

  INowaDataAccessBase = interface
  ['{8E66FDD5-5601-4E80-A369-C1CAF9BCC706}']
    procedure DefineSQL(const Command: string);
    procedure Close;
  end;

  INowaQueryAdapter = interface(INowaDataAccessBase)
  ['{D8A861A9-7600-4450-8AE6-295589CDD520}']
    function FieldByName(const FieldName: string): INowaParamAdapter;
    function Open: Boolean;
  end;

  INowaCommandAdapter = interface(INowaDataAccessBase)
  ['{FC68A143-BD4A-4931-9E47-00B10703EA27}']
    function ParamByName(const ParamName: string): INowaParamAdapter;
    function Execute: Boolean;
  end;

  INowaDataAccess = interface
  ['{699F2178-72CC-4694-96D9-8349B4C8E6EE}']
    function Query: INowaQueryAdapter;
    function Command: INowaCommandAdapter;
  end;

implementation

end.

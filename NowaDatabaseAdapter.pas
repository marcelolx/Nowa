unit NowaDatabaseAdapter;

interface

type
  INowaParamAdapter = interface
  ['{6ABA66E5-94C8-47ED-82B8-711D7860EBAC}']
    function Value: Variant; overload;
    procedure Value(const Value: Variant); overload;
  end;

  INowaQueryAdapter = interface
  ['{D8A861A9-7600-4450-8AE6-295589CDD520}']

  end;

  INowaCommandAdapter = interface
  ['{FC68A143-BD4A-4931-9E47-00B10703EA27}']
    procedure DefineCommand(const Command: string);

    function ParamByName(const ParamName: string): INowaParamAdapter;
  end;

implementation

end.

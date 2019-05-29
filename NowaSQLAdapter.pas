unit NowaSQLAdapter;

interface

type
  INowaSQLAdapter = interface
  ['{D02EC2C7-26C7-4626-9AB2-DE33D5093358}']
    function NewKeyValue(const SequenceName: string): String;
  end;

implementation

end.

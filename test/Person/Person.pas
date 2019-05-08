unit Person;

interface

uses
  NowaModel,
  Enumerator.Person,
  Enumerator.Matriculation;

type
  IPerson<TEPerson> = interface(IModel<TEPerson>)
  ['{F8FF9944-9DB4-4B73-B264-F6614E4875F6}']
    procedure SetValue(const Field: TEMatriculation; const Value: Variant); overload;
    function GetValue(const Field: TEMatriculation): Variant; overload;
  end;

implementation

end.

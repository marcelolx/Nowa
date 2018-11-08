unit Person;

interface

uses
  Nowa.Model,
  Enumerator.Person,
  Enumerator.Matriculation;

type
  IPerson<TEPerson> = interface(IModel<TEPerson>)
  ['{F8FF9944-9DB4-4B73-B264-F6614E4875F6}']
    procedure SetValue(const AField: TEMatriculation; const AValue: Variant); overload;
    function GetValue(const AField: TEMatriculation): Variant; overload;
  end;

implementation

end.

unit LL___REG;
(*
15.05.02 MD TL8MD und LLPrn aus KMP hier plaziert
*)
interface

uses
  Classes, DB, Tabs, ExtCtrls;

  (* Kompatibilität: *)


procedure Register;

implementation

uses
  DesignIntf, DesignEditors, TypInfo,
  L17MD_Kmp, LlPrnKmp;


(* Register *)
procedure Register;
begin
  (* Combit List&Label Erweiterung: *)
  RegisterComponents('LNAV', [TLlPrn]);
  RegisterComponents('combit', [TL17MD]);
end;

end.

unit LlPrnDlg;
(* List & Label - Dialog i.v.m. TLlPrn Komponente

   Autor: Martin Dambach
   Letzte Änderung
   01.03.02     Erstellen
*)

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB, DBTables, Uni, DBAccess, MemDS, Mask, ExtCtrls, TabNotBk,
  Tabs, Grids, DBGrids, Buttons,
  LNav_Kmp, LuDefKmp, Qwf_Form, Menus, Spin, Lubtnkmp, PSrc_Kmp,
  Kmp__reg, Dialogs, DatumDlg, Luedikmp, Ausw_Kmp, Mugrikmp,
  LlPrnKmp;

type
  TDlgLlPrn = class(TqForm)
    Nav: TLNavigator;
    PopupMenu1: TPopupMenu;
    MiLookUp: TMenuItem;
    PanBottom: TPanel;
    BtnClose: TBitBtn;
    BtnSetup: TBitBtn;
    BtnPrn: TBitBtn;
    BtnScr: TBitBtn;
    PanTop: TPanel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure BtnPrnClick(Sender: TObject);
    procedure NavStart(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  protected
  private
    { Private-Deklarationen }
    FDtmVon, FDtmBis: TDateTime;
    procedure SetDtmVon( Value: TDateTime);
    procedure SetDtmBis( Value: TDateTime);
  public
    { Public-Deklarationen }
    LlPrn: TLlPrn;
    DateFmt: string;
    InDoPrn: boolean;
    procedure Prepare;           {LlPrn-Felder definieren anhand Eingabe}
    procedure DoPrn( Preview: boolean);
    property DtmVon: TDateTime read FDtmVon write SetDtmVon;
    property DtmBis: TDateTime read FDtmBis write SetDtmBis;
  end;


implementation
{$R *.DFM}
uses
  Printers,
  GNav_Kmp, Ini__Kmp, Prots, Asws_Kmp, Lov__Dlg, Asw__Dlg, Nlnk_Kmp,
  Tools, nstr_Kmp, Err__Kmp, Poll_Kmp, DPos_Kmp;

procedure TDlgLlPrn.FormCreate(Sender: TObject);
begin
  Sizeable := true;
end;

procedure TDlgLlPrn.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if InDoPrn and (LlPrn <> nil) then
    Action := LlPrn.CloseAction else
    Action := caFree;
end;

procedure TDlgLlPrn.FormDestroy(Sender: TObject);
begin
  if LlPrn <> nil then
    LlPrn.DlgLlPrn := nil;
end;

procedure TDlgLlPrn.NavStart(Sender: TObject);
begin (* NavStart *)
  if (Caller = nil) or not (Caller is TLlPrn) then
  begin
    ErrWarn('Auswahldialog kann nicht gestartet werden',[0]);
    Close;
    Exit;
  end;
  LlPrn := (Caller as TLlPrn);
  LlPrn.DlgLlPrn := self;
end;

(*** Hilfsroutinen ***********************************************************)

procedure TDlgLlPrn.DoPrn(Preview: boolean);
begin
  if LlPrn <> nil then
  try
    InDoPrn := true;
    LlPrn.Preview := Preview;
    LlPrn.DoPrn;
    if LlPrn.CloseAction <> caNone then
      Close;
  finally
    InDoPrn := false;
  end else
  begin
    ErrWarn('Ausdruck kann nicht mehr gestartet werden', [0]);
    Close;
  end;
end;

(*** Auswertungen ************************************************************)

procedure TDlgLlPrn.BtnPrnClick(Sender: TObject);
begin
  DoPrn( false);
end;

(*** Ereignisse **************************************************************)

end.

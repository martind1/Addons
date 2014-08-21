unit fldchk;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, CheckLst;

type
  TFldChooseDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    FieldsLB: TCheckListBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FldChooseDlg: TFldChooseDlg;

implementation

{$R *.DFM}

end.

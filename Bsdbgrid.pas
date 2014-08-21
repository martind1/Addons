

{================ BSDBGRID DISTRIBUTION NOTES ============================================}


{BSDBGRID is a simple, but very effective TDBGRID descendant that can display
each cell in the grid with either a raised, or lowered, 3-D appearance; in addition
to the usual 'flat' appearance. Memo fields can be displayed as formatted, wrapped text, and
Image fields show the associated image as a thumbnail. Rowheights are adjustable at run time
by dragging the split cursor whilst over the fixed column. BSDBGRID also provides added
functionality in that the MOUSEUP and MOUSEDOWN events are inherited. }

{COPYRIGHT NOTICE}
{BSDBGRID is distributed as FREEWARE, but remains the COPYRIGHT of
BUSINESS SOFTWARE (UK) (email  ebinfo@compuserve.com ). Business Software grants you the right
to include this compiled component in your DELPHI application, whether COMMERCIAL, SHAREWARE, or
FREEWARE, BUT YOU MAY NOT DISTRIBUTE THIS SOURCE CODE OR ITS COMPILED .DCU  IN ANY FORM OTHER
THAN AS IT EXISTS HERE; COMPLETE WITH THIS NOTICE AND ALL THE TEXT BELOW. BSDBGRID may be included
in any shareware or freeware libraries or compilation disks, provided no charge other than the
usual media cost recovery is made.}

{IF YOU HAVE ANY DOUBTS ABOUT WHETHER YOU MAY LEGALLY USE OR DISTRIBUTE THIS COMPONENT,
CONTACT BUSINESS SOFTWARE BY E-MAIL.}

{VISIT BUSINESS SOFTWARE'S WEB SITE AT HTTP://OURWORLD.COMPUSERVE.COM/HOMEPAGES/EBINFO/  for
more interesting components and applications}

{WARRANTY / ACCEPTANCE OF LIABILITY / INDEMNITY}
{ABSOLUTELY NONE WHATSOEVER}


{INSTALLATION}
{1.Copy all files into your DELPHI/LIB directory, or wherever your library files are kept}
{2.Select OPTIONS|INSTALL COMPONENTS|ADD...}
{3.ADD This file; BSDBGRID.PAS to the INSTALLED UNITS listbox}
{4.Click OK}

{USING BSDBGRID}
{In order to set the effects, a new PROPERTY 'Cellstyle', is published. Cellstyle may
have one of three possible values: csNONE (default), csRAISED, and csLOWERED.
Cellstyle may be set at design time, and will have a global effect on the Grid display,
however, a much more interesting effect can be achieved if the property is altered dynamically
at run time.

For example; to LOWER any cells that contain a numerical value less than zero, and RAISE
any cells with a value greater than 100, add within the 'ondrawdatacell' event handler,
the code to raise or lower the cell.
e.g.

procedure Tform1.BSDBGrid1DrawDataCell(Sender:TObject;const Rect:TRect;
Field:TField;State:TGridDrawState);
const
numbertypes=[ftcurrency,ftfloat,ftinteger,ftsmallint,ftbcd,ftword];

begin
with bsdbgrid1 do
  begin
  cellstyle:=csnone;
  if (field.datatype in numbertypes) then
     begin
     if (field.asfloat<0) then Cellstyle:=csLowered;
     if (field.asfloat>100) then Cellstyle:=csRaised;
     end;

     {if default drawing is off, we still need to do the text drawing;
     you could make the most of it here by using different font colors for
     positives and negatives, etc, But for this demo, here
     is the elementary way:

     Canvas.TextRect(Rect,Rect.left+2,Rect.Top+2,field.asString);


  end;
end;

property DefaultRowHeight Default Row Height.
property ShowImages       ShowImages as thumbnails
property ShowMemoText     Show memos as wrapped text within cell.






{=============== END OF DISTRIBUTION NOTES ===================================================}

unit BSDBGrid;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Grids, DBGrids,DB;

type
Tcellstyle=(csRaised,csLowered,csNone);

type
  TBSDBGrid = class(TDBGrid)
  private
    Fcellstyle:Tcellstyle;
    FOnMouseDown:TMouseEvent;
    FOnMouseUp:TMouseEvent;
    FRowHeight:Integer;
    FShowImages:boolean;
    FShowMemoText:boolean;
    procedure setcellstyle(value:Tcellstyle);
    procedure setcellspacing(value:integer);
    function getcellspacing:integer;
    procedure setshowimages(value:boolean);
    procedure setshowmemotext(value:boolean);

  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure DrawColumnCell(const Rect:TRect;DataCol:Integer;Column:TColumn;
              State:TGridDrawState); override;
    procedure DrawCell(ACol, ARow: Longint;ARect: TRect; AState: TGridDrawState); override;
    procedure setdefaultrowheight(value:integer);
    function getdefaultrowheight:integer;
    procedure LayoutChanged; override;
    procedure RowHeightsChanged; override;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;


  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;

  published
    property Cellstyle:tcellstyle read fcellstyle write setcellstyle;
    property OnMouseDown read FOnMouseDown write FOnMouseDown;
    property OnMouseUp read FOnMouseUp write FOnMouseUp;
    property CellSpacing:Integer read getcellspacing write setcellspacing default 1;
    property DefaultRowHeight:Integer read GetDefaultRowHeight write SetDefaultRowHeight;
    property ShowImages:boolean read Fshowimages write setshowimages default true;
    property ShowMemoText:boolean read FShowMemoText write setShowMemoText default true;

  end;

procedure Register;

implementation
  
const
imagetypes=[ftblob,ftgraphic,ftTypedBinary,ftParadoxOle,ftDBaseOle];
memotypes=[ftmemo,ftfmtmemo, ftString];

Type
TCustomGridHack = class(TCustomGrid)
Public
Property Options;
end;

constructor TBSDBGrid.Create(AOwner : TComponent);
begin
inherited Create(AOwner);
TCustomGridHack(Self).Options:=TCustomGridHack(Self).Options+[goRowSizing];
cellstyle:=csNone;
FRowheight:=17;
Fshowimages:=true;
FShowMemoText:=true;
end;

procedure TBSDBGrid.WMSize(var Message: TWMSize);
begin
inherited;
invalidate;
end;

procedure TBSDBGrid.CMFontChanged(var Message: TMessage);
var h:integer;
begin
inherited;
canvas.font.assign(font);
h:=canvas.textheight('Wg');
if FRowHeight<h then setdefaultrowheight(h);
if (csdesigning in componentstate) then invalidate;
end;




procedure TBSdbgrid.DrawColumnCell(const Rect:TRect;DataCol:Integer;
Column: TColumn; State: TGridDrawState);
var f:TField;

procedure imagecell;
var
r:trect;
w,h:integer;
pic:TPicture;
x:single;
begin
with rect,canvas do
  begin
  r:=rect;
  fillrect(rect);
  pic:=tpicture.create;
   try
   pic.assign(f);
   if not ((pic.Graphic=nil) or (pic.Graphic.Empty)) then
      begin
      x:=(pic.width/pic.height);{aspect ratio}
      h:=r.bottom-r.top;
      w:=trunc(h*x);
      if w>(right-left) then  {re-proportion pic}
         begin
         w:=(right-left);
         h:=trunc(w/x);
         end;
      r.left:=(right+left-w) shr 1;
      r.right:=r.left+w;
      r.top:=(bottom+top-h) shr 1;
      r.bottom:=r.top+h;
      inflaterect(r,-1,-1);
      stretchdraw(r,pic.graphic);
      end;
   finally
   pic.free;
   end;
  end;
end;

{draw multi-line text in memo fields}
procedure memocell;
var
r:Trect;
s:string;
begin
with canvas do
  begin
  fillrect(rect);
  s := f.asstring; // GetFieldText(F);
  if s='' then exit;
  r:=rect;
  inflaterect(r,-1,-1);
  r.right:=r.right-getsystemmetrics(SM_CXVSCROLL);
  drawtext(canvas.handle,pchar(s),-1,r,DT_WORDBREAK or DT_NOPREFIX);
  end;
end;

begin
inherited drawcolumncell(rect,datacol,column,state);
if (gdFixed in state) then exit;
f:=column.field;
if (f.datatype in imagetypes) and Fshowimages then imagecell;
if (f.datatype in memotypes) and
   FShowmemotext then
  memocell;
end;


procedure TBSDBGrid.DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState);

 procedure drawrect(l,t,r,b:integer;p1,p2:Tcolor);
 begin
 with ARect,canvas do
  begin
  Pen.Color :=p1 ;
  PolyLine([Point(l,b),Point(l,t),Point(r,t)]);
  Pen.Color :=p2;
  PolyLine([Point(l,b),Point(r,b),Point(r,t)]);
  end;
 end;

begin
inherited;
with ARect do
  begin
   case fcellstyle of
   csRaised:  drawrect(left,top,right,bottom-1,clWindow,clBtnShadow);
   csLowered: drawrect(left,top,right,bottom,clBtnShadow,clWindow);
   end;
  end;
end;


procedure TBSDBGrid.Setcellstyle(Value:Tcellstyle);
begin
if (fcellstyle<>value) then fcellstyle:=value;
if (csDesigning in componentstate) then invalidate;
end;

procedure TBSDBGrid.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
if Assigned(FOnMouseDown) then FOnMouseDown(Self, Button, Shift, X, Y);
inherited MouseDown(Button, Shift, X, Y);
end;

procedure TBSDBGrid.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
if Assigned(FOnMouseUp) then FOnMouseUp(Self, Button, Shift, X, Y);
inherited MouseUp(Button, Shift, X, Y);
end;

procedure TBsdbgrid.Setcellspacing(value:integer);
begin
if (value>=-1) and (value<=32) then gridlinewidth:=value;
if (csDesigning in ComponentState) then invalidate;
end;

function TBSdbgrid.getcellspacing:integer;
begin
result:=gridlinewidth;
end;

procedure TBSDBGrid.setshowimages(value:boolean);
begin
if Fshowimages<>value then
 begin
 Fshowimages:=value;
 invalidate;
 end;
end;

procedure TBSDBGrid.setshowmemotext(value:boolean);
begin
if FShowMemoText<>value then
 begin
 FShowMemoText:=value;
 invalidate;
 end;
end;

function TBSdbGrid.GetDefaultRowHeight:Integer;
begin
Result:=Inherited DefaultRowHeight;
end;

procedure TBSdbGrid.SetDefaultRowHeight(Value: Integer);
begin
FRowHeight:=value;
inherited defaultrowheight:=FRowHeight;
if (dgTitles in Options) then
   begin
   Canvas.Font:=TitleFont;
   RowHeights[0]:=Canvas.TextHeight('Wg')+4;
   end;
end;

procedure TBSDBGrid.LayoutChanged;
begin
Inherited;
SetDefaultRowHeight(FRowHeight);
end;

procedure TBSDBGrid.RowHeightsChanged;
var
i,h:Integer;
begin
if (csDestroying in ComponentState) then exit;
h:=DefaultRowHeight;
for i:=Ord(dgTitles in Options) to pred(RowCount) do If RowHeights[i]<>h then break;
if RowHeights[i]<>h then
   begin
   SetDefaultRowHeight(RowHeights[i]);
   recreatewnd;
   end;
inherited;
end;

destructor TBSDBGrid.Destroy;
begin
inherited destroy;
end;

procedure Register;
begin
RegisterComponents('Addons', [TBSDBGrid]);
end;

end.

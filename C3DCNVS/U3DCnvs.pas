unit U3DCnvs;

interface

uses
  Windows, Classes, SysUtils, Controls, Forms,
  Graphics, Messages, Dialogs,
  StdCtrls, Math;

type
  TPoint3D = record x,y,z :Extended;  end;

  TViewer   = class(TPersistent)
  private
    FLongitude: Extended;
    FLatitude: Extended;
    FSize:Extended;
    FDistance,
    FZoom,

    FIx, FIy, FIz,
    FJx, FJy,
    FKx, FKy, FKz
            : Extended;

    FOnChange: TNotifyEvent;
    procedure SetLongitude(Value: Extended);
    procedure SetLatitude(Value: Extended);
    procedure SetSize(Value: Extended);
    procedure SetDistance(Value: Extended);
    procedure SetZoom(Value: Extended);
    procedure Changed;
  public
    procedure Assign(Value: TViewer); reintroduce;
    procedure Update;
  published
    property Longitude: Extended read FLongitude write SetLongitude;
    property Latitude: Extended read FLatitude write SetLatitude;
    property Size: Extended read FSize write SetSize;
    property Distance: Extended read FDistance write SetDistance;
    property Zoom: Extended read FZoom write SetZoom;

    property Ix:Extended read FIx;
    property Iy:Extended read FIy;
    property Iz:Extended read FIz;
    property Jx:Extended read FJx;
    property Jy:Extended read FJy;
    property Kx:Extended read FKx;
    property Ky:Extended read FKy;
    property Kz:Extended read FKz;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TC3DCanvas = class(TGraphicControl)
  private
    FPen    : TPen;
    FBrush  : TBrush;
    FFont   : TFont;
    FViewer:TViewer;
    FMinX:Extended;
    FMaxX:Extended;
    FMinY:Extended;
    FMaxY:Extended;
    FScale:Extended;
    FDrawing:Boolean;
    procedure SetPen        (Value: TPen);
    procedure SetBrush      (Value: TBrush);
    procedure SetFont       (Value: TFont);
    procedure SetViewer     (Value : TViewer);
    procedure SetMinX(Value:Extended);
    procedure SetMaxX(Value:Extended);
    procedure SetMinY(Value:Extended);
    procedure SetMaxY(Value:Extended);
    procedure SetDrawing(Value:Boolean);
    procedure UpdateScale;
  protected
    {property  Canvas;         MD}
    procedure Paint; override;
    function  RealToScreen(Point3D:TPoint3D):TPoint;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure   Clear;
    procedure   SetWindow (xmin, xmax, ymin, ymax : Extended);
    procedure   MoveTo    (P3D: TPoint3D);
    procedure   LineTo    (P3D: TPoint3D);
    procedure   TextOut   (P3D_Start, P3D_end: TPoint3D; Text:ShortString);
    procedure   Polygon(Points: array of TPoint3D);
    procedure   Polyline(Points: array of TPoint3D);
    property    Canvas;  {MD}
  published
    property Align;
    property Viewer : TViewer   read FViewer  write SetViewer;
    property Font   : TFont     read FFont    write SetFont;
    property Brush  : TBrush    read FBrush   write SetBrush;
    property Pen    : TPen      read FPen     write SetPen;
    property MinX   : Extended  read FMinX    write SetMinX;
    property MaxX   : Extended  read FMaxX    write SetMaxX;
    property MinY   : Extended  read FMinY    write SetMinY;
    property MaxY   : Extended  read FMaxY    write SetMaxY;
    property Drawing : Boolean  read FDrawing write SetDrawing;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;

    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;

  function Point3D(x,y,z:Extended):TPoint3D;
  function atan4(x:Extended;y:Extended):Extended;

implementation

procedure TViewer.Assign(Value: TViewer);
begin
  Longitude := Value.Longitude;
  Latitude  := Value.Latitude;
  Size      := Value.Size;
  Distance  := Value.Distance;
  Zoom      := Value.Zoom;
  Update;
end;

procedure TViewer.SetLongitude(Value: Extended);
begin
  if Value <> FLongitude  then begin
    FLongitude := Value;
    Update;
    Changed;
  end;
end;

procedure TViewer.SetLatitude(Value: Extended);
begin
  if Value <> Flatitude then begin
    FLatitude := Value;
    Update;
    Changed;
  end;
end;

procedure TViewer.SetSize(Value: Extended);
begin
  if Value <> FSize then begin
    FSize := Value;
    Update;
    Changed;
  end;
end;

procedure TViewer.SetDistance(Value: Extended);
begin
  if Value <> FDistance then begin
    FDistance := Value;
    Update;
    Changed;
  end;
end;

procedure TViewer.SetZoom(Value: Extended);
begin
  if Value <> FZoom then begin
    FZoom := Value;
    Update;
    Changed;
  end;
end;

procedure TViewer.Changed;
begin
  if Assigned(FOnChange)
    then FOnChange(Self);
end;

procedure TViewer.Update;
var
  CLatitude, SLatitude    : Extended;
  dJx, dJy, dKx, dKy, dKz : Extended;

  TZoom, CSZoom:Extended;
begin
  dJx := - FSize * Sin(DegToRad(FLongitude));
  dJy := FSize * Cos(DegToRad(FLongitude));


  CLatitude := Sin(DegToRad(FLatitude));
  SLatitude := Cos(DegToRad(FLatitude));
  FIx := dJy * SLatitude;
  FIy := - dJx * SLatitude;
  FIz := FSize * CLatitude;
  dKx := - dJy * CLatitude;
  dKy := dJx * CLatitude;
  dKz := FSize * SLatitude;

  TZoom := FZoom;
  CSZoom := Cos(TZoom) / Sin(TZoom);
  FJx := CSZoom * dJx;
  FJy := CSZoom * dJy;
  FKx := CSZoom * dKx;
  FKy := CSZoom * dKy;
  FKz := CSZoom * dKz;
end; {Update}

constructor TC3DCanvas.Create(AOwner: TComponent);
begin
  inherited create(AOwner);
  FBrush := TBrush.Create;
  FFont :=TFont.Create;
  FPen := TPen.Create;
  Canvas.Brush.style:=bsClear;
  FMinX:=-100;
  FMaxX:=100;
  FMinY:=-100;
  FMaxY:=100;
  UpdateScale;
  FViewer:=TViewer.Create;
  FViewer.Zoom:=1.0E-20;
  FViewer.Longitude:=30.0;
  FViewer.Latitude:=30.0;
  FViewer.Distance:=1.0E20;
  FViewer.Size:=1.0;
  FViewer.Zoom:=1.0E-20;
  FViewer.Update;
  ControlStyle := ControlStyle + [csReplicatable];
  Width := 100;
  Height := 100;
end; {Create}

destructor TC3DCanvas.Destroy;
begin
  inherited destroy;
end; {Destroy}

procedure TC3DCanvas.Paint;
begin
  if csDesigning in ComponentState
    then with Canvas do begin
      Pen.Style := psDash;
      Brush.Style := bsClear;
      Rectangle(0, 0, Width, Height);
    end;
end;  {Paint}

function TC3DCanvas.RealToScreen(Point3D:TPoint3D):TPoint;
var
  T             : Extended;
  X,Y           : Extended;
begin
  FViewer.Update;
  T := 1.0 / (FViewer.Distance - (  FViewer.Ix * Point3D.x
                                  + FViewer.Iy * Point3D.y
                                  + FViewer.Iz * Point3D.z));

  X := T * ( FViewer.Jx * Point3D.x
           + FViewer.Jy * Point3D.y);

  Y := T * ( FViewer.Kx * Point3D.x
           + FViewer.Ky * Point3D.y
           + FViewer.Kz * Point3D.z);

  UpdateScale;

  Result.x:=Trunc((X-FMinX)*FScale);
  Result.y:=Trunc((FMaxY-Y)*FScale);
end;  {RealToScreen}

procedure TC3DCanvas.Clear;
begin
  Canvas.Brush.style:=bsClear;
  Repaint;
end;  {Clear}

procedure TC3DCanvas.UpdateScale;
var Scale_x, Scale_y:Extended;
    Width_F,Height_F:Extended;
begin
  Width_F:=Width;
  Height_F:=Height;
  Scale_x:=Width_F/(FMaxX-FMinX);
  Scale_y:=Height_F/(FMaxy-FMiny);
  if Scale_x > Scale_y
    then FScale:=Scale_y
    else FScale:=Scale_x;
end;  {UpdateScale}

procedure TC3DCanvas.SetWindow(xmin,xmax,ymin,ymax:Extended);
begin
  SetMinX(xmin);
  SetMaxX(xmax);
  SetMinY(ymin);
  SetMaxY(ymax);
  UpdateScale;
end;  {SetWindow}

procedure TC3DCanvas.MoveTo(P3D: TPoint3D);
var P:TPoint;
begin

  P:=RealToScreen(P3D);
  with Canvas do
    MoveTo(P.x,P.y);

end; {MoveTo}

procedure TC3DCanvas.LineTo(P3D: TPoint3D);
var P:TPoint;
begin
  P:=RealToScreen(P3D);
  with Canvas do begin
    Pen := FPen;
    LineTo(P.x,P.y);
  end;
end;  {LineTo}

procedure TC3DCanvas.TextOut(P3D_Start,P3D_end: TPoint3D; Text:ShortString);
var
  Font_Log_Record: TLogFont;
  Angle:Extended;
  P1,P2:TPoint;
begin
  P1:=RealToScreen(P3D_Start);
  P2:=RealToScreen(P3D_end);
  Angle:=atan4((P2.x-P1.x),(P1.y-P2.y));
  Angle:=RadToDeg(Angle);

  Canvas.Font := FFont;
  GetObject(Canvas.Font.Handle, SizeOf(Font_Log_Record), Addr(Font_Log_Record));
  Font_Log_Record.lfEscapement := Trunc(Angle * 10);
  Font_Log_Record.lfOutPrecision := OUT_TT_ONLY_PRECIS;
  Canvas.Font.Handle := CreateFontIndirect(Font_Log_Record);
  Canvas.TextOut(P1.X, P1.Y, String(Text));
  Canvas.Font:=FFont;
end;

procedure TC3DCanvas.Polygon(Points: array of TPoint3D);
var i:integer;
    Pts:array [0..99] of TPoint;
    P:TPoint;
    N:integer;
begin
  if High(Points) > High(Pts) then exit;
  N:=High(Points)+1;
  for i:=0 to High(Points) do
  begin
    P:=RealToScreen(Points[i]);
    Pts[i]:= P;
  end;
  with Canvas do
  begin;
    Pen := FPen;
    Brush := FBrush;
    Polygon(Slice(Pts, N));
  end;
end;

procedure TC3DCanvas.Polyline(Points: array of TPoint3D);
var i:integer;
    Pts:array [0..99] of TPoint;
    P:TPoint;
    N:integer;
begin
  if High(Points) > High(Pts) then exit;

  N:=High(Points)+1;
  for i:=0 to High(Points) do
  begin
    P:=RealToScreen(Points[i]);
    Pts[i]:=P;
  end;
  with Canvas do
  begin;
    Pen := FPen;
    Polyline(Slice(Pts, N));
  end;
end;{Polyline}

procedure TC3DCanvas.SetMinX(Value: Extended);
begin
  if Value <> FMinX
  then if Value < FMaxX
    then begin
        FMinX := Value;
        UpdateScale;
      end
    else ShowMessage('MinX should be smaller than MaxX');
end;

procedure TC3DCanvas.SetMaxX(Value: Extended);
begin
  if Value <> FMaxX
    then if Value > FMinX
      then begin
        FMaxX := Value;
        UpdateScale;
      end
    else ShowMessage('MaxX should be greater than MinX');
end;

procedure TC3DCanvas.SetMinY(Value: Extended);
begin
  if Value <> FMinY
    then if Value < FMaxY
      then begin
          FMinY := Value;
          UpdateScale;
        end
      else ShowMessage('MinY should be smaller than MaxY');
end;

procedure TC3DCanvas.SetMaxY(Value: Extended);
begin
  if Value <> FMaxY
  then if Value > FMinY
    then begin
        FMaxY := Value;
        UpdateScale;
      end
    else ShowMessage('MaxY should be greater than MinY');
end;

procedure TC3DCanvas.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
end;

procedure TC3DCanvas.SetBrush(Value: TBrush);
begin
  FBrush.Assign(Value);
end;

procedure TC3DCanvas.SetPen(Value: TPen);
begin
  FPen.Assign(Value);
end;

procedure TC3DCanvas.SetViewer(Value : TViewer);
begin
  FViewer.Assign(Value);
  FViewer.Update;
  Invalidate;
end;

procedure TC3DCanvas.SetDrawing(Value: Boolean);
begin
  (*if Value
  then Canvas.Unlock
  else Canvas.Lock;   D2*)

  if Value <> FDrawing
  then FDrawing := Value;
end;

// Utility functions
function Point3D(x,y,z:Extended):TPoint3D;
begin
  Result.x:=x;  Result.y:=y;  Result.z:=z;
end;

function atan4(x:Extended;y:Extended):Extended;
  {full quadrant tan function}
begin
  result:=0;
  if ((x=0) and (y>0.0)) then
    Result:=Pi/2;

  if ((x=0.0) and (y<0.0)) then
    Result:=3*Pi/2;

  if ((x>0.0) and (y=0.0)) then
    Result:=0;

  if ((x<0.0) and (y=0.0)) then
    Result:=2*Pi;

  if ((x > 0.0) and (y > 0.0)) then
    Result := arctan(y/x);

  if ((x < 0.0) and (y > 0.0)) then
    Result := Pi - arctan(abs(y/x));

  if ((x < 0.0) and (y < 0.0)) then
      Result := Pi + arctan(abs(y/x));

  if ((x > 0.0) and (y < 0.0)) then
    Result := 2*Pi - arctan(abs(y/x));
end;

end.





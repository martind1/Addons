unit U3DEdit;

interface

uses
  {Borland}
  Windows, Classes, Graphics, Forms, Controls,
  Buttons, {DsgnIntf,  DsgnWnds,} DesignIntf, DesignEditors,
  StdCtrls, ComCtrls,
  ExtCtrls, SysUtils,
  {Mine}
  U3DCnvs;

type
  TViewerEditorDlg = class(TForm)
    Panel1: TPanel;
    Panel3: TPanel;
    Panel2: TPanel;
    Panel4: TPanel;
    TrBLatitude: TTrackBar;
    TrBLongitude: TTrackBar;
    Panel5: TPanel;
    Panel6: TPanel;
    EdZoom: TEdit;
    EdDistance: TEdit;
    Label3: TLabel;
    EdLatitude: TEdit;
    Label5: TLabel;
    Label2: TLabel;
    EdLongitude: TEdit;
    Label4: TLabel;
    Label1: TLabel;
    Panel7: TPanel;
    BitBtn2: TBitBtn;
    BitBtn1: TBitBtn;
    Label6: TLabel;
    Label7: TLabel;
    EdSize: TEdit;
    TrBSize: TTrackBar;
    procedure TrBLatitudeChange(Sender: TObject);
    procedure TrBLongitudeChange(Sender: TObject);
    procedure EdLongitudeChange(Sender: TObject);
    procedure EdLatitudeChange(Sender: TObject);
    procedure EdSizeChange(Sender: TObject);
    procedure EdDistanceChange(Sender: TObject);
    procedure EdZoomChange(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure EdLongitudeKeyPress(Sender: TObject; var Key: Char);
    procedure EdLatitudeKeyPress(Sender: TObject; var Key: Char);
    procedure EdSizeKeyPress(Sender: TObject; var Key: Char);
    procedure EdDistanceKeyPress(Sender: TObject; var Key: Char);
    procedure EdZoomKeyPress(Sender: TObject; var Key: Char);
    procedure TrBSizeChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FOrigLongitude, FOrigLatitude, FOrigSize,
    FOrigDistance, FOrigZoom: Extended;
    FViewer: TViewer;
    C3DCanvas: TC3DCanvas;
    procedure SetLongitude(Value: Extended);
    procedure SetLatitude(Value: Extended);
    procedure SetSize(Value: Extended);
    procedure SetDistance(Value: Extended);
    procedure SetZoom(Value: Extended);
    procedure SetViewer(Value: TViewer);
  public
    { Public declarations }
    property EditorViewer: TViewer read FViewer write SetViewer;
    procedure DrawCube;
  end;

  procedure KeyPressForInteger(var KeyPressed: Char);
  procedure KeyPressForReal(var KeyPressed: Char);

implementation

//uses SysUtils;
{$R *.DFM}

procedure TViewerEditorDlg.TrBLatitudeChange(Sender: TObject);
begin
  EdLatitude.Text:=IntToStr(TrBLatitude.Position) ;
  SetLatitude(TrBLatitude.Position);
  C3DCanvas.Viewer.Latitude:=TrBLatitude.Position;
  DrawCube;
end;

procedure TViewerEditorDlg.TrBLongitudeChange(Sender: TObject);
begin
  EdLongitude.Text:=IntToStr(TrBLongitude.Position) ;
  SetLongitude(TrBLongitude.Position);
  C3DCanvas.Viewer.Longitude:=TrBLongitude.Position;
  DrawCube;
end;

procedure TViewerEditorDlg.TrBSizeChange(Sender: TObject);
var Size:Extended;
begin
  Size:=TrBSize.Position/10.0;
  SetSize(Size);
  C3DCanvas.Viewer.Size:=Size;
  DrawCube;
end;

procedure TViewerEditorDlg.EdLongitudeChange(Sender: TObject);
begin
  if   ((EdLongitude.Text = '')
    or (EdLongitude.Text = '.')
    or (EdLongitude.Text = '-')
    or (EdLongitude.Text = 'e')
    or (EdLongitude.Text = 'E'))
  then
    Exit
  else
  begin
    if (StrToInt(EdLongitude.Text) > 180)
      or (StrToInt(EdLongitude.Text) < -180)
    then
      EdLongitude.Text:=IntToStr(TrBLongitude.Position)
    else
      TrBLongitude.Position:=StrToInt(EdLongitude.Text);

    SetLongitude(TrBLongitude.Position);
    C3DCanvas.Viewer.Longitude:=TrBLongitude.Position;
    DrawCube;
  end;
end;

procedure TViewerEditorDlg.EdLatitudeChange(Sender: TObject);
begin
  if   ((EdLatitude.Text = '')
    or (EdLatitude.Text = '.')
    or (EdLatitude.Text = '-')
    or (EdLatitude.Text = 'e')
    or (EdLatitude.Text = 'E'))
  then
    Exit
  else
  begin
    if (StrToInt(EdLatitude.Text) > 180)
      or (StrToInt(EdLatitude.Text) < -180)
    then
      EdLatitude.Text:=IntToStr(TrBLatitude.Position)
    else
      TrBLatitude.Position:=StrToInt(EdLatitude.Text);

    SetLatitude(TrBLatitude.Position);
    C3DCanvas.Viewer.Latitude:=TrBLatitude.Position;
    DrawCube;
  end;
end;

procedure TViewerEditorDlg.EdSizeChange(Sender: TObject);
begin
  if   ((EdSize.Text = '')
    or (EdSize.Text = '.')
    or (EdSize.Text = '-')
    or (EdSize.Text = 'e')
    or (EdSize.Text = 'E')
    or (StrToFloat(EdSize.Text)=0))
  then
    Exit
  else
  begin
    SetSize(StrToFloat(EdSize.Text));
    C3DCanvas.Viewer.Size:=StrToFloat(EdSize.Text);
    DrawCube;
  end;
end;

procedure TViewerEditorDlg.SetLongitude(Value: Extended);
begin
  TrBLongitude.Position:=Trunc(Value);
  EdLongitude.Text:= FloatToStr(Value);
  FViewer.Longitude:=Value;
end;

procedure TViewerEditorDlg.SetLatitude(Value: Extended);
begin
  TrBLatitude.Position:=Trunc(Value);
  EdLatitude.Text:= FloatToStr(Value);
  FViewer.Latitude:=Value;
end;

procedure TViewerEditorDlg.SetSize(Value: Extended);
begin
    TrBSize.Position:=Round(10.0*Value);
    EdSize.Text:=FloatToStrF(Value,ffFixed,2,2);
    FViewer.Size:=Value;
end;

procedure TViewerEditorDlg.SetDistance(Value: Extended);
begin
  EdDistance.Text:=FloatToStr(Value);
  FViewer.Distance:=Value;
end;

procedure TViewerEditorDlg.SetZoom(Value: Extended);
begin
  EdZoom.Text:=FloatToStr(Value);
  FViewer.Zoom:=Value;
end;

procedure TViewerEditorDlg.EdDistanceChange(Sender: TObject);
begin
  if   ((EdDistance.Text = '')
    or (EdDistance.Text = '.')
    or (EdDistance.Text = '-')
    or (EdDistance.Text = 'e')
    or (EdDistance.Text = 'E'))
  then
    Exit
  else
  begin
    SetDistance(StrToFloat(EdDistance.Text));
    C3DCanvas.Viewer.Distance:=StrToFloat(EdDistance.Text);
    DrawCube;
  end;
end;

procedure TViewerEditorDlg.EdZoomChange(Sender: TObject);
begin
  if   ((EdZoom.Text = '')
    or (EdZoom.Text = '.')
    or (EdZoom.Text = '-')
    or (EdZoom.Text = 'e')
    or (EdZoom.Text = 'E'))
  then
    Exit
  else
  begin
    SetZoom(StrToFloat(EdZoom.Text));
    C3DCanvas.Viewer.Zoom:=StrToFloat(EdZoom.Text);
    DrawCube;
  end;
end;

procedure TViewerEditorDlg.SetViewer(Value: TViewer);
begin
  FViewer := Value;
  FOrigLongitude  := Value.Longitude;
  FOrigLatitude   := Value.Latitude;
  FOrigSize       := Value.Size;
  FOrigDistance   := Value.Distance;
  FOrigZoom       := Value.Zoom;
  SetLongitude(Value.Longitude);
  SetLatitude(Value.Latitude);
  SetSize(Value.Size);
  SetDistance(Value.Distance);
  SetZoom(Value.Zoom);
end;

procedure TViewerEditorDlg.BitBtn2Click(Sender: TObject);
begin
  SetLongitude(FOrigLongitude);
  SetLatitude(FOrigLatitude);
  SetSize(FOrigSize);
  SetDistance(FOrigDistance);
  SetZoom(FOrigZoom);
  C3DCanvas.Viewer.Longitude:=FOrigLongitude;
  C3DCanvas.Viewer.Latitude:=FOrigLatitude;
  C3DCanvas.Viewer.Size:=FOrigSize;
  C3DCanvas.Viewer.Distance:=FOrigDistance;
  C3DCanvas.Viewer.Zoom:=FOrigZoom;
  DrawCube;
end;

procedure TViewerEditorDlg.DrawCube;
var P:array [0..3] of TPoint3D;
begin
  //draw cube
  with C3DCanvas do begin
  Drawing:=False;
  Clear;
  Brush.Style:=bsBDiagonal;
  Brush.color:=clBlack;
  P[0]:=Point3D(0,0,0);
  P[1]:=Point3D(50,0,0);
  P[2]:=Point3D(50,50,0);
  P[3]:=Point3D(0,50,0);
  Polygon(P);

  Brush.Style:=bsClear;
  P[0]:=Point3D(0,0,50);
  P[1]:=Point3D(50,0,50);
  P[2]:=Point3D(50,50,50);
  P[3]:=Point3D(0,50,50);
  Polygon(P);

  P[0]:=Point3D(50,0,0);
  P[1]:=Point3D(50,50,0);
  P[2]:=Point3D(50,50,50);
  P[3]:=Point3D(50,0,50);
  Polygon(P);

  P[0]:=Point3D(0,0,0);
  P[1]:=Point3D(0,50,0);
  P[2]:=Point3D(0,50,50);
  P[3]:=point3D(0,0,50);
  Polygon(P);

  // draw axes
  P[1]:=Point3D(75,0,0);
  P[2]:=Point3D(100,0,0);
  MoveTo(P[0]);
  LineTo(P[1]);
  TextOut(P[1],P[2],'x');

  P[1]:=Point3D(0,75,0);
  P[2]:=Point3D(0,100,0);
  MoveTo(P[0]);
  LineTo(P[1]);
  TextOut(P[1],P[2],'y');

  P[1]:=Point3D(0,0,75);
  P[2]:=Point3D(0,0,100);
  MoveTo(P[0]);
  LineTo(P[1]);
  TextOut(P[1],P[2],'z');
  Drawing:=True;
  end;
end;

procedure TViewerEditorDlg.FormActivate(Sender: TObject);
begin
  DrawCube;
end;

procedure TViewerEditorDlg.EdLongitudeKeyPress(Sender: TObject;
  var Key: Char);
begin
  KeyPressForInteger(Key);
end;

procedure TViewerEditorDlg.EdLatitudeKeyPress(Sender: TObject;
  var Key: Char);
begin
    KeyPressForInteger(Key);
end;

procedure TViewerEditorDlg.EdSizeKeyPress(Sender: TObject; var Key: Char);
begin
  KeyPressForReal(Key);
end;

procedure TViewerEditorDlg.EdDistanceKeyPress(Sender: TObject;
  var Key: Char);
begin
  KeyPressForReal(Key);
end;

procedure TViewerEditorDlg.EdZoomKeyPress(Sender: TObject; var Key: Char);
begin
  KeyPressForReal(Key);
end;

procedure KeyPressForInteger(var KeyPressed: Char);
begin
  case KeyPressed of
    ' '..'/':KeyPressed:=Char(0);
    ':'..'ÿ':KeyPressed:=Char(0);
  end;
end;

procedure KeyPressForReal(var KeyPressed: Char);
begin
  case KeyPressed of
    ' '..',':KeyPressed:=Char(0);
    '/':KeyPressed:=Char(0);
    ':'..'D':KeyPressed:=Char(0);
    'F'..'d':KeyPressed:=Char(0);
    'f'..'ÿ':KeyPressed:=Char(0);
  end;
end;

procedure TViewerEditorDlg.FormCreate(Sender: TObject);
begin
  C3DCanvas:=TC3DCanvas.Create(Self);
  C3DCanvas.Parent:=Panel1;
  C3DCanvas.Align:=alClient;
  C3DCanvas.Viewer.Latitude:=30;
  C3DCanvas.Viewer.Longitude:=30;
end;

end.

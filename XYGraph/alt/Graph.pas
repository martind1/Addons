(*
25.02.12 md  Umstellung auf D2010
             PointText string (statt [30]
13.11.12 md  Rename nach xygraph.pas wg Namenskonflikt


  Component XYGraph, Version 3.0
  April 1999

  U.Jürß
  57078 Siegen, Germany
  e-mail: ujhs@aol.com

  Component XYGraph 3.0 is a versatile graph for showing 2D data:
   1. + Very flexible property design.
   2. + Extended control interface
        (control the graph and retrieve all curve data without writing one line
        of code by simply assigning TControl´s to the graph´s CONTROLS property).
   3. + Powerful, flickerfree CENTERZOOM (with or without aspect ratio).
   4. + Flickerfree REALPAN (single curves or graph).
   5. + Editing of curve controlpoints (move, insert, delete, freeze) by mouse
        or numerical input.
   6. + Free colored offset-lettering for every controlpoint.
   7. + Three markstyles with scaleable size to mark important controlpoints.
   8. + Relative cursor reading.
   9. + Streamed writing and reading single curves or graph.
  10. + DXF output of graph and curves for data exchange with CAD systems.
  11. + Moveable hintpanel for additional graph-information.
  12. + Example project showing some features.

  Properties:
    property Controls: TControls
        (all properties of type TControl can be TLabel, TStaticText, TStatusLabel
         or TPanel. They are used for data output. For example assigning a TLabel
         to the property "Mode" will display the graph´s actual mode.)
      property XOut: TControl (output) (normally the TEdit XIn)
      property YOut: TControl (output) (normally the TEdit YIn)
      property Mode: TControl (output)
      property Curve: TControl (output)
      property Item: TControl (output)
      property Color: TControl (output)
      property Angle: TControl (output)
        (TEdits are used for numerical inputs. (and outputs of X,Y))
      property XIn: TEdit (input)
      property YIn: TEdit (input)
        (TButtons are used as switches to control graph functions.)
      property Clear: TButton (input)
      property OpenView: TButton (input)
      property OpenPan: TButton (input)
      property Reset: TButton (input)
        (TRadioButtons are used to control the graph´s operating mode.)
      property ModeNone: TRadioButton (input)
      property ModeMove: TRadioButton (input)
      property ModeInsert: TRadioButton (input)
      property ModeDelete: TRadioButton (input)
      property ModeCursor: TRadioButton (input)
        (TCheckBoxes are used to control graph options.)
      property AspectRatio: TCheckBox (input)
      property MainGrid: TCheckBox (input)
      property SubGrid: TCheckBox (input)
      property HintPanel: TCheckBox (input)
      property ViewListBox: TCheckListBox (input)
        (ViewListBox is used to control visibility of curves. Click checkmark
         of the curve you want to show or hide. To show/hide the ViewListBox
         use Button "OpenView".)
      property PanListBox: TCheckListBox
        (PanListBox is used to select the curve(s) you want to move in the graph.
         To show/hide then PanListBox use Button "OpenPan".)

    property Colors: TColors
      property AxisBkGnd: color of xy-axis background.
      property TickColor: color of scaleticks.
      property GraphBkGnd: color of graph background.
      property MainGridColor: color of maingrid.
      property SubGridColor: color of subgrid.

    property Fonts: TFonts
      property AxisScale: font of axis-scale.
      property AxisTitle: font of axis title.
      property GraphTitle: font of graph title.

    property GraphTitle: Str32 string of graph title.

    property Positions: TPositions
      property XAxisLeft: left margin of xaxis.
      property XAxisRight: right margin of xaxis.
      property YAxisTop: top margin of yaxis.
      property YAxisBottom: bottom margin of yaxis.
      property TitleTop: top margin of graph title.
      property TitleLeft: left margin of graph title (centered if 0).
      property XAxisTitle: bottom margin of xaxis title.
      property YAxisTitle: left margin of yaxis title.

    property XAxis: TAxis
      property Title: title of axis
      property Min: min value of axis
      property Max: max value of axis
      property MainTicks: how many ticks with texture.
      property SubTicks: how many ticks between MainTicks.
      property MainTickLen: length of MainTicks.
      property SubTickLen: length of SubTicks.
      property Decimals: how many digits after comma.
      property ShowMainGrid: flag for showing MainGrid (for color look at Colors).
      property ShowSubGrid: flag for showing SubGrid (for color look at Colors).

    property YAxis: TAxis read FYAxis write FYAxis;
      (same as XAxis)

    property MaxZoom: defines the zoomlimits (MinZoom is 1 / MaxZoom).
    ----------------------------------------------------------------------------

    Control functions:
    LeftButton: does REALPAN if no other function is active. If one or
      more curves are selected in the PanListBox, then these curves are moved
      instead of panning the graph. You can also set this offset by numerical
      input via the X/Y TEdits.
      If a curve-controlpoint is active (shown by a marker), then
      the actual function (move, insert, delete) is performed.

    RightButton: does CENTERZOOM. The point you click will be centered
      and then zoomed by mouse movement. If you deselect "Aspect" the X and Y
      axis are zoomed independent.

    DoubleClick: Resets the graph (pan and zoom).

    Shift: if a curve-controlpoint is marked you can freeze this point by
      holding down the shift-key.
    ----------------------------------------------------------------------------

    How to do:
    Setup the graph to your needs with the properties.
    Use the
      function MakeCurve(AName: Str32; AColor: TColor; ALineWidth: Byte;
                         APenStyle: TPenStyle; AEnabled: Boolean);
    to create a new curve. The parameters makes the creation very flexible.
    Assuming AName = "test". If "test" already exists, it will be renamed to
    "test1" (just like Delphi does it with components).
    You get a handle to the created curve. With this handle you can add new
    points with the

      procedure AddPoint(AIndex: Integer; X,Y: TFloat);

    Where AIndex is the handle to the curve. After creation of all points you
    can add text and/or marks to every point you want with the

      procedure AddText(AIndex,APosition,AXOfs,AYOfs: Integer;
                       const AText: Str32; AColor: TColor);
      procedure AddMark(AIndex,APosition: Integer; AMarkType:
                        TMarkType; AColor: TColor);

    AIndex is the handle of the curve. APosition is the pointindex of the curve.
    AXOfs,AYOfs defines at witch offsets (relative to the point) where the text
    is displayed. Every text can be in different color. For every curve you can
    assign a font with the

      procedure SetCurveFont(AIndex: Integer; AName: TFontName;
                             ASize: Integer; AStyle: TFontStyles);

    For every curve you can assign the size of marks with the

      procedure SetMarkSize(AIndex: Integer; AMarkSize: TMarkSize);

    To add text to the HintPanel use Graph.HintPanel.Strings.Add('test');
    To clear the text use Graph.HintPanel.Strings.Clear;

    To use the edit functions of the graph, set Mode <> None. If moving the
    mouse cursor, a marker signs every controlpoint of the curve. Depending on
    the editmode you can move, delete or insert a point (only if the marker
    is visible). To freeze the actual marker, press (and hold down) the Shift-key.
    If EditMode is "Move", you can numerical input new point coordinates via
    the X,Y TEdits (if assigned).
    ----------------------------------------------------------------------------

    DXF-output: you can create a DXF file with the

      function MakeDXF(const FileName: string; FromX1,FromY1,FromX2,FromY2,
                       ToX1,ToY1,ToX2,ToY2,TextHeight: TFloat; Decimals: Byte): Boolean;

      FromX1..FromY2 are the source coordinates.
      ToX1..TY2 are the destination coordinates.
      Decimals is the precision after comma.
      All entities inside the source coordinates are transfered true to scale
      into the destination coordinates. Everything outside (text,scalelines etc.)
      are not true to scale. Does not process additional text (created with
      AddText) and marks (created with AddMark). 
    ----------------------------------------------------------------------------

    Interesting public methods are:

    function MakeCurve(const AName: Str32; AColor: TColor; ALineWidth: Byte;
                       APenStyle: TPenStyle; AEnabled: Boolean): Integer;
    procedure AddPoint(AIndex: Integer; X,Y: TFloat);
    procedure AddText(AIndex,APosition,AXOfs,AYOfs: Integer; const AText: Str32; AColor: TColor);
    procedure SetCurveFont(AIndex: Integer; AName: TFontName; ASize: Integer; AStyle: TFontStyles);
    procedure AddMark(AIndex,APosition: Integer; AMarkType: TMarkType; AColor: TColor);
    procedure SetMarkSize(AIndex: Integer; AMarkSize: TMarkSize);
    procedure ChangePoint(AIndex,APosition: Integer; X,Y: TFloat);
    procedure DeleteCurve(AItem: Integer);
    function GetCurveHandle(AName: Str32; var H: Integer): Boolean;
    function GetCurveName(H: Integer): Str32;
    procedure SetCurveEnabled(AIndex: Integer; Value: Boolean);
    procedure GetPoint(AIndex,APosition: Integer; var X,Y: TFloat);
    procedure InsertPoint(AIndex,APosition: Integer; X,Y: TFloat);
    procedure DeletePoint(AIndex,APosition: Integer);
    procedure Reset;
    procedure ShowHintPanel(Show: Boolean);
    procedure SetXOfs(AIndex: Integer; AOfs: TFloat);
    function GetXOfs(AIndex: Integer): TFloat;
    procedure SetYOfs(AIndex: Integer; AOfs: TFloat);
    function GetYOfs(AIndex: Integer): TFloat;
    procedure CheckCurvePoints(X,Y: Integer);
    procedure ChangeCPx(Fx: TFloat);
    procedure ChangeCPy(Fy: TFloat);
    procedure ChangeCurveOfs(Ox,Oy: TFloat; Relative: Boolean);
    procedure GetCPInfo(var CPMatch: Boolean; var CPCurve,CPIndex: Integer);
    procedure SetMode(Value: TMode);
    function MakeDXF(const FileName: string; FromX1,FromY1,FromX2,FromY2,
                     ToX1,ToY1,ToX2,ToY2,TextHeight: TFloat; Decimals: Byte): Boolean;
    function SaveCurveToFile(const FileName: string; Item: Integer): Boolean;
    function LoadCurveFromFile(const FileName: string): Boolean;
    function SaveGraphToFile(const FileName: string): Boolean;
    function LoadGraphFromFile(const FileName: string): Boolean;
    ----------------------------------------------------------------------------

    Look at the demo project to see some other features like writing and
    reading curves or graph, or creating DXF output.

    Excuse my english - I hope you get at least the gist of it.
*)

unit
  Graph;

interface

uses
  Windows,Classes,Controls,StdCtrls,ExtCtrls,Graphics,CheckLst,Buttons, Spin, Forms;
{------------------------------------------------------------------------------}

const
  MaxHintLines = 10;
  ciXYHeight   = 22; //neu BG Höhe Werkzeugleiste
  ciXYDistBtn  = 2;
  ciXYLeftBtn  = 20;
  ciXYTopBtn   = 25;
  ciXYTopBtnNone= 0;
  ciXYDistFkt  = 10;
  ciXYDistRB   = 20;
  csMkrEmpty   = '???, ???';

  cLg_Ln     : double = 2.302585093;  //Umrechnungskonstante 10log zum natürlichen ln
  MaxColor     = 11;

  ciResizeBtnSize = 14;
  ciCurveTitlesRandTop = 0;
  ciCurveTitlesRandLeft = 5;
  ciCurveTitlesHeight = 20;
  ciCurveTitelsHeader = 30;
  ciCurveTitlesCurveHeight = 25;

  ciCurveTitlesX4CG = 5;
  ciCurveTitlesX5C = 5;
  ciCurveTitlesX5CG = 20;

{------------------------------------------------------------------------------}

type
  TFloat = Double;
  //Str32 = string[100];
  Str32 = string; //BG191107

  TMode = (gmNone,gmMove,gmInsert,gmDelete,gmCursor);
  TGraphStyleItems = (gsMainGrid,gsSubGrid,gsHintPanel);
  TGraphStyle = set of TGraphStyleItems;

  TMarkType = (mtBox,mtCircle,mtCross);
  TMarkSize = 2..8;

  TCurveData = record //Datenstruktur für SaveCurveToStream/LoadCurveFromStream
    Name: Str32;
    Enabled: Boolean;
    Color: TColor;
    LineWidth: Byte;
    PenStyle: TPenStyle;
    Points: Integer;
    Texts: Integer;
    Marks: Integer;
    XOfs: TFloat;
    YOfs: TFloat;
    FontName: Str32;
    FontSize: Integer;
    FontStyle: TFontStyles;
    MarkSize: TMarkSize;
  end;

  TGraphData = record //Datenstruktur für SaveGraphToFile/LoadGraphFromFile
    GraphTitle: Str32;
    Zoom: TFloat;
    MaxZoom: TFloat;
    Curves: Integer;
  end;

  PPointRec = ^TPointRec;
  TPointRec = record
             X: TFloat;
             Y: TFloat;
           end;

  //neu BG
  TPnt = record
           X: TFloat;
           Y: TFloat;
         end;

  PPointArray = ^TPointArray;
  TPointArray = array[0..0] of TPoint;

  PTextRec = ^TTextRec;
  TTextRec = record
    PointIndex: Integer;
    Text: Str32;
    TextColor: TColor;
    XOfs: Integer;
    YOfs: Integer;
  end;

  PMarkRec = ^TMarkRec;
  TMarkRec = record
    PointIndex: Integer;
    MarkType: TMarkType;
    MarkColor: TColor;
  end;

  TFontRec = record
    AxisScaleFontName: Str32;
    AxisScaleFontSize: Integer;
    AxisScaleFontStyle: TFontStyles;
    AxisTitleFontName: Str32;
    AxisTitleFontSize: Integer;
    AxisTitleFontStyle: TFontStyles;
    GraphTitleFontName: Str32;
    GraphTitleFontSize: Integer;
    GraphTitleFontStyle: TFontStyles;
  end;

  TDXFOut = class(TPersistent)
  private
    StringList: TStringList;
    FromXMin: TFloat;
    FromXMax: TFloat;
    FromYMin: TFloat;
    FromYMax: TFloat;
    ToXMin: TFloat;
    ToXMax: TFloat;
    ToYMin: TFloat;
    ToYMax: TFloat;
    TextHeight: TFloat;
    Decimals: Byte;
    LayerName: Str32;
  public
    constructor Create(AFromXMin,AFromYMin,AFromXMax,AFromYMax,AToXMin,AToYMin,
                       AToXMax,AToYMax,ATextHeight: TFloat; ADecimals: Byte);
    destructor Destroy; override;
    function FToA(F: TFloat): Str32;
    function ToX(X: TFloat): TFloat;
    function ToY(Y: TFloat): TFloat;
    procedure Header;
    procedure Trailer;
    procedure SetLayer(const Name: Str32);
    procedure Line(X1,Y1,Z1,X2,Y2,Z2: TFloat);
    procedure Point(X,Y,Z: TFloat);
    procedure StartPolyLine(Closed: Boolean);
    procedure Vertex(X,Y,Z: TFloat);
    procedure EndPolyLine;
    procedure DText(X,Y,Z,Height,Angle: TFloat; const Txt: Str32);
    procedure Layer;
    procedure StartPoint(X,Y,Z: TFloat);
    procedure EndPoint(X,Y,Z: TFloat);
    procedure AddText(const Txt: Str32);
  end;

  TXYGraph = class;

  TControls = class(TPersistent)
  private
    Graph: TXYGraph;
    FXOut: TControl;
    FYOut: TControl;
    FMode: TControl;
    FCurve: TControl;
    FItem: TControl;
    FColor: TControl;
    FAngle: TControl;
    FXIn: TEdit;
    FYIn: TEdit;
    FClear: TButton;
    FOpenView: TButton;
    FOpenPan: TButton;
    FReset: TButton;
    FModeNone: TRadioButton;
    FModeMove: TRadioButton;
    FModeInsert: TRadioButton;
    FModeDelete: TRadioButton;
    FModeCursor: TRadioButton;
    FAspectRatio: TCheckBox;
    FMainGrid: TCheckBox;
    FSubGrid: TCheckBox;
    FShowScale: TCheckBox;
    FHintPanel: TCheckBox;
    FCurveListBox: TCheckListBox;
    FCurveGroupListBox: TCheckListBox;
    FPanListBox: TCheckListBox;
  protected
    procedure SetControl(Index: Integer; Value: TControl);
    procedure SetEdit(Index: Integer; Value: TEdit);
    procedure SetButton(Index: Integer; Value: TButton);
    procedure SetRadioButton(Index: Integer; Value: TRadioButton);
    procedure SetCheckBox(Index: Integer; Value: TCheckBox);
    procedure SetListBox(Index: Integer; Value: TCheckListBox);
  public
    constructor Create(AGraph: TXYGraph);
  published
    property XOut: TControl index 0 read FXOut write SetControl;
    property YOut: TControl index 1 read FYOut write SetControl;
    property Mode: TControl index 2 read FMode write SetControl;
    property Curve: TControl index 3 read FCurve write SetControl;
    property Item: TControl index 4 read FItem write SetControl;
    property Color: TControl index 5 read FColor write SetControl;
    property Angle: TControl index 6 read FAngle write SetControl;

    property XIn: TEdit index 0 read FXIn write SetEdit;
    property YIn: TEdit index 1 read FYIn write SetEdit;

    property Clear: TButton index 0 read FClear write SetButton;
    property OpenView: TButton index 1 read FOpenView write SetButton;
    property OpenPan: TButton index 2 read FOpenPan write SetButton;
    property Reset: TButton index 3 read FReset write SetButton;

    property ModeNone: TRadioButton index 0 read FModeNone write SetRadioButton;
    property ModeMove: TRadioButton index 1 read FModeMove write SetRadioButton;
    property ModeInsert: TRadioButton index 2 read FModeInsert write SetRadioButton;
    property ModeDelete: TRadioButton index 3 read FModeDelete write SetRadioButton;
    property ModeCursor: TRadioButton index 4 read FModeCursor write SetRadioButton;

    property AspectRatio: TCheckBox index 0 read FAspectRatio write SetCheckBox;
    property MainGrid: TCheckBox index 1 read FMainGrid write SetCheckBox;
    property SubGrid: TCheckBox index 2 read FSubGrid write SetCheckBox;
    property HintPanel: TCheckBox index 3 read FHintPanel write SetCheckBox;
    property ShowScale: TCheckBox index 4 read FShowScale write SetCheckBox;

    property CurveListBox: TCheckListBox index 0 read FCurveListBox write SetListBox;
    property CurveGroupListBox: TCheckListBox index 1 read FCurveGroupListBox write SetListBox;
    property PanListBox: TCheckListBox index 2 read FPanListBox write SetListBox;
  end;

  THintPanel = class(TCustomPanel)
  private
    FStrings: TStringList;
    Graph: TXYGraph;
    Moving: Boolean;
    Start: Boolean;
    MouseX: Integer;
    MouseY: Integer;
  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X,Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X,Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X,Y: Integer); override;
    procedure Loaded; override;
    procedure NewBounds;
    procedure DoStringsChange(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    property Strings: TStringList read FStrings write FStrings;
  end;

  TPositions = class(TPersistent)
  private
    Graph: TXYGraph;
    FXGraphLeft: Integer; //BG190810: Linker Rand der Grafik, hier geht es für alle los, der Wert wird autonmatisch von FXCurveTitle, FXCurveTitleExp gesetzt
    FXAxisLeft: Integer;
    FXAxisRight: Integer;
    FYAxisTop: Integer;
    FYAxisBottom: Integer;
    FTitleTop: Integer;
    FTitleLeft: Integer;
    FXAxisTitle: Integer;
    FYAxisTitle: Integer;
    FXCurveTitle: Integer; //BG290906: Neu
    FXCurveTitleExp: Integer; //BG180810: Neu
    FYCurveTitle: Integer;
    FXToolBar: integer;
    FOnChange: TNotifyEvent;
    FToolBarAlign: TAlign;
  protected
    procedure SetInteger(Index,Value: Integer);
    procedure SetToolBarAlign(AVal: TAlign);
  public
    constructor Create(AGraph: TXYGraph);
    property OnChange: TNotifyEvent read FOnChange write FOnChange default nil;
    property XGraphLeft: Integer index 11 read FXGraphLeft write SetInteger;
  published
    property XAxisLeft: Integer index 0 read FXAxisLeft write SetInteger;
    property XAxisRight: Integer index 1 read FXAxisRight write SetInteger;
    property YAxisTop: Integer index 2 read FYAxisTop write SetInteger;
    property YAxisBottom: Integer index 3 read FYAxisBottom write SetInteger;
    property TitleTop: Integer index 4 read FTitleTop write SetInteger;
    property TitleLeft: Integer index 5 read FTitleLeft write SetInteger;
    property XAxisTitle: Integer index 6 read FXAxisTitle write SetInteger;
    property YAxisTitle: Integer index 7 read FYAxisTitle write SetInteger;
    property XCurveTitle: Integer index 8 read FXCurveTitle write SetInteger;
    property YCurveTitle: Integer index 9 read FYCurveTitle write SetInteger;
    property XCurveTitleExp: Integer index 10 read FXCurveTitleExp write SetInteger;
    property XToolBar: integer index 12 read FXToolBar write SetInteger;
    property ToolBarAlign: TAlign read FToolBarAlign write SetToolBarAlign;
  end;

  TFonts = class(TPersistent)
  private
    FAxisScale: TFont;
    FAxisTitle: TFont;
    FGraphTitle: TFont;
    FOnChange: TNotifyEvent;
  protected
    procedure SetFont(Index: Integer; Value: TFont);
  public
    constructor Create;
    destructor Destroy; override;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  published
    property AxisScale: TFont index 0 read FAxisScale write SetFont;
    property AxisTitle: TFont index 1 read FAxisTitle write SetFont;
    property GraphTitle: TFont index 2 read FGraphTitle write SetFont;
  end;

  TColors = class(TPersistent)
  private
    FAxisBkGnd: TColor;
    FTickColor: TColor;
    FGraphBkGnd: TColor;
    FMainGridColor: TColor;
    FSubGridColor: TColor;
    FOnChange: TNotifyEvent;
  protected
    procedure SetColor(Index: Integer; Value: TColor);
  public
    constructor Create;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  published
    property AxisBkGnd: TColor index 0 read FAxisBkGnd write SetColor;
    property TickColor: TColor index 1 read FTickColor write SetColor;
    property GraphBkGnd: TColor index 2 read FGraphBkGnd write SetColor;
    property MainGridColor: TColor index 3 read FMainGridColor write SetColor;
    property SubGridColor: TColor index 4 read FSubGridColor write SetColor;
  end;

  TMainTicksText = record
    dAxVal: Double;
    sText: string;  //md 25.02.12 [30];
  end;

  TAxis = class(TPersistent)
  private
    FTitle: Str32;                                   {Beschriftung Achsentitel}
    FLength: Integer;                                              {Achsenlänge}
    FMin: TFloat;                                        {Anfangswert auf Achse} //wird bei Zoom verkleinert
    FMax: TFloat;                                            {Endwert auf Achse}
    FMinSave: TFloat;                                    {Anfangswert auf Achse} //absolute Grenzen aus den Properties
    FMaxSave: TFloat;                                        {Endwert auf Achse}
    FZoom: TFloat;
    FMainTicks: Byte;                                    {Anzahl Hauptteilungen}
    FSubTicks: Byte;                                       {Anzahl Subteilungen}
    FMainTickLen: Byte;                           {Länge der Hauptskalenstriche}
    FSubTickLen: Byte;                              {Länge der Subskalenstriche}
    FDecimals: Byte;        {Anzahl Nachkommastellen für Beschriftung auf Achse}
    FShowMainGrid: Boolean;
    FShowSubGrid: Boolean;
    FFactor: TFloat;                          {Wertfaktor für 1 Pixel auf Achse}
    FValuePerMainTick: TFloat;
    FValuePerPixel: TFloat;
    FTicks: Integer;
    FPixelsPerSubTick: TFloat;
    FPan: Integer;
    FPanSubTicks: Integer;
    FShowScale: Boolean; //BG120203
    FOnChange: TNotifyEvent;
    FLog: Boolean; //BG250506
    FTurnAxScale: Boolean;
    MainTicksText: array of TMainTicksText; //BG260906 XAchse beliebig beschriften

  protected
    procedure SetTitle(const Value: Str32);
    procedure SetLength1(Value: Integer);
    procedure SetFloat(Index: Integer; Value: TFloat);
    procedure SetMax(Value: TFloat);
    procedure SetByte(Index: Integer; Value: Byte);
    procedure SetBoolean(Index: Integer; Value: Boolean);
    procedure SetLog(aValue: Boolean);
  public
    constructor Create;
    procedure CalcAxis;
    function Value(APosition: Integer): TFloat;
    function Pixel(APosition: TFloat): Integer;
    procedure SetMinMax(AMin,AMax: TFloat);
    procedure SetZoom(Value: TFloat);
    procedure SetCenter(C: TFloat);
    procedure SetLeftBottom(L: TFloat);
    procedure SetRightTop(R: TFloat);
    function GetCenter: TFloat;
    property Length: Integer read FLength write SetLength1 default 200;
    property ValuePerMainTick: TFloat read FValuePerMainTick;
    property ValuePerPixel: TFloat read FValuePerPixel;
    property PixelsPerSubTick: TFloat read FPixelsPerSubTick;
    property Pan: Integer read FPan write FPan;
    property PanSubTicks: Integer read FPanSubTicks write FPanSubTicks;
    property Ticks: Integer read FTicks;
    property Zoom: TFloat read FZoom write FZoom;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    procedure DelAllMainTicksText;
    procedure AddMainTicksText(aPos: integer; aAxVal: Double; sText: string);
  published
    property Title: Str32 read FTitle write SetTitle;
    property Min: TFloat index 0 read FMin write SetFloat;
    property Max: TFloat index 1 read FMax write SetFloat;
    property MainTicks: Byte index 0 read FMainTicks write SetByte;
    property SubTicks: Byte index 1 read FSubTicks write SetByte;
    property MainTickLen: Byte index 2 read FMainTickLen write SetByte;
    property SubTickLen: Byte index 3 read FSubTickLen write SetByte;
    property Decimals: Byte index 4 read FDecimals write SetByte;
    property ShowMainGrid: Boolean index 0 read FShowMainGrid write SetBoolean;
    property ShowSubGrid: Boolean index 1 read FShowSubGrid write SetBoolean;
    property ShowScale: Boolean index 2 read FShowScale write SetBoolean default true;
    property Log: Boolean read fLog write SetLog; //BG250506
    property TurnAxScale: Boolean read FTurnAxScale write FTurnAxScale;
  end;

  //neu BG
  TMarker = record //Marker, um auf der Kurve herumzulaufen
    bVisible    : boolean; //Marker sichtbar
    bActive     : boolean; //Marker ist aktiv
    iCell       : integer; //Zeigt auf die entsprechende Zelle der Kurve}
    iCrv        : integer;
    Pos         : TPoint;  //Koordinaten in Pixeln
    Point       : TPnt;    //real-Wert der Markerposition
    Col         : TColor;  //Farbe
    Style       : TBrushStyle;
    MSize       : integer;
    Shape       : array [1..3] of TPoint;
   end;

  //BG160810: Neu
  TCurveGroup = class(TPersistent)
  private
    Owner: TComponent;
    CheckBox: TCheckBox;
    FEnabled: Boolean;
    procedure SetEnabled(aVal: Boolean);
  public
    Name: string;
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    property Enabled: Boolean read FEnabled write SetEnabled;
  end;

  TCurve = class(TPersistent)
  private
    Owner: TComponent;
    FPoints: TList;
    FBreakPoints: array of integer;
    FTexts: TList;
    FMarks: TList;
    FFont: TFont;
    FName: Str32;
    FEnabled: Boolean;
    FColor: TColor;
    FBrushColor: TColor;
    FLineWidth: Byte;
    FPenStyle: TPenStyle;
    FXOfs: TFloat;
    FYOfs: TFloat;
    FMarkSize: TMarkSize;
    PPoint: PPointRec;
    PText: PTextRec;
    PMark: PMarkRec;
    FCurveStyle: integer;
    FCurveGroup: integer;
    FMinX, FMinY, FMaxX, FMaxY: Double; //BG160810: Neu
    PointCol: array of TColor; //BG270103 Farbe jedes einzelnen Kurvenpunkts, nicht im TPointRec wegen sinnloser RAM
    PointText: array of String; //BG120203 Texte zum Beschriften
    CheckBox: TCheckBox;
    procedure SetEnabled(aVal: Boolean);
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    procedure AddPoint(Ax,Ay: TFloat);
    procedure AddPointColor(Ax,Ay: TFloat;Col: TColor); //BG280103
    procedure AddPointText(Ax,Ay: TFloat;Text: String); //BG120203
    procedure AddPointTextColor(Ax,Ay: TFloat;Text: String;Col: TColor); //BG260603
    procedure AddBreakPoint(APointIndex: Integer);
    procedure AddText(APointIndex,AXOfs,AYOfs: Integer; const AText: Str32; AColor: TColor);
    procedure AddMark(APointIndex: Integer; AMarkType: TMarkType; AColor: TColor);
    procedure GetPoint(AIndex: Integer; var Ax,Ay: TFloat);
    procedure ChangePoint(AIndex: Integer; Ax,Ay: TFloat);
    procedure InsertPoint(AIndex: Integer; Ax,Ay: TFloat);
    procedure DeletePoint(AIndex: Integer);
    procedure DeleteAllPoints;
    procedure SetBrushColor(aColor: TColor);
  public
    property Name: Str32 read FName write FName;
    property Enabled: Boolean read FEnabled write SetEnabled;
    property Color: TColor read FColor write FColor;
    property BrushColor: TColor read FBrushColor write FBrushColor;
    property LineWidth: Byte read FLineWidth write FLineWidth;
    property PenStyle: TPenStyle read FPenStyle write FPenStyle;
    property XOfs: TFloat read FXOfs write FXOfs;
    property YOfs: TFloat read FYOfs write FYOfs;
    property MarkSize: TMarkSize read FMarkSize write FMarkSize;
    property CurveStyle: integer read FCurveStyle write FCurveStyle;
    property CurveGroup: integer read FCurveGroup write FCurveGroup;
  end;

  TXYToolBar = class(TPanel)
  private
    Graph: TXYGraph;
    bVisible : Boolean;
    BtnRefresh : TSpeedButton;
    BtnZoomOrg : TSpeedButton;
    BtnZoomOut : TSpeedButton;
    BtnZoomIn : TSpeedButton;
    BtnPanSmall : TSpeedButton;
    lblTitle : TLabel;
    btnResize: TSpeedButton;
    btnExpand: TSpeedButton;
    bResized: Boolean;
    bExpanded: Boolean;
  protected
    procedure SetVisible(bVal : Boolean);
    procedure SetExpanded(bVal : Boolean);
    procedure BtnRefreshClicked(Sender: TObject);
    procedure BtnZoomOrgClicked(Sender: TObject);
    procedure BtnZoomOutClicked(Sender: TObject);
    procedure BtnZoomInClicked(Sender: TObject);
    procedure BtnResizeClicked(Sender: TObject);
    procedure BtnExpandClicked(Sender: TObject);
    procedure BtnPanSmallClicked(Sender: TObject);
    procedure PaintBtns;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Visible : Boolean read bVisible write SetVisible;
    property Expanded: Boolean read bExpanded write SetExpanded;
  end;

  //BG180810: Neu
  TCurveTitleBar = class(TPanel)
  private
    Graph: TXYGraph;
    bVisible : Boolean;
    BtnAllOn : TSpeedButton;
    BtnAllOff : TSpeedButton;
    lblTitle : TLabel;
    btnResize: TSpeedButton;
  protected
    procedure BtnAllOnClicked(Sender: TObject);
    procedure BtnAllOffClicked(Sender: TObject);
    procedure SetVisible (bVal : Boolean);
    procedure PaintBtns;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Visible : Boolean read bVisible write SetVisible;
  end;

  //BG180810: Neu
  TMarkerBar = class(TPanel)
  private
    Graph: TXYGraph;
    bVisible : Boolean;
    BtnAbsMkrSmall : TSpeedButton;
    BtnRelMkrSmall : TSpeedButton;
    bvAbsMkrSmall : TBevel;
    bvRelMkrSmall : TBevel;
    lblAbsMkrSmall : TLabel;
    lblRelMkrSmall : TLabel;
    lblTitle : TLabel;
    btnResize: TSpeedButton;
    btnMarkerVert1, btnMarkerVert2: TSpeedButton;
    bResized: Boolean;
  protected
    procedure SetVisible(bVal : Boolean);
    procedure SetResized(bVal : Boolean);
    procedure PaintBtns;
  public
    seAbsMkr : TSpinEdit;
    seRelMkr : TSpinEdit;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BtnAbsMkrClicked(Sender: TObject);
    procedure BtnRelMkrClicked(Sender: TObject);
    procedure seAbsMkrChange(Sender: TObject);
    procedure seRelMkrChange(Sender: TObject);
    procedure BtnResizeClicked(Sender: TObject);
    procedure btnMarkerVertClicked(Sender: TObject);
    property Visible : Boolean read bVisible write SetVisible;
    property Resized: Boolean read bResized write SetResized;
  end;

  //BG180810: Neu
  TFreeMarkerBar = class(TPanel)
  private
    Graph: TXYGraph;
    bVisible : Boolean;
    bvlblFree : TBevel;
    lblFree : TLabel;
  protected
    procedure SetVisible (bVal : Boolean);
    procedure PaintBtns;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Visible : Boolean read bVisible write SetVisible;
  end;

  TTextOnMouseMoveEvent = procedure(Sender: TObject; XS,YS : integer;
    X, Y : Double; var sText : string) of object;

  TXYGraph = class(TCustomPanel)
    procedure SetBounds(ALeft,ATop,AWidth,AHeight: Integer); override;
  private
    FXAxis: TAxis;
    FYAxis: TAxis;
    FColors: TColors;
    FPositions: TPositions;
    FFonts: TFonts;
    FCurve: TCurve;
    FCurveGroup: TCurveGroup;
    FCurveList: TList;
    FCurveGroupList: TList;  //BG160810
    FHintPanel: THintPanel;
    FControls: TControls;
    FMode: TMode;
    FGraphTitle: Str32;
    FZoom: TFloat;
    FMaxZoom: TFloat;

    DXFOut: TDXFOut;
    MouseX: Integer;
    MouseY: Integer;
    CPBmp: TBitMap;
    CPRect: TRect;
    CPMatch: Boolean;                          {Flag für Kontrollpunkterkennung}
    CPCurve: Integer;                      {Index für Kurve des Kontrollpunktes}
    LastCPCurve: Integer;                  {Index für Kurve des Kontrollpunktes}
    CPIndex: Integer;                     {Index für Kontrollpunkt in der Kurve}
    LastCPIndex: Integer;                 {Index für Kontrollpunkt in der Kurve}
    CPx: TFloat;                                    {X-Wert des Kontrollpunktes}
    CPy: TFloat;                                    {Y-Wert des Kontrollpunktes}

    FUpdateCount: Integer;                          //MD

    IsLoaded: Boolean;                                         {Flag für Loaded}
    BoundsChanged: Boolean;
    ZoomSave: TFloat;
    Freeze: Boolean;
    ZoomAspectRatio: Boolean;
    PanCurves: Boolean;
    HClip: HRgn;

    // neu BG
    bZoomRun : Boolean;                   //Variablen für den Zoom
    OrgPnt           : TPoint;
    MovPnt           : TPoint;
    pGridRect        : ^TRect;
    pClipRect        : pointer;           //Maus beim zoomem eingrenzen

    ActMkr           : ^TMarker;
    iActMkrNo        : integer;
//    iCrvMkr          : word;              //Marker should use curve no. x}

    //bRefresh: Boolean;
    bShowZoom : Boolean;
    bShowMarker : Boolean;
    bShowCurveTitles : Boolean; //Kurvennamen
    bShowFree : Boolean;
    FOnRefresh: TNotifyEvent;
    FTextOnMouseMoveEvent : TTextOnMouseMoveEvent;

    fAddNoPoints: Boolean; //keine Kurvenpunkte laden, damit ist der Graßh im Automatikbetrieb quasi außer Kraft gesetzt
    cColorIndex: TColor;
    iFarbschema: integer;

    sbCurveTitles: TScrollBox;
    PBCurveTitles: TPaintBox;

    Timer: TTimer;
  protected
    procedure Loaded; override;
    procedure DrawXAxis;
    procedure DrawYAxis;
    function  DrawCurveTitles: integer; //BG290906: Neu
    procedure PaintCurveTitles(Sender: TObject);
    procedure OnChangePaint(Sender: TObject);
    procedure DoButtonClick(Sender: TObject);
    procedure DoRadioButtonClick(Sender: TObject);
    procedure DoCheckBoxClick(Sender: TObject);
    procedure DoListBoxClickCheck(Sender: TObject);
    procedure DoXEditExit(Sender: TObject);
    procedure DoYEditExit(Sender: TObject);

    procedure DoPan(Dx,Dy: Integer);
    procedure DoZoom(Dx,Dy: Integer);
    procedure DoMouse(X,Y: Integer);
    procedure SetMeasureCursor(X,Y: Integer);
    procedure DoMeasureCursor(X,Y: Integer);
    procedure DoMove(Dx,Dy: Integer);
    procedure DoCheckCP(X,Y: Integer);

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X,Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X,Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X,Y: Integer); override;
    procedure DblClicked(Sender: TObject);
    procedure SetGraphTitle(const Value: Str32);
    procedure SetEditEnable(Value: Boolean);
    procedure OutMode(const Mode: Str32);
    procedure OutCurve(const Curve: Str32);
    procedure OutItem(Item: Integer);
    procedure OutColor(Color: TColor);
    procedure OutAngle(A: TFloat);
    procedure OutXY(Fx,Fy: TFloat);
    procedure ClearMarkBox;
    procedure DrawMarkBox;
    procedure DrawMark(ACanvas: TCanvas; MarkType: TMarkType;
                       MarkColor: TColor; MarkSize: TMarkSize; X,Y: Integer);

    //neu BG
    procedure InitMkr (var xMkr : TMarker; Color : TColor);
    procedure UpdateMkr (var xMkr : TMarker);
    procedure SetActMkrNo (iMkr : integer);
    procedure MovMkrToPnt (xPos : integer; xMkr : TMarker);
    procedure MovVertMkrToPnt (xPos : integer; xMkr : TMarker);
    function  CalcMkrX (var xVal : Double) : integer;
    function  CalcMkrY (var yVal : Double) : integer;
    procedure WriteFreeText (XS, YS : integer);
    procedure SetRefresh (bVal : Boolean);
    procedure SetShowFree (bVal : Boolean);
    procedure SetShowZoom (bVal : Boolean);
    procedure SetShowMarker (bVal : Boolean);
    procedure SetShowCurveTitles (bVal : Boolean);

    function  GetCurveCount: integer;

    procedure OnTimerEvent(Sender: TObject);

    procedure BtnCurveCheckBoxClicked(Sender: TObject);
    procedure BtnCurveGroupCheckBoxClicked(Sender: TObject);

    procedure SetColorIndex(aVal: TColor);
    procedure SetFarbschema(aVal: integer);
  public
    DrawBmp: TBitMap; //BG290906: von privat in public gezogen

    ToolBar          : TPanel;
    XYToolBar        : TXYToolBar;        //Werkzeugleiste Zoom
    CurveTitleBar    : TCurveTitleBar;    //Werkzeugleiste Kurventitel
    MarkerBar        : TMarkerBar;        //Werkzeugleiste Marker
    FreeMarkerBar    : TFreeMarkerBar;    //Werkzeugleiste Freier Marker

    AbsMkr           : TMarker;           //neu BG absoluter Marker
    RelMkr           : TMarker;           //neu BG relativer Marker

    MouseXReal: Double;
    MouseYReal: Double;

    ColorPalette: Array[0..1, 0..MaxColor] of TColor; //Kurvenfarben
    function GetNextColor: TColor;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    procedure Resize; override;
    procedure Notification(Component: TComponent; Operation: TOperation); override;
    function MakeCurve(const AName: Str32; AColor: TColor; ALineWidth: Byte;
                       APenStyle: TPenStyle; AEnabled: Boolean; APos, ACurveGroup : integer): Integer;
    function AddGroup(const AName: Str32; AEnabled: Boolean; IPos : integer): Integer;
    procedure AddPoint(AIndex: Integer; X,Y: TFloat);
    procedure AddPointColor(AIndex: Integer; X,Y: TFloat; Col: TColor); //BG280103
    procedure SetBrushColor(AIndex: Integer; aColor: TColor);
    procedure AddPointText(AIndex: Integer; X,Y: TFloat;Text: String); //BG120203
    procedure AddPointTextColor(AIndex: Integer; X,Y: TFloat;Text: String; Col: TColor); //BG260603
    procedure AddBreakPoint(AIndex, APointIndex: Integer);
    procedure AddText(AIndex,APosition,AXOfs,AYOfs: Integer; const AText: Str32; AColor: TColor);
    procedure SetCurveFont(AIndex: Integer; AName: TFontName; ASize: Integer; AStyle: TFontStyles);
    procedure AddMark(AIndex,APosition: Integer; AMarkType: TMarkType; AColor: TColor);
    procedure SetMarkSize(AIndex: Integer; AMarkSize: TMarkSize);
    procedure ChangePoint(AIndex,APosition: Integer; X,Y: TFloat);
    procedure DeleteCurve(AItem: Integer);
    procedure DeleteCurveGroup(AItem: Integer);
    procedure DeleteAllCurves;
    procedure DeleteAllCurveGroups;
    function GetCurveHandle(AName: Str32; var H: Integer): Boolean;
    function GetCurveName(H: Integer): Str32;
    procedure SetCurveEnabled(AIndex: Integer; Value: Boolean);
    procedure SetCurveStyle(AIndex, AValue: Integer);
    procedure SetCurveColor(AIndex: Integer; Value: TColor);
    function GetCurveEnabled(AIndex: Integer): Boolean;
    procedure GetPoint(AIndex,APosition: Integer; var X,Y: TFloat);
    procedure InsertPoint(AIndex,APosition: Integer; X,Y: TFloat);
    procedure DeletePoint(AIndex,APosition: Integer);
    procedure DeleteAllCurvePoints(AIndex: Integer);
    procedure DeleteAllCurvesCurvePoints;
    procedure Reset;
    procedure ShowHintPanel(Show: Boolean);
    procedure SetXOfs(AIndex: Integer; AOfs: TFloat);
    function GetXOfs(AIndex: Integer): TFloat;
    procedure SetYOfs(AIndex: Integer; AOfs: TFloat);
    function GetYOfs(AIndex: Integer): TFloat;
    procedure CheckCurvePoints(X,Y: Integer);
    procedure ChangeCPx(Fx: TFloat);   {X-Wert Kontrollpunkt Änderung von außen}
    procedure ChangeCPy(Fy: TFloat);   {Y-Wert Kontrollpunkt Änderung von außen}
    procedure ChangeCurveOfs(Ox,Oy: TFloat; Relative: Boolean);
    procedure GetCPInfo(var CPMatch: Boolean; var CPCurve,CPIndex: Integer);
    procedure SetZoom(Value: TFloat);
    procedure SetMode(Value: TMode);
    function GetMaxPoints: Integer;
    function XAxisPixel(Value: TFloat): Integer;
    function YAxisPixel(Value: TFloat): Integer;

    function MakeDXF(const FileName: string; FromX1,FromY1,FromX2,FromY2,
                     ToX1,ToY1,ToX2,ToY2,TextHeight: TFloat; Decimals: Byte): Boolean;
    procedure DXFAxis;
    procedure DXFCurves;

    procedure AsciiCurves;


    function SaveCurveToStream(FileStream: TFileStream; Item: Integer): Boolean;
    function LoadCurveFromStream(FileStream: TFileStream): Boolean;
    function SaveCurveToFile(const FileName: string; Item: Integer): Boolean;
    function LoadCurveFromFile(const FileName: string): Boolean;
    function SaveGraphToFile(const FileName: string): Boolean;
    function LoadGraphFromFile(const FileName: string): Boolean;

    procedure BeginUpdate;                       //MD
    procedure EndUpdate;                         //MD

    property HintPanel: THintPanel read FHintPanel write FHintPanel;
    property Mode: TMode read FMode write SetMode;
    property Zoom: TFloat read FZoom write SetZoom;
    property NoAddPoints: Boolean read fAddNoPoints write fAddNoPoints;

    procedure DrawMkr (var xMkr : TMarker);
    procedure ShowMkr (var xMkr : TMarker);
    procedure HideMkr (var xMkr   : TMarker);
    procedure ShowMkrs;
    procedure HideMkrs;
    procedure ClearMkrs;
    procedure ZoomOut;
    procedure ZoomIn;
    procedure SetMkrToX (xPos : Double; xMkr : TMarker);

    property  CurveCount: integer read GetCurveCount;

    procedure TextOutAngle(const aCanvas: TCanvas; X, Y: Integer; const AText: String; AAngle: Integer);

    property ColorIndex: TColor read cColorIndex write SetColorIndex;
    property Farbschema: integer read iFarbschema write SetFarbschema;

    function SetColorToCrv(aIdx, aMaxIdx, aSchema: Byte; aGroundColor: TColor): TColor;
    function SetMainTicks(aMin, aMax: double): integer;
    function CheckDecimals(aD: Double): integer;

  published
    property Align;
    property Anchors;
    property Hint;
    property ShowHint;
    property OnClick;
    property OnKeyPress;
    property OnKeyDown;
    property OnMouseMove;
    property OnMouseDown;
    property OnMouseUp;

    property OnRefresh: TNotifyEvent read FOnRefresh write FOnRefresh default nil;
    property OnTextMouseMove: TTextOnMouseMoveEvent read FTextOnMouseMoveEvent write FTextOnMouseMoveEvent default nil;

    property Colors: TColors read FColors write FColors;
    property Fonts: TFonts read FFonts write FFonts;
    property GraphTitle: Str32 read FGraphTitle write SetGraphTitle;
    property Positions: TPositions read FPositions write FPositions;
    property XAxis: TAxis read FXAxis write FXAxis;
    property YAxis: TAxis read FYAxis write FYAxis;
    property Controls: TControls read FControls write FControls;
    property MaxZoom: TFloat read FMaxZoom write FMaxZoom;

    property piActMkrNo : integer read iActMkrNo write SetActMkrNo;
    //property pbRefresh : Boolean read bRefresh write SetRefresh;
    property pbShowZoom : Boolean read bShowZoom write SetShowZoom;
    property pbShowFree : Boolean read bShowFree write SetShowFree;
    property pbShowMarker : Boolean read bShowMarker write SetShowMarker;
    property pbShowCurveTitles : Boolean read bShowCurveTitles write SetShowCurveTitles;

  end;
{------------------------------------------------------------------------------}

procedure Register;
function AtoF(S: Str32; var F: TFloat): Boolean;
function InRange(Test,Min,Max: Integer): Boolean;
function Angle(X1,Y1,X2,Y2: TFloat): TFloat;       {0°-360° gegen Uhrzeigersinn}
procedure TextOutRotate(ACanvas: TCanvas; X,Y: Integer; Ang: Word; S: Str32);
function  GET_EXP (   Number : double) : integer;

implementation
{------------------------------------------------------------------------------}

{$R XYGraphNew.RES}


uses
  SysUtils,Dialogs,ComCtrls, Math;
{------------------------------------------------------------------------------}

procedure Register;
begin
  RegisterComponents('Udo',[TXYGraph]);
end;
{------------------------------------------------------------------------------}

function AtoF(S: Str32; var F: TFloat): Boolean;
var
  Code: Integer;
begin
  Code:=Pos(',',S);
  if Code > 0 then S[Code]:='.';
  Val(S,F,Code);
  Result:=Code = 0;
end;
{------------------------------------------------------------------------------}

function InRange(Test,Min,Max: Integer): Boolean;
begin
  Result:=(Test >= Min) and (Test <= Max);
end;
{------------------------------------------------------------------------------}

function Angle(X1,Y1,X2,Y2: TFloat): TFloat;                 {Steigung = 0..90°}
var                                                          {Gefälle = 0..-90°}
  Dx: TFloat;
  Dy: TFloat;
begin
  Result:=0;
  Dx:=X2 - X1;
  Dy:=Y2 - Y1;
  if Dx <> 0 then Result:=ArcTan(Dy / Dx) / Pi * 180;
  if Dx < 0 then Result:=-Result;
end;
{------------------------------------------------------------------------------}

procedure TextOutRotate(ACanvas: TCanvas; X,Y: Integer; Ang: Word; S: Str32);
var
  LogRec: TLogFont;
  OldFontHandle: HFont;
  NewFontHandle: HFont;
begin
  GetObject(ACanvas.Font.Handle,SizeOf(LogRec),@LogRec);
  LogRec.lfEscapement:=Ang;
  NewFontHandle:=CreateFontIndirect(LogRec);
  OldFontHandle:=SelectObject(ACanvas.Handle,NewFontHandle);
  ACanvas.TextOut(X,Y,S);
  NewFontHandle:=SelectObject(ACanvas.Handle,OldFontHandle);
  DeleteObject(NewFontHandle);
end;
{------------------------------------------------------------------------------}

function GET_EXP (   Number : double) : integer;
//Die Funktion bestimmt den Exponenten einer Realzahl
begin
  if Number > 0 then
    Result := Trunc(Log10(Number))
  else
    Result := 0;
//  Result := trunc (ln (Number) / clg_ln);
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}

constructor TCurveGroup.Create(AOwner: TComponent);
begin
  inherited Create;
  CheckBox := TCheckBox.Create(Owner);
  CheckBox.Parent := TXYGraph(AOwner);
  CheckBox.Visible := false;
end;
{------------------------------------------------------------------------------}

destructor TCurveGroup.Destroy;
begin
  try
    CheckBox.Free; //BG210108: Neu: Free
  except
  end;
  inherited Destroy;
end;
{------------------------------------------------------------------------------}

procedure TCurveGroup.SetEnabled(aVal: Boolean);
begin
  FEnabled := aVal;
  CheckBox.Checked := FEnabled;
end;
{------------------------------------------------------------------------------}

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}

constructor TCurve.Create(AOwner: TComponent);
begin
  inherited Create;
  FPoints:=TList.Create;
  FTexts:=TList.Create;
  FMarks:=TList.Create;
  FFont:=TFont.Create;
  CheckBox := TCheckBox.Create(Owner);
  CheckBox.Parent := TXYGraph(AOwner);
  CheckBox.Visible := false;
  FFont.Name:='small font';
  FFont.Size:=7;
  FFont.Style:=[];
  FMarkSize:=4;
  FEnabled:=True;
  FColor:=clWhite;
  FLineWidth:=1;
  FPenStyle:=psSolid;
  FXOfs:=0.0;
  FYOfs:=0.0;
  FBrushColor := clTeal;
  FMinX := MaxDouble;
  FMinY := MaxDouble;
  FMaxX := MinDouble;
  FMaxY := MinDouble;
end;
{------------------------------------------------------------------------------}

destructor TCurve.Destroy;
var
  I: Integer;
begin
  try
    for I:=0 to Pred(FPoints.Count) do FreeMem(FPoints.Items[I],SizeOf(TPointRec));
    FPoints.Free;
    for I:=0 to Pred(FTexts.Count) do FreeMem(FTexts.Items[I],SizeOf(TTextRec));
    FTexts.Free;
    for I:=0 to Pred(FMarks.Count) do FreeMem(FMarks.Items[I],SizeOf(TMarkRec));
    FMarks.Free;
    FFont.Free;
    SetLength(PointCol, 0);
    SetLength(PointText, 0);
    SetLength(FBreakPoints, 0);
    CheckBox.Free; //BG210108: Neu: Free
  except
  end;
  inherited Destroy;
end;
{------------------------------------------------------------------------------}

procedure TCurve.SetEnabled(aVal: Boolean);
begin
  FEnabled := aVal;
  CheckBox.Checked := FEnabled;
end;
{------------------------------------------------------------------------------}

procedure TCurve.AddPoint(Ax,Ay: TFloat);
begin
  GetMem(PPoint,SizeOf(TPointRec));
  PPoint^.X:=Ax;
  PPoint^.Y:=Ay;
  FPoints.Add(PPoint);
  FMinX := Min(FMinX, Ax);
  FMinY := Min(FMinY, Ay);
  FMaxX := Max(FMaxX, Ax);
  FMaxY := Max(FMaxY, Ay);
end;
{------------------------------------------------------------------------------}

procedure TCurve.AddPointColor(Ax,Ay: TFloat;Col: TColor);
begin
  GetMem(PPoint,SizeOf(TPointRec));
  PPoint^.X:=Ax;
  PPoint^.Y:=Ay;
  FPoints.Add(PPoint);
  SetLength(PointCol, FPoints.Count);
  PointCol[FPoints.Count-1] := Col;
  FMinX := Min(FMinX, Ax);
  FMinY := Min(FMinY, Ay);
  FMaxX := Max(FMaxX, Ax);
  FMaxY := Max(FMaxY, Ay);
end;
{------------------------------------------------------------------------------}

procedure TCurve.SetBrushColor(aColor: TColor);
begin
  FBrushColor := aColor;
end;
{------------------------------------------------------------------------------}

procedure TCurve.AddPointText(Ax,Ay: TFloat;Text: String);
begin
  GetMem(PPoint,SizeOf(TPointRec));
  PPoint^.X:=Ax;
  PPoint^.Y:=Ay;
  FPoints.Add(PPoint);
  SetLength(PointText, FPoints.Count);
  PointText[FPoints.Count-1] := Text;
end;
{------------------------------------------------------------------------------}

procedure TCurve.AddPointTextColor(Ax,Ay: TFloat;Text: String; Col: TColor);
begin
  GetMem(PPoint,SizeOf(TPointRec));
  PPoint^.X:=Ax;
  PPoint^.Y:=Ay;
  FPoints.Add(PPoint);
  SetLength(PointText, FPoints.Count);
  PointText[FPoints.Count-1] := Text;
  SetLength(PointCol, FPoints.Count);
  PointCol[FPoints.Count-1] := Col;
end;
{------------------------------------------------------------------------------}

procedure TCurve.AddBreakPoint(APointIndex: Integer);
var
  iLen : integer;
begin
  iLen := Length (FBreakPoints);
  SetLength (FBreakPoints, iLen + 1);
  FBreakPoints[iLen] := APointIndex;
end;

{------------------------------------------------------------------------------}
procedure TCurve.AddText(APointIndex,AXOfs,AYOfs: Integer; const AText: Str32; AColor: TColor);
begin
  GetMem(PText,SizeOf(TTextRec));
  PText^.PointIndex:=APointIndex;
  PText^.XOfs:=AXOfs;
  PText^.YOfs:=AYOfs;
  PText^.Text:=AText;
  PText^.TextColor:=AColor;
  FTexts.Add(PText);
end;
{------------------------------------------------------------------------------}

procedure TCurve.AddMark(APointIndex: Integer; AMarkType: TMarkType; AColor: TColor);
begin
  GetMem(PMark,SizeOf(TMarkRec));
  PMark^.PointIndex:=APointIndex;
  PMark^.MarkType:=AMarkType;
  PMark^.MarkColor:=AColor;
  FMarks.Add(PMark);
end;
{------------------------------------------------------------------------------}

procedure TCurve.GetPoint(AIndex: Integer; var Ax,Ay: TFloat);
begin
  if InRange(AIndex,0,Pred(FPoints.Count)) then
  try
    PPoint:=FPoints.Items[AIndex];
    Ax:=PPoint^.X + FXOfs;
    Ay:=PPoint^.Y + FYOfs;
  except
    Ax:=0;
    Ay:=0;
  end;
end;
{------------------------------------------------------------------------------}

procedure TCurve.ChangePoint(AIndex: Integer; Ax,Ay: TFloat);
begin
  if InRange(AIndex,0,Pred(FPoints.Count)) then
  begin
    PPoint:=FPoints.Items[AIndex];
    PPoint^.X:=Ax - FXOfs;
    PPoint^.Y:=Ay - FYOfs;
    FMinX := Min(FMinX, Ax);
    FMinY := Min(FMinY, Ay);
    FMaxX := Max(FMaxX, Ax);
    FMaxY := Max(FMaxY, Ay);
  end;
end;
{------------------------------------------------------------------------------}

procedure TCurve.InsertPoint(AIndex: Integer; Ax,Ay: TFloat);
begin
  if AIndex > -1 then
  begin
    GetMem(PPoint,SizeOf(TPointRec));
    PPoint^.X:=Ax;
    PPoint^.Y:=Ay;
    FPoints.Insert(AIndex,PPoint);
    FMinX := Min(FMinX, Ax);
    FMinY := Min(FMinY, Ay);
    FMaxX := Max(FMaxX, Ax);
    FMaxY := Max(FMaxY, Ay);
  end;
end;
{------------------------------------------------------------------------------}

procedure TCurve.DeletePoint(AIndex: Integer);
var
  i: integer;
begin
  if InRange(AIndex,0,Pred(FPoints.Count)) then
  begin
    FreeMem(FPoints.Items[AIndex],SizeOf(TPointRec));
    FPoints.Delete(AIndex);

    FMinX := MaxDouble;
    FMinY := MaxDouble;
    FMaxX := MinDouble;
    FMaxY := MinDouble;
    for i := 0 to Pred(FPoints.Count) do
    begin
      PPoint:=FPoints.Items[i];
      FMinX := Min(FMinX, PPoint^.X);
      FMinY := Min(FMinY, PPoint^.Y);
      FMaxX := Max(FMaxX, PPoint^.X);
      FMaxY := Max(FMaxY, PPoint^.Y);
    end;
  end;
end;
{------------------------------------------------------------------------------}

procedure TCurve.DeleteAllPoints;
begin
  while FPoints.Count > 0 do
  begin
    FreeMem(FPoints.Items[0],SizeOf(TPointRec));
    FPoints.Delete(0);
  end;
  SetLength(fBreakPoints, 0); //BG280603
  FMinX := MaxDouble;
  FMinY := MaxDouble;
  FMaxX := MinDouble;
  FMaxY := MinDouble;
end;
{------------------------------------------------------------------------------}

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}

constructor TPositions.Create(AGraph: TXYGraph);
begin
  inherited Create;
  Graph := AGraph;
  FToolBarAlign := alLeft;
  FXAxisLeft:=60;
  FXAxisRight:=15;
  FYAxisTop:=30;
  FYAxisBottom:=50;
  FTitleTop:=5;
  FTitleLeft:=0;
  FXAxisTitle:=20;
  FYAxisTitle:=5;
  FXCurveTitle := 40;
  FXCurveTitleExp := 220;
  FOnChange:=nil;
end;
{------------------------------------------------------------------------------}

procedure TPositions.SetInteger(Index,Value: Integer);
begin
  case Index of
    0 : begin
          FXAxisLeft:=Value;
        end;
    1 : begin
          FXAxisRight:=Value;
        end;
    2 : FYAxisTop := Value;
    3 : FYAxisBottom := Value;
    4 : FTitleTop := Value;
    5 : begin
          FTitleLeft := Value;
        end;
    6 : begin
          FXAxisTitle := Value;
        end;
    7 : begin
          FYAxisTitle := Value;
        end;
    8 : begin
          FXCurveTitle := Value;
        end;
    9 : begin
          FYCurveTitle := Value;
        end;
    10: begin
          FXCurveTitleExp := Value;
        end;
    11: begin
          FXGraphLeft := Value;
          Graph.ToolBar.Width := Value;
        end;
    12: begin
          FXToolBar := Value;
        end;
  end;
  if Assigned(FOnChange) then FOnChange(Self);
end;
{------------------------------------------------------------------------------}

procedure TPositions.SetToolBarAlign(AVal: TAlign);
begin
  //if FToolBarAlign <> AVal then
  begin
    FToolBarAlign := AVal;
    Graph.ToolBar.Align := AVal;
    case AVal of
      alNone: begin
                Graph.ToolBar.Parent := nil;
                Graph.ToolBar.Left := 0;
                Graph.ToolBar.Width := 0;
                Graph.ToolBar.Top := 5;
                Graph.ToolBar.Height := 25;

                Graph.Positions.XGraphLeft := 0;

                Graph.XYToolBar.Parent := Graph;
                Graph.XYToolBar.Align := alNone;
                Graph.XYToolBar.Top := 4;
                Graph.XYToolBar.Width := 120;
                Graph.XYToolBar.Height := 25;
                Graph.XYToolBar.BevelInner := bvNone;
                Graph.XYToolBar.BevelOuter := bvNone;

                Graph.MarkerBar.Parent := Graph;
                Graph.MarkerBar.Top := 4;
                Graph.MarkerBar.Width := 143;
                Graph.MarkerBar.Height := 25;
                Graph.MarkerBar.Align := alNone;
                Graph.MarkerBar.BevelInner := bvNone;
                Graph.MarkerBar.BevelOuter := bvNone;
              end;
    else
      Graph.ToolBar.Parent := Graph;
      Graph.ToolBar.Align := alLeft;
      Graph.ToolBar.Width := XGraphLeft;
      Graph.Positions.XGraphLeft := XCurveTitle;

      Graph.XYToolBar.Parent := Graph.ToolBar;
      Graph.XYToolBar.Align := alTop;
      Graph.MarkerBar.Parent := Graph.ToolBar;
      Graph.MarkerBar.Align := alBottom;
    end;
  end;
end;
{------------------------------------------------------------------------------}

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}

constructor TFonts.Create;
begin
  inherited Create;
  FAxisScale:=TFont.Create;
  FAxisScale.Name:='small fonts';
  FAxisScale.Size:=7;
  FAxisScale.Color:=clNavy;

  FAxisTitle:=TFont.Create;
  FAxisTitle.Name:='arial';
  FAxisTitle.Size:=8;
  FAxisTitle.Style:=[fsBold];
  FAxisTitle.Color:=clMaroon;

  FGraphTitle:=TFont.Create;
  FGraphTitle.Name:='arial';
  FGraphTitle.Size:=10;
  FGraphTitle.Style:=[fsBold];
  FGraphTitle.Color:=clMaroon;
  FOnChange:=nil;
end;
{------------------------------------------------------------------------------}

destructor TFonts.Destroy;
begin
  FAxisScale.Free;
  FAxisTitle.Free;
  FGraphTitle.Free;
  inherited Destroy;
end;
{------------------------------------------------------------------------------}

procedure TFonts.SetFont(Index: Integer; Value: TFont);
begin
  case Index of
    0 : FAxisScale.Assign(Value);
    1 : FAxisTitle.Assign(Value);
    2 : FGraphTitle.Assign(Value);
  end;
  if Assigned(FOnChange) then FOnChange(Self);
end;
{------------------------------------------------------------------------------}

constructor TColors.Create;
begin
  inherited Create;
  FAxisBkGnd:=clSilver;
  FTickColor:=clBlack;
  FGraphBkGnd:=clBlack;
  FMainGridColor:=clGray;
  FSubGridColor:=clGray;
  FOnChange:=nil;
end;
{------------------------------------------------------------------------------}

procedure TColors.SetColor(Index: Integer; Value: TColor);
begin
  case Index of
    0: FAxisBkGnd:=Value;
    1: FTickColor:=Value;
    2: FGraphBkGnd:=Value;
    3: FMainGridColor:=Value;
    4: FSubGridColor:=Value;
  end;
  if Assigned(FOnChange) then FOnChange(Self);
end;
{------------------------------------------------------------------------------}

constructor TAxis.Create;
begin
  inherited Create;
  FTitle:='Axis-Title';
  FLength:=200;
  FMin:=0;
  FMax:=10;
  FMinSave:=FMin;
  FMaxSave:=FMax;
  FZoom:=1.0;
  FMainTicks:=5;
  FSubTicks:=5;
  FMainTickLen:=10;
  FSubTickLen:=5;
  FDecimals:=2;
  FPan:=0;
  FPanSubTicks:=0;
  FShowMainGrid:=True;
  FShowSubGrid:=False;
  FShowScale:= true;
  FLog := false;
  FTurnAxScale:= false;
  FOnChange:=nil;
  DelAllMainTicksText;
  CalcAxis;
end;
{------------------------------------------------------------------------------}

procedure TAxis.CalcAxis;
begin
  FValuePerMainTick:=(FMax - FMin) / FMainTicks;
  try
    FFactor:=FLength / (FMax - FMin);
  except
    FFactor:=1.0;
  end;
  FTicks:=FMainTicks * FSubTicks;
  try
    FPixelsPerSubTick:=FLength / FTicks;

  except
    FPixelsPerSubTick:=1;
  end;
  try
    FValuePerPixel:=FValuePerMainTick / (FSubTicks * FPixelsPerSubTick);
  except
    FValuePerPixel:=1;
  end;
end;
{------------------------------------------------------------------------------}

function TAxis.Value(APosition: Integer): TFloat;
begin
  Result:=FMin + (FValuePerPixel * (APosition - FPan));
end;
{------------------------------------------------------------------------------}

function TAxis.Pixel(APosition: TFloat): Integer;
var
  dy: integer;
  YSpan: Double;
begin
  try
    if Log then
    begin
//      Result:=FPan + Round((ln(APosition) - ln(FMin)) * FFactor);
     YSpan := ln(FMax) - ln (FMin);                            //Der Span
     dy := round (ln (APosition / FMin) / YSpan * Length);
     Result := dy;
//            Result:=FPan + Round((APosition - FMin) * FFactor);
    end else
    begin
      if (APosition > -4E10324) and (APosition < 1E10308) then //BG270407: Neu
        Result := FPan + Round((APosition - FMin) * FFactor)
      else
        Result := 0;
    end;
  except
    Result := 0;
    raise;
  end;
end;
{------------------------------------------------------------------------------}

procedure TAxis.SetZoom(Value: TFloat);
var
  Zoom,Dif: TFloat;
begin
  Dif:=FMax - FMin;
  Zoom:=Dif / (Value * FZoom); //Ergebnis in absoluten Einheiten
  FMin:=FMin - Dif + Zoom;
  FMax:=FMax + Dif - Zoom;
  CalcAxis;
end;
{------------------------------------------------------------------------------}

procedure TAxis.SetCenter(C: TFloat);
var
  Dif: TFloat;
begin
  Dif:=(FMax - FMin) / 2;
  FMin:=C - Dif;
  FMax:=C + Dif;
  CalcAxis;
end;
{------------------------------------------------------------------------------}

function TAxis.GetCenter: TFloat;
begin
  Result:=FMin + ((FMax - FMin) / 2);
end;
{------------------------------------------------------------------------------}

procedure TAxis.SetLeftBottom(L: TFloat);
var
  Dif: TFloat;
begin
  Dif:=FMax - FMin;
  FMin:=L;
  FMax:=FMin + Dif;
  CalcAxis;
end;
{------------------------------------------------------------------------------}

procedure TAxis.SetRightTop(R: TFloat);
var
  Dif: TFloat;
begin
  Dif:=FMax - FMin;
  FMax:=R;
  FMin:=FMax - Dif;
  CalcAxis;
end;
{------------------------------------------------------------------------------}

procedure TAxis.SetMinMax(AMin,AMax: TFloat);
begin
  if (AMin < FMax) and (AMax > FMin) then
  begin
    FMin:=AMin;
    FMax:=AMax;
  end;
end;
{------------------------------------------------------------------------------}

procedure TAxis.SetTitle(const Value: Str32);
begin
  if FTitle <> Value then
  begin
    FTitle:=Value;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;
{------------------------------------------------------------------------------}

procedure TAxis.SetLength1(Value: Integer);
begin
  if FLength <> Value then
  begin
    FLength:=Value;
    CalcAxis;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;
{------------------------------------------------------------------------------}

procedure TAxis.SetFloat(Index: Integer; Value: TFloat);
//Minimum und Maximum der Anzeige berechnen
var
  dExp: TFloat;
begin
  case Index of
    0: if (Value <> FMin){ and (Value < FMax) }then
       begin
         if FLog then
         begin
           dExp := GET_EXP(Value)-1;
           FMin := Power(10, dExp);
         end else
           FMin := Value;
         FMinSave := FMin;
         CalcAxis;
         if Assigned(FOnChange) then FOnChange(Self);
       end;
    1: if (Value <> FMax) and (Value > FMin) then
       begin
         if FLog then
         begin
           dExp := GET_EXP(Value)+1;
           FMax := Power(10, dExp);
         end else
           FMax:=Value;
         FMaxSave:=Value;
         CalcAxis;
         if Assigned(FOnChange) then FOnChange(Self);
       end;
  end;
end;
{------------------------------------------------------------------------------}

procedure TAxis.SetMax(Value: TFloat);
begin
end;
{------------------------------------------------------------------------------}

procedure TAxis.SetByte(Index: Integer; Value: Byte);
begin
  case Index of
    0 : begin
          if Value > 0 then
          begin
            FMainTicks := Value;
//            SetLength(MainTicksText, FMainTicks + 1); //rechter Rand ergibt + 1    //BG271006: beware
          end;
        end;
    1 : FSubTicks:=Value;
    2 : FMainTickLen:=Value;
    3 : FSubTickLen:=Value;
    4 : if Value < 5 then FDecimals:=Value;
  end;
  CalcAxis;
  if Assigned(FOnChange) then FOnChange(Self);
end;
{------------------------------------------------------------------------------}

procedure TAxis.DelAllMainTicksText;
var
  i: integer;
begin
  for i := 0 to System.Length(MainTicksText)-1 do
  begin
    MainTicksText[i].dAxVal := -1;
    MainTicksText[i].sText := '';
  end;
  SetLength(MainTicksText, 0);
end;
{------------------------------------------------------------------------------}

procedure TAxis.AddMainTicksText(aPos: integer; aAxVal: Double; sText: string);
begin
  if aPos >= System.Length(MainTicksText) then
    SetLength(MainTicksText, aPos + 1);
  MainTicksText[aPos].dAxVal := aAxVal;
  MainTicksText[aPos].sText := sText;
end;
{------------------------------------------------------------------------------}

procedure TAxis.SetBoolean(Index: Integer; Value: Boolean);
begin
  case Index of
    0 : FShowMainGrid:=Value;
    1 : FShowSubGrid:=Value;
    2 : FShowScale:=Value;
  end;
  if Assigned(FOnChange) then FOnChange(Self);
end;
{------------------------------------------------------------------------------}

procedure TAxis.SetLog(aValue: Boolean);
begin
  fLog := aValue;
  CalcAxis;
  if Assigned(FOnChange) then FOnChange(Self);
end;

{------------------------------------------------------------------------------}
constructor TXYGraph.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Timer:= TTimer.Create(Self);
  with Timer do
  begin
    OnTimer := OnTimerEvent;
    Interval := 15000; //15 sec
    Enabled := true;
  end;

  IsLoaded:=False;
  BoundsChanged:=False;
  ZoomAspectRatio:=True;
  PanCurves:=False;
  CPMatch:=False;
  FZoom:=1.0;
  MaxZoom:=5.0;
  SetBounds(Left,Top,400,300);


  FXAxis:=TAxis.Create;
  FYAxis:=TAxis.Create;
  FColors:=TColors.Create;
  FFonts:=TFonts.Create;
  FPositions:=TPositions.Create(Self);
  FCurveList:=TList.Create;
  FCurveGroupList:=TList.Create;
  DrawBmp:=TBitMap.Create;

  FControls:=TControls.Create(Self);

  FHintPanel:=THintPanel.Create(Self);
  FHintPanel.Parent:=Self;
  FHintPanel.Visible:=True;

  InitMkr (AbsMkr, clRed);
  InitMkr (RelMkr, RGB(0, $FF, 0)); //clAqua);
  iActMkrNo := -1;
  piActMkrNo := 0; //AbsMkr ist der  ActMkr

  FXAxis.OnChange:=OnChangePaint;
  FYAxis.OnChange:=OnChangePaint;
  FFonts.OnChange:=OnChangePaint;
  FColors.OnChange:=OnChangePaint;
  FPositions.OnChange:=OnChangePaint;

  OnDblClick:=DblClicked;

  FGraphTitle:='Graph-Title';
  XAxis.Title:='X-Axis-Title';
  YAxis.Title:='Y-Axis-Title';

  FGraphTitle:=''; //BG120203
  XAxis.Title:='';
  YAxis.Title:='';

  // neu BG
  bZoomRun := false;
  GetMem (pGridRect, sizeof (TRect));
  pClipRect := nil;
  ClipCursor (pClipRect);

  //bRefresh := false;
  bShowZoom := true;
  bShowMarker := true;
  bShowFree := true;

  AbsMkr.bActive := true;
  AbsMkr.bVisible := false;
  RelMkr.bActive := true;
  RelMkr.bVisible := false;
  AbsMkr.iCrv := 0;
  RelMkr.iCrv := 0;

  FOnRefresh := nil;
  FTextOnMouseMoveEvent := nil;

  fAddNoPoints:= false;

  //übergeordentes Panel auf dem alle Legenden liegen
  ToolBar := TPanel.Create(Self);
  ToolBar.Parent := Self;
  ToolBar.Name := 'XYGraphToolBar';
  ToolBar.Caption := '';
  ToolBar.BevelInner := bvNone;
  ToolBar.BevelOuter := bvNone;
  ToolBar.Align := alLeft;
  ToolBar.Top := 0;
  ToolBar.Width := Positions.XGraphLeft;
  ToolBar.Visible := true;
  ToolBar.Color := FColors.FAxisBkGnd;

  //Zoom
  XYToolBar := TXYToolBar.Create (Self);
  XYToolBar.Color := FColors.FAxisBkGnd;
  XYToolBar.Parent := ToolBar;
  XYToolBar.Name := 'XYToolBar';
  XYToolBar.Caption := '';
  XYToolBar.BevelInner := bvLowered;
  XYToolBar.BevelOuter := bvRaised;
  XYToolBar.Align := alTop;
  XYToolBar.Height := 56;
  XYToolBar.Visible := true;

  //Legende
  CurveTitleBar := TCurveTitleBar.Create (Self);
  CurveTitleBar.Color := FColors.FAxisBkGnd;
  CurveTitleBar.Parent := ToolBar;
  CurveTitleBar.Name := 'CurveTitleBar';
  CurveTitleBar.Caption := '';
  CurveTitleBar.BevelInner := bvLowered;
  CurveTitleBar.BevelOuter := bvRaised;
  CurveTitleBar.Align := alClient;
  CurveTitleBar.Height := 250;
  CurveTitleBar.Visible := true;

  sbCurveTitles := TScrollBox.Create(Self);
  sbCurveTitles.Parent := CurveTitleBar;
  sbCurveTitles.Name := 'sbCurveTitles';
  sbCurveTitles.Visible := true;
  sbCurveTitles.HorzScrollBar.Visible := false;
  sbCurveTitles.BorderStyle := bsNone;
  sbCurveTitles.Left := 2;
  sbCurveTitles.Top := ciCurveTitlesHeight + ciCurveTitelsHeader;
  sbCurveTitles.Color := clRed;

  PBCurveTitles:= TPaintBox.Create(Self);
  PBCurveTitles.Parent := sbCurveTitles;
  PBCurveTitles.OnPaint := PaintCurveTitles;
  PBCurveTitles.Left := 1;
  PBCurveTitles.Top := 0;

  //Marker
  MarkerBar := TMarkerBar.Create (Self);
  MarkerBar.Color := FColors.FAxisBkGnd;
  MarkerBar.Parent := ToolBar;
  MarkerBar.Name := 'MarkerBar';
  MarkerBar.Caption := '';
  MarkerBar.BevelInner := bvLowered;
  MarkerBar.BevelOuter := bvRaised;
  MarkerBar.Align := alBottom;
  MarkerBar.Visible := true;

  //Marker
  FreeMarkerBar := TFreeMarkerBar.Create (Self);
  FreeMarkerBar.Top := 4;
  FreeMarkerBar.Left := Width - Positions.XAxisRight;
  FreeMarkerBar.Height := 25;
  FreeMarkerBar.Width := 136;
  FreeMarkerBar.Color := FColors.FAxisBkGnd;
  FreeMarkerBar.Parent := Self;
  FreeMarkerBar.Name := 'FreeMarkerBar';
  FreeMarkerBar.Caption := '';
  FreeMarkerBar.BevelInner := bvNone;
  FreeMarkerBar.BevelOuter := bvNone;
  FreeMarkerBar.Align := alNone;
  FreeMarkerBar.Visible := true;


end;
{------------------------------------------------------------------------------}

destructor TXYGraph.Destroy;
var
  I: Integer;
begin
  FXAxis.Free;
  FYAxis.Free;
  FPositions.Free;
  FColors.Free;
  FFonts.Free;
  for I:=0 to Pred(FCurveList.Count) do
  begin
    FCurve:=FCurveList.Items[I];
    FCurve.Free;
  end;
  FCurveList.Free;
  for I:=0 to Pred(FCurveGroupList.Count) do
  begin
    FCurveGroup := FCurveGroupList.Items[I];
    FCurveGroup.Free;
  end;
  FCurveGroupList.Free;
  DrawBmp.Free;
  PBCurveTitles.Free;
//  FHintPanel.Free;
//  FControls.Free;

  //neu BG
  FreeMem (pGridRect, sizeof (TRect));

  //MD 13.09.02
  FControls.Free;
  //XYToolBar.Free;

  sbCurveTitles.Free;
  ToolBar.Free;

  inherited Destroy;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.Loaded;
begin
  inherited Loaded;
  XAxis.FMinSave:=XAxis.FMin;
  XAxis.FMaxSave:=XAxis.FMax;
  YAxis.FMinSave:=YAxis.FMin;
  YAxis.FMaxSave:=YAxis.FMax;

  XAxis.CalcAxis;
  YAxis.CalcAxis;

  ZoomSave:=Zoom;

  SetMode(gmNone);
  IsLoaded:=True;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.OnTimerEvent(Sender: TObject);
begin
  if pClipRect <> nil then
  begin
    pClipRect := nil;
    ClipCursor (pClipRect);                                                     //Cursor darf sich wieder überall bewegen
  end;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.BtnCurveCheckBoxClicked(Sender: TObject);
//Name nach Schema: chbCurve_xxx
//wobei xxx die Kurvennummer ist
var
  sName, sCrv: string;
  iPos, iCrv: integer;
begin
  sName := TCheckBox(Sender).Name;
  iPos := Pos('_', sName);
  if iPos > 0 then
  begin
    sCrv := Copy(sName, iPos+1, Length(sName));
    iCrv := StrToIntDef(sCrv, -1);
    if (iCrv > -1) and
       (iCrv < FCurveList.Count) then
    begin
      FCurve := FCurveList.Items[ICrv];
      FCurve.Enabled := TCheckBox(Sender).Checked;
    end;
  end;
  paint; //BG070308: Neu malen
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.BtnCurveGroupCheckBoxClicked(Sender: TObject);
//BG240810: Neu
//Name nach Schema: chbCurve_xxx
//wobei xxx die Kurvennummer ist
var
  sName, sGroup, sCrv: string;
  iPos, iGroup, iCrv: integer;
begin
  sName := TCheckBox(Sender).Name;
  iPos := Pos('_', sName);
  if iPos > 0 then
  begin
    sGroup := Copy(sName, iPos+1, Length(sName));
    iGroup := StrToIntDef(sGroup, -1);
    if (iGroup > -1) and
       (iGroup < FCurveGroupList.Count) then
    begin
      FCurveGroup := FCurveGroupList.Items[IGroup];
      FCurveGroup.Enabled := TCheckBox(Sender).Checked;
      for iCrv := 0 to FCurveList.Count-1 do
      begin
        FCurve := FCurveList.Items[ICrv];
        if FCurve.CurveGroup = iGroup then
          FCurve.Enabled := TCheckBox(Sender).Checked;
      end;
    end;
  end;
  paint; //Neu malen
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.SetBounds(ALeft,ATop,AWidth,AHeight: Integer);
begin
  inherited SetBounds(ALeft,ATop,AWidth,AHeight);
  BoundsChanged:=True;
end;
{------------------------------------------------------------------------------}

function TXYGraph.XAxisPixel(Value: TFloat): Integer;
begin
  Result:= FPositions.FXGraphLeft + Positions.XAxisLeft + XAxis.Pixel(Value);
end;
{------------------------------------------------------------------------------}

function TXYGraph.YAxisPixel(Value: TFloat): Integer;
var
  Fy2: integer;
begin
  if YAxis.Log then
  begin
     Fy2 := Height - FPositions.FYAxisBottom;                                //untere rechte Ecke des Grids
     Result:= Fy2 - YAxis.Pixel(Value);
  end else
    Result:=Height - Positions.YAxisBottom - YAxis.Pixel(Value);
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.Paint;
const
  ciCross1 = 1;
  ciCross  = 2;
  ciCross3 = 3;
  ciLine   = 4;
var
  R: TRect;
  H,I,J, J1, J2: Integer;
  X,Y: TFloat;
  Size: integer;   //MD Word;
  PA: array of TPoint;  //MD PPointArray;
  PText: PTextRec;
  PMark: PMarkRec;
  iBreakPnt: integer;
  ix,iy, iCnt: integer;
begin
  if FUpdateCount <> 0 then
    Exit;

//  ClearMkrs;
//  Canvas.Brush.Style:=bsClear;
  if BoundsChanged then
  begin
    XAxis.Length := Width - Positions.XGraphLeft - Positions.XAxisLeft - Positions.XAxisRight;
    YAxis.Length := Height - Positions.YAxisTop - Positions.YAxisBottom;
    BoundsChanged:=False;
  end;

  if CPMatch or (FMode = gmCursor) then ClearMarkBox;

  DrawBmp.Canvas.Brush.Style:=bsClear;

  DrawBmp.Width:=Width;
  DrawBmp.Height:=Height;
  DrawBmp.Canvas.Pen.Width:=1;

  DrawBmp.Canvas.Brush.Color := FColors.FGraphBkGnd;
  DrawBmp.Canvas.FillRect(Rect(Positions.XGraphLeft + FPositions.XAxisLeft,FPositions.YAxisTop,
                               Width - Positions.XAxisRight,Height - Positions.YAxisBottom));
  DrawBmp.Canvas.Brush.Color := FColors.AxisBkGnd;
  DrawBmp.Canvas.FillRect(Rect(0,0,Positions.XGraphLeft+Positions.XAxisLeft,Height));
  DrawBmp.Canvas.FillRect(Rect(Positions.XGraphLeft+Positions.XAxisLeft,0,Width,Positions.YAxisTop));
  DrawBmp.Canvas.FillRect(Rect(0,Height - Positions.YAxisBottom,Width,Height));
  DrawBmp.Canvas.FillRect(Rect(Width - Positions.XAxisRight,Positions.YAxisTop,Width,Height - FPositions.YAxisBottom));

  DrawBmp.Canvas.Brush.Color := clGray;
  R:=Rect(0,0,Width,Height);
  DrawBmp.Canvas.FrameRect(R);
  InflateRect(R,-1,-1);
  DrawBmp.Canvas.Brush.Color:=clWhite;
  DrawBmp.Canvas.FrameRect(R);
  DrawBmp.Canvas.Brush.Style:=bsClear;

  //Titelgrafik
  if Length(FGraphTitle) > 0 then
  begin
    DrawBmp.Canvas.Font := FFonts.FGraphTitle;
    if Positions.TitleLeft = 0 then
      DrawBmp.Canvas.TextOut(Width div 2 - DrawBmp.Canvas.TextWidth(FGraphTitle) div 2,
                             Positions.TitleTop,FGraphTitle)
    else
      DrawBmp.Canvas.TextOut(Positions.XGraphLeft + Positions.TitleLeft, Positions.TitleTop, FGraphTitle);
  end;

  DrawXAxis;
  DrawYAxis;
  DrawCurveTitles;
  FreeMarkerBar.PaintBtns;

  HClip:=CreateRectRgn(Positions.XGraphLeft+Positions.XAxisLeft,Positions.YAxisTop,
                       Width - Positions.XAxisRight + 1,Height - Positions.YAxisBottom + 1);
  SelectClipRgn(DrawBmp.Canvas.Handle,HClip);
  {MD Size:=GetMaxPoints * SizeOf(TPointArray);
  GetMem(PA,Size);}
  //SetLength(PA, GetMaxPoints);

  for H:=0 to Pred(FCurveList.Count) do
  begin
    FCurve:=FCurveList.Items[H];
    if FCurve.Enabled and (FCurve.FPoints.Count > 0) then
    begin
      DrawBmp.Canvas.Pen.Color := FCurve.Color;
      DrawBmp.Canvas.Pen.Style := FCurve.PenStyle;
      DrawBmp.Canvas.Pen.Width := FCurve.LineWidth;
      DrawBmp.Canvas.Brush.Color := FColors.FGraphBkGnd;
//      DrawBmp.Canvas.Brush.Style:= bsClear; //beware, dann geht das Löschen nicht mehr
      try
        case FCurve.CurveStyle of
          0: begin //Linie
                if Length (FCurve.FBreakPoints) > 0 then
                begin //die Kurve ist in mehrere Abschnitte unterteilt
                  for iBreakPnt := Low(FCurve.FBreakPoints) to High(FCurve.FBreakPoints) do
                  begin
                    if iBreakPnt = Low(FCurve.FBreakPoints) then
                      J1 := 0
                    else
                      J1 := FCurve.FBreakPoints[iBreakPnt-1];
                    if iBreakPnt = High(FCurve.FBreakPoints) then
                      J2 := Pred(FCurve.FPoints.Count)
                    else
                      J2 := FCurve.FBreakPoints[iBreakPnt]-1;
                    SetLength(PA, J2 - J1 + 1);
                    iCnt := 0;
                    for I := J1 to J2 do
                    try
                      FCurve.GetPoint(I,X,Y);
                      PA[I - J1].x:=XAxisPixel(X);
                      PA[I - J1].y:=YAxisPixel(Y);
                      if Length(FCurve.PointCol) > 0 then
                      begin //Sonderfall einzelne Linien haben andere Farben, da hilft nur einzeln malen
                        DrawBmp.Canvas.Pen.Color := FCurve.PointCol[i];

//hier werden wohl Linien vergessen???
//                        if I - J1 = 0 then
//                          DrawBmp.Canvas.MoveTo(PA[I - J1].X, PA[I - J1].Y)
//                        else
                          DrawBmp.Canvas.LineTo(PA[I - J1].X, PA[I - J1].Y);
                      end;
                      inc(iCnt);
                    except
                    end;
                    if (iCnt > 0) and (Length(FCurve.PointCol) = 0) then
                      DrawBmp.Canvas.PolyLine(PA);     //kann nur 15000
                  end;
                end else
                begin //eine Kurve, aber evt. länger als 15000 Punkte
                  J1 := 0;
                  J2 :=Pred(FCurve.FPoints.Count);
                  while J1 < J2 do
                  begin
                    if J2 - J1 + 1 > 15000 then
                      J := J1 + 15000 else
                      J := J2;
                    SetLength(PA, J - J1 + 1);   //MD
                    iCnt := 0;
                    for I:= J1 to J do
                    try
                      FCurve.GetPoint(I,X,Y);
                      PA[I - J1].x:=XAxisPixel(X);
                      PA[I - J1].y:=YAxisPixel(Y);
                      if Length(FCurve.PointCol) > 0 then
                      begin //Sonderfall einzelne Linien haben andere Farben, da hilft nur einzeln malen
                        DrawBmp.Canvas.Pen.Color := FCurve.PointCol[i];
                        if I - J1 = 0 then
                          DrawBmp.Canvas.MoveTo(PA[I - J1].X, PA[I - J1].Y)
                        else
                          DrawBmp.Canvas.LineTo(PA[I - J1].X, PA[I - J1].Y);
                      end;
                      inc(iCnt);
                    except
                      //raise;
                    end;
                    if (iCnt > 0) and (Length(FCurve.PointCol) = 0) then
                      DrawBmp.Canvas.PolyLine(PA);     //kann nur 15000
                    J1 := J1 + 15000;
                  end;
                end;
              end;
          1 : begin //waagrechte Kreuze
                for i := 0 to Pred(FCurve.FPoints.Count) do
                begin
                  FCurve.GetPoint(I,X,Y);
                  if Length(FCurve.PointCol) > I then
                    DrawBmp.Canvas.Pen.Color := FCurve.PointCol[i];
                  ix := XAxisPixel(X);
                  iy := YAxisPixel(Y);
                  DrawBmp.Canvas.MoveTo(iX, iY - ciCross);
                  DrawBmp.Canvas.LineTo(iX, iY + ciCross + 1);
                  DrawBmp.Canvas.MoveTo(iX - ciCross, iY);
                  DrawBmp.Canvas.LineTo(iX + ciCross + 1, iY);
                end;
              end;
          2 : begin //Andreaskreuze
                for i := 0 to Pred(FCurve.FPoints.Count) do
                begin
                  FCurve.GetPoint(I,X,Y);
                  if Length(FCurve.PointCol) > I then
                    DrawBmp.Canvas.Pen.Color := FCurve.PointCol[i];
                  ix := XAxisPixel(X);
                  iy := YAxisPixel(Y);
                  DrawBmp.Canvas.MoveTo(iX - ciCross, iY - ciCross);
                  DrawBmp.Canvas.LineTo(iX + ciCross + 1, iY + ciCross + 1);
                  DrawBmp.Canvas.MoveTo(iX - ciCross, iY + ciCross);
                  DrawBmp.Canvas.LineTo(iX + ciCross + 1, iY - ciCross - 1);
                end;
              end;
          3 : begin //Kreise
                for i := 0 to Pred(FCurve.FPoints.Count) do
                begin
                  FCurve.GetPoint(I,X,Y);
                  if Length(FCurve.PointCol) > I then
                    DrawBmp.Canvas.Pen.Color := FCurve.PointCol[i];
                  ix := XAxisPixel(X);
                  iy := YAxisPixel(Y);
                  DrawBmp.Canvas.Ellipse(iX - ciCross, iY - ciCross, iX + ciCross + 1, iY + ciCross + 1);
                end;
              end;
          4 : begin //senkrechter Strich
                for i := 0 to Pred(FCurve.FPoints.Count) do
                begin
                  FCurve.GetPoint(I,X,Y);
                  if Length(FCurve.PointCol) > I then
                    DrawBmp.Canvas.Pen.Color := FCurve.PointCol[i];
                  ix := XAxisPixel(X);
                  iy := YAxisPixel(Y);
                  DrawBmp.Canvas.MoveTo(iX, iY - ciLine);
                  DrawBmp.Canvas.LineTo(iX, iY + ciLine);
                end;
              end;
          5 : begin //großes Rechteck
                for i := 0 to Pred(FCurve.FPoints.Count) do
                begin
                  FCurve.GetPoint(I,X,Y);
                  if Length(FCurve.PointCol) > I then
                    DrawBmp.Canvas.Pen.Color := FCurve.PointCol[i];
                  ix := XAxisPixel(X);
                  iy := YAxisPixel(Y);
                  DrawBmp.Canvas.Rectangle(iX - ciLine, iY - ciLine, iX + ciLine + 1, iY + ciLine + 1);
                end;
              end;
          6 : begin //ausgefüllter Kreis
                for i := 0 to Pred(FCurve.FPoints.Count) do
                begin
                  DrawBmp.Canvas.Brush.Style:= bsSolid;
                  if Length(FCurve.PointCol) > I then
                  begin
                    DrawBmp.Canvas.Pen.Color := FCurve.PointCol[i];
                    DrawBmp.Canvas.Brush.Color := FCurve.PointCol[i];
                  end else
                    DrawBmp.Canvas.Brush.Color := FCurve.Color;
                  FCurve.GetPoint(I,X,Y);
                  ix := XAxisPixel(X);
                  iy := YAxisPixel(Y);
                  DrawBmp.Canvas.Ellipse(iX - ciCross3, iY - ciCross3, iX + ciCross3 + 1, iY + ciCross3 + 1);
                end;
              end;
          7 : begin //kleine Kreise
                for i := 0 to Pred(FCurve.FPoints.Count) do
                begin
                  FCurve.GetPoint(I,X,Y);
                  if Length(FCurve.PointCol) > I then
                    DrawBmp.Canvas.Pen.Color := FCurve.PointCol[i];
                  ix := XAxisPixel(X);
                  iy := YAxisPixel(Y);
                  DrawBmp.Canvas.Ellipse(iX - ciCross1, iY - ciCross1, iX + ciCross1 + 1, iY + ciCross1 + 1);
                end;
              end;
          50, 51, 52: begin //gefülltes Polygon
                DrawBmp.Canvas.Pen.Width := 1;
                DrawBmp.Canvas.Brush.Color := FCurve.BrushColor;
                case FCurve.CurveStyle of
                  50:DrawBmp.Canvas.Brush.Style := bsCross;
                  51:DrawBmp.Canvas.Brush.Style := bsDiagCross;
                  52:DrawBmp.Canvas.Brush.Style := bsBDiagonal;
                end;
                if Length (FCurve.FBreakPoints) > 0 then
                begin //die Kurve ist in mehrere Abschnitte unterteilt
                  for iBreakPnt := Low(FCurve.FBreakPoints) to High(FCurve.FBreakPoints) do
                  begin
                    if iBreakPnt = Low(FCurve.FBreakPoints) then
                      J1 := 0
                    else
                      J1 := FCurve.FBreakPoints[iBreakPnt-1];
                    if iBreakPnt = High(FCurve.FBreakPoints) then
                      J2 := Pred(FCurve.FPoints.Count)
                    else
                      J2 := FCurve.FBreakPoints[iBreakPnt]-1;
                    SetLength(PA, J2 - J1 + 1);
                    iCnt := 0;
                    for I := J1 to J2 do
                    try
                      FCurve.GetPoint(I,X,Y);
                      PA[I - J1].x:=XAxisPixel(X);
                      PA[I - J1].y:=YAxisPixel(Y);
                      inc(iCnt);
                    except
                    end;
                    if (iCnt > 0) and (Length(FCurve.PointCol) = 0) then
                    begin
                      DrawBmp.Canvas.Pen.Width := 1;
                      DrawBmp.Canvas.Polygon(PA);
                    end;
                  end;
                end;
              end;
          98: begin //Texte zentriert

                for i := 0 to Pred(FCurve.FPoints.Count) do
                begin
                  if Length(FCurve.PointCol) > I then
                  begin
                    DrawBmp.Canvas.Font.Color := FCurve.PointCol[i];
                  end else
                    DrawBmp.Canvas.Font.Color := FCurve.Color;
                  DrawBmp.Canvas.Font.Style := [];
                  DrawBmp.Canvas.Font.Size := 10;
                  DrawBmp.Canvas.Brush.Style := bsSolid;
                  FCurve.GetPoint(I,X,Y);
                  ix := XAxisPixel(X) - (DrawBmp.Canvas.TextWidth(FCurve.PointText[i]) div 2);
                  iy := YAxisPixel(Y) - (DrawBmp.Canvas.TextHeight(FCurve.PointText[i]) div 2);
                  if (Length(FCurve.PointText) > I) and (FCurve.PointText[i] <> '') then
                  begin
                    DrawBmp.Canvas.TextOut(iX + 3, iY + 3, FCurve.PointText[i]);
                  end;
                end;
              end;
          99: begin //rechts unterhalb
                for i := 0 to Pred(FCurve.FPoints.Count) do
                begin
                  if Length(FCurve.PointCol) > I then
                  begin
                    DrawBmp.Canvas.Font.Color := FCurve.PointCol[i];
                  end else
                    DrawBmp.Canvas.Font.Color := FCurve.Color;
                  DrawBmp.Canvas.Font.Style := [];
                  DrawBmp.Canvas.Font.Size := 10;
                  DrawBmp.Canvas.Brush.Style := bsClear; 
                  FCurve.GetPoint(I,X,Y);
                  ix := XAxisPixel(X);
                  iy := YAxisPixel(Y);
                  if (Length(FCurve.PointText) > I) and (FCurve.PointText[i] <> '') then
                  begin
                    DrawBmp.Canvas.TextOut(iX + 3, iY + 3, FCurve.PointText[i]);
                  end;
                end;
              end;
        end;

        for I:=0 to Pred(FCurve.FTexts.Count) do
        begin
          PText:=FCurve.FTexts.Items[I];
          DrawBmp.Canvas.Font:=FCurve.FFont;
          DrawBmp.Canvas.Font.Color:=PText^.TextColor;
          DrawBmp.Canvas.Brush.Style:=bsClear;
          FCurve.GetPoint(PText^.PointIndex,X,Y);
          DrawBmp.Canvas.TextOut(XAxisPixel(X) + PText^.XOfs,
                                 YAxisPixel(Y) + PText^.YOfs,PText^.Text);
        end;
        for I:=0 to Pred(FCurve.FMarks.Count) do
        begin
          PMark:=FCurve.FMarks.Items[I];
          FCurve.GetPoint(PMark^.PointIndex,X,Y);
          DrawMark(DrawBmp.Canvas,PMark^.MarkType,PMark^.MarkColor,
                   FCurve.FMarkSize,XAxisPixel(X),YAxisPixel(Y));
        end;
      except
      end;
    end;
  end;
  //MD FreeMem(PA,Size);
  DeleteObject(HClip);

  try //BG150208: Neu
//    DrawBmp.SaveToFile('c:\test.bmp'); //nur Debug
  except
  end;

  DrawBmp.Canvas.Pen.Style := psSolid;

  R := ClientRect;
  Canvas.CopyRect(R, DrawBmp.Canvas, R);

  if CPMatch or (FMode = gmCursor) then DrawMarkBox;

  UpdateMkr (AbsMkr); {Marker und Bar erst auf dem Original zeichnen}
  UpdateMkr (RelMkr);
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.Resize;
//BG250810: Neu
begin
  inherited Resize;
  FreeMarkerBar.PaintBtns;
  MarkerBar.PaintBtns;
  XYToolBar.PaintBtns;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.OnChangePaint(Sender: TObject);
begin
  if Sender = FPositions then
  begin
    XAxis.Length:=Width - FPositions.XGraphLeft - FPositions.XAxisLeft - FPositions.XAxisRight;
    YAxis.Length:=Height - FPositions.XGraphLeft - FPositions.YAxisTop - FPositions.YAxisBottom;
  end;
  Application.ProcessMessages;
  if IsLoaded then paint;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.DrawXAxis;
var
  I,X,Y, ITW, ITL: Integer;
  Pos: Integer;
  VPos: Integer;
  S: string;  //25.02.12 md  [12];
  xVal, XSpan: Double;
  dx: integer;
begin
  DrawBmp.Canvas.Font := FFonts.AxisScale;
  DrawBmp.Canvas.Pen.Color:=FColors.FTickColor;
  DrawBmp.Canvas.Pen.Style := psDot;
  Y:=0;
  VPos:=Height - FPositions.YAxisBottom;
  try
    FXAxis.PanSubTicks:=Round(FXAxis.Pan / FXAxis.PixelsPerSubTick);
  except
    FXAxis.PanSubTicks:=1;
  end;
  if FXAxis.Log then
  begin //BG261006: Neu: logarithmische Achsen
    //Bei Log gibt es vorerst keinen Pan oder Zoom!!!!
    FXAxis.Pan := 0;


  end else
  begin //lineare Achse
    if Length(FXAxis.MainTicksText) > 0 then
    begin //BG271006: Neu: freie Achsbeschriftungen
      try
        FXAxis.Pan := 0; //keine Verschiebungen erlaubt
        for i := 0 to Length(FXAxis.MainTicksText)-1 do
        begin
          xVal  := FXAxis.MainTicksText[i].dAxVal;
          S := FXAxis.MainTicksText[i].sText;
          XSpan := FXAxis.FMax - FXAxis.FMin;
          dx := round ((xVal - FXAxis.FMin) / XSpan * XAxis.Length);

          Pos := Positions.XGraphLeft + FPositions.XAxisLeft + dx;
//          if (Pos >= FPositions.XAxisLeft) and
//             (Pos <= Width - FPositions.XAxisLeft - FPositions.FXAxisRight) then
          if (Pos >= Positions.XGraphLeft + FPositions.XAxisLeft) then
          begin
            if FXAxis.TurnAxScale then
              ITW := DrawBmp.Canvas.TextHeight(S)
            else
              ITW := DrawBmp.Canvas.TextWidth(S);
            if FXAxis.FShowScale then
            begin
              if FXAxis.TurnAxScale then
              begin //BG061106: Neu: senkrechte Achsskalierung
                ITL := DrawBmp.Canvas.TextWidth(S);
                DrawBmp.Canvas.Font := FFonts.AxisScale;
                DrawBmp.Canvas.Font.Name := 'Arial'; //ohne das geht es nicht!!!
                TextOutAngle(DrawBmp.Canvas, Pos - (ITW div 2), VPos + FXAxis.MainTickLen + ITL, S,  900);
                DrawBmp.Canvas.Font := FFonts.AxisScale;
              end else
                DrawBmp.Canvas.TextOut(Pos - (ITW div 2), VPos + FXAxis.MainTickLen, S); //waagrechte Achsskalierung
            end;

            if FXAxis.ShowMainGrid then
            begin
              DrawBmp.Canvas.Pen.Color := FColors.MainGridColor;
              DrawBmp.Canvas.MoveTo(Pos, FPositions.YAxisTop);
              DrawBmp.Canvas.LineTo(Pos, Height - FPositions.YAxisBottom);
              DrawBmp.Canvas.Pen.Color := FColors.FTickColor;
            end;
          end;
        end;
      except
      end;
    end else
    begin //klassische Achsenbeschriftung
      if FXAxis.Pan > 0 then
      begin
        if FXAxis.PanSubTicks >= FXAxis.SubTicks then
        begin
          FXAxis.Pan:=FXAxis.Pan - Round(FXAxis.PanSubTicks * FXAxis.PixelsPerSubTick);
          FXAxis.PanSubTicks:=0;
          FXAxis.SetMinMax(FXAxis.Min - FXAxis.ValuePerMainTick,
                           FXAxis.Max - FXAxis.ValuePerMainTick);
        end;
        for X:=-FXAxis.PanSubTicks to FXAxis.Ticks - FXAxis.PanSubTicks do
        begin
          Pos:= Positions.XGraphLeft + FPositions.XAxisLeft + Round(FXAxis.FPixelsPerSubTick * X) + FXAxis.Pan;
          if (Pos >= Positions.XGraphLeft + FPositions.XAxisLeft) and (Pos <= Width - FPositions.XAxisRight) then
          begin
            DrawBmp.Canvas.MoveTo(Pos,VPos);
            if X mod FXAxis.SubTicks = 0 then
            begin
              DrawBmp.Canvas.LineTo(Pos,VPos + FXAxis.MainTickLen);

              if Length(FXAxis.MainTicksText) > Y then //BG260906: Neu: Freie Texte
                S := FXAxis.MainTicksText[Y].sText
              else
                S:=FloatToStrF(FXAxis.Min + (Y * FXAxis.ValuePerMainTick),ffFixed,7,FXAxis.Decimals);

              for I:=1 to Length(S) do
              if S[I] = ' ' then Delete(S,I,1);
              I:=DrawBmp.Canvas.TextWidth(S);
              if FXAxis.FShowScale then
                DrawBmp.Canvas.TextOut(Pos - I div 2,VPos + FXAxis.MainTickLen,S);

              if FXAxis.ShowMainGrid then
              begin
                DrawBmp.Canvas.Pen.Color:=FColors.MainGridColor;
                DrawBmp.Canvas.MoveTo(Pos,FPositions.YAxisTop);
                DrawBmp.Canvas.LineTo(Pos,Height - FPositions.YAxisBottom);
                DrawBmp.Canvas.Pen.Color:=FColors.FTickColor;
              end;
            end
            else
            begin
              DrawBmp.Canvas.LineTo(Pos,VPos + FXAxis.SubTickLen);
              if FXAxis.ShowSubGrid then
              begin
                DrawBmp.Canvas.Pen.Color:=FColors.SubGridColor;
                DrawBmp.Canvas.MoveTo(Pos,FPositions.YAxisTop);
                DrawBmp.Canvas.LineTo(Pos,Height - FPositions.YAxisBottom);
                DrawBmp.Canvas.Pen.Color:=FColors.FTickColor;
              end;
            end;
          end;
          if X mod FXAxis.SubTicks = 0 then Inc(Y);
        end;
      end
      else
      begin
        if FXAxis.PanSubTicks <= -FXAxis.SubTicks then
        begin
          FXAxis.Pan:=FXAxis.Pan - Round(FXAxis.PanSubTicks * FXAxis.PixelsPerSubTick);
          FXAxis.PanSubTicks:=0;
          FXAxis.SetMinMax(FXAxis.Min + FXAxis.ValuePerMainTick,
                           FXAxis.Max + FXAxis.ValuePerMainTick);
        end;
        for X:=FXAxis.Ticks - FXAxis.PanSubTicks downto 0 - FXAxis.PanSubTicks do
        begin
          Pos:= Positions.XGraphLeft + FPositions.XAxisLeft + Round(FXAxis.FPixelsPerSubTick * X) + FXAxis.Pan;
          if (Pos >= Positions.XGraphLeft + FPositions.XAxisLeft) and (Pos <= Width - FPositions.XAxisRight) then
          begin
            DrawBmp.Canvas.MoveTo(Pos,VPos);
            if X mod FXAxis.SubTicks = 0 then
            begin
              DrawBmp.Canvas.LineTo(Pos,VPos + FXAxis.MainTickLen);

              if Length(FXAxis.MainTicksText) > Y then
              begin //BG260906: Neu: Freie Texte
                S := FXAxis.MainTicksText[Y].sText;
              end else
                S := FloatToStrF(FXAxis.Max - (Y * FXAxis.ValuePerMainTick),ffFixed,7,FXAxis.Decimals);

              for I:=1 to Length(S) do if S[I] = ' ' then Delete(S,I,1);
              I:=DrawBmp.Canvas.TextWidth(S);
              if FXAxis.FShowScale then
                DrawBmp.Canvas.TextOut(Pos - I div 2,VPos + FXAxis.MainTickLen,S);
              if FXAxis.ShowMainGrid then
              begin
                DrawBmp.Canvas.Pen.Color:=FColors.MainGridColor;
                DrawBmp.Canvas.MoveTo(Pos,FPositions.YAxisTop);
                DrawBmp.Canvas.LineTo(Pos,Height - FPositions.YAxisBottom);
                DrawBmp.Canvas.Pen.Color:=FColors.FTickColor;
              end;
            end
            else
            begin
              DrawBmp.Canvas.LineTo(Pos,VPos + FXAxis.SubTickLen);
              if FXAxis.ShowSubGrid then
              begin
                DrawBmp.Canvas.Pen.Color:=FColors.SubGridColor;
                DrawBmp.Canvas.MoveTo(Pos,FPositions.YAxisTop);
                DrawBmp.Canvas.LineTo(Pos,Height - FPositions.YAxisBottom);
                DrawBmp.Canvas.Pen.Color:=FColors.FTickColor;
              end;
            end;
          end;
          if X mod FXAxis.SubTicks = 0 then Inc(Y);
        end;
      end;
    end;
  end;

  DrawBmp.Canvas.Pen.Color:=FColors.GraphBkGnd;
  DrawBmp.Canvas.MoveTo(Positions.XGraphLeft+FPositions.XAxisLeft,VPos);
  DrawBmp.Canvas.LineTo(Width - FPositions.XAxisRight,VPos);
  DrawBmp.Canvas.MoveTo(Positions.XGraphLeft+FPositions.XAxisLeft,FPositions.YAxisTop);
  DrawBmp.Canvas.LineTo(Width - FPositions.XAxisRight,FPositions.YAxisTop);

  I:=DrawBmp.Canvas.TextWidth(XAxis.Title);
  X:=Positions.XGraphLeft+FPositions.XAxisLeft + XAxis.Length div 2 - I div 2;
  DrawBmp.Canvas.Font:=FFonts.AxisTitle;
  if Length(XAxis.Title) > 0 then
    DrawBmp.Canvas.TextOut(X,Height - FPositions.FXAxisTitle,XAxis.Title);
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.DrawYAxis;
var
  I,H,X,Y, k, ITW: Integer;
  Pos: Integer;
  S: string;  //25.02.12 md  [12];
  Y1, YSpan, P_Exp, P_Mul, P_Act: Double;
  Decade, StartLoop : integer;
  dx, dy, Fx1, Fy2 : integer;
  dMaxEnd: Double;
  RastScl      : array [0..10] of word;  { Teilungspunkte für log Skalierung }
begin
  DrawBmp.Canvas.Font:=FFonts.AxisScale;
  DrawBmp.Canvas.Pen.Color:=FColors.FTickColor;
  DrawBmp.Canvas.Pen.Style := psDot;
  H:=DrawBmp.Canvas.TextHeight('0');
  Y:=0;
  try
    FYAxis.PanSubTicks:=Round(FYAxis.Pan / FYAxis.PixelsPerSubTick)
  except
    FYAxis.PanSubTicks:=1;
  end;
  if FYAxis.Log then
  begin //BG261006: Neu: logarithmische Achsen
    //Bei Log gibt es vorerst keinen Pan oder Zoom!!!!
    //MainTicks und SubTicks werden ignoriert
    FYAxis.Pan := 0;
    if FYAxis.Min < 1E-3 then
      FYAxis.Min := 1E-3;
    Y1 := FYAxis.Min;
    try
      YSpan := ln(FYAxis.FMax) - ln (FYAxis.FMin);                            //Der Span
      P_Exp := GET_EXP (FYAxis.FMin);                                         //Exponent des Startwertes bilden
      Decade := succ (abs ((trunc (GET_EXP (FYAxis.FMax) - P_Exp))));         //Anzahl der Dekaden im Span

      Fx1 := FPositions.FXGraphLeft + FPositions.FXAxisLeft;                  //Obere linke Ecke des Gitters in Pixeln
      Fy2 := Height - FPositions.FYAxisBottom;                                //untere rechte Ecke des Grids

      StartLoop := round (FYAxis.FMin / exp (P_Exp * cLg_Ln) + 0.4);          //Wo ist der erste Eintrag im Array zu finden
      if StartLoop = 0 then
        StartLoop := 1;                                                       //Sicherheitshalber eine Begrenzung für den Zugriff auf das Array

      for i := 0 to 10 do
        RastScl[i] := i;
      for i := 0 to Decade do
      begin
        P_Mul := exp ((P_Exp + pred (i)) * cLg_Ln);                           //Exponent gemäß Decade anpassen
        for k := StartLoop to pred(FYAxis.FMainTicks) do
        begin
          P_Act := RastScl [k] * P_Mul;
          if FYAxis.FMax > 1E18 then
            dMaxEnd := FYAxis.FMax+1E14
          else
            if FYAxis.FMax > 1E15 then
              dMaxEnd := FYAxis.FMax+1E10
            else
              if FYAxis.FMax > 1E10 then
                dMaxEnd := FYAxis.FMax+1E5
              else
                if FYAxis.FMax > 1E5 then
                  dMaxEnd := FYAxis.FMax+1E2
                else
                  dMaxEnd := FYAxis.FMax+1;
          if (P_Act <= dMaxEnd) and (k = 1) then //k=1 nur 0.1, 1, 10, 100, 1000, ...
          begin
            dy := round (ln (P_Act / FYAxis.FMin) / YSpan * YAxis.Length);
            Pos := Fy2 - dy;
            if P_Act > 1E3 then
              s := FloatToStrF (P_Act, ffExponent, 4, FYAxis.Decimals)
            else
              s := FloatToStrF (P_Act, ffNumber, 4, FYAxis.Decimals);
            ITW := DrawBmp.Canvas.TextWidth(Trim(S));
            if FYAxis.ShowMainGrid then
            begin
              DrawBmp.Canvas.Pen.Color := FColors.MainGridColor;
              DrawBmp.Canvas.MoveTo(Positions.XGraphLeft+FPositions.XAxisLeft, Pos);
              DrawBmp.Canvas.LineTo(Width - FPositions.XAxisRight, Pos);
              DrawBmp.Canvas.TextOut (Positions.XGraphLeft+FPositions.XAxisLeft - FYAxis.MainTickLen - ITW, Pos - (H div 2), S);
            end;
          end;
        end;
        StartLoop := 1;                                                       //Ab jetzt immer am Anfang beginnen
      end;
    except
    end;
  end else
  begin //lineare Achse
    if FYAxis.Pan > 0 then
    begin
      if FYAxis.PanSubTicks >= FYAxis.SubTicks then
      begin
        FYAxis.Pan:=FYAxis.Pan - Round(FYAxis.PanSubTicks * FYAxis.PixelsPerSubTick);
        FYAxis.PanSubTicks:=0;
        FYAxis.SetMinMax(FYAxis.Min - FYAxis.ValuePerMainTick,
                         FYAxis.Max - FYAxis.ValuePerMainTick);
      end;
      for X:=-FYAxis.PanSubTicks to FYAxis.Ticks - FYAxis.PanSubTicks do
      begin
        if FXAxis.Log then
        begin
          try
            Pos:=Height - FPositions.YAxisBottom - Round(FYAxis.FPixelsPerSubTick * ln(X)) - FYAxis.Pan;
          except
            Pos:=0;
          end;
        end else
          Pos:=Height - FPositions.YAxisBottom - Round(FYAxis.FPixelsPerSubTick * X) - FYAxis.Pan;
        if (Pos >= FPositions.YAxisTop) and (Pos <= Height - FPositions.YAxisBottom) then
        begin
          DrawBmp.Canvas.MoveTo(Positions.XGraphLeft + FPositions.XAxisLeft, Pos);
          if X mod FYAxis.SubTicks = 0 then
          begin
            DrawBmp.Canvas.LineTo(Positions.XGraphLeft + FPositions.XAxisLeft - FYAxis.MainTickLen, Pos);
            S:=FloatToStrF(FYAxis.Min + (Y * FYAxis.ValuePerMainTick),ffFixed,7,FYAxis.Decimals);
            for I:=1 to Length(S) do
            if S[I] = ' ' then Delete(S,I,1);
            I:=DrawBmp.Canvas.TextWidth(S);
            if FYAxis.FShowScale then
              DrawBmp.Canvas.TextOut(Positions.XGraphLeft + FPositions.XAxisLeft - FYAxis.MainTickLen - I, Pos - (H div 2),S);
            if (FYAxis.ShowMainGrid) and
               (Pos <> FPositions.YAxisTop) and
               (Pos <> Height - FPositions.YAxisBottom) then
            begin
              DrawBmp.Canvas.Pen.Color:=FColors.MainGridColor;
              DrawBmp.Canvas.MoveTo(Positions.XGraphLeft + FPositions.XAxisLeft, Pos);
              DrawBmp.Canvas.LineTo(Width - FPositions.XAxisRight,Pos);
              DrawBmp.Canvas.Pen.Color:=FColors.FTickColor;
            end;
          end
          else
          begin
            DrawBmp.Canvas.LineTo(Positions.XGraphLeft + FPositions.XAxisLeft - FYAxis.SubTickLen, Pos);
            if FYAxis.ShowSubGrid then
            begin
              DrawBmp.Canvas.Pen.Color := FColors.SubGridColor;
              DrawBmp.Canvas.MoveTo(Positions.XGraphLeft + FPositions.XAxisLeft, Pos);
              DrawBmp.Canvas.LineTo(Width - FPositions.XAxisRight,Pos);
              DrawBmp.Canvas.Pen.Color:=FColors.FTickColor;
            end;
          end;
        end;
        if X mod FYAxis.SubTicks = 0 then Inc(Y);
      end;
    end
    else
    begin
      if FYAxis.PanSubTicks <= -FYAxis.SubTicks then
      begin
        FYAxis.Pan:=FYAxis.Pan - Round(FYAxis.PanSubTicks * FYAxis.PixelsPerSubTick);
        FYAxis.PanSubTicks:=0;
        FYAxis.SetMinMax(FYAxis.Min + FYAxis.ValuePerMainTick,
                         FYAxis.Max + FYAxis.ValuePerMainTick);
      end;
      for X:=FYAxis.Ticks - FYAxis.PanSubTicks downto 0 - FYAxis.PanSubTicks do
      begin
        if FXAxis.Log then
        begin
          try
            Pos:=Height - FPositions.YAxisBottom - Round(FYAxis.FPixelsPerSubTick * ln(X)) - FYAxis.Pan;
          except
            Pos:=0;
          end;
        end else
          Pos:=Height - FPositions.YAxisBottom - Round(FYAxis.FPixelsPerSubTick * X) - FYAxis.Pan;
        if (Pos >= FPositions.YAxisTop) and (Pos <= Height - FPositions.YAxisBottom) then
        begin
          DrawBmp.Canvas.MoveTo(Positions.XGraphLeft + FPositions.XAxisLeft, Pos);
          if X mod FYAxis.SubTicks = 0 then
          begin
            DrawBmp.Canvas.LineTo(Positions.XGraphLeft + FPositions.XAxisLeft - FYAxis.MainTickLen, Pos);
            S:=FloatToStrF(FYAxis.Max - (Y * FYAxis.ValuePerMainTick),ffFixed,7,FYAxis.Decimals);
            for I:=1 to Length(S) do
            if S[I] = ' ' then Delete(S,I,1);
            I:=DrawBmp.Canvas.TextWidth(S);
            if FYAxis.FShowScale then
              DrawBmp.Canvas.TextOut(Positions.XGraphLeft + FPositions.XAxisLeft - FYAxis.MainTickLen - I, Pos - H div 2, S);
            if (FYAxis.ShowMainGrid) and
               (Pos <> FPositions.YAxisTop) and
               (Pos <> Height - FPositions.YAxisBottom) then
            begin
              DrawBmp.Canvas.Pen.Color:=FColors.MainGridColor;
              DrawBmp.Canvas.MoveTo(Positions.XGraphLeft + FPositions.XAxisLeft, Pos);
              DrawBmp.Canvas.LineTo(Width - FPositions.XAxisRight,Pos);
              DrawBmp.Canvas.Pen.Color:=FColors.FTickColor;
            end;
          end
          else
          begin
            DrawBmp.Canvas.LineTo(Positions.XGraphLeft + FPositions.XAxisLeft - FYAxis.SubTickLen, Pos);
            if FYAxis.ShowSubGrid then
            begin
              DrawBmp.Canvas.Pen.Color:=FColors.SubGridColor;
              DrawBmp.Canvas.MoveTo(Positions.XGraphLeft + FPositions.XAxisLeft, Pos);
              DrawBmp.Canvas.LineTo(Width - FPositions.XAxisRight, Pos);
              DrawBmp.Canvas.Pen.Color:=FColors.FTickColor;
            end;
          end;
        end;
        if X mod FYAxis.SubTicks = 0 then Inc(Y);
      end;
    end;
  end;
  DrawBmp.Canvas.Pen.Color:=FColors.GraphBkGnd;
  DrawBmp.Canvas.MoveTo(Positions.XGraphLeft + FPositions.XAxisLeft, Height - FPositions.YAxisBottom);
  DrawBmp.Canvas.LineTo(Positions.XGraphLeft + FPositions.XAxisLeft, FPositions.YAxisTop - 1);
  DrawBmp.Canvas.MoveTo(Width - FPositions.XAxisRight,Height - FPositions.YAxisBottom);
  DrawBmp.Canvas.LineTo(Width - FPositions.XAxisRight,FPositions.YAxisTop - 1);

  I:=DrawBmp.Canvas.TextWidth(YAxis.Title);
  Y:=Height - FPositions.YAxisBottom - YAxis.Length div 2 + I div 2;
  DrawBmp.Canvas.Font:=FFonts.AxisTitle;
  if Length(YAxis.Title) > 0 then
    TextOutRotate(DrawBmp.Canvas,FPositions.FXGraphLeft + FPositions.FYAxisTitle, Y, 900, YAxis.Title);
end;
{------------------------------------------------------------------------------}

function TXYGraph.DrawCurveTitles: integer;
//BG290906: Neu
//BG091107: Um CheckBoxes erweitert
//BG160810: Um Min Max erweitert
var
  iGroup, iCrv, iPos: integer;
  yB1: integer;
  y3, x4, x5: integer;
  sName: string;
  {--------------------------}
  function SetCurveGroupBox: integer;
  begin
    Result := 0;  //Compiler
    y3 := YB1 +
          (2 * ciCurveTitlesRandTop) +
          (ciCurveTitelsHeader) +
          (iPos  * ciCurveTitlesHeight);
    sName := 'chbCurveGroup_' + IntToStr(iGroup);
    if TCheckBox(FindComponent(sName)) = nil then
    begin //Mehrfacherzeugen verhindern
      sbCurveTitles.VertScrollBar.Position := 0; //das verhindert dass Phantom-ChkBoxen nach unten "erfunden" werden
      with FCurveGroup.CheckBox do
      begin
        Parent := sbCurveTitles;
        OnClick := BtnCurveGroupCheckBoxClicked;
        Name := sName;
        Visible := true;
        Height := 15;
        Width  := 15;
        Left   := x4;
        Top    := y3 - (Height div 2) - 5;
      end;
    end;
    inc(iPos);
  end;
  {--------------------------}
  function SetCurveBox: integer;
  begin
    Result := 0;  //Compiler
    y3 := YB1 +
          (2 * ciCurveTitlesRandTop) +
          (ciCurveTitelsHeader) +
          (iPos  * ciCurveTitlesHeight);
    sName := 'chbCurve_' + IntToStr(iCrv);
    if TCheckBox(FindComponent(sName)) = nil then
    begin //Mehrfacherzeugen verhindern
      sbCurveTitles.VertScrollBar.Position := 0; //das verhindert dass Phantom-ChkBoxen nach unten "erfunden" werden
      with FCurve.CheckBox do
      begin
        Parent := sbCurveTitles;
        OnClick := BtnCurveCheckBoxClicked;
        Name := sName;
        Visible := true;
        Height := 15;
        Width  := 15;
        Left   := x5;
        Top    := y3 - (Height div 2) - 5;
      end;
    end;
    inc(iPos);
  end;
  {--------------------------}
begin
  Result := 0;  //Compiler
  if bShowCurveTitles then
  begin
    //BG270508: Neu: In ScrollBox malen, damit auch viele Kurven korrekt angezeigt werden
    sbCurveTitles.Left := 2;
    sbCurveTitles.Top := ciCurveTitlesHeight + ciCurveTitelsHeader;
    sbCurveTitles.Width := CurveTitleBar.Width-4;
    sbCurveTitles.Height := CurveTitleBar.Height - ciCurveTitlesHeight - ciCurveTitelsHeader;

    sbCurveTitles.Color := Colors.AxisBkGnd;
    PBCurveTitles.Width := sbCurveTitles.Width - 21; //abzüglich Schieberbreite
    PBCurveTitles.Height := (2 * ciCurveTitlesRandTop) +
                            (ciCurveTitelsHeader) +
                            (FCurveGroupList.Count * ciCurveTitlesCurveHeight) +
                            (FCurveList.Count * ciCurveTitlesHeight) ;
    iPos := 0;
    YB1 := 0;
    if FCurveGroupList.Count > 0 then
    begin
      x4 := ciCurveTitlesX4CG;
      x5 := ciCurveTitlesX5CG;
      for iGroup := 0 to FCurveGroupList.Count-1 do
      begin
        FCurveGroup := FCurveGroupList.Items[iGroup];
        SetCurveGroupBox;
        for iCrv := 0 to FCurveList.Count-1 do
        begin
          FCurve := FCurveList.Items[ICrv];
          if FCurve.CurveGroup = iGroup then
            SetCurveBox;
        end;
      end;
    end else
    begin
      x5 := ciCurveTitlesX5C;
      for iCrv := 0 to FCurveList.Count-1 do
      begin
        FCurve := FCurveList.Items[ICrv];
        SetCurveBox;
      end;
    end;
  end;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.PaintCurveTitles(Sender: TObject);
const
  ciCBWidth = 8;
  ciLineWidth = 12;
  ciCurveNameWidth = 60;
var
  iGroup, iCrv, iPos: integer;
  xB1, yB1: integer;
  x3, y3, x4, x5, x10, x11: integer;
  s: string;
  {--------------------------}
  procedure PaintCurveTitle;
  begin
    x5 := XB1 + (ciCurveTitlesRandLeft); //Beginn Checkbox
    x3 := x5 + ciCBWidth + ciCurveTitlesRandLeft; //Beginn Line

    x4 := x3 + ciLineWidth + ciCurveTitlesRandLeft; //Beginn Text
    y3 := YB1 +
          (2 * ciCurveTitlesRandTop) +
          (ciCurveTitelsHeader) +
          (iPos  * ciCurveTitlesHeight);

    x10 := x4 + ciCurveNameWidth; //Beginn Min
    x11 := x10 + ciCurveNameWidth; //Beginn Min

    PBCurveTitles.Canvas.Pen.Width := 1;
    PBCurveTitles.Canvas.Brush.Color := FCurve.Color;

    if FCurveGroupList.Count > 0 then
      x3 := 2 + 10 //Beginn Line
    else
      x3 := 2;
    //x4 := PBCurveTitles.Width;
    if FCurve.Color = sbCurveTitles.Color then //BG270508: Bei gleich Farben Rechteck dahinter malen
      PBCurveTitles.Canvas.Pen.Color := clSilver
    else
      PBCurveTitles.Canvas.Pen.Color := FCurve.Color;
    PBCurveTitles.Canvas.Rectangle(x3, y3-1, PBCurveTitles.Width-4, y3+1);

    PBCurveTitles.Canvas.Brush.Color := sbCurveTitles.Color; //Hintergrund normal malen
    PBCurveTitles.Canvas.Font.Style := PBCurveTitles.Canvas.Font.Style - [fsBold];
    PBCurveTitles.Canvas.TextOut(x4 + ciCurveTitlesRandLeft, y3 - (PBCurveTitles.Canvas.TextHeight(FCurve.Name) div 2) - 8, FCurve.Name);

    if XYToolBar.Expanded then
    begin
      if FCurve.FMinY < MaxDouble/2 then
      { TODO -obg : limits stimmen nicht }
      begin
        S := FloatToStrF(FCurve.FMinY, ffFixed, 7, FYAxis.Decimals);
        PBCurveTitles.Canvas.TextOut(x10 + ciCurveTitlesRandLeft, y3 - (PBCurveTitles.Canvas.TextHeight(FCurve.Name) div 2) - 8, S);
      end;
      if FCurve.FMaxY > MinDouble then
      begin
        S := FloatToStrF(FCurve.FMaxY, ffFixed, 7, FYAxis.Decimals);
        PBCurveTitles.Canvas.TextOut(x11 + ciCurveTitlesRandLeft, y3 - (PBCurveTitles.Canvas.TextHeight(FCurve.Name) div 2) - 8, S);
      end;
    end;
    inc(iPos);
  end;
  {--------------------------}
  procedure PaintCurveGroupTitle;
  begin
    x5 := XB1 + (ciCurveTitlesRandLeft); //Beginn Checkbox
    x3 := x5 + ciCBWidth + ciCurveTitlesRandLeft; //Beginn Line

    x4 := x3; //Beginn Text
    y3 := YB1 +
          (2 * ciCurveTitlesRandTop) +
          (ciCurveTitelsHeader) +
          (iPos  * ciCurveTitlesHeight) - 3; //+4
    PBCurveTitles.Canvas.Pen.Width := 1;
    PBCurveTitles.Canvas.Brush.Color := sbCurveTitles.Color; //Hintergrund normal malen
    PBCurveTitles.Canvas.Font.Style := PBCurveTitles.Canvas.Font.Style + [fsBold];
    if FCurve <> nil then
      PBCurveTitles.Canvas.TextOut(x4 + ciCurveTitlesRandLeft, y3 - (PBCurveTitles.Canvas.TextHeight(FCurve.Name) div 2) - 8, FCurveGroup.Name);

    inc(iPos);
  end;
  {--------------------------}
begin
  if bShowCurveTitles then
  begin
    PBCurveTitles.Canvas.Font := FFonts.AxisTitle;
    PBCurveTitles.Canvas.Font.Style := PBCurveTitles.Canvas.Font.Style + [fsBold];
    PBCurveTitles.Canvas.Font.Color := Fonts.FAxisScale.Color;
    //rechts von der Grafik ausgerichtet
    xB1 := 0;
    yB1 := 0;
    PBCurveTitles.Canvas.Pen.Color := FColors.SubGridColor;
    PBCurveTitles.Canvas.Pen.Style := psSolid;

    //xB1 := 2;
    //yB1 := //(2 * ciCurveTitlesRand) +
    //       //(ciCurveTitelsHeader) -
    //       (ciCurveTitlesCurveHeight div 2) - 3;
    //PBCurveTitles.Canvas.TextOut(xB1, yB1, 'Legende');

    PBCurveTitles.Canvas.Pen.Color := FColors.SubGridColor;
    PBCurveTitles.Canvas.Pen.Style := psSolid;

    if XYToolBar.Expanded then
    begin
      x5 := XB1 + (ciCurveTitlesRandLeft); //Beginn Checkbox
      x3 := x5 + ciCBWidth + ciCurveTitlesRandLeft; //Beginn Line

      x4 := x3 + ciLineWidth + ciCurveTitlesRandLeft; //Beginn Text
      y3 := YB1 +
            (2 * ciCurveTitlesRandTop) +
            (ciCurveTitelsHeader);
      x10 := x4 + ciCurveNameWidth; //Beginn Min
      x11 := x10 + ciCurveNameWidth; //Beginn Min
      y3 := YB1 +
            (2 * ciCurveTitlesRandTop) +
            10;
      PBCurveTitles.Canvas.Font.Style := PBCurveTitles.Canvas.Font.Style + [fsBold];
      PBCurveTitles.Canvas.TextOut(x10 + ciCurveTitlesRandLeft, y3 - (PBCurveTitles.Canvas.TextHeight(FCurve.Name) div 2) - 4, 'Min');
      PBCurveTitles.Canvas.TextOut(x11 + ciCurveTitlesRandLeft, y3 - (PBCurveTitles.Canvas.TextHeight(FCurve.Name) div 2) - 4, 'Max');
    end;


    PBCurveTitles.Canvas.Font.Style := PBCurveTitles.Canvas.Font.Style - [fsBold];
    PBCurveTitles.Canvas.Font.Color := Fonts.FAxisScale.Color;

    xB1 := 0; //linke Randlinie
    yB1 := 0; //obere Randlinie
    iPos := 0;

    if FCurveGroupList.Count > 0 then
    begin
      for iGroup := 0 to FCurveGroupList.Count-1 do
      begin
        FCurveGroup := FCurveGroupList.Items[iGroup];
        PaintCurveGroupTitle;
        for iCrv := 0 to FCurveList.Count-1 do
        begin
          FCurve := FCurveList.Items[ICrv];
          if FCurve.CurveGroup = iGroup then
            PaintCurveTitle;
        end;
      end;
    end else
    begin
      for iCrv := 0 to FCurveList.Count-1 do
      begin
        FCurve := FCurveList.Items[ICrv];
        PaintCurveTitle;
      end;
    end;
  end;
end;
{------------------------------------------------------------------------------}

function TXYGraph.GetMaxPoints: Integer;
var
  I,Max: Integer;
begin
  Max:=0;
  for I:=0 to Pred(FCurveList.Count) do
  begin
    FCurve:=FCurveList.Items[I];
    if FCurve.FPoints.Count > Max then Max:=FCurve.FPoints.Count;
  end;
  Result:=Max;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.SetEditEnable(Value: Boolean);
begin
  if Assigned(FControls.XOut) then FControls.XOut.Enabled:=Value;
  if Assigned(FControls.YOut) then FControls.YOut.Enabled:=Value;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.OutMode(const Mode: Str32);
begin
  if Assigned(FControls.FMode) then
  begin
    if (FControls.FMode is TPanel) then TPanel(FControls.FMode).Caption:=Mode;
    if (TObject(FControls.FMode) is TStatusPanel) then TStatusPanel(FControls.FMode).Text:=Mode;
    if (FControls.FMode is TLabel) then TLabel(FControls.FMode).Caption:=Mode;
    if (FControls.FMode is TStaticText) then TStaticText(FControls.FMode).Caption:=Mode;
  end;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.OutCurve(const Curve: Str32);
begin
  if Assigned(FControls.FCurve) then
  begin
    if (FControls.FCurve is TPanel) then TPanel(FControls.FCurve).Caption:=Curve;
    if (TObject(FControls.FCurve) is TStatusPanel) then TStatusPanel(FControls.FCurve).Text:=Curve;
    if (FControls.FCurve is TLabel) then TLabel(FControls.FCurve).Caption:=Curve;
    if (FControls.FCurve is TStaticText) then TStaticText(FControls.FCurve).Caption:=Curve;
  end;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.OutItem(Item: Integer);
var
  Text: Str32;
begin
  if Item > -1 then Text:=IntToStr(Item) else Text:='';
  if Assigned(FControls.FItem) then
  begin
    if (FControls.FItem is TPanel) then TPanel(FControls.FItem).Caption:=Text;
    if (TObject(FControls.FItem) is TStatusPanel) then TStatusPanel(FControls.FItem).Text:=Text;
    if (FControls.FItem is TLabel) then TLabel(FControls.FItem).Caption:=Text;
    if (FControls.FItem is TStaticText) then TStaticText(FControls.FItem).Caption:=Text;
  end;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.OutColor(Color: TColor);
begin
  if Assigned(FControls.FColor) then
  begin
    if (FControls.FColor is TPanel) then TPanel(FControls.FColor).Color:=Color;
    if (FControls.FColor is TLabel) then TLabel(FControls.FColor).Color:=Color;
    if (FControls.FColor is TStaticText) then TStaticText(FControls.FColor).Color:=Color;
  end;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.OutXY(Fx,Fy: TFloat);
var
  Sx,Sy: Str32;
begin
  Sx:=FloatToStrF(Fx,ffFixed,7,3);
  Sy:=FloatToStrF(Fy,ffFixed,7,3);

  if Assigned(FControls.FXOut) then
  begin
    if (FControls.FXOut is TEdit) then TEdit(FControls.FXOut).Text:=Sx;
    if (FControls.FXOut is TPanel) then TPanel(FControls.FXOut).Caption:=Sx;
    if (TObject(FControls.FXOut) is TStatusPanel) then TStatusPanel(FControls.FXOut).Text:=Sx;
    if (FControls.FXOut is TLabel) then TLabel(FControls.FXOut).Caption:=Sx;
    if (FControls.FXOut is TStaticText) then TStaticText(FControls.FXOut).Caption:=Sx;
  end;

  if Assigned(FControls.FYOut) then
  begin
    if (FControls.FYOut is TEdit) then TEdit(FControls.FYOut).Text:=Sy;
    if (FControls.FYOut is TPanel) then TPanel(FControls.FYOut).Caption:=Sy;
    if (TObject(FControls.FYOut) is TStatusPanel) then TStatusPanel(FControls.FYOut).Text:=Sy;
    if (FControls.FYOut is TLabel) then TLabel(FControls.FYOut).Caption:=Sy;
    if (FControls.FYOut is TStaticText) then TStaticText(FControls.FYOut).Caption:=Sy;
  end;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.OutAngle(A: TFloat);
var
  Sa: Str32;
begin
  if Assigned(FControls.FAngle) then
  begin
    if A > 9.9E16 then Sa:='' else Sa:=FloatToStrF(A,ffFixed,7,3);
    if (FControls.FAngle is TPanel) then TPanel(FControls.FAngle).Caption:=Sa;
    if (TObject(FControls.FAngle) is TStatusPanel) then TStatusPanel(FControls.FAngle).Text:=Sa;
    if (FControls.FAngle is TLabel) then TLabel(FControls.FAngle).Caption:=Sa;
    if (FControls.FAngle is TStaticText) then TStaticText(FControls.FAngle).Caption:=Sa;
  end;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.DoPan(Dx,Dy: Integer);
begin
  //DX := 0;
  if not PanCurves then
  begin
    OutMode('Pan: Graph');
    SetEditEnable(False);
    if Dx <> 0 then FXAxis.Pan:=FXAxis.Pan + Dx;
    if Dy <> 0 then FYAxis.Pan:=FYAxis.Pan - Dy;
    paint;
  end
  else
  begin
    OutMode('Pan: Curves');
    SetEditEnable(True);
    ChangeCurveOfs(Dx * FXAxis.FValuePerPixel,-Dy * FYAxis.FValuePerPixel,True);
  end;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.DoZoom(Dx,Dy: Integer);
var
  AXDif,AYDif: TFloat;
  XDif,YDif: TFloat;
  ZFx,ZFy: TFloat;
  Factor: TFloat;
  XStep,YStep: TFloat;
begin
  AXDif:=FXAxis.FMax - FXAxis.FMin;
  AYDif:=FYAxis.FMax - FYAxis.FMin;
  XDif:=FXAxis.FMaxSave - FXAxis.FMinSave;
  YDif:=FYAxis.FMaxSave - FYAxis.FMinSave;

  ZFx:=1.0;
  ZFy:=1.0;
  if AXDif <> 0.0 then ZFx:=XDif / AXDif;
  if AYDif <> 0.0 then ZFy:=YDif / AYDif;

  // neu BG
  if bZoomRun then
  begin
    FXAxis.Zoom := ZFx;
    FYAxis.Zoom := ZFy;
    FXAxis.CalcAxis;
    FYAxis.CalcAxis;
//    DoPan(0,0);
//    DoPan(round (FXAxis.FMin), round (FYAxis.FMin));
    paint;
  end else
  begin
    XStep:=0.0;
    YStep:=0.0;

    if Dx > 0 then XStep:=-0.02
    else if Dx < 0 then XStep:=0.02;
    if Dy > 0 then YStep:=-0.02
    else if Dy < 0 then YStep:=0.02;

    if ZoomAspectRatio then
    begin
      OutMode('Zoom: Aspect');
      OutXY(ZFx,ZFx);
      Factor:=FXAxis.Zoom + XStep;
      if ((Factor < 1) and (ZFx < FMaxZoom)) or
         ((Factor > 1) and (ZFx > 1 / FMaxZoom)) then
      begin
        FXAxis.SetZoom(Factor);
        FYAxis.SetZoom(Factor);
        paint;
      end;
    end
    else
    begin
      OutMode('Zoom: Free');
      OutXY(ZFx,ZFy);
      Factor:=FXAxis.Zoom + XStep;
      if ((Factor < 1) and (ZFx < FMaxZoom)) or
         ((Factor > 1) and (ZFx > 1 / FMaxZoom)) then FXAxis.SetZoom(Factor);
      Factor:=FXAxis.Zoom - YStep;
      if ((Factor < 1) and (ZFy < FMaxZoom)) or
         ((Factor > 1) and (ZFy > 1 / FMaxZoom)) then FYAxis.SetZoom(Factor);
      paint;
    end;
  end;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.DoMouse(X,Y: Integer);
begin
  if FMode = gmCursor then OutMode('Mouse: Cursor')
    else OutMode('Mouse: Position');
  OutXY(XAxis.Value(X - Positions.XGraphLeft - Positions.XAxisLeft),
        YAxis.Value(Height - Y - Positions.YAxisBottom));
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.SetMeasureCursor(X,Y: Integer);
begin
  ClearMarkBox;
  OutMode('Mouse: Cursor');
  OutXY(0,0);
  ClearMarkBox;
  CPMatch:=False;
  CPx:=XAxis.Value(X - Positions.XGraphLeft - Positions.XAxisLeft);
  CPy:=YAxis.Value(Height - Y - Positions.YAxisBottom);
  DrawMarkBox;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.DoMeasureCursor(X,Y: Integer);
begin
  OutXY(XAxis.Value(X - Positions.XGraphLeft - Positions.XAxisLeft) - CPx,
        YAxis.Value(Height - Y - Positions.YAxisBottom) - CPy);
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.DoMove(Dx,Dy: Integer);
begin
  if CPMatch then
  begin
    CPx:=CPx + Dx * FXAxis.ValuePerPixel;
    CPy:=CPy - Dy * FYAxis.ValuePerPixel;
    ChangePoint(CPCurve,CPIndex,CPx,CPy);
    OutXY(CPx,CPy);
    OutMode('Edit: Move');
    paint;
  end;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.DoCheckCP(X,Y: Integer);
//BG100908: Nur "vernünftige" x,y akzepieren
var
  Fx,Fy: TFloat;
begin
  if (x >= 0) and (x < 10000) and
     (y >= 0) and (y < 10000) then
  begin
    CheckCurvePoints(X - Positions.XGraphLeft - Positions.XAxisLeft,Height - Y - Positions.YAxisBottom);
    if CPMatch then
    begin
      if ((LastCPCurve <> CPCurve) or (LastCPIndex <> CPIndex)) then
      begin
        OutXY(CPx,CPy);
        FCurve:=FCurveList.Items[CPCurve];
        OutCurve(FCurve.Name);
        OutItem(CPIndex);
        OutColor(FCurve.Color);
        LastCPCurve:=CPCurve;
        LastCPIndex:=CPIndex;
        if CPIndex < Pred(FCurve.FPoints.Count) then
        begin
          GetPoint(CPCurve,Succ(CPIndex),Fx,Fy);
          if Assigned(FControls.FAngle) then OutAngle(Angle(CPx,CPy,Fx,Fy));
        end;
      end;
    end
    else if not CPMatch then
    begin
      OutCurve('');
      OutItem(-1);
      OutColor(FColors.FGraphBkGnd);
      OutAngle(9.9E18);
      LastCPCurve:=-1;
      LastCPIndex:=-1;
    end;
  end;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.DblClicked(Sender: TObject);
begin
  Reset;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.MouseDown(Button: TMouseButton; Shift: TShiftState; X,Y: Integer);
var
  uRect : TRect;
begin
  MouseXReal := XAxis.Value(X - Positions.XGraphLeft - Positions.XAxisLeft);
  MouseYReal := YAxis.Value(Height - Y - Positions.YAxisBottom);

  inherited MouseDown(Button,Shift,X,Y);

  MouseX:=X;
  MouseY:=Y;

  if Button = mbLeft then
  begin
    if (XYToolBar.BtnPanSmall.Down) and (XYToolBar.BtnPanSmall.Visible) then //???
    begin
      if not CPMatch then DoPan(0,0) else DoMouse(X,Y);
      case FMode of
        gmMove: DoMove(0,0);
        gmInsert: if CPMatch then
                  begin
                    GetPoint(CPCurve,CPIndex,CPx,CPy);
                    CPx:=XAxis.Value(X - Positions.XGraphLeft - Positions.XAxisLeft);
                    CPy:=YAxis.Value(Height - Y - Positions.YAxisBottom);
                    InsertPoint(CPCurve,CPIndex,CPx,CPy);
                    paint;
                  end;
        gmDelete: if CPMatch then
                  begin
                    DeletePoint(CPCurve,CPIndex);
                    paint;
                  end;
        gmCursor: SetMeasureCursor(X,Y);
      end;
    end;

    {
    if (MarkerBar.btnMarkerVert1.Down) then
    begin
      MovVertMkrToPnt (x, AbsMkr);
    end;
    }

    if (MarkerBar.BtnAbsMkrSmall.Down) and (AbsMkr.bActive) and (AbsMkr.bVisible) then
    begin
      MovMkrToPnt (x, AbsMkr);
    end;
    if (MarkerBar.BtnRelMkrSmall.Down) and (RelMkr.bActive) and (RelMkr.bVisible)  then
    begin
      MovMkrToPnt (x, RelMkr);
    end;
  end
  else if Button = mbRight then
  begin
    if (not YAxis.Log) and (not XAxis.Log) then
    begin
      // neu BG
      bZoomRun := true;
      OrgPnt.x := x; //Startpunkt des Zooms merken
      OrgPnt.y := y;
      MovPnt.x := x;
      MovPnt.y := y;

      uRect.Top    := Positions.YAxisTop; //BG130606: geändert
      uRect.Left   := Positions.XGraphLeft + Positions.XAxisLeft;
      uRect.Right  := Width - Positions.XAxisRight;
      uRect.Bottom := Height - Positions.YAxisBottom;

      uRect.TopLeft := ClientToScreen (uRect.TopLeft);
      uRect.BottomRight := ClientToScreen (uRect.BottomRight);
      pGridRect^ := uRect;
      pClipRect := pGridRect;
      ClipCursor (pClipRect); //der Cursor wird auf den Grafikbereich eingeschränkt
    end;
  end;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.MouseMove(Shift: TShiftState; X,Y: Integer);
var
  Dx,Dy: Integer;
begin
  inherited MouseMove(Shift,X,Y);

  if csDesigning in ComponentState then exit;

  Dx := X - MouseX;
  Dy := Y - MouseY;

  Freeze:=ssShift in Shift;

  if ssLeft in Shift then
  begin
    if XYToolBar.BtnPanSmall.Down then
    begin
      if not CPMatch then DoPan(Dx,Dy);
      case FMode of
        gmMove: DoMove(Dx,Dy);
        gmCursor: DoMeasureCursor(X,Y);
      end;
    end;

    {
    if (MarkerBar.btnMarkerVert1.Down) then
    begin
      MovVertMkrToPnt (x, AbsMkr);
    end;
    }

    if (MarkerBar.BtnAbsMkrSmall.Down) and (AbsMkr.bActive) and (AbsMkr.bVisible) then
    begin
      MovMkrToPnt (x, AbsMkr);
    end;
    if (MarkerBar.BtnRelMkrSmall.Down) and (RelMkr.bActive) and (RelMkr.bVisible)  then
    begin
      MovMkrToPnt (x, RelMkr);
    end;
  end
  else
  begin
    if ssRight in Shift then
    begin
      if bZoomRun then with Canvas do
      begin
        if (not YAxis.Log) and (not XAxis.Log) then
        begin
          HideMkrs;
          Pen.Mode := pmNotXOR;
          Pen.Style := psDash;
          Pen.Color := clBlack;
          MoveTo (OrgPnt.x, OrgPnt.y); Lineto (MovPnt.x, OrgPnt.y);
          Lineto (MovPnt.x, MovPnt.y); Lineto (OrgPnt.x, MovPnt.y); Lineto (OrgPnt.x, OrgPnt.y);
          MovPnt.x := x; // Bewegung der Maus merken
          MovPnt.y := y;
          MoveTo (OrgPnt.x, OrgPnt.y); Lineto (MovPnt.x, OrgPnt.y);
          Lineto (MovPnt.x, MovPnt.y); Lineto (OrgPnt.x, MovPnt.y); Lineto (OrgPnt.x, OrgPnt.y);
          Pen.Mode := pmCopy;
        end;
      end;
      //DoZoom(Dx,Dy)
    end else
    begin
      if (FMode <> gmNone) and (FMode <> gmCursor) then DoCheckCP(X,Y);
      if FMode = gmCursor then DoMeasureCursor(X,Y)
      else if (FMode = gmNone) and (LastCPIndex > -1) then DoCheckCP(MaxInt,MaxInt)
      else if not CPMatch then DoMouse(X,Y);
    end;
  end;

  if not PanCurves and (FMode = gmMove) then SetEditEnable(CPMatch)
    else if PanCurves then SetEditEnable(True);


  WriteFreeText (X, Y);

  MouseX := X;
  MouseY := Y;
end;

{------------------------------------------------------------------------------}

procedure TXYGraph.MouseUp(Button: TMouseButton; Shift: TShiftState; X,Y: Integer);
var
  FMinDiffX, FMinDiffY : Double;
 {---------------------------}
  procedure Sort_Pnt (var Val1, Val2 :integer);
  //nach Grösse sortieren
  var
    ValDummy : integer;
  begin
    if Val1 > Val2 then
    begin
      ValDummy := Val1;
      Val1 := Val2;
      Val2 := ValDummy;
    end;
  end;
 {---------------------------}
begin
  inherited MouseUp(Button,Shift,X,Y);

  //neu BG
  if (Button = mbRight) and bZoomRun then with Canvas do
  begin //am Zoomende den Ausschnitt berechnen, Cursorbegrenzung freigeben
    if (not YAxis.Log) and (not XAxis.Log) then
    begin
      pClipRect := nil;
      ClipCursor (pClipRect);                                                     //Cursor darf sich wieder überall bewegen
      Pen.Mode := pmNotXOR; Pen.Style := psDash; Pen.Color := clBlack;
      MoveTo (OrgPnt.x, OrgPnt.y); Lineto (MovPnt.x, OrgPnt.y);
      Lineto (MovPnt.x, MovPnt.y); Lineto (OrgPnt.x, MovPnt.y); Lineto (OrgPnt.x, OrgPnt.y);
      MovPnt.x := x; MovPnt.y := y;
      Pen.Mode := pmCopy;
      if (abs (OrgPnt.x - MovPnt.x) > 5) and
         (abs (OrgPnt.y - MovPnt.y) > 4) then
      begin
        Sort_Pnt (OrgPnt.x, MovPnt.x); Sort_Pnt (MovPnt.y, OrgPnt.y); //Sortierte Grenzen bilden, bei y mit Absicht vertauscht

        FMinDiffX := FXAxis.FMin - FXAxis.FMinSave;
        FXAxis.FMin := (FXAxis.ValuePerPixel * (OrgPnt.x - Positions.XGraphLeft - Positions.XAxisLeft - FXAxis.FPan)) + FMinDiffX + FXAxis.FMinSave; //neue absolute linke untere Ecke
        FXAxis.FMax := (FXAxis.ValuePerPixel * (MovPnt.x - Positions.XGraphLeft - Positions.XAxisLeft - FXAxis.FPan)) + FMinDiffX + FXAxis.FMinSave;

        FMinDiffY := FYAxis.FMin - FYAxis.FMinSave;
        FYAxis.FMin := (FYAxis.ValuePerPixel * (Height - OrgPnt.y - Positions.YAxisBottom + FYAxis.FPan)) + FMinDiffY + FYAxis.FMinSave;
        FYAxis.FMax := (FYAxis.ValuePerPixel * (Height - MovPnt.y - Positions.YAxisBottom + FYAxis.FPan)) + FMinDiffY + FYAxis.FMinSave;

        DoZoom(0,0);
        ShowMkrs;
      end else
      begin
        //MessageDlg ('Der Zoombereich ist zu klein gewählt!', mtInformation, [mbOk], 0);
      end;
      bZoomRun := false;
    end;
  end;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.SetGraphTitle(const Value: Str32);
begin
  if Value <> FGraphTitle then
  begin
    FGraphTitle:=Value;
    paint;
  end;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.Reset;
begin
  FXAxis.FZoom:=1.0;
  FYAxis.FZoom:=1.0;
  FXAxis.FPan:=0;
  FYAxis.FPan:=0;
  FXAxis.FMin:=FXAxis.FMinSave;
  FXAxis.FMax:=FXAxis.FMaxSave;
  FYAxis.FMin:=FYAxis.FMinSave;
  FYAxis.FMax:=FYAxis.FMaxSave;
  FXAxis.CalcAxis;
  FYAxis.CalcAxis;
  Zoom:=ZoomSave;
  paint;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.ZoomOut;
//Zoom um den Faktor 2 verkleinern
var
  FXAxisDiff : Double;
  FYAxisDiff : Double;
begin
  {
  FXAxis.FZoom:=FXAxis.FZoom / 2;
  if FXAxis.FZoom < 1 then FXAxis.FZoom := 1.0;
  FYAxis.FZoom:=FYAxis.FZoom / 2;
  if FYAxis.FZoom < 1 then FYAxis.FZoom := 1.0;
  FXAxis.FPan:=FXAxis.FPan div 2;
  FYAxis.FPan:=FYAxis.FPan div 2;
  if FXAxis.FPan < 0 then FXAxis.FPan := 0;
  if FYAxis.FPan < 0 then FYAxis.FPan := 0;
  }

  FXAxisDiff := (FXAxis.FMax - FXAxis.FMin) * 2.0; //die Breite verdoppeln
  if FXAxisDiff > (FXAxis.FMaxSave - FXAxis.FMinSave) then
  begin //Reset
    FXAxis.FZoom := 1.0;
    FXAxis.FPan  := 0;
    FXAxis.FMin  := FXAxis.FMinSave;
    FXAxis.FMax  := FXAxis.FMaxSave;
    Zoom:=ZoomSave;
  end else
  begin //Ausschnitt verdoppeln
    FXAxis.FMin := FXAxis.FMin - FXAxisDiff/4;
    if FXAxis.FMin < FXAxis.FMinSave then
    begin
      FXAxis.FMin := FXAxis.FMinSave;
      FXAxis.FPan:=0;
    end;
    FXAxis.FMax := FXAxis.FMin + FXAxisDiff;
    if FXAxis.FMax > FXAxis.FMaxSave then
    begin
      FXAxis.FMax := FXAxis.FMaxSave;
      FXAxis.FMin := FXAxis.FMaxSave - FXAxisDiff;
    end;
  end;
  FXAxis.CalcAxis;

  FYAxisDiff := (FYAxis.FMax - FYAxis.FMin) * 2.0;
  if FYAxisDiff > (FYAxis.FMaxSave - FYAxis.FMinSave) then
  begin //Reset
    FYAxis.FZoom := 1.0;
    FYAxis.FPan  := 0;
    FYAxis.FMin  := FYAxis.FMinSave;
    FYAxis.FMax  := FYAxis.FMaxSave;
    Zoom:=ZoomSave;
  end else
  begin
    FYAxis.FMin := FYAxis.FMin - FYAxisDiff/4;
    if FYAxis.FMin < FYAxis.FMinSave then FYAxis.FMin := FYAxis.FMinSave;
    FYAxis.FMax := FYAxis.FMin + FYAxisDiff;
    if FYAxis.FMax > FYAxis.FMaxSave then
    begin
      FYAxis.FMax := FYAxis.FMaxSave;
      FYAxis.FMin := FYAxis.FMinSave;
    end;
  end;
  FYAxis.CalcAxis;
  paint;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.ZoomIn;
//Zoom um den Faktor 2 vergrößern
var
  FXAxisDiff : Double;
  FYAxisDiff : Double;
begin
  FXAxisDiff := (FXAxis.FMax - FXAxis.FMin) / 2.0; //die Breite verdoppeln
  if FXAxisDiff > (FXAxis.FMaxSave - FXAxis.FMinSave) then
  begin //Reset
    FXAxis.FZoom := 1.0;
    FXAxis.FPan  := 0;
    FXAxis.FMin  := FXAxis.FMinSave;
    FXAxis.FMax  := FXAxis.FMaxSave;
    Zoom:=ZoomSave;
  end else
  begin //Ausschnitt halbieren
    FXAxis.FMin := FXAxis.FMin + FXAxisDiff/2;
    if FXAxis.FMin < FXAxis.FMinSave then
    begin
      FXAxis.FMin := FXAxis.FMinSave;
      FXAxis.FPan:=0;
    end;
    FXAxis.FMax := FXAxis.FMin + FXAxisDiff;
    if FXAxis.FMax > FXAxis.FMaxSave then
    begin
      FXAxis.FMax := FXAxis.FMaxSave;
      FXAxis.FMin := FXAxis.FMaxSave - FXAxisDiff;
    end;
  end;
  FXAxis.CalcAxis;

  FYAxisDiff := (FYAxis.FMax - FYAxis.FMin) / 2.0;
  if FYAxisDiff > (FYAxis.FMaxSave - FYAxis.FMinSave) then
  begin //Reset
    FYAxis.FZoom := 1.0;
    FYAxis.FPan  := 0;
    FYAxis.FMin  := FYAxis.FMinSave;
    FYAxis.FMax  := FYAxis.FMaxSave;
    Zoom:=ZoomSave;
  end else
  begin
    FYAxis.FMin := FYAxis.FMin + FYAxisDiff/2;
    if FYAxis.FMin < FYAxis.FMinSave then FYAxis.FMin := FYAxis.FMinSave;
    FYAxis.FMax := FYAxis.FMin + FYAxisDiff;
    if FYAxis.FMax > FYAxis.FMaxSave then
    begin
      FYAxis.FMax := FYAxis.FMaxSave;
      FYAxis.FMin := FYAxis.FMinSave;
    end;
  end;
  FYAxis.CalcAxis;
  paint;
end;
{------------------------------------------------------------------------------}

function TXYGraph.MakeCurve(const AName: Str32; AColor: TColor; ALineWidth: Byte;
                            APenStyle: TPenStyle; AEnabled: Boolean; APos, ACurveGroup : integer): Integer;
var
  S: Str32;
begin
  S:=AName;
  {beware BG220902 das kostet bei vielen Kurven immens Zeit!!!
  while GetCurveHandle(S,H) do
  begin
    Inc(N);
    S:=AName + IntToStr(N);
  end;
  }
  FCurve:=TCurve.Create(Self);
  FCurve.Owner := Self;
  FCurve.Name:=S;
  FCurve.Color:=AColor;
  FCurve.LineWidth:=ALineWidth;
  FCurve.PenStyle:=APenStyle;
  FCurve.Enabled:=AEnabled;
  FCurve.CurveGroup := aCurveGroup;
  if (aPos < 0) or (aPos > FCurveList.Count) then
    FCurveList.Add(FCurve)
  else
    FCurveList.Insert(aPos, FCurve);
  Result:=FCurveList.IndexOf(FCurve);
  if Assigned(FControls.FCurveListBox) then
  begin
    FControls.FCurveListBox.Items.Add(S);
    FControls.FCurveListBox.Checked[Pred(FControls.FCurveListBox.Items.Count)]:=AEnabled;
  end;
  if Assigned(FControls.FPanListBox) then
  begin
    FControls.FPanListBox.Items.Add(S);
    FControls.FPanListBox.Checked[Pred(FControls.FPanListBox.Items.Count)]:=False;
  end;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.DeleteCurve(AItem: Integer);
begin
  try
    if (AItem < FCurveList.Count) and
       (AItem > -1) then //BG170308: Neu
    begin
      FCurve:=FCurveList.Items[AItem];
      if FCurve <> nil then //BG170308: Neu
        FCurveList.Delete(AItem);

      FCurve.Free; //BG
      FCurve := nil; //BG
    end;
  except

  end;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.DeleteCurveGroup(AItem: Integer);
begin
  try
    if (AItem < FCurveGroupList.Count) and
       (AItem > -1) then
    begin
      FCurveGroup := FCurveGroupList.Items[AItem];
      if FCurveGroup <> nil then
        FCurveGroupList.Delete(AItem);

      FCurveGroup.Free;
      FCurveGroup := nil;
    end;
  except

  end;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.DeleteAllCurves;
begin
  try
    while FCurveList.Count > 0 do
      DeleteCurve(0);
  finally
    FCurveList.Clear; //BG 210103
    FCurveList.Capacity := 0;
  end;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.DeleteAllCurveGroups;
begin
  try
    while FCurveGroupList.Count > 0 do
      DeleteCurveGroup(0);
  finally
    FCurveGroupList.Clear;
    FCurveGroupList.Capacity := 0;
  end;
end;
{------------------------------------------------------------------------------}

function TXYGraph.GetCurveHandle(AName: Str32; var H: Integer): Boolean;
var
  I,J: Integer;
begin
  H:=-1;
  J:=FCurveList.Count;
  I:=0;
  AName:=AnsiUpperCase(AName);
  while I < J do
  begin
    FCurve:=FCurveList.Items[I];
    if AnsiUpperCase(FCurve.Name) = AName then
    begin
      H:=I;
      Break;
    end;
    Inc(I);
  end;
  Result:=I < J;
end;
{------------------------------------------------------------------------------}

function TXYGraph.GetCurveName(H: Integer): Str32;
begin
  Result:='';
  if (H < 0) or (H > Pred(FCurveList.Count)) then Exit;
  FCurve:=FCurveList.Items[H];
  Result:=FCurve.Name;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.ChangePoint(AIndex,APosition: Integer; X,Y: TFloat);
begin
  if InRange(AIndex,0,Pred(FCurveList.Count)) then
  begin
    FCurve:=FCurveList.Items[AIndex];
    if APosition < FCurve.FPoints.Count then FCurve.ChangePoint(APosition,X,Y);
  end;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.GetPoint(AIndex,APosition: Integer; var X,Y: TFloat);
begin
  if InRange(AIndex,0,Pred(FCurveList.Count)) then
  begin
    FCurve:=FCurveList.Items[AIndex];
    if InRange(APosition,0,Pred(FCurve.FPoints.Count)) then
      FCurve.GetPoint(APosition,X,Y);
  end;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.AddPoint(AIndex: Integer; X,Y: TFloat);
begin
  if fAddNoPoints then exit;
  if InRange(AIndex,0,Pred(FCurveList.Count)) then
  begin
    FCurve:=FCurveList.Items[AIndex];
    if (X > -4E10324) and (X < 1E10308) and
       (Y > -4E10324) and (Y < 1E10308) then //BG270407: Neu
      FCurve.AddPoint(X,Y);
  end;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.AddPointColor(AIndex: Integer; X,Y: TFloat; Col: TColor); //BG280103
begin
  if fAddNoPoints then exit;
  if InRange(AIndex,0,Pred(FCurveList.Count)) then
  begin
    FCurve:=FCurveList.Items[AIndex];
    FCurve.AddPointColor(X,Y,Col);
  end;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.SetBrushColor(AIndex: Integer; aColor: TColor);
begin
  if InRange(AIndex,0,Pred(FCurveList.Count)) then
  begin
    FCurve:=FCurveList.Items[AIndex];
    FCurve.BrushColor := aColor;
  end;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.AddPointText(AIndex: Integer; X,Y: TFloat;Text: String); //BG120203
begin
  if fAddNoPoints then exit;
  if InRange(AIndex,0,Pred(FCurveList.Count)) then
  begin
    FCurve:=FCurveList.Items[AIndex];
    FCurve.AddPointText(X,Y,Text);
  end;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.AddPointTextColor(AIndex: Integer; X,Y: TFloat;Text: String; Col: TColor);
begin
  if fAddNoPoints then exit;
  if InRange(AIndex,0,Pred(FCurveList.Count)) then
  begin
    FCurve := FCurveList.Items[AIndex];
    FCurve.AddPointTextColor(X,Y,Text,Col);
  end;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.AddBreakPoint(AIndex, APointIndex: Integer);
begin
  if (InRange(AIndex,0,Pred(FCurveList.Count))) and
     (APointIndex > 1) then
  begin
    FCurve := FCurveList.Items[AIndex];
//    if APointIndex < Pred(FCurve.FPoints.Count) then
      FCurve.AddBreakPoint(APointIndex);
  end;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.AddMark(AIndex,APosition: Integer; AMarkType: TMarkType; AColor: TColor);
begin
  if InRange(AIndex,0,Pred(FCurveList.Count)) then
  begin
    FCurve:=FCurveList.Items[AIndex];
    FCurve.AddMark(APosition,AMarkType,AColor);
  end;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.SetMarkSize(AIndex: Integer; AMarkSize: TMarkSize);
begin
  if InRange(AIndex,0,Pred(FCurveList.Count)) then
  begin
    FCurve:=FCurveList.Items[AIndex];
    FCurve.FMarkSize:=AMarkSize;
  end;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.AddText(AIndex,APosition,AXOfs,AYOfs: Integer; const AText: Str32; AColor: TColor);
begin
  if InRange(AIndex,0,Pred(FCurveList.Count)) then
  begin
    FCurve:=FCurveList.Items[AIndex];
    FCurve.AddText(APosition,AXOfs,AYOfs,AText,AColor);
  end;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.SetCurveFont(AIndex: Integer; AName: TFontName; ASize: Integer; AStyle: TFontStyles);
begin
  if InRange(AIndex,0,Pred(FCurveList.Count)) then
  begin
    FCurve:=FCurveList.Items[AIndex];
    FCurve.FFont.Name:=AName;
    FCurve.FFont.Size:=ASize;
    FCurve.FFont.Style:=AStyle;
  end;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.InsertPoint(AIndex,APosition: Integer; X,Y: TFloat);
begin
  if InRange(AIndex,0,Pred(FCurveList.Count)) then
  begin
    FCurve:=FCurveList.Items[AIndex];
    FCurve.InsertPoint(APosition,X,Y);
  end;
end;
 {------------------------------------------------------------------------------}

procedure TXYGraph.DeletePoint(AIndex,APosition: Integer);
begin
  if InRange(AIndex,0,Pred(FCurveList.Count)) then
  begin
    FCurve:=FCurveList.Items[AIndex];
    FCurve.DeletePoint(APosition);
  end;

end;
{------------------------------------------------------------------------------}

procedure TXYGraph.DeleteAllCurvePoints(AIndex: Integer);
begin
  if AIndex < FCurveList.Count then
  try
    FCurve:=FCurveList.Items[AIndex];
    //while FCurve.FPoints.Count > 0 do
    //  DeletePoint(AIndex, 0);

    //exit;

    { BG200303 beware
    with FCurve do
    begin
      for I:=Pred(FPoints.Count) downto 0 do FreeMem(FPoints.Items[I],SizeOf(TPointRec));
      for I:=Pred(FTexts.Count)  downto 0 do FreeMem(FTexts.Items[I],SizeOf(TTextRec));
      for I:=Pred(FMarks.Count)  downto 0 do FreeMem(FMarks.Items[I],SizeOf(TMarkRec));
    end;
    }
    while FCurve.FPoints.Count > 0 do
      FCurve.DeletePoint(0);

  except
  end;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.DeleteAllCurvesCurvePoints;
//BG101107: Neu: Alle Kurvenpunkte auf allen Kurven löschen
var
  iCrv: integer;
begin
  for iCrv := 0 to FCurveList.Count-1 do
    DeleteAllCurvePoints(iCrv);
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.SetXOfs(AIndex: Integer; AOfs: TFloat);
begin
  if InRange(AIndex,0,Pred(FCurveList.Count)) then
  begin
    FCurve:=FCurveList.Items[AIndex];
    FCurve.XOfs:=AOfs;
    paint;
  end;
end;
{------------------------------------------------------------------------------}

function TXYGraph.GetXOfs(AIndex: Integer): TFloat;
begin
  if InRange(AIndex,0,Pred(FCurveList.Count)) then
  begin
    FCurve:=FCurveList.Items[AIndex];
    Result:=FCurve.XOfs;
  end
  else Result:=0;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.SetYOfs(AIndex: Integer; AOfs: TFloat);
begin
  if InRange(AIndex,0,Pred(FCurveList.Count)) then
  begin
    FCurve:=FCurveList.Items[AIndex];
    FCurve.YOfs:=AOfs;
    paint;
  end;
end;
{------------------------------------------------------------------------------}

function TXYGraph.GetYOfs(AIndex: Integer): TFloat;
begin
  if InRange(AIndex,0,Pred(FCurveList.Count)) then
  begin
    FCurve:=FCurveList.Items[AIndex];
    Result:=FCurve.YOfs;
  end
  else Result:=0;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.SetCurveEnabled(AIndex: Integer; Value: Boolean);
begin
  if InRange(AIndex,0,Pred(FCurveList.Count)) then
  begin
    FCurve:=FCurveList.Items[AIndex];
    FCurve.Enabled:=Value;
  end;
end;
{------------------------------------------------------------------------------}

{------------------------------------------------------------------------------}
procedure TXYGraph.SetCurveStyle(AIndex, AValue: Integer);
begin
  if InRange(AIndex,0,Pred(FCurveList.Count)) then
  begin
    FCurve:=FCurveList.Items[AIndex];
    FCurve.CurveStyle:=AValue;
  end;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.SetCurveColor(AIndex: Integer; Value: TColor);
begin
  if InRange(AIndex,0,Pred(FCurveList.Count)) then
  begin
    FCurve:=FCurveList.Items[AIndex];
    FCurve.Color:=Value;
  end;
end;
{------------------------------------------------------------------------------}

function TXYGraph.GetCurveEnabled(AIndex: Integer): Boolean;
begin
  Result := false;  //Compiler
  if InRange(AIndex,0,Pred(FCurveList.Count)) then
  begin
    FCurve:=FCurveList.Items[AIndex];
    Result := FCurve.Enabled;
  end;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.SetZoom(Value: TFloat);
begin
  if (Value <= FMaxZoom) and (Value >= 1 / FMaxZoom) then
  begin
    FZoom:=Value;
    XAxis.SetZoom(FZoom);
    YAxis.SetZoom(FZoom);
    paint;
  end;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.ClearMarkBox;
begin
  if Assigned(CPBmp) then
  begin
    Canvas.CopyRect(CPRect,CPBmp.Canvas,Rect(0,0,8,8));
    CPBmp.Free;
    CPBmp:=nil;
  end;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.DrawMarkBox;
var
  I,J: Integer;
begin
  if Assigned(CPBmp) then ClearMarkBox;
  I:=FPositions.FXGraphLeft + Positions.XGraphLeft + FPositions.FXAxisLeft + FXAxis.Pixel(CPx);
  J:=Height - Positions.YAxisBottom - FYAxis.Pixel(CPy);
  CPRect:=Rect(I - 3,J - 3,I + 4,J + 4);
  CPBmp:=TBitMap.Create;
  CPBmp.Width:=8;
  CPBmp.Height:=8;
  CPBmp.Canvas.CopyRect(Rect(0,0,8,8),Canvas,CPRect);
  Canvas.Pen.Color:=clWhite;
  Canvas.Brush.Color:=clWhite;
  HClip:=CreateRectRgn(Positions.XGraphLeft + Positions.XAxisLeft,Positions.YAxisTop,
                       Width - Positions.XAxisRight,Height - Positions.YAxisBottom);
  SelectClipRgn(Canvas.Handle,HClip);

  if FMode = gmCursor then
  begin
    Canvas.MoveTo(CPRect.Left + 1,CPRect.Top + 1);
    Canvas.LineTo(CPRect.Right,CPRect.Bottom);
    Canvas.MoveTo(CPRect.Right - 1,CPRect.Top + 1);
    Canvas.LineTo(CPRect.Left,CPRect.Bottom);
  end
  else Canvas.FrameRect(CPRect);

  DeleteObject(HClip);
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.DrawMark(ACanvas: TCanvas; MarkType: TMarkType;
                            MarkColor: TColor; MarkSize: TMarkSize; X,Y: Integer);
begin
  ACanvas.Pen.Color:=MarkColor;
  ACanvas.Brush.Style:=bsClear;
  case MarkType of
    mtBox: begin
             ACanvas.MoveTo(X - MarkSize,Y - MarkSize);
             ACanvas.LineTo(X + MarkSize,Y - MarkSize);
             ACanvas.LineTo(X + MarkSize,Y + MarkSize);
             ACanvas.LineTo(X - MarkSize,Y + MarkSize);
             ACanvas.LineTo(X - MarkSize,Y - MarkSize);
           end;
    mtCircle: ACanvas.Ellipse(X - MarkSize,Y - MarkSize,X + MarkSize + 2,Y + MarkSize + 2);
    mtCross: begin
               ACanvas.MoveTo(X - MarkSize + 1,Y - MarkSize + 1);
               ACanvas.LineTo(X + MarkSize,Y + MarkSize);
               ACanvas.MoveTo(X + MarkSize - 1,Y - MarkSize + 1);
               ACanvas.LineTo(X - MarkSize,Y + MarkSize);
             end;
  end;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.CheckCurvePoints(X,Y: Integer);
var
  I,J,K,L: Integer;
  Px,Py,Lx,Ly,Dx,Dy,MaxXDif,MaxYDif: TFloat;
begin
  ClearMarkBox;
  if not Freeze or (Freeze and not CPMatch) then
  begin
    Px:=FXAxis.Value(X);
    Py:=FYAxis.Value(Y);

    MaxXDif:=10 * FXAxis.FValuePerPixel;
    MaxYDif:=10 * FYAxis.FValuePerPixel;

    CPMatch:=False;
    J:=Pred(FCurveList.Count);
    for I:=0 to J do
    begin
      FCurve:=FCurveList.Items[I];
      if FCurve.FEnabled then
      begin
        K:=Pred(FCurve.FPoints.Count);
        for L:=0 to K do
        begin
          GetPoint(I,L,Lx,Ly);
          Dx:=Abs(Px - Lx);
          Dy:=Abs(Py - Ly);
          if not CPMatch then
          begin
            CPMatch:=(Dx < MaxXDif) and (Dy < MaxYDif);
            if CPMatch then
            begin
              CPx:=Lx;
              CPy:=Ly;
              CPCurve:=I;
              CPIndex:=L;
            end;
          end
          else
          begin
            if (Dx < Abs(Px - CPx)) and (Dy < MaxYDif) or
               (Dy < Abs(Py - CPy)) and (Dx < MaxXDif) then
            begin
              CPx:=Lx;
              CPy:=Ly;
              CPCurve:=I;
              CPIndex:=L;
            end;
          end;
        end;
      end;
    end;
  end;
  if CPMatch then DrawMarkBox;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.ShowHintPanel(Show: Boolean);
begin
  FHintPanel.Visible:=Show;
  if Assigned(FControls.FHintPanel) then FControls.FHintPanel.Checked:=Show;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.ChangeCPx(Fx: TFloat);
begin
  if (FMode = gmMove) and CPMatch then
  begin
    GetPoint(CPCurve,CPIndex,CPx,CPy);
    ChangePoint(CPCurve,CPIndex,Fx,CPy);
    CPx:=Fx;
    OutXY(CPx,CPy);
    paint;
  end;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.ChangeCPy(Fy: TFloat);
begin
  if (FMode = gmMove) and CPMatch then
  begin
    GetPoint(CPCurve,CPIndex,CPx,CPy);
    ChangePoint(CPCurve,CPIndex,CPx,Fy);
    CPy:=Fy;
    OutXY(CPx,CPy);
    paint;
  end;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.ChangeCurveOfs(Ox,Oy: TFloat; Relative: Boolean);
var
  N: Integer;
begin
  if Assigned(FControls.FPanListBox) then
    for N:=0 to Pred(FControls.FPanListBox.Items.Count) do
  begin
    if FControls.FPanListBox.Checked[N] then
    begin
      FCurve:=FCurveList.Items[N];
      if FCurve.FEnabled then
      begin
        if Relative then
        begin
          if Ox > -9.99E15 then SetXOfs(N,GetXOfs(N) + Ox);
          if Oy > -9.99E15 then SetYOfs(N,GetYOfs(N) + Oy);
        end
        else
        begin
          if Ox > -9.99E15 then SetXOfs(N,Ox);
          if Oy > -9.99E15 then SetYOfs(N,Oy);
        end;
        OutXY(GetXOfs(N),GetYOfs(N));
      end;
    end;
  end;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.GetCPInfo(var CPMatch: Boolean; var CPCurve,CPIndex: Integer);
begin
  CPMatch:=CPMatch;
  CPCurve:=CPCurve;
  CPIndex:=CPIndex;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.DoXEditExit(Sender: TObject);
var
  F: TFloat;
begin
  if not AtoF(TEdit(FControls.FXIn).Text,F) then Exit;
  ChangeCPx(F);
  ChangeCurveOfs(F,-9.9E16,False);
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.DoYEditExit(Sender: TObject);
var
  F: TFloat;
begin
  if not AtoF(TEdit(FControls.FYIn).Text,F) then Exit;
  ChangeCPy(F);
  ChangeCurveOfs(-9.9E16,F,False);
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.TextOutAngle(const aCanvas: TCanvas; X, Y: Integer; const AText: String; AAngle: Integer);
//0 = hor
//450 = 45 Grad
//900 = senkrecht
//1800 = kopfüber
var
  hCurFont: HFONT;
  LogFont: TLogFont;
begin
  with aCanvas do
  begin
    hCurFont := Font.Handle;
    try
      GetObject(Font.Handle, SizeOf(LogFont), @LogFont);
      LogFont.lfEscapement := AAngle;
      LogFont.lfOrientation := AAngle;

      Font.Handle:= CreateFontIndirect(LogFont);
      try
        TextOut(X, Y, AText);
      finally
        DeleteObject(Font.Handle);
      end;
    finally
      Font.Handle := hCurFont;
    end;
  end;
end;
{------------------------------------------------------------------------------}

function TXYGraph.AddGroup(const AName: Str32; AEnabled: Boolean; IPos : integer): Integer;
//BG240810: Neu
//Kurven zu Gruppen zusammenfassen
var
  S: Str32;
begin
  S := AName;
  FCurveGroup := TCurveGroup.Create(Self);
  FCurveGroup.Owner := Self;
  FCurveGroup.Name := S;
  FCurveGroup.Enabled := AEnabled;
  if (iPos < 0) or (iPos > FCurveGroupList.Count) then
    FCurveGroupList.Add(FCurveGroup)
  else
    FCurveGroupList.Insert(iPos, FCurveGroup);
  Result := FCurveGroupList.IndexOf(FCurveGroup);
  if Assigned(FControls.FCurveGroupListBox) then
  begin
    FControls.FCurveGroupListBox.Items.Add(S);
    FControls.FCurveGroupListBox.Checked[Pred(FControls.FCurveGroupListBox.Items.Count)]:=AEnabled;
  end;
  if Assigned(FControls.FPanListBox) then
  begin
    FControls.FPanListBox.Items.Add(S);
    FControls.FPanListBox.Checked[Pred(FControls.FPanListBox.Items.Count)]:=False;
  end;
end;
{------------------------------------------------------------------------------}

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}

constructor THintPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Graph:=TXYGraph(AOwner);
  FStrings:=TStringList.Create;
  FStrings.OnChange:=DoStringsChange;
  SetBounds(5,5,0,0);
  Cursor:=crHandPoint;
  Moving:=False;
  Start:=True;
end;
{------------------------------------------------------------------------------}

destructor THintPanel.Destroy;
begin
  FStrings.Free;
  inherited Destroy;
end;
{------------------------------------------------------------------------------}

procedure THintPanel.Loaded;
begin
  inherited Loaded;
  Canvas.Font.Name:='MS Sans Serif';
  Canvas.Font.Size:=8;
  Canvas.Font.Color:=clBlack;
end;
{------------------------------------------------------------------------------}

procedure THintPanel.NewBounds;
var
  H,I,J,L,N,W: Integer;
begin
  J:=0;
  N:=0;
  if FStrings.Count > 0 then
  begin
    for I:=0 to Pred(FStrings.Count) do
    begin
      L:=Canvas.TextWidth(FStrings.Strings[I]);
      if L > J then J:=L;
      if Length(FStrings.Strings[I]) > 0 then Inc(N);
    end;

    H:=14 * N + 4;
    W:=J + 4;

    if (N > 0) and (N <= MaxHintLines) then
    begin
      Width:=W + 4;
      Height:=H;
    end;
  end;
end;
{------------------------------------------------------------------------------}

procedure THintPanel.DoStringsChange(Sender: TObject);
begin
  NewBounds;
end;
{------------------------------------------------------------------------------}

procedure THintPanel.MouseDown(Button: TMouseButton; Shift: TShiftState; X,Y: Integer);
begin
  inherited MouseDown(Button,Shift,X,Y);
  Anchors:=[];
  MouseX:=X;
  MouseY:=Y;
  Graph.ClearMarkBox;
  Graph.CPMatch:=False;
  Moving:=True;
end;
{------------------------------------------------------------------------------}

procedure THintPanel.MouseMove(Shift: TShiftState; X,Y: Integer);
var
  Dx,Dy: Integer;
begin
  inherited MouseMove(Shift,X,Y);
  if ssLeft in Shift then
  begin
    Dx:=X - MouseX;
    Dy:=Y - MouseY;
    SetBounds(Left + Dx,Top + Dy,Width,Height);
  end;
end;
{------------------------------------------------------------------------------}

procedure THintPanel.MouseUp(Button: TMouseButton; Shift: TShiftState; X,Y: Integer);
begin
  inherited MouseUp(Button,Shift,X,Y);
  Anchors:=[akRight,akTop];
  Moving:=False;
end;
{------------------------------------------------------------------------------}

procedure THintPanel.Paint;
var
  I,L,N: Integer;
begin
  inherited Paint;

  if Start then Start:=False;

  if FStrings.Count > 0 then
  begin
    N:=0;
    for I:=0 to Pred(FStrings.Count) do
    begin
      L:=Length(FStrings.Strings[I]);
      if (L > 0) and (N <= MaxHintLines) then Inc(N);
    end;

    for I:=0 to Pred(N) do Canvas.TextOut(2,2 + I * 14,FStrings.Strings[I]);
  end;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.SetMode(Value: TMode);
begin
  FMode:=Value;
  case FMode of
    gmNone: if Assigned(FControls.FModeNone) then
              FControls.FModeNone.Checked:=True;
    gmMove: if Assigned(FControls.FModeMove) then
              FControls.FModeMove.Checked:=True;
    gmInsert: if Assigned(FControls.FModeInsert) then
                FControls.FModeInsert.Checked:=True;
    gmDelete: if Assigned(FControls.FModeDelete) then
                FControls.FModeDelete.Checked:=True;
    gmCursor: if Assigned(FControls.FModeCursor) then
                FControls.FModeCursor.Checked:=True;
  end;
end;
{------------------------------------------------------------------------------}
{
procedure TXYGraph.SetEditMode(Value: TEditMode);
begin
  FEditMode:=Value;
  if (FEditMode = emMove) or (FEditMode = emInsert) then
  begin
    if Assigned(FControls.XOut) then FControls.XOut.Enabled:=True;
    if Assigned(FControls.YOut) then FControls.YOut.Enabled:=True;
  end
  else
  begin
    if Assigned(FControls.XOut) then FControls.XOut.Enabled:=False;
    if Assigned(FControls.YOut) then FControls.YOut.Enabled:=False;
  end;
  case FEditMode of
    emNone: if Assigned(FControls.FEditModeNone) then
              FControls.FEditModeNone.Checked:=True;
    emMove: if Assigned(FControls.FEditModeMove) then
              FControls.FEditModeMove.Checked:=True;
    emInsert: if Assigned(FControls.FEditModeInsert) then
                FControls.FEditModeInsert.Checked:=True;
    emDelete: if Assigned(FControls.FEditModeDelete) then
                FControls.FEditModeDelete.Checked:=True;
  end;
  if FEditMode <> emNone then SetMode(gmNone);
end;
}
{------------------------------------------------------------------------------}
(*
procedure TXYGraph.SetPanMode(Value: TPanMode);
begin
  FPanMode:=Value;
  case FPanMode of
    pmGraph: if Assigned(FControls.FPanModeGraph) then
               FControls.FPanModeGraph.Checked:=True;
    pmCurves: if Assigned(FControls.FPanModeCurves) then
              begin
                FControls.FPanModeCurves.Checked:=True;
                if Assigned(FControls.XOut) then FControls.XOut.Enabled:=True;
                if Assigned(FControls.YOut) then FControls.YOut.Enabled:=True;
              end;
  end;
end;
*)
{------------------------------------------------------------------------------}

procedure TXYGraph.DoButtonClick(Sender: TObject);
begin
  if Sender = FControls.FClear then
  begin
    while FCurveList.Count > 0 do DeleteCurve(0);
    FHintPanel.FStrings.Clear;
    ShowHintPanel(False);
    GraphTitle:='Graph-Title';
    if Assigned(FControls.FCurveListBox) then FControls.FCurveListBox.Items.Clear;
    if Assigned(FControls.FCurveGroupListBox) then FControls.FCurveGroupListBox.Items.Clear;
    if Assigned(FControls.FPanListBox) then FControls.FPanListBox.Items.Clear;
    Reset;
    Application.ProcessMessages;
    paint;
  end
  else if (Sender = FControls.FOpenView) and Assigned(FControls.FCurveListBox) then
  begin
    FControls.FCurveListBox.BringToFront;
    FControls.FCurveListBox.Visible := not FControls.FCurveListBox.Visible;
  end
  else if (Sender = FControls.FOpenPan) and Assigned(FControls.FPanListBox) then
  begin
    FControls.FPanListBox.BringToFront;
    FControls.FPanListBox.Visible:=not FControls.FPanListBox.Visible;
  end
  else if Sender = FControls.FReset then Reset;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.DoRadioButtonClick(Sender: TObject);
begin
  if Sender = FControls.FModeNone then FMode:=gmNone
  else if Sender = FControls.FModeMove then FMode:=gmMove
  else if Sender = FControls.FModeInsert then FMode:=gmInsert
  else if Sender = FControls.FModeDelete then FMode:=gmDelete
  else if Sender = FControls.FModeCursor then FMode:=gmCursor;
  SetEditEnable(FMode = gmMove);
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.DoCheckBoxClick(Sender: TObject);
begin
  if Sender = FControls.FAspectRatio then
    ZoomAspectRatio:=FControls.FAspectRatio.Checked
  else if Sender = FControls.FMainGrid then
  begin
    FXAxis.ShowMainGrid:=FControls.FMainGrid.Checked;
    FYAxis.ShowMainGrid:=FControls.FMainGrid.Checked;
  end
  else if Sender = FControls.FSubGrid then
  begin
    FXAxis.ShowSubGrid:=FControls.FSubGrid.Checked;
    FYAxis.ShowSubGrid:=FControls.FSubGrid.Checked;
  end
  else if Sender = FControls.FShowScale then
  begin
    FXAxis.ShowScale:=FControls.FShowScale.Checked;
    FYAxis.ShowScale:=FControls.FShowScale.Checked;
  end
  else if Sender = FControls.FHintPanel then
    FHintPanel.Visible:=FControls.FHintPanel.Checked;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.DoListBoxClickCheck(Sender: TObject);
var
  LB: TCheckListBox;
  N: Integer;

begin
  if Sender = FControls.FCurveListBox then
  begin
    LB := FControls.FCurveListBox;
    for N := 0 to Pred(LB.Items.Count) do
    begin
      FCurve := FCurveList.Items[N];
      FCurve.Enabled := LB.Checked[N];
    end;
    paint;
  end else
  begin
    if Sender = FControls.FCurveGroupListBox then
    begin
      LB := FControls.FCurveGroupListBox;
      for N := 0 to Pred(LB.Items.Count) do
      begin
        FCurveGroup := FCurveGroupList.Items[N];
        FCurveGroup.Enabled := LB.Checked[N];
      end;
      paint;
    end else
    begin
      if Sender = FControls.FPanListBox then
      begin
        PanCurves := False;
        N := 0;
        if Assigned(FControls.FPanListBox) then
          while not PanCurves and (N < FControls.FPanListBox.Items.Count) do
        begin
          PanCurves := FControls.FPanListBox.Checked[N];
          Inc(N);
        end;
        if FMode <> gmMove then
          SetEditEnable(PanCurves);
      end;
    end;
  end;
end;
{------------------------------------------------------------------------------}

constructor TControls.Create(AGraph: TXYGraph);
begin
  inherited Create;
  Graph:=AGraph;
  FXOut:=nil;
  FYOut:=nil;
  FMode:=nil;
  FCurve:=nil;
  FItem:=nil;
  FColor:=nil;
  FAngle:=nil;
  FXIn:=nil;
  FYIn:=nil;
  FClear:=nil;
  FOpenView:=nil;
  FOpenPan:=nil;
  FReset:=nil;
  FModeNone:=nil;
  FModeMove:=nil;
  FModeInsert:=nil;
  FModeDelete:=nil;
  FModeCursor:=nil;
  FAspectRatio:=nil;
  FMainGrid:=nil;
  FSubGrid:=nil;
  FHintPanel:=nil;
  FShowScale:=nil;
  FCurveListBox:=nil;
  FCurveGroupListBox:=nil;
  FPanListBox:=nil;
end;
{------------------------------------------------------------------------------}

procedure TControls.SetControl(Index: Integer; Value: TControl);
begin
  case Index of
    0: FXOut:=Value;
    1: FYOut:=Value;
    2: FMode:=Value;
    3: FCurve:=Value;
    4: FItem:=Value;
    5: FColor:=Value;
    6: FAngle:=Value;
  end;
end;
{------------------------------------------------------------------------------}

procedure TControls.SetEdit(Index: Integer; Value: TEdit);
begin
  case Index of
    0: begin
         FXIn:=Value;
         if Assigned(FXIn) then FXIn.OnExit:=Graph.DoXEditExit;
       end;
    1: begin
         FYIn:=Value;
         if Assigned(FYIn) then FYIn.OnExit:=Graph.DoYEditExit;
       end;
  end;
end;
{------------------------------------------------------------------------------}

procedure TControls.SetButton(Index: Integer; Value: TButton);
begin
  case Index of
    0: begin
         FClear:=Value;
         if Assigned(FClear) then FClear.OnClick:=Graph.DoButtonClick;
       end;
    1: begin
         begin
           FOpenView:=Value;
           if Assigned(FOpenView) then FOpenView.OnClick:=Graph.DoButtonClick;
         end;
       end;
    2: begin
         FOpenPan:=Value;
         if Assigned(FOpenPan) then FOpenPan.OnClick:=Graph.DoButtonClick;
       end;
    3: begin
         FReset:=Value;
         if Assigned(FReset) then FReset.OnClick:=Graph.DoButtonClick;
       end;
  end;
end;
{------------------------------------------------------------------------------}

procedure TControls.SetRadioButton(Index: Integer; Value: TRadioButton);
begin
  case Index of
    0: begin
         FModeNone:=Value;
         if Assigned(FModeNone) then
           FModeNone.OnClick:=Graph.DoRadioButtonClick;
       end;
    1: begin
         FModeMove:=Value;
         if Assigned(FModeMove) then
           FModeMove.OnClick:=Graph.DoRadioButtonClick;
       end;
    2: begin
         FModeInsert:=Value;
         if Assigned(FModeInsert) then
           FModeInsert.OnClick:=Graph.DoRadioButtonClick;
       end;
    3: begin
         FModeDelete:=Value;
         if Assigned(FModeDelete) then
           FModeDelete.OnClick:=Graph.DoRadioButtonClick;
       end;
    4: begin
         FModeCursor:=Value;
         if Assigned(FModeCursor) then
           FModeCursor.OnClick:=Graph.DoRadioButtonClick;
       end;
  end;
end;
{------------------------------------------------------------------------------}

procedure TControls.SetCheckBox(Index: Integer; Value: TCheckBox);
begin
  case Index of
    0: begin
         FAspectRatio:=Value;
         if Assigned(FAspectRatio) then
           FAspectRatio.OnClick:=Graph.DoCheckBoxClick;
       end;
    1: begin
         FMainGrid:=Value;
         if Assigned(FMainGrid) then
           FMainGrid.OnClick:=Graph.DoCheckBoxClick;
       end;
    2: begin
         FSubGrid:=Value;
         if Assigned(FSubGrid) then
           FSubGrid.OnClick:=Graph.DoCheckBoxClick;
       end;
    3: begin
         FHintPanel:=Value;
         if Assigned(FHintPanel) then
           FHintPanel.OnClick:=Graph.DoCheckBoxClick;
       end;
    4: begin
         FShowScale:=Value;
         if Assigned(FShowScale) then
           FShowScale.OnClick:=Graph.DoCheckBoxClick;
       end;
  end;
end;
{------------------------------------------------------------------------------}

procedure TControls.SetListBox(Index: Integer; Value: TCheckListBox);
begin
  case Index of
    0: begin
         FCurveListBox:=Value;
         if Assigned(FCurveListBox) then
           FCurveListBox.OnClickCheck:=Graph.DoListBoxClickCheck;
       end;
    1: begin
         FCurveGroupListBox:=Value;
         if Assigned(FCurveGroupListBox) then
           FCurveGroupListBox.OnClickCheck := Graph.DoListBoxClickCheck;
       end;
    2: begin
         FPanListBox:=Value;
         if Assigned(FPanListBox) then
           FPanListBox.OnClickCheck:=Graph.DoListBoxClickCheck;
       end;
  end;
end;
{------------------------------------------------------------------------------}

function TXYGraph.SaveCurveToStream(FileStream: TFileStream; Item: Integer): Boolean;
var
  CurveData: TCurveData;
  N: Integer;
begin
  Result:=False;
  if not InRange(Item,0,Pred(FCurveList.Count)) or not Assigned(FileStream) then Exit;
  FCurve:=FCurveList.Items[Item];
  try
    CurveData.Name:=FCurve.Name;
    CurveData.Enabled:=FCurve.Enabled;
    CurveData.Color:=FCurve.Color;
    CurveData.LineWidth:=FCurve.LineWidth;
    CurveData.PenStyle:=FCurve.PenStyle;
    CurveData.Points:=FCurve.FPoints.Count;
    CurveData.Texts:=FCurve.FTexts.Count;
    CurveData.Marks:=FCurve.FMarks.Count;
    CurveData.XOfs:=FCurve.XOfs;
    CurveData.YOfs:=FCurve.YOfs;
    CurveData.FontName:=FCurve.FFont.Name;
    CurveData.FontSize:=FCurve.FFont.Size;
    CurveData.FontStyle:=FCurve.FFont.Style;
    CurveData.MarkSize:=FCurve.MarkSize;

    FileStream.Write(CurveData,SizeOf(TCurveData));

    for N:=0 to Pred(FCurve.FPoints.Count) do
      FileStream.Write(FCurve.FPoints.Items[N]^,SizeOf(TPointRec));

    for N:=0 to Pred(FCurve.FTexts.Count) do
      FileStream.Write(FCurve.FTexts.Items[N]^,SizeOf(TTextRec));

    for N:=0 to Pred(FCurve.FMarks.Count) do
      FileStream.Write(FCurve.FMarks.Items[N]^,SizeOf(TMarkRec));

    Result:=True;
  except
    ShowMessage('Error writing stream!');
  end;
end;
{------------------------------------------------------------------------------}

function TXYGraph.LoadCurveFromStream(FileStream: TFileStream): Boolean;
var
  CurveData: TCurveData;
  PointRec: TPointRec;
  TextRec: TTextRec;
  MarkRec: TMarkRec;
  H,N: Integer;
begin
  Result:=False;
  if not Assigned(FileStream) then Exit;
  try
    FileStream.Read(CurveData,SizeOf(TCurveData));
    H:=MakeCurve(CurveData.Name,CurveData.Color,CurveData.LineWidth,
                 CurveData.PenStyle,CurveData.Enabled,-1, -1);
    SetXOfs(H,CurveData.XOfs);
    SetYOfs(H,CurveData.YOfs);
    SetCurveFont(H,CurveData.FontName,CurveData.FontSize,CurveData.FontStyle);
    SetMarkSize(H,CurveData.MarkSize);

    for N:=0 to Pred(CurveData.Points) do
    begin
      FileStream.Read(PointRec,SizeOf(TPointRec));
      AddPoint(H,PointRec.x,PointRec.y);
    end;

    for N:=0 to Pred(CurveData.Texts) do
    begin
      FileStream.Read(TextRec,SizeOf(TTextRec));
      AddText(H,TextRec.PointIndex,TextRec.XOfs,TextRec.YOfs,
              TextRec.Text,TextRec.TextColor);
    end;

    for N:=0 to Pred(CurveData.Marks) do
    begin
      FileStream.Read(MarkRec,SizeOf(TMarkRec));
      AddMark(H,MarkRec.PointIndex,MarkRec.MarkType,MarkRec.MarkColor);
    end;

    Result:=True;
  except
    ShowMessage('Error reading stream!');
  end;
end;
{------------------------------------------------------------------------------}

function TXYGraph.SaveCurveToFile(const FileName: string; Item: Integer): Boolean;
var
  FileStream: TFileStream;
begin
  Result:=False;
  FileStream:=TFileStream.Create(FileName,fmCreate);
  try
    try
      FileStream.Position:=0;
      Result:=SaveCurveToStream(FileStream,Item);
    except
      Result:=False;
    end;
  finally
    FileStream.Free;
  end;
end;
{------------------------------------------------------------------------------}

function TXYGraph.LoadCurveFromFile(const FileName: string): Boolean;
var
  FileStream: TFileStream;
begin
  Result:=False;
  FileStream := nil;  //Compiler
  if not FileExists(FileName) then Exit;
  try
    FileStream:=TFileStream.Create(FileName,fmOpenRead);
    try
      FileStream.Position:=0;
      Result:=LoadCurveFromStream(FileStream);
    except
      Result:=False;
    end;
  finally
    FileStream.Free;
  end;
end;
{------------------------------------------------------------------------------}

function TXYGraph.SaveGraphToFile(const FileName: string): Boolean;
var
  FileStream: TFileStream;
  GraphData: TGraphData;
  FontRec: TFontRec;
  N: Integer;
begin
  Result:=False;
  FileStream:=TFileStream.Create(FileName,fmCreate);
  try
    try
      GraphData.GraphTitle:=FGraphTitle;
      GraphData.Curves:=FCurveList.Count;
      GraphData.Zoom:=FZoom;
      GraphData.MaxZoom:=FMaxZoom;
      FileStream.Position:=0;
      FileStream.Write(GraphData,SizeOf(GraphData));
      FileStream.Write(FXAxis.FTitle,FXAxis.InstanceSize);
      FileStream.Write(FYAxis.FTitle,FYAxis.InstanceSize);
      FileStream.Write(FColors.FAxisBkGnd,FColors.InstanceSize);
      FileStream.Write(FPositions.FXAxisLeft,FPositions.InstanceSize);

      FontRec.AxisScaleFontName:=FFonts.FAxisScale.Name;
      FontRec.AxisScaleFontSize:=FFonts.FAxisScale.Size;
      FontRec.AxisScaleFontStyle:=FFonts.FAxisScale.Style;
      FontRec.AxisTitleFontName:=FFonts.FAxisTitle.Name;
      FontRec.AxisTitleFontSize:=FFonts.FAxisTitle.Size;
      FontRec.AxisTitleFontStyle:=FFonts.FAxisTitle.Style;
      FontRec.GraphTitleFontName:=FFonts.FGraphTitle.Name;
      FontRec.GraphTitleFontSize:=FFonts.FGraphTitle.Size;
      FontRec.GraphTitleFontStyle:=FFonts.FGraphTitle.Style;
      FileStream.Write(FontRec,SizeOf(FontRec));

      for N:=0 to Pred(GraphData.Curves) do SaveCurveToStream(FileStream,N);
      FHintPanel.FStrings.SaveToStream(FileStream);
      Result:=True;
    except
      Result:=False;
    end;
  finally
    FileStream.Free;
  end;
end;
{------------------------------------------------------------------------------}

function TXYGraph.LoadGraphFromFile(const FileName: string): Boolean;
var
  FileStream: TFileStream;
  GraphData: TGraphData;
  FontRec: TFontRec;
  N: Integer;
begin
  Result:=False;
  FileStream := nil;  //Compiler
  if not FileExists(FileName) then Exit;
  try
    FileStream:=TFileStream.Create(FileName,fmOpenRead);
    try
      FileStream.Position:=0;
      FileStream.Read(GraphData,SizeOf(GraphData));
      FGraphTitle:=GraphData.GraphTitle;
      FZoom:=GraphData.Zoom;
      FMaxZoom:=GraphData.MaxZoom;
      FileStream.Read(FXAxis.FTitle,FXAxis.InstanceSize);
      FileStream.Read(FYAxis.FTitle,FYAxis.InstanceSize);
      FileStream.Read(FColors.FAxisBkGnd,FColors.InstanceSize);
      FileStream.Read(FPositions.FXAxisLeft,FPositions.InstanceSize);

      FileStream.Read(FontRec,SizeOf(FontRec));
      FFonts.FAxisScale.Name:=FontRec.AxisScaleFontName;
      FFonts.FAxisScale.Size:=FontRec.AxisScaleFontSize;
      FFonts.FAxisScale.Style:=FontRec.AxisScaleFontStyle;
      FFonts.FAxisTitle.Name:=FontRec.AxisTitleFontName;
      FFonts.FAxisTitle.Size:=FontRec.AxisTitleFontSize;
      FFonts.FAxisTitle.Style:=FontRec.AxisTitleFontStyle;
      FFonts.FGraphTitle.Name:=FontRec.GraphTitleFontName;
      FFonts.FGraphTitle.Size:=FontRec.GraphTitleFontSize;
      FFonts.FGraphTitle.Style:=FontRec.GraphTitleFontStyle;

      for N:=0 to Pred(GraphData.Curves) do LoadCurveFromStream(FileStream);
      FHintPanel.FStrings.LoadFromStream(FileStream);
      FXAxis.CalcAxis;
      FYAxis.CalcAxis;
      FHintPanel.Paint;
      paint;
      Result:=True;
    except
      Result:=False;
    end;
  finally
    FileStream.Free;
  end;
end;

(*** MD ***********************************************************************)

procedure TXYGraph.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

procedure TXYGraph.EndUpdate;
begin
  Dec(FUpdateCount);
  paint;
end;


procedure TXYGraph.AsciiCurves;
//BG071207: Neu
//
var
  H,I,J: Integer;
  X,Y: TFloat;
begin
  for H:=0 to Pred(FCurveList.Count) do
  begin
    FCurve:=FCurveList.Items[H];
    if FCurve.Enabled and (FCurve.FPoints.Count > 0) then
    begin
      J := Pred(FCurve.FPoints.Count);
      for I :=0 to J do
      begin
        FCurve.GetPoint(I,X,Y);


      end;

    end;
  end;
end;

(******************************************************************************)

procedure TXYGraph.DXFAxis;
var
  Dif,MainStep,SubStep: TFloat;
  TickLen,TextWidth: TFloat;
  N,M: Integer;
  S: Str32;
begin
  if not Assigned(DXFOut) then Exit;
  TextWidth:=DXFOut.TextHeight / 4 * 3;
  TickLen:=5;
  Dif:=FXAxis.FMax - FXAxis.FMin;
  if FXAxis.MainTicks <> 0 then MainStep:=Dif / FXAxis.MainTicks else MainStep:=Dif;
  if FXAxis.SubTicks <> 0 then SubStep:=MainStep / FXAxis.SubTicks else SubStep:=MainStep;
  for N:=0 to FXAxis.MainTicks do
  begin
    DXFOut.Line(DXFOut.ToX(FXAxis.FMin + N * MainStep),
                DXFOut.ToY(FYAxis.FMin) - TickLen,0,
                DXFOut.ToX(FXAxis.FMin + N * MainStep),
                DXFOut.ToY(FYAxis.FMax),0);
    S:=FloatToStrF(FXAxis.Min + (N * FXAxis.ValuePerMainTick),
                   ffFixed,7,FXAxis.Decimals);
    for M:=1 to Length(S) do if S[M] = ' ' then Delete(S,M,1);
    DXFOut.DText(DXFOut.ToX(FXAxis.FMin + N * MainStep) - TextWidth * Length(S) / 2,
                 DXFOut.ToY(FYAxis.FMin) - DXFOut.TextHeight - TickLen - 1,0,
                 DXFOut.TextHeight,0,S);
    if FXAxis.FShowSubGrid and (N < FXAxis.MainTicks) then
      for M:=1 to Pred(FXAxis.SubTicks) do
    begin
      DXFOut.Line(DXFOut.ToX(FXAxis.FMin + N * MainStep + M * SubStep),
                  DXFOut.ToY(FYAxis.FMin),0,
                  DXFOut.ToX(FXAxis.FMin + N * MainStep + M * SubStep),
                  DXFOut.ToY(FYAxis.FMax),0);
    end;
  end;

  Dif:=FYAxis.FMax - FYAxis.FMin;
  if FYAxis.MainTicks <> 0 then MainStep:=Dif / FYAxis.MainTicks else MainStep:=Dif;
  if FYAxis.SubTicks <> 0 then SubStep:=MainStep / FYAxis.SubTicks else SubStep:=MainStep;
  for N:=0 to FYAxis.MainTicks do
  begin
    DXFOut.Line(DXFOut.ToX(FXAxis.FMin) - TickLen,
                DXFOut.ToY(FYAxis.FMin + N * MainStep),0,
                DXFOut.ToX(FXAxis.FMax),
                DXFOut.ToY(FYAxis.FMin + N * MainStep),0);
    S:=FloatToStrF(FYAxis.Min + (N * FYAxis.ValuePerMainTick),
                   ffFixed,7,FYAxis.Decimals);
    for M:=1 to Length(S) do if S[M] = ' ' then Delete(S,M,1);
    DXFOut.DText(DXFOut.ToX(FXAxis.FMin) - TickLen - TextWidth * Length(S) - 1,
                 DXFOut.ToY(FYAxis.FMin + N * MainStep) - DXFOut.TextHeight / 2,
                 0,DXFOut.TextHeight,0,S);
    if FXAxis.FShowSubGrid and (N < FYAxis.MainTicks) then
      for M:=1 to Pred(FYAxis.SubTicks) do
    begin
      DXFOut.Line(DXFOut.ToX(FXAxis.FMin),
                  DXFOut.ToY(FYAxis.FMin + N * MainStep + M * SubStep),0,
                  DXFOut.ToX(FXAxis.FMax),
                  DXFOut.ToY(FYAxis.FMin + N * MainStep + M * SubStep),0);
    end;
  end;

  S:=FXAxis.FTitle;
  SubStep:=Length(S) * TextWidth;
  MainStep:=(FXAxis.FMax - FXAxis.FMin) / 2;
  Dif:=FXAxis.FMin + MainStep - SubStep;
  DXFOut.DText(DXFOut.ToX(Dif),
               DXFOut.ToY(FYAxis.FMin) - TickLen - DXFOut.TextHeight * 6,
               0,DXFOut.TextHeight * 2,0,S);

  S:=FYAxis.FTitle;
  SubStep:=Length(S) * TextWidth;
  MainStep:=(FYAxis.FMax - FYAxis.FMin) / 2;
  Dif:=FYAxis.FMin + MainStep - SubStep;
  DXFOut.DText(DXFOut.ToX(FXAxis.FMin) - TickLen - TextWidth * Length(S) -
               DXFOut.TextHeight * 2 - 2,
               DXFOut.ToY(Dif),0,DXFOut.TextHeight * 2,90,S);

  S:=FGraphTitle;
  SubStep:=Length(S) * TextWidth;
  MainStep:=(FXAxis.FMax - FXAxis.FMin) / 2;
  Dif:=FXAxis.FMin + MainStep - SubStep;
  DXFOut.DText(DXFOut.ToX(Dif),
               DXFOut.ToY(FYAxis.FMax) + DXFOut.TextHeight * 6,
               0,DXFOut.TextHeight * 2,0,S);
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.DXFCurves;
var
  H,I,J: Integer;
  X,Y: TFloat;
begin
  for H:=0 to Pred(FCurveList.Count) do
  begin
    FCurve:=FCurveList.Items[H];
    if FCurve.Enabled and (FCurve.FPoints.Count > 0) then
    begin
      J:=Pred(FCurve.FPoints.Count);
      DXFOut.StartPolyLine(False);
      for I:=0 to J do
      begin
        FCurve.GetPoint(I,X,Y);
        DXFOut.Vertex(DXFOut.ToX(X),DXFOut.ToY(Y),0);
      end;
      DXFOut.EndPolyLine;
    end;
  end;
end;
{------------------------------------------------------------------------------}

function TXYGraph.MakeDXF(const FileName: string; FromX1,FromY1,FromX2,FromY2,
                          ToX1,ToY1,ToX2,ToY2,TextHeight: TFloat;
                          Decimals: Byte): Boolean;
begin
  Result:=False;
  try
    DXFOut:=TDXFOut.Create(FromX1,FromY1,FromX2,FromY2,ToX1,ToY1,ToX2,ToY2,
                           TextHeight,Decimals);
    try
      DXFOut.Header;
      DXFAxis;
      DXFCurves;
      DXFOut.Trailer;
      DXFOut.StringList.SaveToFile(FileName);
      Result:=True;
    except
      Result:=False;
    end;
  finally
    DXFOut.Free;
  end;
end;
{------------------------------------------------------------------------------}

constructor TDXFOut.Create(AFromXMin,AFromYMin,AFromXMax,AFromYMax,
                           AToXMin,AToYMin,AToXMax,AToYMax,ATextHeight: TFloat; ADecimals: Byte);
begin
  inherited Create;
  FromXMin:=AFromXMin;
  FromYMin:=AFromYMin;
  FromXMax:=AFromXMax;
  FromYMax:=AFromYMax;
  ToXMin:=AToXMin;
  ToYMin:=AToYMin;
  ToXMax:=AToXMax;
  ToYMax:=AToYMax;
  TextHeight:=ATextHeight;
  Decimals:=ADecimals;
  StringList:=TStringList.Create;
end;
{------------------------------------------------------------------------------}

destructor TDXFOut.Destroy;
begin
  StringList.Free;
  inherited Destroy;
end;
{------------------------------------------------------------------------------}

procedure TDXFOut.Header;
begin
  LayerName:='0';
  StringList.Add('0');
  StringList.Add('SECTION');
  StringList.Add('2');
  StringList.Add('HEADER');
  StringList.Add('9');
  StringList.Add('$LIMMIN');
  StringList.Add('10');
  StringList.Add(FToA(ToXMin));
  StringList.Add('20');
  StringList.Add(FToA(ToYMin));
  StringList.Add('9');
  StringList.Add('$LIMMAX');
  StringList.Add('10');
  StringList.Add(FToA(ToXMax));
  StringList.Add('20');
  StringList.Add(FToA(ToYMax));
  StringList.Add('0');
  StringList.Add('ENDSEC');
  StringList.Add('0');
  StringList.Add('SECTION');
  StringList.Add('2');
  StringList.Add('TABLES');
  StringList.Add('0');
  StringList.Add('TABLE');
  StringList.Add('2');
  StringList.Add('LAYER');
  StringList.Add('70');
  StringList.Add('1');
  StringList.Add('0');
  StringList.Add('LAYER');
  StringList.Add('2');
  StringList.Add('0');
  StringList.Add('70');
  StringList.Add('64');
  StringList.Add('62');
  StringList.Add('7');
  StringList.Add('6');
  StringList.Add('CONTINUOUS');
  StringList.Add('0');
  StringList.Add('ENDTAB');
  StringList.Add('0');
  StringList.Add('ENDSEC');
  StringList.Add('0');
  StringList.Add('SECTION');
  StringList.Add('2');
  StringList.Add('ENTITIES');
end;
{------------------------------------------------------------------------------}

function TDXFOut.FToA(F: TFloat): Str32;
var
  I: Integer;
begin
  Result:=FloatToStrF(F,ffFixed,16,Decimals);
  I:=Pos(',',Result);
  if I > 0 then Result[I]:='.';
end;
{------------------------------------------------------------------------------}

function TDXFOut.ToX(X: TFloat): TFloat;
var
  Factor,FromDif: TFloat;
begin
  FromDif:=FromXMax - FromXMin;
  if FromDif <> 0.0 then Factor:=(ToXMax - ToXMin) / FromDif else Factor:=1.0;
  Result:=X * Factor;
end;
{------------------------------------------------------------------------------}

function TDXFOut.ToY(Y: TFloat): TFloat;
var
  Factor,FromDif: TFloat;
begin
  FromDif:=FromYMax - FromYMin;
  if FromDif <> 0.0 then Factor:=(ToYMax - ToYMin) / FromDif else Factor:=1.0;
  Result:=Y * Factor;
end;
{------------------------------------------------------------------------------}

procedure TDXFOut.SetLayer(const Name: Str32);
begin
  LayerName:=Name;
end;
{------------------------------------------------------------------------------}

procedure TDXFOut.Layer;
begin
  StringList.Add('8');
  StringList.Add(LayerName);
end;
{------------------------------------------------------------------------------}

procedure TDXFOut.StartPoint(X,Y,Z: TFloat);
begin
  StringList.Add('10');
  StringList.Add(FToA(X));
  StringList.Add('20');
  StringList.Add(FToA(Y));
  StringList.Add('30');
  StringList.Add(FToA(Z));
end;
{------------------------------------------------------------------------------}

procedure TDXFOut.EndPoint(X,Y,Z: TFloat);
begin
  StringList.Add('11');
  StringList.Add(FToA(X));
  StringList.Add('21');
  StringList.Add(FToA(Y));
  StringList.Add('31');
  StringList.Add(FToA(Z));
end;
{------------------------------------------------------------------------------}

procedure TDXFOut.AddText(const Txt: Str32);
begin
  StringList.Add('1');
  StringList.Add(Txt);
end;
{------------------------------------------------------------------------------}

procedure TDXFOut.StartPolyLine(Closed: Boolean);
var
  Flag : Byte;
begin
  StringList.Add('0');
  StringList.Add('POLYLINE');
  Layer;
  StringList.Add('66');
  StringList.Add('1');
  StartPoint(0,0,0);
  Flag:=8;
  if Closed then Flag:=Flag or 1;
  StringList.Add('70');
  StringList.Add(IntToStr(Flag));
end;
{------------------------------------------------------------------------------}

procedure TDXFOut.Vertex(X,Y,Z: TFloat);
var
 Flag : Byte;
begin
  StringList.Add('0');
  StringList.Add('VERTEX');
  Layer;
  StartPoint(X,Y,Z);
  StringList.Add('70');
  Flag:=32;
  StringList.Add(IntToStr(Flag));
end;
{------------------------------------------------------------------------------}

procedure TDXFOut.EndPolyLine;
begin
  StringList.Add('0');
  StringList.Add('SEQEND');
  Layer;
end;
{------------------------------------------------------------------------------}

procedure TDXFOut.Line(X1,Y1,Z1,X2,Y2,Z2: TFloat);
begin
  StringList.Add('0');
  StringList.Add('LINE');
  Layer;
  StartPoint(X1,Y1,Z1);
  EndPoint(X2,Y2,Z2);
end;
{------------------------------------------------------------------------------}

procedure TDXFOut.Point(X,Y,Z: TFloat);
begin
  StringList.Add('0');
  StringList.Add('POINT');
  Layer;
  StartPoint(X,Y,Z);
end;
{------------------------------------------------------------------------------}

procedure TDXFOut.DText(X,Y,Z,Height,Angle: TFloat; const Txt: Str32);
begin
  StringList.Add('0');
  StringList.Add('TEXT');
  Layer;
  StartPoint(X,Y,Z);
  StringList.Add('40');
  StringList.Add(FToA(Height));
  AddText(Txt);
  StringList.Add('50');
  StringList.Add(FToA(Angle));
end;
{------------------------------------------------------------------------------}

procedure TDXFOut.Trailer;
begin
  StringList.Add('0');
  StringList.Add('ENDSEC');
  StringList.Add('0');
  StringList.Add('EOF');
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.Notification(Component: TComponent; Operation: TOperation);
begin
  if not (csDestroying in ComponentState) then
  try
  if (Operation = opRemove) and (FControls <> nil) then
  begin
    if Component = FControls.FXOut then FControls.FXOut:=nil; 
    if Component = FControls.FYOut then FControls.FYOut:=nil; 
    if Component = FControls.FMode then FControls.FMode:=nil; 
    if Component = FControls.FCurve then FControls.FCurve:=nil; 
    if Component = FControls.FItem then FControls.FItem:=nil; 
    if Component = FControls.FColor then FControls.FColor:=nil; 
    if Component = FControls.FAngle then FControls.FAngle:=nil; 
    if Component = FControls.FXIn then FControls.FXIn:=nil; 
    if Component = FControls.FYIn then FControls.FYIn:=nil; 
    if Component = FControls.FClear then FControls.FClear:=nil; 
    if Component = FControls.FOpenView then FControls.FOpenView:=nil; 
    if Component = FControls.FOpenPan then FControls.FOpenPan:=nil; 
    if Component = FControls.FReset then FControls.FReset:=nil; 
    if Component = FControls.FModeNone then FControls.FModeNone:=nil; 
    if Component = FControls.FModeMove then FControls.FModeMove:=nil; 
    if Component = FControls.FModeInsert then FControls.FModeInsert:=nil; 
    if Component = FControls.FModeDelete then FControls.FModeDelete:=nil; 
    if Component = FControls.FModeCursor then FControls.FModeCursor:=nil; 
    if Component = FControls.FAspectRatio then FControls.FAspectRatio:=nil; 
    if Component = FControls.FMainGrid then FControls.FMainGrid:=nil;
    if Component = FControls.FSubGrid then FControls.FSubGrid:=nil;
    if Component = FControls.FHintPanel then FControls.FHintPanel:=nil;
    if Component = FControls.FShowScale then FControls.FShowScale:=nil;
    if Component = FControls.FCurveListBox then FControls.FCurveListBox:=nil;
    if Component = FControls.FCurveGroupListBox then FControls.FCurveGroupListBox:=nil;
    if Component = FControls.FPanListBox then FControls.FPanListBox:=nil;
  end;
  except
  end;
  inherited Notification(Component,Operation);
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.InitMkr (var xMkr : TMarker; Color : TColor);
//Marker initialisieren
begin
 fillchar (xMkr, sizeof (xMkr), 0);
 with xMkr do begin
  bVisible := false;
  bActive := false;
  Col := Color;
  Style := bsSolid;
  MSize := 7;
  iCell := 1;
  Pos.X   := FPositions.FXGraphLeft + Positions.FXAxisLeft;
  Pos.Y   := Positions.FYAxisTop;
  Point.x := FXAxis.FMin; //beim Start soll sich der Marker verschämt in die linke untere Ecke zurückziehen             
  Point.y := FYAxis.FMin;
  Shape [1].X := Pos.X;
  Shape [1].Y := Pos.Y;
  Shape [2].X := Shape [1].x - MSize;
  Shape [2].Y := Shape [1].Y - MSize;
  Shape [3].X := Shape [1].x + MSize;
  Shape [3].Y := Shape [2].Y;
 end;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.SetActMkrNo (iMkr : integer);
//aktiven Marker zwischen relativem und absoluten umschalten
begin
 if iActMkrNo <> iMkr then begin
  iActMkrNo := iMkr;
  case iActMkrNo of
   0 : ActMkr := @(AbsMkr);
   1 : ActMkr := @(RelMkr);
  end;
 end;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.DrawMkr (var xMkr : TMarker);
//Marker malen
var
  iMirror : integer;
begin
  with Canvas do
  begin
    iMirror := +1;
    Brush.Color := xMkr.Col;
    Brush.Style := xMkr.Style;
    Pen.Style := psClear;             //Es soll kein Rahmen gezeichnet werden
    xMkr.Pos.X := XAxisPixel(xMkr.Point.x);
    xMkr.Pos.Y := YAxisPixel(xMkr.Point.y);
    if xMkr.Pos.X = FPositions.FXGraphLeft + Positions.FXAxisLeft then
      exit;
    if xMkr.Pos.Y = Height - Positions.FYAxisBottom then exit; //damit wird nicht ein Phantommarker verhindert

    xMkr.Shape [1].X := xMkr.Pos.X;
    xMkr.Shape [1].Y := xMkr.Pos.Y;
    xMkr.Shape [2].X := xMkr.Shape [1].x - xMkr.MSize * iMirror;
    xMkr.Shape [2].Y := xMkr.Shape [1].Y - 2 * xMkr.MSize * iMirror;
    xMkr.Shape [3].X := xMkr.Shape [1].x + xMkr.MSize * iMirror;
    xMkr.Shape [3].Y := xMkr.Shape [2].Y;
    Polygon (xMkr.Shape);
    {
    xMkr.Shape [1].X := xMkr.Pos.X;
    xMkr.Shape [1].Y := xMkr.Pos.Y + 100;
    xMkr.Shape [2].X := xMkr.Shape [1].x + 1;
    xMkr.Shape [2].Y := xMkr.Pos.Y - 100;
    xMkr.Shape [3].X := xMkr.Shape [1].x - 1;
    xMkr.Shape [3].Y := xMkr.Pos.Y - 100;
    Polygon (xMkr.Shape);
    }
  end;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.ShowMkr (var xMkr : TMarker);
//Marker auf sichtbar setzen
begin
  with Canvas do
  begin
    if (xMkr.bVisible) or
       (not xMkr.bActive) then
      exit;
    Pen.Mode := pmNotXOR;
    DrawMkr(xMkr);
    Pen.Mode := pmCopy;
    xMkr.bVisible := true;
  end;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.HideMkr (var xMkr : TMarker);
//Marker verstecken
begin
 with Canvas do begin
  if (not xMkr.bVisible) or
     (not xMkr.bActive) then
    exit;
  Pen.Mode := pmNotXOR;
  DrawMkr (xMkr);
  Pen.Mode := pmCopy;
  xMkr.bVisible := false;
 end;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.UpdateMkr (var xMkr : TMarker);
//Marker neu malen
begin
  with Canvas do
  begin
    if xMkr.bVisible and xMkr.bActive then
    begin
      Pen.Mode := pmNotXOR;
      DrawMkr (xMkr);
      Pen.Mode := pmCopy;
    end;
  end;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.HideMkrs;
//alle Marker verstecken
begin
  HideMkr (AbsMkr);
  HideMkr (RelMkr);
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.ShowMkrs;
//alle Marker zeigen
begin
  AbsMkr.bActive := true;
  RelMkr.bActive := true;
  ShowMkr (AbsMkr);
  ShowMkr (RelMkr);
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.ClearMkrs;
//Marker löschen
begin
  HideMkr (AbsMkr);
  HideMkr (RelMkr);
  AbsMkr.bActive := false;
  RelMkr.bActive := false;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.MovMkrToPnt (xPos : integer; xMkr : TMarker);
//Bewege einen Marker auf die mit xPos (= Pixel-Wert) angegebene Position
//auf der zugehörigen Kurve, die Vorgabe xPos wird mit den nächstmöglichen
//wahren Wert vergleichen und entsprechend korrigiert
var
 XMinDist : Double;
 i, iMinDist : integer;
 s : string;
begin
  FCurve := FCurveList.Items[xMkr.iCrv]; //Marker-Kurve laden
  if xPos > (Width - Positions.FXAxisRight) then xPos := Width - Positions.FXAxisRight; //Sicherheitshalber X-Werte begrenzen
  if xPos < FPositions.FXGraphLeft + Positions.FXAxisLeft  then
    xPos := Positions.FXAxisLeft;
  ActMkr^.bActive := true;
  HideMkr (ActMkr^);
  iMinDist := 0;

  XMinDist := Width - Positions.FXAxisRight - (FPositions.FXGraphLeft + Positions.FXAxisLeft); //das ist die Breite des Fensters, das Ergbn. muss immer kleiner sein
  for i := 0 to pred (FCurve.FPoints.Count) do
  begin {Suche nach oben}
    FCurve.PPoint := FCurve.FPoints.Items[i];
    if Abs (XAxisPixel(FCurve.PPoint.X) - xPos) < XMinDist then
    begin
      XMinDist := Abs (XAxisPixel(FCurve.PPoint.X) - xPos);
      iMinDist := i;
    end;
  end;
  ActMkr^.iCell := iMinDist;                //Gefundene Pos im Array merken
  FCurve.PPoint := FCurve.FPoints[iMinDist];
  ActMkr^.Point.x := FCurve.PPoint.x;      //Die Rückrechnung zwingt den Marker auf die Position
  ActMkr^.Point.y := FCurve.PPoint.y;     // Y-Wert suchen und in Koordinate wandeln

  case iActMkrNo of
    0 : // der absolute wird nur bei Bedarf gezeichnet
    begin
      s := FloatToStrF (ActMkr^.Point.x, ffNumber, 18, xAxis.Decimals) +
           ', ' +
           FloatToStrF (ActMkr^.Point.y, ffNumber, 18, yAxis.Decimals);
      MarkerBar.lblAbsMkrSmall.Caption := 'Abs: ' + s;
    end;
  end;
  // der relative Marker wird immer gemalt
  s := FloatToStrF (RelMkr.Point.x - AbsMkr.Point.x, ffNumber, 18, xAxis.Decimals) +
       ', ' +
       FloatToStrF (RelMkr.Point.y - AbsMkr.Point.y, ffNumber, 18, yAxis.Decimals);
   MarkerBar.lblRelMkrSmall.Caption := 'Rel: ' + s;

  ShowMkr (ActMkr^);                        //tatsächlich vorhandene Werte
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.SetMkrToX (xPos : Double; xMkr : TMarker);
var
 XMinDist : Double;
 i, iMinDist : integer;
 s : string;
begin
  try
    if FCurveList.Count = 0 then exit;
    FCurve := FCurveList.Items[xMkr.iCrv]; //Marker-Kurve laden

    ActMkr^.bActive := true;
    HideMkr (ActMkr^);
    iMinDist := 0;

    XMinDist := 1E9; //das ist die Breite des Fensters, das Ergbn. muss immer kleiner sein
    for i := 0 to pred (FCurve.FPoints.Count) do
    begin {Suche nach oben}
      FCurve.PPoint := FCurve.FPoints.Items[i];
      if Abs (FCurve.PPoint.X - xPos) < XMinDist then
      begin
        XMinDist := Abs (FCurve.PPoint.X - xPos);
        iMinDist := i;
      end;
    end;
    ActMkr^.iCell := iMinDist;                //Gefundene Pos im Array merken
    if FCurve.FPoints.Count > iMinDist then   //MD 12.03.08
    begin
      FCurve.PPoint := FCurve.FPoints[iMinDist];
      ActMkr^.Point.x := FCurve.PPoint.x;      //Die Rückrechnung zwingt den Marker auf die Position
      ActMkr^.Point.y := FCurve.PPoint.y;     // Y-Wert suchen und in Koordinate wandeln

      case iActMkrNo of
        0 : // der absolute wird nur bei Bedarf gezeichnet
        begin
          s := FloatToStrF (ActMkr^.Point.x, ffNumber, 18, xAxis.Decimals) +
               ', ' +
               FloatToStrF (ActMkr^.Point.y, ffNumber, 18, yAxis.Decimals);
          MarkerBar.lblAbsMkrSmall.Caption := 'Abs: ' + s;
        end;
      end;
      // der relative Marker wird immer gemalt
      s := FloatToStrF (RelMkr.Point.x - AbsMkr.Point.x, ffNumber, 18, xAxis.Decimals) +
           ', ' +
           FloatToStrF (RelMkr.Point.y - AbsMkr.Point.y, ffNumber, 18, yAxis.Decimals);
       MarkerBar.lblRelMkrSmall.Caption := 'Rel: ' + s;

      ShowMkr (ActMkr^);                        //tatsächlich vorhandene Werte
    end;
  except
  end;
end;
{------------------------------------------------------------------------------}

function TXYGraph.CalcMkrX (var xVal : Double) : integer;
//Berechnet die (im CanvasOrg) absolute Pixelposition des Markers,
//die möglichen Werte werden auf das CanvasOrg beschränkt}
var Ri : Double;
begin
  try
    Ri := XAxisPixel(xVal);
    if (Ri > -32e3) and (Ri < 32e3) then Result := trunc (Ri)
                                    else Result := 0;
    if Result > (Width - Positions.FXAxisRight) then Result := Width - Positions.FXAxisRight+3; //Sicherheitshalber X- und Y-Werte auf das Fenster trimmen
    if Result < FPositions.FXGraphLeft + Positions.FXAxisLeft  then
      Result := Positions.FXAxisLeft-3;
  except
    Result := FPositions.FXGraphLeft + Positions.FXAxisLeft-3;
  end;
end;
{------------------------------------------------------------------------------}

function TXYGraph.CalcMkrY (var yVal : Double) : integer;
//Berechnet die (im CanvasOrg) absolute Pixelposition des Markers,
//die möglichen Werte werden auf das CanvasOrg beschränkt}
var Ri : Double;
begin
  try
    Ri := YAxisPixel(yVal);
    if (Ri > -32e3) and (Ri < 32e3) then Result := trunc (Ri)
                                    else Result := 0;
    if Result > Positions.FYAxisBottom then Result := Positions.FYAxisBottom+3; //auf den Abbildungsbereich begrenzen
    if Result < Positions.FYAxisTop    then Result := Positions.FYAxisTop-3;
  except
    Result := Positions.FYAxisTop-3;
  end;
end;
{------------------------------------------------------------------------------}


procedure TXYGraph.MovVertMkrToPnt (xPos : integer; xMkr : TMarker);
//Bewege einen Marker auf die mit xPos (= Pixel-Wert) angegebene Position
//auf der zugehörigen Kurve, die Vorgabe xPos wird mit den nächstmöglichen
//wahren Wert vergleichen und entsprechend korrigiert
var
 XMinDist : Double;
 i, iMinDist : integer;
 s : string;
begin
  FCurve := FCurveList.Items[xMkr.iCrv]; //Marker-Kurve laden
  if xPos > (Width - Positions.FXAxisRight) then xPos := Width - Positions.FXAxisRight; //Sicherheitshalber X-Werte begrenzen
  if xPos < FPositions.FXGraphLeft + Positions.FXAxisLeft  then
    xPos := Positions.FXAxisLeft;
  ActMkr^.bActive := true;
  HideMkr (ActMkr^);
  iMinDist := 0;

  XMinDist := Width - Positions.FXAxisRight - (FPositions.FXGraphLeft + Positions.FXAxisLeft); //das ist die Breite des Fensters, das Ergbn. muss immer kleiner sein
  for i := 0 to pred (FCurve.FPoints.Count) do
  begin {Suche nach oben}
    FCurve.PPoint := FCurve.FPoints.Items[i];
    if Abs (XAxisPixel(FCurve.PPoint.X) - xPos) < XMinDist then
    begin
      XMinDist := Abs (XAxisPixel(FCurve.PPoint.X) - xPos);
      iMinDist := i;
    end;
  end;
  ActMkr^.iCell := iMinDist;                //Gefundene Pos im Array merken
  FCurve.PPoint := FCurve.FPoints[iMinDist];
  ActMkr^.Point.x := FCurve.PPoint.x;      //Die Rückrechnung zwingt den Marker auf die Position
  ActMkr^.Point.y := FCurve.PPoint.y;     // Y-Wert suchen und in Koordinate wandeln

  case iActMkrNo of
    0 : // der absolute wird nur bei Bedarf gezeichnet
    begin
      s := FloatToStrF (ActMkr^.Point.x, ffNumber, 18, xAxis.Decimals) +
           ', ' +
           FloatToStrF (ActMkr^.Point.y, ffNumber, 18, yAxis.Decimals);
      MarkerBar.lblAbsMkrSmall.Caption := 'Abs: ' + s;
    end;
  end;
  // der relative Marker wird immer gemalt
  s := FloatToStrF (RelMkr.Point.x - AbsMkr.Point.x, ffNumber, 18, xAxis.Decimals) +
       ', ' +
       FloatToStrF (RelMkr.Point.y - AbsMkr.Point.y, ffNumber, 18, yAxis.Decimals);
   MarkerBar.lblRelMkrSmall.Caption := 'Rel: ' + s;

  ShowMkr (ActMkr^);                        //tatsächlich vorhandene Werte
end;
{------------------------------------------------------------------------------}



procedure TXYGraph.WriteFreeText(XS, YS : integer);
var
  sText : string;
  X, Y : Double;
begin
  if csDesigning in ComponentState then exit;
  try
    X := XAxis.Value(XS - Positions.XGraphLeft - Positions.XAxisLeft);
    Y := YAxis.Value(Height - YS - Positions.YAxisBottom);
    if Assigned(FTextOnMouseMoveEvent) then
    begin
      FTextOnMouseMoveEvent(Self, XS, YS, X, Y, sText);
      if bShowFree then
      begin //das freie Textfeld bekommt Info über den Cursor
        FreeMarkerBar.lblFree.Caption := sText;
        FreeMarkerBar.lblFree.Refresh;
      end;
    end;
  except
  end;
end;
{------------------------------------------------------------------------------}


procedure TXYGraph.SetRefresh (bVal : Boolean);
begin
  //bRefresh := bVal;

  //XYToolBar.PaintBtns;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.SetShowZoom (bVal : Boolean);
begin
  bShowZoom := bVal;
//  if csDesigning in ComponentState then exit;

  {
  if bVal then
    XYToolBar.Parent := ToolBar
  else
    XYToolBar.Parent := nil;
  }
  XYToolBar.PaintBtns;
end;

{------------------------------------------------------------------------------}
procedure TXYGraph.SetShowFree (bVal : Boolean);
begin
  bShowFree := bVal;
//  if csDesigning in ComponentState then exit;
  FreeMarkerBar.PaintBtns;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.SetShowMarker (bVal : Boolean);
begin
  bShowMarker := bVal;
//  if csDesigning in ComponentState then exit;
  {
  if bVal then
    MarkerBar.Parent := ToolBar
  else
    MarkerBar.Parent := nil;
  }
  XYToolBar.PaintBtns;
  MarkerBar.PaintBtns;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.SetShowCurveTitles (bVal : Boolean);
begin
  bShowCurveTitles := bVal;
  if bVal then
    CurveTitleBar.Parent := ToolBar
  else
    CurveTitleBar.Parent := nil;
  CurveTitleBar.PaintBtns;
  sbCurveTitles.Visible := bVal;

//  if csDesigning in ComponentState then exit;
  paint;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.SetColorIndex(aVal: TColor);
begin
  cColorIndex := aVal;
end;
{------------------------------------------------------------------------------}

procedure TXYGraph.SetFarbschema(aVal: integer);
begin
  iFarbschema := aVal;
end;
{------------------------------------------------------------------------------}

function TXYGraph.GetNextColor: TColor;
begin
  result := ColorPalette[iFarbschema, cColorIndex];
  ColorIndex := (cColorIndex + 1) mod length(ColorPalette[iFarbschema]);
end;
{------------------------------------------------------------------------------}

function TXYGraph.GetCurveCount: integer;
begin
  Result := FCurveList.Count;
end;
{------------------------------------------------------------------------------}

function TXYGraph.SetColorToCrv(aIdx, aMaxIdx, aSchema: Byte; aGroundColor: TColor): TColor;
var
  Color: TColor;
  cBlue, cGreen, cRed: Byte;
  cBlue1, cGreen1, cRed1: Word;
begin
  Color := clBlue;
  aMaxIdx := aMaxIdx + 2; //nicht ganz nach weiss verschieben
  case aSchema of
    0:begin //schwarzer Hintergrund
        case aGroundColor of
          clRed:
            begin
              cBlue1 := Round($FF * aIdx / aMaxIdx);
              cGreen1 := Round($FF * aIdx / aMaxIdx);
              cRed1 := $FF;
              if cBlue1 > 255 then
                cBlue1 := 255;
              if cGreen1 > 255 then
                cGreen1 := 255;
              if cRed1 > 255 then
                cRed1 := 255;
              Color := RGB(cRed1, cGreen1, cBlue1);
            end;
          clGreen:
            begin
              cBlue1 := Round($FF * aIdx / aMaxIdx);
              cGreen1 := $FF;
              cRed1 := Round($FF * aIdx / aMaxIdx);
              if cBlue1 > 255 then
                cBlue1 := 255;
              if cGreen1 > 255 then
                cGreen1 := 255;
              if cRed1 > 255 then
                cRed1 := 255;
              Color := RGB(cRed1, cGreen1, cBlue1);
            end;
          clBlue:
            begin
              cBlue1 := $FF;
              cGreen1 := Round($FF * aIdx / aMaxIdx);
              cRed1 := Round($FF * aIdx / aMaxIdx);
              if cBlue1 > 255 then
                cBlue1 := 255;
              if cGreen1 > 255 then
                cGreen1 := 255;
              if cRed1 > 255 then
                cRed1 := 255;
              Color := RGB(cRed1, cGreen1, cBlue1);
            end;
        else
          //Color := ColorAdjustLuma(aGroundColor, aIdx / aMaxIdx, false); //Delphi2010
          cBlue1 := GetBValue(aGroundColor);
          cGreen1 := GetGValue(aGroundColor);
          cRed1 := GetRValue(aGroundColor);
          cBlue1 := cBlue1 + Round($FF * aIdx / aMaxIdx);
          if cBlue1 > 255 then
            cBlue1 := 255;
          cGreen1 := cGreen1 + Round($FF * aIdx / aMaxIdx);
          if cGreen1 > 255 then
            cGreen1 := 255;
          cRed1 := cRed1 + Round($FF * aIdx / aMaxIdx);
          if cRed1 > 255 then
            cRed1 := 255;
          Color := RGB(cRed1, cGreen1, cBlue1);
        end;
      end;
    1:begin //weisser Hintergrund
        case aGroundColor of
          clRed:
            begin
              cBlue := Round($FF * aIdx / aMaxIdx);
              cGreen := Round($FF * aIdx / aMaxIdx);
              cRed := $FF;
              //Color := (cBlue shl 16) + (cGreen shl 8) + cRed;
              Color := RGB(cRed, cGreen, cBlue);
            end;
          clGreen:
            begin
              cBlue := Round($FF * aIdx / aMaxIdx);
              cGreen := $FF;
              cRed := Round($FF * aIdx / aMaxIdx);
              Color := RGB(cRed, cGreen, cBlue);
            end;
        end;
      end;
  end;
  Result := Color;
end;
{------------------------------------------------------------------------------}

function TXYGraph.CheckDecimals(aD: Double): integer;
//Dezimalstellen der Achsenbeschriftung berechnen
begin
  if aD >= 1000 then
    result := 0 else
  if aD >= 100 then
    result := 1 else
  if aD >= 20 then
    result := 1 else
  if aD >= 1 then
    result := 2 else
  if aD >= 0.1 then
    result := 3 else
  if aD >= 0.01 then
    result := 4 else
    result := 5;
end;
{------------------------------------------------------------------------------}

function TXYGraph.SetMainTicks(aMin, aMax: double): integer;
var
  Delta, Dummy: Double;
  iTicks: integer;
begin
  Delta := aMax - aMin;
  if Delta > 1000 then
    Delta := 1000
  else
  if Delta > 500 then
    Delta := 200
  else
  if Delta > 100 then
    Delta := 50
  else
  if Delta > 50 then
    Delta := 20
  else
  if Delta > 10 then
    Delta := 5
  else
  if Delta > 5 then
    Delta := 1
  else
  if Delta > 1 then
    Delta := 1
  else
    Delta := 1;
  iTicks := 0;
  Dummy := aMin;
  while (Dummy < aMax) and (iTicks < 1000) do
  begin
    Dummy := Dummy + Delta;
    inc(iTicks);
  end;
  Result := iTicks;
end;
{------------------------------------------------------------------------------}




{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}

constructor TXYToolBar.Create(AOwner: TComponent);

begin
  inherited Create(AOwner);
  Graph := TXYGraph(AOwner);
  Height := ciXYHeight + ciXYTopBtn + 8;
  BevelInner := bvNone;
  BevelOuter := bvNone;
  bExpanded := false;

  lblTitle   := TLabel.Create (self);
  lblTitle.Parent := self;
  lblTitle.Font.Style := lblTitle.Font.Style + [fsBold];
  lblTitle.Top := 2;
  lblTitle.Left := 20;
  lblTitle.Caption := 'Zoom';

  btnResize  := TSpeedButton.Create (self);
  btnResize.Parent := self;
  btnResize.Width := ciResizeBtnSize;
  btnResize.Height := ciResizeBtnSize;
  btnResize.Left := 2;
  btnResize.Top := 2;
  btnResize.OnClick := BtnResizeClicked;
  btnResize.NumGlyphs := 2;
  btnResize.Glyph.Handle := LoadBitmap (HInstance, 'XYBTNDOWN');

  btnExpand  := TSpeedButton.Create (self);
  btnExpand.Parent := self;
  btnExpand.Width := ciResizeBtnSize;
  btnExpand.Height := ciResizeBtnSize;
  btnExpand.Left := 20; //Width - 2 - 12;
  btnExpand.Top := 2;
  btnExpand.OnClick := BtnExpandClicked;
  btnExpand.NumGlyphs := 2;
  btnExpand.Glyph.Handle := LoadBitmap (HInstance, 'XYBTNRIGHT');
  //btnExpand.Glyph.LoadFromFile('c:\delphi\addons\xygraph\arrow_right.bmp');

  BtnRefresh := TSpeedButton.Create (self);
  BtnZoomOrg := TSpeedButton.Create (self);
  BtnZoomOut := TSpeedButton.Create (self);
  BtnZoomIn  := TSpeedButton.Create (self);
  BtnPanSmall := TSpeedButton.Create (self);
  PaintBtns;
end;
{------------------------------------------------------------------------------}

procedure TXYToolBar.PaintBtns;
var
  x,y, xLeft: integer;

begin
  case Graph.Positions.ToolBarAlign of
    alNone:begin
             btnExpand.Visible := false;
             btnResize.Visible := false;
             y := ciXYTopBtnNone;
             lblTitle.Visible := false;
           end;
  else
    btnExpand.Visible := true;
    btnResize.Visible := true;
    y := ciXYTopBtn;
  end;
  if bExpanded then
    btnExpand.Left := Graph.Positions.FXCurveTitleExp - 2 - ciResizeBtnSize
  else
    btnExpand.Left := Graph.Positions.FXCurveTitle - 2 - ciResizeBtnSize;

  x := ciXYLeftBtn;
  if Graph.pbShowZoom then
  begin
    with BtnZoomOrg do
    begin //% Zoom
      Parent := self;
      Left   := x;
      Top    := y;
      Height := ciXYHeight;
      Width  := ciXYHeight;
      NumGlyphs := 2;
      Glyph.Handle := LoadBitmap (HInstance, 'XYZOOMORG');
      ShowHint := true;
      Hint := 'Zoom all';
      OnClick := BtnZoomOrgClicked;
      Visible := true;
      x := x + Width + ciXYDistBtn;
    end;
    with BtnZoomOut do
    begin //Zoom kleiner
      Parent := self;
      Left   := x;
      Top    := y;
      Height := ciXYHeight;
      Width  := ciXYHeight;
      NumGlyphs := 2;
      Glyph.Handle := LoadBitmap (HInstance, 'XYZOOMOUT');
      ShowHint := true;
      Hint := 'Zoom out';
      OnClick := BtnZoomOutClicked;
      Visible := true;
      x := x + Width + ciXYDistBtn;
    end;
    with BtnZoomIn do
    begin //Zoom größer
      Parent := self;
      Left   := x;
      Top    := y;
      Height := ciXYHeight;
      Width  := ciXYHeight;
      NumGlyphs := 2;
      Glyph.Handle := LoadBitmap (HInstance, 'XYZOOMIN');
      ShowHint := true;
      Hint := 'Zoom in';
      OnClick := BtnZoomInClicked;
      Visible := true;
      x := x + Width + ciXYDistBtn;
    end;
    with BtnPanSmall do
    begin //auf Pan schalten
      Parent := self;
      Left   := x;
      Top    := y;
      Height := ciXYHeight;
      Width  := ciXYHeight;
      NumGlyphs := 2;
      GroupIndex := 100;
      Down := true;
      ShowHint := true;
      Hint := 'Pan';
      Glyph.Handle := LoadBitmap (HInstance, 'XYPAN');
      AllowAllUp := true;
      Visible := true;
      x := x + Width + ciXYDistBtn;
      OnClick := BtnPanSmallClicked;
    end;
  end else
  begin
    BtnZoomOrg.Visible := false;
    BtnZoomOut.Visible := false;
    BtnZoomIn.Visible := false;
    BtnPanSmall.Visible := false;
  end;

  if x > 0 then
  begin
    Width := x + 3;
    case Graph.Positions.ToolBarAlign of
      alNone:begin
              Align := alNone;
              if Graph.pbShowFree then
                xLeft := Graph.Width - Graph.Positions.XAxisRight - 158 - x
              else
                xLeft := Graph.Width - Graph.Positions.XAxisRight - x;
              if Graph.pbShowMarker then
              begin
                Graph.MarkerBar.PaintBtns;
                xLeft := Graph.MarkerBar.Left  - x;
              end else
                Graph.MarkerBar.Parent := nil;
              Left := xLeft;
             end;
    else
    end;
    //BevelOuter := bvRaised;
    //Visible := true;
  end else
  begin
    Width := 0;
    //Visible := false;
  end;
  //Left := Graph.Width - Width - 2;
end;
{------------------------------------------------------------------------------}

destructor TXYToolBar.Destroy;
begin
  inherited Destroy;
end;
{------------------------------------------------------------------------------}

procedure TXYToolBar.SetVisible (bVal : Boolean);
begin
  if bVisible <> bVal then
  begin
    bVisible := bVal;
    Refresh;
  end;
end;
{------------------------------------------------------------------------------}

procedure TXYToolBar.SetExpanded(bVal : Boolean);
begin
  if bExpanded <> bVal then
  begin
    bExpanded := bVal;
    if bExpanded then
    begin //breite Legende
      Graph.Positions.XGraphLeft := Graph.Positions.XCurveTitleExp;
    end else
    begin //schmale Legende
      Graph.Positions.XGraphLeft := Graph.Positions.XCurveTitle;
    end;
    PaintBtns;
  end;
end;
{------------------------------------------------------------------------------}

procedure TXYToolBar.BtnRefreshClicked(Sender: TObject);
begin
  if Assigned(Graph.FOnRefresh) then Graph.FOnRefresh(Self);
  Graph.Refresh;
end;
{------------------------------------------------------------------------------}

procedure TXYToolBar.BtnZoomOrgClicked(Sender: TObject);
begin
  Graph.Reset;
end;
{------------------------------------------------------------------------------}

procedure TXYToolBar.BtnZoomOutClicked(Sender: TObject);
begin
  Graph.ZoomOut;
end;
{------------------------------------------------------------------------------}

procedure TXYToolBar.BtnZoomInClicked(Sender: TObject);
begin
  Graph.ZoomIn;
end;
{------------------------------------------------------------------------------}

procedure TXYToolBar.BtnResizeClicked(Sender: TObject);
begin
  bResized := not bResized;
  if bResized then
    Height := ciXYHeight
  else
    Height := ciXYHeight + ciXYTopBtn + 8;
end;
{------------------------------------------------------------------------------}

procedure TXYToolBar.BtnExpandClicked(Sender: TObject);
begin
  bExpanded := not bExpanded;
  if bExpanded then
  begin //breite Legende
    Graph.Positions.XGraphLeft := Graph.Positions.XCurveTitleExp;
  end else
  begin //schmale Legende
    Graph.Positions.XGraphLeft := Graph.Positions.XCurveTitle;
    Graph.MarkerBar.Resized := false;
  end;
  PaintBtns;
end;
{------------------------------------------------------------------------------}

procedure TXYToolBar.BtnPanSmallClicked(Sender: TObject);
begin
  inherited Click;
  Graph.MarkerBar.BtnAbsMkrSmall.Down := false;
  Graph.MarkerBar.BtnRelMkrSmall.Down := false;
  PaintBtns;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}

constructor TCurveTitleBar.Create(AOwner: TComponent);

begin
  inherited Create(AOwner);
  Graph := TXYGraph(AOwner);
  Height := ciXYHeight + (2 * ciXYTopBtn);
  BevelInner := bvNone;
  BevelOuter := bvNone;

  lblTitle   := TLabel.Create (self);
  lblTitle.Parent := self;
  lblTitle.Font.Style := lblTitle.Font.Style + [fsBold];
  lblTitle.Top := 2;
  lblTitle.Left := 20;
  lblTitle.Caption := 'Legende';

  btnResize  := TSpeedButton.Create (self);
  btnResize.Parent := self;
  btnResize.Caption := '';
  btnResize.Width := ciResizeBtnSize;
  btnResize.Height := ciResizeBtnSize;
  btnResize.Left := 2;
  btnResize.Top := 2;
  btnResize.NumGlyphs := 2;
  btnResize.Glyph.Handle := LoadBitmap (HInstance, 'XYBTNDOWN');

  BtnAllOn   := TSpeedButton.Create (self);
  BtnAllOff  := TSpeedButton.Create (self);
  //PaintBtns;
end;
{------------------------------------------------------------------------------}

procedure TCurveTitleBar.PaintBtns;
var
  x: integer;
begin
  x := ciXYLeftBtn;
  if Graph.pbShowCurveTitles then
  begin
    with BtnAllOn do
    begin //alle Kurven enablen
      Parent := self;
      Left   := x;
      Top    := ciXYTopBtn;
      Height := ciXYHeight;
      Width  := ciXYHeight;
      NumGlyphs := 1;
      Glyph.Handle := LoadBitmap (HInstance, 'XYALLON');
      ShowHint := true;
      Hint := 'Show all curves';
      OnClick := BtnAllOnClicked;
      Visible := true;
      x := x + Width + ciXYDistBtn;
    end;
    with BtnAllOff do
    begin //alle Kurven disablen
      Parent := self;
      Left   := x;
      Top    := ciXYTopBtn;
      Height := ciXYHeight;
      Width  := ciXYHeight;
      NumGlyphs := 1;
      Glyph.Handle := LoadBitmap (HInstance, 'XYALLOFF');
      ShowHint := true;
      Hint := 'Show no curves';
      OnClick := BtnAllOffClicked;
      Visible := true;
      x := x + Width + ciXYDistBtn;
    end;

  end else
  begin
    //Graph.CurveTitleBar.Visible := false;
    //BtnAllOn.Visible := false;
    //BtnAllOff.Visible := false;
  end;
  if x > 0 then
  begin
    Width := x + 3;

    //Visible := true;
  end else
  begin
    Width := 0;
    //Visible := false;
  end;
  //Left := Graph.Width - Width - 2;
end;
{------------------------------------------------------------------------------}

destructor TCurveTitleBar.Destroy;
begin
  inherited Destroy;
end;
{------------------------------------------------------------------------------}

procedure TCurveTitleBar.SetVisible (bVal : Boolean);
begin
  if bVisible <> bVal then
  begin
    bVisible := bVal;
    Refresh;
  end;
end;
{------------------------------------------------------------------------------}

procedure TCurveTitleBar.BtnAllOnClicked(Sender: TObject);
var
  iGroup, iCrv: integer;
begin
  with Graph do
  begin
    for iGroup := 0 to Pred(FCurveGroupList.Count) do
    begin
      FCurveGroup := FCurveGroupList.Items[iGroup];
      FCurveGroup.Enabled := true;
    end;
    for iCrv := 0 to Pred(FCurveList.Count) do
    begin
      FCurve := FCurveList.Items[iCrv];
      FCurve.Enabled := true;
    end;
    paint; //BG070308: Neu malen
  end;
end;
{------------------------------------------------------------------------------}

procedure TCurveTitleBar.BtnAllOffClicked(Sender: TObject);
var
  iGroup, iCrv: integer;
begin
  with Graph do
  begin
    for iGroup := 0 to Pred(FCurveGroupList.Count) do
    begin
      FCurveGroup := FCurveGroupList.Items[iGroup];
      FCurveGroup.Enabled := false;
    end;
    for iCrv := 0 to Pred(FCurveList.Count) do
    begin
      FCurve := FCurveList.Items[iCrv];
      FCurve.Enabled := false;
    end;
    paint; //BG070308: Neu malen
  end;
end;
{------------------------------------------------------------------------------}



{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}

constructor TMarkerBar.Create(AOwner: TComponent);

begin
  inherited Create(AOwner);
  Graph := TXYGraph(AOwner);
  Height := ciXYHeight;
  BevelInner := bvNone;
  BevelOuter := bvNone;

  bResized := false;

  lblTitle   := TLabel.Create (self);
  lblTitle.Parent := self;
  lblTitle.Font.Style := lblTitle.Font.Style + [fsBold];
  lblTitle.Top := 2;
  lblTitle.Left := 20;
  lblTitle.Caption := 'Marker';

  btnResize  := TSpeedButton.Create (self);
  btnResize.Parent := self;
  btnResize.Width := ciResizeBtnSize;
  btnResize.Height := ciResizeBtnSize;
  btnResize.Left := 2;
  btnResize.Top := 2;
  btnResize.OnClick := BtnResizeClicked;
  btnResize.NumGlyphs := 2;
  btnResize.Glyph.Handle := LoadBitmap (HInstance, 'XYBTNDOWN');

  {
  btnMarkerVert1 := TSpeedButton.Create (self);
  btnMarkerVert1.Parent := self;
  btnMarkerVert1.Width := ciResizeBtnSize;
  btnMarkerVert1.Height := ciResizeBtnSize;
  btnMarkerVert1.Left := 120 - 2 * (ciResizeBtnSize) - 2;
  btnMarkerVert1.Top := 2;
  btnMarkerVert1.GroupIndex := 100;
  btnMarkerVert1.AllowAllUp := true;
  btnMarkerVert1.OnClick := btnMarkerVertClicked;
  btnMarkerVert2 := TSpeedButton.Create (self);
  btnMarkerVert2.Parent := self;
  btnMarkerVert2.Width := ciResizeBtnSize;
  btnMarkerVert2.Height := ciResizeBtnSize;
  btnMarkerVert2.Left := 122 - ciResizeBtnSize - 4;
  btnMarkerVert2.Top := 2;
  btnMarkerVert2.GroupIndex := 100;
  btnMarkerVert2.AllowAllUp := true;
  btnMarkerVert2.OnClick := btnMarkerVertClicked;
  }

  BtnAbsMkrSmall := TSpeedButton.Create (self);
  lblAbsMkrSmall := TLabel.Create (self);
  bvAbsMkrSmall := TBevel.Create (self);
  bvRelMkrSmall := TBevel.Create (self);
  seAbsMkr := TSpinEdit.Create (self);
  BtnRelMkrSmall := TSpeedButton.Create (self);
  lblRelMkrSmall := TLabel.Create (self);
  seRelMkr := TSpinEdit.Create (self);
  PaintBtns;
end;
{------------------------------------------------------------------------------}

procedure TMarkerBar.PaintBtns;
var
  x, y: integer;
  iPosY: integer;
begin
  case Graph.Positions.ToolBarAlign of
    alNone:begin
             Width := 400;
             y := ciXYTopBtnNone;
             btnResize.Visible := false;
             iPosY := 1;
             lblTitle.Visible := false;
           end;
  else
    y := ciXYTopBtn;
    btnResize.Visible := true;
    iPosY := 2;
  end;
  x := ciXYLeftBtn;
  if Graph.pbShowMarker then
  begin
    with BtnAbsMkrSmall do
    begin //auf Abs-Marker
      Parent := self;
      Left   := x;
      Top    := y;
      Height := ciXYHeight;
      Width := ciXYHeight;
      NumGlyphs := 2;
      GroupIndex := -1;
      Glyph.Handle := LoadBitmap (HInstance, 'XYABSMKR');
      ShowHint := true;
      Hint := 'Marker absolut';
      OnClick := BtnAbsMkrClicked;
      AllowAllUp := true;
      Visible := true;
      x := x + Width + 2;
    end;

    with bvAbsMkrSmall do
    begin
      Parent := self;
      Left   := x;
      Top    := y;
      Height := ciXYHeight;
      Width  := 120;
      Visible := true;
    end;
    with lblAbsMkrSmall do
    begin
      Parent := self;
      Left   := x + 2;
      Top    := y + 3;
      AutoSize := false;
      Width := 116;
      ShowHint := true;
      Hint := '';
      Caption := 'Abs: ' + csMkrEmpty;
      Visible := true;
      x := x + Width + ciXYDistBtn + 4;
    end;
    with seAbsMkr do
    begin
      Parent := self;
      Left   := x;
      Top    := y;
      Width  := 38;
      Height := ciXYHeight;
      MinValue := 1;
      MaxValue := 2;
      Value := 1;
      ShowHint := true;
      Hint := 'Curve No. Marker absolut';
      OnChange := seAbsMkrChange;
      Visible := true;
      x := x + Width + ciXYDistBtn;
    end;

    case Graph.Positions.ToolBarAlign of
      alNone:begin
             end
    else
      x := ciXYLeftBtn;
    end;
    with BtnRelMkrSmall do
    begin
      Parent := self;
      Left   := x;
      Top    := iPosY * y;
      Height := ciXYHeight;
      Width  := ciXYHeight;
      NumGlyphs := 2;
      GroupIndex := -1;
      Glyph.Handle := LoadBitmap (HInstance, 'XYRELMKR');
      ShowHint := true;
      Hint := 'Marker relativ';
      OnClick := BtnRelMkrClicked;
      AllowAllUp := true;
      Visible := true;
      x := x + Width + ciXYDistBtn;
    end;

    with bvRelMkrSmall do
    begin
      Parent := self;
      Left   := x;
      Top    := iPosY * y;
      Height := ciXYHeight;
      Width  := 120;
      Visible := true;
    end;
    with lblRelMkrSmall do
    begin
      Parent := self;
      Left   := x + 2;
      Top    := iPosY * y + 3;
      AutoSize := false;
      Width := 116;
      ShowHint := true;
      Hint := '';
      Caption := 'Rel: ' + csMkrEmpty;
      Visible := true;
      x := x + Width + ciXYDistBtn + 4;
    end;
    with seRelMkr do
    begin
      Parent := self;
      Left   := x;
      Width := 38;
      Top    := iPosY * y;
      Height := ciXYHeight;
      MinValue := 1;
      MaxValue := 2;
      Value := 1;
      ShowHint := true;
      Hint := 'Curve No. Marker relativ';
      OnChange := seRelMkrChange;
      Visible := true;
      x := x + Width + ciXYDistBtn;
    end;
  end else
  begin
    BtnAbsMkrSmall.Visible := false;
    bvAbsMkrSmall.Visible := false;
    lblAbsMkrSmall.Visible := false;
    seAbsMkr.Visible := false;
    BtnRelMkrSmall.Visible := false;
    bvRelMkrSmall.Visible := false;
    lblRelMkrSmall.Visible := false;
    seRelMkr.Visible := false;
  end;

  if x > 0 then
  begin
    Width := x + 3;
    case Graph.Positions.ToolBarAlign of
      alNone:begin
              Align := alNone;
              if Graph.pbShowFree then
                Left := Graph.Width - Graph.Positions.XAxisRight - 158 - x
              else
                Left := Graph.Width - Graph.Positions.XAxisRight - x;

             end;
    else
    end;
  end else
  begin
    Width := 0;
  end;
  //Left := Graph.Width - Width - 2;
end;
{------------------------------------------------------------------------------}

destructor TMarkerBar.Destroy;
begin
  inherited Destroy;
end;
{------------------------------------------------------------------------------}

procedure TMarkerBar.SetVisible (bVal : Boolean);
begin
  if bVisible <> bVal then
  begin
    bVisible := bVal;
    Refresh;
  end;
end;
{------------------------------------------------------------------------------}

procedure TMarkerBar.SetResized(bVal : Boolean);
begin
  bResized := bVal;
  if bResized then
  begin
    Height := ciXYHeight + (2 * ciXYTopBtn) + 10;
    Graph.XYToolBar.Expanded := true;
  end else
    Height := ciXYHeight;
end;
{------------------------------------------------------------------------------}

procedure TMarkerBar.BtnAbsMkrClicked(Sender: TObject);
//absoluten Marker setzen
begin
  Graph.piActMkrNo := 0;
  Graph.AbsMkr.bVisible := true;
  Graph.ShowMkr (Graph.AbsMkr);
  seAbsMkr.MaxValue := Graph.FCurveList.Count;
  BtnRelMkrSmall.Down := false;
  Graph.XYToolBar.BtnPanSmall.Down := false;
end;
{------------------------------------------------------------------------------}

procedure TMarkerBar.BtnRelMkrClicked(Sender: TObject);
//relativen Marker setzen
begin
  Graph.piActMkrNo := 1;
  Graph.RelMkr.bVisible := true;
  Graph.ShowMkr (Graph.RelMkr);
  seRelMkr.MaxValue := Graph.FCurveList.Count;
  BtnAbsMkrSmall.Down := false;
  Graph.XYToolBar.BtnPanSmall.Down := false;
end;
{------------------------------------------------------------------------------}

procedure TMarkerBar.seAbsMkrChange(Sender: TObject);
begin
  Graph.AbsMkr.iCrv := seAbsMkr.Value - 1;
end;
{------------------------------------------------------------------------------}

procedure TMarkerBar.seRelMkrChange(Sender: TObject);
begin
  Graph.RelMkr.iCrv := seRelMkr.Value - 1;
end;
{------------------------------------------------------------------------------}

procedure TMarkerBar.BtnResizeClicked(Sender: TObject);
begin
  bResized := not bResized;
  if bResized then
  begin
    Height := ciXYHeight + (2 * ciXYTopBtn) + 10;
    Graph.XYToolBar.Expanded := true;
    seAbsMkr.MaxValue := Graph.FCurveList.Count;
    seRelMkr.MaxValue := Graph.FCurveList.Count;
  end else
    Height := ciXYHeight;
  if bResized then
    Graph.XYToolBar.Expanded := true;
end;
{------------------------------------------------------------------------------}

procedure TMarkerBar.btnMarkerVertClicked(Sender: TObject);
begin

end;
{------------------------------------------------------------------------------}

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}

constructor TFreeMarkerBar.Create(AOwner: TComponent);

begin
  inherited Create(AOwner);
  Graph := TXYGraph(AOwner);
  Top := 5;
  Width := 142;
  Height := 45;
  Color := clRed;
  BevelInner := bvNone;
  BevelOuter := bvRaised;

  lblFree := TLabel.Create(self);
  bvlblFree := TBevel.Create(self);
  PaintBtns;
end;
{------------------------------------------------------------------------------}

procedure TFreeMarkerBar.PaintBtns;
var
  x: integer;
begin
  Left := Graph.Width - Graph.Positions.XAxisRight - 142;

  x := 0;
  if Graph.bShowFree then
  begin
    //x := x + ciXYDistBtn;

    with bvlblFree do
    begin
      Parent := self;
      Left   := x;
      Top    := 0;
      Height := ciXYHeight;
      Width := 140;
      Visible := true;
    end;

    with lblFree do
    begin //der freie Text
      Parent := self;
      Left   := x + 2;
      Top    := 4;
      AutoSize := false;
      Width := 136;
      ShowHint := true;
      Visible := true;
      Hint := '';
  //    Caption := csMkrEmpty + ': ' + csMkrEmpty;
      x := x + Width + ciXYDistBtn + 4;
    end;
  end else
  begin
    bvlblFree.Visible := false;
    lblFree.Visible := false;
  end;
  if x > 0 then
  begin
    Width := x + 3;
    //Visible := true;
  end else
  begin
    Width := 0;
    //Visible := false;
  end;
  //Left := Graph.Width - Width - 2;
end;
{------------------------------------------------------------------------------}

destructor TFreeMarkerBar.Destroy;
begin
  inherited Destroy;
end;
{------------------------------------------------------------------------------}

procedure TFreeMarkerBar.SetVisible (bVal : Boolean);
begin
  if bVisible <> bVal then
  begin
    bVisible := bVal;
    Refresh;
  end;
end;
{------------------------------------------------------------------------------}


initialization
end.


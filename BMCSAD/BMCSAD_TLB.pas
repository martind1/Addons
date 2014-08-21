unit BMCSAD_TLB;

{ Diese Datei beinhaltet Pascal Deklarationen die aus einer Typenbibliothek
  importiert wurden. Diese Datei wird bei jedem neuen Import oder
  Aktualisieren der Typenbibliothek neu geschrieben.  Änderungen in dieser
  Datei werden wärend des Aktualisierungsprozesse ignoriert. }

{ BMCSAD Object Library 3.2 }
{ Version 3.2 }

interface

uses Windows, ActiveX, Classes, Graphics, OleCtrls, StdVCL;

const
  LIBID_BMCSAD: TGUID = '{3BAE3AB3-424D-11D2-9610-006097B81D3E}';

const

{ NvxAccessType }

  readAcc = 0;
  writeAcc = 1;
  exclusiveAcc = 2;
  adminAcc = 3;

{ NvxChannelType }

  chaUnknown = 0;
  chaAnalogIn = 1;
  chaAnalogOut = 2;
  chaDigital = 3;
  chaLine = 4;
  chaFormula = 5;
  chaDigitalIn = 6;
  chaDigitalOut = 7;
  chaDigitalFolder = 8;

{ NvxStoreType }

  storeNone = 0;
  storeDiscrete = 1;
  storeAverage = 2;
  storeMinimum = 4;
  storeMaximum = 8;
  storeRms = 16;

{ NvxScanState }

  stateUnknown = 0;
  stateReady = 1;
  statePreparing = 2;
  stateBeforeTrigger = 3;
  stateAfterTrigger = 4;
  stateBusy = 5;
  stateRunning = 6;

{ NvxLogLevel }

  levInfo = 0;
  levWarning = 1;
  levError = 2;

{ NvxServerType }

  sysManager = 0;
  logManager = 1;
  userManager = 2;

{ NvxTriggerMode }

  trUnknown = 0;
  trNone = 1;
  trPositive = 2;
  trNegative = 3;
  trInside = 4;
  trOutside = 5;
  trDigital1 = 6;
  trDigital2 = 7;

const

{ Komponentenklassen-GUIDs }
  Class_BMCSADX: TGUID = '{3BAE3AB6-424D-11D2-9610-006097B81D3E}';

type

{ Forward-Deklarationen: Interfaces }
  INvxUserManager = interface;
  INvxLogDB = interface;
  INvxChannel = interface;
  INvxAnalogChannel = interface;
  INvxDigitalChannel = interface;
  INvxFormulaChannel = interface;
  INvxTriggerChannel = interface;
  INvxSignal = interface;
  INvxServer = interface;
  INvxFile = interface;
  _DBMCSADX = dispinterface;
  _DBMCSADXEvents = dispinterface;

{ Forward-Deklarationen: CoClasses }
  BMCSADX = _DBMCSADX;

{ Forward-Deklarationen }
  NvxAccessType = Integer;
  NvxChannelType = Integer;
  NvxStoreType = Integer;
  NvxScanState = Integer;
  NvxLogLevel = Integer;
  NvxServerType = Integer;
  NvxTriggerMode = Integer;

{ Interface to the User Manager }

  INvxUserManager = interface(IUnknown)
    ['{578C54F4-4E05-11D1-A92A-DE82F7000000}']
    function CountUsers: Integer; safecall;
    procedure GetUser(index: Integer; var userName: WideString; var access: NvxAccessType); safecall;
    procedure AddUser(const userName, password: WideString; access: NvxAccessType); safecall;
    procedure SetPassword(const admin, adminpass, userName, newpass: WideString); safecall;
    procedure SetAccess(const admin, adminpass: WideString; access: NvxAccessType); safecall;
  end;

{ Interface to the message database }

  INvxLogDB = interface(IUnknown)
    ['{141C3040-917C-11D1-953E-006097B81D3E}']
    procedure LogMessage(cha: Integer; level: NvxLogLevel; const msg: WideString); safecall;
    procedure CountMessages(cha: Integer; out lastId, count: Integer); safecall;
    procedure ReadMessage(cha, msgId: Integer; var time_h, time_l: Integer; var level: NvxLogLevel; var msg: WideString); safecall;
  end;

{ Basic interface to a single channel }

  INvxChannel = interface(IUnknown)
    ['{578C54F5-4E05-11D1-A92A-DE82F7000000}']
    procedure Set_Name(const Value: WideString); safecall;
    function Get_Name: WideString; safecall;
    procedure Set_GroupName(const Value: WideString); safecall;
    function Get_GroupName: WideString; safecall;
    procedure Set_Comment(const Value: WideString); safecall;
    function Get_Comment: WideString; safecall;
    function PhysName: WideString; safecall;
    procedure SetDefaultScaling(min, max: Double); safecall;
    procedure GetDefaultScaling(var min, max: Double); safecall;
    procedure SetUsing(format, width, frac, opt: Integer); safecall;
    procedure GetUsing(var format, width, frac, opt: Integer); safecall;
    procedure SetScanSettings(store: NvxStoreType; ratio: Integer); safecall;
    procedure GetScanSettings(var store: NvxStoreType; var ratio: Integer); safecall;
    procedure Set_Value(Value: Double); safecall;
    function Get_Value: Double; safecall;
    procedure Set_DigitalValue(Value: Integer); safecall;
    function Get_DigitalValue: Integer; safecall;
    function ChannelType: NvxChannelType; safecall;
    property Name: WideString read Get_Name write Set_Name;
    property GroupName: WideString read Get_GroupName write Set_GroupName;
    property Comment: WideString read Get_Comment write Set_Comment;
    property Value: Double read Get_Value write Set_Value;
    property DigitalValue: Integer read Get_DigitalValue write Set_DigitalValue;
  end;

{ Interface to an analog channel }

  INvxAnalogChannel = interface(IUnknown)
    ['{578C54F6-4E05-11D1-A92A-DE82F7000000}']
    function RangeLimitsCount: Integer; safecall;
    procedure GetRangeLimits(index: Integer; var min, max: Double); safecall;
    procedure Set_Range(Value: Integer); safecall;
    function Get_Range: Integer; safecall;
    procedure SetRawRange(min, max: Double); safecall;
    procedure GetRawLimits(var min, max: Double); safecall;
    function GetRawUnit: WideString; safecall;
    procedure Set_SensorUnit(const Value: WideString); safecall;
    function Get_SensorUnit: WideString; safecall;
    function RawToSensorMaxCount: Integer; safecall;
    function RawToSensorCount: Integer; safecall;
    procedure SetRawToSensor(index: Integer; raw, phys: Double); safecall;
    procedure GetRawToSensor(index: Integer; var raw, phys: Double); safecall;
    function RawToSensor(raw: Double): Double; safecall;
    function SensorToRaw(phys: Double): Double; safecall;
    property Range: Integer read Get_Range write Set_Range;
    property SensorUnit: WideString read Get_SensorUnit write Set_SensorUnit;
  end;

{ Interface to a digital channel }

  INvxDigitalChannel = interface(IUnknown)
    ['{87559C22-47BB-11D2-9613-006097B81D3E}']
    procedure Set_Direction(Value: Integer); safecall;
    function Get_Direction: Integer; safecall;
    property Direction: Integer read Get_Direction write Set_Direction;
  end;

{ Interface to a formula channel }

  INvxFormulaChannel = interface(IUnknown)
    ['{578C54F7-4E05-11D1-A92A-DE82F7000000}']
    procedure Set_Formula(const Value: WideString); safecall;
    function Get_Formula: WideString; safecall;
    procedure Set_FormulaUnit(const Value: WideString); safecall;
    function Get_FormulaUnit: WideString; safecall;
    property Formula: WideString read Get_Formula write Set_Formula;
    property FormulaUnit: WideString read Get_FormulaUnit write Set_FormulaUnit;
  end;

{ Interface to a trigger channel }

  INvxTriggerChannel = interface(IUnknown)
    ['{87559C20-47BB-11D2-9613-006097B81D3E}']
    function SupportsTrigger(mode: NvxTriggerMode): WordBool; safecall;
    procedure SetTrigger(mode: NvxTriggerMode; tp1, tp2, tp3, tp4: Double); safecall;
    procedure GetTrigger(var mode: NvxTriggerMode; var tp1, tp2, tp3, tp4: Double); safecall;
    function SupportsTriggerID(var mode: TGUID): WordBool; safecall;
    procedure SetTriggerID(var mode: TGUID; tp1, tp2, tp3, tp4: Double); safecall;
    procedure GetTriggerID(var mode: TGUID; var tp1, tp2, tp3, tp4: Double); safecall;
  end;

{ Basic interface to a single signal }

  INvxSignal = interface(IUnknown)
    ['{B11D9B40-3E5B-11D2-960B-006097B81D3E}']
    procedure Set_Name(const Value: WideString); safecall;
    function Get_Name: WideString; safecall;
    procedure Set_GroupName(const Value: WideString); safecall;
    function Get_GroupName: WideString; safecall;
    procedure Set_Comment(const Value: WideString); safecall;
    function Get_Comment: WideString; safecall;
    procedure Set_LineName(index: Integer; const Value: WideString); safecall;
    function Get_LineName(index: Integer): WideString; safecall;
    procedure Set_LineGroupName(index: Integer; const Value: WideString); safecall;
    function Get_LineGroupName(index: Integer): WideString; safecall;
    procedure Set_LineComment(index: Integer; const Value: WideString); safecall;
    function Get_LineComment(index: Integer): WideString; safecall;
    procedure Set_xStart(Value: Double); safecall;
    function Get_xStart: Double; safecall;
    procedure Set_xEnd(Value: Double); safecall;
    function Get_xEnd: Double; safecall;
    procedure Set_xDelta(Value: Double); safecall;
    function Get_xDelta: Double; safecall;
    procedure Set_xUnit(const Value: WideString); safecall;
    function Get_xUnit: WideString; safecall;
    procedure xSetUsing(format, width, frac, opt: Integer); safecall;
    procedure xGetUsing(var format, width, frac, opt: Integer); safecall;
    procedure Set_yMin(Value: Double); safecall;
    function Get_yMin: Double; safecall;
    procedure Set_yMax(Value: Double); safecall;
    function Get_yMax: Double; safecall;
    procedure Set_yDefaultMin(Value: Double); safecall;
    function Get_yDefaultMin: Double; safecall;
    procedure Set_yDefaultMax(Value: Double); safecall;
    function Get_yDefaultMax: Double; safecall;
    procedure Set_yDelta(Value: Double); safecall;
    function Get_yDelta: Double; safecall;
    procedure Set_yUnit(const Value: WideString); safecall;
    function Get_yUnit: WideString; safecall;
    procedure ySetUsing(format, width, frac, opt: Integer); safecall;
    procedure yGetUsing(var format, width, frac, opt: Integer); safecall;
    procedure Set_ScanStart(Value: Double); safecall;
    function Get_ScanStart: Double; safecall;
    function SampleCount: Integer; safecall;
    procedure ScaleX(xStart, xEnd: Double; px: Integer); safecall;
    procedure ScaleY(yMin, yMax: Double; py: Integer); safecall;
    procedure ResetDataPosition; safecall;
    function GetNextScaled(out min, max: Integer): WordBool; safecall;
    function GetNextScaledDigital(out min, max: Integer): WordBool; safecall;
    procedure Unscale; safecall;
    procedure Set_NextSample(Value: Double); safecall;
    function Get_NextSample: Double; safecall;
    procedure Set_NextDigitalSample(Value: Integer); safecall;
    function Get_NextDigitalSample: Integer; safecall;
    function GetSampleAt(time: Double): Double; safecall;
    function GetSampleAtOffset(offset: Integer): Double; safecall;
    function GetDigitalSampleAt(time: Double): Integer; safecall;
    function GetDigitalSampleAtOffset(offset: Integer): Integer; safecall;
    function IsAnalog: WordBool; safecall;
    function IsDigital: WordBool; safecall;
    property Name: WideString read Get_Name write Set_Name;
    property GroupName: WideString read Get_GroupName write Set_GroupName;
    property Comment: WideString read Get_Comment write Set_Comment;
    property LineName[index: Integer]: WideString read Get_LineName write Set_LineName;
    property LineGroupName[index: Integer]: WideString read Get_LineGroupName write Set_LineGroupName;
    property LineComment[index: Integer]: WideString read Get_LineComment write Set_LineComment;
    property xStart: Double read Get_xStart write Set_xStart;
    property xEnd: Double read Get_xEnd write Set_xEnd;
    property xDelta: Double read Get_xDelta write Set_xDelta;
    property xUnit: WideString read Get_xUnit write Set_xUnit;
    property yMin: Double read Get_yMin write Set_yMin;
    property yMax: Double read Get_yMax write Set_yMax;
    property yDefaultMin: Double read Get_yDefaultMin write Set_yDefaultMin;
    property yDefaultMax: Double read Get_yDefaultMax write Set_yDefaultMax;
    property yDelta: Double read Get_yDelta write Set_yDelta;
    property yUnit: WideString read Get_yUnit write Set_yUnit;
    property ScanStart: Double read Get_ScanStart write Set_ScanStart;
    property NextSample: Double read Get_NextSample write Set_NextSample;
    property NextDigitalSample: Integer read Get_NextDigitalSample write Set_NextDigitalSample;
  end;

{ Interface to a server }

  INvxServer = interface(IUnknown)
    ['{87559C21-47BB-11D2-9613-006097B81D3E}']
    function SetOnline(var ParMatch: WordBool): WordBool; safecall;
    procedure SetOffline; safecall;
    function IsOnline: WordBool; safecall;
    function LockServer(var IsOnline, ParMatch: WordBool): WordBool; safecall;
    procedure UnlockServer; safecall;
    procedure SaveConfig; safecall;
    procedure LoadConfig; safecall;
    procedure SaveConfigAs(const str: WideString); safecall;
    procedure LoadConfigFrom(const str: WideString); safecall;
    procedure StartScan; safecall;
    procedure StopScan; safecall;
    procedure EnterScanMode; safecall;
    procedure LeaveScanMode; safecall;
    function ScanState: NvxScanState; safecall;
    function ScanNumber: Integer; safecall;
    function ScanningSince: Double; safecall;
    function Remaining: Double; safecall;
    procedure Set_Scantime(Value: Double); safecall;
    function Get_Scantime: Double; safecall;
    function MinScantime: Double; safecall;
    function MaxScantime: Double; safecall;
    procedure Set_Duration(Value: Double); safecall;
    function Get_Duration: Double; safecall;
    function MinDuration: Double; safecall;
    function MaxDuration: Double; safecall;
    procedure Set_LiveScantime(Value: Double); safecall;
    function Get_LiveScantime: Double; safecall;
    function MinLiveScantime: Double; safecall;
    function MaxLiveScantime: Double; safecall;
    procedure Set_LiveDuration(Value: Double); safecall;
    function Get_LiveDuration: Double; safecall;
    function MinLiveDuration: Double; safecall;
    function MaxLiveDuration: Double; safecall;
    procedure Set_Prehistory(Value: Double); safecall;
    function Get_Prehistory: Double; safecall;
    function MaxPrehistory: Double; safecall;
    procedure Set_StoreScans(Value: Integer); safecall;
    function Get_StoreScans: Integer; safecall;
    function MaxStorableScans: Integer; safecall;
    procedure Set_StopAfter(Value: Integer); safecall;
    function Get_StopAfter: Integer; safecall;
    procedure Set_ScanFileName(const Value: WideString); safecall;
    function Get_ScanFileName: WideString; safecall;
    procedure Set_ScanFilePath(const Value: WideString); safecall;
    function Get_ScanFilePath: WideString; safecall;
    procedure Set_LiveFileName(const Value: WideString); safecall;
    function Get_LiveFileName: WideString; safecall;
    function GetScanFileSize: Integer; safecall;
    procedure Set_Flags(Value: Integer); safecall;
    function Get_Flags: Integer; safecall;
    function ChannelCount: Integer; safecall;
    function Channel(index: Integer): INvxChannel; safecall;
    function Signal(index: Integer): INvxSignal; safecall;
    property Scantime: Double read Get_Scantime write Set_Scantime;
    property Duration: Double read Get_Duration write Set_Duration;
    property LiveScantime: Double read Get_LiveScantime write Set_LiveScantime;
    property LiveDuration: Double read Get_LiveDuration write Set_LiveDuration;
    property Prehistory: Double read Get_Prehistory write Set_Prehistory;
    property StoreScans: Integer read Get_StoreScans write Set_StoreScans;
    property StopAfter: Integer read Get_StopAfter write Set_StopAfter;
    property ScanFileName: WideString read Get_ScanFileName write Set_ScanFileName;
    property ScanFilePath: WideString read Get_ScanFilePath write Set_ScanFilePath;
    property LiveFileName: WideString read Get_LiveFileName write Set_LiveFileName;
    property Flags: Integer read Get_Flags write Set_Flags;
  end;

{ Basic interface to a single signal }

  INvxFile = interface(IUnknown)
    ['{B11D9B41-3E5B-11D2-960B-006097B81D3E}']
    procedure Open(const fileName: WideString); safecall;
    procedure Create(const fileName: WideString; sigCount, sampCount: Integer); safecall;
    procedure Close; safecall;
    function SignalCount: Integer; safecall;
    function Signal(index: Integer): INvxSignal; safecall;
  end;

{ Dispatch interface for BMCSAD Object Library 3.2 }

  _DBMCSADX = dispinterface
    ['{3BAE3AB4-424D-11D2-9610-006097B81D3E}']
    function CountServers(serverType: Integer): Integer; dispid 1;
    function AccessServer(serverType, serverID: Integer; const userName, password: WideString): IUnknown; dispid 2;
    function CreateFileObject: IUnknown; dispid 3;
    procedure AboutBox; dispid -552;
  end;

{ Event interface for BMCSADX Object Library 3.2 }

  _DBMCSADXEvents = dispinterface
    ['{3BAE3AB5-424D-11D2-9610-006097B81D3E}']
    procedure OnServerError(errCode, hint: Integer); dispid 1;
    procedure OnDeviceStateChanged; dispid 2;
    procedure OnDeviceSettingsChanged; dispid 3;
    procedure OnScanState(ScanState: NvxScanState; ScanNumber: Integer); dispid 10;
  end;

{ BMCSAD Object Library 3.2 }

  TBMCSADXOnServerError = procedure(Sender: TObject; errCode, hint: Integer) of object;
  TBMCSADXOnScanState = procedure(Sender: TObject; ScanState: NvxScanState; ScanNumber: Integer) of object;

  TBMCSADX = class(TOleControl)
  private
    FOnServerError: TBMCSADXOnServerError;
    FOnDeviceStateChanged: TNotifyEvent;
    FOnDeviceSettingsChanged: TNotifyEvent;
    FOnScanState: TBMCSADXOnScanState;
    FIntf: _DBMCSADX;
  protected
    procedure InitControlData; override;
    procedure InitControlInterface(const Obj: IUnknown); override;
  public
    function CountServers(serverType: Integer): Integer;
    function AccessServer(serverType, serverID: Integer; const userName, password: WideString): IUnknown;
    function CreateFileObject: IUnknown;
    procedure AboutBox;
    property ControlInterface: _DBMCSADX read FIntf;
  published
    property TabStop;
    property Align;
    property DragCursor;
    property DragMode;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property Visible;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnStartDrag;
    property OnServerError: TBMCSADXOnServerError read FOnServerError write FOnServerError;
    property OnDeviceStateChanged: TNotifyEvent read FOnDeviceStateChanged write FOnDeviceStateChanged;
    property OnDeviceSettingsChanged: TNotifyEvent read FOnDeviceSettingsChanged write FOnDeviceSettingsChanged;
    property OnScanState: TBMCSADXOnScanState read FOnScanState write FOnScanState;
  end;

procedure Register;

implementation

uses ComObj;

procedure TBMCSADX.InitControlData;
const
  CEventDispIDs: array[0..3] of Integer = (
    $00000001, $00000002, $00000003, $0000000A);
  CControlData: TControlData = (
    ClassID: '{3BAE3AB6-424D-11D2-9610-006097B81D3E}';
    EventIID: '{3BAE3AB5-424D-11D2-9610-006097B81D3E}';
    EventCount: 4;
    EventDispIDs: @CEventDispIDs;
    LicenseKey: nil;
    Flags: $00000000;
    Version: 300);
begin
  ControlData := @CControlData;
end;

procedure TBMCSADX.InitControlInterface(const Obj: IUnknown);
begin
  FIntf := Obj as _DBMCSADX;
end;

function TBMCSADX.CountServers(serverType: Integer): Integer;
begin
  Result := ControlInterface.CountServers(serverType);
end;

function TBMCSADX.AccessServer(serverType, serverID: Integer; const userName, password: WideString): IUnknown;
begin
  Result := ControlInterface.AccessServer(serverType, serverID, userName, password);
end;

function TBMCSADX.CreateFileObject: IUnknown;
begin
  Result := ControlInterface.CreateFileObject;
end;

procedure TBMCSADX.AboutBox;
begin
  ControlInterface.AboutBox;
end;


procedure Register;
begin
  RegisterComponents('ActiveX', [TBMCSADX]);
end;

end.

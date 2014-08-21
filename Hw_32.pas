{========================================================================}
{========================================================================}
{=================  TVicHW32  Shareware Version 3.0     =================}
{==========     Copyright (c) 1997 Victor I.Ishikeev              =======}
{========================================================================}
{==========             mailto:ivi.ufanet.ru                      =======}
{========================================================================}


{$R-} {$S-} {$D-} {$Q-}

unit HW_32;

interface

uses SysUtils,Classes,Windows;

{$i HW_Types.pas}

type

  TVicHw32 = class(TComponent)

  private

    fDriverName    : array[0..7] of Char;
    fSDriverName   : String; //26.02.12 [8];
    fPathToDriver  : array[0..128] of Char;
    fShortPathToDriver : array[0..12] of Char;
    hDrv           : THandle;
    hDll           : THandle;

    fWin95         : Boolean;
    fRegistry      : Boolean;
    fStarted       : Boolean;

    schSCManager   : THandle;

    fTerminated    : Boolean;

    fInterface     : DWORD;    // Isa, Eisa, etc....
    fBus           : DWORD;    // Bus number
    fPhysLoPart    : DWORD;    // Bus-relative address
    fPhysHiPart    : DWORD;    // Zero
    fTypeMem       : DWORD;    // 0 is memory, 1 is I/O
    fMemorySize    : DWORD;    // Length of section to map

    fMappedPointers  : array[1..MaxMappedAreas] of Pointer;
    fMappedSizes     : array[1..MaxMappedAreas] of DWORD;
    fMappedAddresses : array[1..MaxMappedAreas] of DWORD;
    fMappedAreas     : Word;

    fpLockedMemory   : Pointer;
    fMdl             : Pointer;

    fLocEvent        : THandle;

    fDebugCode       : DWORD;

    fHardAccess      : Boolean;

    fOpenDrive       : Boolean;

    fOnHwInterrupt   : TInterruptHandler;

    fIsIRQSet        : Boolean;
    fIRQNumber       : Byte;
    fMasked          : Boolean;
    fThreadId        : Cardinal;  //28.04.2012 THandle;
    fThreadHandle    : THandle;
    hDrvEvent        : THandle;
    OpenVxdHandle    : TOpenVxdHandle;


    fLPTAddresses    : PLPTAddresses;
    fLPTBasePort     : Word;
    fDataPorts       : array[0..2] of Byte;
    fLPTNumber       : Byte;
    fLPTs            : Byte;

    function	     InstallDriver : Boolean;
    function	     StartDriver : Boolean;
    function	     StopDriver : Boolean;
    function	     RemoveDriver : Boolean;
    procedure        CloseStopUnloadDriver;
    procedure        InstallStartLoadDriver;

    function	     CtlCode(Code : DWORD) : DWORD;
    procedure        ClearFields;

    procedure        SetHardAccess(parm : Boolean);
    procedure	     SetLPTNumber(nNewValue  : Byte);
    procedure	     SetIRQMasked(bNewValue  : Boolean);
    procedure	     SetIRQNumber(nNewValue  : Byte);
    function	     GetLPTAckwl : Boolean;
    function	     GetLPTBusy : Boolean;
    function	     GetLPTPaperEnd : Boolean;
    function	     GetLPTSlct : Boolean;
    function	     GetLPTError : Boolean;

    function         GetPortB(PortAddr : Word) : Byte;
    procedure        SetPortB(PortAddr : Word; nNewValue : Byte);
    function         GetPortW(PortAddr : Word) : Word;
    procedure        SetPortW(PortAddr : Word; nNewValue : Word);
    function         GetPortL(PortAddr : Word) : DWORD;
    procedure        SetPortL(PortAddr : Word; nNewValue : DWORD);
    function         GetPin(nPin : Byte) : Boolean;
    procedure        SetPin(nPin : Byte; bNewValue : Boolean);
    function         GetMemB(MappedAddr : Pointer; Offset : DWORD) : Byte;
    procedure        SetMemB(MappedAddr : Pointer; Offset : DWORD; nNewValue : Byte);
    function         GetMemW(MappedAddr : Pointer; Offset : DWORD) : Word;
    procedure        SetMemW(MappedAddr : Pointer; Offset : DWORD; nNewValue : Word);
    function         GetMemL(MappedAddr : Pointer; Offset : DWORD) : DWORD;
    procedure        SetMemL(MappedAddr : Pointer; Offset : DWORD; nNewValue : DWORD);

  public

    constructor Create(Owner:TComponent); override;
    destructor  Destroy; override;

    procedure  CloseDriver;
    function   OpenDriver : Boolean;
    function   MapPhysToLinear(PhAddr : DWORD; PhSize : DWORD) : Pointer;
    procedure  UnmapMemory(PhAddr : DWORD; PhSize : DWORD);

    function   LPTPrintChar(ch : Char) : Boolean;
    procedure  LPTStrobe;
    procedure  LPTAutofd(Flag : Boolean);
    procedure  LPTInit;
    procedure  LPTSlctIn;

    procedure   PortControl  ( Ports:pPortRec; NumPorts:Word);

    procedure   ReadPortFIFO ( PortAddr:Word; NumPorts:Word; var Buffer);
    procedure   WritePortFIFO( PortAddr:Word; NumPorts:Word; var Buffer);
    procedure   ReadPortWFIFO ( PortAddr:Word; NumPorts:Word; var Buffer);
    procedure   WritePortWFIFO( PortAddr:Word; NumPorts:Word; var Buffer);

    property    Port[Index:Word]  : Byte  read GetPortB  write SetPortB;
    property    PortW[Index:Word] : Word  read GetPortW write SetPortW;
    property    PortL[Index:Word] : DWORD read GetPortL write SetPortL;

    property    Mem[Base:Pointer; Offset:DWORD]  : Byte  read GetMemB write SetMemB;
    property    MemW[Base:Pointer; Offset:DWORD] : Word  read GetMemW write SetMemW;
    property    MemL[Base:Pointer; Offset:DWORD] : DWORD read GetMemL write SetMemL;


    property    IRQMasked    : Boolean read fMasked     write SetIRQMasked;
    property    LPTAckwl     : Boolean read GetLPTAckwl;
    property    LPTBusy      : Boolean read GetLPTBusy;
    property    LPTPaperEnd  : Boolean read GetLPTPaperEnd;
    property    LPTSlct      : Boolean read GetLPTSlct;
    property    LPTError     : Boolean read GetLPTError;
    property    LPTNumPorts  : Byte    read fLPTs;
    property    LPTBasePort  : Word    read fLPTBasePort;
    property    DebugCode    : DWORD   read fDebugCode;

    property    Pin[Index:Byte] : Boolean read GetPin write SetPin;
    
  published

    property    ActiveHW      : Boolean read fOpenDrive;
    property    OnHwInterrupt : TInterruptHandler read fOnHwInterrupt write fOnHwInterrupt;
    property    LPTNumber     : Byte    read fLPTNumber  write SetLPTNumber default 1;
    property    IRQNumber     : Byte   read fIRQNumber  write SetIRQNumber;
    property    HardAccess    : Boolean read fHardAccess write SetHardAccess default TRUE;

  end;

procedure Register;

implementation

//{$R HW_32.dcr}


const  SC_MANAGER_CONNECT            = $0001;
const  SC_MANAGER_CREATE_SERVICE     = $0002;
const  SC_MANAGER_ENUMERATE_SERVICE  = $0004;
const  SC_MANAGER_LOCK               = $0008;
const  SC_MANAGER_QUERY_LOCK_STATUS  = $0010;
const  SC_MANAGER_MODIFY_BOOT_CONFIG = $0020;

const  SC_MANAGER_ALL_ACCESS         =(STANDARD_RIGHTS_REQUIRED      OR
                                       SC_MANAGER_CONNECT            OR
                                       SC_MANAGER_CREATE_SERVICE     OR
                                       SC_MANAGER_ENUMERATE_SERVICE  OR
                                       SC_MANAGER_LOCK               OR
                                       SC_MANAGER_QUERY_LOCK_STATUS  OR
                                       SC_MANAGER_MODIFY_BOOT_CONFIG);
const  SERVICE_QUERY_CONFIG          = $0001;
const  SERVICE_CHANGE_CONFIG         = $0002;
const  SERVICE_QUERY_STATUS          = $0004;
const  SERVICE_ENUMERATE_DEPENDENTS  = $0008;
const  SERVICE_START                 = $0010;
const  SERVICE_STOP                  = $0020;
const  SERVICE_PAUSE_CONTINUE        = $0040;
const  SERVICE_INTERROGATE           = $0080;
const  SERVICE_USER_DEFINED_CONTROL  = $0100;

const  SERVICE_ALL_ACCESS            =(STANDARD_RIGHTS_REQUIRED     OR
                                       SERVICE_QUERY_CONFIG         OR
                                       SERVICE_CHANGE_CONFIG        OR
                                       SERVICE_QUERY_STATUS         OR
                                       SERVICE_ENUMERATE_DEPENDENTS OR
                                       SERVICE_START                OR
                                       SERVICE_STOP                 OR
                                       SERVICE_PAUSE_CONTINUE       OR
                                       SERVICE_INTERROGATE          OR
                                       SERVICE_USER_DEFINED_CONTROL);

const  SERVICE_KERNEL_DRIVER         = $0000001;
const  SERVICE_FILE_SYSTEM_DRIVER    = $0000002;
const  SERVICE_ADAPTER               = $0000004;
const  SERVICE_RECOGNIZER_DRIVER     = $0000008;

const  SERVICE_DRIVER                =(SERVICE_KERNEL_DRIVER OR
                                       SERVICE_FILE_SYSTEM_DRIVER OR
                                       SERVICE_RECOGNIZER_DRIVER);

const  SERVICE_BOOT_START            = $0000000;
const  SERVICE_SYSTEM_START          = $0000001;
const  SERVICE_AUTO_START            = $0000002;
const  SERVICE_DEMAND_START          = $0000003;
const  SERVICE_DISABLED              = $0000004;
const  SERVICE_ERROR_IGNORE          = $0000000;
const  SERVICE_ERROR_NORMAL          = $0000001;
const  SERVICE_ERROR_SEVERE          = $0000002;
const  SERVICE_ERROR_CRITICAL        = $0000003;

const  SERVICE_CONTROL_STOP          = $0000001;
const  SERVICE_CONTROL_PAUSE         = $0000002;
const  SERVICE_CONTROL_CONTINUE      = $0000003;
const  SERVICE_CONTROL_INTERROGATE   = $0000004;
const  SERVICE_CONTROL_SHUTDOWN      = $0000005;


type   SERVICE_STATUS = record
         dwServiceType              : DWORD;
         dwCurrentState             : DWORD;
         dwControlsAccepted         : DWORD;
         dwWin32ExitCode            : DWORD;
         dwServiceSpecificExitCode  : DWORD;
         dwCheckPoint               : DWORD;
         dwWaitHint                 : DWORD;
       end;


function TVicHW32.InstallDriver : Boolean;
var
  schService : SC_HANDLE;
begin

  schService := CreateService(SchSCManager,          // SCManager database
                              LPCSTR(@fDriverName),           // name of service
                              LPCSTR(@fDriverName),           // name to display
                              SERVICE_ALL_ACCESS,    // desired access
                              SERVICE_KERNEL_DRIVER, // service type
                              SERVICE_DEMAND_START,  // start type
                              SERVICE_ERROR_NORMAL,  // error control type
                              LPCSTR(@fPathToDriver),         // service's binary
                              NIL,                   // no load ordering group
                              NIL,                   // no tag identifier
                              NIL,                   // no dependencies
                              NIL,                   // LocalSystem account
                              NIL);                  // no password)

    Result:=(schService <> 0) or (GetLastError=ERROR_SERVICE_EXISTS);
    CloseServiceHandle (schService);
end;

function TVicHW32.StartDriver:Boolean;
var
  schService : SC_HANDLE;
  ret        : BOOL;
begin
  Result:=FALSE;
  schService := OpenService(SchSCManager, LPCSTR(@fDriverName), SERVICE_ALL_ACCESS);
  if (schService = 0) then  Exit;
  ret := StartService (schService,0,NIL);
  Result:=ret or (GetLastError=ERROR_SERVICE_ALREADY_RUNNING);
  CloseServiceHandle (schService);
end;

function TVicHW32.StopDriver : Boolean;
var
  schService       : SC_HANDLE;
  serviceStatus    : SERVICE_STATUS;
begin
  Result:=FALSE;
  schService := OpenService(SchSCManager, LPCSTR(@fDriverName), SERVICE_ALL_ACCESS);
  if (schService = 0) then Exit;
  Result:=ControlService (schService,SERVICE_CONTROL_STOP,@serviceStatus);
  CloseServiceHandle (schService);
end;

function TVicHW32.RemoveDriver : Boolean;
var
  schService  : SC_HANDLE ;
begin
  Result:=FALSE;
  schService := OpenService(SchSCManager, LPCSTR(@fDriverName), SERVICE_ALL_ACCESS);
  if (schService = 0) then Exit;
  Result := DeleteService (schService);
  CloseServiceHandle (schService);
end;

procedure TVicHW32.CloseStopUnloadDriver;
begin
  CloseHandle(hDrv);
  if fWin95 then Exit;

{$ifndef DEMOVERSION}
   if fStarted then Exit;
{$endif}

   schSCManager := OpenSCManager(0, 0, SC_MANAGER_ALL_ACCESS);
   if  (schSCManager <> 0) then
   begin
     StopDriver();
     {$ifndef DEMOVERSION}
     if ( not fRegistry) then
     {$endif}
        RemoveDriver();
     CloseServiceHandle(schSCManager);
   end;
end;

procedure TVicHW32.InstallStartLoadDriver;
begin

//  CloseStopUnloadDriver();  // Close before start

  if fWin95  then   // Windows 95/98
  begin
    hDrv   := CreateFile(fPathToDriver,
                        0,
			0,
			NIL,
			0,
			FILE_FLAG_DELETE_ON_CLOSE,
			0);
    Exit;
  end;

  fDebugCode := DEB_ENTRY;

{$ifndef DEMOVERSION}

  fRegistry  := TRUE; // assume driver already installed to th registry
  fStarted   := TRUE; // assume driver already started

  fDebugCode := fDebugCode or DEB_ENTRY_NOT_DEMO;

  hDrv       := CreateFile(fShortPathToDriver,
                           GENERIC_READ or GENERIC_WRITE,
                           0,
                           NIL,
                           OPEN_EXISTING,
                           FILE_ATTRIBUTE_NORMAL,
			   0);

  if (hDrv <> INVALID_HANDLE_VALUE) then Exit;

  fDebugCode := fDebugCode or DEB_NOT_STARTED;

  fStarted := FALSE;

{$endif}

  schSCManager := OpenSCManager(0, 0, SC_MANAGER_ALL_ACCESS);

  fDebugCode   := fDebugCode or DEB_SC_NOT_OPEN;

  if (schSCManager <> 0) then
  begin

    fDebugCode := fDebugCode or DEB_SC_OPEN;

    {$ifndef DEMOVERSION}

    // Driver already installed but not started? Try to start...
    if StartDriver() then
    begin

      hDrv  := CreateFile(fShortPathToDriver,
                          GENERIC_READ or GENERIC_WRITE,
                          0,
                          NIL,
                          OPEN_EXISTING,
			  FILE_ATTRIBUTE_NORMAL,
			  0);
      CloseServiceHandle (schSCManager);

      fDebugCode := fDebugCode or DEB_INSTALLED;

      Exit; // YES!

    end;

    fRegistry := FALSE; // not installed

    fDebugCode := fDebugCode or DEB_NOT_INSTALLED;

    {$endif}

    if InstallDriver() then
    begin

      fDebugCode := fDebugCode or DEB_AFTER_INSTALL;

      if StartDriver() then
      begin
        fDebugCode := fDebugCode or DEB_AFTER_START;
              hDrv  := CreateFile(fShortPathToDriver,
                          GENERIC_READ or GENERIC_WRITE,
                          0,
                          NIL,
                          OPEN_EXISTING,
			  FILE_ATTRIBUTE_NORMAL,
			  0);
      end;

    end;

    CloseServiceHandle (schSCManager);

  end;

end;

function TVicHw32.CtlCode(Code:DWORD):DWORD;
begin
  if fWin95 then Result:=Code
            else Result:=$80000000 or (($800+Code) shl 2);
end;


procedure IRQProcNT(HW32 : TVicHw32); stdcall;
var  nByte,dwIRQ    : DWORD;
     CurrentProcess : tHandle;
     pl             : PLockedBuffer;
     wrd,sel        : Word;
begin
  pl  := PLockedBuffer(HW32.fpLockedMemory);
  with HW32,pl^ do
  begin
    wrd := 0;
    CurrentProcess := GetCurrentProcess();
    SetPriorityClass(CurrentProcess, REALTIME_PRIORITY_CLASS);
    SetThreadPriority(GetCurrentThread(), THREAD_PRIORITY_TIME_CRITICAL);

    DeviceIoControl(hDrv,
                    CtlCode(_DRV_SET_POST_EVENT),
                    @fLocEvent, sizeof(fLocEvent),
		    NIL, 0, nByte, POverlapped(NIL));
    dwIRQ := fIRQNumber;
    DeviceIoControl(hDrv,
                    CtlCode(_DRV_SET_INT_VEC),
                    @dwIRQ, sizeof(dwIRQ),
		    NIL, 0, nByte, POverlapped(NIL));

    fMasked   := FALSE;
    DeviceIoControl(hDrv,
	     	        CtlCode(_DRV_UNMASK_INT_VEC),
		            NIL, 0, NIL, 0,
		            nByte, POverlapped(NIL));

    while (TRUE) do
    begin

      WaitForSingleObject(fLocEvent, INFINITE);

      if (not fTerminated) then
      begin
        if (LPT_BASE_PORT<>0) and (L_BUF_LPT>0) then
        begin
          sel := N_SEL_LPT;
          wrd := BUF_LPT[sel];
	  Inc(sel);
	  sel := sel and (MAX_BUF_LPT);
          N_SEL_LPT := sel;
          Dec(L_BUF_LPT);
        end;
	if Assigned(fOnHWInterrupt) then
            OnHwInterrupt(HW32,Drv_IRQ_Counter,Hi(wrd),Lo(wrd),ScanCode);
      end
      else
	 break;
    end;
    DeviceIoControl(hDrv,
                    CtlCode(_DRV_STOP_INT_VEC),
		    NIL, 0, NIL, 0,
		    nByte, POverlapped(NIL));

    CurrentProcess := GetCurrentProcess();
    SetPriorityClass(CurrentProcess, NORMAL_PRIORITY_CLASS);
  end;
end;

procedure IRQProc95(HW32 : TVicHw32); stdcall;

var  nByte,Count,fHandled,dwIRQ : DWORD;
     CurrentProcess             : THandle;
     pl                         : PLockedBuffer;
     wrd,sel                    : Word;
begin
  pl  := PLockedBuffer(HW32.fpLockedMemory);
  with HW32,pl^ do
  begin
    wrd := 0;
    fHandled:=0;
    CurrentProcess := GetCurrentProcess();
    SetPriorityClass(CurrentProcess, REALTIME_PRIORITY_CLASS);
    SetThreadPriority(GetCurrentThread(), THREAD_PRIORITY_TIME_CRITICAL);

    DeviceIoControl(hDrv,
                    CtlCode(_DRV_SET_POST_EVENT),
                    @hDrvEvent, sizeof(hDrvEvent),
		    NIL, 0, nByte, POverlapped(NIL));

    dwIRQ := fIRQNumber;
    DeviceIoControl(hDrv,
                    CtlCode(_DRV_SET_INT_VEC),
                    @dwIRQ, sizeof(dwIRQ),
		    NIL, 0, nByte, POverlapped(NIL));

    fMasked   := FALSE;
    DeviceIoControl(hDrv,
                    CtlCode(_DRV_UNMASK_INT_VEC),
		    NIL, 0, NIL, 0,
		    nByte, POverlapped(NIL));

    while (TRUE) do
    begin

      WaitForSingleObject(fLocEvent, INFINITE);
      ResetEvent(fLocEvent);

      if (not fTerminated) then
      begin

        Count := Drv_IRQ_Counter;

        while (fHandled<Count) do
        begin
          Inc(fHandled);
          if (fIRQNumber = 7) and (L_BUF_LPT>0) then
          begin
            sel := N_SEL_LPT;
            wrd := BUF_LPT[sel];
	    Inc(sel);
	    sel := sel and (MAX_BUF_LPT);
            N_SEL_LPT := sel;
            Dec(L_BUF_LPT);
          end;
	  if Assigned(fOnHWInterrupt) then
               OnHwInterrupt(HW32,Drv_IRQ_Counter,Hi(wrd),Lo(wrd),ScanCode);
        end;
      end
      else
        break;
    end;
    DeviceIoControl(hDrv,
                    CtlCode(_DRV_STOP_INT_VEC),
		    NIL, 0, NIL, 0,
		    nByte, POverlapped(NIL));

    CurrentProcess := GetCurrentProcess();
    SetPriorityClass(CurrentProcess, NORMAL_PRIORITY_CLASS);

  end;
end;

procedure TVicHW32.ClearFields;
begin
  hDrv            := INVALID_HANDLE_VALUE;
  fRegistry       := TRUE;
  fStarted        := TRUE;
  fTerminated     := FALSE;

  fInterface      := 0;
  fBus 		  := 0;
  fPhysLoPart     := 0;
  fPhysHiPart     := 0;
  fTypeMem        := 0;
  fMemorySize     := 0;

  fDebugCode      := 0;

  FillChar(fMappedPointers,4*MaxMappedAreas,0);
  FillChar(fMappedSizes,4*MaxMappedAreas,0);
  FillChar(fMappedAddresses,4*MaxMappedAreas,0);
  fMappedAreas    := 0;

  fHardAccess     := TRUE;

  fIsIRQSet       := (fIRQNumber>0) and (fIRQNumber<16);
  fMasked         := TRUE;
  fOpenDrive      := FALSE;

end;

constructor TVicHW32.Create(Owner:TComponent); {==}
begin
  inherited Create(Owner);
  fWin95:= (GetVersion() and $80000000)<>0;
  ClearFields();
  fDriverName := {$ifdef DEMOVERSION} 'VICHW00' {$else} 'VICHW11' {$endif};
  fSDriverName := StrPas(fDriverName);
  if fWin95 then
  begin
    StrPCopy(fPathToDriver,'\\.\'+fSDriverName+'.VXD');
    hDll          := GetModuleHandle('kernel32');
    OpenVxdHandle := TOpenVxdHandle(GetProcAddress(hDll,'OpenVxDHandle'));
    fLocEvent     := CreateEvent(NIL, TRUE, FALSE, NIL);
    hDrvEvent     := OpenVxDHandle(fLocEvent);
  end
  else
  begin
    GetWindowsDirectory(fPathToDriver,128);
    StrCat(fPathToDriver,'\SYSTEM32\DRIVERS\');
    StrCat(fPathToDriver,fDriverName);
    StrCat(fPathToDriver,'.SYS');
    StrPCopy(fShortPathToDriver,'\\.\'+fSDriverName);
    fLocEvent := CreateSemaphore(NIL, 0, 1000, NIL);
  end;
end;

destructor TVicHW32.Destroy;                   {==}
begin
  CloseDriver();
  ClearFields();
  if fWin95 then
  begin
    CloseHandle(hDrvEvent);
    CloseHandle(hDll);
  end;
  CloseHandle(fLocEvent);
  inherited Destroy;
end;

procedure  TVicHW32.SetIRQMasked(bNewValue  : Boolean);
var nByte : DWORD;
begin
  if (fOpenDrive and fIsIRQSet) then
  begin
    if (bNewValue) then
    begin
      if (not fMasked) then
      begin
        fMasked := TRUE;
        DeviceIoControl(hDrv,
                        CtlCode(_DRV_MASK_INT_VEC),
			NIL, 0, NIL, 0,
			nByte, POverlapped(NIL));
        fTerminated := true;

        if  fWin95 then SetEvent(fLocEvent)
	else ReleaseSemaphore(fLocEvent, 1, NIL);

        WaitForSingleObject(fThreadHandle,INFINITE);

        CloseHandle(fThreadHandle);
        
      end;
    end
    else begin
	   if fMasked then
           begin
             with PLockedBuffer(fpLockedMemory)^ do
             begin
               {$ifdef DEB_NOT_LPT}
                  LPT_BASE_PORT := $300;
               {$ELSE}
                  LPT_BASE_PORT := fLPTBasePort;
               {$ENDIF}
               MAX_BUF_LPT   := MAX_RING_BUFFER;
               L_BUF_LPT     := 0;
               N_ADD_LPT     := 0;
	       N_SEL_LPT     := 0;
             end;
             fTerminated := FALSE;

             if (fWin95) then
                fThreadHandle := CreateThread(NIL,
				      	   0,
					   @IRQProc95,
					   self,
					   0,
					   fThreadId)
             else
                fThreadHandle := CreateThread(NIL,
					   0,
					   @IRQProcNT,
					   self,
					   0,
					   fThreadId);
	   end;

         end;

  end;
end;

procedure  TVicHW32.SetIRQNumber(nNewValue  : Byte);
begin
  if (nNewValue>0) and (nNewValue<16) then
  begin
    if (not fMasked) and fOpenDrive then SetIRQMasked(TRUE);
    fIRQNumber := nNewValue;
    fIsIRQSet := TRUE;
  end;
end;

procedure TVicHW32.CloseDriver;
var nByte : DWORD;
    i     : Byte;
begin
  if fOpenDrive then
  begin
    SetHardAccess(TRUE);
    if not fMasked then SetIRQMasked(TRUE);
    fOpenDrive := FALSE;
    DeviceIoControl(hDrv,
                    CtlCode(_DRV_UNMAP_LPT_AREA),
		    @fLPTAddresses,4,
		    @fLPTAddresses,4,
		    nByte,POverlapped(NIL));
    DeviceIoControl(hDrv,
                    CtlCode(_DRV_UNLOCK_MEMORY),
		    @fMdl,4,
		    @fMdl,4,
		    nByte,POverlapped(NIL));
    for i:=1 to fMappedAreas do
       UnmapMemory(fMappedAddresses[i],fMappedSizes[i]);

    CloseStopUnloadDriver();
  end;
end;



function TVicHW32.OpenDriver : Boolean;
type TLocRec = record  pBuf : Pointer; Sz : DWORD; end;
var  Rec     : TLocRec;
     nByte   : DWORD;
     i       : Byte;
begin

  Result:=fOpenDrive;
  if fOpenDrive then Exit;

  ClearFields();
  fLPTBasePort := $378;
  fLPTNumber := 1;

  InstallStartLoadDriver();

  if (hDrv = INVALID_HANDLE_VALUE) then
  begin
    CloseStopUnloadDriver();
    InstallStartLoadDriver();
    if hDrv = INVALID_HANDLE_VALUE then Exit;
  end;
  fOpenDrive  := TRUE;
  Result      := TRUE;
  fPhysLoPart := $408;
  fMemorySize := 6;
  DeviceIoControl(hDrv,
		  CtlCode(_DRV_MAP_MEMORY),//LPT_AREA),
		  @fInterface,24,
		  @fLPTAddresses,4,
		  nByte,POverlapped(NIL));
  if (fLPTAddresses<>NIL) then
  begin
    for  i:=1 to 3 do
       if fLPTAddresses^[i] <> 0  then Inc(fLPTs);

    fLPTBasePort := fLPTAddresses^[1];
  end  
  else begin
         fLPTBasePort :=$378;
       end;

  fLPTNumber   := 1;

  fpLockedMemory := VirtualAlloc(NIL,4096,MEM_COMMIT,PAGE_READWRITE);

  Rec.pBuf := fpLockedMemory;
  Rec.Sz   := 4096;
  DeviceIoControl(hDrv,
                  CtlCode(_DRV_LOCK_MEMORY),
                  @Rec,8,@fMdl,4,
                  nByte,POverlapped(NIL));
  with PLockedBuffer(fpLockedMemory)^ do
  begin
    {$ifdef DEB_NOT_LPT}
       LPT_BASE_PORT := $300;
    {$ELSE}
       LPT_BASE_PORT := fLPTBasePort;
    {$ENDIF}
    MAX_BUF_LPT   := MAX_RING_BUFFER;
    L_BUF_LPT     := 0;
    N_ADD_LPT     := 0;
    N_SEL_LPT     := 0;
  end;
end;


function  TVicHW32.GetPortB(PortAddr:Word):Byte;
var nByte,PortNumber,DataPort : DWORD;
begin
  if not ActiveHW then begin Result:=$ff; Exit; end;
  PortNumber:=PortAddr;
  if HardAccess then
  begin
      DeviceIoControl(hDRV,
                      CtlCode(_DRV_HARD_READ_PORT),
                      @PortNumber,4,@DataPort,4,
                      nByte,pOverlapped(NIL))
  end                    
  else begin
         asm
           mov dx,word ptr PortNumber
           in  al,dx
           mov byte ptr DataPort,al
         end;
       end;
  Result:=Lo(LoWord(DataPort));
end;

function  TVicHW32.GetPortW(PortAddr:Word):Word;
var nByte,PortNumber,DataPort : DWORD;
begin
  if not ActiveHW then begin Result:=$ff; Exit; end;
  PortNumber:=PortAddr;
  if HardAccess then
  begin
    DeviceIoControl(hDRV,
                    CtlCode(_DRV_HARD_READ_PORTW),
                    @PortNumber,4,@DataPort,4,
                    nByte,pOverlapped(NIL));
  end
  else begin
         asm
            mov dx,word ptr PortNumber
            in  ax,dx
            mov word ptr DataPort,ax
         end;
       end;
  Result:=LoWord(DataPort);
end;

function  TVicHW32.GetPortL(PortAddr:Word):DWORD;
var nByte,PortNumber,DataPort : DWORD;
begin
  if not ActiveHW then begin Result:=$ff; Exit; end;
  PortNumber:=PortAddr; DataPort:=0;
  if HardAccess then
  begin
    DeviceIoControl(hDRV,
                    CtlCode(_DRV_HARD_READ_PORTL),
                    @PortNumber,4,@DataPort,4,
                    nByte,pOverlapped(NIL));
  end
  else begin
         asm
            mov dx,word ptr PortNumber
            in  eax,dx
            mov DataPort,eax
         end;
       end;
  Result:=DataPort;
end;

procedure   TVicHW32.SetPortB(PortAddr : Word; nNewValue: Byte);
var nByte : DWORD;
    Rec   : record
     PortNumber:DWORD;
     DataPort  :DWORD;
    end;
begin
  if not ActiveHW then Exit;
  if HardAccess then
  begin
    Rec.PortNumber:=PortAddr; Rec.DataPort:=nNewValue;
    DeviceIoControl(hDRV,
                    CtlCode(_DRV_HARD_WRITE_PORT),
                    @Rec,8,NIL,0,
                    nByte,pOverlapped(NIL));
  end
  else begin
         asm
           mov al,nNewValue
           mov dx,PortAddr
           out dx,al
         end;
       end;
end;

procedure   TVicHW32.SetPortW(PortAddr : Word; nNewValue: Word);
var nByte : DWORD;
    Rec   : record
     PortNumber:DWORD;
     DataPort  :DWORD;
    end;
begin
  if not ActiveHW then Exit;
  if HardAccess then
  begin
    Rec.PortNumber:=PortAddr; Rec.DataPort:=nNewValue;
    DeviceIoControl(hDRV,
                    CtlCode(_DRV_HARD_WRITE_PORTW),
                    @Rec,8,NIL,0,
                    nByte,pOverlapped(NIL));
  end
  else begin
         asm
           mov ax,nNewValue
           mov dx,PortAddr
           out dx,ax
         end;
       end;
end;

procedure   TVicHW32.SetPortL(PortAddr : Word; nNewValue: DWORD);
var nByte : DWORD;
    Rec   : record
     PortNumber:DWORD;
     DataPort  :DWORD;
    end;
begin
  if not ActiveHW then Exit;
  if HardAccess then
  begin
    Rec.PortNumber:=PortAddr; Rec.DataPort:=nNewValue;
    DeviceIoControl(hDRV,
                    CtlCode(_DRV_HARD_WRITE_PORTL),
                    @Rec,6,NIL,0,
                    nByte,pOverlapped(NIL));
  end
  else begin
         asm
           mov eax,nNewValue
           mov dx,PortAddr
           out dx,eax
         end;
       end;
end;

procedure   TVicHW32.PortControl(Ports:pPortRec; NumPorts:Word);
var nByte : DWORD;
    size     : DWORD;
begin
  if not ActiveHW then Exit;
  Size:=4*NumPorts;
  DeviceIoControl(hDRV,
                  CtlCode(_DRV_PORT_CONTROL),
                  Ports,size,
                  Ports,size,
                  nByte,pOverlapped(NIL));
end;

procedure   TVicHW32.ReadPortFIFO ( PortAddr:Word; NumPorts:Word; var Buffer);
type TPortRec = record
       PortAddr : Word;
       size  : Word;
       Buf   : array[1..2] of Byte;
     end;
var nByte    : DWORD;
    PortRec  :^TPortRec;
begin
  if not ActiveHW then Exit;

  if fHardAccess then
  begin

    GetMem(PortRec,4+NumPorts);
    PortRec^.PortAddr:=PortAddr;
    PortRec^.size:=NumPorts;

    DeviceIOControl(hDRV,
                    CtlCode(_DRV_READ_FIFO),
                    PortRec,NumPorts+4,
                    PortRec,NumPorts+4,
                    nByte,pOverlapped(NIL));
    Move(PortRec^.Buf,Buffer,NumPorts);
    FreeMem(PortRec);
  end
  else
  begin
    nByte:=DWORD(@Buffer);
    asm
      cld
      mov dx,PortAddr
      xor ecx,ecx
      mov cx,NumPorts
      mov edi,nByte
      rep insb
    end;
  end;  
end;

procedure   TVicHW32.WritePortFIFO( PortAddr:Word; NumPorts:Word; var Buffer);
type TPortRec = record
       PortAddr : Word;
       size  : Word;
       Buf   : array[1..2] of Byte;
     end;
var nByte    : DWORD;
    PortRec  :^TPortRec;
begin
  if not ActiveHW then Exit;
  if fHardAccess then
  begin
    GetMem(PortRec,4+NumPorts);
    PortRec^.PortAddr:=PortAddr;
    PortRec^.size:=NumPorts;
    Move(Buffer,PortRec^.Buf,NumPorts);
    DeviceIOControl(hDRV,
                    CtlCode(_DRV_WRITE_FIFO),
                    PortRec,NumPorts+4,
                    PortRec,NumPorts+4,
                    nByte,pOverlapped(NIL));
    FreeMem(PortRec);
  end
  else
  begin
    nByte:=DWORD(@Buffer);
    asm
      cld
      mov dx,PortAddr
      xor ecx,ecx
      mov cx,NumPorts
      mov esi,nByte
      rep outsb
    end;
  end;

end;
procedure   TVicHW32.ReadPortWFIFO ( PortAddr:Word; NumPorts:Word; var Buffer);
type TPortRec = record
       PortAddr : Word;
       size  : Word;
       Buf   : array[1..2] of Word;
     end;
var nByte    : DWORD;
    PortRec  :^TPortRec;
begin
  if not ActiveHW then Exit;
 if fHardAccess then
  begin

    GetMem(PortRec,4+2*NumPorts);
    PortRec^.PortAddr:=PortAddr;
    PortRec^.size:=NumPorts;
    DeviceIOControl(hDRV,
                    CtlCode(_DRV_READ_FIFO_WORD),
                    PortRec,2*NumPorts+4,
                    PortRec,2*NumPorts+4,
                    nByte,pOverlapped(NIL));
    Move(PortRec^.Buf,Buffer,2*NumPorts);
    FreeMem(PortRec);
  end
  else
  begin

    nByte:=DWORD(@Buffer);
    asm
      cld
      mov dx,PortAddr
      xor ecx,ecx
      mov cx,NumPorts
      mov edi,nByte
      rep insw
    end;
  end;

end;

procedure   TVicHW32.WritePortWFIFO( PortAddr:Word; NumPorts:Word; var Buffer);
type TPortRec = record
       PortAddr : Word;
       size  : Word;
       Buf   : array[1..2] of Word;
     end;
var nByte    : DWORD;
    PortRec  :^TPortRec;
begin
  if not ActiveHW then Exit;
  if fHardAccess then
  begin
    GetMem(PortRec,4+2*NumPorts);
    PortRec^.PortAddr:=PortAddr;
    PortRec^.size:=NumPorts;
    Move(Buffer,PortRec^.Buf,2*NumPorts);
    DeviceIOControl(hDRV,
                    CtlCode(_DRV_WRITE_FIFO_WORD),
                    PortRec,2*NumPorts+4,
                    PortRec,2*NumPorts+4,
                    nByte,pOverlapped(NIL));
    FreeMem(PortRec);
  end
  else
  begin
    nByte:=DWORD(@Buffer);
    asm
      cld
      mov dx,PortAddr
      xor ecx,ecx
      mov cx,NumPorts
      mov esi,nByte
      rep outsw
    end;
  end;

end;

function  TVicHW32.MapPhysToLinear(PhAddr:DWORD; PhSize:DWORD):Pointer;
var nByte : DWORD;
    MP    : Pointer;
    var i : Byte;
begin

  Result:=NIL;
  if (not fOpenDrive) then Exit;

  for i:=1 to fMappedAreas do
    if PhAddr = fMappedAddresses[i] then
    begin
      Result :=	fMappedPointers[i];
      Exit;
    end;

  if fMappedAreas = MaxMappedAreas then Exit;

  fMemorySize := PhSize;
  fPhysLoPart := PhAddr;
  DeviceIoControl(hDrv,
		  CtlCode(_DRV_MAP_MEMORY),
                  @fInterface,24,
                  @MP, 4,
                  nByte, POverlapped(NIL));
  Inc(fMappedAreas);
  fMappedSizes[fMappedAreas]     := PhSize;
  fMappedPointers[fMappedAreas]  := MP;
  fMappedAddresses[fMappedAreas] := PhAddr;

  Result := MP;
end;



procedure TVicHW32.UnmapMemory(PhAddr:DWORD; PhSize:DWORD);
var nByte : DWORD;
    i,j   : Byte;
begin
  if not fOpenDrive then Exit;
  i:=1;
  while i <= fMappedAreas do
  begin
    if PhAddr=fMappedAddresses[i] then
    begin
      DeviceIOControl(hDrv,
                      CtlCode(_DRV_UNMAP_MEMORY),
                      @fMappedPointers[i],4,
                      NIL,0,
                      nByte,POverlapped(NIL));
      for j:=i to (fMappedAreas-1) do
      begin
        fMappedAddresses[j]:= fMappedAddresses[j+1];
        fMappedPointers[j] := fMappedPointers[j+1];
        fMappedSizes[j]    := fMappedSizes[j+1];
      end;
      Dec(fMappedAreas);
    end
    else Inc(i);
  end;
end;

procedure   TVicHW32.SetHardAccess(Parm : Boolean);
var code,nByte : DWORD;
begin
  if not fWin95 then
  begin
    if Parm then code:=CtlCode(_DRV_HARD_ACCESS)
            else code:=CtlCode(_DRV_SOFT_ACCESS);
    DeviceIoControl(hDRV,
                  Code,
                  NIL,0,NIL,0,
                  nByte,pOverlapped(NIL));
  end;
  fHardAccess:=PARM;
end;

procedure TVicHW32.SetLPTNumber(nNewValue  : Byte);
begin
  if fOpenDrive and (nNewValue<=fLPTs) then
  begin
    fLPTBasePort := fLPTAddresses^[nNewValue];
    {$ifdef DEB_NOT_LPT}
       PLockedBuffer(fpLockedMemory)^.LPT_BASE_PORT := $300;
    {$ELSE}
       PLockedBuffer(fpLockedMemory)^.LPT_BASE_PORT := fLPTBasePort;
    {$ENDIF}
    fDataPorts[0]:=0;
    fDataPorts[1]:=0;
    fDataPorts[2]:=0;
    fLPTNumber := nNewValue;
  end;
end;

procedure TVicHW32.LPTStrobe;
var i : Word;
begin
  if (not fOpenDrive) then Exit;
  SetPin(1,FALSE);
  for i:=0 to 10000 do;
  SetPin(1,TRUE);
end;

function TVicHW32.GetLPTAckwl : Boolean;
begin
  Result:= not GetPin(10);
end;

function TVicHW32.GetLPTBusy : Boolean;
begin
  Result:= GetPin(11);
end;

function TVicHW32.GetLPTPaperEnd : Boolean;
begin
  Result:= GetPin(12);
end;

function TVicHW32.GetLPTSlct: Boolean;
begin
  Result:=  not GetPin(13);
end;

procedure TVicHW32.LPTAutofd(Flag : Boolean);
begin
  SetPin(14, not Flag);
end;

function TVicHW32.GetLPTError : Boolean;
begin
  Result:=  not GetPin(15);
end;

procedure TVicHW32.LPTInit;
var i : Word;
begin
  SetPin(16,FALSE);
  for i:=1 to 10000 do;
  SetPin(16,TRUE);
end;

procedure TVicHW32.LPTSlctIn;
var data : Byte;
begin
  SetPin(16,FALSE);
  data := fDataPorts[2] and $f7;
  fDataPorts[2] := data;
  SetPortB(fLPTBasePort+2,data);
end;

function TVicHW32.LPTPrintChar(ch : Char) : Boolean;
begin
   Result := FALSE;
   if (fOpenDrive) then
   begin
     SetPortB(fLPTBasePort,Byte(ch));
     if (not GetLPTError) and (not GetLPTBusy) then
     LPTStrobe();
     Result := TRUE;
   end;
end;

function TVicHW32.GetPin(nPin : Byte) : Boolean;
var data,ofs : Byte;
begin
  Result := FALSE;
  if (not fOpenDrive) or (nPin>17) or (nPin<=0) then Exit;
  ofs  := PinsPort[nPin];
  data := GetPortB(fLPTBasePort+ofs);
  Result := (data and MaskPins[nPin]) <> 0;
  if (Negative[nPin]) then Result := not Result;
end;

procedure TVicHW32.SetPin(nPin : Byte; bNewValue : Boolean);
var data,ofs : Byte;
begin
  if (not fOpenDrive) or (nPin>17) or (nPin<=0) then Exit;
  ofs  := PinsPort[nPin];
  data := fDataPorts[ofs];
  if (bNewValue <> Negative[nPin]) then data := data or MaskPins[nPin]
                                   else data := data and (not MaskPins[nPin]);
  SetPortB(fLPTBasePort+ofs,data);
  fDataPorts[ofs] := data;
end;

type TByteArray = array[0..65535] of Byte;
function TVicHW32.GetMemB(MappedAddr : Pointer; Offset : DWORD) : Byte;
begin
  if fOpenDrive then
    Result := TByteArray(MappedAddr^)[Offset]
  else Result:=0;
end;

procedure TVicHW32.SetMemB(MappedAddr : Pointer; Offset : DWORD; nNewValue : Byte);
begin
  if fOpenDrive then
    TByteArray(MappedAddr^)[Offset] := nNewValue
end;

type TWordArray = array[0..65535] of Word;
function TVicHW32.GetMemW(MappedAddr : Pointer; Offset : DWORD) : Word;
begin
  if fOpenDrive then
    Result := TWordArray(MappedAddr^)[Offset]
  else Result:=0;
end;

procedure TVicHW32.SetMemW(MappedAddr : Pointer; Offset : DWORD; nNewValue : Word);
begin
  if fOpenDrive then
    TWordArray(MappedAddr^)[Offset] := nNewValue
end;

type TDWordArray = array[0..65535] of DWORD;
function TVicHW32.GetMemL(MappedAddr : Pointer; Offset : DWORD) : DWORD;
begin
  if fOpenDrive then
    Result := TDWordArray(MappedAddr^)[Offset]
  else Result:=0;
end;

procedure TVicHW32.SetMemL(MappedAddr : Pointer; Offset : DWORD; nNewValue : DWORD);
begin
  if fOpenDrive then
    TDWordArray(MappedAddr^)[Offset] := nNewValue
end;

procedure Register;
begin
  RegisterComponents('Addons', [TVicHw32]);
end;

end.

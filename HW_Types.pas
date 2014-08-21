{========================================================================}
{=================  TVicHW32  Shareware Version 3.0     =================}
{==========     Copyright (c) 1997 Victor I.Ishikeev              =======}
{========================================================================}
{==========             mailto:ivi.ufanet.ru                      =======}
{========================================================================}
{==========           declarations for HW_32.PAS                  =======}
{========================================================================}

//{$DEFINE DEMOVERSION}

const

      MaxPins                     = 17;
      MAX_RING_BUFFER             = 511;
      MaxMappedAreas              = 16;

      _DRV_MAP_MEMORY             = 2;
      _DRV_UNMAP_MEMORY           = 3;

      _DRV_SET_POST_EVENT         = 5;
      _DRV_SET_INT_VEC            = 6;
      _DRV_MASK_INT_VEC           = 7;
      _DRV_UNMASK_INT_VEC         = 8;
      _DRV_STOP_INT_VEC           = 9;

      _DRV_PORT_CONTROL           =10;

      _DRV_HARD_READ_PORT         =11;
      _DRV_HARD_WRITE_PORT        =12;
      _DRV_HARD_READ_PORTW        =13;
      _DRV_HARD_WRITE_PORTW       =14;
      _DRV_HARD_READ_PORTL        =15;
      _DRV_HARD_WRITE_PORTL       =16;

      _DRV_READ_FIFO              =18;
      _DRV_WRITE_FIFO             =19;
      _DRV_READ_FIFO_WORD         =20;
      _DRV_WRITE_FIFO_WORD        =21;
      _DRV_READ_FIFO_LONG         =22;
      _DRV_WRITE_FIFO_LONG        =23;

      _DRV_LOCK_MEMORY            =24;
      _DRV_UNLOCK_MEMORY          =25;

      _DRV_MAP_LPT_AREA           =26;
      _DRV_UNMAP_LPT_AREA         =27;

      _DRV_SOFT_ACCESS            =31;
      _DRV_HARD_ACCESS            =32;

type TOpenVxdHandle = function (Ev:THandle):THandle;stdcall;

type PortRec = array[1..65535] of record
                                    PortAddr : Word;
                                    PortData : Byte;
                                    fWrite   : Boolean;
                                  end;
     pPortRec   =^PortRec;

type PortWRec = array[1..65535] of record
                                    PortAddr : Word;
                                    PortData : Word;
                                    fWrite   : Boolean;
                                  end;
     pPortWRec   =^PortWRec;

type PortLRec = array[1..65535] of record
                                    PortAddr : Word;
                                    PortData : DWORD;
                                    fWrite   : Boolean;
                                  end;
     pPortLRec   =^PortLRec;

     TLockedBuffer = record
     	Drv_IRQ_Counter : DWORD;
	ScanCode        : Word;
	MAX_BUF_LPT     : Word;
	LPT_BASE_PORT   : Word;
	L_BUF_LPT       : Word;
        N_ADD_LPT       : Word;
	N_SEL_LPT       : Word;
        BUF_LPT         : array[0..MAX_RING_BUFFER] of Word;
      end;
      PLockedBuffer     =^TLockedBuffer;

     TInterruptHandler = procedure (Sender        : TObject;
                                    HwCounter     : Longint;
                                    LPT_DataReg   : Byte;
                                    LPT_StatusReg : Byte;
                                    Keyb_ScanCode : Byte) of object;

   TLPTAddresses = array[1..3] of Word;
   PLPTAddresses =^TLPTAddresses;

type   SC_HANDLE    = THANDLE;

var    schSCManager : SC_HANDLE;


function OpenScManager(N1,N2:DWORD;A:DWORD):SC_HANDLE; stdcall;
external 'advapi32.dll' name 'OpenSCManagerA';
function CloseServiceHandle(ScHandle:THandle)        :BOOL;          stdcall;
external 'advapi32.dll' name 'CloseServiceHandle';

function CreateService ( hSCManager         : SC_HANDLE;
                         lpServiceName      : LPCSTR   ;
                         lpDisplayName      : LPCSTR   ;
                         dwDesiredAccess    : DWORD    ;
                         dwServiceType      : DWORD    ;
                         dwStartType        : DWORD    ;
                         dwErrorControl     : DWORD    ;
                         lpBinaryPathName   : LPCSTR   ;
                         lpLoadOrderGroup   : LPCSTR   ;
                         lpdwTagId          : LPDWORD  ;
                         lpDependencies     : LPCSTR   ;
                         lpServiceStartName : LPCSTR   ;
                         lpPassword         : LPCSTR ): SC_HANDLE;   stdcall;

external 'advapi32.dll' name 'CreateServiceA';

function OpenService(    hSCManager         : SC_HANDLE;
                         lpServiceName      : LPCSTR;
                         dwDesiredAccess    : DWORD)  : SC_HANDLE;   stdcall;

external 'advapi32.dll' name 'OpenServiceA';

function StartService(   hService           : SC_HANDLE;
                         dwNumServiceArgs   : DWORD;
                         lpServiceArgVectors: LPCSTR) : BOOL;        stdcall;
external 'advapi32.dll' name 'StartServiceA';

function ControlService( hService           : SC_HANDLE;
                         dwControl          : DWORD;
                         lpServiceStatus    : Pointer)   : BOOL;     stdcall;
external 'advapi32.dll' name 'ControlService';

function DeleteService ( hService           : SC_HANDLE) : BOOL;     stdcall;
external 'advapi32.dll' name 'DeleteService';

const PinsPort : array[1..MaxPins] of Byte = (2,0,0,0,0,0,0,0,0,1,1,1,1,2,1,2,2);
const Negative : array[1..MaxPins] of Boolean =

    (TRUE,                             // -STROBE, pin 1,     Base+2,
     FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE, FALSE,//  DATA,    pins 2..9, Base+0
     FALSE,                            //  ACKWL,  pin 10,    Base+1
     TRUE,                             //  BUSY,   pin 11,    Base+1
     FALSE,                            //  PE,     pin 12,    Base+1
     FALSE,                            //  SLCT,   pin 13,    Base+1
     TRUE,                             // -AUTOFD, pin 14,    Base+2
     FALSE,                            // -ERROR,  pin 15,    Base+1
     FALSE,                            //  INIT,   pin 16,    Base+2
     TRUE);                            // -SLCTIN  pin 17,    Base+2

const MaskPins : array[1..MaxPins] of Byte =
	($01,                             // -STROBE,  pin 1,     Base+2,
         $01,				  //  DATA0,   pin 2,     Base+0
	 $02,				  //  DATA1,   pin 3,     Base+0
	 $04,				  //  DATA2,   pin 4,     Base+0
	 $08,				  //  DATA3,   pin 5,     Base+0
	 $10,				  //  DATA4,   pin 6,     Base+0
	 $20,				  //  DATA5,   pin 7,     Base+0
	 $40,				  //  DATA6,   pin 8,     Base+0
	 $80,				  //  DATA7,   pin 9,     Base+0
         $40,                             // -ACKWL,   pin 10,    Base+1
         $80,                             //  BUSY,    pin 11,    Base+1
         $20,                             //  PE,      pin 12,    Base+1
         $10,                             //  SLCT,    pin 13,    Base+1
         $02,                             // -AUTOFD,  pin 14,    Base+2
         $08,                             // -ERROR,   pin 15,    Base+1
         $04,                             //  INIT,    pin 16,    Base+2
         $08);                            // -SLCTIN,  pin 17,    Base+2

const
         DEB_INST_OK         = $0001;
         DEB_INST_ERR        = $0002;
         DEB_START_OK        = $0004;
         DEB_START_ERR       = $0008;
         DEB_ENTRY           = $0010;
         DEB_ENTRY_NOT_DEMO  = $0020;
         DEB_NOT_STARTED     = $0040;
         DEB_RESERVED        = $0080;
         DEB_SC_OPEN         = $0100;
         DEB_SC_NOT_OPEN     = $0200;
         DEB_INSTALLED       = $0400;
         DEB_NOT_INSTALLED   = $0800;
         DEB_AFTER_INSTALL   = $1000;
         DEB_AFTER_START     = $2000;


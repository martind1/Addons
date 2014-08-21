      {******************************************************************}
      { ShellDropper                                                     }
      {                                                                  }
      { home page: http://www.mwcs.de                                    }
      { email    : martin.walter@mwcs.de                                 }
      {                                                                  }
      { date     : 22-09-2007                                            }
      {                                                                  }
      { version  : v1.65                                                 }
      {                                                                  }
      { Use of this file is permitted for commercial and non-commercial  }
      { use.                                                             }
      { This file (c) 2006, 2007 Martin Walter                           }
      {                                                                  }
      { This Software is distributed on an "AS IS" basis, WITHOUT        }
      { WARRANTY OF ANY KIND, either express or implied.                 }
      {                                                                  }
      { *****************************************************************}
{* MD 16.10.11
ShellDropper ist eine Komponente, die den Vorgang des Drag'n'Drop mit der Windows-Shell
vereinfacht. Die Komponente besitzt eine Liste, der beliebig viele Controls zugewiesen
werden können. Der genaue Vorgang kann über die Ereignisse OnDragEnter, OnDragOver,
OnDragLeave, OnCancelDrag und OnDrop gesteuert werden.

Features:
    Drag'n'Drop von Dateien aus der Shell
    Drag'n'Drop von Internet-Links aus dem Internet Explorer und aus Firefox
    Drag'n'Drop von Dateianhängen aus Mailprogrammen
    Ansi- und Unicode-Unterstützung
*}
unit ShellDropper;

interface

{$I Jedi.inc}

{$IFDEF DELPHI7_UP}
  {$DEFINE WIDESTRINGS}
{$ENDIF}

uses
  Windows, Classes, {$IFDEF WIDESTRINGS}WideStrings, {$ENDIF}
  Controls, ActiveX, ShellAPI, ShlObj;

type
  TDropSource = (dsShell, dsURL);

  TFileType = set of (ftFile, ftDirectory, ftVolume, ftTemporary);

  TFileTypes = array of TFileType;

  TDragCursor = (dgCopy, dgMove, dgLink);

  TDropRec = record
    DropSource: TDropSource;
    Pt: TPoint;
    Button: TMouseButton;
    Shift: TShiftState;
    URL: WideString;
    Files: TStrings;
    {$IFDEF WIDESTRINGS}
    FilesW: TWideStrings;
    {$ENDIF}
    FileTypes: TFileTypes;
    RemoveTemporary: Boolean;
  end;

  TDropEvent = procedure(Sender: TObject; const DropRec: TDropRec) of object;
  TDragEnterEvent = procedure(Sender: TObject; const DropRec: TDropRec;
    var Accept: Boolean) of object;
  TDragOverEvent = procedure(Sender: TObject; const DropRec: TDropRec;
    var Accept: Boolean) of object;

  TItemNotification = (inInsert, inRemove);

  TDropState = (dsNone, dsEnter, dsDrop);

  TDropControls = class;

  TDropControl = class(TCollectionItem)
  private
    FDropControls: TDropControls;
    FControl: TWinControl;
    FControlHandle: THandle;
    FEnabled: Boolean;
    FRegistered: Boolean;
    function GetEnabled: Boolean;
    procedure SetControl(const Value: TWinControl);
    procedure SetEnabled(const Value: Boolean);
  protected
    function IsDesigning: Boolean;
    function CanProcessControl: Boolean;
    procedure SetNotification(Action: TItemNotification);
    procedure Enable;
    procedure Disable;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
  published
    property Enabled: Boolean read GetEnabled write SetEnabled;
    property Control: TWinControl read FControl write SetControl;
  end;

  TShellDropper = class;

  TDropControls = class(TCollection)
  private
    FShellDropper: TShellDropper;
    function GetItem(Index: Integer): TDropControl;
    procedure SetItem(Index: Integer; const Value: TDropControl);
  protected
    function GetOwner: TPersistent; override;
    function GetControlUnderCursor: TWinControl;
    procedure RemoveControl(Control: TComponent);
    function IndexOf(Control: TWinControl): Integer;
  public
    constructor Create(Dropper: TShellDropper);
    destructor Destroy; override;
    property Items[Index: Integer]: TDropControl read GetItem write SetItem; default;
  published
  end;

  TShellDropper = class(TComponent, IDropTarget)
  private
    FAccepted: Boolean;
    FFiles: TStrings;
    {$IFDEF WIDESTRINGS}
    FFilesW: TWideStrings;
    {$ENDIF}
    FDropRec: TDropRec;
    FOnDragEnter: TDragEnterEvent;
    FOnDrop: TDropEvent;
    FDragCursor: TDragCursor;
    FOnDragLeave: TNotifyEvent;
    FOnDragOver: TDragOverEvent;
    FControl: TWinControl;
    FOnCancelDrag: TNotifyEvent;
    FDropped: Boolean;
    FControls: TDropControls;
    FDropSource: TDropSource;
    FIsFileGroup: Boolean;
    FFillState: TDropState;
    FIsValid: Boolean;
    procedure ProcessDropFiles(Drop: HDrop);
    procedure ProcessDropURL(URL: PWideChar);
    procedure ProcessFileGroup(const dataObj: IDataObject; DropState: TDropState);
    function IsFileDescriptor(const dataObj: IDataObject): Boolean;
    procedure CheckValid(const dataObj: IDataObject);
    procedure FillObjects(const dataObj: IDataObject; DropState: TDropState);
    procedure RemoveTemporary;
    procedure SetControls(const Value: TDropControls);
    procedure FillFileTypes(Temporary: Boolean);
    procedure PrepareRec(Pt: TPoint; grfKeyState: Longint);
    procedure ClearDropRec;
  protected
    function DragEnter(const dataObj: IDataObject; grfKeyState: Longint;
      pt: TPoint; var dwEffect: Longint): HResult; stdcall;
    function DragOver(grfKeyState: Longint; pt: TPoint;
      var dwEffect: Longint): HResult; stdcall;
    function DragLeave: HResult; stdcall;
    function Drop(const dataObj: IDataObject; grfKeyState: Longint; pt: TPoint;
      var dwEffect: Longint): HResult; stdcall;

    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    function GetCursor: Integer;
    function GetMouseButton(KeyState: Longint): TMouseButton;
    function GetShiftState(KeyState: Longint): TShiftState;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Controls: TDropControls read FControls write SetControls;
    property DragCursor: TDragCursor read FDragCursor write FDragCursor;
    property OnDragEnter: TDragEnterEvent read FOnDragEnter write FOnDragEnter;
    property OnDragOver: TDragOverEvent read FOnDragOver write FOnDragOver;
    property OnDragLeave: TNotifyEvent read FOnDragLeave write FOnDragLeave;
    property OnCancelDrag: TNotifyEvent read FOnCancelDrag write FOnCancelDrag;
    property OnDrop: TDropEvent read FOnDrop write FOnDrop;
  end;

procedure Register;

implementation

uses
  SysUtils, Forms;

{$IFNDEF DELPHI7_UP}
const
  MK_ALT = 32;
  FILE_ATTRIBUTE_DEVICE = $00000040;
  PathDelim = '\';
{$ENDIF}

var
  Formats: array[TDropSource] of Integer;

procedure Register;
begin
  //MD 16.10.11
  RegisterComponents('Addons', [TShellDropper]);
end;

{ Helper functions }

{$IFDEF WIDESTRINGS}
function SaveStreamW(const Stream: IStream; const FileName: WideString): Boolean;
var
  HR: HResult;
  Buffer: Pointer;
  BufSize: Integer;
  BytesRead: LongInt;
  BytesWritten: Cardinal;
  FHandle: HFile;
begin
  Result := False;
  FHandle := CreateFileW(PWideChar(FileName), GENERIC_READ or GENERIC_WRITE, 0,
    nil, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);

  if FHandle > 0 then
  try
    BufSize := 1024 * 1024;
    GetMem(Buffer, BufSize);
    try
      repeat
        HR := Stream.Read(Buffer, BufSize, @BytesRead);
        if (HR = S_OK) and (BytesRead > 0) then
          if not WriteFile(FHandle, Buffer^, BytesRead, BytesWritten, nil) then
            HR := S_FALSE;
      until (HR <> S_OK) or (BytesRead = 0);
      Result := True;
    finally
      FreeMem(Buffer);
    end;
  finally
    CloseHandle(FHandle);
  end;
end;

function GetTempW: WideString;
var
  C: Integer;
begin
  C := GetTempPathW(0, nil);
  SetLength(Result, C);
  GetTempPathW(C, @Result[1]);
  SetLength(Result, C - 1);
end;

function IsDirectoryW(const Name: WideString): Boolean;
var
  Data: TWin32FileAttributeData;
begin
  GetFileAttributesExW(PWideChar(Name), GetFileExInfoStandard, @Data);
  Result := (Data.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) <> 0;
end;

function IsFileW(const Name: WideString): Boolean;
var
  Data: TWin32FileAttributeData;
begin
  GetFileAttributesExW(PWideChar(Name), GetFileExInfoStandard, @Data);
  Result := ((Data.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) = 0) and
    ((Data.dwFileAttributes and FILE_ATTRIBUTE_DEVICE) = 0);
end;

function IsVolumeW(const Name: WideString): Boolean;
var
  VolName: WideString;
  DType: Cardinal;
begin
  if (Name = '') then
  begin
    Result := False;
    Exit;
  end;

  if Name[Length(Name)] <> PathDelim then
    VolName := Name + PathDelim
  else
    VolName := Name;

  DType := GetDriveTypeW(PWideChar(Name));
  Result := DType <> DRIVE_NO_ROOT_DIR;
end;

{$ELSE}

function SaveStreamA(const Stream: IStream; const FileName: AnsiString): Boolean;
var
  HR: HResult;
  Buffer: Pointer;
  BufSize: Integer;
  BytesRead: LongInt;
  BytesWritten: Cardinal;
  FHandle: HFile;
begin
  Result := False;
  FHandle := CreateFileA(PChar(FileName), GENERIC_READ or GENERIC_WRITE, 0,
    nil, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);

  if FHandle > 0 then
  try
    BufSize := 1024 * 1024;
    GetMem(Buffer, BufSize);
    try
      repeat
        HR := Stream.Read(Buffer, BufSize, @BytesRead);
        if (HR = S_OK) and (BytesRead > 0) then
          if not WriteFile(FHandle, Buffer^, BytesRead, BytesWritten, nil) then
            HR := S_FALSE;
      until (HR <> S_OK) or (BytesRead = 0);
      Result := True;
    finally
      FreeMem(Buffer);
    end;
  finally
    CloseHandle(FHandle);
  end;
end;

function GetTempA: AnsiString;
var
  C: Integer;
begin
  C := GetTempPathA(0, nil);
  SetLength(Result, C);
  GetTempPathA(C, @Result[1]);
  SetLength(Result, C - 1);
end;

function IsDirectoryA(const Name: AnsiString): Boolean;
var
  Data: TWin32FileAttributeData;
begin
  GetFileAttributesExA(PChar(Name), GetFileExInfoStandard, @Data);
  Result := (Data.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) <> 0;
end;

function IsFileA(const Name: AnsiString): Boolean;
var
  Data: TWin32FileAttributeData;
begin
  GetFileAttributesExA(PChar(Name), GetFileExInfoStandard, @Data);
  Result := ((Data.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) = 0) and
    ((Data.dwFileAttributes and FILE_ATTRIBUTE_DEVICE) = 0);
end;

function IsVolumeA(const Name: AnsiString): Boolean;
var
  VolName: AnsiString;
  DType: Cardinal;
begin
  if (Name = '') then
  begin
    Result := False;
    Exit;
  end;

  if Name[Length(Name)] <> PathDelim then
    VolName := Name + PathDelim
  else
    VolName := Name;

  DType := GetDriveTypeA(PChar(Name));
  Result := DType <> DRIVE_NO_ROOT_DIR;
end;
{$ENDIF}

{ TShellDropper }

procedure TShellDropper.ClearDropRec;
begin
  if FDropRec.RemoveTemporary then
    RemoveTemporary;
  FFiles.Clear;
  {$IFDEF WIDESTRINGS}
  FFilesW.Clear;
  {$ENDIF}
  FDropRec.URL := '';
  Finalize(FDropRec.FileTypes);
  FFillState := dsNone;
end;

constructor TShellDropper.Create(AOwner: TComponent);
begin
  inherited;
  FFiles := TStringList.Create;
  {$IFDEF WIDESTRINGS}
  FFilesW := TWideStringList.Create;
  {$ENDIF}
  FControls := TDropControls.Create(Self);
end;

destructor TShellDropper.Destroy;
begin
  FreeAndNil(FControls);
  FFiles.Free;
  {$IFDEF WIDESTRINGS}
  FFilesW.Free;
  {$ENDIF}
  Finalize(FDropRec);
  inherited;
end;

function TShellDropper.DragEnter(const dataObj: IDataObject;
  grfKeyState: Integer; pt: TPoint; var dwEffect: Integer): HResult;
begin
  FDropped := False;
  FillObjects(dataObj, dsEnter);
  FAccepted := FIsValid;

  FControl := FControls.GetControlUnderCursor;

  if FAccepted then
  begin
    if Assigned(FOnDragEnter) then
    begin
      PrepareRec(pt, grfKeyState);
      FOnDragEnter(FControl, FDropRec, FAccepted);
    end;
  end;

  if FAccepted then
    dwEffect := GetCursor
  else
    dwEffect := DROPEFFECT_NONE;

  Result := S_OK;
end;

function TShellDropper.DragLeave: HResult;

  function IsInControl: Boolean;
  begin
    Result := Assigned(FControl) and (FControl = FControls.GetControlUnderCursor);
  end;

begin
  if FAccepted and not FDropped then
  begin
    if IsInControl then
    begin
      if Assigned(FOnCancelDrag) then
        FOnCancelDrag(FControl);
      ClearDropRec;
    end
    else
    begin
      if Assigned(FOnDragLeave) then
        FOnDragLeave(FControl);
    end;
  end;
  FControl := nil;
  Result := S_OK;
end;

function TShellDropper.DragOver(grfKeyState: Integer; pt: TPoint;
  var dwEffect: Integer): HResult;
begin
  if Assigned(FOnDragOver) then
  begin
    PrepareRec(pt, grfKeyState);
    FOnDragOver(FControl, FDropRec, FAccepted);
  end;
  dwEffect := GetCursor;

  Result := S_OK;
end;

function TShellDropper.Drop(const dataObj: IDataObject; grfKeyState: Integer;
  pt: TPoint; var dwEffect: Integer): HResult;
begin
  FDropped := True;
  if FAccepted then
  begin
    if Assigned(FOnDrop) then
    begin
      FillObjects(dataObj, dsDrop);
      PrepareRec(pt, grfKeyState);
      FOnDrop(FControl, FDropRec);
    end;
    dwEffect := GetCursor;
  end else
    dwEffect := DROPEFFECT_NONE;
  ClearDropRec;
  Result := S_OK;
end;

procedure TShellDropper.FillFileTypes(Temporary: Boolean);
var
  C: Integer;
begin
  {$IFDEF WIDESTRINGS}
  SetLength(FDropRec.FileTypes, FFilesW.Count);
  for C := 0 to FFiles.Count - 1 do
  begin
    FDropRec.FileTypes[C] := [];
    if IsDirectoryW(FFilesW[C]) then
      Include(FDropRec.FileTypes[C], ftDirectory);
    if IsVolumeW(FFilesW[C]) then
      Include(FDropRec.FileTypes[C], ftVolume);
    if IsFileW(FFilesW[C]) then
      Include(FDropRec.FileTypes[C], ftFile);
    if Temporary then
      Include(FDropRec.FileTypes[C], ftTemporary);
  end;
  {$ELSE}
  SetLength(FDropRec.FileTypes, FFiles.Count);
  for C := 0 to FFiles.Count - 1 do
  begin
    FDropRec.FileTypes[C] := [];
    if IsDirectoryA(FFiles[C]) then
      Include(FDropRec.FileTypes[C], ftDirectory);
    if IsVolumeA(FFiles[C]) then
      Include(FDropRec.FileTypes[C], ftVolume);
    if IsFileA(FFiles[C]) then
      Include(FDropRec.FileTypes[C], ftFile);
    if Temporary then
      Include(FDropRec.FileTypes[C], ftTemporary);
  end;
  {$ENDIF}
end;

procedure TShellDropper.FillObjects(const dataObj: IDataObject;
  DropState: TDropState);
var
  Medium: TStgMedium;
  Format: TFORMATETC;
  Drop: Pointer;
begin
  if FFillState = DropState then
    Exit;
  CheckValid(dataObj);
  if FIsFileGroup then
  begin
    ProcessFileGroup(dataObj, DropState);
    FFillState := DropState;
    Exit;
  end;

  FillChar(Format, SizeOf(Format), 0);
  Format.cfFormat := Formats[FDropSource];
  Format.lindex := -1;
  Format.dwAspect := 1;
  Format.tymed := TYMED_HGLOBAL;

  if dataObj.GetData(Format, Medium) = S_OK then
  begin
    Drop := GlobalLock(Medium.hGlobal);
    try
      case FDropSource of
        dsShell:
          ProcessDropFiles(HDrop(Drop));
        dsURL:
          ProcessDropURL(PWideChar(Drop));
      end;
    finally
      GlobalUnlock(Medium.hGlobal);
    end;
    ReleaseStgMedium(Medium);
    FFillState := DropState;
  end;
end;

function TShellDropper.GetCursor: Integer;
begin
  if not FAccepted then
    Result := DROPEFFECT_NONE
  else
  begin
    case FDragCursor of
      dgCopy: Result := DROPEFFECT_COPY;
      dgMove: Result := DROPEFFECT_MOVE;
      else
        Result := DROPEFFECT_LINK;
    end;
    if FDropSource = dsURL then
      Result := DROPEFFECT_LINK;
  end;
end;

function TShellDropper.GetMouseButton(KeyState: Integer): TMouseButton;
begin
  if KeyState and MK_RBUTTON = MK_RBUTTON then
    Result := mbRight
  else
    if KeyState and MK_MBUTTON = MK_MBUTTON then
      Result := mbMiddle
      else
        Result := mbLeft;
end;

function TShellDropper.GetShiftState(KeyState: Integer): TShiftState;
begin
  Result := [];

  if KeyState and MK_SHIFT = MK_SHIFT then
    Include(Result, ssShift);

  if KeyState and MK_CONTROL = MK_CONTROL then
    Include(Result, ssCtrl);

  if KeyState and MK_ALT = MK_ALT then
    Include(Result, ssAlt);
end;

function TShellDropper.IsFileDescriptor(const dataObj: IDataObject): Boolean;
var
  MediumDesc, MediumContents: TStgMedium;
  FormatDesc, FormatContents: TFORMATETC;
  C: Integer;
  {$IFDEF WIDESTRINGS}
  FGD: PFileGroupDescriptorW;
  {$ELSE}
  FGD: PFileGroupDescriptorA;
  {$ENDIF}
  HR: HResult;
begin
  Result := False;

  FillChar(FormatDesc, SizeOf(FormatDesc), 0);
  FormatDesc.lindex := -1;
  FormatDesc.dwAspect := 1;
  FormatDesc.tymed := TYMED_HGLOBAL;
  {$IFDEF WIDESTRINGS}
  FormatDesc.cfFormat := RegisterClipBoardFormat(CFSTR_FILEDESCRIPTORW);
  {$ELSE}
  FormatDesc.cfFormat := RegisterClipBoardFormat(CFSTR_FILEDESCRIPTORA);
  {$ENDIF}

  FillChar(FormatContents, SizeOf(FormatContents), 0);
  FormatContents.lindex := -1;
  FormatContents.dwAspect := 1;
  FormatContents.tymed := TYMED_ISTREAM;
  FormatContents.cfFormat := RegisterClipBoardFormat(CFSTR_FILECONTENTS);

  if dataObj.GetData(FormatDesc, MediumDesc) = S_OK then
  try
    FGD := GlobalLock(MediumDesc.hGlobal);
    try
      for C := 0 to FGD.cItems - 1 do
      begin
        FormatContents.lindex := C;
        HR := dataObj.GetData(FormatContents, MediumContents);
        if (HR <> S_OK) or (MediumContents.stm = nil) then
          Exit;
      end;
    finally
      GlobalUnlock(MediumDesc.hGlobal);
    end;
  finally
    GlobalFree(MediumDesc.hGlobal);
  end else
    Exit;
  Result := True;
end;

procedure TShellDropper.CheckValid(const dataObj: IDataObject);
var
  Format: TFORMATETC;
  C: TDropSource;
begin
  FIsValid := False;
  FIsFileGroup := False;

  if IsFileDescriptor(dataObj) then
  begin
    FIsFileGroup := True;
    FDropSource := dsShell;
    FIsValid := True;
    Exit;
  end;

  FillChar(Format, SizeOf(Format), 0);
  Format.lindex := -1;
  Format.dwAspect := 1;
  Format.tymed := TYMED_HGLOBAL;
  for C := Low(TDropSource) to High(TDropSource) do
  begin
    Format.cfFormat := Formats[C];
    if dataObj.QueryGetData(Format) = S_OK then
    begin
      FDropSource := C;
      FIsValid := True;
      Exit;
    end;
  end;
end;

procedure TShellDropper.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if (Operation = opRemove) and Assigned(FControls) then
  begin
    FControls.RemoveControl(AComponent);
    if (csDestroying in Application.ComponentState) then
      FControls.Clear;
  end;
  inherited;
end;

procedure TShellDropper.PrepareRec(Pt: TPoint; grfKeyState: Integer);
begin
  if Assigned(FControl) then
    FDropRec.Pt := FControl.ScreenToClient(pt)
  else
    FDropRec.Pt := pt;
  FDropRec.Button := GetMouseButton(grfKeyState);
  FDropRec.Shift := GetShiftState(grfKeyState);
  FDropRec.Files := FFiles;
  {$IFDEF WIDESTRINGS}
  FDropRec.FilesW := FFilesW;
  {$ENDIF}
  FDropRec.DropSource := FDropSource;
  FDropRec.RemoveTemporary := True;
end;

procedure TShellDropper.ProcessDropFiles(Drop: HDrop);

  {$IFDEF WIDESTRINGS}
  procedure AddFilesW;
  var
    FileName: PWideChar;
    Count: Integer;
    C: Integer;
    Size: Integer;
  begin
    Count := DragQueryFileW(Drop, $FFFFFFFF, nil, MAX_PATH);
    for C := 0 to Count - 1 do
    begin
      Size := DragQueryFileW(Drop, C, nil, 0) + 1;
      FileName := PWideChar(StrAlloc(Size * SizeOf(WideChar)));
      try
        DragQueryFileW(Drop, C, FileName, Size);
        FFiles.Add(FileName);
        FFilesW.Add(FileName);
      finally
        StrDispose(PChar(FileName));
      end;
    end;
  end;
  {$ELSE}

  procedure AddFilesA;
  var
    FileName: PChar;
    Count: Integer;
    C: Integer;
    Size: Integer;
  begin
    Count := DragQueryFileA(Drop, $FFFFFFFF, nil, MAX_PATH);
    for C := 0 to Count - 1 do
    begin
      Size := DragQueryFileA(Drop, C, nil, 0) + 1;
      FileName := StrAlloc(Size);
      try
        DragQueryFileA(Drop, C, FileName, Size);
        FFiles.Add(FileName);
      finally
        StrDispose(FileName);
      end;
    end;
  end;
  {$ENDIF}

begin
  FFiles.BeginUpdate;
  {$IFDEF WIDESTRINGS}
  FFilesW.BeginUpdate;
  {$ENDIF}
  try
    ClearDropRec;

    {$IFDEF WIDESTRINGS}
    AddFilesW;
    {$ELSE}
    AddFilesA;
    {$ENDIF}
  finally
    FFiles.EndUpdate;
    {$IFDEF WIDESTRINGS}
    FFilesW.EndUpdate;
    {$ENDIF}
  end;
  FillFileTypes(False);
end;

procedure TShellDropper.ProcessDropURL(URL: PWideChar);
begin
  CleardropRec;
  FDropRec.URL := URL;
end;

procedure TShellDropper.ProcessFileGroup(const dataObj: IDataObject;
  DropState: TDropState);

  {$IFDEF WIDESTRINGS}
  procedure SaveFilesW;
  var
    MediumDesc, MediumContents: TStgMedium;
    FormatDesc, FormatContents: TFORMATETC;
    C: Integer;
    FGD: PFileGroupDescriptorW;
    TempPath: WideString;
    FileName: WideString;
    HR: HResult;
  begin
    TempPath := GetTempW;
    FillChar(FormatContents, SizeOf(FormatContents), 0);
    FormatContents.lindex := -1;
    FormatContents.dwAspect := 1;
    FormatContents.tymed := TYMED_ISTREAM;
    FormatContents.cfFormat := RegisterClipBoardFormat(CFSTR_FILECONTENTS);

    FillChar(FormatDesc, SizeOf(FormatDesc), 0);
    FormatDesc.lindex := -1;
    FormatDesc. dwAspect := 1;
    FormatDesc.tymed := TYMED_HGLOBAL;
    FormatDesc.cfFormat := RegisterClipBoardFormat(CFSTR_FILEDESCRIPTORW);

    if dataObj.GetData(FormatDesc, MediumDesc) = S_OK then
    try
      FGD := GlobalLock(MediumDesc.hGlobal);
      try
        for C := 0 to FGD.cItems - 1 do
        begin
          FileName := TempPath + FGD.fgd[C].cFileName;
          FFiles.Add(FileName);
          FFilesW.Add(FileName);

          if DropState = dsDrop then
          begin
            // Save each Stream to temp file
            FormatContents.lindex := C;
            HR := dataObj.GetData(FormatContents, MediumContents);
            if not ((HR = S_OK) and
               (MediumContents.stm <> nil) and
               SaveStreamW(IStream(MediumContents.stm), FileName)) then
            begin
              FFiles.Delete(FFiles.Count - 1);
              FFilesW.Delete(FFilesW.Count - 1);
            end;
          end;
        end;
      finally
        GlobalUnlock(MediumDesc.hGlobal);
      end;
    finally
      GlobalFree(MediumDesc.hGlobal);
    end;
  end;
  {$ELSE}
  procedure SaveFilesA;
  var
    MediumDesc, MediumContents: TStgMedium;
    FormatDesc, FormatContents: TFORMATETC;
    C: Integer;
    FGD: PFileGroupDescriptorA;
    TempPath: AnsiString;
    FileName: AnsiString;
    HR: HResult;
  begin
    TempPath := GetTempA;
    FillChar(FormatContents, SizeOf(FormatContents), 0);
    FormatContents.lindex := -1;
    FormatContents.dwAspect := 1;
    FormatContents.tymed := TYMED_ISTREAM;
    FormatContents.cfFormat := RegisterClipBoardFormat(CFSTR_FILECONTENTS);

    FillChar(FormatDesc, SizeOf(FormatDesc), 0);
    FormatDesc.lindex := -1;
    FormatDesc.dwAspect := 1;
    FormatDesc.tymed := TYMED_HGLOBAL;
    FormatDesc.cfFormat := RegisterClipBoardFormat(CFSTR_FILEDESCRIPTORA);

    if dataObj.GetData(FormatDesc, MediumDesc) = S_OK then
    try
      FGD := GlobalLock(MediumDesc.hGlobal);
      try
        for C := 0 to FGD.cItems - 1 do
        begin
          FileName := TempPath + FGD.fgd[C].cFileName;
          FFiles.Add(FileName);

          if DropState = dsDrop then
          begin
            // Save each Stream to temp file
            FormatContents.lindex := C;
            HR := dataObj.GetData(FormatContents, MediumContents);
            if not ((HR = S_OK) and
               (MediumContents.stm <> nil) and
               SaveStreamA(IStream(MediumContents.stm), FileName)) then
            begin
              FFiles.Delete(FFiles.Count - 1);
            end;
          end;
        end;
      finally
        GlobalUnlock(MediumDesc.hGlobal);
      end;
    finally
      GlobalFree(MediumDesc.hGlobal);
    end;
  end;
  {$ENDIF}

begin
  FFiles.BeginUpdate;
  {$IFDEF WIDESTRINGS}
  FFilesW.BeginUpdate;
  {$ENDIF}
  try
    ClearDropRec;

    {$IFDEF WIDESTRINGS}
    SaveFilesW;
    {$ELSE}
    SaveFilesA;
    {$ENDIF}
  finally
    FFiles.EndUpdate;
    {$IFDEF WIDESTRINGS}
    FFilesW.EndUpdate;
    {$ENDIF}
  end;
  FillFileTypes(True);
end;

procedure TShellDropper.RemoveTemporary;
var
  C: Integer;
begin
  {$IFDEF WIDESTRINGS}
  for C := 0 to FDropRec.FilesW.Count - 1 do
    if ftTemporary in FDropRec.FileTypes[C] then
      DeleteFileW(PWideChar(FDropRec.FilesW[C]));
  {$ELSE}
  for C := 0 to FDropRec.Files.Count - 1 do
    if ftTemporary in FDropRec.FileTypes[C] then
      DeleteFile(FDropRec.Files[C]);
  {$ENDIF}
end;

procedure TShellDropper.SetControls(const Value: TDropControls);
begin
  FControls.Assign(Value);
end;

{ TDropControl }

function TDropControl.CanProcessControl: Boolean;
begin
   Result := Assigned(FControl) and not IsDesigning;
end;

constructor TDropControl.Create(Collection: TCollection);
begin
  if not (Collection is TDropControls) then
    raise Exception.Create('Collection must be TDropControls.');
  inherited;

  FDropControls := TDropControls(Collection);
end;

function TDropControl.IsDesigning: Boolean;
begin
  Result := csDesigning in FDropControls.FShellDropper.ComponentState;
end;

destructor TDropControl.Destroy;
begin
  Enabled := False;
  Control := nil;
  inherited;
end;

procedure TDropControl.Disable;
begin
  if FRegistered then
  begin
    if RevokeDragDrop(FControlHandle) = S_OK then
      FRegistered := False;
  end;
end;

procedure TDropControl.Enable;
begin
  if not FRegistered and CanProcessControl then
  begin
    if RegisterDragDrop(FControl.Handle, FDropControls.FShellDropper) = S_OK then
    begin
      FRegistered := True;
      FControlHandle := FControl.Handle;
    end;
  end;
end;

function TDropControl.GetEnabled: Boolean;
begin
  if IsDesigning then
    Result := FEnabled
  else
    Result := FRegistered;
end;

procedure TDropControl.SetControl(const Value: TWinControl);
begin
  if FRegistered then
    Disable;

  SetNotification(inRemove);

  FControl := Value;

  SetNotification(inInsert);

  if FEnabled then
    Enable;
end;

procedure TDropControl.SetEnabled(const Value: Boolean);
begin
  FEnabled := Value;

  if Value then
    Enable
  else
    Disable;
end;

procedure TDropControl.SetNotification(Action: TItemNotification);
begin
  if CanProcessControl then
  case Action of
    inInsert:
      FControl.FreeNotification(FDropControls.FShellDropper);
    inRemove:
      FControl.RemoveFreeNotification(FDropControls.FShellDropper);
  end;
end;

{ TDropControls }

constructor TDropControls.Create(Dropper: TShellDropper);
begin
  inherited Create(TDropControl);
  FShellDropper := Dropper;
end;

destructor TDropControls.Destroy;
begin

  inherited;
end;

function TDropControls.GetControlUnderCursor: TWinControl;
var
  Handle: THandle;
  Control: TWinControl;
  C: Integer;
begin
  Handle := WindowFromPoint(Mouse.CursorPos);

  if Handle <> 0 then
  begin
    Control := FindControl(Handle);

    while Assigned(Control) do
    begin
      C := IndexOf(Control);
      if (C <> -1) and GetItem(C).Enabled then
      begin
        Result := Control;
        Exit;
      end;

      Control := Control.Parent;
    end;
  end;
  Result := nil;
end;

function TDropControls.GetItem(Index: Integer): TDropControl;
begin
  Result := TDropControl(inherited GetItem(Index));
end;

function TDropControls.GetOwner: TPersistent;
begin
  Result := FShellDropper;
end;

function TDropControls.IndexOf(Control: TWinControl): Integer;
begin
  for Result := 0 to Count - 1 do
    if GetItem(Result).Control = Control then
      Exit;
  Result := -1;
end;

procedure TDropControls.RemoveControl(Control: TComponent);
var
  C: Integer;
begin
  for C := Count - 1 downto 0 do
    if GetItem(C).Control = Control then
      Delete(C);
end;

procedure TDropControls.SetItem(Index: Integer; const Value: TDropControl);
begin
  inherited SetItem(Index, Value);
end;

initialization
  OleInitialize(nil);
  Formats[dsShell] := CF_HDROP;
  Formats[dsURL] := RegisterClipboardFormat('UniformResourceLocatorW');
end.

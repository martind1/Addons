unit L17MD_Kmp;
(* Erweiterung der L&L Komponenten DBL8_
   * Unterstützung bis zu 10 Datasources in MD-Report

   Autor: Bernard Greb, Martin Dambach
   Letzte Änderung:
   01.03.02 BG     Erstellen
   17.03.02 MD     Designer, Print Schleifen überarb. Variablen DetailTable
   21.12.03 MD     letzte Detail-Zeile wird u.U. 2mal ausgegeben
                   Lsg:mdMaster Datasources in TLlPrn-Kmp mit Leereintrag trennen
   14.03.04 MD     auch bei Label können Detailsources genannt werden
   23.04.12 MD     LL17, D2010

==================================================================================
Erweiterungen:
- DataLink[0..9]
- Variable LL.DetailTable
- zusätzliche Übergabe von Text in Auswahlfeldern in <Feldname>_TEXT

- automatisches Öffnen der DataSets
- Mastersource.dataset kann disabled sein
  - trotzdem CalcFields rechnen (in OnRech, OnGet, OnCalcFields)

todo
   08.09.04 MD  bei MDMany ist in 'Bedingungen' LL.DetailTable=<Table> zu verwenden

==================================================================================
Vorausgesetzte DLLs (in Win\System):
  - cmL17*
*)


interface

uses
  SysUtils,
  WinProcs,
  Classes,
  Forms,
  cmbtLL17,
  db,
  dbtables, Uni, DBAccess, MemDS,
  dialogs,
  WinTypes{$IFDEF win32},
  registry{$ELSE},
  IniFiles{$ENDIF},
  l17, l17db;

const
  MaxLlDataSource = 10;

//{$IFDEF UNICODE}
//type
//  TString = WideString;
//{$ELSE}
//type
//  TString = string;
//{$ENDIF}


type

{*TL17MD is the new MasterDetail List & Label component*}

  TaDataSource = array[0..pred(MaxLlDataSource)] of TDataSource;

  TL17MD = class(TL17_)
  private
    (*AutoDefine*)
    bAutoDefine: boolean;
    bAutoShowSelectFile: boolean;
    bAutoShowPrintOptions: boolean;
    FDesignerFile: TLlDesignerFile;
    FAutoProjectType: TAutoProjectType;
    FAutoDestination: TAutoDestination;
    FDataLink: array[0..pred(MaxLlDataSource)] of TDataLink;
    FMasterLink: TDataLink;
    FAutoMasterMode: TAutoMasterMode;

    FOnAutoDefineField: TAutoDefineFieldEvent;
    FOnAutoDefineVariable: TAutoDefineVariableEvent;
    FOnAutoDefineNewPage: TAutoDefineNewPageEvent;
    FOnAutoDefineNewLine: TAutoDefineNewLineEvent;

    FRecNo: integer;
    FAutoMasterPrefix: TString;
    FAutoDetailPrefix: TString;

  protected

    UnUsedFields: TStringList;

    function GetAutoShowSelectFile: TPropYesNo;
    procedure SetAutoShowSelectFile(nMode: TPropYesNo);

    function GetAutoShowPrintOptions: TPropYesNo;
    procedure SetAutoShowPrintOptions(nMode: TPropYesNo);


    function GetAutoDefine: TPropYesNo;
    procedure SetAutoDefine(nMode: TPropYesNo);

    procedure SetAutoMasterMode(value: TAutoMasterMode);

    procedure OpenDS(Index: integer);

    function GetDataSource(Index: integer): TDataSource;
    procedure SetDataSource(Index: integer; Value: TDataSource);

    function GetMasterSource: TDataSource;
    procedure SetMasterSource(Value: TDataSource);

    procedure SetAutoDetailPrefix(const Value: TString);
    procedure SetAutoMasterPrefix(const Value: TString);


    function GetDesignerFile: TLlDesignerFile;
    procedure SetDesignerFile(value: TLlDesignerFile);

    procedure SetAutoDestination(value: TAutoDestination);

    procedure SetAutoProjectType(value: TAutoProjectType);

    procedure DataAutoDefine(nUserData: longint; bDummy: longint;
      pnProgressInPerc: PLongint; pbLastRecord: PLongint; var lResult: longint;
      bAsFields: boolean; Source: TDataSource; nMaster: integer);

    procedure SetAutoOptions(var nObjectType: integer; var nPrintOptions: integer);

    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

  public
    RecordCount: integer; {für Fortschrittsanzeige}
    Kopien: integer; {Vorgabe in llPrn}
    ExportType: string; {für Export. 'PDF' oder 'HTML'. MD08.05.04}
    UsePageCount: boolean; {true = 2-Pass Durchgang, Variable PageCount vorhanden}
    PageCount: integer; {Anzahl Seiten}
    CalcPageCount: boolean; {Flag 1.Pass für Bestimmung der PageCount}

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function Design(UserData: integer; ParentHandle: cmbtHWND; Title: TString; ProjectType: integer;
      ProjectName: TString; ShowFileSelect: boolean; AllowCreate: boolean): integer; override;
//23.04.12 alt
//    function Design(nUserData: longint; hWnd: HWND; sTitle: TString;
//      nObjType: longint; sObjName: TString; bWithFileSelect: longint): longint; override;

    function Print(UserData: integer; ProjectType: integer; ProjectName: TString; ShowFileSelect: boolean;
      PrintOptions: integer; BoxType: integer; ParentHandle: cmbtHWND; Title: TString;
      ShowPrintOptions: boolean; TempPath: TString): integer; override;
//23.04.12 alt
//    function Print(nUserData: longint; nObjType: longint; sObjName: TString; bWithFileSelect: longint;
//      nPrintOptions: longint; nBoxType: longint; hWnd: HWND; sTitle: TString;
//      bShowPrintOptionsDlg: longint; sTempPath: TString): longint; override;

    function AutoPrint(sTitle: TString; sTempPath: TString): longint;
    function AutoDesign(sTitle: TString): longint;

    property AutoMasterPrefix: TString read FAutoMasterPrefix write SetAutoMasterPrefix;
    property AutoDetailPrefix: TString read FAutoDetailPrefix write SetAutoDetailPrefix;

    property DataSource[Index: integer]: TDataSource read GetDataSource write SetDataSource;
  published
    property AutoShowPrintOptions: TPropYesNo read GetAutoShowPrintOptions write SetAutoShowPrintOptions;
    property AutoShowSelectFile: TPropYesNo read GetAutoShowSelectFile write SetAutoShowSelectFile;
    property AutoDefine: TPropYesNo read GetAutoDefine write SetAutoDefine;
    property MasterSource: TDataSource read GetMasterSource write SetMasterSource;
    property AutoDesignerFile: TLlDesignerFile read GetDesignerFile write SetDesignerFile;
    property AutoProjectType: TAutoProjectType read FAutoProjectType write SetAutoProjectType;
    property AutoDestination: TAutoDestination read FAutoDestination write SetAutoDestination;
    property AutoMasterMode: TAutoMasterMode read FAutoMasterMode write SetAutoMasterMode;
    property OnAutoDefineNewPage: TAutoDefineNewPageEvent read FOnAutoDefineNewPage write FOnAutoDefineNewPage;
    property OnAutoDefineField: TAutoDefineFieldEvent read FOnAutoDefineField write FOnAutoDefineField;
    property OnAutoDefineVariable: TAutoDefineVariableEvent read FOnAutoDefineVariable write FOnAutoDefineVariable;
    property OnAutoDefineNewLine: TAutoDefineNewLineEvent read FOnAutoDefineNewLine write FOnAutoDefineNewLine;

  end;

procedure StrPCopyExt(var Dest: ptChar; Source: TString; MinSize: Integer);
function StrPasExt(Str: ptChar): TString;
function FileContains(aFilename, aToken: string): boolean;
// Textdatei enthält Zeichenkette (exakt)

implementation

uses
  cmbtls17;

const
  SMaster = 'Master';
  SDetail = 'Detail';

procedure ShowFileWarning;
{Raises an EDBLlFileError, if filename is unknown}
begin
  raise EDBLlFileError.create('List && Label could not process this request. Project does not exist');
end;

procedure ShowPipeWarning;
{Raises an EDBLlPipeError, if pipe is not active}
begin
  raise EDBLlPipeError.create('List && Label could not process this request. Probably the Data Pipe is not active');
end;

{*----------------------------------------------------------------------------*}
{TL17MD component implementation                                               }
{*----------------------------------------------------------------------------*}

constructor TL17MD.create(AOwner: TComponent);
var
  I: integer;
begin
  inherited create(AOwner);
  for I := 0 to pred(MaxLlDataSource) do
    FDataLink[i] := TDataLink.create;
  FMasterLink := TDataLink.create;
  UnUsedFields := TStringList.Create;
  UnUsedFields.Sorted := true;
  UnUsedFields.Duplicates := dupIgnore;
  FDesignerFile := '';
  FAutoMasterPrefix := SMaster;
  FAutoDetailPrefix := SDetail;
  AutoDefine := Yes;
end;


destructor TL17MD.destroy;
var
  i: integer;
begin
  for i := 0 to pred(MaxLlDataSource) do
    FDataLink[i].free;
  FMasterLink.free;
  UnUsedFields.Free;
  inherited destroy;
end;

function TL17MD.GetAutoShowSelectFile: TPropYesNo;

begin
  if bAutoShowSelectFile then
    Result := Yes
  else
    Result := No;
end;

procedure TL17MD.SetAutoShowSelectFile(nMode: TPropYesNo);

begin
  if nMode = Yes then bAutoShowSelectFile := true
  else
    bAutoShowSelectFile := false;
end;

function TL17MD.GetAutoShowPrintOptions: TPropYesNo;

begin
  if bAutoShowPrintOptions then
    Result := Yes
  else
    Result := No;
end;


procedure TL17MD.SetAutoShowPrintOptions(nMode: TPropYesNo);

begin
  if nMode = Yes then bAutoShowPrintOptions := true
  else
    bAutoShowPrintOptions := false;
end;


function TL17MD.GetAutoDefine: TPropYesNo;
begin
  if bAutoDefine then
    Result := Yes
  else
    Result := No;
end;

procedure TL17MD.SetAutoDefine(nMode: TPropYesNo);
begin
  if (nMode = Yes) {and
     ((Assigned(FDataLink.DataSource)) or (csLoading in ComponentState))}then
  begin
    bAutoDefine := true;
    //23.04.12 alt
//    EnableDefineFieldsEvent := false;
//    EnableDefineVariablesEvent := false;
  end else
  begin
    bAutoDefine := false;
  end;
end;


procedure TL17MD.OpenDS(Index: integer);
{Öffnet ein Detail Dataset. Füllt Parameter. DS Kann Disabled sein}
var
  I: integer;
  aQuery: TUniQuery;
  aField: TField;
  QueryX: TUniQuery;
begin
  if FDataLink[Index].DataSet = nil then
    Exit;
  //UniDAC: 22.05.12
  if (FDataLink[Index].DataSet is TUniQuery) then // beware: FDataLink[Index].DataSet.ControlsDisabled da nur Master disabled
  begin
    aQuery := TUniQuery(FDataLink[Index].DataSet);
    aQuery.Close;
    for I := 0 to aQuery.Params.Count - 1 do
    begin
      aField := aQuery.DataSource.DataSet.FindField(
        aQuery.Params[I].Name);
      if aField <> nil then
      begin
        aQuery.Params[I].AssignField(aField);
        //aQuery.Params[I].Bound := false;  //22.05.12 ergibt ORA-01008: Nicht allen Variablen ist ein Wert zugeordnet
      end;
    end;
  end;
  FDataLink[Index].DataSet.Open;
end;

function TL17MD.GetDataSource(Index: integer): TDataSource;
begin
  Result := FDataLink[Index].DataSource;
end;

procedure TL17MD.SetDataSource(Index: integer; Value: TDatasource);
begin
  FDataLink[Index].DataSource := Value;
{$IFDEF win32}
  if Value <> nil then
    Value.FreeNotification(self);
{$ENDIF}
end;

function TL17MD.GetMasterSource: TDataSource;
begin
  Result := FMasterLink.DataSource;
end;

procedure TL17MD.SetMasterSource(Value: TDatasource);
begin
  FMasterLink.DataSource := Value;
{$IFDEF win32}
  if Value <> nil then
    Value.FreeNotification(self);
{$ENDIF}
end;


function TL17MD.GetDesignerFile: TLlDesignerFile;
begin
  Result := FDesignerFile;
end;

procedure TL17MD.SetDesignerFile(value: TLlDesignerFile);
begin
  FDesignerFile := value;
end;

procedure TL17MD.SetAutoProjectType(value: TAutoProjectType);
begin
  FAutoProjectType := value;
end;

procedure TL17MD.SetAutoDestination(value: TAutoDestination);
begin
  FAutoDestination := value;
  if value = adUserSelect then
    AutoShowPrintOptions := Yes;
end;

procedure TL17MD.SetAutoMasterMode(value: TAutoMasterMode);

begin
  if (value <> mmNone) and
    ((FMasterLink.active and (AutoDefine = Yes)) or
    (csLoading in ComponentState)) then
    FAutoMasterMode := value else
    FAutoMasterMode := mmNone;
end;


procedure TL17MD.DataAutoDefine(nUserData: longint; bDummy: longint;
  pnProgressInPerc: PLongint; pbLastRecord: PLongint; var lResult: longint;
  bAsFields: boolean; Source: TDataSource; nMaster: integer);
(*Used if AutoDefine is switched on to declare fields / variables automatically
       from the datasource via FDataLink*)
{nMaster = LL_MASTER_NONE -> No Master/Detail;
 nMaster = LL_MASTER_DETAIL -> Data is Detail Data;
 nMaster = LL_MASTER_MASTER -> Data is Master Data}
var
  i: integer;
  para: longint;
  FieldName: ptchar;
  FieldContent: ptchar;
  SFieldName: TString;
  content: TString;
  sDummy: TString;
  handled: boolean;
  DefHandled: boolean;
  BlobStream: TStream;
  LBuffer: TBytes;
  LOffset: integer;
  LEncoding: TEncoding;
  StringStream: TStringStream;


  T, T0, T1, T2, T3, T4, T5: Cardinal;

  function GetFieldName: TString;
  begin
    result := Source.DataSet.Fields[i].FieldName;
    case nMaster of
      LL_MASTER_DETAIL:
        begin {immer: Datasources gruppieren}
          if (FDataLink[1].DataSource <> nil) or {nur bei MDMany}
            (self.AutoMasterMode = mmAsFields) then
            result := AutoDetailPrefix + '.' + result;
        end;
      LL_MASTER_MASTER:
        begin
          if self.AutoMasterMode = mmAsFields then
            result := AutoMasterPrefix + '.' + result;
        end;
    end;
  end;


begin
  T := GetCurrentTime;
  T1 := 0; T2 := 0; T3 := 0; T4 := 0; T5 := 0;
  T0 := T;
  GetMem(FieldName, 1);
  GetMem(FieldContent, 1);

  {if ((nMaster <> LL_MASTER_MASTER) and FDataLink[0].active ) or
     ((nMaster=LL_MASTER_MASTER) and FMasterLink.active ) then}

  if (Source <> nil) and (Source.DataSet <> nil) and (Source.DataSet.Active) then
  begin

    {Variable LL.DetailTable zur Darstellungsbedingung für Detailtabellen:}
    if nMaster = LL_MASTER_DETAIL then
      LlDefineFieldExt('LL.DetailTable', PChar(AutoDetailPrefix), LL_TEXT);
    if bAsFields and Assigned(FOnAutoDefineNewLine) and (nMaster <> LL_MASTER_MASTER) then
      OnAutoDefineNewLine(self, (bDummy = 1));

    Inc(T1, GetCurrentTime - T); T := GetCurrentTime;
    for i := 0 to (Source.DataSet.FieldCount - 1) do
    begin
      handled := false; // internal flag
      DefHandled := false; // callback flag
      SFieldName := GetFieldName;
      StrPCopyExt(FieldName, SFieldName, 0);
      Inc(T2, GetCurrentTime - T); T := GetCurrentTime;

      if bAsFields then
      begin
        if UnUsedFields.IndexOf(SFieldName) >= 0 then
        begin
          handled := true;
          //DefHandled := true;
        end else
        begin
        //test weg qupe 22.05.12
//          if LlPrintIsFieldUsed(FieldName) = 0 then
//          begin
//            UnUsedFields.Add(FieldName);
//            handled := true;
//          //DefHandled := true;
//          end;
        end;
      end;
      (* bAsFields and (LlPrintIsFieldUsed(FieldName) = 0) then
      begin
        handled := true;
        DefHandled := true;
      end;*)

      Inc(T3, GetCurrentTime - T); T := GetCurrentTime;
      case Source.DataSet.Fields[i].DataType of
        ftInteger, ftsmallint, ftFloat, ftWord: {numeric}
          begin
            para := LL_TEXT;
            SFieldName := GetFieldName + '_TEXT';
            content := Source.DataSet.Fields[i].Text; {Textdarstellung}
            if bAsFields then
            begin
              if Assigned(FOnAutoDefineField) then
                OnAutoDefineField(self, (bDummy = 1), SFieldName, Content, para, DefHandled);
              if DefHandled = false then
              begin
                StrPCopyExt(FieldContent, content, 0);
                StrPCopyExt(FieldName, SFieldName, 0);
                LlDefineFieldExt(FieldName, FieldContent, para);
              end;
            end else
            begin
              if Assigned(FOnAutoDefineVariable) then
                OnAutoDefineVariable(self, (bDummy = 1), SFieldName, Content, para, DefHandled);
              if DefHandled = false then
              begin
                StrPCopyExt(FieldContent, content, 0);
                StrPCopyExt(FieldName, SFieldName, 0);
                LlDefineVariableExt(FieldName, FieldContent, para);
              end;
            end;

            para := LL_NUMERIC;
            SFieldName := GetFieldName; {nochmal hier!}
            content := Source.DataSet.Fields[i].AsString; {erst hier!}
          end;
        ftDate: {date}
          begin
{$IFDEF win32}
            para := LL_DATE_DELPHI;
{$ELSE}
            para := LL_DATE_DELPHI_1;
{$ENDIF}
            if Source.DataSet.Fields[i].AsString = '' then
              content := '1e100' else {Flag invalid date}
              content := FloatToStr(StrToDate(Source.DataSet.Fields[i].AsString));
          end;
        ftBoolean: {boolean}
          begin
            para := LL_BOOLEAN;
            content := Source.DataSet.Fields[i].AsString;
          end;
{$IFDEF win32}
        ftBlob:
          begin {BLOB-Fields are regarded as RTF}
            para := LL_RTF;
{$IFDEF ver90}
            BlobStream := TBlobStream.Create(TBlobField(Source.DataSet.Fields[i]), bmRead);
{$ELSE}
            BlobStream := Source.DataSet.CreateBlobStream(Source.DataSet.Fields[i], bmRead);
{$ENDIF}
            SetLength(LBuffer, BlobStream.Size);
            BlobStream.ReadBuffer(Pointer(LBuffer)^, Length(LBuffer));
            // Identify encoding and convert buffer to Unicode.
            LOffset := TEncoding.GetBufferEncoding(LBuffer, LEncoding);
            LBuffer := LEncoding.Convert(LEncoding, TEncoding.Unicode, LBuffer,
              LOffset, Length(LBuffer) - LOffset);
            StringStream := TStringStream.Create(LBuffer);

            if bAsFields then
            begin
              if Assigned(FOnAutoDefineField) then
              begin
                sDummy := 'BLOB';
                OnAutoDefineField(self, (bDummy = 1), SFieldName, sDummy, para, DefHandled);
              end;
              if DefHandled = false then
              begin
                LlDefineFieldExt(FieldName, StringStream.DataString, para);
              end;
            end else
            begin
              if Assigned(FOnAutoDefineVariable) then
              begin
                sDummy := 'BLOB';
                OnAutoDefineVariable(self, (bDummy = 1), SFieldName, sDummy, para, DefHandled);
              end;
              if DefHandled = false then
              begin
                LlDefineVariableExt(FieldName, StringStream.DataString, para);
              end;
            end;
            BlobStream.Free;
            StringStream.Free;
            handled := true;
          end;
{$ENDIF}
      else {text variables}
        para := LL_TEXT;
        if Source.DataSet.Fields[i].Tag > 0 then {Auswahlfeld: _TEXT}
        begin
          SFieldName := GetFieldName + '_TEXT';
          content := Source.DataSet.Fields[i].Text; {Auswahltext}
          if bAsFields then
          begin
            if Assigned(FOnAutoDefineField) then
              OnAutoDefineField(self, (bDummy = 1), SFieldName, Content, para, DefHandled);
            if DefHandled = false then
            begin
              StrPCopyExt(FieldContent, content, 0);
              StrPCopyExt(FieldName, SFieldName, 0);
              LlDefineFieldExt(FieldName, FieldContent, para);
            end;
          end else
          begin
            if Assigned(FOnAutoDefineVariable) then
              OnAutoDefineVariable(self, (bDummy = 1), SFieldName, Content, para, DefHandled);
            if DefHandled = false then
            begin
              StrPCopyExt(FieldContent, content, 0);
              StrPCopyExt(FieldName, SFieldName, 0);
              LlDefineVariableExt(FieldName, FieldContent, para);
            end;
          end;
        end;
        SFieldName := GetFieldName; {nochmal hier!}
        content := Source.DataSet.Fields[i].AsString; {erst hier!}
      end; {case}
      Inc(T4, GetCurrentTime - T); T := GetCurrentTime;

      if not (handled) then
      begin
        if bAsFields then
        begin
          if Assigned(FOnAutoDefineField) then
            OnAutoDefineField(self, (bDummy = 1), SFieldName, Content, para, DefHandled);
          if DefHandled = false then
          begin
            StrPCopyExt(FieldContent, content, 0);
            StrPCopyExt(FieldName, SFieldName, 0);
            LlDefineFieldExt(FieldName, FieldContent, para);
          end;
        end else
        begin
          if Assigned(FOnAutoDefineVariable) then
            OnAutoDefineVariable(self, (bDummy = 1), SFieldName, Content, para, DefHandled);
          if DefHandled = false then
          begin
            StrPCopyExt(FieldContent, content, 0);
            StrPCopyExt(FieldName, SFieldName, 0);
            LlDefineVariableExt(FieldName, FieldContent, para);
          end;
        end;
      end;

      Inc(T5, GetCurrentTime - T); T := GetCurrentTime;
    end;

    if Source.DataSet.EOF = True then
      pbLastRecord^ := 1 else
      pbLastRecord^ := 0;

    if bDummy = 0 then
    begin
      Source.DataSet.Next;
      if Source.DataSet.EOF = True then
        pbLastRecord^ := 1 else
        pbLastRecord^ := 0;
    end;

    (*if nMaster <> LL_MASTER_DETAIL then  {Update percentage only if not detail from master/detail}
    begin
      if (Source.DataSet.RecordCount <> 0) then
        pnProgressInPerc^:=Round(FRecNo/Source.DataSet.RecordCount*100) else
        pnProgressInPerc^:=100;
      if pnProgressInPerc^>100 then
        pnProgressInPerc^:=100;
      inc(FRecNo);
    end;*)
    if nMaster <> LL_MASTER_DETAIL then {Update percentage only if not detail from master/detail}
    begin
      if RecordCount > 0 then
        pnProgressInPerc^ := Round(FRecNo / RecordCount * 100) else
        pnProgressInPerc^ := 100;
      if pnProgressInPerc^ > 100 then
        pnProgressInPerc^ := 100;
      inc(FRecNo);
    end;

  end else {Assigned(Source)}
  begin
    pbLastRecord^ := 1; //keine Daten da kein Datasource
  end;
  FreeMem(FieldName);
  FreeMem(FieldContent);

  Format('%8.8d 1(%6.6d) 2(%6.6d) 3(%6.6d) 4(%6.6d) 5(%6.6d) <<<',
    [GetCurrentTime - T0, T1,T2,T3,T4,T5]);    {Profiler}
end;

procedure TL17MD.SetAutoDetailPrefix(const Value: TString);
begin
  FAutoDetailPrefix := Value;
end;

procedure TL17MD.SetAutoMasterPrefix(const Value: TString);
begin
  FAutoMasterPrefix := Value;
end;


procedure TL17MD.SetAutoOptions(var nObjectType: integer; var nPrintOptions: integer);
//  TAutoDestination = (adPreview, adPrinter, adPRNFile, adUserSelect, adExport);
//  TAutoProjectType = (ptListProject, ptLabelProject, ptCardProject);
begin
  case AutoDestination of
    adPrinter: nPrintOptions := LL_PRINT_NORMAL;
    adPRNFile: if ExportType <> '' then
        nPrintOptions := LL_PRINT_EXPORT else //md08.05.04
        nPrintOptions := LL_PRINT_FILE;
    adUserSelect: nPrintOptions := LL_PRINT_USERSELECT
  else
    nPrintOptions := LL_PRINT_PREVIEW;
  end;

  case AutoProjectType of
    ptListProject: begin
        nObjectType := LL_PROJECT_LIST;
      end;
    ptLabelProject: begin
        nObjectType := LL_PROJECT_LABEL;
      end;
  else
    begin
      nObjectType := LL_PROJECT_CARD;
    end;
  end;
end;


function TL17MD.AutoPrint(sTitle: TString; sTempPath: TString): longint;
var
  nPrintOptions, nObjectType: integer;
  bShowPrintOptions, bShowFileSelect: boolean;
  WinHandle: hWnd;
begin
  FRecNo := 0;
  if AutoMasterMode <> mmNone then {Master/Detail-Mode}
  begin
    if not (((FileExists(AutoDesignerFile)) or (AutoShowSelectFile = Yes)) and
      (FMasterLink.DataSet <> nil) and FMasterLink.DataSet.Active and
      (AutoDefine = Yes)) then
    begin
      ShowPipeWarning;
      result := -1;
      exit;
    end;
  end else
    if not (((FileExists(AutoDesignerFile)) or (AutoShowSelectFile = Yes)) and
      (FDataLink[0].DataSet <> nil) and (FDataLink[0].DataSet.Active) and
      (AutoDefine = Yes)) then
           {FDataLink[0].active and (AutoDefine = Yes)) then}
    begin
      result := -1;
      if not FileExists(AutoDesignerFile) then
        ShowFileWarning else
        ShowPipeWarning;
      exit;
    end;

  SetAutoOptions(nObjectType, nPrintOptions);
  if AutoShowSelectFile = Yes then
    bShowFileSelect := true else
    bShowFileSelect := false;

  if AutoShowPrintOptions = Yes then
    bShowPrintOptions := true else
    bShowPrintOptions := false;

  if csDesigning in ComponentState then
    WinHandle := Application.handle else
    WinHandle := TForm(Owner).Handle;

  result := Print(1, nObjectType, AutoDesignerFile, bShowFileSelect, nPrintOptions,
    LL_BOXTYPE_NORMALMETER, WinHandle, sTitle, bShowPrintOptions, sTempPath);

end;

function TL17MD.AutoDesign(sTitle: TString): longint;
var
  nPrintOptions, nObjectType: integer;
  bShowFileSelect, bAllowCreate: boolean;
  WinHandle: cmbtHWND;
begin
  if AutoMasterMode <> mmNone then {Master/Detail-Mode}
  begin
    if not ((FMasterLink.DataSet <> nil) and FMasterLink.DataSet.Active and
      (AutoDefine = Yes)) then
    begin
      ShowPipeWarning;
      result := -1;
      exit;
    end;
  end else
    if not ((FDataLink[0].DataSet <> nil) and FDataLink[0].DataSet.Active and
      (AutoDefine = Yes)) then
    begin
      ShowPipeWarning;
      result := -1;
      exit;
    end;

  SetAutoOptions(nObjectType, nPrintOptions);
  if AutoShowSelectFile = Yes then
    bShowFileSelect := true else
    bShowFileSelect := false;

  if csDesigning in ComponentState then
    WinHandle := Application.handle else
    WinHandle := TForm(Owner).Handle;

  bAllowCreate := true;  //23.04.12 neu

  result := Design(1, WinHandle, sTitle, nObjectType or LL_FILE_ALSONEW,
    AutoDesignerFile, bShowFileSelect, bAllowCreate);
end;


(*** function Design ********************************************************)

function TL17MD.Design(UserData: integer; ParentHandle: cmbtHWND; Title: TString;
      ProjectType: integer; ProjectName: TString; ShowFileSelect: boolean;
      AllowCreate: boolean): integer;
//function TL17MD.Design(nUserData: longint; hWnd: HWND; sTitle: TString;
//  nObjType: longint; sObjName: TString; bWithFileSelect: longint): longint;
var
  nProgressInPerc: longint;
  bLastRecord: array[0..pred(MaxLlDataSource)] of longint;
  nRet: longint;
  bMaster: integer;
  bFields: boolean;
  iDS: integer;
begin

  nProgressInPerc := 0;
  for iDS := 0 to pred(MaxLlDataSource) do
    bLastRecord[iDS] := 0;
  nRet := 0;

  if (AllowCreate) then
    ProjectType:=ProjectType or LL_FILE_ALSONEW
  else
    ProjectType:=ProjectType and $7FFF;

  if ShowFileSelect then
  begin
    nRet := LlSelectFileDlgTitle(ParentHandle, '',
      ProjectType and $800F, ProjectName);
    if (nRet <> 0) then
    begin
      Result := nRet;
      exit;
    end;
  end;
  ProjectType := ProjectType and $7FFF;
  (*end of initialization; now get the Variables and Fields*)

  LlDefineVariableStart;
  LlDefineChartFieldStart;
  LlDefineFieldStart;

  if (AutoDefine = No) then
  begin
    DefineVariablesCallback(UserData, 1, @nProgressInPerc, @bLastRecord, nRet);
    DefineFieldsCallback(UserData, 1, @nProgressInPerc, @bLastRecord, nRet);
    result := 0;
  end else
  begin
    for iDS := 0 to pred(MaxLlDataSource) do
    begin
      if FDataLink[iDS].DataSet <> nil then
      begin
        if (FDataLink[1].DataSource <> nil) or
          (FDataLink[2].DataSource <> nil) then {MDMany}
        begin
          AutoDetailPrefix := FDataLink[iDS].DataSet.Name;
          if iDS = 0 then //14.03.04 Sidor.Vorf
            bMaster := LL_MASTER_NONE else
            bMaster := LL_MASTER_DETAIL;
        end else
        begin
          AutoDetailPrefix := SDetail;
          bMaster := LL_MASTER_NONE; //14.03.04 Sidor.Vorf
        end;

        {DataSource[iDS].DataSet.Close;     nicht im Designer}
        if not DataSource[iDS].DataSet.Active then
        begin
          OpenDS(iDS);
        end; {ansonsten aktuelle Sicht nehmen}
        if ((ProjectType and LL_PROJECT_LABEL) = LL_PROJECT_LABEL) or
          ((ProjectType and LL_PROJECT_CARD) = LL_PROJECT_CARD) then
        begin
          DataAutoDefine(1, 1, @nProgressInPerc, @bLastRecord, nRet, false,
            FDataLink[iDS].DataSource, bMaster);
        end else
        begin
          if Assigned(FOnAutoDefineNewPage) then
          begin
            OnAutoDefineNewPage(self, true);
          end;
          if AutoMasterMode = mmNone then
            bMaster := LL_MASTER_NONE else
            bMaster := LL_MASTER_DETAIL; {Define as detail}

          DataAutoDefine(1, 1, @nProgressInPerc, @bLastRecord, nRet, true,
            FDataLink[iDS].DataSource, bMaster);
        end;
      end;
    end; //for
    if AutoMasterMode <> mmNone then {Master/Detail-Mode}
    begin
      {MasterSource.DataSet.First;   im Designer aktuelle Sicht verwenden}
      if AutoMasterMode = mmAsVariables then
        LlDefineVariableExt('LL.MasterRecNo', '1', LL_NUMERIC) else
        LlDefineFieldExt('LL.MasterRecNo', '1', LL_NUMERIC);

      bMaster := LL_MASTER_MASTER; {define as master}
      if AutoMasterMode = mmAsFields then
        bFields := true else
        bFields := false;

      DataAutoDefine(1, 1, @nProgressInPerc, @bLastRecord, nRet, bFields,
        FMasterLink.DataSource, bMaster);
    end;
    LlDefineVariableExt('LL.PageCount', PChar(IntToStr(PageCount)), LL_NUMERIC);

    //result := cmbTLL17.LlDefineLayout(hTheJob, ParentHandle, szTitle, ProjectType and $7FFF, szObjName);
    result := LlDefineLayout(ParentHandle, Title, ProjectType, ProjectName);
  end;

end;


(*** function print **********************************************************)

function TL17MD.Print(UserData: integer; ProjectType: integer; ProjectName: TString; ShowFileSelect: boolean;
  PrintOptions: integer; BoxType: integer; ParentHandle: cmbtHWND; Title: TString;
  ShowPrintOptions: boolean; TempPath: TString): integer;
//function TL17MD.Print(nUserData: longint; nObjType: longint; sObjName: TString; bWithFileSelect: longint;
//  nPrintOptions: longint; nBoxType: longint; hWnd: HWND; sTitle: TString;
//  bShowPrintOptionsDlg: longint; sTempPath: TString): longint;
var
  nRet: longint;
  nProgressInPerc: longint;
  bLastRecord: longint;
  bTemp: longint;
  sPath: TString;
  sDir: TString;
  sPort: TString;
  sPrinter: TString;
  sPreviewFile: TString;
  nCopies: integer;
  i: integer;
  btmpAutoMultipage: boolean;
  btmpDelayTableHeader: boolean;
  bWrnRepeatDataMode: boolean;
  bToPreview: boolean;
  nMaster: integer;
  bMasterDetailMode: boolean;
  bContinued: boolean;
  bFirst: boolean;
  bLabelPrinting: boolean;

  nMasterRecNo: integer;
  sMasterRecNo: ptchar;

  Dummy: TString;
  hStg: HLLSTG; //für PageCount

  szBuffer: ptchar;
  szPath: ptchar;
  szTempPath: ptchar;
  szTitle: ptchar;
  szPrinter: ptchar;
  szPort: ptchar;

  iDS: integer;

  procedure FreeBuffers;
  begin
    FreeMem(szBuffer);
    FreeMem(szPath);
    FreeMem(szTempPath);
    FreeMem(szTitle);
    FreeMem(szPrinter);
    FreeMem(szPort);
  end;
begin {Print}
  GetMem(szBuffer, 1024 * sizeof(tChar));
  GetMem(szPath, 256 * sizeof(tChar));
  GetMem(szTempPath, 256 * sizeof(tChar));
  GetMem(szTitle, 128 * sizeof(tChar));
  GetMem(szPrinter, 128 * sizeof(tChar));
  GetMem(szPort, 40 * sizeof(tChar));

  szBuffer^ := #0;
  szTitle^ := #0;
  szPath^ := #0;
  szTempPath^ := #0;
  szPrinter^ := #0;
  szPort^ := #0;

  nRet := 0;
  nProgressInPerc := 0;
  bLastRecord := 0;
  sPath := '';
  sDir := '';
  sPort := '';
  sPrinter := '';
  if Kopien > 0 then
    nCopies := Kopien else
    nCopies := 1;
//     btmpAutoMultipage:=bAutoMultipage;
//     btmpDelayTableHeader:=bDelayTableHeader;
  btmpAutoMultipage := true;
  btmpDelayTableHeader := true;

  bWrnRepeatDataMode := false;
  bMasterDetailMode := false;
  bFirst := false;
  nMasterRecNo := 1;
  bLabelPrinting := (((ProjectType and $7FFF) = LL_PROJECT_LABEL) or
                     ((ProjectType and $7FFF) = LL_PROJECT_CARD));

  if ShowFileSelect then
  begin
    StrPCopyExt(szBuffer, ProjectName, 1024 * sizeof(tChar));
    nRet := cmbTLL17.LlSelectFileDlgTitleEx(hTheJob, ParentHandle, nil,
      ProjectType and $7FFF, szBuffer, 1024 - 1, nil);
    if (nRet <> 0) then
    begin
      result := nRet;
      FreeBuffers;
      exit;
    end else
      ProjectName := StrPasExt(szBuffer);
  end;
  ProjectType := ProjectType and $7FFF;

  (*define all variables*)
  nMaster := LL_MASTER_NONE;
  cmbTLL17.LlDefineVariableStart(hTheJob);
  cmbTLL17.LlDefineChartFieldStart(hTheJob);

  if (AutoDefine = No) then
  begin
    DefineVariablesCallback(UserData, 1, @nProgressInPerc, @bLastRecord, nRet)
  end else
  begin
    if (FDataLink[0].DataSource <> nil) and
      (FDataLink[0].DataSource.DataSet <> nil) then
    begin
      {FDataLink[0].DataSource.DataSet.Open;
      FDataLink[0].DataSource.DataSet.First;}
      OpenDS(0);

      if (ProjectType <> LL_PROJECT_LIST) then
      begin
        DataAutoDefine(1, 1, @nProgressInPerc, @bLastRecord, nRet, false,
          FDataLink[0].DataSource, LL_MASTER_NONE);
        {>>14.03.04}
        for iDS := 1 to pred(MaxLlDataSource) do
        begin
          if FDataLink[iDS].DataSet <> nil then
          begin
            AutoDetailPrefix := FDataLink[iDS].DataSet.Name;
            nMaster := LL_MASTER_DETAIL;

            if not DataSource[iDS].DataSet.Active then
            begin
              OpenDS(iDS);
            end;
            DataAutoDefine(1, 1, @nProgressInPerc, @bTemp, nRet, false,
              FDataLink[iDS].DataSource, nMaster);
          end;
        end; //for
      end;
      {<<14.03.04}
    end;
    if Assigned(FOnAutoDefineNewPage) then
      OnAutoDefineNewPage(self, true);
  end;

  (*define all fields if list project*)

  if (ProjectType = LL_PROJECT_LIST) then
  begin
    cmbTLL17.LlDefineFieldStart(hTheJob);
    if (AutoDefine = No) then
      DefineFieldsCallback(UserData, 1, @nProgressInPerc, @bLastRecord, nRet)
    else
    begin
      if FMasterLink.Active and (AutoMasterMode <> mmNone) then
        MasterSource.DataSet.First;
      if AutoMasterMode = mmNone then
        nMaster := LL_MASTER_NONE
      else
      begin
        nMaster := LL_MASTER_DETAIL;
        if AutoMasterMode = mmAsVariables then
          LlDefineVariableExt('LL.MasterRecNo', '1', LL_NUMERIC)
        else
          LlDefineFieldExt('LL.MasterRecNo', '1', LL_NUMERIC)
      end;
      // MD Schleife
      for iDS := 0 to pred(MaxLlDataSource) do
      begin
        if (FDataLink[iDS].DataSource <> nil) and
          (FDataLink[iDS].DataSource.DataSet <> nil) then
        begin
          if (FDataLink[1].DataSource <> nil) or
            (FDataLink[2].DataSource <> nil) then {MDMany}
            AutoDetailPrefix := FDataLink[iDS].DataSet.Name else
            AutoDetailPrefix := SDetail;
          {FDataLink[iDS].DataSource.DataSet.Open;}
          OpenDS(iDS);
          FDataLink[iDS].DataSource.DataSet.First;
          DataAutoDefine(1, 1, @nProgressInPerc, @bLastRecord, nRet, true,
            FDataLink[iDS].DataSource, nMaster);
        end;
      end;
      case AutoMasterMode of
        mmAsFields: DataAutoDefine(1, 1, @nProgressInPerc, @bLastRecord, nRet,
            true, FMasterLink.DataSource, LL_MASTER_MASTER);
        mmAsVariables: DataAutoDefine(1, 1, @nProgressInPerc, @bLastRecord, nRet,
            false, FMasterLink.DataSource, LL_MASTER_MASTER);

      end;
      FRecNo := 0;
    end;
  end; {LL_PROJECT_LIST}

  LlDefineVariableExt('LL.PageCount', PChar(IntToStr(PageCount)), LL_NUMERIC);

  if not UsePageCount then
  begin
    UsePageCount := FileContains(ProjectName, 'LL.PageCount');
    if UsePageCount then
    begin
      CalcPageCount := true;
      PrintOptions := LL_PRINT_PREVIEW; //L17MD.AutoDestination := L8.Preview;
      ShowPrintOptions := false; // L17MD.AutoShowPrintOptions := BoolToYesNo(false);
      //fürs nächste mal:
      AutoShowSelectFile := No;
      AutoDesignerFile := ProjectName;
    end;
  end;

  (*initialize printing*)
  StrPCopyExt(szPath, ProjectName, 0);
  StrPCopyExt(szTitle, Title, 0);

  // 22.05.12 muss vor Printstart pasieren
  if not bLabelPrinting then
  begin
    cmbTLL17.LlSetOption(hTheJob, LL_OPTION_AUTOMULTIPAGE, 1);
    cmbTLL17.LlSetOption(hTheJob, LL_OPTION_DELAYTABLEHEADER, 1);
  end;

  nRet := cmbTLL17.LlPrintWithBoxStart(hTheJob, ProjectType, szPath, PrintOptions,
    BoxType, ParentHandle, szTitle);
  if nRet < 0 then
  begin
    result := nRet;
    LlExprError(hTheJob, szTempPath, 256);
    MessageDlg(Format('Fehler%d(%s)', [nRet, szTempPath]), mtWarning, [mbOK], 0);
    FreeBuffers;
    exit;
  end;

  (*show print options dialog?*)

  if not bLabelPrinting then
  begin
    cmbTLL17.LlPrintSetOption(hTheJob, LL_OPTION_COPIES, nCopies); //immer!
  end;
  if ExportType <> '' then
    LlPrintSetOptionString(LL_PRNOPTSTR_EXPORT, ExportType); //MD08.05.04
  if ShowPrintOptions then
  begin
    if bLabelPrinting then
    begin
      //cmbTLL17.LlPrintSetOption(hTheJob, LL_OPTION_COPIES, nCopies);
      cmbTLL17.LlPrintSetOption(hTheJob, LL_PRNOPT_COPIES, LL_COPIES_HIDE);
    end else
    begin
      cmbTLL17.LlPrintSetOption(hTheJob, LL_PRNOPT_PRINTDLG_ONLYPRINTERCOPIES, 1);
    end;

    (*cmbTLL17.LlPrintSetOption(hTheJob, LL_PRNOPT_PRINTDLG_DESTMASK,0);*)

    cmbTLL17.LlPrintSetOption(hTheJob, LL_OPTION_PAGE, LL_PAGE_HIDE);

    nRet := cmbTLL17.LlPrintOptionsDialog(hTheJob, ParentHandle, szTitle); //Dialog
    if nRet < 0 then
    begin
      cmbTLL17.LlPrintEnd(hTheJob, 0);
      result := nRet;
      FreeBuffers;
      exit;
    end;
    cmbTLL17.LlPrintSetOption(hTheJob, LL_OPTION_PAGE, 1);
  end;

  cmbTLL17.LlPrintGetPrinterInfo(hTheJob, szPrinter, 128 - 1, szPort, 40 - 1);
  StrPCopyExt(szTempPath, TempPath, 0);

  (*Destination may have changed*)
  if cmbTLL17.LlPrintGetOption(hTheJob, LL_PRNOPT_PRINTDLG_DEST) =
    LL_DESTINATION_PRV then
    bToPreview := true else
    bToPreview := false;

  (*set preview file path and name*)
  if bToPreview = true then
  begin
    sPreviewFile := TempPath + ExtractFileName(StrPasExt(szPath));
    cmbTLL17.LlPreviewSetTempPath(hTheJob, szTempPath);
  end;

  (*Direct copies-support only for label printing*)
  if bLabelPrinting then
  begin
//     nCopies := cmbTLL17.LlPrintGetOption(hTheJob, LL_OPTION_COPIES);
//     cmbTLL17.LlPrintSetOption(hTheJob, LL_OPTION_COPIES, 1);
//     cmbTLL17.LlPrintSetOption(hTheJob, LL_PRNOPT_COPIES, 1);
  end else
  begin
    (*For Lists copies have to be made by the driver. This has to be set
      however...*)
    if cmbTLL17.LlPrintGetOption(hTheJob, LL_PRNOPT_COPIES_SUPPORTED) = 0 then
      cmbTLL17.LlPrintSetOption(hTheJob, LL_PRNOPT_COPIES, nCopies);
    (*The input number of copies is not supported -> reset to 1*)
  end;


  (*----------------------
     main printing routine
    ----------------------

    labels and cards*)


  if bLabelPrinting then
  begin
    while ((bLastRecord = 0) and (nRet = 0)) do
    begin
      (*define variables*)
      cmbTLL17.LlDefineVariableStart(hTheJob);
      cmbTLL17.LlDefineChartFieldStart(hTheJob);

      if Assigned(FOnAutoDefineNewPage) then
        OnAutoDefineNewPage(self, false);
      if (AutoDefine = No) then
      begin
        DefineVariablesCallback(UserData, 0, @nProgressInPerc, @bLastRecord, nRet);
      end else
      begin
        DataAutoDefine(UserData, 0, @nProgressInPerc, @bLastRecord, nRet,
          false, FDataLink[0].DataSource, LL_MASTER_NONE);
        {<<14.03.04}
        for iDS := 1 to pred(MaxLlDataSource) do
        begin
          if FDataLink[iDS].DataSet <> nil then
          begin
            AutoDetailPrefix := FDataLink[iDS].DataSet.Name;
            nMaster := LL_MASTER_DETAIL;

            if not DataSource[iDS].DataSet.Active then
            begin
              OpenDS(iDS);
            end;
            DataAutoDefine(UserData, 0, @nProgressInPerc, @bTemp, nRet, false,
              FDataLink[iDS].DataSource, nMaster);
          end;
        end; //for
        {>>14.03.04}
      end;
      if nProgressInPerc < 0 then
        nProgressInPerc := 0 else
        if nProgressInPerc > 100 then
          nProgressInPerc := 100;

      nRet := cmbTLL17.LlPrintSetBoxText(hTheJob, szPrinter, nProgressInPerc);
      if nRet = LL_ERR_USER_ABORTED then
      begin
        cmbTLL17.LlPrintEnd(hTheJob, 0);
        result := nRet;
        FreeBuffers;
        exit;
      end;
      for i := 1 to nCopies do
      begin
        repeat
          nRet := cmbTLL17.LlPrint(hTheJob)
        until nRet <> LL_WRN_REPEAT_DATA;
      end;
    end;
  end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

  else (*print lists*)
  begin
    (*set List & Label Options
    22.05.12 muss vor Printstart pasieren
    cmbTLL17.LlSetOption(hTheJob, LL_OPTION_AUTOMULTIPAGE, 1);
    cmbTLL17.LlSetOption(hTheJob, LL_OPTION_DELAYTABLEHEADER, 1);
    *)
    bContinued := false; {Flag whether LlPrint() should be supressed or not}

    if AutoMasterMode <> mmNone then {Supply master data}
    begin
      bMasterDetailMode := true;
      bFirst := true;
      if Assigned(FOnAutoDefineNewPage) then
        OnAutoDefineNewPage(self, false);
      cmbTLL17.LlPrint(hTheJob);
      (*cmbTLL17.LlDefineFieldStart(hTheJob); {free the detail data}
      cmbTLL17.LlDefineChartFieldStart(hTheJob);*)

      case AutoMasterMode of
        mmAsFields:
          DataAutoDefine(1, 1, @nProgressInPerc, @bLastRecord, nRet,
            true, FMasterLink.DataSource, LL_MASTER_MASTER);
        mmAsVariables:
          DataAutoDefine(1, 1, @nProgressInPerc, @bLastRecord, nRet,
            false, FMasterLink.DataSource, LL_MASTER_MASTER);
      end;
    end;

    {Outer loop: Master/Detail}
    bLastRecord := 0;
    repeat {for each Master record / at least once}
      iDS := 0; //MD17.03.02
      if bMasterDetailMode = true then
      begin
        {DataSource[0].DataSet.Close;
        DataSource[0].DataSet.Open;}
        OpenDS(0);
      end;

      while ((bLastRecord = 0) and (nRet = 0)) or
        ((bLastRecord <> 0) and (bWrnRepeatDataMode = true) and (nRet = 0)) do
      begin {page}
        if nRet = LL_ERR_USER_ABORTED then
        begin
          cmbTLL17.LlPrintEnd(hTheJob, 0);
          if btmpAutoMultipage = false then
            cmbTLL17.LlSetOption(hTheJob, LL_OPTION_AUTOMULTIPAGE, 0);
          if btmpDelayTableHeader = false then
            cmbTLL17.LlSetOption(hTheJob, LL_OPTION_DELAYTABLEHEADER, 0);
          result := nRet;
          FreeBuffers;
          exit;
        end;

        if (AutoDefine = No) then
          DefineVariablesCallback(UserData, 0, @nProgressInPerc, @bLastRecord, nRet);

        if not bContinued and not bFirst then
        begin
          if Assigned(FOnAutoDefineNewPage) and (AutoDefine <> No) then
            OnAutoDefineNewPage(self, false);
          cmbTLL17.LlPrint(hTheJob);
        end;

        if bFirst then
          bFirst := false; {Skip Page start for first Master/Detail - handled before}
        while (bLastRecord = 0) and (nRet = 0) or
          ((bLastRecord <> 0) and (bWrnRepeatDataMode = true) and (nRet = 0)) do
        begin {lines}
          if (FDataLink[1].DataSource <> nil) or
            (FDataLink[2].DataSource <> nil) then {MDMany}
          begin
            if (iDS < pred(MaxLlDataSource)) and (FDataLink[iDS].DataSet <> nil) then
              AutoDetailPrefix := FDataLink[iDS].DataSet.Name;
          end else
            AutoDetailPrefix := SDetail;

          if bWrnRepeatDataMode = false then
            if (AutoDefine = No) then
              DefineFieldsCallback(UserData, 0, @nProgressInPerc, @bLastRecord, nRet)
            else
              DataAutoDefine(UserData, 0, @nProgressInPerc, @bLastRecord, nRet, true,
                FDataLink[iDS].DataSource, nMaster);

          if nProgressInPerc < 0 then
            nProgressInPerc := 0 else
            if nProgressInPerc > 100 then
              nProgressInPerc := 100;

          if AutoMasterMode = mmNone then {Don't update in master/detail-mode}
          begin
            nRet := cmbTLL17.LlPrintSetBoxText(hTheJob, szPrinter, nProgressInPerc);
            if nRet = LL_ERR_USER_ABORTED then
            begin
              cmbTLL17.LlPrintEnd(hTheJob, 0);
              if btmpAutoMultipage = false then
                cmbTLL17.LlSetOption(hTheJob, LL_OPTION_AUTOMULTIPAGE, 0);
              if btmpDelayTableHeader = false then
                cmbTLL17.LlSetOption(hTheJob, LL_OPTION_DELAYTABLEHEADER, 0);
              result := nRet;
              FreeBuffers;
              exit;
            end;
          end;

          nRet := cmbTLL17.LlPrintFields(hTheJob);
          if bWrnRepeatDataMode = false then
            cmbTLL17.LlPrintDeclareChartRow(hTheJob, LL_DECLARECHARTROW_FOR_OBJECTS);

          if nRet <> LL_WRN_REPEAT_DATA then
          begin
            bWrnRepeatDataMode := false;
            if nRet <> 0 then
              iDS := MaxLlDataSource; {Bei Fehler keine weiteren Details}
          end;
          //MD17.03.02
          if (bLastRecord <> 0) and (iDS < pred(MaxLlDataSource)) and
            (bWrnRepeatDataMode = false) and (AutoDefine = Yes) then
          begin
            (*repeat
              Inc(iDS);
            until (iDS >= pred(MaxLlDataSource)) or
                  ((FDataLink[iDS].DataSource <> nil) and
                   (FDataLink[iDS].DataSource.DataSet <> nil));
            if iDS < pred(MaxLlDataSource) then*)
            //mdMaster Datasources in TLlPrn-Kmp mit Leereintrag trennen. neu 21.12.03 qupe.prob.LlPrnLabelZentrallabor
            Inc(iDS);
            if (iDS < pred(MaxLlDataSource)) and
              (FDataLink[iDS].DataSource <> nil) and
              (FDataLink[iDS].DataSource.DataSet <> nil) then
            begin
              bLastRecord := 0;
              OpenDS(iDS);
            end;
          end;
        end; {lines}

        bContinued := false;

        if nRet = LL_WRN_REPEAT_DATA then
        begin
          bWrnRepeatDataMode := true;
          nRet := 0;
        end else
          bWrnRepeatDataMode := false;
      end; {page}

      if AutoMasterMode <> mmNone then
      begin
        MasterSource.DataSet.Next; {skip to next}

        if MasterSource.DataSet.EOF = false then
        begin
          (*cmbTLL17.LlDefineFieldStart(hTheJob); {free the detail data}
          cmbTLL17.LlDefineChartFieldStart(hTheJob);*)
          case AutoMasterMode of
            mmAsFields:
              begin
                DataAutoDefine(UserData, 1, @nProgressInPerc, @bLastRecord, nRet, true,
                  FMasterLink.DataSource, LL_MASTER_MASTER); {no skip here!}
                bContinued := true; {no page break}
              end;
            mmAsVariables:
              begin
                while cmbTLL17.LlPrintFieldsEnd(hTheJob) = LL_WRN_REPEAT_DATA do
                begin
                  if Assigned(FOnAutoDefineNewPage) then
                    OnAutoDefineNewPage(self, false);
                end;
                cmbTLL17.LlPrintResetProjectState(hTheJob);
                DataAutoDefine(UserData, 1, @nProgressInPerc, @bLastRecord, nRet, false,
                  FMasterLink.DataSource, LL_MASTER_MASTER); {no skip here, pagebreak OK!}
              end;
          end;
        end;

        inc(nMasterRecNo); {Supply MasterRecNo Data}

        GetMem(sMasterRecNo, 20);
        try
          //Str(nMasterRecNo, Dummy);
          Dummy := IntToStr(nMasterRecNo);
          StrPCopyExt(sMasterRecNo, Dummy, 0);
          if AutoMasterMode = mmAsVariables then
            LlDefineVariableExt('LL.MasterRecNo', sMasterRecNo, LL_NUMERIC)
          else
            LlDefineFieldExt('LL.MasterRecNo', sMasterRecNo, LL_NUMERIC);
        finally
          FreeMem(sMasterRecNo);
        end;

        nRet := cmbTLL17.LlPrintSetBoxText(hTheJob, szPrinter, nProgressInPerc);
        if nRet = LL_ERR_USER_ABORTED then
        begin
          cmbTLL17.LlPrintEnd(hTheJob, 0);
          if btmpAutoMultipage = false then
            cmbTLL17.LlSetOption(hTheJob, LL_OPTION_AUTOMULTIPAGE, 0);
          if btmpDelayTableHeader = false then
            cmbTLL17.LlSetOption(hTheJob, LL_OPTION_DELAYTABLEHEADER, 0);
          result := nRet;
          FreeBuffers;
          exit;
        end;

        if bLastRecord <> 0 then
        begin
          bLastRecord := 0;
          bMasterDetailMode := false; {finished}
        end;
      end;

    until bMasterDetailMode = false; {outer loop}

    if (AutoMasterMode <> mmAsVariables) or (MasterSource.DataSet.EOF) then
      while cmbTLL17.LlPrintFieldsEnd(hTheJob) = LL_WRN_REPEAT_DATA do
      begin
        if Assigned(FOnAutoDefineNewPage) then
          OnAutoDefineNewPage(self, false);
      end;

  end;
///////////////////////////////////////////////////////////////////////////////////////////////////

  nRet := cmbTLL17.LlPrintEnd(hTheJob, 0);

  (*reset old settings*)

  if btmpAutoMultipage = false then
    cmbTLL17.LlSetOption(hTheJob, LL_OPTION_AUTOMULTIPAGE, 0);
  if btmpDelayTableHeader = false then
    cmbTLL17.LlSetOption(hTheJob, LL_OPTION_DELAYTABLEHEADER, 0);

  if bToPreview and (nRet = 0) then
  begin
    StrPCopyExt(szTempPath, TempPath, 0);
    if UsePageCount and CalcPageCount then
    begin
      hStg := cmbTLS17.LlStgsysStorageOpen(szPath, szTempPath, TRUE, TRUE);
      PageCount := cmbTLS17.LlStgsysGetPageCount(hStg);
      cmbTLS17.LlStgsysStorageClose(hStg);
    end else
    begin
      (*display preview when in preview mode*)
      nRet := cmbTLL17.LlPreviewDisplay(hTheJob, szPath, szTempPath, ParentHandle);
      if nRet = 0 then
        cmbTLL17.LlPreviewDeleteFiles(hTheJob, szPath, szTempPath);
    end;
  end;
  FreeBuffers;
  result := nRet;
end; { Print }

procedure TL17MD.Notification(AComponent: TComponent; Operation: TOperation);
var
  iDS: integer;
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink[0] <> nil) and
    (AComponent = DataSource[0]) then
  begin
    DataSource[0] := nil;
    AutoDefine := No;
  end;
  for iDS := 1 to pred(MaxLlDataSource) do
  begin
    if (Operation = opRemove) and (FDataLink[iDS] <> nil) and
      (AComponent = DataSource[iDS]) then
    begin
      DataSource[iDS] := nil;
    end;
  end;
  if (Operation = opRemove) and (FMasterLink <> nil) and
    (AComponent = MasterSource) then
  begin
    MasterSource := nil;
  end;
end;

procedure StrPCopyExt(var Dest: ptChar; Source: TString; MinSize: Integer);
var ActSize: Integer;
begin
  if MinSize > SizeOf(ptChar) * (length(Source) + 1) then
    ActSize := MinSize else
    ActSize := SizeOf(ptChar) * (length(Source) + 1);

  FreeMem(Dest);
  GetMem(Dest, ActSize);
{$IFDEF UNICODE}
  Move(ptCHAR(Source)^, Dest^, SizeOf(ptChar) * (length(Source)));
  Dest[length(Source)] := #0;
{$ELSE}
  StrPCopy(Dest, Source);
{$ENDIF}
end;

function StrPasExt(Str: ptChar): TString;
begin
{$IFDEF UNICODE}
  result := WideCharToString(Str);
{$ELSE}
  result := StrPas(Str);
{$ENDIF}

end;

function FileContains(aFilename, aToken: string): boolean;
// Textdatei enthält Zeichenkette (exakt)
var
  F: Text;
  S: string;
begin
  result := false;
{$I-}
  AssignFile(F, aFileName);
  Reset(F);
  while (IOResult = 0) and not result and not Eof(F) do
  begin
    ReadLn(F, S);
    result := Pos(aToken, S) > 0;
  end;
  CloseFile(F);
{$I+}
end;

end.


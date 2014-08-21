{=================================================================================

 Copyright © combit GmbH, Konstanz

----------------------------------------------------------------------------------
 File   : l17db.pas
 Module : List & Label 17 Databinding
 Descr. : Implementation file for the List & Label 17 VCL-Component for databinding
 Version: 17.001
==================================================================================
}

unit l17db;

{$ifdef VER90}
{$define NOADVANCEDDATABINDING}
{$endif}

{$ifdef VER100}
{$define NOADVANCEDDATABINDING}
{$endif}

{$ifndef VER90}
{$ifndef VER100}
{$ifndef VER110}
{$ifndef VER120}
{$define ADOAVAILABLE}
{$endif}
{$endif}
{$endif}
{$endif}

{$ifndef VER210}
{$ifndef VER220}
{$ifndef VER230}
{$define USETHREADRESUME}
{$endif}
{$endif}
{$endif}

{$ifndef WIN64}
  {$define BDEAVAILABLE}
  {$define DESIGNIDEAVAILABLE}
{$endif}

interface
uses Classes, db, l17, cmbTLl17, SysUtils,

    {$ifdef BDEAVAILABLE}
      dbtables,
    {$endif}

    Forms, Math, l17printworker, dialogs,

    {$ifdef ADOAVAILABLE}
      ADODB,
    {$endif}

    Windows, SyncObjs;

type
  TAutoMasterMode = (mmNone, mmAsFields, mmAsVariables);
  TDataItemType = (itTTable, itTADOTable, itTDataSetDescendand);
  TAutoProjectType = (ptListProject, ptLabelProject, ptCardProject);
  TAutoDestination = (adPreview, adPrinter, adPRNFile, adUserSelect, adExport);
  TAutoBoxType = (btStandardAbort, btNone, btNormalMeter, btBridgeMeter, btNormalWait, btBridgeWait, btEmptyWait, btEmptyAbort, btStandardWait);

  TAutoDefineTableEvent = procedure(Sender: TObject; IsDesingMode: boolean;
    var TableName: TSTring; var IsHandled: boolean) of object;
  TAutoDefineTableSortOrderEvent = procedure(Sender: TObject; IsDesignMode: boolean; const Table: TString;
    var TableSortOrder: TString; var IsHandled: boolean) of object;
  TAutoDefineTableRelationEvent = procedure(Sender: TObject; IsDesignMode: boolean;
    var TableRelation: TString; var IsHandled: boolean) of object;

  TAutoNotifyProgress = procedure(Sender: TObject; const SetBoxText: TString; Progress: integer) of object;

  TTableMap = class;

  TDBL17_ = class(TL17_)
  private
    (*AutoDefine*)
    FCritDesignerPrint: TCriticalSection;
    FCritDrillDown    : TCriticalSection;

    FWorkerThread: l17printworker.TPrintWorker;
    FDrillDownThread: TDrillDownWorker;
    FMaxPage: integer;
    bAutoDefine: boolean;
    bAutoDesignerPreview: boolean;
    bAutoShowSelectFile: boolean;
    bAutoShowPrintOptions: boolean;
    bIsPrinting: boolean;
    FDesignerFile: TLlDesignerFile;
    FAutoProjectType: TAutoProjectType;
    FAutoDestination: TAutoDestination;
    //FDataLink: TDataLink;
    FMasterLink: TDataLink;
    FAutoMasterMode: TAutoMasterMode;
    FOnAutoDefineField: TAutoDefineFieldEvent;
    FOnAutoDefineVariable: TAutoDefineVariableEvent;
    FOnAutoDefineNewPage: TAutoDefineNewPageEvent;
    FOnAutoDefineNewLine: TAutoDefineNewLineEvent;
    FRecNo: integer;
    FDrillDownJobId: integer;
    FAutoMasterPrefix: TString;
    FAutoDetailPrefix: TString;
    {$ifndef NOADVANCEDDATABINDING}
    bAdvancedDataBinding: boolean;
    {$endif}
    FOnAutoDefineTable: TAutoDefineTableEvent;
    FOnAutoDefineTableSortOrder: TAutoDefineTableSortOrderEvent;
    FOnAutoDefineTableRelation: TAutoDefineTableRelationEvent;
    FOnAutoNotifyProgress: TAutoNotifyProgress;
    FAutoBoxType: TAutoBoxType;
    FLLForDesignerPrint: TDBL17_;
    FLLForDrillDown: TDBL17_;
    FAborted: boolean;
    procedure DefineFieldContent(bDummy: Integer; Source: TDataSource; i: Integer; var handled: Boolean; DefHandled: Boolean; SFieldName: TString; var para: Integer; var content: TString; bAsFields: Boolean);
    {$ifndef NOADVANCEDDATABINDING}
    procedure FillDataStructure(MasterSource: TDataSet);
    {$endif}
    procedure SetAutoBoxType(const Value: TAutoBoxType);

    {$ifdef BDEAVAILABLE}
    function ExtractTableName(tableName: string):string;
    {$endif}

    function TranslateBoxType(AutoBoxType: TAutoBoxType): integer;
    procedure SetAborted(const Value: boolean);
  protected
    {$ifndef NOADVANCEDDATABINDING}
    function GetAdvancedDataBinding: TPropYesNo;
    procedure SetAdvancedDataBinding(nMode : TPropYesNo);
    {$endif}
    function GetMasterSource: TDataSource;
    procedure SetMasterSource(nSource: TDataSource);
    function GetAutoShowSelectFile: TPropYesNo;
    procedure SetAutoShowSelectFile(nMode : TPropYesNo);
    function GetAutoShowPrintOptions: TPropYesNo;
    procedure SetAutoShowPrintOptions(nMode : TPropYesNo);
    function GetAutoDefine: TPropYesNo;
    procedure SetAutoDefine(nMode : TPropYesNo);
    function GetAutoDesignerPreview: TPropYesNo;
    procedure SetAutoDesignerPreview(nMode: TPropYesNo);
    procedure SetAutoMasterMode(Value : TAutoMasterMode);
    function GetDataSource: TDataSource;
    procedure SetDataSource(nSource: TDataSource);
    procedure SetAutoDetailPrefix(Value : TString);
    procedure SetAutoMasterPrefix(Value : TString);
    function GetDesignerFile: TLlDesignerFile;
    procedure SetDesignerFile(Value : TLlDesignerFile);
    procedure SetAutoDestination(Value : TAutoDestination);
    procedure SetAutoProjectType(Value : TAutoProjectType);
    procedure DataAutoDefine(nUserData: integer; bDummy: integer;
      pnProgressInPerc: Pinteger; pbLastRecord: Pinteger; var lResult: integer;
      bAsFields: boolean; Source: TDataSource; nMaster: integer);
    {$ifndef NOADVANCEDDATABINDING}
    procedure AdvancedDataBindingDataAutoDefine(nUserData: integer; bDummy: integer;
      pnProgressInPerc: Pinteger; pbLastRecord: Pinteger; var lResult: integer;
      bAsFields: boolean; Source: TDataSource; nMaster: integer; doSkip: boolean);
    {$endif}
    procedure SetAutoOptions(var nObjectType: integer; var nPrintOptions: integer);
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    procedure OnAutoDesignerPrintJob(Sender: TObject; UserParam: Integer;
      ProjectFileName, OriginalFileName: TString; Pages, Task: Cardinal;
      hWndPreviewControl: cmbtHWND; Event: THandle; var returnValue: Integer);

    procedure OnAutoDrillDownJob(Sender: TObject; Task: cardinal; UserParam: integer; ParentTableName: TString; RelationName: TString;
    ChildTableName: TString; ParentKey: TString; ChildKey: TString; KeyValue: TString; ProjectFileName: TString;
    PreviewFileName: TString; TooltipText: TString; TabText: TString; WindowHandle: cmbtHWND; JobID: longint; AttachInfo: THandle; var returnValue: integer);

    procedure CleanUpAfterInplaceDesign(Sender: TObject);

  public
    FTable: TDataSet;
    FTableMap: TTableMap;
    FDataLink: TDataLink;

    property MaxPage: integer read FMaxPage write FMaxPage;
    property Aborted: boolean read FAborted write SetAborted;

    constructor Create(AOwner: TComponent); overload; override;
    constructor Create(ASource: TDBL17_); reintroduce; overload;
    destructor Destroy; override;
    procedure InterpretOnAutoDefineTable(Table: TComponent);
    procedure InterpretOnAutoDefineTableSortOrder(const Table: TString; SortOrderName, SortOrderDisplayName: TString; DataType: integer);
    function InterpretOnAutoDefineTableRelation(ChildTable, ParentTable, TableRelation, KeyField, ParentKeyField: TString): TString;
    {$ifndef NOADVANCEDDATABINDING}
    procedure FillTableMapper;
    procedure PassDataStructure(AutoMasterMode: TAutoMasterMode; Source: TDataSource);
    procedure DefineCurrentRecord(Prefix: string; Table: TDataSet; AsField: boolean; DataSetType: TDataItemType);
    function PrintDataView(Table: TDataSet; Level, CurrentTableNo: integer):integer;
    {$endif}
    function Design(UserData: integer; ParentHandle: cmbtHWND; Title: TString; ProjectType: integer; ProjectName: TString; ShowFileSelect: boolean; AllowCreate: boolean): integer; override;
    {$ifndef NOADVANCEDDATABINDING}
    function AdvancedDataBindingDesign(UserData: integer; ParentHandle: cmbtHWND; Title: TString; ProjectType: integer; ProjectName: TString; ShowFileSelect: boolean; AllowCreate: boolean): integer;
    {$endif}
    function Print(UserData: integer; ProjectType: integer; ProjectName: TString; ShowFileSelect: boolean; PrintOptions: integer; BoxType: integer; ParentHandle: cmbtHWND; Title: TString; ShowPrintOptions: boolean; TempPath: TString): integer; override;
    {$ifndef NOADVANCEDDATABINDING}
    function AdvancedDataBindingPrint(UserData: integer; ProjectType: integer; ProjectName: TString; ShowFileSelect: boolean; PrintOptions: integer; BoxType: integer; ParentHandle: cmbtHWND; Title: TString; ShowPrintOptions: boolean; TempPath: TString): integer;
    {$endif}
    function AutoPrint(sTitle: TString; sTempPath: TString): integer;
    function AutoDesign(sTitle: TString): integer;
    {$ifndef NOADVANCEDDATABINDING}
    property AdvancedDataBinding: TPropYesNo read GetAdvancedDataBinding write SetAdvancedDataBinding;
    {$endif}
    property AutoMasterPrefix: TString read FAutoMasterPrefix write SetAutoMasterPrefix;
    property AutoDetailPrefix: TString read FAutoDetailPrefix write SetAutoDetailPrefix;
    property MasterSource: TDataSource read GetMasterSource write SetMasterSource;
  published
    property AutoShowPrintOptions: TPropYesNo read GetAutoShowPrintOptions write SetAutoShowPrintOptions;
    property AutoShowSelectFile: TPropYesNo read GetAutoShowSelectFile write SetAutoShowSelectFile;
    property AutoDefine: TPropYesNo read GetAutoDefine write SetAutoDefine;
    property AutoDesignerPreview: TPropYesNo read GetAutoDesignerPreview write SetAutoDesignerPreview;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property AutoDesignerFile: TLlDesignerFile read GetDesignerFile write SetDesignerFile;
    property AutoProjectType: TAutoProjectType read FAutoProjectType write SetAutoProjectType;
    property AutoDestination: TAutoDestination read FAutoDestination write SetAutoDestination;
    property AutoMasterMode: TAutoMasterMode read FAutoMasterMode write SetAutoMasterMode;
    property AutoBoxType: TAutoBoxType read FAutoBoxType write SetAutoBoxType;
    property OnAutoDefineNewPage: TAutoDefineNewPageEvent read FOnAutoDefineNewPage write FOnAutoDefineNewPage;
    property OnAutoDefineField: TAutoDefineFieldEvent read FOnAutoDefineField write FOnAutoDefineField;
    property OnAutoDefineVariable: TAutoDefineVariableEvent read FOnAutoDefineVariable write FOnAutoDefineVariable;
    property OnAutoDefineNewLine: TAutoDefineNewLineEvent read FOnAutoDefineNewLine write FOnAutoDefineNewLine;
    property OnAutoDefineTable: TAutoDefineTableEvent read FOnAutoDefineTable write FOnAutoDefineTable;
    property OnAutoDefineTableSortOrder: TAutoDefineTableSortOrderEvent read FOnAutoDefineTableSortOrder write FOnAutoDefineTableSortOrder;
    property OnAutoDefineTableRelation: TAutoDefineTableRelationEvent read FOnAutoDefineTableRelation write FOnAutoDefineTableRelation;
    property OnAutoNotifyProgress: TAutoNotifyProgress read FOnAutoNotifyProgress write FOnAutoNotifyProgress;
  end;

  TTableMap = class
  protected
    FKeyList: TStringList;
    FValueList: TList;
    FMasterFieldList: TStringList;
    FDetailFieldList: TStringList;
    FMasterTableList: TStringList;
    FDataTyp: TStringList;
  public
    constructor create;
    destructor Destroy; override;
    procedure AddProperty(Key: String; Value: TDataSet; MasterField, DetailField, MasterTable, DataTyp: TString);
    function GetValue(Key: String; var Value: TDataSet; var MasterField, DetailField, MasterTable, DataTyp: TString): boolean;
  end;

var DrillDownActive : boolean;

implementation

procedure ShowFileWarning;
{Raises an EDBLlFileError, if filename is unknown}
begin
  raise EDBLlFileError.Create('List & Label could not process this request. Project does not exist');
end;

procedure ShowPipeWarning;
{Raises an EDBLlPipeError, if pipe is not active}
begin
  raise EDBLlPipeError.Create(
    'List & Label could not process this request. Propably the Data Pipe is not active');
end;

constructor TDBL17_.Create(AOwner: TComponent);
  begin
    inherited Create(AOwner);
    LlSetOption(LL_OPTION_DRILLDOWN_SUPPORTS_EMBEDDING, 0);
    bIsPrinting := False;
    FDataLink := TDataLink.Create;
    FMasterLink := TDataLink.Create;
    FDesignerFile := '';
    FAutoMasterPrefix := 'Master';
    FAutoDetailPrefix := 'Detail';
    FAutoBoxType:=btStandardAbort;
    AutoDefine := Yes;
    AutoDesignerPreview := Yes;
    {$ifndef NOADVANCEDDATABINDING}
    AdvancedDataBinding := Yes;
    {$endif}
    FCritDesignerPrint := TCriticalSection.Create;
    FCritDrillDown     := TCriticalSection.Create;
    FTableMap := TTableMap.Create;
    MaxPage:=-1;
    Aborted:=false;
    FDrillDownJobId:=0;
  end;

destructor TDBL17_.Destroy;
begin
  FCritDesignerPrint.Free;
  FCritDrillDown.Free;
  FLLForDesignerPrint.Free;
  FLLForDrillDown.Free;

  FDataLink.Free;
  FMasterLink.Free;
  FTableMap.Free;

  inherited Destroy;
 end;

function TDBL17_.GetAutoShowSelectFile: TPropYesNo;
  begin
    if bAutoShowSelectFile then
      Result := Yes
    else
      Result := No;
  end;

procedure TDBL17_.SetAutoShowSelectFile(nMode : TPropYesNo);
  begin
    if nMode = Yes then bAutoShowSelectFile := True
    else
      bAutoShowSelectFile := False;
  end;

function TDBL17_.GetAutoShowPrintOptions: TPropYesNo;
  begin
    if bAutoShowPrintOptions then
      Result := Yes
    else
      Result := No;
  end;

procedure TDBL17_.SetAutoShowPrintOptions(nMode : TPropYesNo);
  begin
    if nMode = Yes then bAutoShowPrintOptions := True
    else
      bAutoShowPrintOptions := False;
  end;

function TDBL17_.GetAutoDefine: TPropYesNo;
begin
  if bAutoDefine then
    Result := Yes
  else
    Result := No;
end;

function TDBL17_.GetAutoDesignerPreview: TPropYesNo;
begin
  if bAutoDesignerPreview then
    Result := Yes
  else
    Result := No;
end;

procedure TDBL17_.SetAutoBoxType(const Value: TAutoBoxType);
begin
  FAutoBoxType := Value;
end;

procedure TDBL17_.SetAutoDefine(nMode : TPropYesNo);
begin
  if (nMode = Yes)      {  and ((Assigned(FDataLink.DataSource))     or (csLoading in ComponentState))} then
  begin
    bAutoDefine := True;
  end
  else
  begin
    bAutoDefine := False;
  end;
end;

function TDBL17_.GetDataSource: TDataSource;
  begin
    Result := FDataLink.DataSource;
  end;

procedure TDBL17_.SetDataSource(nSource: TDataSource);
  begin
    FDataLink.DataSource := nSource;
    if nSource <> nil then nSource.FreeNotification(self);

    LlSetOption(LL_OPTION_DRILLDOWNPARAMETER, 1);
    if not FIsCopy and not Assigned(FLLForDrillDown) then
    begin
      FLLForDrillDown := TDBL17_.Create(self);
    end;
    OnDrillDownJob := OnAutoDrillDownJob;
  end;

function TDBL17_.GetMasterSource: TDataSource;
begin
    Result := FMasterLink.DataSource;
end;

procedure TDBL17_.SetMasterSource(nSource: TDataSource);
begin
    FMasterLink.DataSource := nSource;
    if nSource <> nil then nSource.FreeNotification(self);
end;

function TDBL17_.TranslateBoxType(AutoBoxType: TAutoBoxType): integer;
begin
  case AutoBoxType of
    btStandardAbort: result:=7;
    btNone: result:=-1;
    btNormalMeter: result:=0;
    btBridgeMeter: result:=1;
    btNormalWait: result:=2;
    btBridgeWait: result:=3;
    btEmptyWait: result:=4;
    btEmptyAbort: result:=5;
    btStandardWait: result:=6;
    else result:=7;
  end;
end;

function TDBL17_.GetDesignerFile: TLlDesignerFile;
begin
    Result := FDesignerFile;
end;

procedure TDBL17_.SetDesignerFile(Value : TLlDesignerFile);
begin
    FDesignerFile := Value;
end;

procedure TDBL17_.SetAutoProjectType(Value : TAutoProjectType);
  begin
    FAutoProjectType := Value;
  end;

procedure TDBL17_.SetAutoDesignerPreview(nMode: TPropYesNo);
begin
  if (nMode = Yes) then
  begin
    bAutoDesignerPreview := True;
  end
  else
  begin
    bAutoDesignerPreview := False;
  end;
end;

procedure TDBL17_.SetAutoDestination(Value : TAutoDestination);
  begin
    FAutoDestination := Value;
    if Value = adUserSelect then AutoShowPrintOptions := Yes;
  end;

procedure TDBL17_.SetAutoMasterMode(Value : TAutoMasterMode);
  begin
  {$ifndef NOADVANCEDDATABINDING}
    if bAdvancedDataBinding or ((Value <> mmNone) and ((FMasterLink.active and (AutoDefine = Yes)) or
      (csLoading in ComponentState))) then
      FAutoMasterMode := Value
    else
      FAutoMasterMode := mmNone;
  {$else}
    if  ((Value <> mmNone) and ((FMasterLink.active and (AutoDefine = Yes)) or
      (csLoading in ComponentState))) then
      FAutoMasterMode := Value
    else
      FAutoMasterMode := mmNone;
  {$endif}
  end;

procedure TDBL17_.DataAutoDefine(nUserData: integer; bDummy: integer;
      pnProgressInPerc: Pinteger; pbLastRecord: Pinteger; var lResult: integer;
      bAsFields: boolean; Source: TDataSource; nMaster: integer);


(*Used if AutoDefine is switched on to declare fields / variables automatically
       from the datasource via FDataLink*)

{nMaster = LL_MASTER_NONE -> No Master/Detail;
 nMaster = LL_MASTER_DETAIL -> Data is Detail Data;
 nMaster = LL_MASTER_MASTER -> Data is Master Data}
  var
    i: integer;
    para: integer;
    SFieldName: TString;
    content: TString;
    handled: boolean;

    DefHandled: boolean;
  begin
    if ((nMaster <> LL_MASTER_MASTER) and FDataLink.active) or
      ((nMaster = LL_MASTER_MASTER) and FMasterLink.active) then
    begin
      if bAsFields and Assigned(FOnAutoDefineNewLine) and
        (nMaster <> LL_MASTER_MASTER) then
        OnAutoDefineNewLine(self, (bDummy = 1));

      for i := 0 to (Source.DataSet.FieldCount - 1) do
      begin
        handled := False;      (*internal flag*)
        DefHandled := False;   (*callback flag*)
        SFieldName := Source.DataSet.Fields[i].FieldName;

        if self.AutoMasterMode = mmAsFields then
          case nMaster of
            LL_MASTER_DETAIL:
              begin
                SFieldName := AutoDetailPrefix + '.' + SFieldName;
              end;
            LL_MASTER_MASTER:
              begin
                SFieldName := AutoMasterPrefix + '.' + SFieldName;
              end;
          end;

        DefineFieldContent(bDummy, Source, i, handled, DefHandled, SFieldName, para, content, bAsFields);

        if not (handled) then
        begin
          if bAsFields then
          begin
            if Assigned(FOnAutoDefineField) then
              OnAutoDefineField(self, (bDummy = 1), SFieldName,
                Content, para, DefHandled);
            if DefHandled = False then
            begin
              LlDefineFieldExt(SFieldName,
                content, para);
            end;
          end
          else
          begin
            if Assigned(FOnAutoDefineVariable) then
              OnAutoDefineVariable(self, (bDummy = 1), SFieldName,
                Content, para, DefHandled);
            if DefHandled = False then
            begin
              LlDefineVariableExt(SFieldName,
                Content, para);
            end;
          end;
        end;
      end;

      if Source.DataSet.EOF = True then pbLastRecord^ := 1
      else
        pbLastRecord^ := 0;


      if bDummy = 0 then
      begin
        Source.DataSet.Next;
        if Source.DataSet.EOF = True then pbLastRecord^ := 1
        else
          pbLastRecord^ := 0;
      end;

      if nMaster <> LL_MASTER_DETAIL then
      {Update percentage only if not detail from master/detail}
      begin
        if (Source.DataSet.RecordCount <> 0) then
          pnProgressInPerc^ := Round(FRecNo / Source.DataSet.RecordCount * 100)
        else
          pnProgressInPerc^ := 100;
        if pnProgressInPerc^ > 100 then pnProgressInPerc^ := 100;
        inc(FRecNo);
      end;
    end; {Assigned(Source)}
  end;

{$ifndef NOADVANCEDDATABINDING}
procedure TDBL17_.AdvancedDataBindingDataAutoDefine(nUserData: integer; bDummy: integer;
      pnProgressInPerc: Pinteger; pbLastRecord: Pinteger; var lResult: integer;
      bAsFields: boolean; Source: TDataSource; nMaster: integer; doSkip: boolean);
(*Used if AutoDefine is switched on to declare fields / variables automatically
       from the datasource via FDataLink*)

{nMaster = LL_MASTER_NONE -> No Master/Detail;
 nMaster = LL_MASTER_DETAIL -> Data is Detail Data;
 nMaster = LL_MASTER_MASTER -> Data is Master Data}
var
  i: integer;
  para: integer;
  SFieldName: TString;
  content: TString;
  handled: boolean;
  DefHandled: boolean;
  nTableName: TString;
  begin
    if (nMaster = LL_MASTER_MASTER) and FDataLink.active then
    begin
      if Assigned(FOnAutoDefineNewLine) then
        OnAutoDefineNewLine(self, (bDummy = 1));

      {$ifdef BDEAVAILABLE}
      if Source.DataSet is TTable then
        if pos('.',(TTable(Source.DataSet).TableName)) > 0 then
          nTableName := ExtractTableName(TTable(Source.DataSet).TableName)
        else
         nTableName := TTable(Source.DataSet).TableName
      else
      {$endif}

        {$ifdef ADOAVAILABLE}
        if Source.DataSet is TADOTable then
         nTableName := TADOTable(Source.DataSet).TableName
        else
        {$endif}
         if Source.DataSet is TDataSet then
          nTableName := Source.DataSet.Name;

      for i := 0 to (Source.DataSet.FieldCount - 1) do
      begin
        handled := False;      (*internal flag*)
        DefHandled := False;   (*callback flag*)
        SFieldName :=  nTableName + '.' + Source.DataSet.Fields[i].FieldName;

        if self.AutoMasterMode = mmAsFields then
          case nMaster of
            LL_MASTER_DETAIL:
              begin
                SFieldName := AutoDetailPrefix + '.' + SFieldName;
              end;
            LL_MASTER_MASTER:
              begin
                SFieldName :=  nTableName + '.' + Source.DataSet.Fields[i].FieldName;
              end;
          end;

        DefineFieldContent(bDummy, Source, i, handled, DefHandled, SFieldName, para, content, bAsFields);

        if not (handled) then
        begin
          if bAsFields then
          begin
            if Assigned(FOnAutoDefineField) then
              OnAutoDefineField(self, (bDummy = 1), SFieldName, Content, para, DefHandled);
            if DefHandled = False then
              LlDefineFieldExt(SFieldName, content, para);
          end
          else
          begin
            if Assigned(FOnAutoDefineVariable) then
              OnAutoDefineVariable(self, (bDummy = 1), SFieldName, Content, para, DefHandled);
            if DefHandled = False then
              LlDefineVariableExt(SFieldName, Content, para);
          end;
        end;
      end;     //end Source.FieldCount

      if Source.DataSet.EOF = True then pbLastRecord^ := 1
      else
        pbLastRecord^ := 0;


      if doSkip = true then
      begin
        Source.DataSet.Next;
        if Source.DataSet.EOF = True then pbLastRecord^ := 1
        else
          pbLastRecord^ := 0;
      end;

      if nMaster <> LL_MASTER_DETAIL then
      {Update percentage only if not detail from master/detail}
      begin
        if (Source.DataSet.RecordCount <> 0) then
          pnProgressInPerc^ := Round(FRecNo / Source.DataSet.RecordCount * 100)
        else
          pnProgressInPerc^ := 100;
        if pnProgressInPerc^ > 100 then pnProgressInPerc^ := 100;
        inc(FRecNo);
      end;
    end; {Assigned(Source)}
  end;
{$endif}
procedure TDBL17_.SetAutoDetailPrefix(Value : TString);
  begin
    FAutoDetailPrefix := Value;
  end;

procedure TDBL17_.SetAutoMasterPrefix(Value : TString);
  begin
    FAutoMasterPrefix := Value;
  end;

procedure TDBL17_.SetAutoOptions(var nObjectType: integer; var nPrintOptions: integer);
  begin
    case AutoDestination of
      adPrinter:    nPrintOptions := LL_PRINT_NORMAL;
      adPRNFile:    nPrintOptions := LL_PRINT_FILE;
      adUserSelect: nPrintOptions := LL_PRINT_USERSELECT;
      adExport:     nPrintOptions := LL_PRINT_EXPORT
      else
        nPrintOptions := LL_PRINT_PREVIEW;
    end;

    case AutoProjectType of
      ptListProject:
        begin
          nObjectType := LL_PROJECT_LIST;
        end;
      ptLabelProject: 
        begin
          nObjectType := LL_PROJECT_LABEL;
        end;
      else
        begin
          nObjectType := LL_PROJECT_CARD;
        end;
    end;
  end;

function TDBL17_.AutoPrint(sTitle: TString; sTempPath: TString): integer;
  var
    nPrintOptions, nObjectType: integer;
    bShowFileSelect, bShowPrintOptions: boolean;
    WinHandle: cmbtHWND;
  begin
    FRecNo := 0;
    if not (((FileExists(AutoDesignerFile)) or (AutoShowSelectFile = Yes)) and
      FDataLink.active and (AutoDefine = Yes)) then
    begin
      Result := -1;
      if not FileExists(AutoDesignerFile) then ShowFileWarning
      else
        ShowPipeWarning;
      exit;
    end;

    SetAutoOptions(nObjectType, nPrintOptions);
    if AutoShowSelectFile = Yes then bShowFileSelect := True
    else
      bShowFileSelect := False;

    if AutoShowPrintOptions = Yes then bShowPrintOptions := True
    else
      bShowPrintOptions := False;

    if not (csDesigning in ComponentState) then WinHandle := Application.handle
    else
        WinHandle := GetActiveWindow();


    {$ifndef NOADVANCEDDATABINDING}
    if ((AdvancedDataBinding = No) or (nObjectType and $7FFF <> LL_PROJECT_LIST) ) then
     Result := Print(1, nObjectType, AutoDesignerFile, bShowFileSelect, nPrintOptions,
      TranslateBoxType(AutoBoxType), WinHandle, sTitle, bShowPrintOptions, sTempPath)
    else
    Result := AdvancedDataBindingPrint(1, nObjectType, AutoDesignerFile, bShowFileSelect, nPrintOptions,
      TranslateBoxType(AutoBoxType), WinHandle, sTitle, bShowPrintOptions, sTempPath);
    {$else}
     Result := Print(1, nObjectType, AutoDesignerFile, bShowFileSelect, nPrintOptions,
      TranslateBoxType(AutoBoxType), WinHandle, sTitle, bShowPrintOptions, sTempPath)
    {$endif}
  end;

constructor TDBL17_.Create(ASource: TDBL17_);
begin
    inherited Create(ASource);
    LlSetOption(LL_OPTION_DRILLDOWN_SUPPORTS_EMBEDDING, 0);
    bIsPrinting := ASource.bIsPrinting;
    bAutoDesignerPreview := ASource.bAutoDesignerPreview;
    FDataLink :=  TDataLink.Create;
    FMasterLink := TDataLink.Create;
    FDesignerFile := ASource.FDesignerFile;
    FAutoMasterPrefix := ASource.FAutoMasterPrefix;
    FAutoDetailPrefix := ASource.FAutoDetailPrefix;
    FAutoBoxType := ASource.FAutoBoxType;
    AutoDefine := ASource.AutoDefine;
    {$ifndef NOADVANCEDDATABINDING}
    AdvancedDataBinding := ASource.AdvancedDataBinding;
    {$endif}
    FTableMap := TTableMap.Create;

    FAutoMasterMode := ASource.FAutoMasterMode;
    DataSource := ASource.DataSource;
    FOnAutoDefineField:=ASource.FOnAutoDefineField;
    FOnAutoDefineVariable:=ASource.FOnAutoDefineVariable;
    FOnAutoDefineNewPage:=ASource.FOnAutoDefineNewPage;
    FOnAutoDefineNewLine:=ASource.FOnAutoDefineNewLine;
    FOnAutoDefineTable:=ASource.FOnAutoDefineTable;
    FOnAutoDefineTableSortOrder:=ASource.FOnAutoDefineTableSortOrder;
    FOnAutoDefineTableRelation:=ASource.FOnAutoDefineTableRelation;
    FOnAutoNotifyProgress:=ASource.FOnAutoNotifyProgress;
end;

function TDBL17_.AutoDesign(sTitle: TString): integer;
  var
    nPrintOptions, nObjectType: integer;
    bShowFileSelect: boolean;
    WinHandle: cmbtHWND;
  begin
    if not (FDataLink.Active and (AutoDefine = Yes)) then
    begin
      ShowPipeWarning;
      Result := -1;
      exit;
    end;

    SetAutoOptions(nObjectType, nPrintOptions);
    if AutoShowSelectFile = Yes then bShowFileSelect := True
    else
      bShowFileSelect := False;

    if csDesigning in ComponentState then WinHandle := Application.handle
    else
      if TForm(Owner).HandleAllocated then
        WinHandle := TForm(Owner).Handle
      else
        WinHandle := GetActiveWindow();

  {$ifndef NOADVANCEDDATABINDING}
    if ((AdvancedDataBinding = No) or (nObjectType and $7FFF <> LL_PROJECT_LIST) ) then
     Result := Design(1, WinHandle, sTitle, nObjectType, AutoDesignerFile, bShowFileSelect, true)
    else Result := AdvancedDataBindingDesign(1, WinHandle, sTitle, nObjectType, AutoDesignerFile, bShowFileSelect, true);
    {$else}
     Result := Design(1, WinHandle, sTitle, nObjectType, AutoDesignerFile, bShowFileSelect, true)
    {$endif}
  end;

procedure TDBL17_.DefineFieldContent(bDummy: Integer; Source: TDataSource; i: Integer; var handled: Boolean; DefHandled: Boolean; SFieldName: TString; var para: Integer; var content: TString; bAsFields: Boolean);
var
  BlobStream: TStream;
  BufferStream: TMemoryStream;
  sDummy: TString;
  const DigitBool: array[Boolean] of string = ('0', '1');
begin
  case Source.DataSet.Fields[i].DataType of
    ftInteger, ftsmallint, ftAutoInc, ftFloat, ftWord: {numeric}
        begin
          para := LL_NUMERIC;
          {Flag null value}
          if Source.DataSet.Fields[i].IsNull then
            content := '(NULL)'
          else
            content := Source.DataSet.Fields[i].AsString;
        end;
    ftDate, ftDateTime: {date}
        begin
          para := LL_DATE_DELPHI;
          {Flag invalid date}
          if Source.DataSet.Fields[i].IsNull then
            content := '(NULL)'
          else
            content := FloatToStr(StrToDateTime(Source.DataSet.Fields[i].AsString));
        end;
    ftBoolean: {boolean}
        begin
          para := LL_BOOLEAN;
          {Flag null value}
          if Source.DataSet.Fields[i].IsNull then
            content := '(NULL)'
          else
            content := DigitBool[Source.DataSet.Fields[i].AsBoolean];
        end;
    ftCurrency:
        begin
          para := LL_NUMERIC;
          {Flag null value}
          if Source.DataSet.Fields[i].IsNull then
            content := '(NULL)'
          else
            content := Source.DataSet.Fields[i].AsString;
        end;
    ftBCD:
        begin
          para := LL_NUMERIC;
          {Flag null value}
          if Source.DataSet.Fields[i].IsNull then
            content := '(NULL)'
          else
            content := Source.DataSet.Fields[i].AsString;
        end;
    ftBlob:
        begin {BLOB-Fields are regarded as RTF}
          para := LL_RTF;
          {$ifdef ver90}
          BlobStream := TBlobStream.Create(TBlobField(Source.DataSet.Fields[i]), bmRead);
          {$else}
          BlobStream := Source.DataSet.CreateBlobStream(Source.DataSet.Fields[i], bmRead);
          {$endif}
          BufferStream := TMemoryStream.Create;
          BufferStream.LoadFromStream(BlobStream);
          if bAsFields then
          begin
            if Assigned(FOnAutoDefineField) then
            begin
              sDummy := 'BLOB';
              OnAutoDefineField(self, (bDummy = 1), SFieldName, sDummy, para, DefHandled);
            end;
            if DefHandled = False then
              LlDefineFieldExt(SFieldName, TString(PTChar(BufferStream.Memory)), para);
          end else
          begin
            if Assigned(FOnAutoDefineVariable) then
            begin
              sDummy := 'BLOB';
              OnAutoDefineVariable(self, (bDummy = 1), SFieldName, sDummy, para, DefHandled);
            end;
            if DefHandled = False then
              LlDefineVariableExt(SFieldName, TString(BufferStream.Memory), para);
          end;
          BlobStream.Free;
          BufferStream.Free;
          handled := True;
        end
    {$ifdef UNICODE}
    {$ifdef ADOAVAILABLE}
      ;
      ftWideString:
      begin
          para:=LL_TEXT;
          {Flag null value}
          if Source.DataSet.Fields[i].IsNull then
            content := '(NULL)'
          else
            content:=TWideStringField(Source.DataSet.Fields[i]).Value;
      end;
    {$endif}
    {$endif}
    else
    begin
      {text variables}
      para := LL_TEXT;
      {Flag null value}
      if Source.DataSet.Fields[i].IsNull then
        content := '(NULL)'
      else
        content := Source.DataSet.Fields[i].AsString;
    end;
  end; //end case
end;

{$ifdef BDEAVAILABLE}
function TDBL17_.ExtractTableName(tableName: string): string;
begin
  result := copy(tableName,0,pos('.',tableName)-1);
end;
{$endif}

{$ifndef NOADVANCEDDATABINDING}
////////////////////////////////////////////////////////////////////////////////
//Fills the TTableMap class with...                                           //
//  ...a Key e.g. a table 'Orders'                                            //
//  ...a Value as a pointer to a TDataSet                                     //
//  ...a MasterField e.g. 'CustomerID' and                                    //
//  ...a DetailField e.g. 'OrdersID'                                          //
//  ...a DatyTyp e.g. 'LL_TADOTABLE'                                          //
////////////////////////////////////////////////////////////////////////////////
procedure TDBL17_.FillTableMapper();
var
  nTableName, DataTyp: TString;
begin
  if FTableMap.FKeyList.Count<>0 then
  begin
    FTableMap.Free;
    FTableMap:=TTableMap.create;
  end;
  if AutoMasterMode = mmNone then
  begin

    {$ifdef BDEAVAILABLE}
    if (DataSource.DataSet is TTable) then
    begin
      nTableName := TTable(DataSource.DataSet).TableName;
      FTableMap.AddProperty(nTableName, TTable(DataSource.DataSet), '', '', '', 'LL_TTABLE');
    end
    else
    {$endif}

    {$ifdef ADOAVAILABLE}
    if (DataSource.DataSet is TADOTable) then
    begin
      nTableName := TADOTable(DataSource.DataSet).TableName;
      FTableMap.AddProperty(nTableName, TADOTable(DataSource.DataSet), '', '', '', 'LL_TADOTABLE');
    end
    else
    {$endif}
    if (DataSource.DataSet is TDataSet) then
    begin
      nTableName := TDataSet(DataSource.DataSet).Name;
      FTableMap.AddProperty(nTableName, TDataSet(DataSource.DataSet), '', '', '', 'LL_TDATASET');
    end;
  end else //end of mmNone
  begin
    {$ifdef ADOAVAILABLE}
    if DataSource.DataSet is TADOTable then
    begin
      nTableName := (DataSource.DataSet as TADOTable).TableName;
      DataTyp := 'LL_TADOTABLE';
    end else
    if DataSource.DataSet is TADODataSet then
    begin
      nTableName := (DataSource.DataSet as TADODataSet).Name;
      DataTyp := 'LL_TADODATASET';
    end else
    {$endif}

      {$ifdef BDEAVAILABLE}
      if DataSource.DataSet is TTable then
      begin
        if pos('.',(TTable(DataSource.DataSet).TableName)) > 0 then
          nTableName := ExtractTableName(TTable(DataSource.DataSet).TableName)
        else
        nTableName := (DataSource.DataSet as TTable).TableName;
        DataTyp := 'LL_TTABLE';
      end else
      {$endif}
      begin
        nTableName :=DataSource.DataSet.Name;
        DataTyp := 'LL_TDATASET';
      end;

    FTableMap.AddProperty(nTableName, DataSource.DataSet, '', '', '', DataTyp);
    FillDataStructure(DataSource.DataSet);
   end; //end of mastermode
end;
{$endif}
function TDBL17_.Design(UserData: integer; ParentHandle: cmbtHWND; Title: TString;
      ProjectType: integer; ProjectName: TString; ShowFileSelect: boolean; AllowCreate: boolean): integer;
  var
    nProgressInPerc: integer;
    bLastRecord: integer;
    nRet: integer;
    bMaster: integer;
    bFields: boolean;
  begin
    nProgressInPerc := 0;
    bLastRecord := 0;
    nRet := 0;

    if (AllowCreate) then
      ProjectType:=ProjectType or LL_FILE_ALSONEW
    else
      ProjectType:=ProjectType and $7FFF;


    if (ShowFileSelect) then
    begin
      nRet := LlSelectFileDlgTitle(ParentHandle, '',
        ProjectType and $800F, ProjectName);
      if (nRet <> 0) then
      begin
        Result := nRet;
        exit;
      end
    end;
    ProjectType := ProjectType and $7fff;
    (*end of initialization; now get the Variables and Fields*)

    LlDefineVariableStart;
    LlDefineChartFieldStart;
    LlDefineFieldStart;

    if (AutoDefine = No) then
    begin
      DefineVariablesCallback(UserData, 1, @nProgressInPerc, @bLastRecord, nRet);
      DefineFieldsCallback(UserData, 1, @nProgressInPerc, @bLastRecord, nRet);
      Result := 0;
    end
    else
    begin
      if FDataLink.Active then
      begin
        DataSource.DataSet.First;
        if ((ProjectType and LL_PROJECT_LABEL) = LL_PROJECT_LABEL) or
          ((ProjectType and LL_PROJECT_CARD) = LL_PROJECT_CARD) then
        begin
          DataAutoDefine(1,1, @nProgressInPerc, @bLastRecord, nRet,
            False, FDataLink.DataSource, LL_MASTER_NONE);
        end
        else
        begin
          if Assigned(FOnAutoDefineNewPage) then
          begin
            OnAutoDefineNewPage(self, True);
          end;

          if AutoMasterMode = mmNone then bMaster := LL_MASTER_NONE
          else
          begin
            bMaster := LL_MASTER_DETAIL; {Define as detail}
          end;

          DataAutoDefine(1,1, @nProgressInPerc, @bLastRecord, nRet,
            True, FDataLink.DataSource, bMaster);
        end;
      end;

      if ((AutoMasterMode <> mmNone) and Assigned(MasterSource)) then {Master/Detail-Mode}
      begin
        MasterSource.DataSet.First;
        if AutoMasterMode = mmAsVariables then
          LlDefineVariableExt('LL.MasterRecNo', '1', LL_NUMERIC)
        else
          LlDefineFieldExt('LL.MasterRecNo', '1', LL_NUMERIC);
        bMaster := LL_MASTER_MASTER;  {define as master}
        if AutoMasterMode = mmAsFields then bFields := True
        else
        begin
          bFields := False;
        end;

        DataAutoDefine(1,1, @nProgressInPerc, @bLastRecord,
          nRet, bFields, FMasterLink.DataSource, bMaster);
      end;


      Result := LlDefineLayout(ParentHandle, Title,
        ProjectType and $7FFF, ProjectName);
    end;
  end;

{$ifndef NOADVANCEDDATABINDING}
function TDBL17_.AdvancedDataBindingDesign(UserData: integer; ParentHandle: cmbtHWND; Title: TString;
      ProjectType: integer; ProjectName: TString; ShowFileSelect: boolean; AllowCreate: boolean): integer;
var
  nProgressInPerc: integer;
  bLastRecord: integer;
  nRet: integer;
  bMaster: integer;
  bFields: boolean;
begin
      nProgressInPerc := 0;
      bLastRecord := 0;
      nRet := 0;

      if (AllowCreate) then
        ProjectType:=ProjectType or LL_FILE_ALSONEW
      else
        ProjectType:=ProjectType and $7FFF;


      if (ShowFileSelect) then
      begin
        nRet := LlSelectFileDlgTitle(ParentHandle, '',
          ProjectType and $800F, ProjectName);
        if (nRet <> 0) then
        begin
          Result := nRet;
          exit;
        end
      end;
      ProjectType := ProjectType and $7fff;
      (*end of initialization; now get the Variables and Fields*)

      LlDefineVariableStart;
      LlDefineChartFieldStart;
      LlDefineFieldStart;

      if (AutoDefine = No) then
      begin
        DefineVariablesCallback(UserData, 1, @nProgressInPerc, @bLastRecord, nRet);
        DefineFieldsCallback(UserData, 1, @nProgressInPerc, @bLastRecord, nRet);
        Result := 0;
      end
      else
      begin
        if FDataLink.Active then
        begin

          DataSource.DataSet.First;

          //Fills the TTableMap class
          FillTableMapper();

          if ((ProjectType and LL_PROJECT_LIST) = LL_PROJECT_LIST) then
          begin
            if Assigned(FOnAutoDefineNewPage) then
            begin
              OnAutoDefineNewPage(self, True);
            end;
          end;
          PassDataStructure(AutoMasterMode, FDataLink.DataSource);

        end;

        if AutoMasterMode <> mmNone then {Master/Detail-Mode}
        begin
          if AutoMasterMode = mmAsVariables then
            LlDefineVariableExt('LL.MasterRecNo', '1', LL_NUMERIC)
          else
            LlDefineFieldExt('LL.MasterRecNo', '1', LL_NUMERIC);
          bMaster := LL_MASTER_MASTER;  {define as master}
          if AutoMasterMode = mmAsFields then bFields := True
          else
          begin
            bFields := False;
          end;
          AdvancedDataBindingDataAutoDefine(1,1, @nProgressInPerc, @bLastRecord,
            nRet, bFields, FDataLink.DataSource, bMaster, false);
        end;

        if bAutoDesignerPreview then
        begin
          //Einschalten der Funktionen für den Druck / Export im Designer:
          LlSetOption(LL_OPTION_DESIGNERPREVIEWPARAMETER, 1);
          LlSetOption(LL_OPTION_DESIGNEREXPORTPARAMETER, 1);
          LlSetOption(LL_OPTION_DESIGNERPRINT_SINGLETHREADED, 1);
          FLLForDesignerPrint := TDBL17_.Create(self);
          OnDesignerPrintJob := OnAutoDesignerPrintJob;
        end;

        Result := LlDefineLayout(ParentHandle, Title,
          ProjectType and $7FFF, ProjectName);

        if (Assigned(FLLForDesignerPrint) and (InplaceDesignerHandle=0)) then
        begin
          FLLForDesignerPrint.Free;
          FLLForDesignerPrint := nil;
        end
        else
        begin
          OnInplaceDesignerClosed := CleanUpAfterInplaceDesign;
        end;

      end;
  end;

procedure TDBL17_.CleanUpAfterInplaceDesign(Sender: TObject);
begin
    if (Assigned(FLLForDesignerPrint) and (InplaceDesignerHandle=0)) then
    begin
      FLLForDesignerPrint.Free;
      FLLForDesignerPrint := nil;
    end;
end;

{$endif}
function TDBL17_.Print(UserData: integer; ProjectType: integer; ProjectName: TString;
      ShowFileSelect: boolean; PrintOptions: integer; BoxType: integer;
      ParentHandle: cmbtHWND;
      Title: TString; ShowPrintOptions: boolean; TempPath: TString): integer;
  var
    nRet: integer;
    nProgressInPerc: integer;
    bLastRecord: integer;
    sPath: TString;
    sDir: TString;
    sPort: TString;
    sPrinter: TString;
    sPreviewFile: TString;
    nCopies: integer;
    i: integer;
    btmpDelayTableHeader: boolean;
    bWrnRepeatDataMode: boolean;
    bToPreview: boolean;
    nMaster: integer;
    bMasterDetailMode: boolean;
    bContinued: boolean;
    bFirst: boolean;
    bLabelPrinting: boolean;
    nOptions: integer;
    Printer, Port: TString;

    nMasterRecNo: integer;
    Dummy: TString;
  begin
    nRet := 0;
    nProgressInPerc := 0;
    bLastRecord := 0;
    sPath := '';
    sDir := '';
    sPort := '';
    sPrinter := '';
    nCopies := 1;
    btmpDelayTableHeader := bDelayTableHeader;
    bWrnRepeatDataMode := False;
    bMasterDetailMode := False;
    bFirst := False;
    nMasterRecNo := 1;
    nOptions := 0;
    bLabelPrinting := (((ProjectType and $7FFF) = LL_PROJECT_LABEL) or
      ((ProjectType and $7FFF) = LL_PROJECT_CARD));

    if (ShowFileSelect) then
    begin
      nRet := LlSelectFileDlgTitle(ParentHandle, '',
        ProjectType and $7FFF, ProjectName);
      if (nRet <> 0) then
      begin
        Result := nRet;
        exit;
      end;
    end;
    ProjectType := ProjectType and $7FFF;
    (*define all variables*)
    nMaster := LL_MASTER_NONE;
    LlDefineVariableStart;
    LlDefineChartFieldStart;

    if (AutoDefine = No) then
      DefineVariablesCallback(UserData, 1, @nProgressInPerc, @bLastRecord, nRet)
    else
    begin
      if FDataLink.Active then
        DataSource.DataSet.First;
      if (ProjectType <> LL_PROJECT_LIST) then
        DataAutoDefine(1,1, @nProgressInPerc, @bLastRecord, nRet,
          False, FDataLink.DataSource, LL_MASTER_NONE);
      if Assigned(FOnAutoDefineNewPage) then OnAutoDefineNewPage(self, True);
    end;

    (*define all fields if list project*)

    if (ProjectType = LL_PROJECT_LIST) then
    begin
      LlDefineFieldStart;
      if (AutoDefine = No) then
        DefineFieldsCallback(UserData, 1, @nProgressInPerc, @bLastRecord, nRet)
      else
      begin
        if FDataLink.Active then
          DataSource.DataSet.First;
        if FMasterLink.Active and (AutoMasterMode <> mmNone) then
          MasterSource.DataSet.First;
        if AutoMasterMode = mmNone then nMaster := LL_MASTER_NONE
        else
        begin
          nMaster := LL_MASTER_DETAIL;
          if AutoMasterMode = mmAsVariables then
            LlDefineVariableExt('LL.MasterRecNo', '1', LL_NUMERIC)
          else
            LlDefineFieldExt('LL.MasterRecNo', '1', LL_NUMERIC)
        end;

        DataAutoDefine(1,1, @nProgressInPerc, @bLastRecord, nRet,
          True, FDataLink.DataSource, nMaster);

        case AutoMasterMode of
          mmAsFields: DataAutoDefine(1,1, @nProgressInPerc, @bLastRecord, nRet,
              True, FMasterLink.DataSource, LL_MASTER_MASTER);
          mmAsVariables: DataAutoDefine(1,1, @nProgressInPerc, @bLastRecord, nRet,
              False, FMasterLink.DataSource, LL_MASTER_MASTER);
        end;
        FRecNo := 0;
      end;
    end;

    (*initialize printing*)

    nRet := LlPrintWithBoxStart(ProjectType, ProjectName, PrintOptions,
      BoxType, ParentHandle, Title);

    if nRet < 0 then
    begin
      Result := nRet;
      exit;
    end;

    (*show print options dialog?*)
    if Assigned(FOnSetPrintOptionsEvent) then
      FOnSetPrintOptionsEvent(self, nOptions);

    if MaxPage>0 then
    begin
    	LlPrintSetOption(LL_OPTION_LASTPAGE, MaxPage);
    end;

    if ShowPrintOptions then
    begin
      if bLabelPrinting then
        LlPrintSetOption(LL_OPTION_COPIES, nCopies)
      else
        LlPrintSetOption(LL_PRNOPT_PRINTDLG_ONLYPRINTERCOPIES, 1);
      LlPrintSetOption(LL_OPTION_PAGE, LL_PAGE_HIDE);

      nRet := LlPrintOptionsDialog(ParentHandle, Title);

      if nRet < 0 then
      begin
        LlPrintEnd(0);
        Result := nRet;
        exit;
      end;
      LlPrintSetOption(LL_OPTION_PAGE, 1);
    end;

    LlPrintGetPrinterInfo(Printer, Port);


    (*Destination may have changed*)
    if LlPrintGetOption(LL_PRNOPT_PRINTDLG_DEST) = LL_DESTINATION_PRV then
      bToPreview := True
    else
      bToPreview := False;

    (*set preview file path and name*)
    if bToPreview = True then
    begin
      sPreviewFile := TempPath + ExtractFileName(ProjectName);
      LlPreviewSetTempPath(TempPath);
    end;

    (*Direct copies-support only for label printing*)
    if bLabelPrinting then
    begin
      nCopies := LlPrintGetOption(LL_OPTION_COPIES);
      LlPrintSetOption(LL_OPTION_COPIES, 1);
    end
    else
     (*For Lists copies have to be made by the driver. This has to be set
       however...*)
    begin
      if LlPrintGetOption(LL_PRNOPT_COPIES_SUPPORTED) = 0 then
        (*The input number of copies is not supported -> reset to 1*)
        LlPrintSetOption(LL_PRNOPT_COPIES, nCopies);
    end;


     (*----------------------
        main printing routine
       ----------------------

       labels and cards*)


    if bLabelPrinting then
    begin
      while ((bLastRecord = 0) and (nRet = 0)) and (LlPrintGetOption(LL_PRNOPT_PAGEINDEX) < LlPrintGetOption(LL_PRNOPT_LASTPAGE)) do
      begin
        (*define variables*)
        //LlDefineVariableStart; Empty the internal variable buffer - not needful here

        if Assigned(FOnAutoDefineNewPage) then OnAutoDefineNewPage(self, False);
        if (AutoDefine = No) then
          DefineVariablesCallback(UserData, 0, @nProgressInPerc, @bLastRecord, nRet)
        else
          DataAutoDefine(UserData, 0, @nProgressInPerc, @bLastRecord, nRet,
            False, FDataLink.DataSource, LL_MASTER_NONE);


        if nProgressInPerc < 0 then
          nProgressInPerc := 0
        else if nProgressInPerc > 100 then
          nProgressInPerc := 100;

        nRet := LlPrintSetBoxText(Printer, nProgressInPerc);

        if nRet = LL_ERR_USER_ABORTED then
        begin
          LlPrintEnd(0);
          Result := nRet;
          exit;
        end;

        for i := 1 to nCopies do
        begin
          repeat
            nRet := LlPrint;
          until nRet <> LL_WRN_REPEAT_DATA;
        end;
      end;
    end
    else (*print lists*)
    begin
      (*set List & Label Options*)
      LlSetOption(LL_OPTION_DELAYTABLEHEADER, 1);
      bContinued := False; {Flag whether LlPrint() should be supressed or not}

      if AutoMasterMode <> mmNone then    {Supply master data}
      begin
        bMasterDetailMode := True;
        bFirst := True;
        if Assigned(FOnAutoDefineNewPage) then OnAutoDefineNewPage(self, False);
        while (LlPrint=LL_WRN_REPEAT_DATA) do;
        //LlDefineFieldStart; {free the detail data} //Empty the internal variable buffer - not needful here

        case AutoMasterMode of
          mmAsFields:
            DataAutoDefine(1,1, @nProgressInPerc, @bLastRecord, nRet,
              True, FMasterLink.DataSource, LL_MASTER_MASTER);
          mmAsVariables:
            DataAutoDefine(1,1, @nProgressInPerc, @bLastRecord, nRet,
              False, FMasterLink.DataSource, LL_MASTER_MASTER);
        end;
      end;

      bLastRecord := 0;

      {Outer loop: Master/Detail}

      repeat {for each Master record / at least once}

        if bMasterDetailMode = True then DataSource.DataSet.First;

        Dummy:=IntToStr(nMasterRecNo);
        if AutoMasterMode = mmAsVariables then
          LlDefineVariableExt('LL.MasterRecNo', Dummy, LL_NUMERIC)
        else
          LlDefineFieldExt('LL.MasterRecNo', Dummy, LL_NUMERIC);
        inc(nMasterRecNo);

        while (((bLastRecord = 0) and (nRet = 0)) or
          ((bLastRecord <> 0) and (bWrnRepeatDataMode = True) and (nRet = 0))) and (LlPrintGetOption(LL_PRNOPT_PAGEINDEX) < LlPrintGetOption(LL_PRNOPT_LASTPAGE)) do
        begin  {page}
          if nRet = LL_ERR_USER_ABORTED then
          begin
            LlPrintEnd(0);
            if btmpDelayTableHeader = False then
              LlSetOption(LL_OPTION_DELAYTABLEHEADER, 0);
            Result := nRet;
            exit;
          end;

          if (AutoDefine = No) then
            DefineVariablesCallback(UserData, 0, @nProgressInPerc, @bLastRecord, nRet);

          if not bContinued and not bFirst then
          begin
            if Assigned(FOnAutoDefineNewPage) and (AutoDefine <> No) then
              OnAutoDefineNewPage(self, False);
            while (LlPrint=LL_WRN_REPEAT_DATA) do;
          end;


          if bFirst then bFirst := False;
          {Skip Page start for first Master/Detail - handled before}
          while (bLastRecord = 0) and (nRet = 0) or
            ((bLastRecord <> 0) and (bWrnRepeatDataMode = True) and (nRet = 0)) do
          begin  {lines}
            if bWrnRepeatDataMode = False then
              if (AutoDefine = No) then
                DefineFieldsCallback(UserData, 0, @nProgressInPerc, @bLastRecord, nRet)
              else
                DataAutoDefine(UserData, 0, @nProgressInPerc, @bLastRecord,
                  nRet, True, FDataLink.DataSource, nMaster);

            if nProgressInPerc < 0 then
              nProgressInPerc := 0
            else if nProgressInPerc > 100 then
              nProgressInPerc := 100;

            if AutoMasterMode = mmNone then   {Don't update in master/detail-mode}
            begin
              nRet := LlPrintSetBoxText(Printer,
                nProgressInPerc);

              if nRet = LL_ERR_USER_ABORTED then
              begin
                LlPrintEnd(0);
                if btmpDelayTableHeader = False then
                  LlSetOption(LL_OPTION_DELAYTABLEHEADER, 0);
                Result := nRet;
                exit;
              end;
            end;

            nRet := LlPrintFields;
            if ((bWrnRepeatDataMode = False) and (self.UseChartFields = Yes)) then
              LlPrintDeclareChartRow(LL_DECLARECHARTROW_FOR_OBJECTS);

            if nRet <> LL_WRN_REPEAT_DATA then bWrnRepeatDataMode := False
          end;  {lines}

          bContinued := False;

          if nRet = LL_WRN_REPEAT_DATA then
          begin
            bWrnRepeatDataMode := True;
            nRet := 0;
          end
          else
            bWrnRepeatDataMode := False;
        end;  {page}


        if (AutoMasterMode <> mmNone) and Assigned(MasterSource) then
        begin
          MasterSource.DataSet.Next; {skip to next}

          if MasterSource.DataSet.EOF = False then
          begin
            //LlDefineFieldStart; {free the detail data} //Empty the internal variable buffer - not needful here
            case AutoMasterMode of
              mmAsFields:
                begin
                  DataAutoDefine(UserData, 1, @nProgressInPerc, @bLastRecord, nRet, True,
                    FMasterLink.DataSource, LL_MASTER_MASTER);
                  {no skip here!}
                  bContinued := True; {no page break}
                end;

              mmAsVariables:
                begin
                  while LlPrintFieldsEnd = LL_WRN_REPEAT_DATA do
                  begin
                    if Assigned(FOnAutoDefineNewPage) then
                      OnAutoDefineNewPage(self, False);
                  end;
                  LlPrintResetProjectState;
                  DataAutoDefine(UserData, 1, @nProgressInPerc, @bLastRecord, nRet, False,
                    FMasterLink.DataSource, LL_MASTER_MASTER);
                  {no skip here, pagebreak OK!}
                end;
            end;
          end;

          nRet := LlPrintSetBoxText(Printer, nProgressInPerc);
          if nRet = LL_ERR_USER_ABORTED then
          begin
            LlPrintEnd(0);
            if btmpDelayTableHeader = False then
              LlSetOption(LL_OPTION_DELAYTABLEHEADER, 0);
            Result := nRet;
            exit;
          end;


          if bLastRecord <> 0 then
          begin
            bLastRecord := 0;
            bMasterDetailMode := False; {finished}
          end;
        end;

      until bMasterDetailMode = False;       {outer loop}

      if (AutoMasterMode <> mmAsVariables) or (Assigned(MasterSource) and (MasterSource.DataSet.EOF)) then
        while LlPrintFieldsEnd = LL_WRN_REPEAT_DATA do
        begin
          if Assigned(FOnAutoDefineNewPage) then OnAutoDefineNewPage(self, False);
        end;
    end;

    nRet := LlPrintEnd(0);

    (*reset old settings*)

    if btmpDelayTableHeader = False then
      LlSetOption(LL_OPTION_DELAYTABLEHEADER, 0);

    if bToPreview and (nRet = 0) then

    begin
      if (nOptions and LL_CMNDSETPRINT_PREVIEW_DONOTDELETEANDSHOW = 0) then
      begin
        (*display preview when in preview mode*)

        nRet := LlPreviewDisplay(ProjectName, TempPath,
          ParentHandle);
        if nRet = 0 then
          LlPreviewDeleteFiles(ProjectName, TempPath);
      end;
    end;
    Result := nRet;
  end;

procedure TDBL17_.Notification(AComponent: TComponent; Operation: TOperation);
  begin
    inherited Notification(AComponent, Operation);
    if (Operation = opRemove) and (FDataLink <> nil) and (AComponent = DataSource) then
    begin
      DataSource := nil;
      AutoDefine := No;
    end;

    if (Operation = opRemove) and (FMasterLink <> nil) and (AComponent = MasterSource) then
    begin
      MasterSource := nil;
    end;
  end;

procedure TDBL17_.SetAborted(const Value: boolean);
begin
  FAborted := Value;
end;

{$ifndef NOADVANCEDDATABINDING}

procedure TDBL17_.SetAdvancedDataBinding(nMode : TPropYesNo);
begin
    if nMode = Yes then bAdvancedDataBinding := True
    else
      bAdvancedDataBinding := False;
end;

function TDBL17_.GetAdvancedDataBinding: TPropYesNo;
begin
    if bAdvancedDataBinding then
      Result := Yes
    else
      Result := No;
end;
{$endif}
function TDBL17_.InterpretOnAutoDefineTableRelation(ChildTable, ParentTable, TableRelation, KeyField, ParentKeyField: TString
      ): TString;
var DefHandled: boolean;
  DisplayName: TString;
  i: integer;
begin
    DefHandled := false;
    if Assigned(FOnAutoDefineTableRelation) then
    begin
     OnAutoDefineTableRelation(self, true, TableRelation, DefHandled);
     if DefHandled then
      exit;
    end;
    for I := 0 to Dictionary.Relations.LCIDList.Count - 1 do
    begin
      Dictionary.Relations.GetValue(TableRelation, DisplayName, Dictionary.Fields.LCIDList[I]);
      LlLocAddDictionaryEntry(hLlJob, Dictionary.Relations.LCIDList[I],PTChar(TableRelation), PTChar(DisplayName), Cardinal(dtRelations))
    end;

     LlDbAddTableRelationEx(ChildTable, ParentTable,
                          ParentTable + '2' + ChildTable,
                          '',
                          KeyField,
                          ParentKeyField);
end;

procedure TDBL17_.InterpretOnAutoDefineTableSortOrder(const Table: TString;
      SortOrderName, SortOrderDisplayName: TString; DataType: integer);
var DefHandled: boolean;
    UpOrDown, DisplayName: TString;
    FieldName: TString;
  I: Integer;
begin
    DisplayName := SortOrderName;
    DefHandled := false;
    if Assigned(FOnAutoDefineTableSortOrder) then
    //Event AutoDefineTableSortOrder is assigned...
    begin
      OnAutoDefineTableSortOrder(self, true, Table, DisplayName, DefHandled);
      if DefHandled = False then
      begin
        case DataType of
          1 :  begin //TTable
                LlDbAddTableSortOrder(Table, SortOrderName, '');
                LlLocAddDictionaryEntry(hLlJob, 0, PTChar(SortOrderName), PTChar(DisplayName), Cardinal(dtSortOrders));
               end;
          2,3: begin //TADOTable, TADODataSet
                UpOrDown := copy(SortOrderDisplayName,pos('[',SortOrderDisplayName),3); //Cutting the order symbol
                FieldName := copy(SortOrderDisplayName,0,pos('[',SortOrderDisplayName)-2); //Cutting the name without the order symbol
                for I := 0 to Dictionary.Fields.LCIDList.Count - 1 do
                  begin
                    Dictionary.Fields.GetValue(FieldName, DisplayName, Dictionary.Fields.LCIDList[I]);
                    if UpOrDown='[+]' then
                      LlLocAddDictionaryEntry(hLlJob, Dictionary.Fields.LCIDList[I],PTChar(FieldName+' ASC'), PTChar(DisplayName+' [+]'), Cardinal(dtSortOrders))
                    else
                      LlLocAddDictionaryEntry(hLlJob, Dictionary.Fields.LCIDList[I],PTChar(FieldName+' DESC'), PTChar(DisplayName+' [-]'), Cardinal(dtSortOrders))
                  end;
                LlDbAddTableSortOrder(Table, SortOrderName, SortOrderDisplayName);
               end;
        end;
        end else
        //Name is manipulated in the event
          LlDbAddTableSortOrder(Table, SortOrderName, SortOrderDisplayName);
      end
    else
    begin
    //Event AutoDefineTableSortOrder is not assigned...
      case DataType of
        1 :  begin //TTable
              LlDbAddTableSortOrder(Table, SortOrderName, '');
             end;
        2,3: begin //TADOTable, TADODataSet
              UpOrDown := copy(SortOrderDisplayName,pos('[',SortOrderDisplayName),3); //Cutting the order symbol
              FieldName := copy(SortORderDisplayName,0,pos('[',SortORderDisplayName)-2); //Cutting the name without the order symbol

              for I := 0 to Dictionary.Fields.LCIDList.Count - 1 do
                begin
                  Dictionary.Fields.GetValue(FieldName, DisplayName, Dictionary.Fields.LCIDList[I]);
                  if UpOrDown='[+]' then
                    LlLocAddDictionaryEntry(hLlJob, Dictionary.Fields.LCIDList[I],PTChar(FieldName+' ASC'), PTChar(DisplayName+' [+]'), Cardinal(dtSortOrders))
                  else
                    LlLocAddDictionaryEntry(hLlJob, Dictionary.Fields.LCIDList[I],PTChar(FieldName+' DESC'), PTChar(DisplayName+' [-]'), Cardinal(dtSortOrders))
                end;
            LlDbAddTableSortOrder(Table, SortOrderName,SortOrderDisplayName);
           end;
      end;
    end;
end;

procedure TDBL17_.OnAutoDrillDownJob(Sender: TObject; Task: cardinal; UserParam: integer; ParentTableName: TString; RelationName: TString;
  ChildTableName: TString; ParentKey: TString; ChildKey: TString; KeyValue: TString; ProjectFileName: TString;
  PreviewFileName: TString; TooltipText: TString; TabText: TString; WindowHandle: cmbtHWND; JobID: longint; AttachInfo: THandle; var returnValue: integer);

begin
   case Task of
      LL_DRILLDOWN_START:

        begin
          LlDebugOutput(1, '>LL_DRILLDOWN_START');
          DrillDownActive:=true;
          with FCritDrillDown do
          try
            Acquire;
            Inc(FDrillDownJobId);
            // might be assigned from previous print
            FDrillDownThread := TDrillDownWorker.Create(true);
			FDrillDownThread.PrintInstance := FLlForDrilldown;
			FDrillDownThread.FreeOnTerminate := true;
			FDrillDownThread.UserParam:= UserParam;
			FDrillDownThread.ParentTableName:= ParentTableName;
			FDrillDownThread.RelationName:=RelationName;
			FDrillDownThread.ChildTableName:=ChildTableName;
			FDrillDownThread.ParentKey:=ParentKey;
			FDrillDownThread.ChildKey:=ChildKey;
			FDrillDownThread.KeyValue:=KeyValue;
			FDrillDownThread.ProjectFileName:=ProjectFileName;
			FDrillDownThread.PreviewFileName:=PreviewFileName;
			FDrillDownThread.TooltipText:=TooltipText;
			FDrillDownThread.TabText:=TabText;
			FDrillDownThread.WindowHandle:=WindowHandle;
			FDrillDownThread.JobID:=JobID;
			FDrillDownThread.AttachInfo:=AttachInfo;
            {$ifdef USETHREADRESUME}
				FDrillDownThread.Resume();
			{$else}
				FDrillDownThread.Start();
			{$endif}
            returnValue:=FDrillDownJobId;
          finally
            Release;
            LlDebugOutput(-1, '<LL_DRILLDOWN_START');
          end;
        end;
      LL_DRILLDOWN_FINALIZE:
        begin
          LlDebugOutput(1, '>LL_DRILLDOWN_FINALIZE');
          with FCritDrillDown do
          try
            Acquire;
            if Assigned(FDrillDownThread) then
            begin
              if not FDrillDownThread.Terminated then
              begin
                FDrillDownThread.FinalizePrinting;
                //FDrillDownThread.WaitFor;
              end;
            end;
          finally
            Release;
          LlDebugOutput(-1, '<LL_DRILLDOWN_FINALAZE');
          end;
        end;
   end;
end;


procedure TDBL17_.OnAutoDesignerPrintJob(Sender: TObject; UserParam: Integer;
  ProjectFileName, OriginalFileName: TString; Pages, Task: Cardinal;
  hWndPreviewControl: cmbtHWND; Event: THandle; var returnValue: Integer);
begin
  case Task of
    LL_DESIGNERPRINTCALLBACK_PREVIEW_START,
    LL_DESIGNERPRINTCALLBACK_EXPORT_START:
    begin
      with FCritDesignerPrint do
      try
        Acquire;
        // might be assigned from previous print
        if Assigned(FWorkerThread) then
        begin
          FWorkerThread.Free;
        end;
        FWorkerThread := TPrintWorker.Create(true);
        with FWorkerThread do
        begin
          printInstance := FLLForDesignerPrint;
          FreeOnTerminate := false;

            // D: Setzen der Event Parameter:
            // US: Set event parameter:
            projectFile := ProjectFileName;
            originalProjectFile := OriginalFileName;
            controlHandle := hWndPreviewControl;
            eventHandle := Event;

            // D:  Im Export Fall die doExport Variable auf true setzen:
            // US: Set the doExport variable true for the export:
            if Task = LL_DESIGNERPRINTCALLBACK_EXPORT_START then
                doExport := true
            else
                doExport := false;

            // D:  Maximale Seitenanzahl für den Preview / Druck:
            // US: page count for the real data preview / print:
            pageCount := Pages;
            {$ifdef USETHREADRESUME}
				FWorkerThread.Resume();
            {$else}
				FWorkerThread.Start();
            {$endif}
        end;
      finally
        Release;
      end;
      exit;
    end;
    LL_DESIGNERPRINTCALLBACK_PREVIEW_ABORT,
    LL_DESIGNERPRINTCALLBACK_EXPORT_ABORT:
    begin
          with FCritDesignerPrint do
          try
            Acquire;
            if Assigned(FWorkerThread) and not FWorkerThread.Terminated then
              FWorkerThread.Abort();
          finally
            Release;
          end;
          exit;
    end;
    LL_DESIGNERPRINTCALLBACK_PREVIEW_FINALIZE,
    LL_DESIGNERPRINTCALLBACK_EXPORT_FINALIZE:
    begin
          with FCritDesignerPrint do
          try
            Acquire;
            if Assigned(FWorkerThread) then
            begin
              if not FWorkerThread.Terminated then
              begin
                FWorkerThread.FinalizePrinting();
                FWorkerThread.WaitFor;
              end;
              FWorkerThread.Free;
              FWorkerThread:=nil;
            end;
          finally
            Release;
          end;
          exit;
    end;
    LL_DESIGNERPRINTCALLBACK_PREVIEW_QUEST_JOBSTATE,
    LL_DESIGNERPRINTCALLBACK_EXPORT_QUEST_JOBSTATE:
    begin
        with FCritDesignerPrint do
        try
          Acquire;
          if not Assigned(FWorkerThread) then
            returnValue := 0;

         if Assigned(FWorkerThread) then
         begin
           if (FWorkerThread.Terminated) then
            returnValue := 0
           else
            returnValue := 2;
         end;
        finally
          Release;
        end;
        exit;        
    end;
  end;
end;

procedure TDBL17_.InterpretOnAutoDefineTable(Table: TComponent);
var DefHandled: boolean;
    TableName: TString;
begin
    DefHandled := false;

    {$ifdef BDEAVAILABLE}
    if Table is TTable then
      if pos('.',(TTable(Table).TableName)) > 0 then
        TableName := ExtractTableName(TTable(Table).TableName)
      else
        TableName := TTable(Table).TableName
     else
     {$endif}

     {$ifdef ADOAVAILABLE}
      if Table is TADOTable then
       TableName := TADOTable(Table).TableName
     {$endif}
     else
      if Table is TDataSet then
       TableName := TDataSet(Table).Name;
    if Assigned(FOnAutoDefineTable) then
    begin
      OnAutoDefineTable(self, true, TableName, DefHandled);
    end;
end;

{$ifndef NOADVANCEDDATABINDING}
procedure TDBL17_.PassDataStructure(AutoMasterMode: TAutoMasterMode; Source: TDataSource);
var
 i, j: Integer;
 FIndex: TStringList;
 fDetailField, fMasterField, fMasterTable, fDataTyp: TString;
begin
  LlDbAddTable('','');
  LlDbAddTable('LLStaticTable','');
  FIndex := TStringList.Create;
  try
    if AutoMasterMode = mmNone then
    begin

      {$ifdef BDEAVAILABLE}
      if Source.DataSet is TTable then
      begin
        with Source.DataSet as TTable do
        begin
          InterpretOnAutoDefineTable(Source.DataSet);
          LlDbAddTableEx(TableName, '', LL_ADDTABLEOPT_SUPPORTSSTACKEDSORTORDERS);
          DefineCurrentRecord('',Source.DataSet as TTable, true, itTTable);

          GetIndexNames(FIndex);
          for j := 0 to FIndex.Count - 1 do
           InterpretOnAutoDefineTableSortOrder(TableName, FIndex.Strings[j], FIndex.Strings[j],1);

        end;
      end
      else
      {$endif}

      {$ifdef ADOAVAILABLE}
        if Source.DataSet is TADOTable then
        begin
          with Source.DataSet as TADOTable do
          begin
            InterpretOnAutoDefineTable(Source.DataSet);
            LlDbAddTableEx(TableName, '', LL_ADDTABLEOPT_SUPPORTSSTACKEDSORTORDERS);
            DefineCurrentRecord('',Source.DataSet as TADOTable, true, itTADOTable);
            for j := 0 to FieldCount-1 do
            begin
              InterpretOnAutoDefineTableSortOrder(TableName, Fields[j].FieldName + ' ASC', Fields[j].FieldName + ' [+]',2);
              InterpretOnAutoDefineTableSortOrder(TableName, Fields[j].FieldName + ' DESC', Fields[j].FieldName + ' [-]',2);
            end;
          end;
        end //end of TADOTable
        else
          if (Source.DataSet is TADODataSet) then
          begin
            with Source.DataSet as TADODataSet do
            begin
              InterpretOnAutoDefineTable(Source.DataSet);
              LlDbAddTableEx(Name, '', LL_ADDTABLEOPT_SUPPORTSSTACKEDSORTORDERS);
              DefineCurrentRecord('',Source.DataSet as TADODataSet, true, itTDataSetDescendand);
              for j:= 0 to FieldCount-1 do
              begin
                InterpretOnAutoDefineTableSortOrder(Name, Fields[j].FieldName + ' ASC', Fields[j].FieldName + ' [+]',3);
                InterpretOnAutoDefineTableSortOrder(Name, Fields[j].FieldName + ' DESC', Fields[j].FieldName + ' [-]',3);
              end;
            end;
          end //end of TADODataSet
          else
      {$endif}
       if Source.DataSet is TDataSet then
      begin
        with Source.DataSet as TDataSet do
        begin
          InterpretOnAutoDefineTable(Source.DataSet);
          LlDbAddTableEx(Source.DataSet.Name, '', LL_ADDTABLEOPT_SUPPORTSSTACKEDSORTORDERS);
          DefineCurrentRecord('',Source.DataSet as TDataSet, true, itTDataSetDescendand);
        end;
      end;
    end else  //end of mmNone
    begin

        for i := 0 to FTableMap.FKeyList.Count - 1 do
        begin
          FTableMap.GetValue(FTableMap.FKeyList.Strings[i], FTable, fMasterField, fDetailField, fMasterTable, fDataTyp);

        {D:  Zuerst eine Tabelle anmelden...}
        {US: At first declare a table...}
          LlDbAddTableEx(FTableMap.FKeyList.Strings[i], '', LL_ADDTABLEOPT_SUPPORTSSTACKEDSORTORDERS);

          if fDataTyp = 'LL_TTABLE' then
            DefineCurrentRecord('', FTable, true, itTTable);
          if fDataTyp = 'LL_TADOTABLE' then
            DefineCurrentRecord('', FTable, true, itTADOTable);
          if ( (fDataTyp = 'LL_TDATASET') or (fDataTyp = 'LL_TADODATASET') ) then
            DefineCurrentRecord('', FTable, true, itTDataSetDescendand);

          {D:  ...dann die Relationen zwischen den Tabellen...}
          {US: ... then the relation between the tables...}
          if fMasterTable <> '' then
            InterpretOnAutoDefineTableRelation(FTableMap.FKeyList.Strings[i], fMasterTable, FTableMap.FKeyList.Strings[i] + '2' + fMasterTable, '', fMasterTable+'.'+FTableMap.FMasterFieldList.Strings[i]);
            {D:  ...und zum Schluss die Sortierung}
            {US: ...and at the end the sorting}

           {$ifdef BDEAVAILABLE}
          if fDataTyp = 'LL_TTABLE' then
          begin
            (FTable As TTable).GetIndexNames(FIndex);
//            for j := 0 to Findex.Count - 1 do
//              InterpretOnAutoDefineTableSortOrder(FTableMap.FKeyList.Strings[i], FIndex.Strings[j], FIndex.Strings[j],1);
            for j := 0 to FTable.FieldCount - 1 do
              InterpretOnAutoDefineTableSortOrder(FTableMap.FKeyList.Strings[i], FTable.Fields[j].FieldName, FTable.Fields[j].FieldName, 1);
            end;
          {$endif}

          {$ifdef ADOAVAILABLE}
          if (fDataTyp = 'LL_TADOTABLE') or (fDataTyp = 'LL_TADODATASET') then
          begin
            if not assigned(FTable) then
              FTableMap.GetValue(FTableMap.FKeyList.Strings[i], FTable, fMasterField, fDetailField, fMasterTable, fDataTyp);
            for j := 0 to FTable.FieldCount-1 do
            begin
              InterpretOnAutoDefineTableSortOrder(FTableMap.FKeyList.Strings[i], FTable.Fields[j].FieldName + ' ASC', FTable.Fields[j].FieldName + ' [+]',3);
              InterpretOnAutoDefineTableSortOrder(FTableMap.FKeyList.Strings[i], FTable.Fields[j].FieldName + ' DESC', FTable.Fields[j].FieldName + ' [-]',3);
            end;
          end;
          {$endif}

        end; //end of KeyList.Count
    end; // end of AutoMasterMode

  finally
    FIndex.Free;
  end;
end;

procedure TDBL17_.DefineCurrentRecord(Prefix: string; Table: TDataSet; AsField: boolean; DataSetType: TDataItemType);
var i : integer;
    nTableName, ParentPrefix, MasterField, DetailField, MasterTable: TString;
    sFieldName, sFieldContent: TString;
    aFieldType: integer;
    DefHandle: boolean;
    fDataTyp: TString;
begin

   case DataSetType of
         itTTable :

           begin
           {$ifdef BDEAVAILABLE}
               if pos('.',(TTable(Table).TableName)) > 0 then
                 nTableName := ExtractTableName(TTable(Table).TableName)
               else
                 nTableName := TTable(Table).TableName;
                 {$endif}
           end;


         {$ifdef ADOAVAILABLE}
         itTADOTable : nTableName := TADOTable(Table).TableName;
         {$endif}

         itTDataSetDescendand : nTableName := TDataSet(Table).Name;
   end;

       DefHandle := False;

       for i:= 0 to (Table.FieldCount - 1) do
       begin
          {D:  Für den Designer werden alle Felder übergeben}
          {US: For the Designer will all fields transfered}
          if not bIsPrinting then
          begin

            if Assigned(FOnAutoDefineField) then
            begin
             ConvertTField(Table.Fields[i],sFieldName, sFieldContent, aFieldType);
             if ( (Prefix <> '') and (pos('@',Table.Fields[i].FieldName) <= 0) ) then
              sFieldName := Prefix + sFieldName
             else
              sFieldName := nTableName + '.' + sFieldName;
             OnAutoDefineField(self, true,sFieldName, sFieldContent, aFieldType, DefHandle);
            end;

             if not DefHandle then
             begin
              {D:  Felder, die über einen JOIN in der TTable-Komponente verbunden sind  }
              {US: Fields, which are joined by the ttable component}
              if ( (Prefix <> '') and (pos('@',Table.Fields[i].FieldName) <= 0) ) then
              begin
                {D:  Umsetzung der Datenbank-Feldtypen in List & Label Feldtypen }
                {US: Transform database field types into List & Label field types}
                if AsField then
                begin
                      if Assigned(FOnAutoDefineField) then
                           LlDefineFieldExt(sFieldName, sFieldContent, aFieldType)
                      else
                           LlDefineFieldFromTFieldExt(Prefix+Table.Fields[i].FieldName, Table.Fields[i]);
                end else
                begin
                      if Assigned(FOnAutoDefineField) then
                         LlDefineVariableExt(sFieldName, sFieldContent, aFieldType)
                      else

                end;
              end else
              begin
                if AsField then
                begin
                      if Assigned(FOnAutoDefineField) then
                        LlDefineFieldExt(sFieldName, sFieldContent, aFieldType)
                      else
                        LlDefineFieldFromTFieldExt(nTableName, Table.Fields[i]);
                end else
                begin
                      if Assigned(FOnAutoDefineField) then
                        LlDefineVariableExt(sFieldName, sFieldContent, aFieldType)
                      else
                        LlDefineVariableFromTFieldExt(nTableName, Table.Fields[i]);
                end;
              end;
             end;

          end
          else
          begin

            if Assigned(FOnAutoDefineField) then
            begin
             ConvertTField(Table.Fields[i],sFieldName, sFieldContent, aFieldType);
             if ( (Prefix <> '') and (pos('@',Table.Fields[i].FieldName) <= 0) ) then
              sFieldName := Prefix + sFieldName
             else
              sFieldName := nTableName + '.' + sFieldName;
             OnAutoDefineField(self, false, sFieldName, sFieldContent, aFieldType, DefHandle);
            end;

             if not DefHandle then
             begin
                {D:  Zur Druckzeit werden nur die benötigten Felder und Variablen übergeben}
                {US: For print time only the needed fields and variables will be transfered}
                {D:  Umsetzung der Datenbank-Feldtypen in List & Label Feldtypen }
                {US: Transform database field types into List & Label field types}

                if ( (Prefix <> '') and (pos('@',Table.Fields[i].FieldName) <= 0) ) then
                begin
                  if AsField then
                  begin
                      if Assigned(FOnAutoDefineField) then
                       LlDefineFieldExt(sFieldName, sFieldContent, aFieldType)
                      else
                       LlDefineFieldFromTFieldExt(Prefix+Table.Fields[i].FieldName, Table.Fields[i]);
                  end else
                  begin
                      if Assigned(FOnAutoDefineField) then
                       LlDefineVariableExt(sFieldName, sFieldContent, aFieldType)
                      else
                       LlDefineVariableFromTFieldExt(Prefix+nTableName, Table.FieldList[i]);
                  end;
                end else
                begin
                  if AsField  then
                  begin
                      if Assigned(FOnAutoDefineField) then
                       LlDefineFieldExt(sFieldName, sFieldContent, aFieldType)
                      else
                       LlDefineFieldFromTFieldExt(nTableName,Table.Fields[i] );
                  end else
                  begin
                      if Assigned(FOnAutoDefineField) then
                       LlDefineVariableExt(sFieldName, sFieldContent, aFieldType)
                      else
                       LlDefineVariableFromTFieldExt(nTableName, Table.Fields[i]);
                  end;
                end;
             end;
          end;
       end;



   {D:  Übergabe aller Felder als 1:1-Relation}
   {US: Delivery all fields as 1:1-Relation}
   case DataSetType of

        {$ifdef BDEAVAILABLE}
         itTTable : begin
               if TTable(Table).MasterSource <> nil then
               begin
                  FTableMap.GetValue(nTableName, FTable, MasterField, DetailField, MasterTable, fDataTyp);
                  ParentPrefix:=Prefix+nTableName+'.'+MasterField+'@'+TTable(TTable(Table).MasterSource.DataSet).TableName+'.'+DetailField+':';

                  DefineCurrentRecord(ParentPrefix, TTable(Table).MasterSource.DataSet, true, itTTable);
               end;
             end;
         {$endif}

         {$ifdef ADOAVAILABLE}
         itTADOTable : begin
               if TADOTable(Table).MasterSource <> nil then
               begin
                  FTableMap.GetValue(nTableName, FTable, MasterField, DetailField, MasterTable, fDataTyp);
//                  ParentPrefix:=Prefix+nTableName+'.'+MasterField+'@'+TADOTable(TADOTable(Table).MasterSource.DataSet).TableName+'.'+DetailField+':';
                  ParentPrefix:=Prefix+nTableName+'.'+MasterField+'@'+MasterTable+'.'+MasterField+':';

                  DefineCurrentRecord(ParentPrefix, TADOTable(Table).MasterSource.DataSet, true, itTADOTable);
               end;
             end;
         {$endif}

         itTDataSetDescendand : begin
               if TDataSet(Table).DataSource <> nil then
               begin
                  FTableMap.GetValue(nTableName, FTable, MasterField, DetailField, MasterTable, fDataTyp);
                  if (MasterField = '') and (DetailField = '') then
                   ParentPrefix:=Prefix+nTableName+':'+MasterTable+'.'
                  else
                   ParentPrefix:=Prefix+nTableName+'.'+MasterField+'@'+MasterTable+'.'+DetailField+':';

                   DefineCurrentRecord(ParentPrefix, TDataSet(Table).DataSource.DataSet, true, itTDataSetDescendand);
               end;
             end;
   end;

end;

function TDBL17_.PrintDataView(Table: TDataSet; Level, CurrentTableNo: integer):integer;
var
 i: integer;
 nRet: integer;
 tableName, sortOrder: TString;
 Printer, Port: TString;
 masterField, detailField, masterTable: TString;
 percentage, maxPercentage: currency;
 nMasterRec: integer;
 Dummy: string;
 dataType: TString;
 printPages: integer;
begin

    LlPrintDbGetCurrentTable(tableName, false);
    if (tableName = 'LLStaticTable') then
    begin
      nRet := LlPrintFields();
      while nRet = LL_WRN_REPEAT_DATA do
      begin
        LlPrint();
        nRet := LlPrintFields();
        while nRet = LL_WRN_REPEAT_DATA do
          nRet := LlPrintFieldsEnd;
      end;
     end else
     begin
       nMasterRec := 0;

       if AutoMasterMode = mmAsVariables then
        maxPercentage := 100/FDataLink.DataSet.RecordCount
       else
        maxPercentage := 100/LlPrintDbGetRootTableCount();

       {D:  Sortierung der aktuellen Tabelle bestimmen
       US: Determine the sort order of the current table}
       LlPrintDbGetCurrentTableSortOrder(sortOrder);

       if sortOrder <> '' then
       begin
         sortOrder:=StringReplace(sortOrder, chr(9), ';', [rfReplaceAll]);

         {$ifdef BDEAVAILABLE}
         if Table is TTable then
         begin
          if Level <> 0 then
            sortOrder := TTable(Table).MasterFields + ';' + sortOrder;
          TTable(Table).IndexFieldNames := sortOrder;
         end;
         {$endif}

        {$ifdef ADOAVAILABLE}
          if Level <> 0 then
            sortOrder := TADOTable(Table).MasterFields + ';' + sortOrder;
         if Table is TADOTable then
           TADOTable(Table).IndexFieldNames := sortOrder
         else
           if Table is TADODataSet then
             TADODataSet(Table).IndexFieldNames := sortOrder;
        {$endif}
       end;

       {D:  Seitenumbruch auslösen, bis Datensatz vollständig gedruckt wurde
       US: Wrap pages until record was fully printed}
       Table.First;
       i := 0;
       printPages := 1;
       while (not Table.Eof) and (LlPrintGetOption(LL_PRNOPT_PAGEINDEX) < LlPrintGetOption(LL_PRNOPT_LASTPAGE)) do
       begin

        {Damit LL.MasterRecNo richtig gezählt wird}
        if Level = 0 then
        begin
         inc(nMasterRec);
         Dummy:=IntToStr(nMasterRec);
         LlDefineFieldExt('LL.MasterRecNo', Dummy, LL_NUMERIC);
        end;

        {$ifdef BDEAVAILABLE}
        if Table is TTable then
         DefineCurrentRecord('', Table, true,itTTable)
        else
        {$endif}

          {$ifdef ADOAVAILABLE}
          if Table is TADOTable then
           DefineCurrentRecord('',Table, true, itTADOTable)
          else
         {$endif}
         if Table is TDataSet then
          DefineCurrentRecord('', Table, true,itTDataSetDescendand);

        if Assigned(FOnAutoDefineNewLine) then
          OnAutoDefineNewLine(self, false);

        nRet := LlPrintFields();
        {D:  Seitenumbruch auslösen, bis Datensatz vollständig gedruckt wurde
        US: Wrap pages until record was fully printed}
        while nRet = LL_WRN_REPEAT_DATA do
        begin

          if ( bAutoDesignerPreview and Assigned(FWorkerThread) )then
          begin

              if (printPages < FWorkerThread.pageCount) or (FWorkerThread.pageCount = 0) then
              begin

                LlPrint();
                nRet := LlPrintFields();
                if ( (AutoMasterMode = mmNone) or (AutoMasterMode = mmAsFields) ) then
                begin
                   if Assigned(FOnAutoDefineNewPage) then
                    OnAutoDefineNewPage(self, False);
                end;

                inc(printPages);
              end else
              begin
                {D:  Druck beenden}
                {US: Stop printing}
                LlPrintEnd(0);
                Result := nRet;
                exit;
              end;

          end else
          begin
                LlPrint();
                nRet := LlPrintFields();
                if ( (AutoMasterMode = mmNone) or (AutoMasterMode = mmAsFields) ) then
                begin
                   if Assigned(FOnAutoDefineNewPage) then
                    OnAutoDefineNewPage(self, False);
                end;
          end;


        end;

        {D:  Tabellenwechsel und Rekursion beginnen
        US: Change of table begin recursion}
        while nRet = LL_WRN_TABLECHANGE do
        begin
          LlPrintDbGetCurrentTable(tableName, false);
          FTableMap.GetValue(tableName, FTable, masterField, detailField, masterTable, dataType);
          nRet := PrintDataView(FTable, Level + 1, 0);
        end;

        if nRet = LL_ERR_USER_ABORTED then
        begin
          LlPrintEnd(0);
          Result := nRet;
          exit;
        end;

		LlPrintGetPrinterInfo(Printer, Port);

        {D: Aktualisierung der Fortschrittsanzeige wenn Root-Datensatz gedruckt wird
        US: If a root record is printed update the progress bar }
        if Level = 0 then
        begin
         percentage := maxPercentage*(CurrentTableNo-1) + i/Table.RecordCount*maxPercentage;
         LlPrintSetBoxText(Printer,round(percentage));
         if Assigned(FOnAutoNotifyProgress) then
           OnAutoNotifyProgress(self, Printer, Ceil(percentage));
         if AutoMasterMode = mmAsVariables then
         begin
          percentage := maxPercentage*(CurrentTableNo-1) + i/Table.RecordCount*maxPercentage;
          LlPrintSetBoxText(Printer,round(percentage));
          if Assigned(FOnAutoNotifyProgress) then
            OnAutoNotifyProgress(self, Printer, Ceil(percentage));
         end;
        end;

        i := i + 1;
        Table.Next
       end;
     end;

      nRet := LlPrintFieldsEnd();
      {D:  Seitenumbruch auslösen, bis Datensatz vollständig gedruckt wurde
      US: Wrap pages until record was fully printed}
      while nRet = LL_WRN_REPEAT_DATA do
        nRet := LlPrintFieldsEnd();

      if tableName <> 'LLStaticTable' then
      begin
        {$ifdef ADOAVAILABLE}
         if Table is TADOTable then
          TADOTable(Table).IndexFieldNames := TADOTable(Table).MasterFields
         else
          if Table is TADODataSet then
           TADODataSet(Table).IndexFieldNames := TADODataSet(Table).MasterFields
         else
        {$endif}

        {$ifdef BDEAVAILABLE}
         if Table is TTable then
           TTable(Table).IndexFieldNames := TTable(Table).MasterFields
         else
         {$endif}
           if Table is TDataSet then
             TDataSet(Table).UpdateCursorPos;
      end;
      Result := nRet;
end;

function TDBL17_.AdvancedDataBindingPrint(UserData: integer; ProjectType: integer; ProjectName: TString;
      ShowFileSelect: boolean; PrintOptions: integer; BoxType: integer;
      ParentHandle: cmbtHWND;
      Title: TString; ShowPrintOptions: boolean; TempPath: TString): integer;
  var
    nRet: integer;
    nProgressInPerc: integer;
    bLastRecord: integer;
    sPath: TString;
    sDir: TString;
    sPort: TString;
    sPrinter: TString;
    sPreviewFile: TString;
    nCopies: integer;
    btmpDelayTableHeader: boolean;
    bToPreview: boolean;
    nOptions: integer;
    Printer, Port: TString;
    nMasterRecNo: integer;
    Dummy: TString;

    TableName: TString;
    FMasterField, FDetailField, FMasterTable: TString;
    nTableIndex: integer;

    fDataTyp: TString;
    begin
    nRet := 0;
    nProgressInPerc := 0;
    bLastRecord := 0;
    nMasterRecNo := 1;
    sPath := '';
    sDir := '';
    sPort := '';
    sPrinter := '';
    nCopies := 1;
    btmpDelayTableHeader := bDelayTableHeader;
    nOptions := 0;
    nTableIndex := 0;

    if (ShowFileSelect) then
    begin
      nRet := LlSelectFileDlgTitle(ParentHandle, '',
        ProjectType and $7FFF, ProjectName);
      if (nRet <> 0) then
      begin
        Result := nRet;
        exit;
      end;
    end;
    ProjectType := ProjectType and $7FFF;
    (*define all variables*)
    LlDefineVariableStart;
    LlDefineChartFieldStart;

    if (AutoDefine = No) then
      DefineVariablesCallback(UserData, 1, @nProgressInPerc, @bLastRecord, nRet)
    else
    begin

      if (FDataLink.Active and not DrilldownActive) then
        DataSource.DataSet.First;

      if (ProjectType <> LL_PROJECT_LIST) then
        DataAutoDefine(1,1, @nProgressInPerc, @bLastRecord, nRet,
          False, FDataLink.DataSource, LL_MASTER_NONE);
      if Assigned(FOnAutoDefineNewPage) then
       OnAutoDefineNewPage(self, True);
    end;

    (*define all fields if list project*)

    if (ProjectType = LL_PROJECT_LIST) then
    begin
      LlDefineFieldStart;
      if (AutoDefine = No) then
        DefineFieldsCallback(UserData, 1, @nProgressInPerc, @bLastRecord, nRet)
      else
      begin

        FillTableMapper();

        if Assigned(FOnAutoDefineNewLine) then
          OnAutoDefineNewLine(self, True);

        if (FDataLink.Active and not DrilldownActive) then
          DataSource.DataSet.First;
        if FMasterLink.Active and (AutoMasterMode <> mmNone) then
          MasterSource.DataSet.First;
        if AutoMasterMode <> mmNone then
        begin
          if AutoMasterMode = mmAsVariables then
            LlDefineVariableExt('LL.MasterRecNo', '1', LL_NUMERIC)
          else
            LlDefineFieldExt('LL.MasterRecNo', '1', LL_NUMERIC)
        end;

        PassDataStructure(AutoMasterMode, FDataLink.DataSource);

        case AutoMasterMode of
          mmAsVariables: AdvancedDataBindingDataAutoDefine(1,1, @nProgressInPerc, @bLastRecord, nRet,
                            False, FDataLink.DataSource, LL_MASTER_MASTER, false);
        end;

        FRecNo := 0;
      end;
      // cancel has meanwhile been signalled (e.g. designer preview was closed)
      if Aborted then
      begin
        Result:=LL_ERR_USER_ABORTED;
        exit;
      end;
    end; // end of ProjectType = LL_PROJECT_LIST

    (*initialize printing*)
    if not Assigned(FWorkerThread) then
      nRet := LlPrintWithBoxStart(ProjectType, ProjectName, PrintOptions, BoxType, ParentHandle, Title);

    if Assigned(FWorkerThread) then
    begin
      if FWorkerThread.Terminated then
      begin
        nRet := LlPrintWithBoxStart(ProjectType, ProjectName, PrintOptions, BoxType, ParentHandle, Title);
      end else if FWorkerThread.doExport then
      begin
        LlPrintWithBoxStart(ProjectType, FWorkerThread.projectFile, LL_PRINT_EXPORT, LL_BOXTYPE_STDABORT, ParentHandle, Title);
        nRet := LlPrintOptionsDialog(FWorkerThread.controlHandle, '');
      end else
        nRet := LlPrintWithBoxStart(ProjectType, FWorkerThread.projectFile, PrintOptions, BoxType, ParentHandle, Title)
    end;

    if nRet < 0 then
    begin
      Result := nRet;
      exit;
    end;

    (*show print options dialog?*)
    if Assigned(FOnSetPrintOptionsEvent) then
      FOnSetPrintOptionsEvent(self, nOptions);

    if MaxPage>0 then
    begin
    	LlPrintSetOption(LL_OPTION_LASTPAGE, MaxPage);
    end;

    if ShowPrintOptions then
    begin
      LlPrintSetOption(LL_PRNOPT_PRINTDLG_ONLYPRINTERCOPIES, 1);
      LlPrintSetOption(LL_OPTION_PAGE, LL_PAGE_HIDE);

      nRet := LlPrintOptionsDialog(ParentHandle, Title);

      if nRet < 0 then
      begin
        LlPrintEnd(0);
        Result := nRet;
        exit;
      end;
      LlPrintSetOption(LL_OPTION_PAGE, 1);
    end;

    LlPrintGetPrinterInfo(Printer, Port);


    (*Destination may have changed*)
    if LlPrintGetOption(LL_PRNOPT_PRINTDLG_DEST) = LL_DESTINATION_PRV then
      bToPreview := True
    else
      bToPreview := False;

    (*set preview file path and name*)
    if bToPreview = True then
    begin
      sPreviewFile := TempPath + ExtractFileName(ProjectName);
      LlPreviewSetTempPath(TempPath);
    end;

     (*For Lists copies have to be made by the driver. This has to be set
       however...*)
      if LlPrintGetOption(LL_PRNOPT_COPIES_SUPPORTED) = 0 then
        (*The input number of copies is not supported -> reset to 1*)
        LlPrintSetOption(LL_PRNOPT_COPIES, nCopies);


     (*----------------------
        main printing routine
       ----------------------
       for lists*)


    if (ProjectType = LL_PROJECT_LIST) then (*print lists*)
    begin
      (*set List & Label Options*)
      LlSetOption(LL_OPTION_DELAYTABLEHEADER, 1);

      case AutoMasterMode of
           mmAsVariables : begin
                            repeat
                               Dummy:=IntToStr(nMasterRecNo);
                               LlDefineVariableExt('LL.MasterRecNo', Dummy, LL_NUMERIC);
                               AdvancedDataBindingDataAutoDefine(1,0, @nProgressInPerc, @bLastRecord, nRet, False, FDataLink.DataSource, LL_MASTER_MASTER, false);

                               if Assigned(FOnAutoDefineNewPage) then
                                 OnAutoDefineNewPage(self, False);
                               while (LlPrint=LL_WRN_REPEAT_DATA) do;
                                 inc(nMasterRecNo);

                               bIsPrinting := True;
                               bLastRecord := 0;

                               if (LlPrintDbGetRootTableCount<>0)
                             	 then
                                  repeat
                                    LlPrintDbGetCurrentTable(TableName, false);

                                    // may happen if there are more tables, but no matching appearance conditions
                                    if (TableName='') then
                                      break;

                                    FTableMap.GetValue(TableName, FTable, FMasterField, FDetailField, FMasterTable, fDataTyp);
                                    Inc(nTableIndex)
                                  until (PrintDataView(FTable, 0, nTableIndex) <> LL_WRN_TABLECHANGE);

                               if (AutoMasterMode <> mmAsVariables) or (DataSource.DataSet.EOF) then
                                  while LlPrintFieldsEnd = LL_WRN_REPEAT_DATA do
                                  begin
                                    if Assigned(FOnAutoDefineNewPage) then
                                     OnAutoDefineNewPage(self, False);
                                  end;

                                  FDataLink.DataSource.DataSet.Next;
                                  nRet:=LlPrintResetProjectState();
                                  if nRet < 0 then
                                  begin
                                    LlPrintEnd(0);
                                    Result := nRet;
                                    exit;
                                  end;
                            until (FDataLink.DataSource.DataSet.EOF or (LlPrintGetOption(LL_PRNOPT_PAGEINDEX) >= LlPrintGetOption(LL_PRNOPT_LASTPAGE)));

                            if not FDataLink.DataSource.DataSet.EOF then
                            begin
                              LlPrintAbort;
                            end;

                            bIsPrinting := False;
                           end;
           mmAsFields,
           mmNone:      begin
                          if Assigned(FOnAutoDefineNewPage) then
                            OnAutoDefineNewPage(self, False);
                          while (LlPrint=LL_WRN_REPEAT_DATA) do;
                            LlDefineFieldStart; {free the detail data}

                          bIsPrinting := True;
                          bLastRecord := 0;

                          if (LlPrintDbGetRootTableCount<>0)
               		        then
                            repeat
                              LlPrintDbGetCurrentTable(TableName, false);
							  if (TableName='') then
                               			 break;
                              FTableMap.GetValue(TableName, FTable, FMasterField, FDetailField, FMasterTable, fDataTyp);
                              Inc(nTableIndex);
                            until (PrintDataView(FTable, 0, nTableIndex) <> LL_WRN_TABLECHANGE);

                          if DataSource.DataSet.EOF then
                            while LlPrintFieldsEnd = LL_WRN_REPEAT_DATA do
                            begin
                              if Assigned(FOnAutoDefineNewPage) then
                               OnAutoDefineNewPage(self, False);
                            end;
                          bIsPrinting := False;
                        end;
      end;
    end;

    nRet := LlPrintEnd(0);

    (*reset old settings*)

    if btmpDelayTableHeader = False then
      LlSetOption(LL_OPTION_DELAYTABLEHEADER, 0);

    if bToPreview and (nRet = 0) then
    begin
      if (nOptions and LL_CMNDSETPRINT_PREVIEW_DONOTDELETEANDSHOW = 0) then
      begin
        (*display preview when in preview mode*)
        nRet := LlPreviewDisplay(ProjectName, TempPath,
          ParentHandle);
        if nRet = 0 then
          LlPreviewDeleteFiles(ProjectName, TempPath);
      end;
    end;
    Result := nRet;
  end;

procedure TDBL17_.FillDataStructure(MasterSource: TDataSet);
var
 Details, DetailFields, MasterFields: TList;
 i: integer;
 Key, MasterTable, DataTyp, DetailField, MasterField: TString;
begin

  DetailFields := nil;
  MasterFields := nil;
  Details := TList.Create();
  try
    DetailFields := TList.Create();
    MasterFields := TList.Create();

    MasterSource.GetDetailDataSets(Details);

    for i := 0 to Details.Count - 1 do

      with TDataSet(Details[i]) do
      begin

        {$ifdef ADOAVAILABLE}
        if TDataSet(Details[i]) is TADOTable then
        begin
          Key := (TDataSet(Details[i]) as TADOTable).TableName;
          MasterTable := ((TDataSet(Details[i]) as TADOTable).MasterSource.DataSet as TADOTable).TableName;
          DataTyp := 'LL_TADOTABLE';
        end else
        if TDataSet(Details[i]) is TADODataSet then
        begin
          Key := TDataSet(Details[i]).Name;
          MasterTable := (DataSource.DataSet as TADODataSet).Name;
          DataTyp := 'LL_TADODATASET';
        end else
        {$endif}

        {$ifdef BDEAVAILABLE}
        if TDataSet(Details[i]) is TTable then
        begin
          Key := (TDataSet(Details[i]) as TTable).TableName;
          MasterTable := ((TDataSet(Details[i]) as TTable).MasterSource.DataSet as TTable).TableName;
          DataTyp := 'LL_TTABLE';
        end else
        {$endif}

        begin
          Key := TDataSet(Details[i]).Name;
          MasterTable := TDataSet(Details[i]).DataSource.DataSet.Name;
          DataTyp := 'LL_TDATASET';
        end;

        GetDetailLinkFields(MasterFields, DetailFields);

        if MasterFields.Count > 0 then
          MasterField := TField(MasterFields[0]).FieldName
        else
          MasterField := '';

        if DetailFields.Count > 0 then
          DetailField := TField(DetailFields[0]).FieldName
        else
          DetailField := '';


        FTableMap.AddProperty(Key,
                              TDataSet(Details[i]),
                              MasterField,
                              DetailField,
                              MasterTable,
                              DataTyp);
        FillDataStructure(TDataSet(Details[i]));

      end;
  finally
    Details.Free;
    DetailFields.Free;
    MasterFields.Free;
  end;

end;
{$endif}

procedure TTableMap.AddProperty(Key: String; Value: TDataSet; MasterField, DetailField, MasterTable, DataTyp: TString);
var
 Pos: integer;
begin
    Pos:=FKeyList.IndexOf(Key);
    if Pos<>-1 then
    begin
      FKeyList.Delete(Pos);
      FValueList.Delete(Pos);
      FMasterFieldList.Delete(Pos);
      FDetailFieldList.Delete(Pos);
      FMasterTableList.Delete(Pos);
    end;
    FKeyList.Add(Key);
    FValueList.Add(Value);
    FMasterFieldList.Add(MasterField);
    FDetailFieldList.Add(DetailField);
    FMasterTableList.Add(MasterTable);
    FDataTyp.Add(DataTyp);
end;

constructor TTableMap.create;
begin
 inherited create;
 FKeyList := TStringList.Create;
 FValueList := TList.Create;
 FMasterFieldList := TStringList.Create;
 FDetailFieldList := TStringList.Create;
 FMasterTableList := TStringList.Create;
 FDataTyp := TStringList.Create;
end;

destructor TTableMap.Destroy;
begin
  FKeyList.Free;
  FValueList.Free;
  FMasterFieldList.Free;
  FDetailFieldList.Free;
  FMasterTableList.Free;
  FDataTyp.Free;
  inherited destroy;
end;

function TTableMap.GetValue(Key: String; var Value: TDataSet; var MasterField, DetailField, MasterTable, DataTyp: TString): boolean;
var
 Pos: integer;
begin
    result:=false;
    Pos:=FKeyList.IndexOf(Key);
    if Pos=-1 then
    begin
        Value := nil;
        MasterField := '';
        DetailField := '';
        MasterTable := '';
        DataTyp := '';
        exit;
    end;
    Value:=FValueList[Pos];
    MasterField:=FMasterFieldList[Pos];
    DetailField:=FDetailFieldList[Pos];
    MasterTable:=FMasterTableList[Pos];
    DataTyp:=FDataTyp[Pos];
    result:=true;
end;
initialization
DrillDownActive:=false;
end.

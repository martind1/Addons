{=================================================================================

 Copyright � combit GmbH, Konstanz

----------------------------------------------------------------------------------
 File   : l17printworker.pas
 Module : List & Label 17
 Descr. : Implementation file for the List & Label 17 VCL-Component
 Version: 17.001
==================================================================================
}
unit l17printworker;

{$ifndef WIN64}
  {$define BDEAVAILABLE}
  {$define DESIGNIDEAVAILABLE}
{$endif}

interface

uses
  Classes, SysUtils, Windows, cmbtls17, cmbtll17, DB, l17,

  {$ifdef BDEAVAILABLE}
      dbtables,
  {$endif}

  dialogs;

type

  TPrintWorker = class(TThread)
  private
    procedure DesignerPrintPreview();
    function GetTempFile(): Tstring;
  protected
    procedure Execute; override;
  public
    printInstance: TComponent;
    projectFile: string;
    originalProjectFile: string;
    controlHandle: Cardinal;
    eventHandle: Cardinal;
    pageCount: integer;
    doExport: boolean;
    FCount: integer;
    Terminated: boolean;
    IsPrinting: boolean;
    procedure FinalizePrinting();
    procedure ReleasePreviewControl(alsoEmptyPreviewControl: integer);
    procedure Abort();
  end;

  TDrillDownWorker = class(TThread)
  private
    FUserParam: integer;
    FPreviewFileName: TString;
    FTabText: TString;
    FProjectFileName: TString;
    FParentKey: TString;
    FParentTableName: TString;
    FAttachInfo: THandle;
    FPrintInstance: TComponent;
    FTerminated: boolean;
    FKeyValue: TString;
    FJobID: longint;
    FTooltipText: TString;
    FRelationName: TString;
    FWindowHandle: cmbtHWND;
    FChildKey: TString;
    FChildTableName: TString;
    procedure DoDrillDown;
    procedure SetAttachInfo(const Value: THandle);
    procedure SetChildKey(const Value: TString);
    procedure SetChildTableName(const Value: TString);
    procedure SetJobID(const Value: longint);
    procedure SetKeyValue(const Value: TString);
    procedure SetParentKey(const Value: TString);
    procedure SetParentTableName(const Value: TString);
    procedure SetPreviewFileName(const Value: TString);
    procedure SetPrintInstance(const Value: TComponent);
    procedure SetProjectFileName(const Value: TString);
    procedure SetRelationName(const Value: TString);
    procedure SetTabText(const Value: TString);
    procedure SetTerminated(const Value: boolean);
    procedure SetTooltipText(const Value: TString);
    procedure SetUserParam(const Value: integer);
    procedure SetWindowHandle(const Value: cmbtHWND);
  protected
    procedure Execute; override;
  public
    property Terminated: boolean read FTerminated write SetTerminated;
    property PrintInstance: TComponent read FPrintInstance write SetPrintInstance;
    property UserParam: integer read FUserParam write SetUserParam;
    property ParentTableName: TString read FParentTableName write SetParentTableName;
    property RelationName: TString read FRelationName write SetRelationName;
    property ChildTableName: TString read FChildTableName write SetChildTableName;
    property ParentKey: TString read FParentKey write SetParentKey;
    property ChildKey: TString read FChildKey write SetChildKey;
    property KeyValue: TString read FKeyValue write SetKeyValue;
    property ProjectFileName: TString read FProjectFileName write SetProjectFileName;
    property PreviewFileName: TString read FPreviewFileName write SetPreviewFileName;
    property TooltipText: TString read FTooltipText write SetTooltipText;
    property TabText: TString read FTabText write SetTabText;
    property WindowHandle: cmbtHWND read FWindowHandle write SetWindowHandle;
    property JobID: longint read FJobID write SetJobID;
    property AttachInfo: THandle read FAttachInfo write SetAttachInfo;
    procedure FinalizePrinting();

  end;

implementation
uses l17db;

{ LlPrintWorker }

procedure TPrintWorker.Abort;
begin
  {D:  Druck beenden}
  {US: Stop printing}
  TDBL17_(printInstance).LlPrintAbort();
  TDBL17_(printInstance).MaxPage:=-1;
  TDBL17_(printInstance).Aborted:=true;

  Terminated := True;
end;

procedure TPrintWorker.DesignerPrintPreview;
var
  tempFileName: TString;
begin
  // D:  Aktualisierung der Echtdatenvorschau Toolbar:
  // US: Update the real data preview toolbar:
  PostMessage(controlHandle, LS_VIEWERCONTROL_UPDATE_TOOLBAR, 0, 0);

  SetEvent(eventHandle);

  // D: Tempor채res List & Label Projekt f체r den Druck 체bergeben:
  // US: Set temp List & Label project file for printing:
  TDBL17_(printInstance).IncrementalPreview := 1;
  TDBL17_(printInstance).NoNoTableCheck := Yes;
  TDBL17_(printInstance).LlSetOptionString(LL_OPTIONSTR_ORIGINALPROJECTFILENAME, originalProjectFile);

  if not doExport then
  begin
    // D:  Aufruf, damit das Vorschau-Control die Kontrolle 체ber die Vorschaudatei erh채lt:
    // US: Set the preview control as master for the preview file:
    tempFileName := GetTempFile();
	TDBL17_(printInstance).AutoDestination := adPreview;
    TDBL17_(printInstance).LlSetOptionString(LL_OPTIONSTR_PREVIEWFILENAME, ExtractFileName(tempFileName));
    TDBL17_(printInstance).LlPreviewSetTempPath(ExtractFilePath(tempFileName));
    TDBL17_(printInstance).LlAssociatePreviewControl(controlHandle, 1);
  end
  else
  begin
	TDBL17_(printInstance).AutoDestination := adUserSelect;
    TDBL17_(printInstance).LlSetOptionString(LL_OPTIONSTR_PREVIEWFILENAME, '');
    TDBL17_(printInstance).LlPreviewSetTempPath('');
    TDBL17_(printInstance).LlAssociatePreviewControl(0, 0);
  end;

  try
    TDBL17_(printInstance).MaxPage := pageCount;
    TDBL17_(printInstance).AutoDesignerFile:=projectFile;
    TDBL17_(printInstance).AutoPrint('DesignerPreview...','');
  finally
    DeleteFile(PXChar(projectFile));
    if not doExport then
      TDBL17_(printInstance).LlAssociatePreviewControl(0,1);
    Terminated := true;
  end;
end;

procedure TPrintWorker.Execute;
begin
  IsPrinting := false;
  {$ifndef NO_VCL_SYNCHRONIZATION}
  Synchronize( DesignerPrintPreview );
  {$else}
  DesignerPrintPreview;
  {$endif}
end;

procedure TPrintWorker.FinalizePrinting();
begin
  Abort();
  ReleasePreviewControl(0);
end;

function TPrintWorker.GetTempFile: TString;
var
  Buffer: PTChar;
begin
    GetMem(Buffer, (MAX_PATH+1)*sizeof(TChar));
    LlGetTempFileName('~', 'll', Buffer, MAX_PATH+1, 0);
    result:=TString(Buffer);
    FreeMem(Buffer);
end;



procedure TPrintWorker.ReleasePreviewControl(alsoEmptyPreviewControl: integer);
begin
  TDBL17_(printInstance).LlAssociatePreviewControl(controlHandle, alsoEmptyPreviewControl)
end;

{ TDrillDownWorker }

procedure TDrillDownWorker.DoDrillDown;
var s1,s2,s3: TString;
var fieldName: string;
begin
    with TDBL17_(printInstance) do
    begin
      LlSetOptionString(LL_OPTIONSTR_PREVIEWFILENAME, PreviewFileName);
      LlAssociatePreviewControl(AttachInfo, LL_ASSOCIATEPREVIEWCONTROLFLAG_DELETE_ON_CLOSE or LL_ASSOCIATEPREVIEWCONTROLFLAG_HANDLE_IS_ATTACHINFO);
      AutoShowPrintOptions:=No;
      AutoShowSelectFile:=No;
      AutoBoxType:=btNone;

      try
        AutoDesignerFile:=ProjectFileName;
        FillTableMapper();
        FTableMap.GetValue(ParentTableName, FTable, s1, s2, s3, s3);

        fieldName:=Copy(ParentKey, length(ParentTableName)+2, length(ParentKey)-( length(ParentTableName)+1));
        if ((FTable <> nil) and (FTable.Locate(fieldName, KeyValue, [] ))) then
          AutoPrint('DesignerPreview...','')
        else
          LlDebugOutput(0, 'VCL: Locate not supported by data source, no drill down possible');
      finally
        Terminated := true;
        DrillDownActive:=false;
      end;
    end;
end;

procedure TDrillDownWorker.Execute;
begin
  {$ifndef NO_VCL_SYNCHRONIZATION}
  Synchronize( DoDrillDown );
  {$else}
  DoDrillDown;
  {$endif}
end;

procedure TDrillDownWorker.FinalizePrinting;
begin
  TDBL17_(PrintInstance).LlPrintAbort();
  TDBL17_(PrintInstance).MaxPage:=-1;
  Terminated := True;
end;

procedure TDrillDownWorker.SetAttachInfo(const Value: THandle);
begin
  FAttachInfo := Value;
end;

procedure TDrillDownWorker.SetChildKey(const Value: TString);
begin
  FChildKey := Value;
end;

procedure TDrillDownWorker.SetChildTableName(const Value: TString);
begin
  FChildTableName := Value;
end;

procedure TDrillDownWorker.SetJobID(const Value: longint);
begin
  FJobID := Value;
end;

procedure TDrillDownWorker.SetKeyValue(const Value: TString);
begin
  FKeyValue := Value;
end;

procedure TDrillDownWorker.SetParentKey(const Value: TString);
begin
  FParentKey := Value;
end;

procedure TDrillDownWorker.SetParentTableName(const Value: TString);
begin
  FParentTableName := Value;
end;

procedure TDrillDownWorker.SetPreviewFileName(const Value: TString);
begin
  FPreviewFileName := Value;
end;

procedure TDrillDownWorker.SetPrintInstance(const Value: TComponent);
begin
  FPrintInstance := Value;
end;

procedure TDrillDownWorker.SetProjectFileName(const Value: TString);
begin
  FProjectFileName := Value;
end;

procedure TDrillDownWorker.SetRelationName(const Value: TString);
begin
  FRelationName := Value;
end;

procedure TDrillDownWorker.SetTabText(const Value: TString);
begin
  FTabText := Value;
end;

procedure TDrillDownWorker.SetTerminated(const Value: boolean);
begin
  FTerminated := Value;
end;

procedure TDrillDownWorker.SetTooltipText(const Value: TString);
begin
  FTooltipText := Value;
end;

procedure TDrillDownWorker.SetUserParam(const Value: integer);
begin
  FUserParam := Value;
end;

procedure TDrillDownWorker.SetWindowHandle(const Value: cmbtHWND);
begin
  FWindowHandle := Value;
end;

end.

{=================================================================================

 Copyright © combit GmbH, Konstanz

----------------------------------------------------------------------------------
 File   : L17.pas
 Module : List & Label 17
 Descr. : Implementation file for the List & Label 17 VCL-Component
 Version: 17.001
==================================================================================
}

unit l17;

{$ifndef VER90}
{$ifndef VER100}
{$define USELLXOBJECTS}
//beware 15.05.12 {$R 'l17.dcr'}
{$endif}
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


{$ifndef VER90}
{$ifndef VER100}
{$ifndef VER110}
{$ifndef VER120}
{$ifndef VER125}
{$ifndef VER130}
{$ifndef VER135}
{$ifndef VER140}
{$ifndef VER150}
{$ifndef VER160}
{$ifndef VER170}
{$ifndef VER180}
{$ifndef VER185}
{$ifndef VER190}
{$define UNICODE}
{$define USE_UNICODE_DLL}
{$define UNICODESTRING_AWARE}
{$endif}
{$endif}
{$endif}
{$endif}
{$endif}
{$endif}
{$endif}
{$endif}
{$endif}
{$endif}
{$endif}
{$endif}
{$endif}
{$endif}


interface

uses

  SysUtils, Windows, Classes, graphics, Forms, cmbtll17, db, messages, dialogs,
  registry, controls, TypInfo, menus,
  {$ifdef USELLXOBJECTS}
  l17interf,axctrls,
  {$endif}
  {$ifdef VER90}
  ole2;
  {$else}
  activex;
  {$endif}

const
  (* If the language file for the current selected language is not present    *)
  (* List & Label tries to open the job with each language up to              *)
  (* CMBTLANG_MAX. In this LL_VCL version there are supported languages up    *)
  (* to CMBTLANG_UKRAINIAN. If you need a further language you have to define *)
  (* the values for the language property up to the language you want to      *)
  (* support.                                                                 *)
  (* You have to change the code in at following positions:                   *)
  (*                                                                          *)
  (*                        - constant CMBTLANG_MAX                           *)
  (*                        - type for property nLanguage: TLanguageType      *)
  (*                        - function TL17_.CheckSetLlJob()                   *)
  (*                        - function TL17_.SetLanguage()                     *)

  CMBTLANG_MAX = CMBTLANG_UKRAINIAN;
  LL_MASTER_NONE = 0;
  LL_MASTER_DETAIL = 1;
  LL_MASTER_MASTER = 2;

  LL_CMNDSETPRINT_PREVIEW_DONOTDELETEANDSHOW = 1;

  IDM_PRV_ZOOMMUL2=100;
  IDM_PRV_ZOOMPREV=101;
  IDM_PRV_FIRST=102;
  IDM_PRV_LAST=103;
  IDM_PRV_PREVIOUS=104;
  IDM_PRV_NEXT=105;
  IDM_PRV_DEFAULT=108;
  IDM_PRV_PRINTONE=112;
  IDM_PRV_PRINTALL=113;
  IDM_PRV_FILEEXIT=114;
  IDM_PRV_SENDTO=115;
  IDM_PRV_SAVEAS=116;
  IDM_PRV_FAX=117;
  IDM_PRV_SAVE_PDF=123;
  IDM_PRV_PAGECOMBO=124;
  IDM_PRV_ZOOMCOMBO=125;
  IDM_PRV_SLIDESHOWMODE=126;
  IDM_PRV_SEARCH=118;
  IDM_PRV_SEARCH_NEXT=119;
  IDM_PRV_SEARCH_TEXT=121;
  IDM_PRV_SEARCH_OPTIONS=122;

  var
  g_BufferStr: PTChar;

  {Text Pointer and String Type for UNICODE-VCL}
type
  {$ifdef UNICODE}
  {$ifdef UNICODESTRING_AWARE}
  TString = UnicodeString;
  {$else}
  TString = WideString;
  {$endif}
  {$else}
  TString = String;
  {$endif}

  {$ifdef UNICODESTRING_AWARE}
  PXChar = PWideChar;
  XChar  = WideChar;
  {$else}
  PXChar = PChar;
  XChar = Char;
  {$endif}



  cmbtHWND = DWORD; // needed for C++Builder compatibility

  TExpressionMode = (Old, NewMode, Enhanced);

  (* Definition of the possible values of the language property             *)
  (* If you need more language types, here is a good place to define the    *)
  (* values by your own                                                     *)
  TLanguageType = (ltDefaultLang, ltDeutsch, ltEnglish, ltArab,
    ltAfrikaans, ltAlbanian, ltBasque,
    ltBulgarian, ltBelorussian, ltCatalan, ltChinese,
    ltCroatian, ltCzech,
    ltDanish, ltDutch, ltEstonian, ltFaeroese, ltFarsi,
    ltFinnish, ltFrench,
    ltGreek, ltHebrew, ltHungarian, ltIcelandic,
    ltIndonesian, ltItalian,
    ltJapanese, ltKorean, ltLatvian, ltLithuanian,
    ltNorwegian, ltPolish,
    ltPortuguese, ltRomanian, ltRussian, ltSlovak,
    ltSlovenian, ltSerbian,
    ltSpanish, ltSwedish, ltThai, ltTurkish, ltUkrainian);

  TDictionaryType = (dtStatic=1, dtIdentifiers=2, dtTables=3, dtRelations=4, dtSortOrders=5);

  TTabMode = (tmReplace, tmExpand);
  TPropEnable = (Disable, Enable);
  TPropYesNo = (No, Yes);
  TPropTableColoring = (tcNormal, tcUserdefined, tcMixed);
  TPropUnitSystem = (usMetric, usHiMetric, usInch, usHiInch);
  TPropStgSystem = (syCompat4, syStorage);
  TDialogboxMode = (dmWin16, dmcombit1, dmcombit2, dmcombit3, dmcombit4, dmcombit5, dmcombit6, dmcombit7, dmWin95, dmOffice97, dmOfficeXP, dmOffice2003);

  Pinteger = ^integer;
  TLlDesignerFile = TString;

  TTableLineType = (ltHeader, ltBody, ltFooter, ltFill, ltGroupHeader, ltGroupFooter);
  TTableFieldType = (ftHeader, ftBody, ftFooter, ftFill, ftGroupHeader, ftGroupFooter);
  TPaintMode = (pmPaintPreview, pmPaintFastPreview, pmPaintWorkspace);
  TObjectType = (otMarker, otText, otRectangle, otLine, otBarcode, otTable, otTemplate, otEllipse, otGroup, otRTF, otExtensionObject);
  TButtonState = (bsInvisible,bsDefault,bsEnabled, bsDisabled);
  TViewerButton = (vbFirstPage, vbPreviousPage, vbNextPage, vbLastPage, vbZoomIn, vbZoomOut, vbViewPage, vbPrintPage, vbPrintAll, vbExit, vbSendTo, vbSaveAs, vbFax, vbPrintPageWithPrinterSelection, vbPrintAllWithPrinterSelection);
  TMeterJob = (mjNone, mjLoad, mjSave, mfConsistencyCheck);
  TCloseMode = (cmKeepFile, cmDeleteFile);

  TLlDesignerWorkspaceFileMode = (fmOpen, fmCreate, fmCreateNew, fmOpenOrCreate, fmImport);
  TLlDesignerWorkspaceSaveMode = (smDefault, smNoSaveQuery, smNoSave);

  TLlDesignerAction = (
        daFileNew, daFileOpen, daFileImport, daFileSave, daFileSaveAs,
        daFilePrintSamplePrintSamplewithFrames, daFilePrintSamplePrintSamplewithoutFrames, daFilePrintSampleFirstPage,
        daFilePrintSampleFollowingPage, daFileExit, daFileLRUlist, daEditUndo, daEditCut, daEditCopy, daEditPaste, daEditDelete,
        daProjectPageSetup, daProjectInclude, daProjectLayerDefinitions, daProjectFilter, daProjectSumVariables, daProjectUserVariables,
        daProjectOptions, daObjectsSelectSelectionMode, daObjectsSelectSelectAll, daObjectsSelectToggleSelection,
        daObjectsSelectNextObject, daObjectsSelectPreviousObject, daObjectsInsertText, daObjectsInsertRectangle,
        daObjectsInsertEllipse, daObjectsInsertLine, daObjectsInsertPicture, daObjectsInsertBarcode, daObjectsInsertTable,
        daObjectsInsertFormattedText, daObjectsInsertFormControl, daObjectsInsertFormTemplate, daObjectsInsertLLXObjects,
        daObjectsInsertMultipleCopies, daObjectsArrangeToFront, daObjectsArrangeToBack, daObjectsArrangeOneForward,
        daObjectsArrangeOneBackward, daObjectsArrangeAlignment, daObjectsGroup, daObjectsUngroup, daObjectsAssigntoLayer,
        daObjectsCopytoLayer, daObjectsProperties, daObjectsContents, daObjectsFont, daObjectsLocked,
        daObjectsAppearanceCondition, daObjectsCommonAppearanceCondition, daObjectsName, daObjectsObjectList,
        daViewFull, daViewTimes2, daViewTimes4, daViewTimes8, daViewLayout, daViewLayoutPreview, daViewPreview,
        daViewWindowsPreview, daViewWindowsVariables, daViewWindowsLayers, daViewWindowsObjectList, daViewWindowsPropertyWindow,
        daViewWindowsTableStructure, daViewWindowsRulers, daViewWindowsToolbarActions, daViewWindowsToolbarObjects,
        daHelpContextSensitive, daHelpContents, daZoomTimes2, daZoomRevert, daZoomFit
        );


  EDBLlError = class(Exception);
  EDBLlPipeError = class(EDBLlError);
  EDBLlFileError = class(EDBLlError);
  ENoParentComponentError = class(Exception);

  Ll17HelperClass = class of TLl17HelperClass;

  TPrvAppearance = class(TPersistent)
  private
    { Private-Deklarationen }
    FPrvPerc: integer;
    FPrvLeft: integer;
    FPrvTop: integer;
    FPrvWidth: integer;
    FPrvHeight: integer;
    hTheLLJob: integer;

  protected
    { Protected-Deklarationen }

    function GetPerc: integer;
    function GetLeft: integer;
    function GetTop: integer;
    function GetWidth: integer;
    function GetHeight: integer;

    procedure SetPerc(nValue: integer);
    procedure SetLeft(nValue: integer);
    procedure SetTop(nValue: integer);
    procedure SetWidth(nValue: integer);
    procedure SetHeight(nValue: integer);

  public
    { Public-Deklarationen }

    constructor Create;
    procedure SetJob(hLLJob: integer);

  published
    property ZoomPerc: integer read FPrvPerc write SetPerc default 100;
    property Left: integer read FPrvLeft write SetLeft default - 1;
    property Top: integer read FPrvTop write SetTop default - 1;
    property Width: integer read FPrvWidth write SetWidth default - 1;
    property Height: integer read FPrvHeight write SetHeight default - 1;
  end;


  {$ifdef USELLXOBJECTS}
  TLl17XObject=class;
  TLl17XFunction=class;
  {$endif}
  TLl17XAction=class;

  TTableFieldEvent = procedure(Sender: TObject; FieldType: TTableFieldType;
    Canvas: TCanvas; Rect: TRect; LineDef: integer; Index: integer; SpacingRect: TRect)
    of object;

  TTableLineEvent = procedure(Sender: TObject; LineType: TTableLineType;
    Canvas: TCanvas; Rect: TRect; PageLine: integer; Line: integer;
    Zebra: boolean; SpacingRect: TRect) of object;

  TDrawUserobjEvent = procedure(Sender: TObject; Name: TString;
    Contents: TString; VarType: integer; VarPointer: Pointer; ContentsHandle: thandle;
    Isotropic: boolean; Parameters: TString; Canvas: TCanvas; var Rect: TRect;
    PaintMode: TPaintMode) of object;

  TEditUserobjEvent = procedure(Sender: TObject; Name: TString;
    VarType: integer; VarPointer: Pointer; ContentsHandle: thandle;
    var Isotropic: boolean; ParentHandle: cmbtHWND; var Parameters: TString) of object;

  TPageEvent = procedure(Sender: TObject; IsDesignerPreview: boolean;
    IsPreDraw: boolean; var Canvas: TCanvas; Rect: TRect) of object;
  TProjectEvent = procedure(Sender: TObject; IsDesignerPreview: boolean;
    IsPreDraw: boolean; Canvas: TCanvas; Rect: TRect) of object;
  TObjectEvent = procedure(Sender: TObject; ObjectName: TString;
    ObjectType: TObjectType; IsPreDraw: boolean; Canvas: TCanvas;
    var Rect: TRect; var EventResult: integer) of object;
  TEvaluateEvent = procedure(Sender: TObject; const Parameters: TString;
    IsEvaluating: boolean; var EventResult: TString; var HasError: boolean;
    var ErrorText: TString) of object;
  TFailsFilterEvent = procedure(Sender: TObject) of object;
  THelpEvent = procedure(Sender: TObject; HelpCommand: integer;
    ContextID: integer; var EventResult: integer) of object;
  TEnableMenuEvent = procedure(Sender: TObject; Handle: HMENU) of object;
  TModifyMenuEvent = procedure(Sender: TObject; Handle: HMENU) of object;
  TSelectMenuEvent = procedure(Sender: TObject; MenuID: integer; var EventResult: integer) of
  object;
  TGetViewerButtonStateEvent = procedure(Sender: TObject; Button: TViewerButton;
    var ButtonState: TButtonState) of object;
  TViewerButtonClickedEvent = procedure(Sender: TObject; Button: TViewerButton;
    var PerformDefaultAction: boolean) of object;
  TVarHelpTextEvent = procedure(Sender: TObject; const Name: TString;
    var HelpText: TString) of object;
  TMeterInfoEvent = procedure(Sender: TObject; ParentHandle: cmbtHWND;
    TotalObjects: integer; CurrentObject: integer; Job: TMeterJob) of object;

  TDefineVariablesEvent = procedure(Sender: TObject; UserData: integer;
    IsDesignMode: boolean; var Percentage: integer; var IsLastRecord: boolean;
    var EventResult: integer) of object;
  TDefineFieldsEvent = procedure(Sender: TObject; UserData: integer;
    IsDesignMode: boolean;
    var Percentage: integer; var IsLastRecord: boolean; var EventResult: integer) of object;

  TAutoDefineNewPageEvent = procedure(Sender: TObject; IsDesignMode: boolean) of object;
  TAutoDefineNewLineEvent = procedure(Sender: TObject; IsDesignMode: boolean) of object;
  TAutoDefineFieldEvent = procedure(Sender: TObject; IsDesignMode: boolean; var FieldName, FieldContent: TString; var FieldType: integer; var IsHandled: boolean) of object;
  TAutoDefineVariableEvent = procedure(Sender: TObject; IsDesignMode: boolean; var VariableName, VariableContent: TString; var VariableType: integer; var IsHandled: boolean) of object;
  TSetPrintOptionsEvent = procedure(Sender: TObject; var PrintMethodOptionFlags: integer) of object;
  THostPrinterEvent = procedure(Sender: TObject; var pSCHP: PSCLLPRINTER; var lResult: integer) of object;
  TDlgExprVarBtnEvent = procedure(Sender: TObject; var pSCDE: PSCLLDLGEXPRVAREXT; var lResult: integer) of object;
  TNtfyErrorEvent = procedure(Sender: TObject; ErrorText: TString; lResult: integer) of object;
  TSaveFileNameEvent = procedure(Sender: TObject; FileName: TString) of object;
  TPrintJobInfoEvent = procedure(Sender: TObject; LlJobID: HLLJOB; DeviceName: TString; JobID: cardinal; JobStatus: cardinal) of object;
  TProjectLoadedEvent = procedure(Sender: TObject) of object;
  TInplaceDesignerClosedEvent = procedure(Sender: TObject) of object;
  TDesignerPrintJobEvent = procedure(Sender: TObject; UserParam: integer; ProjectFileName: TString;
                                     OriginalFileName: TString; Pages: cardinal; Task: cardinal;
                                     hWndPreviewControl: cmbtHWND; Event: THandle; var returnValue: integer) of object;

  TDrillDownJobEvent = procedure(Sender: TObject; Task: cardinal; UserParam: integer; ParentTableName: TString; RelationName: TString;
    ChildTableName: TString; ParentKey: TString; ChildKey: TString; KeyValue: TString; ProjectFileName: TString;
    PreviewFileName: TString; TooltipText: TString; TabText: TString; WindowHandle: cmbtHWND; JobID: longint; AttachInfo: THandle; var returnValue: integer) of object;


  TDicData = class;
  TDicFields = class;
  TDictionary = class;
  TDesignerWorkspace = class;

TLongintList=class
private
      FList: TList;
      function GetItems(Index: Integer): longint;
      function GetCount:integer;
public
      constructor Create;
      destructor Destroy; override;
      procedure Add(item: longint);
      procedure Clear;
      function Find(item: longint):integer;
      property Items[Index: Integer]: longint read GetItems; default;
      property List: TList read FList;
      property Count: integer read GetCount;
end;


  TL17_ = class(TComponent)
  private
    nDebug: integer;
    nMaxRTFVersion: smallint;
    nLanguage: TLanguageType;
    nEMFResolution: integer;
    nDialogBoxMode: TDialogBoxMode;
    nDialogBoxValue: integer;
    nButtonsValue: integer;
    FPrvAppearance: TPrvAppearance;
    lpfnNtfyProc: TFarProc;
    bHelpAvailable: boolean;
    bOfnDialogExplorer: boolean;
    bRealTime: boolean;
    bSpaceOptimization: boolean;
    bUseBarcodeSizes: boolean;
    bUseHostprinter: boolean;
    bVarsCaseSensitive: boolean;
    bWizFileNew: boolean;
    bButtons3D: boolean;
    bButtonsWithBitmaps: boolean;
    bXlatvarnames: boolean;
    bCreateInfo: boolean;
    bInterCharSpacing: boolean;
    bIncludeFontDescent: boolean;
    bUseChartFields: boolean;
    sLicensingInfo: string;
    sProjectPassword: string;
    FOnTableFieldCallback: TTableFieldEvent;
    FOnTableLineCallback: TTableLineEvent;
    FOnDrawUserobjCallback: TDrawUserobjEvent;
    FOnEditUserobjCallback: TEditUserobjEvent;
    FOnPageCallback: TPageEvent;
    FOnProjectCallback: TProjectEvent;
    FOnObjectCallback: TObjectEvent;
    FOnExtFctCallback: TEvaluateEvent;
    FOnFailsFilterCallback: TFailsFilterEvent;
    FOnHelpCallback: THelpEvent;

    FOnEnableMenuCallback: TEnableMenuEvent;
    FOnModifyMenuCallback: TModifyMenuEvent;
    FOnSelectMenuCallback: TSelectMenuEvent;
    FOnGetViewerButtonStateCallback: TGetViewerButtonStateEvent;
    FOnViewerButtonClickedCallback: TViewerButtonClickedEvent;
    FOnVarHelpTextCallback: TVarHelpTextEvent;
    FOnNtfyProgressCallback: TMeterInfoEvent;
    FOnHostPrinterCallback: THostPrinterEvent;
    FOnDlgExprVarBtnCallback: TDlgExprVarBtnEvent;
    FOnDefineVariablesCallback: TDefineVariablesEvent;
    FOnDefineFieldsCallback: TDefineFieldsEvent;
    FOnPrintJobInfo: TPrintJobInfoEvent;
    FOnExprError: TNtfyErrorEvent;
    FOnSaveFileName: TSaveFileNameEvent;
    FDictionary: TDictionary;
    FIncrementalPreview: integer;
    FOnProjectLoaded: TProjectLoadedEvent;
    FOnInplaceDesignerClosed: TInplaceDesignerClosedEvent;
    FDesignerWorkspace: TDesignerWorkspace;
    FOnDesignerPrintJob: TDesignerPrintJobEvent;
    FOnDrillDownJob: TDrillDownJobEvent;
    FInplaceDesignerHandle: HWND;
    function CheckLlJob: boolean;
    function CheckSetLlJob(bWarn: boolean): boolean;
    function CheckSetCallback: boolean;
    procedure UpdateButtonsValue;
    procedure SetDictionary(const Value: TDictionary);
    function TranslateRelationFieldName(RelFieldName: TString; LCID: integer): TString;
    function GetPairedItemDisplayString(TableFieldPair: TString; LCID: integer):TString;
    procedure SetIncrementalPreview(const Value: integer);
    procedure SetDesignerWorkspace(const Value: TDesignerWorkspace);
    procedure SetInplaceDesignerHandle(const Value: HWND);
  protected
    FIsCopy: boolean;
    hTheJob: HLLJOB;
    {$ifdef USELLXOBJECTS}
    FLlXObjectList: TList;
    FLlXFunctionList: TList;
    FLlXInterface: LlXInterface;
    {$endif}
    FLlXActionList: TList;
    bDelayTableHeader: boolean;
    FOnSetPrintOptionsEvent: TSetPrintOptionsEvent;
         
    function GetItemDisplayName(Name: TString; DictionaryType: TDictionaryType; LCID: integer): TString;
    function ButtonFromLLValue(Value: integer): TViewerButton;
    function LLValueFromButton(Value: TViewerButton): integer;
    procedure SetLanguage(nType: TLanguageType);
    procedure SetEMFResolution(_nRes: integer);
    procedure SetMaxRTFVersion(nVersion: smallint);
    function GetNewExpressions: TExpressionMode;
    procedure SetNewExpressions(nMode: TExpressionMode);
    function GetMultipleTableLines: TPropYesNo;
    procedure SetMultipleTableLines(nEnable: TPropYesNo);
    function GetAddVarsToFields: TPropYesNo;
    procedure SetAddVarsToFields(nEnable: TPropYesNo);
    function GetOnlyOneTable: boolean;
    procedure SetOnlyOneTable(bFlag: boolean);
    function GetOptionSupervisor: TPropYesNo;
    procedure SetOptionSupervisor(bFlag: TPropYesNo);
    function GetTabMode: TTabMode;
    procedure SetTabMode(bFlag: TTabMode);
    function GetConvertCRLF: TPropYesNo;
    procedure SetConvertCRLF(bFlag: TPropYesNo);
    function GetTabRepresentationCode: char;
    procedure SetTabRepresentationCode(cCode: char);
    function GetPhantomspaceRepresentationCode: char;
    procedure SetPhantomspaceRepresentationCode(cCode: char);
    function GetLocknextcharRepresentationCode: char;
    procedure SetLocknextcharRepresentationCode(cCode: char);
    function GetExprsepRepresentationCode: char;
    procedure SetExprsepRepresentationCode(cCode: char);
    function GetTextquoteRepresentationCode: char;
    procedure SetTextquoteRepresentationCode(cCode: char);
    function GetRetRepresentationCode: char;
    procedure SetRetRepresentationCode(cCode: char);
    function GetHelpAvailable: TPropYesNo;
    procedure SetHelpAvailable(nFlag: TPropYesNo);
    function GetDelayTableHeader: TPropYesNo;
    procedure SetDelayTableHeader(nFlag: TPropYesNo);
    function GetOfnDialogExplorer: TPropYesNo;
    procedure SetOfnDialogExplorer(nFlag: TPropYesNo);
    function GetRealTime: TPropYesNo;
    procedure SetRealTime(nFlag: TPropYesNo);
    function GetSpaceOptimization: TPropYesNo;
    procedure SetSpaceOptimization(nFlag: TPropYesNo);
    function GetUseBarcodeSizes: TPropYesNo;
    procedure SetUseBarcodeSizes(nFlag: TPropYesNo);
    function GetUseHostprinter: TPropYesNo;
    procedure SetUseHostprinter(nFlag: TPropYesNo);
    function GetVarsCaseSensitive: TPropYesNo;
    procedure SetVarsCaseSensitive(nFlag: TPropYesNo);
    function GetWizFileNew: TPropYesNo;
    procedure SetWizFileNew(nFlag: TPropYesNo);
    function GetSupportPageBreak: TPropYesNo;
    procedure SetSupportPageBreak(nFlag: TPropYesNo);
    function GetSortVariables: TPropYesNo;
    procedure SetSortVariables(nFlag: TPropYesNo);
    function GetShowPredefVars: TPropYesNo;
    procedure SetShowPredefVars(nFlag: TPropYesNo);
    function GetTableColoringMode: TPropTableColoring;
    procedure SetTableColoringMode(nMode: TPropTableColoring);
    function GetMetric: TPropUnitSystem;
    procedure SetMetric(nMode: TPropUnitSystem);
    function GetStorageSystem: TPropStgSystem;
    procedure SetStorageSystem(nMode: TPropStgSystem);
    function GetCompressStorage: TPropYesNo;
    procedure SetCompressStorage(nMode: TPropYesNo);
    function GetNoParameterCheck: TPropYesNo;
    procedure SetNoParameterCheck(nMode: TPropYesNo);
    function GetNoNoTableCheck: TPropYesNo;
    procedure SetNoNoTableCheck(nMode: TPropYesNo);
    function GetDialogboxMode: TDialogBoxMode;
    procedure SetDialogBoxMode(nMode: TDialogBoxMode);
    function GetButtons3D: TPropYesNo;
    procedure SetButtons3D(nMode: TPropYesNo);
    function GetButtonsWithBitmaps: TPropYesNo;
    procedure SetButtonsWithBitmaps(nMode: TPropYesNo);
    function GetXlatVarNames: TPropYesNo;
    procedure SetXlatVarNames(nMode: TPropYesNo);
    function GetCreateInfo: TPropYesNo;
    procedure SetCreateInfo(nMode: TPropYesNo);
    function GetInterCharSpacing: TPropYesNo;
    procedure SetInterCharSpacing(nMode: TPropYesNo);
    function GetIncludeFontDescent: TPropYesNo;
    procedure SetIncludeFontDescent(nMode: TPropYesNo);
    function GetUseChartFields: TPropYesNo;
    procedure SetUseChartFields(nMode: TPropYesNo);
    procedure SetLicensingInfo(sInfo: string);
    procedure SetProjectPassword(sPassword: string);
    procedure TableFieldCallback(pSCF: PSCLLTABLEFIELD);
    procedure TableLineCallback(pSCL: PSCLLTABLELINE);
    procedure DrawUserobjCallback(pSCD: PSCLLDRAWUSEROBJ);
    procedure EditUserobjCallback(pSCE: PSCLLEDITUSEROBJ);
    procedure PageCallback(pSCP: PSCLLPAGE);
    procedure ProjectCallback(pSCP: PSCLLPROJECT);
    procedure ObjectCallback(pSCO: PSCLLOBJECT; var lResult: integer);
    procedure ExtFctCallback(pSCP: PSCLLEXTFCT);
    procedure FailsFilterCallback;
    procedure ProjectLoadedEvent;
    procedure InplaceDesignerClosedEvent;
    function DesignerPrintJobEvent(pSCD: PSCLLDESIGNERPRINTJOB): integer;
    function DrillDownJobEvent(pSCD: PSCLLDRILLDOWNJOBINFO): integer;
    procedure HelpCallback(nHelpCommand: integer; nContextID: integer; var lResult: integer);
    procedure EnableMenuCallback(nMenuHandle: integer);
    procedure ModifyMenuCallback(nMenuHandle: integer);
    procedure SelectMenuCallback(nMenuID: integer; var lResult: integer);
    procedure GetViewerButtonStateCallback(nID: integer; nState: integer; var lResult: integer);
    procedure ViewerButtonClickedCallback(nID: integer; var lResult: integer);
    procedure PrintJobInfoCallback(pSCI:PSCLLPRINTJOBINFO);
    procedure VarHelpTextCallback(const pszVarName: PTChar; var pszHelpText: PTChar);
    procedure NtfyProgressCallback(pSCM: PSCLLMETERINFO);
    procedure NtfyExprErrorCallback(pszErrorText: PTChar; var lResult: integer);
    procedure HostPrinterCallback(pSCHP: PSCLLPRINTER; var lResult: integer);
    procedure DlgExprVarBtnCallback(pSCDE: PSCLLDLGEXPRVAREXT; var lResult: integer);
    procedure DefineVariablesCallback(nUserData: integer; bDummy: integer; pnProgressInPerc: Pinteger; pbLastRecord: Pinteger; var lResult: integer);
    procedure DefineFieldsCallback(nUserData: integer; bDummy: integer; pnProgressInPerc: Pinteger; pbLastRecord: Pinteger; var lResult: integer);
    procedure SaveFileNameCallback(pszFileName: PTChar);
    procedure ConvertTField(Field: TField; var FieldName, FieldContent: TString; var FieldType: integer);
    function LlDesignerInvokeAction(menuId: integer): integer;
    function LlDesignerRefreshWorkspace: integer;
    function LlDesignerFileOpen(filename: TString; flags: Cardinal): integer;
    function LlDesignerFileSave(flags: Cardinal): integer;
    property OnInplaceDesignerClosed: TInplaceDesignerClosedEvent read FOnInplaceDesignerClosed write FOnInplaceDesignerClosed;
  public
    bIsPrinting: boolean;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function Design(UserData: integer; ParentHandle: cmbtHWND; Title: TString; ProjectType: integer; ProjectName: TString; ShowFileSelect: boolean; AllowCreate: boolean): integer; virtual;
    function Print(UserData: integer; ProjectType: integer; ProjectName: TString; ShowFileSelect: boolean; PrintOptions: integer; BoxType: integer;      ParentHandle: cmbtHWND; Title: TString; ShowPrintOptions: boolean; TempPath: TString): integer; virtual;
    procedure LlSetDebug(DebugMode: integer);
    function LlGetVersion(VersionType: integer): integer;
    function LlGetNotificationMessage: word;
    function LlGetErrortext(returnValue: integer): TString;
    function LlSetNotificationMessage(Message: word): integer;
    function LlSetNotificationCallback(_lpfnNotify: TFarproc): tFarproc;
    function LlDefineField(FieldName: TString; Contents: TString): integer;
    function LlDefineFieldExt(FieldName: TString; Contents: TString; FieldType: integer): integer;
    function LlDefineFieldFromTField(Contents: TField):integer;
    function LlDefineFieldFromTFieldExt(TableName: TString; Contents: TField):integer;
    function LlDefineFieldExtHandle(FieldName: TString; Handle: THandle; FieldType: integer): integer;
    procedure LlDefineFieldStart;
    function LlDefineLayout(ParentHandle: cmbtHWND; Title: TString; ProjectType: word; ProjectName: TString): integer;
    function LlDefineVariable(VariableName: TString; Contents: TString): integer;
    function LlDefineVariableExt(VariableName: TString; Contents: TString; VariableType: integer): integer;
    function LlDefineVariableFromTField(Contents: TField):integer;
    function LlDefineVariableFromTFieldExt(TableName: TString; Contents: TField):integer;
    function LlDefineVariableExtHandle(VariableName: TString; Handle: THandle; VariableType: integer): integer;
    procedure LlDefineVariableStart;
    function LlPreviewSetTempPath(Path: TString): integer;
    function LlPreviewDeleteFiles(ProjectName: TString; PreviewFilePath: TString): integer;
    function LlPreviewDisplay(ProjectName: TString; PreviewFilePath: TString; ParentHandle: cmbtHWND): integer;
    function LlPrint: integer;
    function LlPrintAbort: integer;
    function LlPrintCheckLineFit: wordbool;
    function LlPrintFieldsEnd: integer;
    function LlPrintEnd(AdditionalPages: integer): integer;
    function LlPrintFields: integer;
    function LlPrintGetCurrentPage: integer;
    function LlPrintGetItemsPerPage: integer;
    function LlPrintGetItemsPerTable: integer;
    function LlPrintGetRemainingItemsPerTable(FieldName: TString): integer;
    function LlPrintGetOption(OptionIndex: integer): integer;
    function LlPrintGetPrinterInfo(var PrinterName, PrinterPort: TString): integer;
    function LlPrintOptionsDialog(ParentHandle: cmbtHWND; DialogText: TString): integer;
    function LlPrintSelectOffset(ParentHandle: cmbtHWND): integer;
    function LlPrintSetBoxText(Text: TString; Percentage: integer): integer;
    function LlPrintSetOption(Index: integer; Value: integer): integer;
    function LlPrintStart(ProjectType: word; ProjectName: TString; PrintOptions: integer): integer;
    function LlPrintWithBoxStart(ProjectType: word; ProjectName: TString; PrintOptions: integer; BoxType: integer; ParentHandle: cmbtHWND; Title: TString): integer;
    function LlPrinterSetup(ParentHandle: cmbtHWND; ProjectType: word; ProjectName: TString): integer;
    function LlSelectFileDlg(ParentHandle: cmbtHWND; ProjectType: word; var ProjectName: TString): integer;
    function LlSelectFileDlgTitle(ParentHandle: cmbtHWND; Title: TString; ProjectType: word; var ProjectName: TString): integer;
    procedure LlSetDlgboxMode(Mode: cardinal);
    function LlGetDlgboxMode: cardinal;
    function LlSetOption(OptionIndex: integer; Value: lParam): integer;
    function LlGetOption(OptionIndex: integer): integer;
    function LlDesignerProhibitAction(MenuID: integer): integer;
    function LlViewerProhibitAction(Button: TViewerButton): integer;
    function LlPrintEnableObject(ObjectName: TString; Enable: boolean): integer;
    function LlSetFileExtensions(ProjectType: integer; ProjectExtension: TString; PrinterExtension: TString; SketchExtension: TString): integer;
    function LlPrintIsVariableUsed(VariableName: TString): integer;
    function LlPrintIsFieldUsed(FieldName: TString): integer;
    function LlPrintOptionsDialogTitle(ParentHandle: cmbtHWND; Title: TString; DialogText: TString): integer;
    function LlSetPrinterToDefault(ProjectType: integer; ProjectName: TString): integer;
    function LlSetPrinterDefaultsDir(Directory: TString): integer;
    function LlDlgEditLineEx(parentHandle: cmbtHWND;var formularText: TString; fieldType: integer; title: PTChar; useFields: boolean): integer;
    function LlCreateSketch(ProjectType: cardinal; ProjectName: TString): integer;
    function LlDefineSortOrderStart: integer;
    function LlDefineSortOrder(Identifier: TString; Text: TString): integer;
    function LlPrintGetSortOrder(var SortOrder: TString): integer;
    function LlAddCtlSupport(Handle: cmbtHWND; Flags: integer): integer;
    function LlPrintGetFilterExpression(var Expression: TString): integer;
    function LlPrintWillMatchFilter: integer;
    function LlPrintDidMatchFilter: integer;
    function LlGetVariableContents(VariableName: TString; var VariableContent: TString): integer;
    function LlGetFieldContents(FieldName: TString; var FieldContent: TString): integer;
    function LlGetVariableType(VariableName: TString): integer;
    function LlGetFieldType(FieldName: TString): integer;
    function LlDefineSumVariable(VariableName: TString; VariableContent: TString): integer;
    function LlGetOptionString(OptionIndex: integer; var Value: TString): integer;
    function LlDbAddTable(TableName, DisplayName: TString): integer;
    function LlDbAddTableEx(TableName, DisplayName: TString; Options: integer): integer;
    function LlPrintDbGetCurrentTable(var TableName: TString; CompletePath: boolean): integer;
    function LlDbAddTableRelation(TableName, ParentTableName, RelationName, RelationDisplayName: TString): integer;
    function LlDbAddTableRelationEx(TableName, ParentTableName, RelationName, RelationDisplayName: TString; KeyField: TString; ParentKeyField: TString): integer;
    function LlPrintDbGetCurrentTableRelation(var TableRelation: TString): integer;
    function LlDbAddTableSortOrder(TableName, SortOrderName, SortOrderDisplayName: TString): integer;
    function LlPrintDbGetCurrentTableSortOrder(var TableSortOrder: TString): integer;
    function LlDbSetMasterTable(TableName: TString): integer;
    function LlPrintDbGetRootTableCount: integer;
    function LlGetSumVariableContents(VariableName: TString; var VariableContent: TString): integer;
    function LlGetUserVariableContents(VariableName: TString; var VariableContent: TString): integer;
    function LlPreviewDisplayEx(ProjectName: TString; PreviewFilePath: TString; ParentHandle: cmbtHWND; Options: integer): integer;
    function LlPrintCopyPrinterConfiguration(PrinterFileName: TString; FunctionIndex: integer): integer;
    function LlPrintSetOptionString(OptionIndex: integer; Value: TString): integer;
    function LlPrintGetOptionString(OptionIndex: integer; var Value: TString): integer;
    function LlSetOptionString(OptionIndex: integer; Value: TString): integer;
    procedure LlDebugOutput(Indent: integer; Text: TString);
    function LlEnumGetFirstVar(Flags: integer): HLISTPOS;
    function LlEnumGetFirstField(Flags: integer): HLISTPOS;
    function LlEnumGetNextEntry(Pos: HLISTPOS; Flags: integer): HLISTPOS;
    function LlEnumGetEntry(Pos: HLISTPOS; var Name: TString; var Content: TString; var Handle: THandle; var EntryType: integer): integer;
    {$ifdef UNICODE}
    function LlSetPrinterInPrinterFile(ProjectType: cardinal; const ProjectName: TString; PrinterIndex: integer; const PrinterName: TString; const DevModePointer: _PCDEVMODEW): integer;
    {$else}
    function LlSetPrinterInPrinterFile(ProjectType: cardinal; const ProjectName: TString; PrinterIndex: integer; const PrinterName: TString; const DevModePointer: _PCDEVMODEA): integer;
    {$endif}
    function LlXSetParameter(ExtensionType: integer; ExtensionName: TString; Key: TString; Value: TString): integer;
    function LlXGetParameter(ExtensionType: integer; ExtensionName: TString; Key: TString; var Value: TString): integer;
    function LlPrintResetObjectStates: integer;
    function LlPrintResetProjectState: integer;
    function LlDesignerProhibitFunction(FunctionName: TString): integer;
    function LlDefineChartFieldExt(FieldName: TString; Contents: TString; FieldType: integer): integer;
    function LlDefineChartFieldFromTField(Contents: TField):integer;
    procedure LlDefineChartFieldStart;
    function LlPrintDeclareChartRow(Flags: cardinal): integer;
    function LlPrintGetChartObjectCount(Flags: cardinal): integer;
    function LlPrintIsChartFieldUsed(FieldName: TString): integer;
    function LlGetChartFieldContents(FieldName: TString; var Content: TString): integer;
    function LlEnumGetFirstChartField(Flags: integer): HLISTPOS;
    function LlPrintGetRemainingSpacePerTable(FieldName: TString; Dimension: integer): integer;
    procedure AddLlXActionToList(TheAction: TLl17XAction);
    procedure RemoveLlXActionFromList(TheAction: TLl17XAction);
    {$ifdef USELLXOBJECTS}
    procedure AddLlXObjectToList(TheObject: TLl17XObject);
    procedure RemoveLlXObjectFromList(TheObject: TLl17XObject);
    procedure AddLlXFunctionToList(TheFunction: TLl17XFunction);
    procedure RemoveLlXFunctionFromList(TheFunction: TLl17XFunction);
    procedure DeclareLlXObjectsToLL;
    {$endif}
    function LlPrintSetProjectParameter(ParamName, ParamValue: TString; Flag: Longint): integer;
    function LlPrintGetProjectParameter(ParamName: TString; Evaluated: Boolean; var ParamValue: TString; var Flag: _LPUINT): integer;
    function LlGetDefaultProjectParameter(ParamName: TString; var ParamValue: TString; var Flag: _LPUINT): integer;
    function LlGetProjectParameter(ProjectName: TString; ParamName: TString; var ParamValue: TString): integer;
    function LlSetDefaultProjectParameter(ParamName, ParamValue: TString; Flag: Longint): integer;
    function LlDesignerProhibitEditingObject(ObjectName: TString): integer;
    function LlGetUsedIdentifiers(ProjectName: TString; var UsedIdentifiers: TStringList): integer;
    {$ifdef UNICODE}
    function LlGetPrinterFromPrinterFile(ProjectType: Cardinal; ProjectName: TString; PrinterIndex: integer; var Printer: TString; var DevMode: _PDEVMODEW): integer;
    {$else}
    function LlGetPrinterFromPrinterFile(ProjectType: Cardinal; ProjectName: TString; PrinterIndex: integer; var Printer: TString; var DevMode: _PDEVMODEA): integer;
    {$endif}
    function LsMailConfigurationDialog(Handle: cmbtHWND; Subkey: TString; Flags: integer; Language: integer):integer;
    function LlDomGetProject:HLLDOMOBJ;
    property Dictionary: TDictionary read FDictionary write SetDictionary;
    property DesignerWorkspace: TDesignerWorkspace read FDesignerWorkspace write SetDesignerWorkspace;
    function LlDesignerAddAction(actionID: Cardinal; nFlags: Cardinal; menuText: TString; menuHierarchy: TString; tooltipText: TString; iconId: Cardinal; pvReserved: Pointer): integer;
    function LlDesignerGetOptionString(option: integer; var OptionString: TString): integer;
    function LlDesignerSetOptionString(option: integer; OptionString: TString): integer;
    function LlAssociatePreviewControl(PreviewControl: HWND; flags: Cardinal): integer;
    property InplaceDesignerHandle: HWND read FInplaceDesignerHandle write SetInplaceDesignerHandle;
  published
    { Published-Deklarationen }
    property hLlJob: HLLJOB read hTheJob;
    property DebugMode: integer read nDebug write LlSetDebug default 0;
    property IncrementalPreview: integer read FIncrementalPreview write SetIncrementalPreview default 1;
    property EMFResolution: integer read nEMFResolution write SetEmfResolution default 0;
    property Language: TLanguageType read nLanguage write SetLanguage default ltDefaultLang;
    property PreviewAppearance: TPrvAppearance read FPrvAppearance write FPrvAppearance;
    property NewExpressions: TExpressionMode read GetNewExpressions write SetNewExpressions default NewMode;
    property OnlyOneTable: boolean read GetOnlyOneTable write SetOnlyOneTable default False;
    property MultipleTableLines: TPropYesNo read GetMultipleTableLines write SetMultipleTableLines default Yes;
    property AddVarsToFields: TPropYesNo read GetAddVarsToFields write SetAddVarsToFields default No;
    property Supervisor: TPropYesNo read GetOptionSupervisor write SetOptionSupervisor default No;
    property TabStops: TTabMode read GetTabMode write SetTabMode default tmReplace;
    property ConvertCRLF: TPropYesNo read GetConvertCRLF write SetConvertCRLF default Yes;
    property TabRepresentationCode: char read GetTabRepresentationCode write SetTabRepresentationCode default #247;
    property PhantomspaceRepresentationCode: char read GetPhantomspaceRepresentationCode write SetPhantomspaceRepresentationCode default Chr(LL_CHAR_PHANTOMSPACE);
    property LocknextcharRepresentationCode: char read GetLocknextcharRepresentationCode write SetLocknextcharRepresentationCode default Chr(LL_CHAR_LOCK);
    property ExprsepRepresentationCode: char read GetExprsepRepresentationCode write SetExprsepRepresentationCode default Chr(LL_CHAR_EXPRSEP);
    property TextquoteRepresentationCode: char read GetTextquoteRepresentationCode write SetTextquoteRepresentationCode default Chr(LL_CHAR_TEXTQUOTE);
    property RetRepresentationCode: char read GetRetRepresentationCode write SetRetRepresentationCode default #182;
    property HelpAvailable: TPropYesNo read GetHelpAvailable write SetHelpAvailable default Yes;
    property DelayTableHeader: TPropYesNo read GetDelayTableHeader write SetDelayTableHeader default No;
    property OfnDialogExplorer: TPropYesNo read GetOfnDialogExplorer write SetOfnDialogExplorer default Yes;
    property RealTime: TPropYesNo read GetRealTime write SetRealtime default No;
    property SpaceOptimization: TPropYesNo read GetSpaceOptimization  write SetSpaceOptimization default Yes;
    property UseBarcodeSizes: TPropYesNo read GetUseBarcodeSizes write SetUseBarcodeSizes default No;
    property UseHostprinter: TPropYesNo read GetUseHostprinter write SetUseHostprinter default No;
    property VarsCaseSensitive: TPropYesNo read GetVarsCaseSensitive write SetVarsCaseSensitive default Yes;
    property WizFileNew: TPropYesNo read GetWizFileNew write SetWizFileNew default No;
    property MaxRTFVersion: smallint read nMaxRTFVersion write SetMaxRTFVersion default $401;
    property SupportPageBreak: TPropYesNo read GetSupportPageBreak write SetSupportPageBreak default Yes;
    property SortVariables: TPropYesNo read GetSortVariables write SetSortVariables default No;
    property ShowPredefVars: TPropYesNo read GetShowPredefVars write SetShowPredefVars default Yes;
    property TableColoringMode: TPropTableColoring read GetTableColoringMode write SetTableColoringMode default tcNormal;
    property UnitSystem: TPropUnitSystem read GetMetric write SetMetric default usHiMetric;
    property StorageSystem: TPropStgSystem read GetStorageSystem write SetStorageSystem default syStorage;
    property CompressStorage: TPropYesNo read GetCompressStorage write SetCompressStorage default No;
    property NoParameterCheck: TPropYesNo read GetNoParameterCheck write SetNoParameterCheck default No;
    property NoNoTableCheck: TPropYesNo read GetNoNoTableCheck write SetNoNoTableCheck  default Yes;
    property DialogBoxMode: TDialogBoxMode read GetDialogBoxMode write SetDialogBoxMode default dmOffice2003;
    property Buttons3D: TPropYesNo read GetButtons3D write SetButtons3D;
    property ButtonsWithBitmaps: TPropYesNo read GetButtonsWithBitmaps write SetButtonsWithBitmaps;
    property XlatVarNames: TPropYesNo read GetXlatVarNames write SetXlatvarNames default Yes;
    property CreateInfo: TPropYesNo read GetCreateInfo write SetCreateInfo default Yes;
    property InterCharSpacing: TPropYesNo read GetInterCharSpacing write SetInterCharSpacing default No;
    property IncludeFontDescent: TPropYesNo read GetIncludeFontDescent write SetIncludeFontDescent default Yes;
    property UseChartFields: TPropYesNo read GetUseChartFields write SetUseChartFields default No;
    property LicensingInfo: string read sLicensingInfo write SetLicensingInfo;
    property ProjectPassword: string read sProjectPassword write SetProjectPassword;
    property OnTableField: TTableFieldEvent read FOnTableFieldCallback write FOnTableFieldCallback;
    property OnTableLine: TTableLineEvent read FOnTableLineCallback write FOnTableLineCallback;
    property OnDrawUserobj: TDrawUserobjEvent read FOnDrawUserobjCallback write FOnDrawUserobjCallback;
    property OnEditUserobj: TEditUserobjEvent read FOnEditUserobjCallback write FOnEditUserobjCallback;
    property OnPage: TPageEvent read FOnPageCallback write FOnPageCallback;
    property OnProject: TProjectEvent read FOnProjectCallback write FOnProjectCallback;
    property OnObject: TObjectEvent read FOnObjectCallback write FOnObjectCallback;
    property OnExtFct: TEvaluateEvent read FOnExtFctCallback write FOnExtFctCallback;
    property OnFailsFilter: TFailsFilterEvent read FOnFailsFilterCallback write FOnFailsFilterCallback;
    property OnHelp: THelpEvent read FOnHelpCallback write FOnHelpCallback;
    property OnEnableMenu: TEnableMenuEvent read FOnEnableMenuCallback write FOnEnableMenuCallback;
    property OnModifyMenu: TModifyMenuEvent read FOnModifyMenuCallback write FOnModifyMenuCallback;
    property OnSelectMenu: TSelectMenuEvent read FOnSelectMenuCallback write FOnSelectMenuCallback;
    property OnGetViewerButtonState: TGetViewerButtonStateEvent read FOnGetViewerButtonStateCallback write FOnGetViewerButtonStateCallback;
    property OnViewerButtonClicked: TViewerButtonClickedEvent read FOnViewerButtonClickedCallback write FOnViewerButtonClickedCallback;
    property OnVarHelpText: TVarHelpTextEvent read FOnVarHelpTextCallback write FOnVarHelpTextCallback;
    property OnNtfyProgress: TMeterInfoEvent  read FOnNtfyProgressCallback write FOnNtfyProgressCallback;
    property OnHostPrinter: THostPrinterEvent read FOnHostPrinterCallback write FOnHostPrinterCallback;
    property OnDlgExprVarBtn: TDlgExprVarBtnEvent read FOnDlgExprVarBtnCallback write FOnDlgExprVarBtnCallback;
    property OnDefineVariables: TDefineVariablesEvent read FOnDefineVariablesCallback write FOnDefineVariablesCallback;
    property OnDefineFields: TDefineFieldsEvent read FOnDefineFieldsCallback write FOnDefineFieldsCallback;
    property OnSetPrintOptions: TSetPrintOptionsEvent read FOnSetPrintOptionsEvent write FOnSetPrintOptionsEvent;
    property OnPrintJobInfo: TPrintJobInfoEvent read FOnPrintJobInfo write FOnPrintJobInfo;
    property OnExprError: TNtfyErrorEvent read FOnExprError write FOnExprError;
    property OnSaveFileName: TSaveFileNameEvent read FOnSaveFileName write FOnSaveFileName;
    property OnProjectLoaded: TProjectLoadedEvent read FOnProjectLoaded write FOnProjectLoaded;
    property OnDesignerPrintJob: TDesignerPrintJobEvent read FOnDesignerPrintJob write FOnDesignerPrintJob;
    property OnDrillDownJob: TDrillDownJobEvent read FOnDrillDownJob write FOnDrillDownJob;
  end;

  TDicData = class(TObject)
  private
    FLCIDList: TLongintList;
    FKeyListList: TList;
    FValueListList: TList;
    FParentObj: TL17_;
    FDictionaryType: TDictionaryType;

    function GetKeyList(LCID: integer): TStringList;
    function GetValueList(LCID: integer): TStringList;
    function GetLCIDList: TLongintList;
  public
    constructor Create(ParentObj: TL17_; DictionaryType: TDictionaryType);
    destructor Destroy; override;
    procedure Clear();
    procedure Add(Key, Value: TString); overload; virtual;
    procedure Add(Key, Value: TString; LCID: integer); overload; virtual;
    function GetValue(Key: TString; var Value: TString): boolean; overload;
    function GetValue(Key: TString; var Value: TString; LCID: integer): boolean; overload;
    property KeyList[LCID: integer]: TStringList read GetKeyList;
    property ValueList[LCID: integer]: TStringList read GetValueList;
    property LCIDList: TLongintList read GetLCIDList;
  end;

  TDicFields = class(TDicData)
  public
    procedure AddComplexItems(Value: TString); overload;
    procedure AddComplexItems(Value: TString; LCID: integer); overload;
  end;


  TDictionary = class(TObject)
  private
    FFields: TDicFields;
    FTables: TDicData;
    FRelations: TDicData;
    FSortOrders: TDicData;
    FParentObj: TL17_;
    FStaticTexts: TDicData;
    procedure SetRelations(const Value: TDicData);
    procedure SetFields(const Value: TDicFields);
    procedure SetTables(const Value: TDicData);
    procedure SetStaticTexts(const Value: TDicData);
    procedure SetSortOrders(const Value: TDicData);
  public
    property Fields: TDicFields read FFields write SetFields;
    property Tables: TDicData read FTables write SetTables;
    property Relations: TDicData read FRelations write SetRelations;
    property SortOrders: TDicData read FSortOrders write SetSortOrders;
    property StaticTexts: TDicData read FStaticTexts write SetStaticTexts;
    constructor Create(ParentObj: TL17_);
    destructor Destroy; override;
    procedure Clear;
  end;

  TProhibitedAction = class(TObject)
  public
    FProhibitedActionList: TStringList;
    FParentObj: TL17_;
    procedure Add(Value: TLlDesignerAction);
    constructor Create(ParentObj: TL17_);
    destructor Destroy; override;
  end;

  TProhibitedFunction = class(TObject)
  public
    FProhibitedFunctionList: TStringList;
    FParentObj: TL17_;
    procedure Add(Value: TString);
    constructor Create(ParentObj: TL17_);
    destructor Destroy; override;
  end;

  TReadOnlyObject = class(TObject)
  private
    FReadOnlyObjectList: TStringList;
    FParentObj: TL17_;
  public
    procedure Add(Value: TString);
    constructor Create(ParentObj: TL17_);
    destructor Destroy; override;
  end;

  TDesignerLanguages = class(TObject)
  private
    FParentObj: TL17_;

  public
    constructor Create(ParentObj: TL17_);
    procedure Add(LCID: integer);
    procedure Clear();
  end;

  TDesignerWorkSpace = class(TObject)
  private
    FParentObj: TL17_;
    FProhibitedAction: TProhibitedAction;
    FProhibitedFunction: TProhibitedFunction;
    FReadOnlyObject: TReadOnlyObject;
    FDesignerLanguages: TDesignerLanguages;
    procedure SetProjectName(const Value: TString);
    function GetProjectName: TString;
    function GetCaption: TString;
    procedure SetCaption(const Value: TString);
    procedure SetProhibitedAction(const Value: TProhibitedAction);
    procedure SetProhibitedFunction(const Value: TProhibitedFunction);
    procedure SetReadOnlyObject(const Value: TReadOnlyObject);
  public
    function InvokeAction(menuId: integer): integer;
    function Open(filename: TString; filemode: TLlDesignerWorkspaceFileMode; savemode: TLlDesignerWorkspaceSaveMode): integer;
    function Refresh: integer;
    function Save: integer;
    property Caption: TString read GetCaption write SetCaption;
    property ProhibitedAction: TProhibitedAction read FProhibitedAction write SetProhibitedAction;
    property ProhibitedFunction: TProhibitedFunction read FProhibitedFunction write SetProhibitedFunction;
    property ProjectName: TString read GetProjectName write SetProjectName;
    property ReadOnlyObject: TReadOnlyObject read FReadOnlyObject write SetReadOnlyObject;
    property DesignerLanguages: TDesignerLanguages read FDesignerLanguages;
    constructor Create(ParentObj: TL17_);
    destructor Destroy; override;
  end;

  TLl17HelperClass = class
  public
    class function Split(Text: TString;Seperator: TChar;fTrim: Boolean;Quotes: Boolean):TStringList;
    class procedure FreeList(List: TList);
    class function PWideToString(pw : PWideChar) : AnsiString;
    class procedure CopyToBuffer(source: TString ; dest: PTChar; maxLen: integer) ;
  end;

  TLl17MailJob = class
  private
    FMailTo: TString;
    FMailJob: integer;
    FMailCC: TString;
    FMailBCC: TString;
    FMailSubject: TString;
    FShowDialog: boolean;
    FMailBody: TString;
    FMailBodyHTML: TString;
    FMailProvider: TString;
    FMailAttachment: TString;
    procedure SetMailTo(const Value: TString);
    procedure SetMailJob(const Value: integer);
    procedure SetMailCC(const Value: TString);
    procedure SetMailBCC(const Value: TString);
    procedure SetMailSubject(const Value: TString);
    procedure SetShowDialog(const Value: boolean);
    procedure SetMailBody(const Value: TString);
    procedure SetMailBodyHTML(const Value: TString);
    procedure SetMailProvider(const Value: TString);
    procedure SetMailAttachment(const Value: TString);
  protected
    MailAttachmentList: TStringList;
    property MailJob: integer read FMailJob write SetMailJob;
  public
    constructor create;
    destructor Destroy; override;
    property ShowDialog: boolean read FShowDialog write SetShowDialog;
    property MailTo: TString read FMailTo write SetMailTo;
    property MailCC: TString read FMailCC write SetMailCC;
    property MailBCC: TString read FMailBCC write SetMailBCC;
    property MailSubject: TString read FMailSubject write SetMailSubject;
    property MailBody: TString read FMailBody write SetMailBody;
    property MailBodyHTML: TString read FMailBodyHTML write SetMailBodyHTML;
    property MailProvider: TString read FMailProvider write SetMailProvider;
    property MailAttachment: TString read FMailAttachment write SetMailAttachment;
    procedure Send(hwnd: HWND);
  end;

  TLl17ExprEvaluator = class
  private
    FExprPointer: HLLEXPR;
    FParent: TL17_;
    FErrorValue: integer;
    FExprType: integer;
    FErrorText: TString;
    FResult: TString;
    FExpression: TString;
    procedure SetExpression(const Value: TString);
  public
    constructor Create(Parent: TL17_; Expression: TString; IncludeTablefields: boolean);
    destructor Destroy; override;
    property ErrorText: TString read FErrorText;
    property Result: TString read FResult;
    property ErrorValue: integer read FErrorValue;
    property ExprType: integer read FExprType;
    property Expression: TString read FExpression write SetExpression;
    procedure EditExpression(title: TString);
  end;


  TLl17PreviewPage = class
  private
    FHandle: HLLSTG;
    FPageIndex: integer;
    procedure SetJobName(const Value: TString);
    function GetCreationApp: TString;
    function GetCreationDLL: TString;
    function GetCreationUser: TString;
  protected
    function GetCopies: integer;
    function GetCreation: TString;
    function GetJobName: TString;
    function GetPageIndex: integer;
    function GetProjectFileName: TString;
    function GetOrientation: integer;
    function GetPrintablePageOffset: TSize;
    function GetPrintablePageSize: TSize;
    function GetPrinterDevice: TString;
    function GetPrinterName: TString;
    function GetPrinterPhysicalPage: boolean;
    function GetPhysicalPageSize: TSize;
    function GetPrinterPort: TString;
    function GetPrinterResolution: TSize;
    function GetUserValue: TString;
    procedure SetUserValue(Value: TString);
    function GetOptionValue(OptionIndex: integer): integer;
    function GetOptionString(OptionIndex: integer): TString;

  public
    function GetMetafile: TMetafile;
    procedure Draw(Canvas: TCanvas; Rect: TRect; ResolutionCorrection: boolean);
    constructor Create(FileHandle: HLLSTG; PageIndex: integer);
    property Copies: integer read GetCopies;
    property Creation: TString read GetCreation;
    property CreationApp: TString read GetCreationApp;
    property CreationDLL: TString read GetCreationDLL;
    property CreationUser: TString read GetCreationUser;
    property PageIndex: integer read GetPageIndex;
    property ProjectFileName: TString read GetProjectFileName;
    property JobName: TString read GetJobName write SetJobName;
    property Orientation: integer read GetOrientation;
    property PrintablePageOffset: TSize read GetPrintablePageOffset;
    property PrintablePageSize: TSize read GetPrintablePageSize;
    property PrinterName: TString read GetPrinterName;
    property PrinterDevice: TString read GetPrinterDevice;
    property PrinterPort: TString read GetPrinterPort;
    property PrinterResolution: TSize read GetPrinterResolution;
    property PrinterPhysicalPage: boolean read GetPrinterPhysicalPage;
    property PhysicalPageSize: TSize read GetPhysicalPageSize;
    property UserValue: TString read GetUserValue write SetUserValue;
  end;



  TLl17PreviewFile = class

  private
    FHandle: HLLSTG;
  protected
    function GetPageCount: integer;
    function GetPage(const Index: integer): TLl17PreviewPage;
  public
    property PageCount: integer read GetPageCount;
    property Page[const Index: integer]: TLl17PreviewPage read GetPage; default;
    property Handle: HLLSTG read FHandle;
    constructor Create(FileName: TString; ReadOnly: boolean);
    destructor Destroy; override;
    procedure Append(FileToAppend: TLl17PreviewFile);
    procedure Print(PrinterFirstPage: TString; PrinterFollowingPages: TString;
      StartPage: integer; EndPage: integer; Copies: integer; Flags: integer;
      MessageText: TString; ParentHandle: cmbtHWND);
    function ConvertTo(TargetFileName: TString; TargetFormat: TString): integer;
    procedure Delete;
  end;

  TLlRTFTextMode = (tmRTF, tmPlain);
  TLlRTFContentMode = (cmRaw, cmEvaluated);
  TLlRTFPrintState = (psPending, psFinished);
  TLl17PreviewControl = class;

  TLl17PreviewButtons=class(TPersistent)
  private
    FPrintToFax: TButtonState;
    FPrintAllPages: TButtonState;
    FGotoFirst: TButtonState;
    FSendTo: TButtonState;
    FPrintCurrentPage: TButtonState;
    FGotoPrev: TButtonState;
    FGotoLast: TButtonState;
    FExit: TButtonState;
    FSaveAs: TButtonState;
    FGotoNext: TButtonState;
    FZoomTimes2: TButtonState;
    FZoomRevert: TButtonState;
    FZoomReset: TButtonState;
    FParentComponent: TLl17PreviewControl;
    FPageCombo: TButtonState;
    FZoomCombo: TButtonState;
    FSearchStart: TButtonState;
    FSearchNext: TButtonState;
    FSearchOptions: TButtonState;
    FSearchText: TButtonState;
    FSlideShowMode: TButtonState;
    procedure SetExit(const Value: TButtonState);
    procedure SetGotoFirst(const Value: TButtonState);
    procedure SetGotoLast(const Value: TButtonState);
    procedure SetGotoNext(const Value: TButtonState);
    procedure SetGotoPrev(const Value: TButtonState);
    procedure SetPrintAllPages(const Value: TButtonState);
    procedure SetPrintCurrentPage(const Value: TButtonState);
    procedure SetPrintToFax(const Value: TButtonState);
    procedure SetSaveAs(const Value: TButtonState);
    procedure SetSendTo(const Value: TButtonState);
    procedure SetZoomReset(const Value: TButtonState);
    procedure SetZoomRevert(const Value: TButtonState);
    procedure SetZoomTimes2(const Value: TButtonState);
    procedure SetPageCombo(const Value: TButtonState);
    procedure SetZoomCombo(const Value: TButtonState);
    procedure SetSearchStart(const Value: TButtonState);
    procedure SetSearchNext(const Value: TButtonState);
    procedure SetSearchOptions(const Value: TButtonState);
    procedure SetSearchText(const Value: TButtonState);

    procedure SetSlideShowMode(const Value: TButtonState);
  public
    constructor create(AParent: TLl17PreviewControl);
  published
    property GotoFirst: TButtonState read FGotoFirst write SetGotoFirst;
    property GotoPrev: TButtonState read FGotoPrev write SetGotoPrev;
    property GotoNext: TButtonState read FGotoNext write SetGotoNext;
    property GotoLast: TButtonState read FGotoLast write SetGotoLast;
    property ZoomTimes2: TButtonState read FZoomTimes2 write SetZoomTimes2;
    property ZoomRevert: TButtonState read FZoomRevert write SetZoomRevert;
    property ZoomReset: TButtonState read FZoomReset write SetZoomReset;
    property PrintCurrentPage: TButtonState read FPrintCurrentPage write SetPrintCurrentPage;
    property PrintAllPages: TButtonState read FPrintAllPages write SetPrintAllPages;
    property PrintToFax: TButtonState read FPrintToFax write SetPrintToFax;
    property SendTo: TButtonState read FSendTo write SetSendTo;
    property SaveAs: TButtonState read FSaveAs write SetSaveAs;
    property Exit: TButtonState read FExit write SetExit;
    property PageCombo: TButtonState read FPageCombo write SetPageCombo;
    property ZoomCombo: TButtonState read FZoomCombo write SetZoomCombo;
    property SlideShowMode: TButtonState read FSlideShowMode write SetSlideShowMode;
    property SearchStart: TButtonState read FSearchStart write SetSearchStart;
    property SearchNext: TButtonState read FSearchNext write SetSearchNext;
    property SearchOptions: TButtonState read FSearchOptions write SetSearchOptions;
    property SearchText: TButtonState read FSearchText write SetSearchText;

  end;

  TPageChangedEvent = procedure(Sender: TObject; NewPageIndex: integer) of object;
  TButtonClickedEvent = procedure(Sender: TObject; ButtonID: integer; var IsHandled: boolean) of object;


  TLl17PreviewControl = class(TCustomControl)
  private
    FFileName: TString;
    FShowToolbar: boolean;
    FToolbarButtons: TLl17PreviewButtons;
    FInitializing: boolean;
    FNotifyProc: TFarProc;
    FBackgroundColor: TColor;
    FSaveAsFilePath: TString;
    FOnPageChanged: TPageChangedEvent;
    FOnButtonClicked: TButtonClickedEvent;
    FShowThumbnails: boolean;
    FLanguage: TLanguageType;
    FhLlJob: integer;
    FCloseMode: TCloseMode;
    FShowUnprintableArea: boolean;
    procedure SetLanguage(const Value: TLanguageType);
    procedure SetFileName(const Value: TString);
    procedure SetShowToolbar(const Value: boolean);
    procedure SetToolbarButtons(const Value: TLl17PreviewButtons);
    procedure SetBackgroundColor(const Value: TColor);
    procedure SetSaveAsFilePath(const Value: TString);
    function GetCurrentPage: integer;
    function GetPageCount: integer;
    procedure SetOnButtonClicked(const Value: TButtonClickedEvent);
    procedure SetShowThumbnails(const Value: boolean);
    procedure SetCloseMode(const Value: TCloseMode);
    procedure SetShowUnprintableArea(const Value: boolean);
  protected
    procedure CreateWnd; override;
    procedure DestroyWindowHandle; override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWindowHandle(const Params: TCreateParams); override;
    procedure RefreshOptions;
    procedure QuestButtonState(ButtonID: integer; var Result: integer);
  public
    destructor Destroy; override;
    constructor Create(AOwner: TComponent); override;
    procedure ZoomTimes2;
    procedure ZoomRevert;
    procedure ZoomReset;
    procedure PrintCurrentPage(ShowPrintOptions: boolean);
    procedure PrintAllPages(ShowPrintOptions: boolean);
    procedure GotoFirst;
    procedure GotoLast;
    procedure GotoPrevious;
    procedure GotoNext;
    procedure SaveAs;
    procedure SetZoom(Percentage: integer);
    procedure SetSlideShowMode;
    procedure RefreshToolbar;
    procedure SetOptionString(Option: TString; Value: TString);
    procedure Attach(FParentComponent: TL17_; nFlags: Cardinal);
    procedure Detach;
    procedure SearchFirst(SearchString: TString; CaseSensitive: Boolean);
    procedure SearchNext;
    function GetActualButtonState(ButtonID: integer):integer;
    function GetOptionString(Option: TString): TString;
    function CanClose: boolean;
  published
    Property Align;
    Property TabStop;
    Property TabOrder;
    property OnEnter;
    property OnExit;
    property OnPageChanged: TPageChangedEvent read FOnPageChanged write FOnPageChanged;
    property OnButtonClicked: TButtonClickedEvent read FOnButtonClicked write SetOnButtonClicked;

    property SaveAsFilePath: TString read FSaveAsFilePath write SetSaveAsFilePath;
    property InputFileName: TString read FFileName write SetFileName;
    property ShowToolbar: boolean read FShowToolbar write SetShowToolbar;
    property ShowThumbnails: boolean read FShowThumbnails write SetShowThumbnails;
    property ToolbarButtons: TLl17PreviewButtons read FToolbarButtons write SetToolbarButtons;
    property BackgroundColor: TColor read FBackgroundColor write SetBackgroundColor default clWhite;
    property CurrentPage: integer read GetCurrentPage;
    property PageCount: integer read GetPageCount;
    property Language: TLanguageType read FLanguage write SetLanguage;
    property CloseMode: TCloseMode read FCloseMode write SetCloseMode;
    property ShowUnprintableArea: boolean read FShowUnprintableArea write SetShowUnprintableArea;
  end;

  TLl17RTFObject = class(TCustomControl)
  private
    FHandle: HLLRTFOBJ;
    FContentMode: TLlRTFContentMode;
    FPrintState: TLlRTFPrintState;
    FTextMode: TLlRTFTextMode;
    FMyParentComponent: TL17_;
    FFirst: boolean;
    procedure SetContentMode(const Value: TLlRTFContentMode);
    procedure SetPrintState(const Value: TLlRTFPrintState);
    procedure SetText(const Value: TString);
    procedure SetTextMode(const Value: TLlRTFTextMode);
    function GetText: TString;
    procedure SetMyParentComponent(const Value: TL17_);

  protected
    procedure WndProc(var Message: TMessage); override;  
  public
    destructor Destroy; override;
    constructor Create(AOwner: TComponent); override;
    procedure CreateWnd; override;
    property Text: TString read GetText write SetText;
    property PrintState: TLlRTFPrintState read FPrintState write SetPrintState;
    function ProhibitAction(ControlID: integer):integer;
  published
    property TabStop;
    property TabOrder;
    Property Align;
    property ParentComponent: TL17_ read FMyParentComponent write SetMyParentComponent;
    function CopyToClipboard: integer;
    function Display(Canvas: TCanvas; Rect: TRect; FromStart: boolean): integer;
    property TextMode: TLlRTFTextMode read FTextMode write SetTextMode;
    property ContentMode: TLlRTFContentMode read FContentMode write SetContentMode;
  end;

  {$ifdef USELLXOBJECTS}
  TLl17PropertyMap = class
  protected
    FKeyList: TStringList;
    FValueList: TStringList;
  public
    constructor create;
    constructor CreateCopy(Base: TLl17PropertyMap);
    destructor Destroy; override;
    procedure AddProperty(Key, Value: String);
    procedure SaveToStream(const Stream: IStream);
    procedure LoadFromStream(const Stream: IStream);
    function ContainsKey(Key: String): boolean;
    procedure RemoveProperty(Key: String);
    function GetValue(Key: String; var Value: String): boolean;
  end;


  TLl17XObjectPrintState = (llxpsWaiting, llxpsUnfinished, llxpsFinished, llxpsPastFinished);
  TCreateObjectEvent = procedure(Sender:TObject; ParentHandle: cmbtHWND) of object;
  TEditObjectEvent = procedure(Sender:TObject; ParentHandle: cmbtHWND; var HasChanged: Boolean) of object;
  TDrawObjectEvent = procedure(Sender:TObject; Canvas: TCanvas; Rect: TRect; IsDesignMode: boolean; var IsFinished: boolean) of object;
  TClickEvent = procedure(Sender: TObject; Canvas: TCanvas; Point: TPoint; ParentHandle: cmbtHWND) of object;
  TGetVariableSizeInfoEvent = procedure(Sender: TObject; const hDC: HDC; const Width: integer; var MinimumHeight, IdealHeight: integer) of object;
  TResetPrintStateEvent = procedure(Sender: TObject) of object;
  {$endif}
  TLl17XActionInsertionType=(itAppend, itInsert);
  TLl17XActionLlActionState=(asEnabled, asDisabled);
  TExecuteActionEvent = procedure of object;
  TGetActionStateEvent = procedure(var state: TLl17XActionLlActionState) of object;
  {$ifdef USELLXOBJECTS}
  TLl17XFunctionParameterType=(ptAll, ptDouble,ptDate,ptBool,ptString,ptDrawing,ptBarcode);
  TEvaluateFunctionEvent = procedure(Sender:TObject; var ResultType: TLl17XFunctionParameterType; var ResultValue: OleVariant; var DecimalPositions: integer; const ParameterCount: Integer; const Parameter1,Parameter2,Parameter3,Parameter4: OleVariant) of object;
  TParameterAutoCompleteEvent = procedure(Sender: TObject; ParameterIndex: integer; var Values: TStringList) of object;
  TCheckFunctionSyntaxEvent = procedure(Sender:TObject; var IsValid: bool; var ErrorText: String; var ResultType: TLl17XFunctionParameterType; var DecimalPositions: integer; const ParameterCount: Integer; const Parameter1,Parameter2,Parameter3,Parameter4: OleVariant) of object;

  TLl17XFunctionParameter=class(TPersistent)
  private
    FParameterDescription: String;
    FParameterType: TLl17XFunctionParameterType;
    procedure SetParameterDescription(const Value: String);
    procedure SetParameterType(const Value: TLl17XFunctionParameterType);
  published
    property ParameterType: TLl17XFunctionParameterType read FParameterType write SetParameterType;
    property ParameterDescription: String read FParameterDescription write SetParameterDescription;
  end;



  TLl17XFunction=class(TComponent,ILlXFunction,IUnknown)
  private
    FParentComponent: TL17_;
    FILlBase: pILlBase;
    FLLJob: HLLJOB;
    FRefCount: Integer;
    FLanguage: integer;
    FHLib : Integer;

    FMaximumParameters: integer;
    FMinimumParameters: integer;
    FParameter1: TLl17XFunctionParameter;
    FParameter2: TLl17XFunctionParameter;
    FParameter3: TLl17XFunctionParameter;
    FParameter4: TLl17XFunctionParameter;
    FResultType: TLl17XFunctionParameterType;
    FVisible: boolean;
    FGroupName: String;
    FFunctionName: String;
    FDescription: String;
    FOnCheckFunctionSyntax: TCheckFunctionSyntaxEvent;
    FOnEvaluateFunction: TEvaluateFunctionEvent;
    FOnParameterAutoComplete: TParameterAutoCompleteEvent;
    procedure SetMaximumParameters(const Value: integer);
    procedure SetMinimumParameters(const Value: integer);
    procedure SetParameter1(const Value: TLl17XFunctionParameter);
    procedure SetParameter2(const Value: TLl17XFunctionParameter);
    procedure SetParameter3(const Value: TLl17XFunctionParameter);
    procedure SetParameter4(const Value: TLl17XFunctionParameter);
    procedure SetResultType(const Value: TLl17XFunctionParameterType);
    procedure SetMyParentComponent(const Value: TL17_);
    procedure SetFunctionName(const Value: String);
    procedure SetGroupName(const Value: String);
    procedure SetVisible(const Value: boolean);
    procedure SetDescription(const Value: String);
    procedure SetOnCheckFunctionSyntax(const Value: TCheckFunctionSyntaxEvent);
    procedure SetOnEvaluateFunction(const Value: TEvaluateFunctionEvent);
    procedure SetOnParameterAutoComplete(const Value: TParameterAutoCompleteEvent);
  protected
    function GetParameterTypeText(Value: TLl17XFunctionParameterType):String;
    function GetLlFctparaTypeFromParamType(Value: TLl17XFunctionParameterType): integer;
    function GetLlFieldTypeFromParamType(Value: TLl17XFunctionParameterType): integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function QueryInterface(const IID: TGUID; out Obj): HResult; override; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    function SetLLJob(hLLJob: HLLJob; pInfo: pILlBase): HResult; stdcall;
    function SetOption (const nOption, nValue: integer): HResult;  stdcall;
    function GetOption (const nOption: integer; var pnValue: integer): HResult; stdcall;
    function GetName(var pbsName: OLEString): HResult; stdcall;  // get name.
    function GetDescr(var pbsDescr: OLEString):HResult; stdcall; // get description
    function GetGroups(var pbsDescr: OLEString):HResult;  stdcall;
    function GetGroupDescr(const bsGroup:OLEString; var pbsDescr:OLEString): HResult; stdcall;
    function GetParaCount(var pnMinParas,pnMaxParas: integer): HResult; stdcall;
    function GetParaTypes(var pnTypeRes, pnTypeArg1, pnTypeArg2, pnTypeArg3, pnTypeArg4: integer): HResult; stdcall;
    function CheckSyntax(var pbsError: OLEString; var pnTypeRes: integer; var pnTypeResLL: cardinal; var pnDecs: cardinal; const nArgs: cardinal; VarArg1,VarArg2,VarArg3,VarArg4: OleVariant): HResult; stdcall;
    function Execute(var pVarRes: OleVariant; var pnTypeRes: integer; var pnTypeResLL: cardinal; var pnDecs: cardinal; const nArgs: cardinal; VarArg1,VarArg2,VarArg3,VarArg4: OleVariant) : HResult; stdcall;
    function GetVisibleFlag(var pbVisible: boolean) : HResult; stdcall;
    function GetParaValueHint(const nPara: integer; var pbsHint,pbsTabbedList: OLEString): HResult; stdcall;// nPara = 0..3
  published
    property MinimumParameters: integer read FMinimumParameters write SetMinimumParameters;
    property MaximumParameters: integer read FMaximumParameters write SetMaximumParameters;
    property ResultType: TLl17XFunctionParameterType read FResultType write SetResultType;
    property Parameter1: TLl17XFunctionParameter read FParameter1 write SetParameter1;
    property Parameter2: TLl17XFunctionParameter read FParameter2 write SetParameter2;
    property Parameter3: TLl17XFunctionParameter read FParameter3 write SetParameter3;
    property Parameter4: TLl17XFunctionParameter read FParameter4 write SetParameter4;
    property ParentComponent: TL17_ read FParentComponent write SetMyParentComponent;
    property FunctionName: String read FFunctionName write SetFunctionName;
    property Description: String read FDescription write SetDescription;
    property GroupName: String read FGroupName write SetGroupName;
    property Visible: boolean read FVisible write SetVisible;
    property OnEvaluateFunction: TEvaluateFunctionEvent read FOnEvaluateFunction write SetOnEvaluateFunction;
    property OnParameterAutoComplete: TParameterAutoCompleteEvent read FOnParameterAutoComplete write SetOnParameterAutoComplete;
    property OnCheckFunctionSyntax: TCheckFunctionSyntaxEvent read FOnCheckFunctionSyntax write SetOnCheckFunctionSyntax;
  end;

  TLl17XObject=class(TComponent,ILlXObject,IUnknown)
  private
    FParentComponent: TL17_;
    FFontHandle: THandle;
    FFontColor: TColor;
    FFontSize: integer;
    FCommandHandlerList: TList;
    FPrintState: TLl17XObjectPrintState;
    FOnClick: TClickEvent;
    FPopupMenu: TPopupMenu;
    FHint: String;
    FOnGetVariableSizeInfo: TGetVariableSizeInfoEvent;
    FSupportsMultipage: boolean;
    FOnResetPrintState: TResetPrintStateEvent;
    procedure SetMyParentComponent(const Value: TL17_);
    procedure SetOnClick(const Value: TClickEvent);
    procedure SetPopupMenu(const Value: TPopupMenu);
    procedure SetHint(const Value: String);
    procedure SetOnGetVariableSizeInfo(const Value: TGetVariableSizeInfoEvent);
    procedure SetSupportsMultipage(const Value: boolean);
    procedure SetOnResetPrintState(const Value: TResetPrintStateEvent);
  protected
    FRefCount: Integer;
    FILlXObjectNtfySink: pILlXObjectNtfySink ;
    FILlBase: pILlBase;
    FLLJob: HLLJOB;
    FIsCopy: boolean;

    FObjectName: String;
    FDescription: String;
    FOnInitialCreation: TCreateObjectEvent;
    FOnDraw: TDrawObjectEvent;
    FOnEdit: TEditObjectEvent;
    FIcon: TIcon;
    procedure SetDescription(const Value: String);
    procedure SetIcon(const Value: TIcon);
    procedure SetObjectName(const Value: String);
    procedure SetOnDraw(const Value: TDrawObjectEvent);
    procedure SetOnEdit(const Value: TEditObjectEvent);
    procedure SetOnInitialCreation(const Value: TCreateObjectEvent);
  public
      Properties: TLl17PropertyMap;
      constructor Create(AOwner: TComponent); override;
      constructor CreateCopy(AOwner:TComponent; Base: TLl17XObject);
      destructor Destroy; override;
      function QueryInterface(const IID: TGUID; out Obj): HResult; override; stdcall;
      function _AddRef: Integer; stdcall;
      function _Release: Integer; stdcall;
      function SetLLJob(hLLJob: HLLJob; pInfo: pILlBase): HResult; stdcall;
      function GetName(var pbsName: OLEString): HResult; stdcall;  // get name.
      function GetDescr(var pbsDescr: OLEString):HResult; stdcall; // get description
      function GetIcon(var phIcon: HIcon):HResult; stdcall;// get icon (must be released by LLX object)
      function IsProjectSupported(const nProjType: integer; var pbSupported: boolean): HResult;stdcall; // is project type (LL_PROJECT_xxx) supported
      function SetOption (const nOption, nValue: integer): HResult; stdcall;
      function GetOption (const nOption: integer; var pnValue: integer): HResult;stdcall;
      function SetOptionString(const sOption: OLEString; sText:OLEString): HResult;stdcall;
      function GetOptionString(const sOption: OLEString; var psText:OLEString): HResult;stdcall;
      function SetParameters(pIStream: IStream): HResult;stdcall;
      function GetParameters(pIStream: IStream ): HResult; stdcall;
      function Clone (var pIObject):HResult; stdcall;
      function FirstCreation(const hWndParent: cmbtHWND):HResult; stdcall;// Wizard?
      function GetMinDimensionsSCM(const bForNew: boolean; var ptMinSize: Size):HResult; stdcall;
      function Show(const hDC: HDC; var prcPaint: TRect; const hExportProfJob: HPROFJOB; const hExportProfList: HPROFLIST; const nExportVerbosity: integer; const nDestination: integer; const bSelected: boolean):HResult ;stdcall;
      function GetTrueRec(var prc: TRect):HResult ;stdcall;	// label, card projects only :-)
      function GetErrorcode: longint;stdcall;
      function AllowPageBreak:HResult ;stdcall;
      function ResetPrintState:HResult ;stdcall;
      function ForceResetPrintState:HResult ;stdcall;
      function PrintWaiting:HResult ;stdcall;
      function PrintUnfinished:HResult ;stdcall;
      function PrintFinished:HResult ;stdcall;
      function PrintPastFinished:HResult ;stdcall;
      function SetNtfySink(pNtfySink: pILlXObjectNtfySink):HResult ;stdcall; // must inc ref count and release when finished
      function Edit(const hWnd: cmbtHWND;ptMouse: TPoint):HResult ;stdcall;// S_FALSE for aborted, pNtfySink may be NULL!!!
      function ClearEditPartInfo:HResult ;stdcall;
      function CanEditPart(ptMouse: TPoint; var phMenu: hMenu):HResult ;stdcall; // item ID 10000 ff
      function EditPart(const hWnd: cmbtHWND;ptMouse: TPoint; const nMenuID: cardinal):HResult ;stdcall;
      function CancelEditPart:HResult ;stdcall;
      function OnDragDrop(pDataObj: IDataObject;const grfKeyState: Longword;p: TPoint; var pdwEffect: Longword; const bQuery: boolean):HResult ;stdcall;
      function IsSetFontSupported(var pbSupported: boolean):HResult ;stdcall;
      function SetFont(var pLF: LOGFONT; const nSize: cardinal; const rgbColor: COLORREF):HResult ;stdcall;
      function OnObject(const hDC: HDC; ptMouse: TPoint):HResult ;stdcall;
      function InObject(const hDC: HDC; ptMouse: TPoint):HResult ;stdcall;
      function CalcDistanceToFrame(const hDC: HDC; ptMouse: TPoint; var pnDistance: cardinal):HResult ;stdcall; // return in device coords - sorry, historical reasons! Return 65535 for non-inside click
      function OnMouseMove(const hDC: HDC; ptMouse: TPoint; var phCrs: hCursor) :HResult ;stdcall;  // S_FALSE for original cursor
      function OnMouseLButton(const hDC: HDC; ptMouse: TPoint; const hWnd: cmbtHWND) :HResult ;stdcall;
      function OnDeclareChartRow:HResult ;stdcall;
      function CanCreateObjectFromType(const nLLType: integer; const sVarName: OLEString; var prcCreate: TRect):HResult;stdcall;
      function GetVarSizeInfo(const hDC: HDC; const prcSpaceAvailable: cmbtll17.pTRect; var pnMinHeight,pnIdealHeight: integer): HRESULT; stdcall;
    published
      property Description: String read FDescription write SetDescription;
      property Hint: String read FHint write SetHint;
      property ParentComponent: TL17_ read FParentComponent write SetMyParentComponent;
      property PopupMenu: TPopupMenu read FPopupMenu write SetPopupMenu;
      property Icon: TIcon read FIcon write SetIcon;
      property ObjectName: String read FObjectName write SetObjectName;
      property SupportsMultipage: boolean read FSupportsMultipage write SetSupportsMultipage;
      property OnEdit: TEditObjectEvent read FOnEdit write SetOnEdit;
      property OnInitialCreation: TCreateObjectEvent read FOnInitialCreation write SetOnInitialCreation;
      property OnDraw: TDrawObjectEvent read FOnDraw write SetOnDraw;
      property OnClick: TClickEvent read FOnClick write SetOnClick;
      property OnGetVariableSizeInfo: TGetVariableSizeInfoEvent read FOnGetVariableSizeInfo write SetOnGetVariableSizeInfo;
      property OnResetPrintState: TResetPrintStateEvent read FOnResetPrintState write SetOnResetPrintState;
    end;

{$endif}

  TLl17XAction=class(TComponent)
  private
    FParentComponent: TL17_;
    FAddToToolbar: boolean;
    FIconId: integer;
    FInsertionType: TLl17XActionInsertionType;
    FMenuHierachy: string;
    FMenuText: string;
    FTooltipText: string;
    FMenuId: integer;
    FOnGetActionState: TGetActionStateEvent;
    FShortCut: TShortCut;
    FOnExecuteAction: TExecuteActionEvent;
    procedure SetMenuId(const Value: integer);
    procedure SetOnGetActionState(const Value: TGetActionStateEvent);
    procedure SetShortCut(const Value: TShortCut);
    procedure SetOnExecuteAction(const Value: TExecuteActionEvent);
    property MenuId: integer read FMenuId write SetMenuId;
    procedure AddAction;
    procedure SetMyParentComponent(const Value: TL17_);
    procedure SetToToolbar(const Value: boolean);
    procedure SetIconId(const Value: integer);
    procedure SetInsertionType(const Value: TLl17XActionInsertionType);
    procedure SetMenuHierachy(const Value: string);
    procedure SetMenuText(const Value: string);
    procedure SetTooltipText(const Value: string);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property AddToToolbar: boolean read FAddToToolbar write SetToToolbar;
    property IconId: integer read FIconId write SetIconId;
    property InsertionType: TLl17XActionInsertionType read FInsertionType write SetInsertionType;
    property MenuHierachy: string read FMenuHierachy write SetMenuHierachy;
    property MenuText: string read FMenuText write SetMenuText;
    property ParentComponent: TL17_ read FParentComponent write SetMyParentComponent;
    property ShortCut: TShortCut read FShortCut write SetShortCut;
    property TooltipText: string read FTooltipText write SetTooltipText;
    property OnExecuteAction: TExecuteActionEvent read FOnExecuteAction write SetOnExecuteAction;
    property OnGetActionState: TGetActionStateEvent read FOnGetActionState write SetOnGetActionState;
  end;



function NtfyCallback(nMsg: cardinal; lParam: cardinal; lUserParam: cardinal): integer; export; stdcall;

function StgsysNtfyCallback(nMsg: cardinal; lParam: integer; lUserParam: integer): integer; export; stdcall;

procedure StrPCopyExt(var Dest: ptChar; Source: TString; MinSize: integer);


procedure Register;


implementation

uses l17db, cmbtls17, math;

function NtfyCallback(nMsg: cardinal; lParam: cardinal; lUserParam: cardinal): integer;
var
  i, lResult, menuId: integer;
  pc: pTChar;
  actionState: TLl17XActionLlActionState;
begin
  lResult := 0;


  case nMsg of
    LL_CMND_DRAW_USEROBJ:
      begin
          (TL17_(lUserParam)).DrawUserobjCallback(pSCLLDRAWUSEROBJ(lParam));
      end;
    LL_CMND_EDIT_USEROBJ:
      begin
          (TL17_(lUserParam)).EditUserobjCallback(pSCLLEDITUSEROBJ(lParam));
          lResult:=1;
      end;
    LL_CMND_TABLELINE:
      begin
          (TL17_(lUserParam)).TableLineCallback(pSCLLTABLELINE(lParam));
      end;
    LL_CMND_TABLEFIELD:
      begin
          (TL17_(lUserParam)).TableFieldCallback(pSCLLTABLEFIELD(lParam));
      end;
    LL_CMND_EVALUATE:
      begin
          (TL17_(lUserParam)).ExtFctCallback(pSCLLEXTFCT(lParam));
      end;
    LL_CMND_OBJECT:
      begin
          (TL17_(lUserParam)).ObjectCallback(pSCLLOBJECT(lParam), lResult);
      end;
    LL_CMND_PAGE:
      begin
          (TL17_(lUserParam)).PageCallback(pSCLLPAGE(lParam));
      end;
    LL_CMND_PROJECT:
      begin
          (TL17_(lUserParam)).ProjectCallback(pSCLLPROJECT(lParam));
      end;
    LL_CMND_HELP:
      begin
          (TL17_(lUserParam)).HelpCallback(HIWORD(lParam), LOWORD(lParam), lResult);
      end;
    LL_CMND_ENABLEMENU:
      begin
        (* undoc: lParam/LOWORD(lParam) = HMENU *)
          (TL17_(lUserParam)).EnableMenuCallback(lParam);
      end;
    LL_CMND_MODIFYMENU:
      begin
        (* undoc: lParam/LOWORD(lParam) = HMENU *)
          (TL17_(lUserParam)).ModifyMenuCallback(lParam);
      end;
    LL_CMND_SELECTMENU:
      begin
          for i := 0 to (TL17_(lUserParam)).FLlXActionList.Count - 1 do
          begin
          if integer(lParam) = TLl17XAction((TL17_(lUserParam)).FLlXActionList.Items[i]).FMenuId then
          begin
            if Assigned(TLl17XAction((TL17_(lUserParam)).FLlXActionList.Items[i]).OnExecuteAction) then
              TLl17XAction((TL17_(lUserParam)).FLlXActionList.Items[i]).OnExecuteAction();
            lResult:=1;
          end;
        end;
          (TL17_(lUserParam)).SelectMenuCallback(lParam, lResult);
      end;
    LL_NTFY_FAILSFILTER:
      begin
          (TL17_(lUserParam)).FailsFilterCallback;
      end;
    LL_NTFY_EXPRERROR:
      begin
          (TL17_(lUserParam)).NtfyExprErrorCallback(PTChar(lParam), lResult);
      end;
    LL_CMND_GETVIEWERBUTTONSTATE:
      begin
          (TL17_(lUserParam)).GetViewerButtonStateCallback(HIWORD(lParam),
          LOWORD(lParam), lResult);
      end;
    LL_NTFY_VIEWERBTNCLICKED:
      begin
          (TL17_(lUserParam)).ViewerButtonClickedCallback(LOWORD(lParam), lResult);
      end;
    LL_CMND_VARHELPTEXT:
      begin
        pc := g_BufferStr;
        pc^ := #0;
        (TL17_(lUserParam)).VarHelpTextCallback(ptchar(lParam), pc);
        lResult := integer(pc);
      end;
    LL_INFO_METER:
      begin
          (TL17_(lUserParam)).NtfyProgressCallback(pSCLLMETERINFO(lParam));
      end;

    LL_INFO_PRINTJOBSUPERVISION:
      begin
          (TL17_(lUserParam)).PrintJobInfoCallback(PSCLLPRINTJOBINFO(lParam));
      end;

    LL_CMND_HOSTPRINTER:
      begin
          (TL17_(lUserParam)).HostPrinterCallback(pSCLLPRINTER(lParam), lResult);
      end;
    LL_CMND_DLGEXPR_VARBTN:
      begin
          (TL17_(lUserParam)).DlgExprVarbtnCallback(PSCLLDLGEXPRVAREXT(lParam), lResult);
      end;
    LL_CMND_SAVEFILENAME:
      begin
          (TL17_(lUserParam)).SaveFileNameCallback(PTChar(lparam));
      end;
    LL_QUERY_DESIGNERACTIONSTATE:
      begin
        menuId := (lParam and $ffff0000) shr 16;
        for i := 0 to (TL17_(lUserParam)).FLlXActionList.Count - 1 do
        begin
          if menuId = TLl17XAction((TL17_(lUserParam)).FLlXActionList.Items[i]).FMenuId then
          begin
            actionState := asEnabled;
            if Assigned(TLl17XAction((TL17_(lUserParam)).FLlXActionList.Items[i]).OnGetActionState) then
              TLl17XAction((TL17_(lUserParam)).FLlXActionList.Items[i]).OnGetActionState(actionState);
            case actionState of
              asEnabled: lResult:=1;
              asDisabled: lResult:=2;
            end;
          end;
        end;
      end;
    LL_NTFY_PROJECTLOADED:
      begin
          (TL17_(lUserParam)).ProjectLoadedEvent;
      end;
    LL_NTFY_DESIGNERPRINTJOB:
      begin
          lResult := (TL17_(lUserParam)).DesignerPrintJobEvent(pSCLLDESIGNERPRINTJOB(lParam));
      end;
    LL_NTFY_VIEWERDRILLDOWN:
      begin
          lResult:= (TL17_(lUserParam)).DrillDownJobEvent(PSCLLDRILLDOWNJOBINFO(lParam));
      end;
    LL_NTFY_QUEST_DRILLDOWNDENIED :
      begin
        if l17db.DrillDownActive then
          lResult:= 1
        else
          lResult:= 0;
      end;
    73:      // LL_NTFY_INPLACEDESIGNER_END
      begin
          (TL17_(lUserParam)).InplaceDesignerClosedEvent;
      end;

  end;
  Result := lResult;
end;

function StgsysNtfyCallback(nMsg: cardinal; lParam: integer; lUserParam: integer): integer;
var
  lResult: integer;
  var IsHandled: boolean;
begin

  lResult := 0;
  IsHandled:=false;

  case nMsg of
    LS_VIEWERCONTROL_QUEST_BTNSTATE:
      begin
          TLl17PreviewControl(lUserParam).QuestButtonState(lParam,lResult);
      end;

    LS_VIEWERCONTROL_NTFY_PAGELOADED:
      begin
          if Assigned(TLl17PreviewControl(lUserParam).OnPageChanged) then
                  TLl17PreviewControl(lUserParam).OnPageChanged(TLl17PreviewControl(lUserParam),lParam);
      end;

    LS_VIEWERCONTROL_NTFY_BTNPRESSED:
      begin
          If Assigned(TLl17PreviewControl(lUserParam).OnButtonClicked) then
          begin
            TLl17PreviewControl(lUserParam).OnButtonClicked(TLl17PreviewControl(lUserParam),lParam, IsHandled);
            if IsHandled=true then lResult:=1;
          end;
      end;
  end;
  Result := lResult;
end;




(******************************************************************************)
(*** TPrvAppearance implementation *******************************************)
(******************************************************************************)

constructor TPrvAppearance.Create;
begin
  inherited Create;
  FPrvPerc := 100;
  FPrvLeft := -1;
  FPrvTop := -1;
  FPrvWidth := -1;
  FPrvHeight := -1;
  hTheLLJob := LL_ERR_BAD_JOBHANDLE;
end;

procedure TPrvAppearance.SetJob(hLLJob: integer);
begin
  hTheLLJob := hLLJob;
end;

function TPrvAppearance.GetPerc: integer;
begin
  if hTheLLJOB = LL_ERR_BAD_JOBHANDLE then
    Result := LL_ERR_BAD_JOBHANDLE
  else
    Result := LlGetOption(hTheLlJob, LL_OPTION_PRVZOOM_PERC);
end;

function TPrvAppearance.GetLeft: integer;
begin
  if hTheLLJOB = LL_ERR_BAD_JOBHANDLE then
    Result := LL_ERR_BAD_JOBHANDLE
  else
    Result := LlGetOption(hTheLlJob, LL_OPTION_PRVRECT_LEFT);
end;

function TPrvAppearance.GetTop: integer;
begin
  if hTheLLJOB = LL_ERR_BAD_JOBHANDLE then
    Result := LL_ERR_BAD_JOBHANDLE
  else
    Result := LlGetOption(hTheLlJob, LL_OPTION_PRVRECT_TOP);
end;

function TPrvAppearance.GetWidth: integer;
begin
  if hTheLLJOB = LL_ERR_BAD_JOBHANDLE then
    Result := LL_ERR_BAD_JOBHANDLE
  else
    Result := LlGetOption(hTheLlJob, LL_OPTION_PRVRECT_WIDTH);
end;

function TPrvAppearance.GetHeight: integer;
begin
  if hTheLLJOB = LL_ERR_BAD_JOBHANDLE then
    Result := LL_ERR_BAD_JOBHANDLE
  else
    Result := LlGetOption(hTheLlJob, LL_OPTION_PRVRECT_HEIGHT);
end;

procedure TPrvAppearance.SetPerc(nValue: integer);
begin
  if (hTheLLJob <> LL_ERR_BAD_JOBHANDLE) and (nValue > -2) then
  begin
    FPrvPerc := nValue;
    if (nValue > 0) then
      LlSetOption(hTheLLJob, LL_OPTION_PRVZOOM_PERC, nValue);
  end;
end;

procedure TPrvAppearance.SetLeft(nValue: integer);
begin
  if (hTheLLJob <> LL_ERR_BAD_JOBHANDLE) and (nValue > -2) then
  begin
    FPrvLeft := nValue;
    if (nValue > -1) then
      LlSetOption(hTheLLJob, LL_OPTION_PRVRECT_LEFT, nValue);
  end;
end;

procedure TPrvAppearance.SetTop(nValue: integer);
begin
  if (hTheLLJob <> LL_ERR_BAD_JOBHANDLE) and (nValue > -2) then
  begin
    FPrvTop := nValue;
    if (nValue > -1) then
      LlSetOption(hTheLLJob, LL_OPTION_PRVRECT_TOP, nValue);
  end;
end;

procedure TPrvAppearance.SetWidth(nValue: integer);
begin
  if (hTheLLJob <> LL_ERR_BAD_JOBHANDLE) and (nValue > -2) then
  begin
    FPrvWidth := nValue;
    if (nValue > 0) then
      LlSetOption(hTheLLJob, LL_OPTION_PRVRECT_WIDTH, nValue);
  end;
end;

procedure TPrvAppearance.SetHeight(nValue: integer);
begin
  if (hTheLLJob <> LL_ERR_BAD_JOBHANDLE) and (nValue > -2) then
  begin
    FPrvHeight := nValue;
    if (nValue > 0) then
      LlSetOption(hTheLLJob, LL_OPTION_PRVRECT_HEIGHT, nValue);
  end;
end;

(******************************************************************************)
(*** TL17_ implementation ******************************************************)
(******************************************************************************)
constructor TL17_.Create(AOwner: TComponent);
var Owner: TL17_;
begin
  hTheJob := LL_ERR_BAD_JOBHANDLE;
  lpfnNtfyProc := nil;
  inherited Create(AOwner);

  FPrvAppearance := TPrvAppearance.Create;

  if AOwner is TL17_ then
  begin
    FIsCopy:=true;
    Owner:=AOwner As TL17_;
    hTheJob := LlJobOpenCopy(Owner.hLlJob);

    FOnObjectCallback:=Owner.FOnObjectCallback;
    FOnTableFieldCallback:=Owner.FOnTableFieldCallback;
    FOnTableLineCallback:=Owner.FOnTableLineCallback;
    FOnDrawUserobjCallback:=Owner.FOnDrawUserobjCallback;
    FOnEditUserobjCallback:=Owner.FOnEditUserobjCallback;
    FOnPageCallback:=Owner.FOnPageCallback;
    FOnProjectCallback:=Owner.FOnProjectCallback;
    FOnObjectCallback:=Owner.FOnObjectCallback;
    FOnExtFctCallback:=Owner.FOnExtFctCallback;
    FOnFailsFilterCallback:=Owner.FOnFailsFilterCallback;
    FOnHelpCallback:=Owner.FOnHelpCallback;

    FOnEnableMenuCallback:=Owner.FOnEnableMenuCallback;
    FOnModifyMenuCallback:=Owner.FOnModifyMenuCallback;
    FOnSelectMenuCallback:=Owner.FOnSelectMenuCallback;
    FOnGetViewerButtonStateCallback:=Owner.FOnGetViewerButtonStateCallback;
    FOnViewerButtonClickedCallback:=Owner.FOnViewerButtonClickedCallback;
    FOnVarHelpTextCallback:=Owner.FOnVarHelpTextCallback;
    FOnNtfyProgressCallback:=Owner.FOnNtfyProgressCallback;
    FOnHostPrinterCallback:=Owner.FOnHostPrinterCallback;
    FOnDlgExprVarBtnCallback:=Owner.FOnDlgExprVarBtnCallback;
    FOnDefineVariablesCallback:=Owner.FOnDefineVariablesCallback;
    FOnDefineFieldsCallback:=Owner.FOnDefineFieldsCallback;
    FOnPrintJobInfo:=Owner.FOnPrintJobInfo;
    FOnExprError:=Owner.FOnExprError;
    FOnSaveFileName:=Owner.FOnSaveFileName;
    FOnProjectLoaded:=Owner.FOnProjectLoaded;

    DebugMode := Owner.DebugMode;

    {$ifdef USELLXOBJECTS}
    FLlXObjectList:=Owner.FLlXObjectList;
    FLlXFunctionList:=Owner.FLlXFunctionList;
    {$endif}
  end else
  begin
    FIsCopy:=false;
    CheckSetLlJob(False);
    LlSetOption(LL_OPTION_CALLBACKPARAMETER, integer(self));
    lpfnNtfyProc := TFarProc(@NtfyCallback);
    LlSetNotificationCallback(lpfnNtfyProc);

    (*initialize default values*)
    IncrementalPreview := 1;
    SetHelpAvailable(Yes);
    SetSpaceOptimization(Yes);
    SetVarsCaseSensitive(Yes);
    MaxRTFVersion := $0401;
    nDialogBoxValue := 0;
    nButtonsValue := 0;
    SetDialogboxMode(dmOffice2003);
    SetButtons3D(No);
    SetButtonsWithBitmaps(No);
    SetXlatVarNames(Yes);
    SetCreateInfo(Yes);
    SetAddVarsToFields(No);
    SetConvertCRLF(Yes);
    SetDelayTableHeader(No);
    SetEMFResolution(0);
    SetMultipleTableLines(Yes);
    SetNewExpressions(NewMode);
    SetNoNoTableCheck(Yes);
    SetNoParameterCheck(No);
    SetOfnDialogExplorer(Yes);
    SetOnlyOneTable(False);
    SetRealTime(No);
    SetRetRepresentationCode(#182);
    SetShowPredefVars(Yes);
    SetSortVariables(Yes);
    SetStorageSystem(syStorage);
    SetSupportPageBreak(Yes);
    SetTableColoringMode(tcNormal);
    SetTabRepresentationCode(#247);
    SetPhantomspaceRepresentationCode(Chr(LL_CHAR_PHANTOMSPACE));
    SetLocknextcharRepresentationCode(Chr(LL_CHAR_LOCK));
    SetExprsepRepresentationCode(Chr(LL_CHAR_EXPRSEP));
    SetTextquoteRepresentationCode(Chr(LL_CHAR_TEXTQUOTE));
    SetTabMode(tmReplace);
    SetUseBarcodeSizes(No);
    SetUseHostprinter(No);
    SetWizFileNew(No);
    SetInterCharSpacing(No);
    SetIncludeFontDescent(Yes);
    SetUseChartFields(No);
    SetLicensingInfo('');
    ProjectPassword := '';
    InplaceDesignerHandle := 0;
    // Explicitly enable print job supervision
    cmbtll17.LlSetOption(hTheJob, 106, 0);

    {$ifdef USELLXOBJECTS}
    FLlXObjectList:= TList.Create;
    FLlXFunctionList:=TList.Create;
    FLlXInterface:=nil;
    {$endif}
  end;

  FLlXActionList := TList.Create;

  Dictionary := TDictionary.Create(self);
  DesignerWorkspace := TDesignerWorkSpace.Create(self);
  bIsPrinting := False;
end;

destructor TL17_.Destroy;
begin
  if (lpfnNtfyProc <> nil) then
    FreeProcInstance(lpfnNtfyProc);
  lpfnNtfyProc := nil;
  LlSetNotificationCallback(nil);
  if (hTheJob > LL_ERR_BAD_JOBHANDLE) then
    LlJobClose(hTheJob);
  FPrvAppearance.Free;
  {$ifdef USELLXOBJECTS}
  if not (Owner is TL17_) then
  begin
    FLlXObjectList.free;
    FLlXFunctionList.free;
  end;
  {$endif}
  FLlXActionList.Free;
  Dictionary.Free;
  DesignerWorkspace.Free;

  inherited Destroy;
end;

function TL17_.CheckLlJob: boolean;
begin
  Result := (hTheJob < 0);
  if (hTheJob < 0) then
  begin
    if (hTheJob = LL_ERR_NO_LANG_DLL) then
      Application.MessageBox('List & Label Language file not found.', 'Error',
        MB_OK or MB_ICONINFORMATION)
    else
      Application.MessageBox('Can''t open the List & Label job.', 'Error',
        MB_OK or MB_ICONINFORMATION);
  end;
end;

function TL17_.CheckSetLlJob(bWarn: boolean): boolean;
var
  nLang: integer;
begin
  if bWarn then
    CheckLlJob;
  if (hTheJob < 0) then
  begin
    hTheJob := LlJobOpen(CMBTLANG_DEFAULT);
    nLang := CMBTLANG_DEFAULT;
    if (hTheJob <= LL_ERR_BAD_JOBHANDLE) then
    begin
      for nLang := CMBTLANG_GERMAN to CMBTLANG_MAX do
      begin
        hTheJob := LlJobOpen(nLang);
        if (hTheJob > LL_ERR_BAD_JOBHANDLE) then
          break;
      end;
    end;
    FPrvAppearance.SetJob(hTheJob);
    if (hTheJob < 0) then
    begin
      Application.MessageBox('Can''t find the List & Label default language file.',
        'Error',
        MB_OK or MB_ICONINFORMATION);
      result := True;
      exit;
    end;
    case nLang of
      (* If you want to support more languages in your Project, you have to add *)
      (* code for the languages up to the language you want to support like     *)
      (* this: *)
      CMBTLANG_DEFAULT:
        nLanguage := ltDefaultLang;
      CMBTLANG_GERMAN:
        nLanguage := ltDeutsch;
      CMBTLANG_ENGLISH:
        nLanguage := ltEnglish;
      CMBTLANG_ARAB:
        nLanguage := ltArab;
      CMBTLANG_AFRIKAANS:
        nLanguage := ltAfrikaans;
      CMBTLANG_ALBANIAN:
        nLanguage := ltAlbanian;
      CMBTLANG_BASQUE:
        nLanguage := ltBasque;
      CMBTLANG_BULGARIAN:
        nLanguage := ltBulgarian;
      CMBTLANG_BYELORUSSIAN:
        nLanguage := ltBelorussian;
      CMBTLANG_CATALAN:
        nLanguage := ltCatalan;
      CMBTLANG_CHINESE:
        nLanguage := ltChinese;
      CMBTLANG_CROATIAN:
        nLanguage := ltCroatian;
      CMBTLANG_CZECH:
        nLanguage := ltCzech;
      CMBTLANG_DANISH:
        nLanguage := ltDanish;
      CMBTLANG_DUTCH:
        nLanguage := ltDutch;
      CMBTLANG_ESTONIAN:
        nLanguage := ltEstonian;
      CMBTLANG_FAEROESE:
        nLanguage := ltFaeroese;
      CMBTLANG_FARSI:
        nLanguage := ltFarsi;
      CMBTLANG_FINNISH:
        nLanguage := ltFinnish;
      CMBTLANG_FRENCH:
        nLanguage := ltFrench;
      CMBTLANG_GREEK:
        nLanguage := ltGreek;
      CMBTLANG_HEBREW:
        nLanguage := ltHebrew;
      CMBTLANG_HUNGARIAN:
        nLanguage := ltHungarian;
      CMBTLANG_ICELANDIC:
        nLanguage := ltIcelandic;
      CMBTLANG_INDONESIAN:
        nLanguage := ltIndonesian;
      CMBTLANG_ITALIAN:
        nLanguage := ltItalian;
      CMBTLANG_JAPANESE:
        nLanguage := ltJapanese;
      CMBTLANG_KOREAN:
        nLanguage := ltKorean;
      CMBTLANG_LATVIAN:
        nLanguage := ltLatvian;
      CMBTLANG_LITHUANIAN:
        nLanguage := ltLithuanian;
      CMBTLANG_NORWEGIAN:
        nLanguage := ltNorwegian;
      CMBTLANG_POLISH:
        nLanguage := ltPolish;
      CMBTLANG_PORTUGUESE:
        nLanguage := ltPortuguese;
      CMBTLANG_ROMANIAN:
        nLanguage := ltRomanian;
      CMBTLANG_RUSSIAN:
        nLanguage := ltRussian;
      CMBTLANG_SLOVAK:
        nLanguage := ltSlovak;
      CMBTLANG_SLOVENIAN:
        nLanguage := ltSlovenian;
      CMBTLANG_SERBIAN:
        nLanguage := ltSerbian;
      CMBTLANG_SPANISH:
        nLanguage := ltSpanish;
      CMBTLANG_SWEDISH:
        nLanguage := ltSwedish;
      CMBTLANG_THAI:
        nLanguage := ltThai;
      CMBTLANG_TURKISH:
        nLanguage := ltTurkish;
      CMBTLANG_UKRAINIAN:
        nLanguage := ltUkrainian;
    end;
  end;
  Result := CheckSetCallback;
end;

function TL17_.CheckSetCallback: boolean;
begin
  if (lpfnNtfyProc <> nil) then
    FreeProcInstance(lpfnNtfyProc);

  LlSetOption(LL_OPTION_CALLBACKPARAMETER, integer(self));
  lpfnNtfyProc := MakeProcInstance(TFarProc(@NtfyCallback), HInstance);
  Result := (LlSetNotificationCallback(lpfnNtfyProc) <> nil);
  cmbtll17.LlSetOption(hTheJob,LL_OPTION_CALLBACKMASK, LL_CB_PAGE or LL_CB_PROJECT or LL_CB_OBJECT or LL_CB_HELP or LL_CB_TABLELINE or LL_CB_TABLEFIELD);
end;



procedure TL17_.SetLanguage(nType: TLanguageType);
var
  SavDebugMode: integer;
  SavNewExpressions: TExpressionMode;
  SavMultipleTableLines: TPropYesNo;
  SavAddVarsToFields: TPropYesNo;
  SavOnlyOneTable: boolean;
  SavSupervisor: TPropYesNo;
  SavTabStops: TTabMode;
  SavConvertCRLF: TPropYesNo;
  SavTabRepresentationCode: char;
  SavRetRepresentationCode: char;
  SavPhantomspaceRepresentationCode: char;
  SavExprsepRepresentationCode: char;
  SavLocknextcharRepresentationCode: char;
  SavTextquoteRepresentationCode: char;
  SavHelpAvailable: TPropYesNo;
  SavDelayTableHeader: TPropYesNo;
  SavOfnDialogExplorer: TPropYesNo;
  SavRealTime: TPropYesNo;
  SavSpaceOptimization: TPropYesNo;
  SavUseBarcodeSizes: TPropYesNo;
  SavUseHostprinter: TPropYesNo;
  SavVarsCaseSensitive: TPropYesNo;
  SavWizFileNew: TPropYesNo;
  SavSupportPageBreak: TPropYesNo;
  SavSortVariables: TPropYesNo;
  SavShowPreDefVars: TPropYesNo;
  SavTableColoringMode: TPropTableColoring;
  SavMetric: TPropUnitSystem;
  SavStgSystem: TPropStgSystem;
  SavStgCompress: TPropYesNo;
  SavNoParameterCheck: TPropYesNo;
  SavNoNoTableCheck: TPropYesNo;
  SavDialogBoxMode: TDialogBoxMode;
  SavButtons3D: TPropYesNo;
  SavButtonsWithBitmaps: TPropYesNo;
  SavDialogBoxValue: integer;
  SavButtonsValue: integer;
  SavXlatVarNames: TPropYesNo;
  SavCreateInfo: TPropYesNo;

  SavInterCharSpacing: TPropYesNo;
  SavIncludeFontDescent: TPropYesNo;
  SavUseChartFields: TPropYesNo;
  SavIncrementalPreview: integer;

  SavLicensingInfo: string;
  SavProjectPassword: string;
begin
  SavDebugMode := nDebug;
  SavNewExpressions := GetNewExpressions;
  SavMultipleTableLines := GetMultipleTableLines;
  SavAddVarsToFields := GetAddVarsToFields;
  SavOnlyOneTable := GetOnlyOneTable;
  SavSupervisor := GetOptionSupervisor;
  SavTabStops := GetTabMode;
  SavConvertCRLF := GetConvertCRLF;
  SavTabRepresentationCode := GetTabRepresentationcode;
  SavRetRepresentationCode := GetRetRepresentationcode;
  SavPhantomspaceRepresentationCode := GetPhantomspaceRepresentationcode;
  SavExprsepRepresentationCode := GetExprsepRepresentationcode;
  SavLocknextcharRepresentationCode := GetLocknextcharRepresentationcode;
  SavTextquoteRepresentationCode := GetTextquoteRepresentationcode;
  SavHelpAvailable := GetHelpAvailable;
  SavDelayTableHeader := GetDelayTableHeader;
  SavOfnDialogExplorer := GetOfnDialogExplorer;
  SavRealTime := GetRealTime;
  SavSpaceOptimization := GetSpaceOptimization;
  SavUseBarcodeSizes := GetUseBarcodeSizes;
  SavUseHostprinter := GetUseHostprinter;
  SavVarsCaseSensitive := GetVarsCaseSensitive;
  SavWizFileNew := GetWizFileNew;

  SavSupportPageBreak := GetSupportPageBreak;
  SavSortVariables := GetSortVariables;
  SavShowPreDefVars := GetShowPreDefVars;
  SavTableColoringMode := GetTableColoringMode;
  SavMetric := GetMetric;
  SavStgSystem := GetStorageSystem;
  SavStgCompress := GetCompressStorage;
  SavNoParameterCheck := GetNoParameterCheck;
  SavNoNoTableCheck := GetNoNoTableCheck;


  SavDialogBoxMode := nDialogBoxMode;
  SavButtons3D := GetButtons3D;
  SavButtonsWithBitmaps := GetButtonsWithBitmaps;
  SavDialogBoxValue := nDialogBoxValue;
  SavButtonsValue := nButtonsValue;
  SavXlatVarNames := GetXlatVarnames;
  SavCreateInfo := GetCreateInfo;

  SavInterCharSpacing := GetInterCharSpacing;
  SavIncludeFontDescent := GetIncludeFontDescent;
  SavUseChartFields := GetUseChartFields;
  SavLicensingInfo := LicensingInfo;
  SavProjectPassword := ProjectPassword;

  SavIncrementalPreview:=IncrementalPreview;


  nLanguage := nType;
  if (hTheJob > LL_ERR_BAD_JOBHANDLE) then
    LlJobClose(hTheJob);
  cmbtll17.LlSetOption(-1,LL_OPTION_MAXRTFVERSION, nMaxRTFVersion);
  case nType of
    (* If you want to support more languages in your Project, you have to add *)
    (* code for the languages up to the language you want to support like     *)
    (* this: *)
    ltDefaultLang:
      hTheJob := LlJobOpen(CMBTLANG_DEFAULT);
    ltDeutsch:
      hTheJob := LlJobOpen(CMBTLANG_GERMAN);
    ltEnglish:
      hTheJob := LlJobOpen(CMBTLANG_ENGLISH);
    ltArab:
      hTheJob := LlJobOpen(CMBTLANG_ARAB);
    ltAfrikaans:
      hTheJob := LlJobOpen(CMBTLANG_AFRIKAANS);
    ltAlbanian:
      hTheJob := LlJobOpen(CMBTLANG_ALBANIAN);
    ltBasque:
      hTheJob := LlJobOpen(CMBTLANG_BASQUE);
    ltBulgarian:
      hTheJob := LlJobOpen(CMBTLANG_BULGARIAN);
    ltBelorussian:
      hTheJob := LlJobOpen(CMBTLANG_BYELORUSSIAN);
    ltCatalan:
      hTheJob := LlJobOpen(CMBTLANG_CATALAN);
    ltChinese:
      hTheJob := LlJobOpen(CMBTLANG_CHINESE);
    ltCroatian:
      hTheJob := LlJobOpen(CMBTLANG_CROATIAN);
    ltCzech:
      hTheJob := LlJobOpen(CMBTLANG_CZECH);
    ltDanish:
      hTheJob := LlJobOpen(CMBTLANG_DANISH);
    ltDutch:
      hTheJob := LlJobOpen(CMBTLANG_DUTCH);
    ltEstonian:
      hTheJob := LlJobOpen(CMBTLANG_ESTONIAN);
    ltFaeroese:
      hTheJob := LlJobOpen(CMBTLANG_FAEROESE);
    ltFarsi:
      hTheJob := LlJobOpen(CMBTLANG_FARSI);
    ltFinnish:
      hTheJob := LlJobOpen(CMBTLANG_FINNISH);
    ltFrench:
      hTheJob := LlJobOpen(CMBTLANG_FRENCH);
    ltGreek:
      hTheJob := LlJobOpen(CMBTLANG_GREEK);
    ltHebrew:
      hTheJob := LlJobOpen(CMBTLANG_HEBREW);
    ltHungarian:
      hTheJob := LlJobOpen(CMBTLANG_HUNGARIAN);
    ltIcelandic:
      hTheJob := LlJobOpen(CMBTLANG_ICELANDIC);
    ltIndonesian:
      hTheJob := LlJobOpen(CMBTLANG_INDONESIAN);
    ltItalian:
      hTheJob := LlJobOpen(CMBTLANG_ITALIAN);
    ltJapanese:
      hTheJob := LlJobOpen(CMBTLANG_JAPANESE);
    ltKorean:
      hTheJob := LlJobOpen(CMBTLANG_KOREAN);
    ltLatvian:
      hTheJob := LlJobOpen(CMBTLANG_LATVIAN);
    ltLithuanian:
      hTheJob := LlJobOpen(CMBTLANG_LITHUANIAN);
    ltNorwegian:
      hTheJob := LlJobOpen(CMBTLANG_NORWEGIAN);
    ltPolish:
      hTheJob := LlJobOpen(CMBTLANG_POLISH);
    ltPortuguese:
      hTheJob := LlJobOpen(CMBTLANG_PORTUGUESE);
    ltRomanian:
      hTheJob := LlJobOpen(CMBTLANG_ROMANIAN);
    ltRussian:
      hTheJob := LlJobOpen(CMBTLANG_RUSSIAN);
    ltSlovak:
      hTheJob := LlJobOpen(CMBTLANG_SLOVAK);
    ltSlovenian:
      hTheJob := LlJobOpen(CMBTLANG_SLOVENIAN);
    ltSerbian:
      hTheJob := LlJobOpen(CMBTLANG_SERBIAN);
    ltSpanish:
      hTheJob := LlJobOpen(CMBTLANG_SPANISH);
    ltSwedish:
      hTheJob := LlJobOpen(CMBTLANG_SWEDISH);
    ltThai:
      hTheJob := LlJobOpen(CMBTLANG_THAI);
    ltTurkish:
      hTheJob := LlJobOpen(CMBTLANG_TURKISH);
    ltUkrainian:
      hTheJob := LlJobOpen(CMBTLANG_UKRAINIAN);
    else
      hTheJob := LlJobOpen(CMBTLANG_DEFAULT);
  end;
  if (hTheJob < 0) then
    CheckSetLlJob(True)
  else
    CheckSetCallback;
  FPrvAppearance.SetJob(hTheJob);
  LlSetDebug(SavDebugMode);
  SetNewExpressions(SavNewExpressions);
  SetMultipleTableLines(SavMultipleTableLines);
  SetAddVarsToFields(SavAddVarsToFields);
  SetOnlyOneTable(SavOnlyOneTable);
  SetOptionSupervisor(SavSupervisor);
  SetTabMode(SavTabStops);
  SetConvertCRLF(SavConvertCRLF);
  SetTabRepresentationcode(SavTabRepresentationCode);
  SetRetRepresentationcode(SavRetRepresentationCode);
  SetPhantomspaceRepresentationcode(SavPhantomspaceRepresentationCode);
  SetExprsepRepresentationcode(SavExprsepRepresentationCode);
  SetLocknextcharRepresentationcode(SavLocknextcharRepresentationCode);
  SetTextquoteRepresentationcode(SavTextquoteRepresentationCode);
  SetHelpAvailable(SavHelpAvailable);
  SetDelayTableHeader(SavDelayTableHeader);
  SetOfnDialogExplorer(SavOfnDialogExplorer);
  SetRealTime(SavRealTime);
  SetSpaceOptimization(SavSpaceOptimization);
  SetUseBarcodeSizes(SavUseBarcodeSizes);
  SetUseHostprinter(SavUseHostprinter);
  SetVarsCaseSensitive(SavVarsCaseSensitive);
  SetWizFileNew(SavWizFileNew);
  SetSupportPageBreak(SavSupportPageBreak);
  SetSortVariables(SavSortVariables);
  SetShowPreDefVars(SavShowPreDefVars);
  SetTableColoringMode(SavTableColoringMode);
  SetMetric(SavMetric);
  SetStorageSystem(SavStgSystem);
  SetCompressStorage(SavStgCompress);
  SetNoParameterCheck(SavNoParameterCheck);
  SetNoNoTableCheck(SavNoNoTableCheck);

  nDialogBoxValue := SavDialogBoxValue;
  nButtonsValue := SavButtonsValue;
  nDialogBoxMode := SavDialogBoxMode;
  SetButtons3D(SavButtons3D);
  SetButtonsWithBitmaps(SavButtonsWithBitmaps);
  SetXlatVarNames(SavXlatVarNames);
  SetCreateInfo(SavCreateInfo);

  SetInterCharSpacing(SavInterCharSpacing);
  SetIncludeFontDescent(SavIncludeFontDescent);
  SetUseChartFields(SavUseChartFields);

  LicensingInfo := SavLicensingInfo;
  ProjectPassword := SavProjectPassword;
  IncrementalPreview:=SavIncrementalPreview;

  // Explicitly enable print job supervision
  cmbtll17.LlSetOption(hTheJob, 106, 0);

end;

procedure TL17_.SetEMFResolution(_nRes: integer);
begin
  cmbtll17.LlSetOption(hTheJob, LL_OPTION_EMFRESOLUTION, _nRes);
  nEMFResolution := cmbtll17.LlGetOption(hTheJob, LL_OPTION_EMFRESOLUTION);
end;

function TL17_.GetNewExpressions: TExpressionMode;
begin
  Result := Old;
  if LlGetOption(LL_OPTION_EXTENDEDEVALUATION) <> 0 then
    Result := Enhanced;
  if LlGetOption(LL_OPTION_NEWEXPRESSIONS) <> 0 then
    Result := NewMode;
end;

procedure TL17_.SetNewExpressions(nMode: TExpressionMode);
begin
  case nMode of
    Old:
      begin
        LlSetOption(LL_OPTION_NEWEXPRESSIONS, 0);
        LlSetOption(LL_OPTION_EXTENDEDEVALUATION, 0);
      end;
    Enhanced:
      LlSetOption(LL_OPTION_EXTENDEDEVALUATION, 1);
    else
      LlSetOption(LL_OPTION_NEWEXPRESSIONS, 1);
  end;
end;

function TL17_.GetMultipleTableLines: TPropYesNo;
begin
  if (LlGetOption(LL_OPTION_MULTIPLETABLELINES) <> 0) then
    Result := Yes
  else
    Result := No;
end;

procedure TL17_.SetMultipleTableLines(nEnable: TPropYesNo);
begin
  if (nEnable = Yes) then
    LlSetOption(LL_OPTION_MULTIPLETABLELINES, 1)
  else
    LlSetOption(LL_OPTION_MULTIPLETABLELINES, 0);
end;

function TL17_.GetAddVarsToFields: TPropYesNo;
begin
  if (LlGetOption(LL_OPTION_ADDVARSTOFIELDS) <> 0) then
    Result := Yes
  else
    Result := No;
end;

procedure TL17_.SetAddVarsToFields(nEnable: TPropYesNo);
begin
  if (nEnable = Yes) then
    LlSetOption(LL_OPTION_ADDVARSTOFIELDS, 1)
  else
    LlSetOption(LL_OPTION_ADDVARSTOFIELDS, 0);
end;

function TL17_.GetOnlyOneTable: boolean;
begin
  Result := (LlGetOption(LL_OPTION_ONLYONETABLE) <> 0);
end;

procedure TL17_.SetOnlyOneTable(bFlag: boolean);
begin
  if (bFlag) then
    LlSetOption(LL_OPTION_ONLYONETABLE, 1)
  else
    LlSetOption(LL_OPTION_ONLYONETABLE, 0);
end;

function TL17_.GetOptionSupervisor: TPropYesNo;
begin
  if LlGetOption(LL_OPTION_SUPERVISOR) <> 0 then
    Result := Yes
  else
    Result := No;
end;

procedure TL17_.SetOptionSupervisor(bFlag: TPropYesNo);
begin
  if (bFlag = Yes) then
    LlSetOption(LL_OPTION_SUPERVISOR, 1)
  else
    LlSetOption(LL_OPTION_SUPERVISOR, 0);
end;

function TL17_.GetTabMode: TTabMode;
begin
  if LlGetOption(LL_OPTION_TABSTOPS) = LL_TABS_DELETE then
    Result := tmReplace
  else
    Result := tmExpand;
end;

procedure TL17_.SetTabMode(bFlag: TTabMode);
begin
  if (bFlag = tmReplace) then
    LlSetOption(LL_OPTION_TABSTOPS, LL_TABS_DELETE)
  else
    LlSetOption(LL_OPTION_TABSTOPS, LL_TABS_EXPAND);
end;

function TL17_.GetConvertCRLF: TPropYesNo;
begin
  if LlGetOption(LL_OPTION_CONVERTCRLF) <> 0 then
    Result := Yes
  else
    Result := No;
end;

procedure TL17_.SetConvertCRLF(bFlag: TPropYesNo);
begin
  if (bFlag = Yes) then
    LlSetOption(LL_OPTION_CONVERTCRLF, 1)
  else
    LlSetOption(LL_OPTION_CONVERTCRLF, 0);
end;

function TL17_.GetTabRepresentationCode: char;
begin
  Result := char(LOBYTE(LlGetOption(LL_OPTION_TABREPRESENTATIONCODE)));
end;

procedure TL17_.SetTabRepresentationCode(cCode: char);
begin
  LlSetOption(LL_OPTION_TABREPRESENTATIONCODE, integer(MAKEWORD(byte(cCode), 0)));
end;

function TL17_.GetRetRepresentationCode: char;
begin
  Result := char(LOBYTE(LlGetOption(LL_OPTION_RETREPRESENTATIONCODE)));
end;

procedure TL17_.SetRetRepresentationCode(cCode: char);
begin
  LlSetOption(LL_OPTION_RETREPRESENTATIONCODE, integer(MAKEWORD(byte(cCode), 0)));
end;

function TL17_.GetExprsepRepresentationCode: char;
begin
  Result := char(LOBYTE(LlGetOption(LL_OPTION_EXPRSEPREPRESENTATIONCODE)));
end;

function TL17_.GetLocknextcharRepresentationCode: char;
begin
  Result := char(LOBYTE(LlGetOption(LL_OPTION_LOCKNEXTCHARREPRESENTATIONCODE)));
end;

function TL17_.GetPairedItemDisplayString(TableFieldPair: TString; LCID: integer): TString;
begin
  Result := GetItemDisplayName(Copy(TableFieldPair,0,pos('.',TableFieldPair)-1),dtTables,LCID) + '.' +
              GetItemDisplayName(Copy(TableFieldPair,pos('.',TableFieldPair)+1,Length(TableFieldPair)-pos('.',TableFieldPair)),dtIdentifiers, LCID);
end;

function TL17_.GetPhantomspaceRepresentationCode: char;
begin
  Result := char(LOBYTE(LlGetOption(LL_OPTION_PHANTOMSPACEREPRESENTATIONCODE)));
end;

function TL17_.GetTextquoteRepresentationCode: char;
begin
  Result := char(LOBYTE(LlGetOption(LL_OPTION_TEXTQUOTEREPRESENTATIONCODE)));
end;

procedure TL17_.SetExprsepRepresentationCode(cCode: char);
begin
  LlSetOption(LL_OPTION_EXPRSEPREPRESENTATIONCODE, integer(MAKEWORD(byte(cCode), 0)));
end;

procedure TL17_.SetLocknextcharRepresentationCode(cCode: char);
begin
  LlSetOption(LL_OPTION_LOCKNEXTCHARREPRESENTATIONCODE, integer(MAKEWORD(byte(cCode), 0)));
end;

procedure TL17_.SetPhantomspaceRepresentationCode(cCode: char);
begin
  LlSetOption(LL_OPTION_PHANTOMSPACEREPRESENTATIONCODE, integer(MAKEWORD(byte(cCode), 0)));
end;

procedure TL17_.SetTextquoteRepresentationCode(cCode: char);
begin
  LlSetOption(LL_OPTION_TEXTQUOTEREPRESENTATIONCODE, integer(MAKEWORD(byte(cCode), 0)));
end;

function TL17_.GetHelpAvailable: TPropYesNo;
begin
  if bHelpAvailable then
  begin
    Result := Yes
  end
  else
  begin
    Result := No;
  end;
end;

procedure TL17_.SetHelpAvailable(nFlag: TPropYesNo);
begin
  if (nFlag = Yes) then
  begin
    LlSetOption(LL_OPTION_HELPAVAILABLE, 1);
    bHelpAvailable := True;
  end
  else
  begin
    LlSetOption(LL_OPTION_HELPAVAILABLE, 0);
    bHelpAvailable := False;
  end;
end;

function TL17_.GetDelayTableHeader: TPropYesNo;
begin
  if bDelayTableHeader then
  begin
    Result := Yes
  end
  else
  begin
    Result := No;
  end;
end;

procedure TL17_.SetDelayTableHeader(nFlag: TPropYesNo);
begin
  if (nFlag = Yes) then
  begin
    LlSetOption(LL_OPTION_DELAYTABLEHEADER, 1);
    bDelayTableHeader := True;
  end
  else
  begin
    LlSetOption(LL_OPTION_DELAYTABLEHEADER, 0);
    bDelayTableHeader := False;
  end;
end;


procedure TL17_.SetDesignerWorkspace(const Value: TDesignerWorkspace);
begin
  FDesignerWorkspace := Value;
end;

function TL17_.GetOfnDialogExplorer: TPropYesNo;
begin
  if bOfnDialogExplorer then
  begin
    Result := Yes
  end
  else
  begin
    Result := No;
  end;
end;

procedure TL17_.SetOfnDialogExplorer(nFlag: TPropYesNo);
begin
  if (nFlag = Yes) then
  begin
    LlSetOption(LL_OPTION_OFNDIALOG_EXPLORER, 1);
    bOfnDialogExplorer := True;
  end
  else
  begin
    LlSetOption(LL_OPTION_OFNDIALOG_EXPLORER, 0);
    bOfnDialogExplorer := False;
  end;
end;

function TL17_.GetRealTime: TPropYesNo;
begin
  if bRealTime then
  begin
    Result := Yes
  end
  else
  begin
    Result := No;
  end;
end;

procedure TL17_.SetRealTime(nFlag: TPropYesNo);
begin
  if (nFlag = Yes) then
  begin
    LlSetOption(LL_OPTION_REALTIME, 1);
    bRealTime := True;
  end
  else
  begin
    LlSetOption(LL_OPTION_REALTIME, 0);
    bRealTime := False;
  end;
end;

function TL17_.GetSpaceOptimization: TPropYesNo;
begin
  if bSpaceOptimization then
  begin
    Result := Yes
  end
  else
  begin
    Result := No;
  end;
end;

procedure TL17_.SetSpaceOptimization(nFlag: TPropYesNo);
begin
  if (nFlag = Yes) then
  begin
    LlSetOption(LL_OPTION_SPACEOPTIMIZATION, 1);
    bSpaceOptimization := True;
  end
  else
  begin
    LlSetOption(LL_OPTION_SPACEOPTIMIZATION, 0);
    bSpaceOptimization := False;
  end;
end;

function TL17_.GetUseBarcodeSizes: TPropYesNo;
begin
  if bUseBarcodeSizes then
  begin
    Result := Yes
  end
  else
  begin
    Result := No;
  end;
end;

procedure TL17_.SetUseBarcodeSizes(nFlag: TPropYesNo);
begin
  if (nFlag = Yes) then
  begin
    LlSetOption(LL_OPTION_USEBARCODESIZES, 1);
    bUseBarcodeSizes := True;
  end
  else
  begin
    LlSetOption(LL_OPTION_USEBARCODESIZES, 0);
    bUseBarcodeSizes := False;
  end;
end;

function TL17_.GetUseHostPrinter: TPropYesNo;
begin
  if bUseHostPrinter then
  begin
    Result := Yes
  end
  else
  begin
    Result := No;
  end;
end;

procedure TL17_.SetUseHostPrinter(nFlag: TPropYesNo);
begin
  if (nFlag = Yes) then
  begin
    LlSetOption(LL_OPTION_USEHOSTPRINTER, 1);
    bUseHostPrinter := True;
  end
  else
  begin
    LlSetOption(LL_OPTION_USEHOSTPRINTER, 0);
    bUseHostPrinter := False;
  end;
end;


function TL17_.GetVarsCaseSensitive: TPropYesNo;
begin
  if bVarsCaseSensitive then
  begin
    Result := Yes
  end
  else
  begin
    Result := No;
  end;
end;

procedure TL17_.SetVarsCaseSensitive(nFlag: TPropYesNo);
begin
  if (nFlag = Yes) then
  begin
    LlSetOption(LL_OPTION_VARSCASESENSITIVE, 1);
    bVarsCaseSensitive := True;
  end
  else
  begin
    LlSetOption(LL_OPTION_VARSCASESENSITIVE, 0);
    bVarsCaseSensitive := False;
  end;
end;

function TL17_.GetWizFileNew: TPropYesNo;
begin
  if bWizFileNew then
  begin
    Result := Yes
  end
  else
  begin
    Result := No;
  end;
end;

procedure TL17_.SetWizFileNew(nFlag: TPropYesNo);
begin
  if (nFlag = Yes) then
  begin
    LlSetOption(LL_OPTION_WIZ_FILENEW, 1);
    bWizFileNew := True;
  end
  else
  begin
    LlSetOption(LL_OPTION_WIZ_FILENEW, 0);
    bWizFileNew := False;
  end;
end;


function TL17_.GetSupportPageBreak: TPropYesNo;
begin
  if LlGetOption(LL_OPTION_SUPPORTPAGEBREAK) <> 0 then
    Result := Yes
  else
    Result := No;
end;

procedure TL17_.SetSupportPageBreak(nFlag: TPropYesNo);
begin
  if (nFlag = Yes) then
    LlSetOption(LL_OPTION_SUPPORTPAGEBREAK, 1)
  else
    LlSetOption(LL_OPTION_SUPPORTPAGEBREAK, 0);
end;

function TL17_.GetSortVariables: TPropYesNo;
begin
  if LlGetOption(LL_OPTION_SORTVARIABLES) <> 0 then
    Result := Yes
  else
    Result := No;
end;

procedure TL17_.SetSortVariables(nFlag: TPropYesNo);
begin
  if (nFlag = Yes) then
    LlSetOption(LL_OPTION_SORTVARIABLES, 1)
  else
    LlSetOption(LL_OPTION_SORTVARIABLES, 0);
end;

function TL17_.GetShowPredefVars: TPropYesNo;
begin
  if LlGetOption(LL_OPTION_SHOWPREDEFVARS) <> 0 then
    Result := Yes
  else
    Result := No;
end;

procedure TL17_.SetShowPredefVars(nFlag: TPropYesNo);
begin
  if (nFlag = Yes) then
    LlSetOption(LL_OPTION_SHOWPREDEFVARS, 1)
  else
    LlSetOption(LL_OPTION_SHOWPREDEFVARS, 0);
end;





function TL17_.GetTableColoringMode: TPropTableColoring;
var
  Value: integer;
begin
  Value := LlGetOption(LL_OPTION_TABLE_COLORING);
  case Value of
    LL_COLORING_PROGRAM:
      Result := tcUserDefined;
    LL_COLORING_DONTCARE:
      Result := tcMixed;
    else
      Result := tcNormal;
  end;
end;

procedure TL17_.SetTableColoringMode(nMode: TPropTableColoring);
begin
  case nMode of
    tcNormal:
      begin
        LlSetOption(LL_OPTION_TABLE_COLORING, LL_COLORING_LL);
      end;
    tcUserdefined:
      begin
        LlSetOption(LL_OPTION_TABLE_COLORING, LL_COLORING_PROGRAM);
      end;
    tcMixed:
      begin
        LlSetOption(LL_OPTION_TABLE_COLORING, LL_COLORING_DONTCARE);
      end;
  end;
end;

function TL17_.GetMetric: TPropUnitSystem;
begin
  if LlGetOption(LL_OPTION_UNITS) = LL_UNITS_MM_DIV_10 then
    Result := usMetric
  else if LlGetOption(LL_OPTION_UNITS) = LL_UNITS_MM_DIV_100 then
    Result := usHiMetric
  else if LlGetOption(LL_OPTION_UNITS) = LL_UNITS_INCH_DIV_100 then
    Result := usInch
  else
    Result := usHiInch;
end;

procedure TL17_.SetMetric(nMode: TPropUnitSystem);
begin
  if (nMode = usMetric) then
    LlSetOption(LL_OPTION_UNITS, LL_UNITS_MM_DIV_10)
  else if (nMode = usHiMetric) then
    LlSetOption(LL_OPTION_UNITS, LL_UNITS_MM_DIV_100)
  else if (nMode = usInch) then
    LlSetOption(LL_OPTION_UNITS, LL_UNITS_INCH_DIV_100)
  else
    LlSetOption(LL_OPTION_UNITS, LL_UNITS_INCH_DIV_1000)
end;

function TL17_.GetStorageSystem: TPropStgSystem;
begin
  if LlGetOption(LL_OPTION_STORAGESYSTEM) = LL_STG_COMPAT4 then
    Result := syCompat4
  else
    Result := syStorage;
end;

procedure TL17_.SetStorageSystem(nMode: TPropStgSystem);
begin
  if (nMode = syCompat4) then
  begin
    LlSetOption(LL_OPTION_STORAGESYSTEM, LL_STG_COMPAT4);
    SetCompressStorage(No);
  end
  else
    LlSetOption(LL_OPTION_STORAGESYSTEM, LL_STG_STORAGE);
end;

function TL17_.GetCompressStorage: TPropYesNo;
begin
  if LlGetOption(LL_OPTION_COMPRESSSTORAGE) <> 0 then
    Result := Yes
  else
    Result := No;
end;

procedure TL17_.SetCompressStorage(nMode: TPropYesNo);
begin
  if (nMode = Yes) and (GetStorageSystem = syStorage) then
    LlSetOption(LL_OPTION_COMPRESSSTORAGE, 1)
  else
    LlSetOption(LL_OPTION_COMPRESSSTORAGE, 0);
end;

function TL17_.GetNoParameterCheck: TPropYesNo;
begin
  if LlGetOption(LL_OPTION_NOPARAMETERCHECK) <> 0 then
    Result := Yes
  else
    Result := No;
end;

procedure TL17_.SetNoParameterCheck(nMode: TPropYesNo);
begin
  if (nMode = Yes) then
    LlSetOption(LL_OPTION_NOPARAMETERCHECK, 1)
  else
    LlSetOption(LL_OPTION_NOPARAMETERCHECK, 0);
end;

function TL17_.GetNoNoTableCheck: TPropYesNo;
begin
  if LlGetOption(LL_OPTION_NONOTABLECHECK) <> 0 then
    Result := Yes
  else
    Result := No;
end;

procedure TL17_.SetNoNoTableCheck(nMode: TPropYesNo);
begin
  if (nMode = Yes) then
    LlSetOption(LL_OPTION_NONOTABLECHECK, 1)
  else
    LlSetOption(LL_OPTION_NONOTABLECHECK, 0);
end;


function TL17_.GetUseChartFields: TPropYesNo;
begin
  if bUseChartFields then
    Result := Yes
  else
    Result := No;
end;


function TL17_.GetIncludeFontDescent: TPropYesNo;
begin
  if bIncludeFontDescent then
    Result := Yes
  else
    Result := No;
end;

function TL17_.GetInterCharSpacing: TPropYesNo;
begin
  if bInterCharSpacing then
    Result := Yes
  else
    Result := No;
end;


function TL17_.GetItemDisplayName(Name: TString; DictionaryType: TDictionaryType; LCID: integer): TString;
var
 DisplayName: TString;
 CurrentList: TStringList;
begin
    Result := Name;

    case DictionaryType of
      dtTables : begin
            CurrentList:=Dictionary.Tables.KeyList[LCID];
            if (CurrentList<> nil) and (CurrentList.Count > 0) then
              Dictionary.Tables.GetValue(Name, DisplayName, LCID);
          end;
      dtIdentifiers : begin
            CurrentList:=Dictionary.Fields.KeyList[LCID];
            if (CurrentList<> nil) and (CurrentList.Count > 0) then
              Dictionary.Fields.GetValue(Name, DisplayName, LCID);
          end;
      dtRelations : begin
            CurrentList:=Dictionary.Relations.KeyList[LCID];
            if (CurrentList<> nil) and (CurrentList.Count > 0) then
              Dictionary.Relations.GetValue(Name, DisplayName, LCID);
          end;
      dtSortOrders : begin

          end;
    end;
    if DisplayName <> '' then
      Result := DisplayName
end;

procedure TL17_.SetUseChartFields(nMode: TPropYesNo);
begin
  if (nMode = Yes) then
  begin
    LlSetOption(LL_OPTION_USECHARTFIELDS, 1);
    bUseChartFields := True;
  end
  else
  begin
    LlSetOption(LL_OPTION_USECHARTFIELDS, 0);
    bUseChartFields := False;
  end;
end;



procedure TL17_.SetIncludeFontDescent(nMode: TPropYesNo);
begin
  if (nMode = Yes) then
  begin
    LlSetOption(LL_OPTION_INCLUDEFONTDESCENT, 1);
    bIncludeFontDescent := True;
  end
  else
  begin
    LlSetOption(LL_OPTION_INCLUDEFONTDESCENT, 0);
    bIncludeFontDescent := False;
  end;
end;

procedure TL17_.SetIncrementalPreview(const Value: integer);
begin
  FIncrementalPreview := Value;
  LlSetOption(LL_OPTION_INCREMENTAL_PREVIEW, FIncrementalPreview);
end;

procedure TL17_.SetInplaceDesignerHandle(const Value: HWND);
begin
  FInplaceDesignerHandle := Value;
end;

procedure TL17_.SetInterCharSpacing(nMode: TPropYesNo);
begin
  if (nMode = Yes) then
  begin
    LlSetOption(LL_OPTION_INTERCHARSPACING, 1);
    bInterCharSpacing := True;
  end
  else
  begin
    LlSetOption(LL_OPTION_INTERCHARSPACING, 0);
    bInterCharSpacing := False;
  end;
end;



procedure TL17_.SetDialogBoxMode(nMode: TDialogBoxMode);
  var UIStyleOption: integer;
begin

  UIStyleOption:=LL_OPTION_UISTYLE_STANDARD;
  nDialogBoxValue:=LL_DLGBOXMODE_ALT9;

  case nMode of
    dmwin16: nDialogBoxValue := LL_DLGBOXMODE_SAA;
    dmcombit1: nDialogBoxValue := LL_DLGBOXMODE_ALT1;
    dmcombit2: nDialogBoxValue := LL_DLGBOXMODE_ALT2;
    dmcombit3: nDialogBoxValue := LL_DLGBOXMODE_ALT3;
    dmcombit4: nDialogBoxValue := LL_DLGBOXMODE_ALT4;
    dmcombit5: nDialogBoxValue := LL_DLGBOXMODE_ALT5;
    dmcombit6: nDialogBoxValue := LL_DLGBOXMODE_ALT6;
    dmcombit7: nDialogBoxValue := LL_DLGBOXMODE_ALT7;
    dmwin95: nDialogBoxValue := LL_DLGBOXMODE_ALT8;
    dmoffice97: nDialogBoxValue := LL_DLGBOXMODE_ALT9;
    dmOfficeXP: UIStyleOption:= LL_OPTION_UISTYLE_OFFICEXP;
    dmOffice2003:UIStyleOption:= LL_OPTION_UISTYLE_OFFICE2003;
  end;

  nDialogBoxMode := nMode;
  if UIStyleOption = LL_OPTION_UISTYLE_STANDARD then
  begin
          LlSetDlgBoxMode(nDialogBoxValue or nButtonsValue);
          LlSetOption(LL_OPTION_UISTYLE, UIStyleOption);
  end
  else
  begin
          LlSetDlgBoxMode(LL_DLGBOXMODE_ALT9 or nButtonsValue);
          LlSetOption(LL_OPTION_UISTYLE, UIStyleOption);
  end;
end;

procedure TL17_.SetDictionary(const Value: TDictionary);
begin
  FDictionary := Value;
end;

function TL17_.GetDialogBoxMode: TDialogBoxMode;
begin
  Result := nDialogBoxMode;
end;

procedure TL17_.UpdateButtonsValue;
begin
  if GetButtons3D = Yes then nButtonsValue := nButtonsValue or LL_DLGBOXMODE_3DBUTTONS
  else
    nButtonsValue := nButtonsValue and (not LL_DLGBOXMODE_3DBUTTONS);
  if GetButtonsWithBitmaps = No then
    nButtonsValue := nButtonsValue or LL_DLGBOXMODE_NOBITMAPS
  else
    nButtonsValue := nButtonsValue and (not LL_DLGBOXMODE_NOBITMAPS);
  DialogBoxMode:=DialogBoxMode;

end;


function TL17_.GetButtons3D: TPropYesNo;
begin
  if bButtons3D = True then Result := Yes 
  else 
    Result := No;
end;

procedure TL17_.SetButtons3D(nMode: TPropYesNo);
begin
  if nMode = Yes then
    bButtons3D := True
  else
    bButtons3D := False;
  UpdateButtonsValue;
end;

function TL17_.GetButtonsWithBitmaps: TPropYesNo;
begin
  if bButtonsWithBitmaps = True then Result := Yes 
  else 
    Result := No;
end;

procedure TL17_.SetButtonsWithBitmaps(nMode: TPropYesNo);
begin
  if nMode = Yes then
    bButtonsWithBitmaps := True
  else
    bButtonsWithBitmaps := False;
  UpdateButtonsValue;
end;

function TL17_.GetXlatVarNames: TPropYesNo;
begin
  if bXlatVarNames = True then Result := Yes
  else 
    Result := No;
end;


procedure TL17_.SetXlatVarnames(nMode: TPropYesNo);
begin
  if nMode = Yes then
  begin
    bXlatVarNames := True;
    LlSetOption(LL_OPTION_XLATVARNAMES, 1);
  end
  else
  begin
    bXlatVarNames := False;
    LlSetOption(LL_OPTION_XLATVARNAMES, 0);
  end;
end;

function TL17_.GetCreateInfo: TPropYesNo;
begin
  if bCreateInfo = True then Result := Yes 
  else 
    Result := No;
end;


procedure TL17_.SetCreateInfo(nMode: TPropYesNo);
begin
  if nMode = Yes then
  begin
    bCreateInfo := True;
    LlSetOption(LL_OPTION_SETCREATIONINFO, 1);
  end
  else
  begin
    bCreateInfo := False;
    LlSetOption(LL_OPTION_SETCREATIONINFO, 0);
  end;
end;



procedure TL17_.TableFieldCallback(pSCF: PSCLLTABLEFIELD);
var 
  Canvas: TCanvas;
begin
  if Assigned(FOnTableFieldCallback) then
  begin
    Canvas := TCanvas.Create;
    try
      Canvas.Handle := pSCF^._hPaintDC;
      FOnTableFieldCallback(Self, TTableFieldType(pSCF^._nType), Canvas,
        pSCF^._rcPaint, pSCF^._nLineDef, pSCF^._nIndex, pSCF^._rcSpacing);
    finally
      Canvas.Free;
    end;
  end;
end;

procedure TL17_.TableLineCallback(pSCL: PSCLLTABLELINE);
var
  Canvas: TCanvas;
begin
  if Assigned(FOnTableLineCallback) then
  begin
    Canvas := TCanvas.Create;
    try
      Canvas.Handle := pSCL^._hPaintDC;
      FOnTableLineCallback(Self, TTableLineType(pSCL^._nType), Canvas,
        pSCL^._rcPaint, pSCL^._nPageLine, pSCL^._nLine, pSCL^._bZebra, pSCL^._rcSpacing);
    finally
      Canvas.Free;
    end;
  end;
end;

function TL17_.TranslateRelationFieldName(RelFieldName: TString; LCID: integer): TString;
var
   Part: array[0..1] of string;
   Otherpart: array[0..1] of string;
begin

  Result := '';

  if ( (pos('@',RelFieldName) > 0) and (pos(':',RelFieldName)>0) ) then //relations with a key field
  begin
    Part[0] := Copy(RelFieldName,0,pos('@',RelFieldName)-1);
    Part[1] := Copy(RelFieldName,pos('@',RelFieldName)+1,Length(RelFieldName)-pos('@',RelFieldName));

    Result := Result + GetPairedItemDisplayString(Part[0], LCID) + '@';

    Otherpart[0] := Copy(Part[1],0,pos(':',Part[1])-1);
    Otherpart[1] := Copy(Part[1],pos(':',Part[1])+1,Length(Part[1])-pos(':',Part[1]));

    Result := Result + GetPairedItemDisplayString(Otherpart[0], LCID) + ':';

    Result := Result + TranslateRelationFieldName(Otherpart[1], LCID);

  end else
  if ( pos(':',RelFieldName) > 0 ) then //relations without a key field
  begin

    Part[0] := Copy(RelFieldName,0,pos(':',RelFieldName)-1);
    Part[1] := Copy(RelFieldName,pos(':',RelFieldName)+1,Length(RelFieldName)-pos(':',RelFieldName));

    Result := Result + GetItemDisplayName(Part[0],dtTables, LCID) + ':';

    if ( pos(':', Part[1]) <= 0 ) then
    begin
      Result := Result + GetPairedItemDisplayString(Part[1], LCID);
    end else
    begin

      Otherpart[0] := Copy(Part[1],0,pos(':',Part[1])-1);
      Otherpart[1] := Copy(Part[1],pos(':',Part[1])+1,Length(Part[1])-pos(':',Part[1]));

      Result := Result + GetItemDisplayName(Otherpart[0],dtTables, LCID) + ':';


      if ( pos(':', Otherpart[1]) <= 0 ) then
        Result := Result + GetPairedItemDisplayString(Otherpart[1], LCID)
      else
       Result := Result + TranslateRelationFieldName(Otherpart[1], LCID);

    end;

  end else
  begin
    Result := GetItemDisplayName(RelFieldName,dtIdentifiers,LCID);
  end;

end;

procedure TL17_.DrawUserobjCallback(pSCD: PSCLLDRAWUSEROBJ);
var
  Canvas: TCanvas;
begin
  if Assigned(FOnDrawUserobjCallback) then
  begin
    Canvas := TCanvas.Create;
    try
      Canvas.Handle := pSCD^._hPaintDC;
      FOnDrawUserobjCallback(Self, TString(pSCD^._pszName),
        TString(pSCD^._pszContents), pSCD^._lPara, pSCD^._lpPtr, pSCD^._hPara,
        pSCD^._bIsotropic, TString(pSCD^._pszParameters), Canvas, pSCD^._rcPaint,
        TPaintMode(pSCD^._nPaintMode));
    finally
      Canvas.Free;
    end;
  end;
end;

procedure TL17_.EditUserobjCallback(pSCE: PSCLLEDITUSEROBJ);
var
  Parameters: TString;
  Isotropic: boolean;
begin
  if Assigned(FOnEditUserObjCallback) then
  begin
    Parameters := TString(pSCE^._pszParameters);
    Isotropic := pSCE^._bIsotropic;
    FOnEditUserobjCallback(Self, TString(pSCE^._pszName), pSCE^._lPara,
      pSCE^._lpPtr, pSCE^._hPara, Isotropic, pSCE^._HWND, Parameters);
    pSCE^._bIsotropic := Isotropic;
    TLl17HelperClass.CopyToBuffer(Parameters,pSCE^._pszParameters,pSCE^._nParaBufSize-1);
  end;
end;

procedure TL17_.PageCallback(pSCP: PSCLLPAGE);
var
  Canvas: TCanvas;
  Rect: TRect;
  Size: TSize;
  Point: TPoint;
begin
  if Assigned(FOnPageCallback) then
  begin
    Canvas := TCanvas.Create;
    try
      Canvas.handle := pSCP^._hPaintDC;
      GetWindowExtEx(Canvas.handle, Size);
      GetWindowOrgEx(Canvas.handle, Point);
      Rect.Top := Point.y;
      Rect.Bottom := Rect.Top + Size.cy;
      Rect.Left := Point.x;
      Rect.Right := Rect.Left + Size.cx;
      FOnPageCallback(Self, pSCP^._bDesignerPreview, pSCP^._bPreDraw, Canvas, Rect);
    finally
      Canvas.Free;
    end;
  end;
end;

procedure TL17_.ProjectCallback(pSCP: PSCLLPROJECT);
var 
  Canvas: TCanvas;
  Rect: TRect;
  Size: TSize;
  Point: TPoint;
begin
  if Assigned(FOnProjectCallback) then
  begin
    Canvas := TCanvas.Create;
    try
      Canvas.handle := pSCP^._hPaintDC;
      GetWindowExtEx(Canvas.handle, Size);
      GetWindowOrgEx(Canvas.handle, Point);
      Rect.Top := Point.y;
      Rect.Bottom := Rect.Top + Size.cy;
      Rect.Left := Point.x;
      Rect.Right := Rect.Left + Size.cx;
      FOnProjectCallback(Self, pSCP^._bDesignerPreview, pSCP^._bPreDraw, Canvas, Rect);
    finally
      Canvas.Free;
    end;
  end;
end;

function TL17_.DesignerPrintJobEvent(pSCD: PSCLLDESIGNERPRINTJOB): integer;
var
  returnValue: integer;
begin
  returnValue := 0;
  result := 0;
  if Assigned(FOnDesignerPrintJob) then
  begin
    FOnDesignerPrintJob(self, pSCD^._nUserParam, pSCD^._pszProjectFileName, pSCD^._pszOriginalProjectFileName,
                        pSCD^._nPages, pSCD^._nFunction, pSCD^._hWndPreviewControl, pSCD^._hEvent, returnValue);
    result := returnValue;
  end;
end;

function TL17_.DrillDownJobEvent(pSCD: PSCLLDRILLDOWNJOBINFO): integer;
var
  returnValue: integer;
begin
  result:=0;
  if Assigned(FOnDrillDownJob) then
  begin
    returnValue:=0;
    FOnDrillDownJob(self, pSCD^._nFunction, pSCD^._nUserParameter, pSCD^._pszTableID, pSCD^._pszRelationID, pSCD^._pszSubreportTableID,
    pSCD^._pszKeyField, pSCD^._pszSubreportKeyField, pSCD^._pszKeyValue, pSCD^._pszProjectFileName, pSCD^._pszPreviewFileName,
    pSCD^._pszTooltipText, pSCD^._pszTabText, pSCD^._hWnd, pSCD^._nID, pSCD^._hAttachInfo, returnValue);
    result:=returnValue;
  end;
end;


procedure TL17_.ProjectLoadedEvent;
begin
  if Assigned(FOnProjectLoaded) then
    FOnProjectLoaded(Self);
end;

procedure TL17_.InplaceDesignerClosedEvent;
begin
  if Assigned(FOnInplaceDesignerClosed) then
    FOnInplaceDesignerClosed(Self);
end;


procedure TL17_.ObjectCallback(pSCO: PSCLLOBJECT; var lResult: integer);
var 
  Canvas: TCanvas;
  Rect: TRect;
begin
  lResult := 0;
  if Assigned(FOnObjectCallback) then
  begin
    Canvas := TCanvas.Create;
    try
      Canvas.Handle := pSCO^._hPaintDC;
      Rect := pSCO^._rcPaint;
      FOnObjectCallback(Self, TString(pSCO^._pszName), TObjectType(pSCO^._nType),
        pSCO^._bPreDraw, Canvas, Rect, lResult);
      pSCO^._rcPaint := Rect;
    finally
      Canvas.Free;
    end;
  end;
end;


procedure TL17_.ExtFctCallback(pSCP: PSCLLEXTFCT);
var 
  Result, Error: TString;
  HasError: boolean;
begin
  if Assigned(FOnExtFctCallback) then
  begin
    HasError := False;
    Result := '';
    Error := '';
    FOnExtFctCallback(Self, TString(pSCP^._pszContents), pSCP^._bEvaluate,
      Result, HasError, Error);

    if (HasError) then
      pSCP^._bError := 1
    else
      pSCP^._bError := 0;

    TLl17HelperClass.CopyToBuffer(Result,pSCP^._szNewValue, $4000);
    TLl17HelperClass.CopyToBuffer(Error,pSCP^._szError, 127);
  end;
end;

procedure TL17_.FailsFilterCallback;
begin
  if Assigned(FOnFailsFilterCallback) then
    FOnFailsFilterCallback(Self);
end;

procedure TL17_.HelpCallback(nHelpCommand: integer; nContextID: integer;
  var lResult: integer);
begin
  lResult := 0;
  if Assigned(FOnHelpCallback) then
    FOnHelpCallback(Self, nHelpCommand, nContextID, lResult);
end;

procedure TL17_.EnableMenuCallback(nMenuHandle: integer);
begin
  if Assigned(FOnEnableMenuCallback) then
    FOnEnableMenuCallback(Self, nMenuHandle);
end;

procedure TL17_.ModifyMenuCallback(nMenuHandle: integer);
begin
  if Assigned(FOnModifyMenuCallback) then
    FOnModifyMenuCallback(Self, nMenuHandle);
end;

procedure TL17_.SaveFileNameCallback(pszFileName: PTChar);
begin
  if Assigned(FOnSaveFileName) then
    FOnSaveFileName(Self, pszFileName);
end;

procedure TL17_.SelectMenuCallback(nMenuID: integer; var lResult: integer);
begin
  lResult := 0;
  if Assigned(FOnSelectMenuCallback) then
    FOnSelectMenuCallback(Self, nMenuID, lResult);
end;

function TL17_.ButtonFromLLValue(Value: integer): TViewerButton;
begin
  Result := vbFirstPage;
  case Value of
    102: Result := vbFirstPage;
    104: Result := vbPreviousPage;
    105: Result := vbNextPage;
    103: Result := vbLastPage;
    100: Result := vbZoomIn;
    101: Result := vbZoomOut;
    108: Result := vbViewPage;
    112: Result := vbPrintPage;
    113: Result := vbPrintAll;
    114: Result := vbExit;
    115: Result := vbSendTo;
    116: Result := vbSaveAs;
    117: Result := vbFax;
    16496: Result := vbPrintPageWithPrinterSelection;
    16497: Result := vbPrintAllWithPrinterSelection;

  end;
end;

function TL17_.LLValueFromButton(Value: TViewerButton): integer;
begin
  Result := 0;
  case Value of
    vbFirstPage: Result := 102;
    vbPreviousPage: Result := 104;
    vbNextPage: Result := 105;
    vbLastPage: Result := 103;
    vbZoomIn: Result := 100;
    vbZoomOut: Result := 101;
    vbViewPage: Result := 108;
    vbPrintPage: Result := 112;
    vbPrintAll: Result := 113;
    vbExit: Result := 114;
    vbSendTo: Result := 115;
    vbSaveAs: Result := 116;
    vbFax: Result := 117;
  end;
end;


procedure TL17_.GetViewerButtonStateCallback(nID: integer; nState: integer;
  var lResult: integer);
var 
  OldState, NewState: TButtonState;

  function StateFromLLValue(State: integer): TButtonState;
  begin
    case State of
      1: Result := bsEnabled;
      2: Result := bsDisabled; -1: Result := bsInvisible;
      else
        Result := bsEnabled;
    end;
  end;

  function LLValueFromState(State: TButtonState): integer;
  begin
    case State of
      bsEnabled: Result := 1;
      bsDisabled: Result := 2;
      bsInvisible: Result := -1;
      else
        Result := 0;
    end;
  end;
begin
  lResult := 0;

  if Assigned(FOnGetViewerButtonStateCallback) then
  begin
    OldState := StateFromLLValue(nState);
    NewState := OldState;
    FOnGetViewerButtonStateCallback(Self, ButtonFromLLValue(nID), NewState);
    if NewState = OldState then lResult := 0 
    else 
      lResult := LLValueFromState(NewState);
  end;
end;

procedure TL17_.ViewerButtonClickedCallback(nID: integer; var lResult: integer);
var 
  DoAction: boolean;
begin
  lResult := 0;
  if Assigned(FOnViewerButtonClickedCallback) then
  begin
    DoAction := True;
    FOnViewerButtonClickedCallback(Self, ButtonFromLLValue(nID), DoAction);
    if DoAction then lResult := 0 
    else 
      lResult := 1;
  end;
end;

procedure TL17_.VarHelpTextCallback(const pszVarName: PTChar;
  var pszHelpText: PTChar);
var
  HelpText: TString;
begin
  if Assigned(FOnVarHelpTextCallback) then
  begin
    FOnVarHelpTextCallback(Self, TString(pszVarName), HelpText);
    TLl17HelperClass.CopyToBuffer(HelpText, pszHelpText, 1024);
  end;
end;

procedure TL17_.NtfyExprErrorCallback(pszErrorText: PTChar; var lResult: integer);
begin
  if Assigned(FOnExprError) then
   FOnExprError(self, pszErrorText, lResult);
end;

procedure TL17_.NtfyProgressCallback(pSCM: PSCLLMETERINFO);
begin
  if Assigned(FOnNtfyProgressCallback) then
    FOnNtfyProgressCallback(Self, pSCM^._HWND_, pSCM^._nTotal,
      pSCM^._nCurrent, TMeterJob(pSCM^._nJob));
end;

procedure TL17_.HostPrinterCallback(pSCHP: PSCLLPRINTER;
  var lResult: integer);
begin
  if Assigned(FOnHostPrinterCallback) then
    FOnHostPrinterCallback(Self, pSCHP, lResult);
end;

procedure TL17_.DlgExprVarBtnCallback(pSCDE: PSCLLDLGEXPRVAREXT;
  var lResult: integer);
begin
  if Assigned(FOnDlgExprVarBtnCallback) then
    FOnDlgExprVarBtnCallback(Self, pSCDE, lResult);
end;

procedure TL17_.DefineVariablesCallback(nUserData: integer; bDummy: integer;
  pnProgressInPerc: Pinteger;
  pbLastRecord: Pinteger; var lResult: integer);
var 
  Dummy: boolean;
  IsLastRecord: boolean;
  Perc: integer;
begin
  if Assigned(FOnDefineVariablesCallback) then
  begin
    if pbLastRecord^=1 then
        IsLastRecord:=True
    else
        IsLastRecord := False;
    if bDummy = 0 then Dummy := False 
    else 
      Dummy := True;
    FOnDefineVariablesCallback(Self, nUserData, Dummy, Perc,
      IsLastRecord, lResult);
    pnProgressInPerc^ := Perc;
    if IsLastRecord then pbLastRecord^ := 1 
    else 
      pbLastRecord^ := 0;
  end;
end;

procedure TL17_.DefineFieldsCallback(nUserData: integer; bDummy: integer;
  pnProgressInPerc: Pinteger;
  pbLastRecord: Pinteger; var lResult: integer);
var
  Dummy: boolean;
  IsLastRecord: boolean;
  Perc: integer;
begin
  if Assigned(FOnDefineFieldsCallback) then
  begin
    if pbLastRecord^=1 then
        IsLastRecord:=True
    else
        IsLastRecord := False;
    if bDummy = 0 then Dummy := False
    else
      Dummy := True;
    FOnDefineFieldsCallback(Self, nUserData, Dummy, Perc,
      IsLastRecord, lResult);
    pnProgressInPerc^ := Perc;
    if IsLastRecord then pbLastRecord^ := 1
    else
      pbLastRecord^ := 0;
  end
  else
    pbLastRecord^ := 1;
end;

procedure TL17_.PrintJobInfoCallback(pSCI:PSCLLPRINTJOBINFO);
begin
    if Assigned (FOnPrintJobInfo) then
    begin
        FOnPrintJobInfo(self, pSCI^._hLlJob, pSCI^._szDevice, pSCI^._dwJobID, pSCI^._dwState);
    end;
end;

(******************************************************************************)


(*function design*)



function TL17_.Design(UserData: integer; ParentHandle: cmbtHWND; Title: TString;
  ProjectType: integer; ProjectName: TString; ShowFileSelect: boolean; AllowCreate: boolean): integer;
var
  nProgressInPerc: integer;
  bLastRecord: integer;
  nRet: integer;
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
    end;
  end;

  (*end of initialization; now get the Variables and Fields*)

  LlDefineVariableStart;
  LlDefineChartFieldStart;
  LlDefineFieldStart;

  DefineVariablesCallback(UserData, 1, @nProgressInPerc, @bLastRecord, nRet);
  DefineFieldsCallback(UserData, 1, @nProgressInPerc, @bLastRecord, nRet);


  Result := LlDefineLayout(ParentHandle, Title,
    ProjectType and $7FFF, ProjectName);
end;



(*function print*)


function TL17_.Print(UserData: integer; ProjectType: integer;
  ProjectName: TString;
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
  bToPreview: boolean;
  bDummy: integer;
  bLabelPrinting: boolean;
  nOptions: integer;
begin
  nRet := 0;
  nProgressInPerc := 0;
  bLastRecord := 0;
  sPath := '';
  sDir := '';
  sPort := '';
  sPrinter := '';
  nCopies := 1;
  nOptions := 0;
  btmpDelayTableHeader := bDelayTableHeader;
  bLabelPrinting := ((ProjectType = LL_PROJECT_LABEL) or (ProjectType = LL_PROJECT_CARD));

  if (ShowFileSelect) then
  begin
    nRet := self.LlSelectFileDlgTitle(ParentHandle, '', ProjectType and $7FFF, ProjectName);
    if (nRet <> 0) then
    begin
      Result := nRet;
      exit;
    end;
  end;

  (*define all variables*)

  LlDefineVariableStart;
  LlDefineChartFieldStart;

  DefineVariablesCallback(UserData, 1, @nProgressInPerc, @bLastRecord, nRet);


  (*define all fields if list project*)

  if ProjectType = LL_PROJECT_LIST then
  begin
    LlDefineFieldStart;
    DefineFieldsCallback(UserData, 1, @nProgressInPerc, @bLastRecord, nRet);
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

  LlPrintGetPrinterInfo(sPrinter, sPort);


  (*Destination may have changed*)
  if LlPrintGetOption(LL_PRNOPT_PRINTDLG_DEST) = LL_DESTINATION_PRV then
    bToPreview := True
  else
    bToPreview := False;

  (*set preview file path and name*)
  if bToPreview = True then
  begin
    sPreviewFile := TempPath + ExtractFileName(sPath);
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
      DefineVariablesCallback(UserData, 0, @nProgressInPerc, @bLastRecord, nRet);
      if nProgressInPerc < 0 then
        nProgressInPerc := 0
      else if nProgressInPerc > 100 then
        nProgressInPerc := 100;

      nRet := LlPrintSetBoxText(sPrinter, nProgressInPerc);

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

    // init first page
    DefineVariablesCallback(UserData, 0, @nProgressInPerc, @bLastRecord, nRet);
    while (LlPrint=LL_WRN_REPEAT_DATA) do;

    while (bLastRecord = 0) and (nRet = 0) do
    begin  {lines}
      DefineFieldsCallback(UserData, 0, @nProgressInPerc, @bLastRecord, nRet);

      if nProgressInPerc < 0 then
        nProgressInPerc := 0
      else if nProgressInPerc > 100 then
        nProgressInPerc := 100;

      nRet := LlPrintSetBoxText(sPrinter,
        nProgressInPerc);

      if nRet = LL_ERR_USER_ABORTED then
      begin
        LlPrintEnd(0);
        if btmpDelayTableHeader = False then
          LlSetOption(LL_OPTION_DELAYTABLEHEADER, 0);
        Result := nRet;
        exit;
      end;
      nRet := LlPrintFields;
      while nRet = LL_WRN_REPEAT_DATA do
      begin
		bDummy := bLastRecord;
        DefineVariablesCallback(UserData, 0, @nProgressInPerc, @bDummy, nRet);
        LlPrint;
        nRet := LlPrintFields;
      end;

      if (self.UseChartFields = Yes) then
        LlPrintDeclareChartRow(LL_DECLARECHARTROW_FOR_OBJECTS);
    end;  {lines}

    repeat
      nRet := LlPrintFieldsEnd;
    until nRet <> LL_WRN_REPEAT_DATA;
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

(******************************************************************************)

procedure TL17_.LlSetDebug(DebugMode: integer);
begin
  nDebug := DebugMode;
  cmbtll17.LlSetDebug(nDebug);
end;

function TL17_.LlGetVersion(VersionType: integer): integer;
begin
  result:= cmbtll17.LlGetVersion(VersionType);
end;

function TL17_.LlGetNotificationMessage: word;
begin
  result:= cmbtll17.LlGetNotificationMessage(hTheJob);
end;

function TL17_.LlSetNotificationMessage(Message: word): integer;
begin
  result:= cmbtll17.LlSetNotificationMessage(hTheJob, Message);
end;

function TL17_.LlSetNotificationCallback(_lpfnNotify: tFarproc): tFarproc;
begin
  result:=cmbtll17.LlSetNotificationCallback(hTheJob, _lpfnNotify);
end;

function TL17_.LlDefineField(FieldName: TString;
  Contents: TString): integer;
begin
  if not bIsPrinting then
    Dictionary.Fields.AddComplexItems(FieldName);
  Result := cmbtll17.LlDefineField(hTheJob, PTChar(FieldName), PTChar(Contents));
end;

function TL17_.LlDefineFieldExt(FieldName: TString;
  Contents: TString;
  FieldType: integer
  ): integer;
begin
  if not bIsPrinting then
    Dictionary.Fields.AddComplexItems(FieldName);
  Result := cmbtll17.LlDefineFieldExt(hTheJob, PTChar(FieldName),
   PTChar(Contents), FieldType, nil);
end;

function TL17_.LlDefineFieldExtHandle(FieldName: TString;
  Handle: THandle;
  FieldType: integer
  ): integer;
begin
  if not bIsPrinting then
    Dictionary.Fields.AddComplexItems(FieldName);
  Result := cmbtll17.LlDefineFieldExtHandle(hTheJob, PTChar(FieldName),
    Handle, FieldType, nil);
end;

procedure TL17_.LlDefineFieldStart;
begin
  cmbtll17.LlDefineFieldStart(hTheJob);
end;

function TL17_.LlDefineLayout(ParentHandle: cmbtHWND; Title: TString; ProjectType: word; ProjectName: TString): integer;
var
  i, currentId: integer;
begin
  {$ifdef USELLXOBJECTS}
  DeclareLlXObjectsToLL;
  {$endif}
  currentId := 10100;
  for i := 0 to FLlXActionList.Count - 1 do
  begin
    TLl17XAction(FLlXActionList.Items[i]).MenuId := currentId;
    TLl17XAction(FLlXActionList.Items[i]).AddAction();
    Inc(currentId);
  end;

  for i := 0 to DesignerWorkspace.FProhibitedAction.FProhibitedActionList.Count - 1 do
    LlDesignerProhibitAction(StrToInt(DesignerWorkspace.FProhibitedAction.FProhibitedActionList.Strings[i]));

  for i := 0 to DesignerWorkspace.FProhibitedFunction.FProhibitedFunctionList.Count - 1 do
    LlDesignerProhibitFunction(DesignerWorkspace.FProhibitedFunction.FProhibitedFunctionList.Strings[i]);

  for i := 0 to DesignerWorkspace.FReadOnlyObject.FReadOnlyObjectList.Count - 1 do
    LlDesignerProhibitEditingObject(DesignerWorkspace.FReadOnlyObject.FReadOnlyObjectList.Strings[i]);
  if (InplaceDesignerHandle = 0) then
  begin
    Result := cmbtll17.LlDefineLayout(hTheJob, ParentHandle, PTChar(Title), ProjectType, PTChar(ProjectName));
  end
  else
  begin
    Result := cmbtll17.LlDefineLayout(hTheJob, InplaceDesignerHandle, PTChar(Title), ProjectType or $2000, PTChar(ProjectName));
  end;
  {$ifdef USELLXOBJECTS}
  LlSetOption(53,0);
  FLlXInterface:=nil;
  {$endif}
end;

function TL17_.LlDefineVariable(VariableName: TString;
  Contents: TString): integer;
begin
  if not bIsPrinting then
    Dictionary.Fields.AddComplexItems(VariableName);
  Result := cmbtll17.LlDefineVariable(hTheJob, PTChar(VariableName), PTChar(Contents));
end;

function TL17_.LlDefineVariableExt(VariableName: TString;
  Contents: TString;
  VariableType: integer
  ): integer;
begin
  if not bIsPrinting then
    Dictionary.Fields.AddComplexItems(VariableName);
  Result := cmbtll17.LlDefineVariableExt(hTheJob, PTChar(VariableName),
    PTChar(Contents), VariableType, nil);
end;

function TL17_.LlDefineVariableExtHandle(VariableName: TString;
  Handle: THandle;
  VariableType: integer
  ): integer;
begin
  if not bIsPrinting then
    Dictionary.Fields.AddComplexItems(VariableName);
  Result := cmbtll17.LlDefineVariableExtHandle(hTheJob, PTChar(VariableName),
    Handle, VariableType, nil);
end;


procedure TL17_.LlDefineVariableStart;
begin
  cmbtll17.LlDefineVariableStart(hTheJob);
end;

function TL17_.LlPreviewSetTempPath(Path: TString
  ): integer;
begin
  Result := cmbtll17.LlPreviewSetTempPath(hTheJob, PTChar(Path));
end;

function TL17_.LlPreviewDeleteFiles(ProjectName: TString;
  PreviewFilePath: TString
  ): integer;
begin
  Result := cmbtll17.LlPreviewDeleteFiles(hTheJob, PTChar(ProjectName),
    PTChar(PreviewFilePath));
end;

function TL17_.LlPreviewDisplay(ProjectName: TString;
  PreviewFilePath: TString;
  ParentHandle: cmbtHWND
  ): integer;
begin
  Result := cmbtll17.LlPreviewDisplay(hTheJob, PTChar(ProjectName),
    PTChar(PreviewFilePath), ParentHandle);
end;

function TL17_.LlPrint: integer;
begin
  Result := cmbtll17.LlPrint(hTheJob);
end;

function TL17_.LlPrintAbort: integer;
begin
  Result := cmbtll17.LlPrintAbort(hTheJob);
end;

function TL17_.LlPrintCheckLineFit: wordbool;
begin
  Result := cmbtll17.LlPrintCheckLineFit(hTheJob);
end;

function TL17_.LlPrintEnd(AdditionalPages: integer): integer;
begin
  Result := cmbtll17.LlPrintEnd(hTheJob, AdditionalPages);
  {$ifdef USELLXOBJECTS}
  LlSetOption(53,0);
  FLlXInterface:=nil;
  {$endif}
  
  bIsPrinting := False;
end;

function TL17_.LlPrintFieldsEnd: integer;
begin
  Result := cmbtll17.LlPrintFieldsEnd(hTheJob);
end;

function TL17_.LlPrintFields: integer;
begin
  Result := cmbtll17.LlPrintFields(hTheJob);
end;

function TL17_.LlPrintGetCurrentPage: integer;
begin
  Result := cmbtll17.LlPrintGetCurrentPage(hTheJob);
end;

function TL17_.LlPrintGetItemsPerPage: integer;
begin
  Result := cmbtll17.LlPrintGetItemsPerPage(hTheJob);
end;

function TL17_.LlPrintGetItemsPerTable: integer;
begin
  Result := cmbtll17.LlPrintGetItemsPerTable(hTheJob);
end;

function TL17_.LlPrintGetRemainingItemsPerTable(FieldName: TString
  ): integer;
begin
  Result := cmbtll17.LlPrintGetRemainingItemsPerTable(hTheJob, PTChar(FieldName));
end;


function TL17_.LlPrintGetOption(OptionIndex: integer
  ): integer;
begin
  Result := cmbtll17.LlPrintGetOption(hTheJob, OptionIndex);
end;

function TL17_.LlPrintGetPrinterInfo(var PrinterName, PrinterPort: TString
  ): integer;
var
  BufPrinter, BufPort: PTChar;
begin
  GetMem(BufPrinter, 128 * sizeof(tChar));
  GetMem(BufPort, 40 * sizeof(tChar));
  BufPrinter^ := #0;
  BufPort^ := #0;
  Result := cmbtll17.LlPrintGetPrinterInfo(hTheJob, BufPrinter, 128 - 1, BufPort, 40 - 1);
  PrinterName := TString(BufPrinter);
  PrinterPort := TString(BufPort);
  FreeMem(BufPrinter);
  FreeMem(BufPort);
end;

function TL17_.LlPrintOptionsDialog(ParentHandle: cmbtHWND;
  DialogText: TString): integer;
begin
  Result := cmbtll17.LlPrintOptionsDialog(hTheJob, ParentHandle, PTChar(DialogText));
end;

function TL17_.LlPrintSelectOffset(ParentHandle: cmbtHWND): integer;
begin
  result:=cmbtll17.LlPrintSelectOffsetEx(hTheJob, ParentHandle);
end;

function TL17_.LlPrintSetBoxText(Text: TString;
  Percentage: integer
  ): integer;
begin
  Result := cmbtll17.LlPrintSetBoxText(hTheJob, PTChar(Text), Percentage);
end;

function TL17_.LlPrintSetOption(Index: integer;
  Value: integer
  ): integer;
begin
  Result := cmbtll17.LlPrintSetOption(hTheJob, Index, Value);
end;

function TL17_.LlPrintStart(ProjectType: word;
  ProjectName: TString;
  PrintOptions: integer
  ): integer;
begin
  {$ifdef USELLXOBJECTS}
  DeclareLlXObjectsToLL;
  {$endif}
  Result := cmbtll17.LlPrintStart(hTheJob, ProjectType, PTChar(ProjectName),
    PrintOptions, 0);
  bIsPrinting := True;
end;

function TL17_.LlPrintWithBoxStart(ProjectType: word;
  ProjectName: TString;
  PrintOptions: integer;
  BoxType: integer;
  ParentHandle: cmbtHWND;
  Title: TString
  ): integer;
begin
  {$ifdef USELLXOBJECTS}
  DeclareLlXObjectsToLL;
  {$endif}
  Result := cmbtll17.LlPrintWithBoxStart(hTheJob, ProjectType, PTChar(ProjectName),
    PrintOptions, BoxType, ParentHandle, PTChar(Title));
  bIsPrinting := True;
end;




function TL17_.LlPrinterSetup(ParentHandle: cmbtHWND;
  ProjectType: word;
  ProjectName: TString
  ): integer;
begin
  Result := cmbtll17.LlPrinterSetup(hTheJob, ParentHandle, ProjectType,
    PTChar(ProjectName));
end;


function TL17_.LlSelectFileDlg(ParentHandle: cmbtHWND;
  ProjectType: word;
  var ProjectName: TString
  ): integer;
var
  pszProjectName: PTChar;
begin
  pszProjectName := nil;
  StrPCopyExt(pszProjectName, ProjectName, 1024);
  Result := cmbtll17.LlSelectFileDlgTitleEx(hTheJob, ParentHandle,
    nil, ProjectType, pszProjectName, 1024 - 1, nil);
  ProjectName := TString(pszProjectName);
  FreeMem(pszProjectName);
end;

function TL17_.LlSelectFileDlgTitle(ParentHandle: cmbtHWND;
  Title: TString;
  ProjectType: word;
  var ProjectName: TString
  ): integer;
var 
  pszProjectName: PTChar;
begin
  pszProjectName := nil;
  StrPCopyExt(pszProjectName, ProjectName, 1024);
  Result := cmbtll17.LlSelectFileDlgTitleEx(hTheJob, ParentHandle,
    PTChar(Title), ProjectType, pszProjectName, 1024 - 1, nil);
  ProjectName := TString(pszProjectName);
  FreeMem(pszProjectName);
end;

procedure TL17_.LlSetDlgboxMode(Mode: cardinal
  );
begin
  cmbtll17.LlSetDlgBoxMode(Mode);
end;

function TL17_.LlGetDlgboxMode: cardinal;
begin
  Result := cmbtll17.LlGetDlgBoxMode;
end;

function TL17_.LlGetErrortext(returnValue: integer): TString;
var
  Buffer: PTChar;
  length: integer;
begin
  length := cmbtll17.LlGetErrortext(returnValue, nil, 0);
  if length>0 then
  begin
    GetMem(Buffer, length * sizeof(TChar));
    Buffer^ := #0;
    cmbtll17.LlGetErrortext(returnValue, Buffer, length);
    Result := TString(Buffer);
    FreeMem(Buffer);
  end
  else
  begin
    result:='';
  end;
end;

function TL17_.LlSetOption(OptionIndex: integer;
  Value: lParam
  ): integer;
begin
  Result := cmbtll17.LlSetOption(hTheJob, OptionIndex, Value);
end;

function TL17_.LlGetOption(OptionIndex: integer
  ): integer;
begin
  Result := cmbtll17.LlGetOption(hTheJob, OptionIndex);
end;

function TL17_.LlDesignerAddAction(actionID, nFlags: Cardinal; menuText,
  menuHierarchy, tooltipText: TString; iconId: Cardinal;
  pvReserved: Pointer): integer;
begin
  Result := cmbtll17.LlDesignerAddAction(hTheJob, actionID, nFlags, PTChar(menuText), PTChar(menuHierarchy), PTChar(tooltipText),iconID, pvReserved);
end;

function TL17_.LlDesignerFileOpen(filename: TString; flags: Cardinal): integer;
begin
  result := cmbtll17.LlDesignerFileOpen(hTheJob, PTChar(filename), flags);
end;

function TL17_.LlDesignerFileSave(flags: Cardinal): integer;
begin
  result := cmbtll17.LlDesignerFileSave(hTheJob, flags);
end;

function TL17_.LlDesignerGetOptionString(option: integer; var OptionString: TString): integer;
var
  Buffer: PTChar;
  length: integer;
begin
    length := cmbtll17.LlDesignerGetOptionString(hTheJob, option, nil, 0);
    GetMem(Buffer, length * sizeof(TChar));
    Buffer^ := #0;
    Result := cmbtll17.LlDesignerGetOptionString(hTheJob, option, Buffer, length);
    OptionString := TString(Buffer);
    FreeMem(Buffer);
end;

function TL17_.LlDesignerInvokeAction(menuId: integer): integer;
begin
  result := cmbtll17.LlDesignerInvokeAction(hTheJob, menuId);
end;

function TL17_.LlDesignerProhibitAction(MenuID: integer): integer;
begin
  Result := cmbtll17.LlDesignerProhibitAction(hTheJob, MenuID);
end;

function TL17_.LlViewerProhibitAction(Button: TViewerButton): integer;
begin
  Result := cmbtll17.LlViewerProhibitAction(hTheJob, LLValueFromButton(Button));
end;

function TL17_.LlPrintEnableObject(ObjectName: TString; Enable: boolean): integer;
begin
  Result := cmbtll17.LlPrintEnableObject(hTheJob, PTChar(ObjectName), Enable);
end;

function TL17_.LlSetFileExtensions(ProjectType: integer;
  ProjectExtension: TString;
  PrinterExtension: TString;
  SketchExtension: TString
  ): integer;
begin
    Result := cmbtll17.LlSetFileExtensions(hTheJob, ProjectType,
    PTChar(ProjectExtension),
    PTChar(PrinterExtension),
    PTChar(SketchExtension));
end;


function TL17_.LlPrintIsVariableUsed(VariableName: TString): integer;
begin
  Result := cmbtll17.LlPrintIsVariableUsed(hTheJob, PTChar(VariableName));
end;

function TL17_.LlPrintIsFieldUsed(FieldName: TString): integer;
begin
  Result := cmbtll17.LlPrintIsFieldUsed(hTheJob, PTChar(FieldName));
end;

function TL17_.LlPrintOptionsDialogTitle(ParentHandle: cmbtHWND;
  Title: TString;
  DialogText: TString
  ): integer;
begin
  Result := cmbtll17.LlPrintOptionsDialogTitle(hTheJob,
    ParentHandle, PTChar(Title), PTChar(DialogText));
end;


function TL17_.LlSetPrinterToDefault(ProjectType: integer;
  ProjectName: TString
  ): integer;
begin
  Result := cmbtll17.LlSetPrinterToDefault(hTheJob,
    ProjectType, PTChar(ProjectName));
end;

function TL17_.LlSetPrinterDefaultsDir(Directory: TString
  ): integer;
begin
  Result := cmbtll17.LlSetPrinterDefaultsDir(hTheJob, PTChar(Directory));
end;

function TL17_.LlCreateSketch(ProjectType: cardinal;
  ProjectName: TString
  ): integer;
begin
  result:=cmbtll17.LlCreateSketch(hTheJob, ProjectType, PTChar(ProjectName));
end;


function TL17_.LlDefineSortOrderStart: integer;
begin
  Result := cmbtll17.LlDefineSortOrderStart(hTheJob);
end;

function TL17_.LlDefineSortOrder(Identifier: TString;
  Text: TString
  ): integer;
begin
  Result := cmbtll17.LlDefineSortOrder(hTheJob, PTChar(Identifier), PTChar(Text));
end;

function TL17_.LlPrintGetSortOrder(var SortOrder: TString): integer;
var
  Buffer: PTChar;
  length: integer;
begin
  length := cmbtll17.LlPrintGetSortOrder(hTheJob, nil, 0);
  if length>0 then
  begin
    GetMem(Buffer, length * sizeof(TChar));
    Buffer^ := #0;
    Result := cmbtll17.LlPrintGetSortOrder(hTheJob, Buffer, length);
    SortOrder := TString(Buffer);
    FreeMem(Buffer);
  end
  else
  begin
    SortOrder:='';
    Result:=length;
  end;
end;

function TL17_.LlAddCtlSupport(Handle: cmbtHWND;
  Flags: integer
  ): integer;
begin
  Result := cmbtll17.LlAddCtlSupport(Handle, Flags, nil);
end;


function TL17_.LlAssociatePreviewControl(PreviewControl: HWND; flags: Cardinal): integer;
begin
  result := cmbtll17.LlAssociatePreviewControl(hTheJob, PreviewControl, flags);
end;

function TL17_.LlPrintGetFilterExpression(var Expression: TString
  ): integer;
var
  Buffer: PTChar;
  length: integer;
begin
  length := cmbtll17.LlPrintGetFilterExpression(hTheJob, nil, 0);
  if length>0 then
  begin
    GetMem(Buffer, length * sizeof(TChar));
    Buffer^ := #0;
    result:=cmbtll17.LlPrintGetFilterExpression(hTheJob,
      Buffer, length);
    Expression := TString(Buffer);
    FreeMem(Buffer);
  end
  else
  begin
    result:=length;
    Expression:='';
  end;
end;

function TL17_.LlPrintWillMatchFilter: integer;
begin
  result:=cmbtll17.LlPrintWillMatchFilter(hTheJob);
end;

function TL17_.LlPrintDidMatchFilter: integer;
begin
  result:=cmbtll17.LlPrintDidMatchFilter(hTheJob);
end;


function TL17_.LlGetVariableContents(VariableName: TString;
  var VariableContent: TString): integer;
var
  Buffer: PTChar;
  Length: integer;
begin
  length := cmbtll17.LlGetVariableContents(hTheJob, PTChar(VariableName), nil, 0);
  if length>0 then
  begin
    GetMem(Buffer, length * sizeof(TChar));
    Buffer^ := #0;
    Result := cmbtll17.LlGetVariableContents(hTheJob,
      PTChar(VariableName), Buffer, length);
    VariableContent := TString(Buffer);
    FreeMem(Buffer);
  end
  else
  begin
    result:=length;
    VariableContent:='';
  end;
end;


function TL17_.LlGetFieldContents(FieldName: TString;
  var FieldContent: TString): integer;
var
  Buffer: PTChar;
  Length: integer;
begin
  length := cmbtll17.LlGetFieldContents(hTheJob, PTChar(FieldName), nil, 0);
  if length>0 then
  begin
    GetMem(Buffer, length * sizeof(TChar));
    Buffer^ := #0;
    Result := cmbtll17.LlGetFieldContents(hTheJob, PTChar(FieldName),
      Buffer, length);
    FieldContent := TString(Buffer);
    FreeMem(Buffer);
  end
  else
  begin
    result:=length;
    FieldContent:='';
  end;

end;

function TL17_.LlGetVariableType(VariableName: TString): integer;
begin
  Result := cmbtll17.LlGetVariableType(hTheJob, PTChar(VariableName));
end;

function TL17_.LlGetFieldType(FieldName: TString): integer;
begin
  Result := cmbtll17.LlGetFieldType(hTheJob, PTChar(FieldName));
end;

function TL17_.LlDefineSumVariable(VariableName: TString;
  VariableContent: TString): integer;
begin
  Result := cmbtll17.LlDefineSumVariable(hTheJob, PTChar(VariableName),
    PTChar(VariableContent));
end;

function TL17_.LlDbAddTable(TableName, DisplayName: TString): integer;
begin
    Result := cmbtll17.LlDbAddTable(hTheJob, PTChar(TableName), PTChar(DisplayName));
end;

function TL17_.LlDbAddTableEx(TableName, DisplayName: TString; Options: integer): integer;
begin
    Result := cmbtll17.LlDbAddTableEx(hTheJob, PTChar(TableName), PTChar(DisplayName), options);
end;


function TL17_.LlPrintDbGetCurrentTable(var TableName: TString; CompletePath: boolean): integer;
var
  Buffer: PTChar;
  Length: integer;
begin
  Length := cmbtll17.LlPrintDbGetCurrentTable(hTheJob, nil, 0, CompletePath);
  if length>0 then
  begin
    GetMem(Buffer, Length * sizeof(TChar));
    Buffer^ := #0;
    Result := cmbtll17.LlPrintDbGetCurrentTable(hTheJob, Buffer, Length, CompletePath);
    TableName := TString(Buffer);
    FreeMem(Buffer);
  end
  else
  begin
    result:=length;
    TableName:='';
  end;
end;

function TL17_.LlDbAddTableRelation(TableName, ParentTableName, RelationName,
      RelationDisplayName: TString): integer;
begin
    Result := cmbtll17.LlDbAddTableRelation(hTheJob, PTChar(TableName), PTChar(ParentTableName),
                                            PTChar(RelationName), PTChar(RelationDisplayName));
end;

function TL17_.LlDbAddTableRelationEx(TableName, ParentTableName, RelationName,
      RelationDisplayName: TString; KeyField: TString; ParentKeyField: TString): integer;
begin
    Result := cmbtll17.LlDbAddTableRelationEx(hTheJob, PTChar(TableName), PTChar(ParentTableName),
                                            PTChar(RelationName), PTChar(RelationDisplayName), PTChar(KeyField), PTChar(ParentKeyField));
end;


function TL17_.LlPrintDbGetCurrentTableRelation(var TableRelation: TString): integer;
var
  Buffer: PTChar;
  Length: integer;
begin
  Length := cmbtll17.LlPrintDbGetCurrentTableRelation(hTheJob, nil, 0);
  if length>0 then
  begin
    GetMem(Buffer, Length * sizeof(TChar));
    Buffer^ := #0;
    Result := cmbtll17.LlPrintDbGetCurrentTableRelation(hTheJob, Buffer, Length);
    TableRelation := TString(Buffer);
    FreeMem(Buffer);
  end
  else
  begin
    result:=length;
    TableRelation:='';
  end;
end;

function TL17_.LlDbAddTableSortOrder(TableName, SortOrderName,
      SortOrderDisplayName: TString): integer;
begin
    Result := cmbtll17.LlDbAddTableSortOrder(hTheJob, PTChar(TableName), PTChar(SortOrderName),
                                             PTChar(SortOrderDisplayName));
end;

function TL17_.LlPrintDbGetCurrentTableSortOrder(var TableSortOrder: TString): integer;
var
  Buffer: PTChar;
  Length: integer;
begin
  Length := cmbtll17.LlPrintDbGetCurrentTableSortOrder(hTheJob, nil, 0);
  if length>0 then
  begin
    GetMem(Buffer, Length * sizeof(TChar));
    Buffer^ := #0;
    Result := cmbtll17.LlPrintDbGetCurrentTableSortOrder(hTheJob, Buffer, Length);
    TableSortOrder := TString(Buffer);
    FreeMem(Buffer);
  end
  else
  begin
    result:=length;
    TableSortOrder:='';
  end;
end;

function TL17_.LlDbSetMasterTable(TableName: TString):integer;
begin
    Result := cmbtll17.LlDbSetMasterTable(hTheJob, PTChar(TableName));
end;

function TL17_.LlPrintDbGetRootTableCount(): integer;
begin
    Result := cmbtll17.LlPrintDbGetRootTableCount(hTheJob);
end;

function TL17_.LlGetOptionString(OptionIndex: integer;
  var Value: TString): integer;
var
  Buffer: PTChar;
  Length: integer;
begin
  Length := cmbtll17.LlGetOptionString(hTheJob, OptionIndex, nil,
    0);
  if length>0 then
  begin
    GetMem(Buffer, Length * sizeof(TChar));
    Buffer^ := #0;
    Result := cmbtll17.LlGetOptionString(hTheJob, OptionIndex, Buffer,
      Length);
    Value := TString(Buffer);
    FreeMem(Buffer);
  end
  else
  begin
    result:=length;
    Value:='';
  end;
end;

function TL17_.LlGetSumVariableContents(VariableName: TString;
  var VariableContent: TString): integer;
var 
  Buffer: PTChar;
  length: integer;
begin
  length := cmbtll17.LlGetSumVariableContents(hTheJob, PTChar(VariableName),
    nil, 0);
  if length > 0 then
  begin
    GetMem(Buffer, length * sizeof(TChar));
    Buffer^ := #0;
    Result := cmbtll17.LlGetSumVariableContents(hTheJob, PTChar(VariableName),
      Buffer, length);
    VariableContent := TString(Buffer);
    FreeMem(Buffer);
  end
  else
  begin
    VariableContent:='';
    Result:=length;
  end;
end;

function TL17_.LlGetUserVariableContents(VariableName: TString;
  var VariableContent: TString): integer;
var
  Buffer: PTChar;
  Length: integer;
begin
  length := cmbtll17.LlGetUserVariableContents(hTheJob, PTChar(VariableName),
    nil, 0);
  if length>0 then
  begin
    GetMem(Buffer, length * sizeof(TChar));
    Buffer^ := #0;
    Result := cmbtll17.LlGetUserVariableContents(hTheJob, PTChar(VariableName),
      Buffer, length);
    VariableContent := TString(Buffer);
    FreeMem(Buffer);
  end
  else
  begin
    VariableContent:='';
    Result:=length;
  end;
end;



function TL17_.LlPreviewDisplayEx(ProjectName: TString;
  PreviewFilePath: TString;
  ParentHandle: cmbtHWND;
  Options: integer): integer;
begin
  Result := cmbtll17.LlPreviewDisplayEx(hTheJob, PTChar(ProjectName),
    PTChar(PreviewFilePath), ParentHandle, Options, nil);
end;

function TL17_.LlPrintCopyPrinterConfiguration(PrinterFileName: TString;
  FunctionIndex: integer): integer;
begin
  Result := cmbtll17.LlPrintCopyPrinterConfiguration(hTheJob,
    PTChar(PrinterFileName), FunctionIndex);
end;

function TL17_.LlPrintSetOptionString(OptionIndex: integer;
  Value: TString): integer;
begin
  Result := cmbtll17.LlPrintSetOptionString(hTheJob, OptionIndex, PTChar(Value));
end;

function TL17_.LlPrintGetOptionString(OptionIndex: integer; var Value: TString): integer;
var
  Buffer: PTChar;
  length: integer;
begin
  length := cmbtll17.LlPrintGetOptionString(hTheJob, OptionIndex,
    nil, 0);
  if length>0 then
  begin
    GetMem(Buffer, length * sizeof(TChar));
    Buffer^ := #0;
    Result := cmbtll17.LlPrintGetOptionString(hTheJob, OptionIndex,
      Buffer, length);
    Value := TString(Buffer);
    FreeMem(Buffer);
  end
  else
  begin
    result:=length;
    Value:='';
  end;
end;

function TL17_.LlSetOptionString(OptionIndex: integer; Value: TString): integer;
begin
  Result := cmbtll17.LlSetOptionString(hTheJob, OptionIndex, PTChar(Value));
end;

procedure TL17_.LlDebugOutput(Indent: integer; Text: TString);
begin
  cmbtll17.LlDebugOutput(Indent, PTChar(Text));
end;


function TL17_.LlEnumGetFirstVar(Flags: integer): HLISTPOS;
begin
  Result := cmbtll17.LlEnumGetFirstVar(hTheJob, Flags);
end;

function TL17_.LlEnumGetFirstField(Flags: integer): HLISTPOS;
begin
  Result := cmbtll17.LlEnumGetFirstField(hTheJob, Flags);
end;


function TL17_.LlEnumGetNextEntry(Pos: HLISTPOS; Flags: integer): HLISTPOS;
begin
  Result := cmbtll17.LlEnumGetNextEntry(hTheJob, Pos, Flags);
end;


function TL17_.LlEnumGetEntry(Pos: HLISTPOS;
  var Name: TString;
  var Content: TString;
  var Handle: THandle;
  var EntryType: integer
  ): integer;
var 
  NameBuffer, ContentBuffer: PTChar;
begin
  GetMem(NameBuffer, 4096 * sizeof(TChar));
  GetMem(ContentBuffer, 4096 * sizeof(TChar));
  NameBuffer^ := #0;
  ContentBuffer^ := #0;
  Result := cmbtll17.LlEnumGetEntry(hTheJob, Pos, NameBuffer,
    4096 - 1, ContentBuffer, 4096 - 1, @Handle, @EntryType);
  Name := TString(NameBuffer);
  Content := TString(ContentBuffer);
  FreeMem(NameBuffer);
  FreeMem(ContentBuffer);
end;




{$ifdef UNICODE}
function TL17_.LlSetPrinterInPrinterFile(ProjectType: cardinal;
  const ProjectName: TString;
  PrinterIndex: integer;
  const PrinterName: TString;
  const DevModePointer: _PCDEVMODEW
  ): integer;
{$else}
  function TL17_.LlSetPrinterInPrinterFile(ProjectType: cardinal;
    const ProjectName: TString;
    PrinterIndex: integer;
    const PrinterName: TString;
    const DevModePointer: _PCDEVMODEA
    ): integer;
{$endif}
  begin
    Result := cmbtll17.LlSetPrinterInPrinterFile(hTheJob, ProjectType, PTChar(ProjectName),
      PrinterIndex, PTChar(PrinterName), DevModePointer);
  end;




  function TL17_.LlXSetParameter(ExtensionType: integer;
    ExtensionName: TString;
    Key: TString;
    Value: TString
    ): integer;
  begin
    Result := cmbtll17.LlXSetParameter(hTheJob, ExtensionType,
      PTChar(ExtensionName), PTChar(Key), PTChar(Value));
  end;


  function TL17_.LlXGetParameter(ExtensionType: integer;
    ExtensionName: TString;
    Key: TString;
    var Value: TString
    ): integer;
  var 
    Buffer: PTChar;
    length: integer;
  begin
    length := cmbtll17.LlXGetParameter(hTheJob, ExtensionType, PTChar(ExtensionName),
      PTChar(Key), nil, 0);
    GetMem(Buffer, length * sizeof(TChar));  
    Buffer^ := #0;
    Result := cmbtll17.LlXGetParameter(hTheJob, ExtensionType, PTChar(ExtensionName),
      PTChar(Key), Buffer, length);
    Value := TString(Buffer);
    FreeMem(Buffer);
  end;

  function TL17_.LlPrintResetObjectStates: integer;
  begin
    Result := cmbtll17.LlPrintResetObjectStates(hTheJob);
  end;

  function TL17_.LlPrintResetProjectState: integer;
  begin
    Result := cmbtll17.LlPrintResetProjectState(hTheJob);
  end;

  function TL17_.LlDesignerProhibitFunction(FunctionName: TString): integer;
  begin
    Result := cmbtll17.LlDesignerProhibitFunction(hTheJob, PTChar(FunctionName));
  end;


function TL17_.LlDesignerRefreshWorkspace: integer;
begin
  result := cmbtll17.LlDesignerRefreshWorkspace(hTheJob);
end;

function TL17_.LlDesignerSetOptionString(option: integer; OptionString: TString): integer;
begin
  result := cmbtll17.LlDesignerSetOptionString(hTheJob, option, PTChar(OptionString));
end;

function TL17_.LlDlgEditLineEx(parentHandle: cmbtHWND;var formularText: TString;
  fieldType: integer; title: PTChar; useFields: boolean): integer;
var
 nOption: integer;
 {$ifdef UNICODE}
    buffer: PWideChar;
 {$else}
    buffer: PAnsiChar;
 {$endif}
begin

  buffer := nil;
  nOption := LlGetOption(LL_OPTION_ADDVARSTOFIELDS);

  if useFields then
    LlSetOption(LL_OPTION_ADDVARSTOFIELDS, 1);

  StrPCopyExt(buffer, formularText, 16384);
  {$ifdef USELLXOBJECTS}
  DeclareLlXObjectsToLL;
  {$endif}
  result := cmbtll17.LlDlgEditLineEx(hTheJob, parentHandle, buffer, 16384, fieldType, title, useFields, nil);
  formularText := buffer;


  if useFields then
    LlSetOption(LL_OPTION_ADDVARSTOFIELDS, nOption);
  if result <> 0 then
    ShowMessage(IntToStr(result));
  {$ifdef USELLXOBJECTS}
  LlSetOption(53,0);
  FLlXInterface:=nil;
  {$endif}

end;

function TL17_.LlDomGetProject: HLLDOMOBJ;
var
  proj: HLLDOMOBJ;
begin
  cmbtll17.LlDomGetProject(hTheJob, @proj);
  result := proj;
end;

function TL17_.LlDefineChartFieldExt(FieldName: TString;
    Contents: TString;
    FieldType: integer
    ): integer;
  begin
    if not bIsPrinting then
      Dictionary.Fields.AddComplexItems(FieldName);
    Result := cmbtll17.LlDefineChartFieldExt(hTheJob, PTChar(FieldName), PTChar(Contents),
      FieldType, nil)
  end;

  procedure TL17_.LlDefineChartFieldStart;
  begin
    cmbtll17.LlDefineChartFieldStart(hTheJob);
  end;

  function TL17_.LlPrintDeclareChartRow(Flags: cardinal
    ): integer;
  begin
    Result := cmbtll17.LlPrintDeclareChartRow(hTheJob, Flags);
  end;

  function TL17_.LlPrintGetChartObjectCount(Flags: cardinal
    ): integer;
  begin
    Result := cmbtll17.LlPrintGetChartObjectCount(hTheJob, Flags);
  end;

  function TL17_.LlPrintIsChartFieldUsed(FieldName: TString): integer;
  begin
    Result := cmbtll17.LlPrintIsChartFieldUsed(hTheJob, PTChar(FieldName));
  end;

  function TL17_.LlGetChartFieldContents(FieldName: TString; var Content: TString): integer;
  var
    Buffer: PTChar;
    length: integer;
  begin
    length := cmbtll17.LlGetChartFieldContents(hTheJob, PTChar(FieldName), nil, 0);
    GetMem(Buffer, length * sizeof(TChar));
    Buffer^ := #0;
    Result := cmbtll17.LlGetChartFieldContents(hTheJob, PTChar(FieldName), Buffer, length);
    Content := TString(Buffer);
    FreeMem(Buffer);
  end;


  function TL17_.LlEnumGetFirstChartField(Flags: integer
    ): HLISTPOS;
  begin
    Result := cmbtll17.LlEnumGetFirstChartField(hTheJob, Flags);
  end;


  procedure TL17_.SetMaxRTFVersion(nVersion: smallint);
  begin
    if nversion <> nMaxRTFVersion then
    begin
      nMaxRTFVersion := nVersion;
      SetLanguage(self.Language);
    end;
  end;

  procedure TL17_.SetLicensingInfo(sInfo: string);
  begin
    sLicensingInfo := sInfo;
    LlSetOptionString(LL_OPTIONSTR_LICENSINGINFO, sInfo);
  end;

  procedure TL17_.SetProjectPassword(sPassword: string);
  begin
    sProjectPassword := sPassword;
    LlSetOptionString(LL_OPTIONSTR_PROJECTPASSWORD, sPassword);
  end;

  function TL17_.LlPrintGetRemainingSpacePerTable(FieldName: TString;
    Dimension: integer
    ): integer;
  begin
    Result := cmbtll17.LlPrintGetRemainingSpacePerTable(hTheJob,
      PTChar(FieldName), Dimension);
  end;

  // LL10

  function TL17_.LsMailConfigurationDialog(Handle: cmbtHWND; Subkey: TString; Flags: integer; Language: integer):integer;
  begin
    result:=cmbtls17.LsMailConfigurationDialog(Handle, PTChar(Subkey), Flags, Language);
  end;


  // LL11
  procedure TL17_.ConvertTField(Field: TField; var FieldName, FieldContent: TString; var FieldType: integer);
  const DigitBool: array[Boolean] of string = ('0', '1');
  begin
    FieldName:=Field.FieldName;
{$ifdef  ADOAVAILABLE}
    case Field.DataType of
      ftInteger, ftsmallint, ftAutoInc,
      ftFloat, ftWord, ftLargeint:           {numeric}
{$else}
    case Field.DataType of
      ftInteger, ftsmallint, ftAutoInc,
      ftFloat, ftWord:           {numeric}
{$endif}      
        begin
          FieldType := LL_NUMERIC;
          {Flag null value}
          if Field.IsNull then
            FieldContent := '(NULL)'
          else
          FieldContent := Field.AsString;
        end;
      ftDate, ftDateTime:         {date}
        begin
          FieldType := LL_DATE_DELPHI;
          {Flag invalid date or null value}
          if Field.IsNull then
            FieldContent := '(NULL)'
          else
            FieldContent := FloatToStr(StrToDateTime(Field.AsString));
        end;
      ftBoolean:                  {boolean}
        begin
          FieldType := LL_BOOLEAN;
          {Flag null value}
          if Field.IsNull then
            FieldContent := '(NULL)'
          else
          FieldContent := DigitBool[Field.AsBoolean];
        end;
      ftCurrency:
        begin
          FieldType := LL_NUMERIC;
          {Flag null value}
          if Field.IsNull then
            FieldContent := '(NULL)'
          else
          FieldContent := Field.AsString;
        end;
      ftBCD
      {$ifdef ADOAVAILABLE}
      , ftfmtBCD
      {$endif}
      :
        begin
          FieldType := LL_NUMERIC;
          {Flag null value}
          if Field.IsNull then
            FieldContent := '(NULL)'
          else
          FieldContent := Field.AsString
        end;
      {$ifdef UNICODE}
      {$ifdef ADOAVAILABLE}
      ftWideString:
        begin
            FieldType:=LL_TEXT;
          {Flag null value}
          if Field.IsNull then
            FieldContent := '(NULL)'
          else
            FieldContent:=TWideStringField(Field).Value;
        end
      {$endif}
       {$endif}
        else
          begin        {text variables}
            FieldType := LL_TEXT;
          {Flag null value}
          if Field.IsNull then
            FieldContent := '(NULL)'
          else
            FieldContent := Field.AsString;
          end;
    end;
  end;

  function TL17_.LlDefineChartFieldFromTField(Contents: TField): integer;
  var FieldName, FieldContent: TString;
      FieldType: integer;
  begin
    ConvertTField(Contents, FieldName, FieldContent, FieldType);
    result:=LlDefineChartFieldExt(FieldName, FieldContent, FieldType);

  end;

  function TL17_.LlDefineFieldFromTField(Contents: TField): integer;
  var FieldName, FieldContent: TString;
      FieldType: integer;
  begin
    ConvertTField(Contents, FieldName, FieldContent, FieldType);
    result:=LlDefineFieldExt(FieldName, FieldContent, FieldType);
  end;

  function TL17_.LlDefineFieldFromTFieldExt(TableName: TString; Contents: TField):integer;
  var FieldName, FieldContent: TString;
      FieldType: integer;
  begin

   ConvertTField(Contents, FieldName, FieldContent, FieldType);

   if pos(':',TableName) > 0 then
     result:=LlDefineFieldExt(TableName, FieldContent, FieldType)
   else
     result:=LlDefineFieldExt(TableName+'.'+FieldName, FieldContent, FieldType);
  end;

  function TL17_.LlDefineVariableFromTField(Contents: TField): integer;
  var FieldName, FieldContent: TString;
      FieldType: integer;
  begin
    ConvertTField(Contents, FieldName, FieldContent, FieldType);
    result:=LlDefineVariableExt(FieldName, FieldContent, FieldType);
  end;

  function TL17_.LlDefineVariableFromTFieldExt(TableName: TString; Contents: TField):integer;
  var FieldName, FieldContent: TString;
      FieldType: integer;
  begin
    ConvertTField(Contents, FieldName, FieldContent, FieldType);
    result:=LlDefineVariableExt(TableName+'.'+FieldName, FieldContent, FieldType);
  end;

procedure Register;
  begin
  {$ifndef WIN64}
    RegisterComponents('combit', [TL17_, TDBL17_, TLl17RTFObject, TLl17PreviewControl
    {$ifdef USELLXOBJECTS}
    , TLl17XObject
    , TLl17XFunction
    {$endif}
    , TLl17XAction
    ]);
    {$endif}
  end;


  procedure StrPCopyExt(var Dest: ptChar; Source: TString; MinSize: integer);
  var
    ActSize: integer;
  begin
    if MinSize > SizeOf(ptChar) * (length(Source) + 1) then ActSize := MinSize
    else
      ActSize := SizeOf(ptChar) * (length(Source) + 1);
    if (Dest <> nil) then
      FreeMem(Dest);
    GetMem(Dest, ActSize);
    {$ifdef UNICODE}
    Move(ptCHAR(Source)^, Dest^, SizeOf(ptChar) * (length(Source)));
    Dest[length(Source)] := #0;
    {$else}
    StrPCopy(Dest, Source);
    {$endif}
  end;


  { TLl17ExprEvaluator }

  constructor TLl17ExprEvaluator.Create(Parent: TL17_; Expression: TString;
    IncludeTablefields: boolean);
  var
    pszErrorBuffer: PTChar;
    {$ifdef VER90}
    Content: Variant;
    {$else}
    Content: OleVariant;
    {$endif}
  begin
    inherited Create;
    FParent := Parent;
    VariantInit(Content);
    GetMem(pszErrorBuffer, 1024 * sizeof(TChar));

    {$ifdef USELLXOBJECTS}
    FParent.DeclareLlXObjectsToLL;
    {$endif}
    FExprPointer := cmbtll17.LlExprParse(Parent.hLlJob, PTChar(Expression), IncludeTablefields);
    FErrorValue := cmbtll17.LlExprEvaluateVar(Parent.hLlJob, FExprPointer, PVARIANT(@Content), 0);
    if (FErrorValue = 0) then
    begin
      FResult := Content;
      FExprType := cmbtll17.LlExprType(Parent.hLlJob, FExprPointer);
    end
    else
    begin
      FResult := '';
      FExprType := 0;
      cmbtll17.LlExprError(Parent.hLlJob, pszErrorBuffer, 1024 - 1);
      FErrorText := TString(pszErrorBuffer);
    end;
    FExpression := Expression;
    VariantClear(Content);
    FreeMem(pszErrorBuffer);
  end;

  destructor TLl17ExprEvaluator.Destroy;
  begin
    cmbtll17.LlExprFree(FParent.hLlJob, FExprPointer);
    {$ifdef USELLXOBJECTS}
    FParent.LlSetOption(53,0);
    FParent.FLlXInterface:=nil;
    {$endif}

    inherited Destroy;
  end;


procedure TLl17ExprEvaluator.EditExpression(title: TString);
var
  WinHandle: cmbtHWND;
begin

  if FParent.Owner is TDataModule then
    WinHandle := GetActiveWindow()
  else
  if TForm(FParent.Owner).HandleAllocated then
    WinHandle := TForm(FParent.Owner).Handle
  else
    WinHandle := GetActiveWindow();

  FParent.LlDlgEditLineEx(WinHandle, FExpression, LL_TYPEMASK, PTChar(title), true);

end;

procedure TLl17ExprEvaluator.SetExpression(const Value: TString);
begin
  FExpression := Value;
end;

{ TLl17PreviewPage }


  constructor TLl17PreviewPage.Create(FileHandle: HLLSTG; PageIndex: integer);
  begin
    inherited Create;
    FHandle := FileHandle;
    FPageIndex := PageIndex;
  end;

  procedure TLl17PreviewPage.Draw(Canvas: TCanvas; Rect: TRect; ResolutionCorrection: boolean);
  var 
    prnDC: HDC;
  begin
    if GetDeviceCaps(Canvas.Handle, TECHNOLOGY) = DT_RASDISPLAY then
      prnDC := 0
    else
      prnDC := Canvas.Handle;
    LlStgsysDrawPage(FHandle, Canvas.Handle, prnDC, False, @Rect, FPageIndex,
      ResolutionCorrection, nil);
  end;

  function TLl17PreviewPage.GetCopies: integer;
  begin
    Result := GetOptionValue(LS_OPTION_COPIES);
  end;

  function TLl17PreviewPage.GetCreation: TString;
  begin
    Result := GetOptionString(LS_OPTION_CREATION);
  end;

  function TLl17PreviewPage.GetJobName: TString;
  begin
    Result := GetOptionString(LS_OPTION_JOBNAME);
  end;

  function TLl17PreviewPage.GetMetafile: TMetafile;
  var 
    mf: TMetafile;
  begin
    mf := TMetafile.Create;
    mf.Handle := LlStgsysGetPageMetafile(FHandle, FPageIndex);
    Result := mf;
  end;

  function TLl17PreviewPage.GetOptionString(OptionIndex: integer): TString;
  var
    Buffer: PTChar;
    length: integer;
  begin
    length := cmbtls17.LlStgsysGetPageOptionString(FHandle, FPageIndex,
      OptionIndex, nil, 0);
    if length>0 then
    begin
      GetMem(Buffer, length * sizeof(TChar));
      Buffer^ := #0;
      cmbtls17.LlStgsysGetPageOptionString(FHandle, FPageIndex, OptionIndex, Buffer, length);
      Result := TString(Buffer);
      FreeMem(Buffer);
    end
    else
    begin
        result:='';
    end;
  end;

  function TLl17PreviewPage.GetOptionValue(OptionIndex: integer): integer;
  begin
    Result := cmbtls17.LlStgsysGetPageOptionValue(FHandle, FPageIndex, OptionIndex);
  end;

  function TLl17PreviewPage.GetOrientation: integer;
  begin
    Result := GetOptionValue(LS_OPTION_PRN_ORIENTATION);
  end;

  function TLl17PreviewPage.GetPageIndex: integer;
  begin
    Result := FPageIndex;
  end;

  function TLl17PreviewPage.GetProjectFileName: TString;
  begin
    Result := GetOptionString(LS_OPTION_PROJECTNAME);
  end;


  function TLl17PreviewPage.GetPrintablePageOffset: TSize;
  begin
    Result.cx := GetOptionValue(LS_OPTION_PRN_PIXELSOFFSET_X);
    Result.cy := GetOptionValue(LS_OPTION_PRN_PIXELSOFFSET_Y);
  end;

  function TLl17PreviewPage.GetPrintablePageSize: TSize;
  begin
    Result.cx := GetOptionValue(LS_OPTION_PRN_PIXELS_X);
    Result.cy := GetOptionValue(LS_OPTION_PRN_PIXELS_Y);
  end;

  function TLl17PreviewPage.GetPrinterDevice: TString;
  begin
    Result := GetOptionString(LS_OPTION_PRTDEVICE);
  end;

  function TLl17PreviewPage.GetPrinterName: TString;
  begin
    Result := GetOptionString(LS_OPTION_PRTNAME);
  end;

  function TLl17PreviewPage.GetPhysicalPageSize: TSize;
  begin
    Result.cx := GetOptionValue(LS_OPTION_PRN_PIXELSPHYSICAL_X);
    Result.cy := GetOptionValue(LS_OPTION_PRN_PIXELSPHYSICAL_Y);
  end;

  function TLl17PreviewPage.GetPrinterPhysicalPage: boolean;
  begin
    Result := (GetOptionValue(LS_OPTION_PHYSPAGE) <> 0);
  end;

  function TLl17PreviewPage.GetPrinterPort: TString;
  begin
    Result := GetOptionString(LS_OPTION_PRTPORT);
  end;

  function TLl17PreviewPage.GetPrinterResolution: TSize;
  begin
    Result.cx := GetOptionValue(LS_OPTION_PRN_PIXELSPERINCH_X);
    Result.cy := GetOptionValue(LS_OPTION_PRN_PIXELSPERINCH_Y);
  end;

  function TLl17PreviewPage.GetUserValue: TString;
  begin
    Result := GetOptionString(LS_OPTION_USER);
  end;

  procedure TLl17PreviewPage.SetJobName(const Value: TString);
  begin
    cmbtls17.LlStgsysSetPageOptionString(FHandle, FPageIndex,
      LS_OPTION_JOBNAME, PTChar(Value));
  end;

  procedure TLl17PreviewPage.SetUserValue(Value: TString);
  begin
    cmbtls17.LlStgsysSetPageOptionString(FHandle, FPageIndex,
      LS_OPTION_USER, PTChar(Value));
  end;

  function TLl17PreviewPage.GetCreationApp: TString;
  begin
    Result := GetOptionString(LS_OPTION_CREATIONAPP);
  end;

  function TLl17PreviewPage.GetCreationDLL: TString;
  begin
    Result := GetOptionString(LS_OPTION_CREATIONDLL);
  end;

  function TLl17PreviewPage.GetCreationUser: TString;
  begin
    Result := GetOptionString(LS_OPTION_CREATIONUSER);
  end;

  { TLl17PreviewFile }

  procedure TLl17PreviewFile.Append(FileToAppend: TLl17PreviewFile);
  begin
    LlStgsysAppend(FHandle, FileToAppend.FHandle);
  end;

function TLl17PreviewFile.ConvertTo(TargetFileName, TargetFormat: TString): integer;
begin
 Result := LlStgsysConvert(FHandle, PTChar(TargetFileName), PTChar(TargetFormat));
end;

constructor TLl17PreviewFile.Create(FileName: TString; ReadOnly: boolean);
  begin
    inherited Create;
    FHandle := LlStgsysStorageOpen(PTChar(FileName), nil, ReadOnly, True);
  end;

  procedure TLl17PreviewFile.Delete;
  begin
    LlStgsysDeleteFiles(FHandle);
  end;

  destructor TLl17PreviewFile.Destroy;
  begin
    LlStgsysStorageClose(FHandle);
    inherited Destroy;
  end;

  function TLl17PreviewFile.GetPage(const Index: integer): TLl17PreviewPage;
  begin
    if Index <= GetPageCount then
    begin
      Result := TLl17PreviewPage.Create(FHandle, Index);
    end
    else
      Result := nil;
  end;

  function TLl17PreviewFile.GetPageCount: integer;
  begin
    Result := LlStgsysGetPageCount(FHandle);
  end;

  procedure TLl17PreviewFile.Print(PrinterFirstPage,
    PrinterFollowingPages: TString; StartPage, EndPage, Copies,
    Flags: integer; MessageText: TString; ParentHandle: cmbtHWND);
  var
    Prt1, Prt2: PTChar;
  begin
    if PrinterFirstPage = '' then Prt1 := nil
    else
      Prt1 := PTChar(PrinterFirstPage);
    if PrinterFollowingPages = '' then Prt2 := nil
    else
      Prt2 := PTChar(PrinterFollowingPages);
    LlStgsysPrint(FHandle, Prt1, Prt2,
      StartPage, EndPage, Copies, Flags, PTChar(MessageText), ParentHandle);
  end;

  { TLl17RTFObject }

  function TLl17RTFObject.CopyToClipboard: integer;
  begin
    if Assigned(FMyParentComponent) then
        Result := LlRTFCopyToClipboard(FMyParentComponent.hLlJob, FHandle)
    else
    begin
        raise ENoParentComponentError.Create('No parent component assigned');
    end;
  end;


constructor TLl17RTFObject.Create(AOwner: TComponent);
begin
    inherited create(AOwner);
    PrintState := psPending;
    ContentMode := cmEvaluated;
    TextMode := tmRTF;
    FFirst:=true;
end;

procedure TLl17RTFObject.CreateWnd;
begin
    inherited CreateWnd;
    if FFirst then
    begin
        if not (csDesigning in ComponentState) then
        begin
            if Assigned(FMyParentComponent) then
            begin
               FHandle := LlRTFCreateObject(FMyParentComponent.hLlJob);
               cmbtll17.LlRTFEditObject(FMyParentComponent.hLlJob, FHandle, handle, 0, LL_PROJECT_LIST, false);
               FFirst:=False;
            end
            else
                raise ENoParentComponentError.Create('No parent component assigned');
        end;

    end;
end;

destructor TLl17RTFObject.Destroy;
  begin
    if not (csDesigning in ComponentState) and Assigned(FMyParentComponent) then
        LlRTFDeleteObject(FMyParentComponent.hLlJob, FHandle);
    inherited Destroy;
  end;

function TLl17RTFObject.Display(Canvas: TCanvas; Rect: TRect;
    FromStart: boolean): integer;
  var
    State: integer;
    pRect: cmbtll17._PRECT;
  begin
    if Assigned(FMyParentComponent) then
    begin
      if ((Rect.Left = Rect.Right) and (Rect.Top = Rect.Bottom)) then pRect := nil
      else
        pRect := @Rect;
      Result := LlRTFDisplay(FMyParentComponent.hLlJob,
        FHandle,
        Canvas.Handle,
        pRect,
        FromStart,
        LLPUINT(@State));
      if State = LL_WRN_REPEAT_DATA then
        PrintState := psPending
      else
        PrintState := psFinished;
    end
    else
    begin
        raise ENoParentComponentError.Create('No parent component assigned');
    end;

  end;

 (* function TLl17RTFObject.Edit(RefCanvas: TCanvas;
    ProjectType: integer): integer;
  begin
    Result := LlRTFEditObject(FMyParentComponent.hLlJob, FHandle, FParentHandle,
      RefCanvas.Handle, ProjectType);
  end;*)

  function TLl17RTFObject.GetText: TString;
  var
    Flags: integer;
    Length: integer;
    Buffer: PTChar;
  begin
    Flags := 0;
    case TextMode of
      tmRTF: Flags := LL_RTFTEXTMODE_RTF;
      tmPlain: Flags := LL_RTFTEXTMODE_PLAIN;
    end;
    case ContentMode of
      cmRaw: Flags := Flags or LL_RTFTEXTMODE_RAW;
      cmEvaluated: Flags := Flags or LL_RTFTEXTMODE_EVALUATED;
    end;
    if Assigned(FMyParentComponent) then
    begin
      Length := LlRTFGetTextLength(FMyParentComponent.hLlJob, FHandle, Flags);
      if length>0 then
      begin
        GetMem(Buffer, (Length + 1) * sizeof(TChar));
        Buffer^ := #0;
        LlRTFGetText(FMyParentComponent.hLlJob, FHandle, Flags, Buffer, Length+1);
        Result := TString(Buffer);
        FreeMem(Buffer);
      end
      else
        result:='';
    end
    else
        raise ENoParentComponentError.Create('No parent component assigned');
  end;

  function TLl17RTFObject.ProhibitAction(ControlID: integer): integer;
begin
    result:=LlRTFEditorProhibitAction(FMyParentComponent.hLlJob, FHandle, ControlID);
end;

procedure TLl17RTFObject.SetContentMode(const Value: TLlRTFContentMode);
  begin
    FContentMode := Value;
  end;

  procedure TLl17RTFObject.SetMyParentComponent(const Value: TL17_);
begin
  FMyParentComponent := Value;
end;

procedure TLl17RTFObject.SetPrintState(const Value: TLlRTFPrintState);
  begin
    FPrintState := Value;
  end;

  procedure TLl17RTFObject.SetText(const Value: TString);
  begin
    if not (csDesigning in ComponentState) then
    begin
        if Assigned(FMyParentComponent) then
            LlRTFSetText(FMyParentComponent.hLlJob, FHandle, PTChar(Value))
        else
            raise ENoParentComponentError.Create('No parent component assigned');
    end;

  end;

  procedure TLl17RTFObject.SetTextMode(const Value: TLlRTFTextMode);
  begin
    FTextMode := Value;
  end;

procedure TLl17RTFObject.WndProc(var Message: TMessage);
var hCtl: HWND;
begin
  inherited;
  if Message.Msg = WM_GETDLGCODE then
  begin
        hCtl:=GetParent(GetFocus);
        while (hCtl<>0) and (hCtl<>GetDesktopWindow) do
        begin
                if hCtl = Handle then
                begin
                    Message.Result:=SendMessage(GetFocus, Message.Msg, Message.WParam, Message.LParam); // DLGC_WANTMESSAGE or DLGC_WANTARROWS or DLGC_WANTTAB;
                    break;
                end;
                hCtl:=GetParent(hCtl);
        end;
  end;
end;


{ TLl17PropertyMap }
{$ifdef USELLXOBJECTS}
procedure TLl17PropertyMap.AddProperty(Key, Value: String);
var Pos: integer;
begin
    Pos:=FKeyList.IndexOf(Key);
    if Pos<>-1 then
    begin
      FKeyList.Delete(Pos);
      FValueList.Delete(Pos);
    end;
    FKeyList.Add(Key);
    FValueList.Add(Value);
end;

function TLl17PropertyMap.ContainsKey(Key: String): boolean;
begin
    result:=(FKeyList.IndexOf(Key)<>-1);

end;

constructor TLl17PropertyMap.create;
begin
    inherited create;
    FKeyList:=TStringList.Create;
    FValueList:=TStringList.Create;
    FKeyList.Sorted:=false;
    FValueList.Sorted:=false;
end;

constructor TLl17PropertyMap.CreateCopy(Base: TLl17PropertyMap);
var TempStream: TMemoryStream;
begin
    create;
    TempStream:=TMemoryStream.Create;
    Base.FKeyList.SaveToStream(TempStream);
    TempStream.Seek(0, soFromBeginning);
    FKeyList.LoadFromStream(TempStream);
    TempStream.Clear;
    Base.FValueList.SaveToStream(TempStream);
    TempStream.Seek(0, soFromBeginning);
    FValueList.LoadFromStream(TempStream);
    TempStream.Free;
end;

destructor TLl17PropertyMap.Destroy;
begin
    FKeyList.Free;
    FValueList.Free;
    inherited destroy;
end;

function TLl17PropertyMap.GetValue(Key: String; var Value: String): boolean;
var Pos: integer;
begin
    result:=false;
    Pos:=FKeyList.IndexOf(Key);
    if Pos=-1 then
    begin
        Value:='';
        exit;
    end;
    result:=true;
    Value:=FValueList[Pos];
end;

procedure TLl17PropertyMap.LoadFromStream(const Stream: IStream);
var OStream: TOleStream;
    TempList: TStringList;
    index: integer;
    IsKey: Boolean;

begin
    IsKey:=true;
    TempList:=TStringList.Create;
    OStream:=TOleStream.Create(Stream);
    OStream.Seek(0,soFromBeginning);
    TempList.LoadFromStream(OStream);
    OStream.Free;
    FKeyList.Clear;
    FValueList.Clear;

    for Index:=0 to TempList.Count-1 do
    begin
        if TempList[index]='$$$LLDELIMITER§§§' then
            IsKey:=false
        else
            if IsKey=true then
                FKeyList.Add(TempList[index])
            else
                FValueList.Add(TempList[index]);
    end;

    TempList.Free;


end;

procedure TLl17PropertyMap.RemoveProperty(Key: String);
var Pos: integer;
begin
    Pos:=FKeyList.IndexOf(Key);
    if Pos<>-1 then
    begin
        FKeyList.Delete(Pos);
        FValueList.Delete(Pos);
    end;
end;

procedure TLl17PropertyMap.SaveToStream(const Stream: IStream);
var OStream: TOleStream;
    TempList: TStringList;
    index: integer;

begin
    TempList:=TStringList.Create;
    for Index:=0 to FKeyList.Count-1 do
    begin
        TempList.Add(FKeyList[index]);
    end;
    TempList.Add('$$$LLDELIMITER§§§');
    for Index:=0 to FValueList.Count-1 do
    begin
        TempList.Add(FValueList[index]);
    end;
    OStream:=TOleStream.Create(Stream);
    TempList.SaveToStream(OStream);
    OStream.Free;
    TempList.Free;
end;


  { TLl17XObject }

function TLl17XObject._AddRef: Integer;
begin
  	Result := InterlockedIncrement(FRefCount);
    InterlockedIncrement(l17interf.g_nObjects);
end;

function TLl17XObject._Release: Integer;
begin
    InterlockedDecrement(l17interf.g_nObjects);
	Result := InterlockedDecrement(FRefCount);
    if Result = 0 then
    begin
      if FILlBase[0]<>nil then
          FILlBase[0]:=nil;
      if FILlXObjectNtfySink[0]<>nil then
          FILlXObjectNtfySink[0]:=nil;
      if FIsCopy then
        self.Destroy;
    end;

end;



function TLl17XObject.AllowPageBreak: HResult;
begin
    if SupportsMultipage then
        result:=S_OK
    else
        result:=S_FALSE;
end;

function TLl17XObject.CalcDistanceToFrame(const hDC: HDC; ptMouse: TPoint;
  var pnDistance: cardinal): HResult;
begin
    result:=E_NOTIMPL;
end;

function TLl17XObject.CancelEditPart: HResult;
begin
    result:=E_NOTIMPL;
end;

function TLl17XObject.CanCreateObjectFromType(const nLLType: integer;
  const sVarName: OLEString; var prcCreate: TRect): HResult;
begin
    result:=E_NOTIMPL;
end;

function TLl17XObject.CanEditPart(ptMouse: TPoint;
  var phMenu: hMenu): HResult;

var UniqueID: cardinal;

function CreateMenuCopy(Source: TMenuItem; Dest: HMENU; var CommandHandlerList:TList):HMENU;
var hDestTemp: HMENU;
    Buffer:PXChar;
    ItemIndex: integer;
    MII:MENUITEMINFO;
    Handler: TNotifyEvent;
begin
    GetMem(Buffer,256);
    hDestTemp:= Dest;
    if Dest=0 then hDestTemp:=CreatePopupMenu;

    for ItemIndex:=0 to GetMenuItemCount(Source.Handle)-1 do
    begin
        fillchar(MII, sizeof(MII)-4,0);
		MII.cbSize:=sizeof(MII)-4;
		MII.fMask:=MIIM_DATA or MIIM_ID or MIIM_TYPE or MIIM_SUBMENU or MIIM_STATE or MIIM_CHECKMARKS;
		MII.dwTypeData:=Buffer;
		MII.cch:=256;
		GetMenuItemInfo(Source.Handle,ItemIndex,true,MII);
        MII.dwItemData:=0;
		if (MII.hSubMenu<>0) then
        begin
            MII.hSubMenu := CreateMenuCopy(Source.Items[ItemIndex],0, CommandHandlerList);
        end;

		if (MII.fType and MFT_SEPARATOR<>0) then
			AppendMenu(hDestTemp,MF_SEPARATOR,0,nil)
		  else
          begin
            MII.wID:=UniqueID;
            Handler:=TNotifyEvent(Source.Items[ItemIndex].OnClick);
            if Assigned(Handler) then
             CommandHandlerList.Add(@Handler)
            else
             CommandHandlerList.Add(nil);
            inc(UniqueID);
			InsertMenuItem(hDestTemp,ItemIndex,TRUE,MII);
          end;
    end;
	result:=hDestTemp;
    FreeMem(Buffer);
end;

begin
    UniqueID:=10000;
    FCommandHandlerList.Clear;
    if Assigned(PopupMenu) then
    	phMenu:=CreateMenuCopy(PopupMenu.Items,0,FCommandHandlerList);
    result:=S_OK;
end;

function TLl17XObject.ClearEditPartInfo: HResult;
begin
    result:=S_OK;
end;

function TLl17XObject.Clone(var pIObject): HResult;
var pObject: TLl17XObject;
begin
    try
      pObject := TLl17XObject.CreateCopy(owner,self);
      if FAILED(pObject.QueryInterface(IID_LLX_IOBJECT,pIObject)) then
          begin
          pObject.Free;
          Result := E_FAIL;
          exit;
          end;
     result:=S_OK;
    except
     Result := E_FAIL;
    end;
end;

constructor TLl17XObject.Create(AOwner: TComponent);
begin
    FRefCount:=0;
    FIcon:=TIcon.Create;
    FIsCopy:=false;
    FFontHandle:=0;
    FFontColor:=clBlack;
    FFontSize:= 12;
    FPrintState:=llxpsWaiting;
    FSupportsMultipage:=false;
    FCommandHandlerList:=TList.Create;
    Properties:=TLl17PropertyMap.create;
    inherited create(AOwner);
end;

constructor TLl17XObject.CreateCopy(AOwner:TComponent; Base: TLl17XObject);
var index: integer;
begin
     inherited create(AOwner);
     FRefCount:=0;
     FIsCopy:=True;
     FLLJob:=Base.FLLJob;
     FOnEdit:=Base.FOnEdit;
     FOnDraw:=Base.FOnDraw;
     FOnClick:=Base.FOnClick;
     FOnGetVariableSizeInfo:=Base.FOnGetVariableSizeInfo;
     FPopupMenu:=Base.FPopupMenu;
     FSupportsMultipage:=Base.FSupportsMultipage;
     FCommandHandlerList:=TList.Create;
     FHint:=Base.FHint;
     for index:=0 to Base.FCommandHandlerList.Count-1 do
     begin
         FCommandHandlerList.Add(Base.FCommandHandlerList[index]);
     end;

     FOnInitialCreation:=Base.FOnInitialCreation;
     ParentComponent:=Base.ParentComponent;
     Description:=Base.Description;
     ObjectName:=Base.ObjectName;
     Icon:=Base.Icon;
     FFontHandle:=Base.FFontHandle;
     FFontColor:=Base.FFontColor;
     FFontSize:=Base.FFontSize;
     if Base.FILlBase[0]<> nil then
     begin
        FILlBase[0]:=Base.FILlBase[0];
     end
     else
        FILlBase[0]:=nil;

     if Base.FILlXObjectNtfySink[0]<>nil then
     begin
        FILlXObjectNtfySink[0]:=Base.FILlXObjectNtfySink[0];
     end
     else
        FILlXObjectNtfySink[0]:=nil;

     Properties:=TLl17PropertyMap.CreateCopy(Base.Properties);
end;

destructor TLl17XObject.Destroy;
begin
    if Assigned(FParentComponent) then
     try
         FParentComponent.RemoveLlXObjectFromList(self);
     except
     end;
    FIcon.Free;
    FCommandHandlerList.Free;
    Properties.Free;
    inherited destroy;
end;

function TLl17XObject.Edit(const hWnd: cmbtHWND; ptMouse: TPoint): HResult;
var ChangedFlag: boolean;
begin
    ChangedFlag:=false;
    if Assigned(FOnEdit) then
    begin
        FOnEdit(self, hWnd, ChangedFlag);
        if ChangedFlag then
            FILlXObjectNtfySink[0].UpdateView(LLX_OBJECTNOTIFYSINK_UPDATEVIEWFLAG_OBJECTCHANGED, true)
        else
            FILlXObjectNtfySink[0].UpdateView(0,true);
    end;
    result:=S_OK;
end;

function TLl17XObject.EditPart(const hWnd: cmbtHWND; ptMouse: TPoint;
  const nMenuID: cardinal): HResult;

var
    Handler: TNotifyEvent;
    TheItem: TMenuItem;

function FindMenuItem(Menu: TMenuItem; HandlerProc: Pointer): TMenuItem;
var ItemIndex: integer;
begin
    result:=nil;
    for ItemIndex:=0 to GetMenuItemCount(Menu.Handle)-1 do
    begin
          if Menu.Items[ItemIndex].Count<>0 then
            result:=FindMenuItem(Menu.Items[ItemIndex], HandlerProc)
          else
          begin
            Handler:=TNotifyEvent(Menu.Items[ItemIndex].OnClick);
            if @Handler = HandlerProc then
            begin
              result:=Menu.Items[ItemIndex];
              exit;
            end;
          end;
    end;
end;
begin
    TheItem:=FindMenuItem(PopupMenu.Items, FCommandHandlerList[nMenuID-10000]);
    if Assigned(TheItem) then
        if Assigned(TheItem.OnClick) then
        begin
            TheItem.OnClick(self);
            FILlXObjectNtfySink[0].UpdateView(LLX_OBJECTNOTIFYSINK_UPDATEVIEWFLAG_OBJECTCHANGED, true);            
        end;
    result:=S_OK;
end;

function TLl17XObject.FirstCreation(const hWndParent: cmbtHWND): HResult;
begin
    if Assigned(FOnInitialCreation) then
        FOnInitialCreation(self, hWndParent);
    result:=E_NOTIMPL; // force edit dialog anyway
end;

function TLl17XObject.ForceResetPrintState: HResult;
begin
    FPrintState:=llxpsWaiting;
    if Assigned(FOnResetPrintState) then
        FOnResetPrintState(self);
    result:=S_OK;
end;

function TLl17XObject.GetDescr(var pbsDescr: OLEString): HResult;
begin
    pbsDescr:=Description;
    result:=S_OK;
end;

function TLl17XObject.GetErrorcode: longint;
begin
    result:=0;
end;

function TLl17XObject.GetIcon(var phIcon: HIcon): HResult;
begin
    if Assigned(Icon) then
        phIcon:=Icon.Handle
    else
        phIcon:=0;
    result:=S_OK;
end;

function TLl17XObject.GetMinDimensionsSCM(const bForNew: boolean;
  var ptMinSize: Size): HResult;
begin
    result:=E_NOTIMPL;
end;

function TLl17XObject.GetName(var pbsName: OLEString): HResult;
begin
    pbsName:=ObjectName;
    result:=S_OK;
end;

function TLl17XObject.GetOption(const nOption: integer;
  var pnValue: integer): HResult;
begin
    case nOption of
        LLXOBJECT_OPTION_USABLE_AS_OBJECT: pnValue:=1;
        LLXOBJECT_OPTION_USABLE_IN_CELL: pnValue:=1;
        LLXOBJECT_OPTION_USABLE_IN_STATIC_CELL: pnValue:=1;
        LLXOBJECT_OPTION_SUPPORTS_VARSIZE:
            begin
                if Assigned(FOnGetVariableSizeInfo) then
                    pnValue:=1
                else
                    pnValue:=0;
            end;
    else
        pnValue:=0;
    end;
    result:=S_OK;

end;

function TLl17XObject.GetOptionString(const sOption: OLEString;
  var psText: OLEString): HResult;
begin
    psText := '';
    if (sOption = 'LL.MouseMove.HelpString') then
        psText:=FHint;

    result:=S_OK;
end;

function TLl17XObject.GetParameters(pIStream: IStream): HResult;
begin
    Properties.SaveToStream(pIStream);
    result:=S_OK;
end;

function TLl17XObject.GetTrueRec(var prc: TRect): HResult;
begin
    result:=E_NOTIMPL;
end;

function TLl17XObject.InObject(const hDC: HDC; ptMouse: TPoint): HResult;
begin
    result:=E_NOTIMPL;
end;

function TLl17XObject.IsProjectSupported(const nProjType: integer;
  var pbSupported: boolean): HResult;
begin
    pbSupported:=true;
    result:=S_OK;
end;

function TLl17XObject.IsSetFontSupported(var pbSupported: boolean): HResult;
begin
    pbSupported:=true;
    result:=S_OK;
end;

function TLl17XObject.OnDeclareChartRow: HResult;
begin
    result:=E_NOTIMPL;
end;

function TLl17XObject.OnDragDrop(pDataObj: IDataObject;
  const grfKeyState: Longword; p: TPoint; var pdwEffect: Longword;
  const bQuery: boolean): HResult;
begin
    result:=E_NOTIMPL;
end;

function TLl17XObject.OnMouseLButton(const hDC: HDC; ptMouse: TPoint;
  const hWnd: cmbtHWND): HResult;
var Canvas: TCanvas;
begin
    if Assigned(FOnClick) then
    begin
        Canvas:=TCanvas.Create;
        Canvas.Handle:=hDC;
        FOnClick(self, Canvas, ptMouse, hWnd);
        Canvas.Free;
    end;
    result:=S_OK;
end;

function TLl17XObject.OnMouseMove(const hDC: HDC; ptMouse: TPoint;
  var phCrs: hCursor): HResult;
begin
    result:=S_OK;
end;

function TLl17XObject.OnObject(const hDC: HDC; ptMouse: TPoint): HResult;
begin
    result:=E_NOTIMPL;
end;

function TLl17XObject.PrintFinished: HResult;
begin
    if FPrintState=llxpsFinished then
        result:=S_OK
    else
        result:=S_FALSE;
end;

function TLl17XObject.PrintPastFinished: HResult;
begin
    if FPrintState=llxpsPastFinished then
        result:=S_OK
    else
        result:=S_FALSE;

end;

function TLl17XObject.PrintUnfinished: HResult;
begin
    if FPrintState=llxpsUnfinished then
        result:=S_OK
    else
        result:=S_FALSE;

end;

function TLl17XObject.PrintWaiting: HResult;
begin
    if FPrintState=llxpsWaiting then
        result:=S_OK
    else
        result:=S_FALSE;
end;

function TLl17XObject.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
	Result := S_OK;
	pointer(obj) := NIL;

	if IsEqualGuid(iid,IID_IUnknown) then
        IUnknown(obj):=IUnknown(self);

    if IsEqualGuid(iid,IID_LLX_IObject) then
        ILlXObject(obj) := ILlXObject(self);

    if pointer(obj) = NIL then
        Result := E_NOINTERFACE;

end;

function TLl17XObject.ResetPrintState: HResult;
begin
    if FSupportsMultipage then
    begin
        FPrintState:=llxpsWaiting;
        if Assigned(FOnResetPrintState) then
            FOnResetPrintState(self);
    end;
    result:=S_OK;
end;

procedure TLl17XObject.SetDescription(const Value: String);
begin
  FDescription := Value;
end;

function TLl17XObject.SetFont(var pLF: LOGFONT; const nSize: cardinal;
  const rgbColor: COLORREF): HResult;
begin
    if (FFontHandle<>0) then DeleteObject(FFontHandle);
    FFontHandle:=CreateFontIndirect(pLF);
    FFontColor:=rgbColor;
    FFontSize:=nSize;
    result:=S_OK;
end;

procedure TLl17XObject.SetIcon(const Value: TIcon);
begin
  if not Assigned(FIcon) then FIcon:=TIcon.Create;
    FIcon.Assign(Value);
end;

function TLl17XObject.SetLLJob(hLLJob: HLLJob; pInfo: pILlBase): HResult;
begin
    if (hLLJob=0) then
    begin
        result:=S_OK;
        exit;
    end;
    FLlJob:=hLlJob;
    if FILlBase[0]<>nil then
        FILlBase[0]:=nil;
    FILlBase:=pInfo;

    result:=S_OK;

end;

function TLl17XObject.SetNtfySink(pNtfySink: pILlXObjectNtfySink): HResult;
begin
    if FILlXObjectNtfySink[0] <> nil then
        FILlXObjectNtfySink[0]:=nil;

    FILlXObjectNtfySink[0]:=pNtfySink[0];
    result:=S_OK;
end;

procedure TLl17XObject.SetObjectName(const Value: String);
begin
  FObjectName := Value;
end;

procedure TLl17XObject.SetOnDraw(const Value: TDrawObjectEvent);
begin
  FOnDraw := Value;
end;

procedure TLl17XObject.SetOnEdit(const Value: TEditObjectEvent);
begin
  FOnEdit := Value;
end;

procedure TLl17XObject.SetOnInitialCreation(const Value: TCreateObjectEvent);
begin
  FOnInitialCreation := Value;
end;

function TLl17XObject.SetOption(const nOption, nValue: integer): HResult;
begin
    result:=S_OK;
end;

function TLl17XObject.SetOptionString(const sOption: OLEString;
  sText: OLEString): HResult;
begin
    result:=S_OK;
end;

function TLl17XObject.SetParameters(pIStream: IStream): HResult;
begin
    Properties.LoadFromStream(pIStream);
    result:=S_OK;
end;

function TLl17XObject.Show(const hDC: HDC; var prcPaint: TRect;
  const hExportProfJob: HPROFJOB; const hExportProfList: HPROFLIST;
  const nExportVerbosity, nDestination: integer;
  const bSelected: boolean): HResult;

var Canvas: TCanvas;
    Rect: TRect;
    IsFinished: boolean;
begin
    if SupportsMultipage and (PrintFinished=S_OK) then
        FPrintState:=llxpsPastFinished;
    if FPrintState<llxpsFinished then
    begin
      if Assigned(FOnDraw) then
      begin
        Canvas:=TCanvas.create;
        with Canvas do
        begin
          Handle:=hDC;
          with Font do
          begin
            Handle:=FFontHandle;
            Color:=FFontColor;
            Size:=FFontSize;
          end;
        end;
        Rect:=prcPaint;
        IsFinished:=false;
        FOnDraw(self,Canvas,Rect,nDestination<>LLXOBJECT_DESTINATION_PRINTER,IsFinished);
        if IsFinished then
            FPrintState:=llxpsFinished
        else
            FPrintState:=llxpsUnfinished;
        Canvas.free;
      end;
    end
    else
    begin
        prcPaint.Bottom:=prcPaint.Top;
    end;
    if not SupportsMultipage then
        ResetPrintState;
    result:=S_OK;
end;

procedure TLl17XObject.SetMyParentComponent(const Value: TL17_);
begin
  FParentComponent := Value;
  FParentComponent.AddLlXObjectToList(self);
end;

procedure TLl17XObject.SetOnClick(const Value: TClickEvent);
begin
  FOnClick := Value;
end;

procedure TLl17XObject.SetPopupMenu(const Value: TPopupMenu);
begin
  FPopupMenu := Value;
  if Value <> nil then
  begin
    Value.FreeNotification(Self);
  end;
end;

procedure TLl17XObject.SetHint(const Value: String);
begin
  FHint := Value;
end;

procedure TLl17XObject.SetOnGetVariableSizeInfo(
  const Value: TGetVariableSizeInfoEvent);
begin
  FOnGetVariableSizeInfo := Value;
end;

procedure TLl17XObject.SetSupportsMultipage(const Value: boolean);
begin
  FSupportsMultipage := Value;
end;


procedure TLl17XObject.SetOnResetPrintState(
  const Value: TResetPrintStateEvent);
begin
  FOnResetPrintState := Value;
end;

function TLl17XObject.GetVarSizeInfo(const hDC: HDC;
  const prcSpaceAvailable: cmbtll17.pTRect; var pnMinHeight,
  pnIdealHeight: integer): HRESULT;
begin
    if (prcSpaceAvailable = nil) and (FPrintState<llxpsFinished) then
    begin
        pnIdealHeight:=1000;  // just a dumy value indicating there's data to print
        result:=S_OK;
        exit;
    end
    else
    if Assigned(FOnGetVariableSizeInfo) then
    begin
        FOnGetVariableSizeInfo(self, hDC, (prcSpaceAvailable^.Right-prcSpaceAvailable^.Left), pnMinHeight, pnIdealHeight);
        result:=S_OK;
    end
    else
        result:=E_NOTIMPL;
end;

{ TLl17XFunction }

function TLl17XFunction._AddRef: Integer;
begin
	Result := InterlockedIncrement(FRefCount);
  InterlockedIncrement(l17interf.g_nObjects);
end;

function TLl17XFunction._Release: Integer;
begin
    InterlockedDecrement(l17interf.g_nObjects);
	Result := InterlockedDecrement(FRefCount);
    if Result = 0 then
    begin
      if FILlBase[0]<>nil then
          FILlBase[0]:=nil;

    end;

end;

function TLl17XFunction.CheckSyntax(var pbsError: OLEString;
  var pnTypeRes: integer; var pnTypeResLL, pnDecs: cardinal;
  const nArgs: cardinal; VarArg1, VarArg2, VarArg3,
  VarArg4: OleVariant): HResult;
var IsValid: LongBool;
    TmpResultType: TLl17XFunctionParameterType;
    ErrorText: String;
    Decimals: integer;
begin
   IsValid:=true;
   Decimals:=pnDecs;
   TmpResultType:=ResultType;
   if Assigned(FOnCheckFunctionSyntax) then
   	begin
    	 FOnCheckFunctionSyntax(self, IsValid, ErrorText, TmpResultType, Decimals, nArgs,VarArg1, VarArg2, VarArg3,VarArg4);
   	end;
    pnTypeRes:=GetLlFctparaTypeFromParamType(TmpResultType);
    pbsError:=ErrorText;
    pnDecs:=Decimals;
    pnTypeResLL := GetLlFieldTypeFromParamType(TmpResultType);
   if IsValid then
    result:=S_OK
   else
   begin
    pnTypeRes:=-1;
    result:=E_FAIL;
   end;
end;

constructor TLl17XFunction.Create(AOwner: TComponent);
begin
    inherited create(AOwner);
    FParameter1:=TLl17XFunctionParameter.Create;
    FParameter2:=TLl17XFunctionParameter.Create;
    FParameter3:=TLl17XFunctionParameter.Create;
    FParameter4:=TLl17XFunctionParameter.Create;
    Visible:=true;
    FRefCount:=0;
    FHLib:=0;
end;


destructor TLl17XFunction.Destroy;
begin
    FParameter1.Free;
    FParameter2.Free;
    FParameter3.Free;
    FParameter4.Free;
    inherited destroy;
end;

function TLl17XFunction.Execute(var pVarRes: OleVariant; var pnTypeRes: integer;
  var pnTypeResLL, pnDecs: cardinal; const nArgs: cardinal; VarArg1,
  VarArg2, VarArg3, VarArg4: OleVariant): HResult;
var
    TmpResultType: TLl17XFunctionParameterType;
    Decimals: integer;

begin
    Decimals:=pnDecs;
    TmpResultType:=ResultType;
    if Assigned(FOnEvaluateFunction) then
    FOnEvaluateFunction(self, TmpResultType,pVarRes, Decimals, nArgs, VarArg1, VarArg2, VarArg3, VarArg4);
    pnTypeRes:=GetLlFctparaTypeFromParamType(TmpResultType);
    pnDecs:=Decimals;
    pnTypeResLL := GetLlFieldTypeFromParamType(TmpResultType);
    result:=S_OK;
end;

function TLl17XFunction.GetDescr(var pbsDescr: OLEString): HResult;
var ResultString: String;
    ParameterString: String;
begin
    ResultString := Format('%s', [GetParameterTypeText(ResultType)]);
    if(MaximumParameters >= 1) then
    begin
        if(MinimumParameters < 1) then
            ParameterString:=ParameterString+Format('[%s]', [GetParameterTypeText(Parameter1.ParameterType)])
        else
            ParameterString:=ParameterString+Format('%s', [GetParameterTypeText(Parameter1.ParameterType)])
    end;

    if(MaximumParameters >= 2) then
    begin
        if(MinimumParameters < 2) then
            ParameterString:=ParameterString+Format(', [%s]', [GetParameterTypeText(Parameter2.ParameterType)])
        else
            ParameterString:=ParameterString+Format(', %s', [GetParameterTypeText(Parameter2.ParameterType)])
    end;

    if(MaximumParameters >= 3) then
    begin
        if(MinimumParameters < 3) then
            ParameterString:=ParameterString+Format(', [%s]', [GetParameterTypeText(Parameter3.ParameterType)])
        else
            ParameterString:=ParameterString+Format(', %s', [GetParameterTypeText(Parameter3.ParameterType)])
    end;

    if(MaximumParameters >= 4) then
    begin
        if(MinimumParameters < 4) then
            ParameterString:=ParameterString+Format(', [%s]', [GetParameterTypeText(Parameter4.ParameterType)])
        else
            ParameterString:=ParameterString+Format(', %s', [GetParameterTypeText(Parameter4.ParameterType)])
    end;

    pbsDescr := Format('%s(%s)'+chr(9)+'%s'+chr(9)+'%s', [FunctionName, ParameterString, ResultString, Description]);
    result:=S_OK;
end;

function TLl17XFunction.GetGroupDescr(const bsGroup: OLEString;
  var pbsDescr: OLEString): HResult;
begin
    pbsDescr:=GroupName;
    result:=S_OK;
end;

function TLl17XFunction.GetGroups(var pbsDescr: OLEString): HResult;
begin
    pbsDescr:=GroupName;
    result:=S_OK;
end;

function TLl17XFunction.GetName(var pbsName: OLEString): HResult;
begin
    pbsName:=FunctionName;
    result:=S_OK;

end;

function TLl17XFunction.GetOption(const nOption: integer;
  var pnValue: integer): HResult;
begin
    pnValue:=0;
    result:=S_OK;
end;

function TLl17XFunction.GetParaCount(var pnMinParas,
  pnMaxParas: integer): HResult;
begin
    pnMinParas:=MinimumParameters;
    pnMaxParas:=MaximumParameters;
    result:=S_OK;
end;

function TLl17XFunction.GetLlFctparaTypeFromParamType(Value: TLl17XFunctionParameterType): integer;
begin
    result:=LL_FCTPARATYPE_STRING;
    if(Value=ptBarcode) then result:=LL_FCTPARATYPE_BARCODE;
    if(Value=ptDrawing) then result:=LL_FCTPARATYPE_DRAWING;
    if(Value=ptBool) then result:=LL_FCTPARATYPE_BOOL;
    if(Value=ptDate) then result:=LL_FCTPARATYPE_DATE;
    if(Value=ptDouble) then result:=LL_FCTPARATYPE_DOUBLE ;
    if(Value=ptAll) then result:=LL_FCTPARATYPE_ALL;
end;

function TLl17XFunction.GetLlFieldTypeFromParamType(Value: TLl17XFunctionParameterType): integer;
begin
    result:=LL_TEXT;
    if(Value=ptBarcode) then result:=LL_BARCODE;
    if(Value=ptDrawing) then result:=LL_DRAWING;
    if(Value=ptBool) then result:=LL_BOOLEAN;
    if(Value=ptDate) then result:=LL_DATE;
    if(Value=ptDouble) then result:=LL_NUMERIC;
end;


function TLl17XFunction.GetParameterTypeText(Value: TLl17XFunctionParameterType):String;
var Text: Array[0..6] of String;

function LoadStringEx(hInstance: integer; uID: Longint): String;
var Buffer: PXChar;
begin
     GetMem(Buffer, 1024);
     LoadString(hInstance, uID, Buffer, 1024);
     Result:=Buffer;
     Result:=Copy(Result,1,Pos(',',Result)-1);
     FreeMem(Buffer,1024);
end;

begin
    Text[0]:=LoadStringEx(FHLib,11506);
    Text[1]:=LoadStringEx(FHLib,11500);
    Text[2]:=LoadStringEx(FHLib,11501);
    Text[3]:=LoadStringEx(FHLib,11503);
    Text[4]:=LoadStringEx(FHLib,11502);
    Text[5]:=LoadStringEx(FHLib,11504);
    Text[6]:=LoadStringEx(FHLib,11505);

    result:=Text[integer(Value)];
end;

function TLl17XFunction.GetParaTypes(var pnTypeRes, pnTypeArg1, pnTypeArg2,
  pnTypeArg3, pnTypeArg4: integer): HResult;
begin
    pnTypeRes:=GetLlFctparaTypeFromParamType(ResultType);
    pnTypeArg1:=GetLlFctparaTypeFromParamType(Parameter1.ParameterType);
    pnTypeArg2:=GetLlFctparaTypeFromParamType(Parameter2.ParameterType);
    pnTypeArg3:=GetLlFctparaTypeFromParamType(Parameter3.ParameterType);
    pnTypeArg4:=GetLlFctparaTypeFromParamType(Parameter4.ParameterType);
    result:=S_OK;    
end;

function TLl17XFunction.GetParaValueHint(const nPara: integer; var pbsHint,
  pbsTabbedList: OLEString): HResult;

var ValueList: TStringList;
    index: integer;
begin
    case nPara of
      0: pbsHint:=Parameter1.ParameterDescription;
      1: pbsHint:=Parameter2.ParameterDescription;
      2: pbsHint:=Parameter3.ParameterDescription;
      3: pbsHint:=Parameter4.ParameterDescription;
    end;

    if Assigned(FOnParameterAutocomplete) then
    begin
        pbsTabbedList:='';
        ValueList:=TStringList.Create;
        ValueList.Clear;
        FOnParameterAutocomplete(self, nPara, ValueList);
        for index:=0 to ValueList.Count-1 do
        begin
            pbsTabbedList:=pbsTabbedList+ValueList[index]+chr(9);
        end;
        ValueList.Free;
    end
    else
        pbsTabbedList:='';

    result:=S_OK;
end;

function TLl17XFunction.GetVisibleFlag(var pbVisible: boolean): HResult;
begin
    pbVisible:=visible;
    result:=S_OK;
end;

function TLl17XFunction.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
	Result := S_OK;
	pointer(obj) := NIL;

	if IsEqualGuid(iid,IID_IUnknown) then
        IUnknown(obj):=IUnknown(self);

    if IsEqualGuid(iid,IID_LLX_IFUNCTION) then
        ILlXFunction(obj) := ILlXFunction(self);

    if pointer(obj) = NIL then
        Result := E_NOINTERFACE;

end;

procedure TLl17XFunction.SetDescription(const Value: String);
begin
  FDescription := Value;
end;

function TLl17XFunction.SetLLJob(hLLJob: HLLJob; pInfo: pILlBase): HResult;
begin
  if (hLLJob=0) then
  begin
      result:=S_OK;
      exit;
  end;
  FLlJob:=hLlJob;
  if FILlBase[0]<>nil then
      FILlBase[0]:=nil;
  FILlBase:=pInfo;
  result:=S_OK;
end;

procedure TLl17XFunction.SetMaximumParameters(const Value: integer);
begin
  FMaximumParameters := Value;
end;

procedure TLl17XFunction.SetMinimumParameters(const Value: integer);
begin
  FMinimumParameters := Value;
end;

function TLl17XFunction.SetOption(const nOption, nValue: integer): HResult;
begin
    case nOption of
        LLXFUNCTION_OPTION_LANGUAGE: FLanguage:=nValue;
        LLXFUNCTION_OPTION_HLIBRARY: FHLib:=nValue;
    end;
    result:=S_OK;
end;

procedure TLl17XFunction.SetParameter1(const Value: TLl17XFunctionParameter);
begin

  FParameter1.ParameterType:=Value.ParameterType;
  FParameter1.ParameterDescription:=Value.ParameterDescription;
end;

procedure TLl17XFunction.SetParameter2(const Value: TLl17XFunctionParameter);
begin
  FParameter2.ParameterType:=Value.ParameterType;
  FParameter2.ParameterDescription:=Value.ParameterDescription;
end;

procedure TLl17XFunction.SetParameter3(const Value: TLl17XFunctionParameter);
begin
  FParameter3.ParameterType:=Value.ParameterType;
  FParameter3.ParameterDescription:=Value.ParameterDescription;

end;

procedure TLl17XFunction.SetParameter4(const Value: TLl17XFunctionParameter);
begin
  FParameter4.ParameterType:=Value.ParameterType;
  FParameter4.ParameterDescription:=Value.ParameterDescription;
end;

procedure TLl17XFunction.SetResultType(
  const Value: TLl17XFunctionParameterType);
begin
  FResultType := Value;
end;

procedure TLl17XFunction.SetFunctionName(const Value: String);
begin
  FFunctionName := Value;
end;

procedure TLl17XFunction.SetGroupName(const Value: String);
begin
  FGroupName := Value;
end;

procedure TLl17XFunction.SetMyParentComponent(const Value: TL17_);
begin
  FParentComponent := Value;
  FParentComponent.AddLlXFunctionToList(self);
end;

procedure TLl17XFunction.SetVisible(const Value: boolean);
begin
  FVisible := Value;
end;

procedure TLl17XFunction.SetOnCheckFunctionSyntax(
  const Value: TCheckFunctionSyntaxEvent);
begin
  FOnCheckFunctionSyntax := Value;
end;

procedure TLl17XFunction.SetOnEvaluateFunction(
  const Value: TEvaluateFunctionEvent);
begin
  FOnEvaluateFunction := Value;
end;

procedure TLl17XFunction.SetOnParameterAutoComplete(
  const Value: TParameterAutoCompleteEvent);
begin
  FOnParameterAutoComplete := Value;
end;


procedure TL17_.AddLlXObjectToList(TheObject: TLl17XObject);
begin
    FLlxObjectList.Add(TheObject);
end;

procedure TL17_.RemoveLlXObjectFromList(TheObject: TLl17XObject);
begin
    FLlXObjectList.Remove(TheObject);
end;

procedure TL17_.AddLlXFunctionToList(TheFunction: TLl17XFunction);
begin
    FLlxFunctionList.Add(TheFunction);
end;

procedure TL17_.RemoveLlXFunctionFromList(TheFunction: TLl17XFunction);
begin
    FLlXFunctionList.Remove(TheFunction);
end;

procedure TL17_.DeclareLlXObjectsToLL;
begin
    FLlXInterface:=nil;
    FLlXInterface:=LlXInterface.Create(FLlXObjectList, FLlXFunctionList);

    LlSetOption(53, lParam(ILlXInterface(FLlXInterface)));
end;

{ TLl17XFunctionParameter }

procedure TLl17XFunctionParameter.SetParameterDescription(
  const Value: String);
begin
  FParameterDescription := Value;
end;

procedure TLl17XFunctionParameter.SetParameterType(
  const Value: TLl17XFunctionParameterType);
begin
  FParameterType := Value;
end;


{$endif} //{$ifdef USELLXOBJECTS}

procedure TL17_.RemoveLlXActionFromList(TheAction: TLl17XAction);
begin
  FLlXActionList.Remove(TheAction)
end;

procedure TL17_.AddLlXActionToList(TheAction: TLl17XAction);
begin
    FLlXActionList.Add(TheAction);
end;

function TL17_.LlPrintSetProjectParameter(ParamName, ParamValue: TString; Flag: Longint):integer;
begin
  Result := cmbtll17.LlPrintSetProjectParameter(hTheJob, PTChar(ParamName), PTChar(ParamValue), Flag);
end;

function TL17_.LlPrintGetProjectParameter(ParamName: TString; Evaluated: Boolean;
 var ParamValue: TString; var Flag: _LPUINT): integer;
var
  Buffer: PTChar;
  length: integer;
begin
  length := cmbtll17.LlPrintGetProjectParameter(hTheJob, PTChar(ParamName), Evaluated, nil, 0, nil);
  if length>0 then
  begin
    GetMem(Buffer, length * sizeof(TChar));
    Buffer^ := #0;
    Result := cmbtll17.LlPrintGetProjectParameter(hTheJob, PTChar(ParamName), Evaluated, Buffer, length, nil);
    ParamValue := TString(Buffer);
    FreeMem(Buffer);
  end
  else
  begin
    Result:=length;
    ParamValue:='';
  end;
end;

function TL17_.LlGetProjectParameter(ProjectName: TString; ParamName: TString; var ParamValue: TString): integer;
var
  Buffer: PTChar;
  length: integer;
begin
  length := cmbtll17.LlGetProjectParameter(hTheJob, PTChar(ProjectName), PTChar(ParamName), nil, 0);
  if length>0 then
  begin
    GetMem(Buffer, length * sizeof(TChar));
    Buffer^ := #0;
    Result := cmbtll17.LlGetProjectParameter(hTheJob, PTChar(ProjectName), PTChar(ParamName), Buffer, length);
    ParamValue := TString(Buffer);
    FreeMem(Buffer);
  end
  else
  begin
    Result:=length;
    ParamValue:='';
  end;
end;

function TL17_.LlGetDefaultProjectParameter(ParamName: TString; var ParamValue: TString;
  var Flag: _LPUINT): integer;
var
  Buffer: PTChar;
  length: integer;
  pParamName: PTChar;
begin
  if ParamName<>'' then
  begin
    pParamName := PTChar(ParamName);
  end
  else
  begin
    pParamName := nil;
  end;
  length := cmbtll17.LlGetDefaultProjectParameter(hTheJob, pParamName, nil, 0, nil);
  if length>0 then
  begin
    GetMem(Buffer, length * sizeof(TChar));
    Buffer^ := #0;
    Result := cmbtll17.LlGetDefaultProjectParameter(hTheJob, pParamName, Buffer, length, _LPUINT(@Flag));
    ParamValue := TString(Buffer);
    FreeMem(Buffer);
  end
  else
  begin
    Result:=length;
    ParamValue:='';
  end;
end;

function TL17_.LlSetDefaultProjectParameter(ParamName, ParamValue: TString; Flag: Longint
  ): integer;
begin
  Result := cmbtll17.LlSetDefaultProjectParameter(hTheJob, PTChar(ParamName), PTChar(ParamValue), Flag)
end;


function TL17_.LlDesignerProhibitEditingObject(ObjectName: TString): integer;
begin
  Result := cmbtll17.LlDesignerProhibitEditingObject(hLlJob, PTChar(ObjectName));
end;

function TL17_.LlGetUsedIdentifiers(ProjectName: TString; var UsedIdentifiers: TStringList
  ): integer;
var
 Buffer: PTChar;
 length: integer;
begin
  length := cmbtll17.LlGetUsedIdentifiers(hTheJob, PTChar(ProjectName), nil, 0);
  if length>0 then
  begin
    GetMem(Buffer, length * sizeof(TChar));
    Buffer^ := #0;
    Result := cmbtll17.LlGetUsedIdentifiers(hTheJob, PTChar(ProjectName), Buffer, length);
    UsedIdentifiers.Assign( Ll17HelperClass.Split(TString(Buffer),#59,false,false) );
    FreeMem(Buffer);
  end
  else
  begin
    Result:=length;
    UsedIdentifiers.Text := '';
  end;
end;

{$ifdef UNICODE}
function TL17_.LlGetPrinterFromPrinterFile(ProjectType: Cardinal; ProjectName: TString;
  PrinterIndex: integer; var Printer: TString;
                         var DevMode: _PDEVMODEW): integer;

{$else}
function TL17_.LlGetPrinterFromPrinterFile(ProjectType: Cardinal; ProjectName: TString;
  PrinterIndex: integer; var Printer: TString;
                         var DevMode: _PDEVMODEA): integer;
{$endif}
var
 BufPrinter: PTChar;
 {$ifdef UNICODE}
 BufDevMode: _PDEVMODEW;
 {$else}
 BufDevMode: _PDEVMODEA;
 {$endif}
 PrnSize, DevModeSize: cardinal;
 nRet: integer;
begin


 nRet:=cmbtll17.LlGetPrinterFromPrinterFile(hTheJob, ProjectType, PTChar(ProjectName),
                                                PrinterIndex, nil, @PrnSize, nil, @DevModeSize);
 if nRet>=0 then
 begin

   GetMem(BufPrinter, PrnSize*Sizeof(TChar));
   GetMem(BufDevMode, DevModeSize*Sizeof(TChar));
   BufPrinter^ := #0;
   nRet := cmbtll17.LlGetPrinterFromPrinterFile(hTheJob, ProjectType, PTChar(ProjectName),
                                                PrinterIndex, PTChar(BufPrinter), @PrnSize, BufDevMode, @DevModeSize);
   Printer := TString(BufPrinter);
   DevMode := BufDevMode;
   FreeMem(PTChar(BufPrinter));
 end;
 result:=nRet;
end;


{ TLl17PreviewControl }

constructor TLl17PreviewControl.Create(AOwner: TComponent);
begin
    inherited create(AOwner);
    FNotifyProc := TFarProc(@StgsysNtfyCallback);
    FInitializing:=true;
    ShowToolbar:=true;
    ShowThumbnails:=true;
    ShowUnprintableArea:=false;
    InputFileName:='';
    BackgroundColor:=clWhite;
    FhLlJob := -1;
    FCloseMode := cmKeepFile;
    ToolbarButtons:=TLl17PreviewButtons.create(self);
end;

procedure TLl17PreviewControl.CreateParams(var Params: TCreateParams);
begin
    inherited CreateParams(Params);
    Params.ExStyle:=Params.ExStyle or WS_EX_CLIENTEDGE;
end;

procedure TLl17PreviewControl.CreateWindowHandle(
  const Params: TCreateParams);
begin
    if not (csDesigning in ComponentState) then
    begin
    {$ifdef UNICODE}
      {$ifdef UNICODESTRING_AWARE}
        StrCopy(PChar(@Params.WinClassName), LsGetViewerControlClassName);
      {$else}
        StrCopy(@Params.WinClassName,PChar(Ll17HelperClass.PWideToString(LsGetViewerControlClassName)));
      {$endif}
    {$else}
        StrCopy(PChar(@Params.WinClassName), LsGetViewerControlClassName);
    {$endif}
    end;
    inherited CreateWindowHandle(Params);
end;

procedure TLl17PreviewControl.CreateWnd;
begin
    inherited CreateWnd;
    SendMessage(handle,LS_VIEWERCONTROL_SET_OPTION, LS_OPTION_USERDATA, lparam(self));
    SendMessage(handle,LS_VIEWERCONTROL_SET_NTFYCALLBACK, 0, lparam(FNotifyProc));
    FInitializing:=false;
    if not (csDesigning in ComponentState) then
    begin
        RefreshOptions;
        RefreshToolbar;
    end;
end;

procedure TLl17PreviewControl.DestroyWindowHandle;
begin
    if IsWindow(handle) then
        inherited DestroyWindowHandle;
end;


procedure TLl17PreviewControl.Detach;
var
 CurrentInputFileName: TString;
begin
  CurrentInputFileName := InputFileName;
  LlAssociatePreviewControl(FhLlJob, 0, 0);
  if ( (CurrentInputFileName <> '') and (CloseMode = cmDeleteFile) ) then
  {$ifdef UNICODE}
    DeleteFileW(PWideChar(CurrentInputFileName));
  {$else}
    DeleteFile(PAnsiChar(CurrentInputFileName));
  {$endif}
end;

destructor TLl17PreviewControl.Destroy;
begin
    ToolbarButtons.Free;
    inherited destroy;
end;

function TLl17PreviewControl.GetActualButtonState(ButtonID: integer):integer;
begin
    if ShowToolbar then
        result:=SendMessage(handle, LS_VIEWERCONTROL_GET_TOOLBARBUTTONSTATE, ButtonID,0)
    else
        result:=LL_ERR_PARAMETER;

end;

function TLl17PreviewControl.GetOptionString(Option: TString): TString;
var Size: integer;
    Buffer: PTChar;
begin
    Size:=SendMessage(handle, LS_VIEWERCONTROL_GET_OPTIONSTRLEN, integer(PTChar(Option)), 0);
    if Size>0 then
    begin
      GetMem(Buffer,Size*sizeof(TChar));
      Buffer^ := #0;
      SendMessage(handle, LS_VIEWERCONTROL_GET_OPTIONSTR, integer(PTChar(Option)), integer(Buffer));
      result:=Buffer;
      FreeMem(Buffer);
    end
    else
        result:='';
end;

function TLl17PreviewControl.GetCurrentPage: integer;
begin
     result:=SendMessage(handle, LS_VIEWERCONTROL_GET_PAGE, 0, 0);
end;

function TLl17PreviewControl.GetPageCount: integer;
begin
     result:=SendMessage(handle, LS_VIEWERCONTROL_GET_PAGECOUNT, 0, 0);
end;

procedure TLl17PreviewControl.GotoFirst;
begin
    SendMessage(handle,LS_VIEWERCONTROL_SET_PAGE, 0, 0);
end;

procedure TLl17PreviewControl.GotoLast;
var
    Pages: integer;
begin
    Pages:=SendMessage(handle,LS_VIEWERCONTROL_GET_PAGECOUNT, 0, 0);
    SendMessage(handle,LS_VIEWERCONTROL_SET_PAGE, Pages-1, 0);
end;

procedure TLl17PreviewControl.GotoNext;
var
    CurrentPage: integer;
begin
    CurrentPage:=SendMessage(handle,LS_VIEWERCONTROL_GET_PAGE, 0, 0);
    SendMessage(handle,LS_VIEWERCONTROL_SET_PAGE, CurrentPage+1, 0);
end;

procedure TLl17PreviewControl.SaveAs;
begin
    SendMessage(handle,LS_VIEWERCONTROL_SAVE_TO_FILE, 0, 0);
end;


procedure TLl17PreviewControl.GotoPrevious;

var
    CurrentPage: integer;
begin
    CurrentPage:=SendMessage(handle,LS_VIEWERCONTROL_GET_PAGE, 0, 0);
    if CurrentPage>0 then
        SendMessage(handle,LS_VIEWERCONTROL_SET_PAGE, CurrentPage-1, 0);
end;

procedure TLl17PreviewControl.PrintAllPages(ShowPrintOptions: boolean);
var Value: integer;
begin
    if ShowPrintOptions then Value:=1 else Value:=0;
    SendMessage(handle,LS_VIEWERCONTROL_PRINT_ALL, Value, 0);
end;

procedure TLl17PreviewControl.PrintCurrentPage(ShowPrintOptions: boolean);
var Value: integer;
begin
    if ShowPrintOptions then Value:=1 else Value:=0;
    SendMessage(handle,LS_VIEWERCONTROL_PRINT_CURRENT, Value, 0);
end;

procedure TLl17PreviewControl.QuestButtonState(ButtonID: integer;
  var Result: integer);
begin
    case ButtonID of
        IDM_PRV_ZOOMMUL2        : Result:=integer(ToolbarButtons.ZoomTimes2)-1;
        IDM_PRV_ZOOMPREV        : Result:=integer(ToolbarButtons.ZoomRevert)-1;
        IDM_PRV_FIRST           : Result:=integer(ToolbarButtons.GotoFirst)-1;
        IDM_PRV_LAST            : Result:=integer(ToolbarButtons.GotoLast)-1;
        IDM_PRV_PREVIOUS        : Result:=integer(ToolbarButtons.GotoPrev)-1;
        IDM_PRV_NEXT            : Result:=integer(ToolbarButtons.GotoNext)-1;
        IDM_PRV_DEFAULT         : Result:=integer(ToolbarButtons.ZoomReset)-1;
        IDM_PRV_PRINTONE        : Result:=integer(ToolbarButtons.PrintCurrentPage)-1;
        IDM_PRV_PRINTALL        : Result:=integer(ToolbarButtons.PrintAllPages)-1;
        IDM_PRV_FILEEXIT        : Result:=integer(ToolbarButtons.Exit)-1;
        IDM_PRV_SENDTO          : Result:=integer(ToolbarButtons.SendTo)-1;
        IDM_PRV_SAVEAS          : Result:=integer(ToolbarButtons.SaveAs)-1;
        IDM_PRV_FAX             : Result:=integer(ToolbarButtons.PrintToFax)-1;
        IDM_PRV_PAGECOMBO       : Result:=integer(ToolbarButtons.PageCombo)-1;
        IDM_PRV_ZOOMCOMBO       : Result:=integer(ToolbarButtons.ZoomCombo)-1;
        IDM_PRV_SLIDESHOWMODE   : Result:=integer(ToolbarButtons.SlideShowMode)-1;
        IDM_PRV_SEARCH          : Result:=integer(ToolbarButtons.SearchStart)-1;
        IDM_PRV_SEARCH_NEXT     : Result:=integer(ToolbarButtons.SearchNext)-1;
        IDM_PRV_SEARCH_TEXT     : Result:=integer(ToolbarButtons.SearchText)-1;
        IDM_PRV_SEARCH_OPTIONS  : Result:=integer(ToolbarButtons.SearchOptions)-1;

    else
        Result:=0;
    exit;
    end;

end;

procedure TLl17PreviewControl.RefreshOptions;
begin
    SetFileName(InputFileName);
    SetShowToolbar(FShowToolbar);
    SetBackgroundColor(FBackgroundColor);
    SetShowThumbnails(FShowThumbnails);
    SetSaveAsFilePath(FSaveAsFilePath);    
end;

procedure TLl17PreviewControl.RefreshToolbar;
begin
    if not FInitializing then
        SendMessage(handle, LS_VIEWERCONTROL_NTFY_TOOLBARUPDATE, 0, 0);
end;

procedure TLl17PreviewControl.SetBackgroundColor(const Value: TColor);
begin
  FBackgroundColor := Value;
  if not FInitializing then
  begin
    SendMessage(handle, LS_VIEWERCONTROL_SET_OPTION, LS_OPTION_BGCOLOR,BackgroundColor);
  end;
end;

procedure TLl17PreviewControl.SetCloseMode(const Value: TCloseMode);
begin
  FCloseMode := Value;
end;

procedure TLl17PreviewControl.SetFileName(const Value: TString);
begin
  if not (csDesigning in ComponentState) then
  begin
    if not FInitializing then
    begin
        SendMessage(handle,LS_VIEWERCONTROL_SET_FILENAME,0,Integer(PTChar(Value)));
        invalidate;
    end;
  end;
  FFileName := Value;
end;

procedure TLl17PreviewControl.SetLanguage(const Value: TLanguageType);
begin
  SendMessage(handle,LS_VIEWERCONTROL_SET_OPTION, LS_OPTION_LANGUAGE, integer(value)-1);
  FLanguage := Value;
end;

procedure TLl17PreviewControl.SetOptionString(Option, Value: TString);
begin
  SendMessage(handle, LS_VIEWERCONTROL_SET_OPTIONSTR, integer(PTChar(Option)), integer(PTChar(Value)));
end;

procedure TLl17PreviewControl.SetSlideShowMode;
begin
  SendMessage(handle, LS_VIEWERCONTROL_SET_THEATERMODE, 1, 1);
end;

procedure TLl17PreviewControl.SetSaveAsFilePath(const Value: TString);
begin
  FSaveAsFilePath := Value;
  if not (csDesigning in ComponentState) then
  begin
    if not FInitializing then
      SendMessage(handle,LS_VIEWERCONTROL_SET_OPTION, LS_OPTION_SAVEASFILEPATH, Integer(PTChar(Value)));
  end;
end;

procedure TLl17PreviewControl.SetShowToolbar(const Value: boolean);
var IntValue: integer;
begin
  FShowToolbar := Value;
  if not (csDesigning in ComponentState) then
  begin
    if Value then IntValue:=1 else IntValue:=0;
    if not FInitializing then SendMessage(handle,LS_VIEWERCONTROL_SET_OPTION, LS_OPTION_TOOLBAR, IntValue);
  end;
end;

procedure TLl17PreviewControl.SetShowUnprintableArea(const Value: boolean);
var IntValue: integer;
begin
  FShowUnprintableArea:=Value;
  if not (csDesigning in ComponentState) then
  begin
    if Value then IntValue:=1 else IntValue:=0;
      if not FInitializing then SendMessage(handle,LS_VIEWERCONTROL_SET_OPTION, LS_OPTION_SHOW_UNPRINTABLE_AREA,IntValue);
  end;
end;

procedure TLl17PreviewControl.SetToolbarButtons(
  const Value: TLl17PreviewButtons);
begin
  FToolbarButtons := Value;
end;

procedure TLl17PreviewControl.SetZoom(Percentage: integer);
begin
    SendMessage(handle,LS_VIEWERCONTROL_SET_ZOOM, Percentage, 0);
end;


procedure TLl17PreviewControl.ZoomReset;
begin
    SendMessage(handle,LS_VIEWERCONTROL_RESET_ZOOM, 0, 0);
end;

procedure TLl17PreviewControl.ZoomRevert;
begin
    SendMessage(handle,LS_VIEWERCONTROL_POP_ZOOM, 0, 0);
end;

procedure TLl17PreviewControl.ZoomTimes2;
begin
    SendMessage(handle,LS_VIEWERCONTROL_SET_ZOOM_TWICE, 0, 0);
end;

procedure TLl17PreviewControl.Attach(FParentComponent: TL17_;
  nFlags: Cardinal);
begin
  FhLlJob := FParentComponent.hTheJob;
  LlAssociatePreviewControl(FhLlJob, Self.Handle, nFlags);
end;

procedure TLl17PreviewControl.SearchFirst(SearchString: TString; CaseSensitive: Boolean);
var wParam: integer;
begin
  if CaseSensitive = True then
  begin
     wParam := 0;
  end
  else
  begin
    wParam := LS_VCITEM_SEARCHFLAG_CASEINSENSITIVE;
  end;

  SendMessage(handle, LS_VIEWERCONTROL_SEARCH,
   LS_VCITEM_SEARCH_FIRST Or wParam,
  Integer(PTChar(SearchString)));
end;

procedure TLl17PreviewControl.SearchNext;
begin
  SendMessage(handle, $400 + 29 (*LS_VIEWERCONTROL_SEARCH*), 1 (*LS_VCITEM_SEARCH_NEXT*), 0);
end;

function TLl17PreviewControl.CanClose: boolean;
begin
    if SendMessage(handle,LS_VIEWERCONTROL_QUERY_ENDSESSION, 0, 0)=1 then
        result:=true
    else
        result:=false;
end;

procedure TLl17PreviewControl.SetOnButtonClicked(
  const Value: TButtonClickedEvent);
begin
  FOnButtonClicked := Value;
end;

procedure TLl17PreviewControl.SetShowThumbnails(const Value: boolean);
var IntValue: integer;
begin
  FShowThumbnails:=Value;
  if not (csDesigning in ComponentState) then
  begin
    if Value then IntValue:=1 else IntValue:=0;
    if not FInitializing then SendMessage(handle,LS_VIEWERCONTROL_SET_OPTION, LS_OPTION_NAVIGATIONBAR,IntValue);
  end;
end;

{ TLl17PreviewButtons }

constructor TLl17PreviewButtons.create(AParent: TLl17PreviewControl);
begin
  inherited create;
  FParentComponent:=AParent;
  Exit:=bsDefault;
  GotoFirst:=bsDefault;
  GotoLast:=bsDefault;
  GotoNext:=bsDefault;
  GotoPrev:=bsDefault;
  PrintAllPages:=bsDefault;
  PrintCurrentPage:=bsDefault;
  PrintToFax:=bsDefault;
  SaveAs:=bsDefault;
  SendTo:=bsDefault;
  ZoomReset:=bsDefault;
  ZoomRevert:=bsDefault;
  ZoomTimes2:=bsDefault;
  PageCombo:=bsDefault;
  ZoomCombo:=bsDefault;
  SlideShowMode:=bsDefault;
  SearchNext:=bsDefault;
  SearchOptions:=bsDefault;
  SearchStart:=bsDefault;
  SearchText:=bsDefault;
end;

procedure TLl17PreviewButtons.SetExit(const Value: TButtonState);
begin
  FExit := Value;
  FParentComponent.RefreshToolbar;
end;

procedure TLl17PreviewButtons.SetGotoFirst(const Value: TButtonState);
begin
  FGotoFirst := Value;
  FParentComponent.RefreshToolbar;
end;

procedure TLl17PreviewButtons.SetGotoLast(const Value: TButtonState);
begin
  FGotoLast := Value;
  FParentComponent.RefreshToolbar;
end;

procedure TLl17PreviewButtons.SetGotoNext(const Value: TButtonState);
begin
  FGotoNext := Value;
  FParentComponent.RefreshToolbar;
end;

procedure TLl17PreviewButtons.SetGotoPrev(const Value: TButtonState);
begin
  FGotoPrev := Value;
  FParentComponent.RefreshToolbar;
end;

procedure TLl17PreviewButtons.SetPageCombo(const Value: TButtonState);
begin
  FPageCombo := Value;
  FParentComponent.RefreshToolbar;
end;

procedure TLl17PreviewButtons.SetPrintAllPages(const Value: TButtonState);
begin
  FPrintAllPages := Value;
  FParentComponent.RefreshToolbar;
end;

procedure TLl17PreviewButtons.SetPrintCurrentPage(const Value: TButtonState);
begin
  FPrintCurrentPage := Value;
  FParentComponent.RefreshToolbar;
end;

procedure TLl17PreviewButtons.SetPrintToFax(const Value: TButtonState);
begin
  FPrintToFax := Value;
  FParentComponent.RefreshToolbar;
end;

procedure TLl17PreviewButtons.SetSaveAs(const Value: TButtonState);
begin
  FSaveAs := Value;
  FParentComponent.RefreshToolbar;
end;

procedure TLl17PreviewButtons.SetSearchNext(const Value: TButtonState);
begin
  FSearchNext := Value;
  FParentComponent.RefreshToolbar;
end;

procedure TLl17PreviewButtons.SetSearchOptions(const Value: TButtonState);
begin
  FSearchOptions := Value;
  FParentComponent.RefreshToolbar;
end;

procedure TLl17PreviewButtons.SetSearchStart(const Value: TButtonState);
begin
  FSearchStart := Value;
  FParentComponent.RefreshToolbar;
end;

procedure TLl17PreviewButtons.SetSearchText(const Value: TButtonState);
begin
  FSearchText := Value;
  FParentComponent.RefreshToolbar;
end;

procedure TLl17PreviewButtons.SetSendTo(const Value: TButtonState);
begin
  FSendTo := Value;
  FParentComponent.RefreshToolbar;
end;

procedure TLl17PreviewButtons.SetSlideShowMode(const Value: TButtonState);
begin
  FSlideShowMode := Value;
  FParentComponent.RefreshToolbar;
end;

procedure TLl17PreviewButtons.SetZoomCombo(const Value: TButtonState);
begin
  FZoomCombo := Value;
  FParentComponent.RefreshToolbar;
end;

procedure TLl17PreviewButtons.SetZoomReset(const Value: TButtonState);
begin
  FZoomReset := Value;
  FParentComponent.RefreshToolbar;
end;

procedure TLl17PreviewButtons.SetZoomRevert(const Value: TButtonState);
begin
  FZoomRevert := Value;
  FParentComponent.RefreshToolbar;
end;

procedure TLl17PreviewButtons.SetZoomTimes2(const Value: TButtonState);
begin
  FZoomTimes2 := Value;
  FParentComponent.RefreshToolbar;
end;

{$ifndef NOADVANCEDDATABINDING}
{$endif}
{$ifndef NOADVANCEDDATABINDING}
{$endif}

{ TLongintList }

function CompareFunction(Item1, Item2: Pointer): Integer;
var i1,i2: longint;
begin
     i1:=longint(Item1^);
     i2:=longint(Item2^);
     if (i1>i2) then result:=1
     else
     if (i1<i2) then result:=-1
     else
     result:=0;
end;


procedure TLongintList.Add(item: Integer);
var pItem: ^longint;
begin
     (* ChK: und das ist tödlich: Find() sortert die Liste immer wieder! *)
     if (Find(item)=-1) then
     begin
       new(pItem);
       pItem^:=item;
       List.Add(pItem);
     end;
end;

procedure TLongintList.Clear;
begin
     FList.Clear;
end;

constructor TLongintList.Create;
begin
     FList:=TList.Create;
end;

destructor TLongintList.Destroy;
begin
     while (List.Count>0) do
     begin
          FreeMem(List.Items[0]);
          List.Delete(0);
     end;
     List.Free;
end;

function TLongintList.Find(item: longint): integer;
  var I: Integer;
begin
     if List.Count=0 then
     begin
        result:=-1;
        exit;
     end;

     for I := 0 to List.Count - 1 do
     begin
       if (Items[I]=item) then
       begin
            result:=i;
            exit;
       end;
     end;
     result:=-1;
end;


function TLongintList.GetCount: integer;
begin
    result:=List.Count;
end;

function TLongintList.GetItems(Index: Integer): longint;
begin
     result:=longint(List[Index]^);
end;

{ TTableMap }
{ TDicData }
procedure TDicData.Add(Key, Value: TString);
begin
  Add(Key, Value, 0);
end;

procedure TDicData.Add(Key, Value: TString; LCID: integer);
var Pos: integer;
    CurrentList: TStringList;
begin
    CurrentList:=KeyList[LCID];
    if (CurrentList=nil) then
    begin
      FLCIDList.Add(LCID);
      CurrentList:=TStringList.Create;
      FKeyListList.Add(CurrentList);
      FValueListList.Add(TStringList.Create);
    end;
    Pos:=CurrentList.IndexOf(Key);
    if Pos<>-1 then
    begin
      KeyList[LCID].Delete(Pos);
      ValueList[LCID].Delete(Pos);
    end;
    KeyList[LCID].Add(Key);
    ValueList[LCID].Add(Value);
    LlLocAddDictionaryEntry(FParentObj.hTheJob, LCID, PTChar(Key), PTChar(Value), Cardinal(FDictionaryType));

end;

procedure TDicData.Clear;
begin
  FLCIDList.Clear;
  FKeyListList.Clear;
  FValueListList.Clear;
  LlLocAddDictionaryEntry(FParentObj.hTheJob, 0, nil, nil, Cardinal(FDictionaryType));
end;

constructor TDicData.Create(ParentObj: TL17_; DictionaryType: TDictionaryType);
begin
    inherited create;
    FDictionaryType := DictionaryType;
    FKeyListList:=TList.Create;
    FValueListList:=TList.Create;
    FLCIDList:=TLongintList.Create;
    FParentObj:=ParentObj;
end;

destructor TDicData.Destroy;
var
  I: Integer;
begin
  for I := 0 to FLCIDList.Count - 1 do
  begin
    KeyList[i].Free;
    ValueList[i].Free;
  end;
  FKeyListList.Free;
  FValueListList.Free;
  FLCIDList.Free;
  inherited destroy;
end;

function TDicData.GetKeyList(LCID: integer): TStringList;
var Pos: integer;
begin
  Pos:=FLCIDList.Find(LCID);
  if (pos<>-1) then
    result := FKeyListList[pos]
  else
    result := nil;

end;

function TDicData.GetLCIDList: TLongintList;
begin
  result:=FLCIDList;
end;

function TDicData.GetValue(Key: TString; var Value: TString;
  LCID: integer): boolean;
var Pos: integer;
begin
    result:=false;
    Pos:=KeyList[LCID].IndexOf(Key);
    if Pos=-1 then
    begin
        Value:='';
        exit;
    end;
    result:=true;
    Value:=ValueList[LCID][Pos];
end;

function TDicData.GetValueList(LCID: integer): TStringList;
var Pos: integer;
begin
  Pos:=FLCIDList.Find(LCID);
  if (pos<>-1) then
    result := FValueListList[pos]
  else
    result := nil;

end;

function TDicData.GetValue(Key: TString; var Value: TString): boolean;
begin
  result := GetValue(Key, Value, 0);
end;

{ TDictionary }

procedure TDictionary.Clear;
begin
  Tables.Clear;
  Relations.Clear;
  Fields.Clear;
  SortOrders.Clear;
  StaticTexts.Clear;
end;

constructor TDictionary.Create(ParentObj:TL17_);
begin
  inherited Create;
  FParentObj:=ParentObj;
  Tables := TDicData.Create(ParentObj, dtTables);
  Fields := TDicFields.Create(ParentObj, dtIdentifiers);
  Relations := TDicData.Create(ParentObj, dtRelations);
  SortOrders := TDicData.Create(ParentObj, dtSortOrders);
  StaticTexts := TDicData.Create(ParentObj, dtStatic);
end;

destructor TDictionary.Destroy;
begin

  FTables.Free;
  FFields.Free;
  FRelations.Free;
  FSortOrders.Free;
  FStaticTexts.Free;
  inherited Destroy;
end;

procedure TDictionary.SetFields(const Value: TDicFields);
begin
  FFields := Value;
end;

procedure TDictionary.SetRelations(const Value: TDicData);
begin
  FRelations := Value;
end;

procedure TDictionary.SetSortOrders(const Value: TDicData);
begin
  FSortOrders := Value;
end;

procedure TDictionary.SetStaticTexts(const Value: TDicData);
begin
  FStaticTexts := Value;
end;

procedure TDictionary.SetTables(const Value: TDicData);
begin
  FTables := Value;
end;

{ TLl17MailJob }

constructor TLl17MailJob.create;
begin
 inherited create;
 MailAttachmentList := TStringList.Create;
 MailJob := cmbtls17.LsMailJobOpen(-1);
 ShowDialog := true;
end;

destructor TLl17MailJob.Destroy;
begin
 MailAttachmentList.Free;
 inherited destroy;
end;

procedure TLl17MailJob.Send(hwnd: HWND);
var DelText: TString;
    i: integer;
begin
 for i:= 0 to MailAttachmentList.Count-1 do
 begin
    DelText:=DelText+MailAttachmentList[i]+#9;
 end;
 cmbtls17.LsMailSetOptionString(MailJob,'Export.Mail.AttachmentList',PTChar(DelText));
 cmbtls17.LsMailSendFile(MailJob,hwnd);
end;

procedure TLl17MailJob.SetMailAttachment(const Value: TString);
begin
  FMailAttachment := Value;
  MailAttachmentList.Add(Value);
end;

procedure TLl17MailJob.SetMailBCC(const Value: TString);
begin
  FMailBCC := Value;
  cmbtls17.LsMailSetOptionString(MailJob,'Export.Mail.BCC',PTChar(Value));
end;

procedure TLl17MailJob.SetMailBody(const Value: TString);
begin
  FMailBody := Value;
  cmbtls17.LsMailSetOptionString(MailJob,'Export.Mail.Body',PTChar(Value));
end;

procedure TLl17MailJob.SetMailBodyHTML(const Value: TString);
begin
  FMailBodyHTML := Value;
  cmbtls17.LsMailSetOptionString(MailJob,'Export.Mail.Body:text/html',PTChar(Value));
end;

procedure TLl17MailJob.SetMailCC(const Value: TString);
begin
  FMailCC := Value;
  cmbtls17.LsMailSetOptionString(MailJob,'Export.Mail.CC',PTChar(Value));
end;

procedure TLl17MailJob.SetMailJob(const Value: integer);
begin
  FMailJob := Value;
end;

procedure TLl17MailJob.SetMailProvider(const Value: TString);
begin
  FMailProvider := Value;
  cmbtls17.LsMailSetOptionString(MailJob,'Export.Mail.Provider',PTChar(Value));
end;

procedure TLl17MailJob.SetMailSubject(const Value: TString);
begin
  FMailSubject := Value;
  cmbtls17.LsMailSetOptionString(MailJob,'Export.Mail.Subject',PTChar(Value));
end;

procedure TLl17MailJob.SetMailTo(const Value: TString);
begin
  FMailTo := Value;
  cmbtls17.LsMailSetOptionString(MailJob,'Export.Mail.TO',PTChar(Value));
end;

procedure TLl17MailJob.SetShowDialog(const Value: boolean);
begin
  FShowDialog := Value;
  if Value then
    cmbtls17.LsMailSetOptionString(MailJob,'Export.Mail.ShowDialog','1')
  else
    cmbtls17.LsMailSetOptionString(MailJob,'Export.Mail.ShowDialog','0');
end;

{ TLl17HelperClass }

class procedure TLl17HelperClass.FreeList(List: TList);
//var
//  eachItem : Integer;
begin
{Description: At the moment it's not necessary to destroy the items of the
TList. They are used further on.}
//  for eachItem := 0 to Pred(List.Count) do
//  begin
//    TObject(List.Items[eachItem]).Free;
//  end;
  List.Clear;
  List.Free;
end;

class function TLl17HelperClass.Split(Text: TString; Seperator: TChar;
  fTrim, Quotes: Boolean): TStringList;
var vI: Integer;
    vBuffer: TString;
    vOn: Boolean;
begin
  Result:=TStringList.Create;
  vBuffer:='';
  vOn:=true;
  for vI:=1 to Length(Text) do
  begin
    if (Quotes and (Text[vI] = Seperator) and vOn)or(Not(Quotes) and (Text[vI]=Seperator)) then
    begin
      if fTrim then vBuffer:=Trim(vBuffer);
      if vBuffer[1]=Seperator then
        vBuffer:=Copy(vBuffer,2,Length(vBuffer));
      Result.Add(vBuffer);
      vBuffer:='';
    end;
    if Quotes then
    begin
      if Text[vI]='"' then
      begin
        vOn:=Not(vOn);
        Continue;
      end;
      if (Text[vI]<>Seperator)or((Text[vI]=Seperator)and(vOn=false)) then
        vBuffer:=vBuffer+Text[vI];
    end else
      if Text[vI]<>Seperator then
        vBuffer:=vBuffer+Text[vI];
  end;
  if vBuffer<>'' then
  begin
    if fTrim then vBuffer:=Trim(vBuffer);
    Result.Add(vBuffer);
  end;
end;

class function TLl17HelperClass.PWideToString(pw : PWideChar) : AnsiString;
var
  buffer : PAnsiChar;
  iLen : integer;
begin
  iLen := lstrlenw(pw)+1;
  GetMem(buffer, iLen);
  WideCharToMultiByte(CP_ACP, 0, pw, iLen, buffer, iLen*2, nil, nil);
  Result := buffer;
  FreeMem(buffer);
end;

class procedure TLl17HelperClass.CopyToBuffer(source: TString ; dest: PTChar; maxLen: integer)  ;
begin
{$ifdef UNICODESTRING_AWARE}
  StrPCopy(dest, Copy(source,0,maxLen-1));
{$else}
  {$ifdef UNICODE}
    Move(ptCHAR(source)^, dest, maxLen-1);
  {$else}
    StrPCopy(dest, Copy(source,0,maxLen-1));
  {$endif}

{$endif}
end;


{ TDicFields }
procedure TDicFields.AddComplexItems(Value: TString);
var
  I: Integer;
begin
  for I := 0 to FLCIDList.Count - 1 do
  begin
    AddComplexItems(Value, FLCIDList[I]);
  end;
end;

procedure TDicFields.AddComplexItems(Value: TString; LCID: integer);
begin
  if  FKeyListList.Count > 0 then
  begin
    if ( (pos('@',Value) <= 0) and (pos('.',Value)>0) and (pos(':',Value) <= 0) ) then
      LlLocAddDictionaryEntry(FParentObj.hTheJob,LCID,PTChar(Value), PTChar(FParentObj.GetPairedItemDisplayString(Value, LCID)), cardinal(dtIdentifiers))
    else
    if ( (pos('@',Value) > 0) or (pos(':',Value) > 0) ) then
      LlLocAddDictionaryEntry(FParentObj.hTheJob,LCID,PTChar(Value), PTChar(FParentObj.TranslateRelationFieldName(Value, LCID)), cardinal(dtIdentifiers))
    else
      LlLocAddDictionaryEntry(FParentObj.hTheJob,LCID,PTChar(Value), PTChar(FParentObj.GetItemDisplayName(Value,dtIdentifiers, LCID)), cardinal(dtIdentifiers))
  end;
end;

{ TLl17XAction }

procedure TLl17XAction.AddAction;
var
  flags: integer;
  shiftState: TShiftState;
  key: Word;
begin

  if FInsertionType = itAppend then
    flags := $00000000
  else
    flags := $00000001;

  if FAddToToolbar then
    flags := flags or $20000000; // LLDESADDACTIONFLAG_ADD_TO_TOOLBAR

  ShortCutToKey(FShortCut, key, shiftState);
  if (ssCtrl in shiftState) then
    flags := flags or $00010000; // LLDESADDACTION_ACCEL_CONTROL

  if (ssShift in shiftState) then
    flags := flags or $00020000;

  if (ssAlt in shiftState) then
    flags := flags or $00040000;

  flags := flags or $00080000; // LLDESADDACTION_ACCEL_VIRTKEY

  flags := flags or  (FShortCut and $fff);

  FParentComponent.LlDesignerAddAction(FMenuId, flags, FMenuText, FMenuHierachy, FTooltipText, FIconId, nil);
end;

constructor TLl17XAction.Create(AOwner: TComponent);
begin
    inherited create(AOwner);
end;

destructor TLl17XAction.Destroy;
begin
  inherited destroy;
end;

procedure TLl17XAction.SetIconId(const Value: integer);
begin
  FIconId := Value;
end;

procedure TLl17XAction.SetInsertionType(const Value: TLl17XActionInsertionType);
begin
  FInsertionType := Value;
end;

procedure TLl17XAction.SetMenuHierachy(const Value: string);
begin
  FMenuHierachy := Value;
end;

procedure TLl17XAction.SetMenuId(const Value: integer);
begin
  FMenuId := Value;
end;

procedure TLl17XAction.SetMenuText(const Value: string);
begin
  FMenuText := Value;
end;

procedure TLl17XAction.SetMyParentComponent(const Value: TL17_);
begin
  FParentComponent := Value;
  FParentComponent.AddLlXActionToList(self);
end;

procedure TLl17XAction.SetOnExecuteAction(const Value: TExecuteActionEvent);
begin
  FOnExecuteAction := Value;
end;

procedure TLl17XAction.SetOnGetActionState(const Value: TGetActionStateEvent);
begin
  FOnGetActionState := Value;
end;

procedure TLl17XAction.SetShortCut(const Value: TShortCut);
begin
  FShortCut := Value;
end;

procedure TLl17XAction.SetTooltipText(const Value: string);
begin
  FTooltipText := Value;
end;

procedure TLl17XAction.SetToToolbar(const Value: boolean);
begin
  FAddToToolbar := Value;
end;

{ TDesignerWorkSpace }

constructor TDesignerWorkSpace.Create(ParentObj: TL17_);
begin
  inherited create;
  FParentObj := ParentObj;
  FProhibitedAction := TProhibitedAction.Create(FParentObj);
  FProhibitedFunction := TProhibitedFunction.Create(FParentObj);
  FReadOnlyObject := TReadOnlyObject.Create(FParentObj);
  FDesignerLanguages := TDesignerLanguages.Create(FParentObj);
end;

destructor TDesignerWorkSpace.Destroy;
begin
  FProhibitedAction.Free;
  FProhibitedFunction.Free;
  FReadOnlyObject.Free;
  FDesignerLanguages.Free;
  inherited;
end;

function TDesignerWorkSpace.GetCaption: TString;
var
  opt: TString;
begin
  FParentObj.LlDesignerGetOptionString(2, opt); //LL_DESIGNEROPTSTR_WORKSPACETITLE
  result := opt;
end;

function TDesignerWorkSpace.GetProjectName: TString;
var
  opt: TString;
begin
  FParentObj.LlDesignerGetOptionString(1, opt);  //LL_DESIGNEROPTSTR_PROJECTFILENAME
  result := opt;
end;

function TDesignerWorkSpace.InvokeAction(menuId: integer): integer;
begin
  result := FParentObj.LlDesignerInvokeAction(menuId);
end;

function TDesignerWorkSpace.Open(filename: TString; filemode: TLlDesignerWorkspaceFileMode; savemode: TLlDesignerWorkspaceSaveMode): integer;
var
  flag: Cardinal;
begin
  flag := GetEnumValue(TypeInfo(TLlDesignerWorkspaceFileMode), GetEnumName(TypeInfo(TLlDesignerWorkspaceFileMode),integer(filemode))) +
            GetEnumValue(TypeInfo(TLlDesignerWorkspaceSaveMode), GetEnumName(TypeInfo(TLlDesignerWorkspaceSaveMode),integer(savemode)));
  result := FParentObj.LlDesignerFileOpen(filename, flag);
end;

function TDesignerWorkSpace.Refresh: integer;
begin
  result :=  FParentObj.LlDesignerRefreshWorkspace();
end;

function TDesignerWorkSpace.Save: integer;
begin
  result := FParentObj.LlDesignerFileSave(0);
end;

procedure TDesignerWorkSpace.SetCaption(const Value: TString);
begin
  FParentObj.LlDesignerSetOptionString(2, Value);  //LL_DESIGNEROPTSTR_WORKSPACETITLE
end;

procedure TDesignerWorkSpace.SetProhibitedAction(
  const Value: TProhibitedAction);
begin
  FProhibitedAction := Value;
end;

procedure TDesignerWorkSpace.SetProhibitedFunction(
  const Value: TProhibitedFunction);
begin
  FProhibitedFunction := Value;
end;

procedure TDesignerWorkSpace.SetProjectName(const Value: TString);
begin
  FParentObj.LlDesignerSetOptionString(1, Value);  //LL_DESIGNEROPTSTR_PROJECTFILENAME
end;

procedure TDesignerWorkSpace.SetReadOnlyObject(const Value: TReadOnlyObject);
begin
  FReadOnlyObject := Value;
end;

{ TProhibitedAction }

procedure TProhibitedAction.Add(Value: TLlDesignerAction);
var Pos: integer;
begin
    Pos:=FProhibitedActionList.IndexOf(IntToStr(Ord(Value)));
    if Pos<>-1 then
      FProhibitedActionList.Delete(Pos);
//    FProhibitedActionList.Add(IntToStr(Ord(Value)));
    case Value of
        daFileNew: FProhibitedActionList.Add('524');
        daFileOpen: FProhibitedActionList.Add('519');
        daFileImport: FProhibitedActionList.Add('726');
        daFileSave: FProhibitedActionList.Add('514');
        daFileSaveAs: FProhibitedActionList.Add('515');
        daFilePrintSamplePrintSamplewithFrames: FProhibitedActionList.Add('513');
        daFilePrintSamplePrintSamplewithoutFrames: FProhibitedActionList.Add('546');
        daFilePrintSampleFirstPage: FProhibitedActionList.Add('549');
        daFilePrintSampleFollowingPage: FProhibitedActionList.Add('548');
        daFileExit: FProhibitedActionList.Add('511');
        daFileLRUlist: FProhibitedActionList.Add('990');

        daEditUndo: FProhibitedActionList.Add('540');
        daEditCut: FProhibitedActionList.Add('503');
        daEditCopy: FProhibitedActionList.Add('502');
        daEditPaste: FProhibitedActionList.Add('516');
        daEditDelete: FProhibitedActionList.Add('507');

        daProjectPageSetup: FProhibitedActionList.Add('512');
        daProjectInclude: FProhibitedActionList.Add('574');
        daProjectLayerDefinitions: FProhibitedActionList.Add('596');
        daProjectFilter: FProhibitedActionList.Add('573');
        daProjectSumVariables: FProhibitedActionList.Add('721');
        daProjectUserVariables: FProhibitedActionList.Add('725');
        daProjectOptions: FProhibitedActionList.Add('708');

        daObjectsSelectSelectionMode: FProhibitedActionList.Add('532');
        daObjectsSelectSelectAll: FProhibitedActionList.Add('535');
        daObjectsSelectToggleSelection: FProhibitedActionList.Add('536');
        daObjectsSelectNextObject: FProhibitedActionList.Add('537');
        daObjectsSelectPreviousObject: FProhibitedActionList.Add('538');
        daObjectsInsertText: FProhibitedActionList.Add('530');
        daObjectsInsertRectangle: FProhibitedActionList.Add('528');
        daObjectsInsertEllipse: FProhibitedActionList.Add('593');
        daObjectsInsertLine: FProhibitedActionList.Add('526');
        daObjectsInsertPicture: FProhibitedActionList.Add('527');
        daObjectsInsertBarcode: FProhibitedActionList.Add('525');
        daObjectsInsertTable: FProhibitedActionList.Add('529');
        daObjectsInsertFormattedText: FProhibitedActionList.Add('724');
        daObjectsInsertFormControl: FProhibitedActionList.Add('533');
        daObjectsInsertFormTemplate: FProhibitedActionList.Add('561');
        daObjectsInsertLLXObjects: FProhibitedActionList.Add('799');
        daObjectsInsertMultipleCopies: FProhibitedActionList.Add('723');
        daObjectsArrangeToFront: FProhibitedActionList.Add('522');
        daObjectsArrangeToBack: FProhibitedActionList.Add('520');
        daObjectsArrangeOneForward: FProhibitedActionList.Add('523');
        daObjectsArrangeOneBackward: FProhibitedActionList.Add('521');
        daObjectsArrangeAlignment: FProhibitedActionList.Add('547');
        daObjectsGroup: FProhibitedActionList.Add('703');
        daObjectsUngroup: FProhibitedActionList.Add('704');
        daObjectsAssigntoLayer: FProhibitedActionList.Add('722');
        daObjectsCopytoLayer: FProhibitedActionList.Add('719');
        daObjectsProperties: FProhibitedActionList.Add('504');
        daObjectsContents: FProhibitedActionList.Add('501');
        daObjectsFont: FProhibitedActionList.Add('729');
        daObjectsLocked: FProhibitedActionList.Add('562');
        daObjectsAppearanceCondition: FProhibitedActionList.Add('551');
        daObjectsCommonAppearanceCondition: FProhibitedActionList.Add('706');
        daObjectsName: FProhibitedActionList.Add('552');
        daObjectsObjectList: FProhibitedActionList.Add('560');
        daViewFull: FProhibitedActionList.Add('541');
        daViewTimes2: FProhibitedActionList.Add('542');
        daViewTimes4: FProhibitedActionList.Add('543');
        daViewTimes8: FProhibitedActionList.Add('544');
        daViewLayout: FProhibitedActionList.Add('733');
        daViewLayoutPreview: FProhibitedActionList.Add('734');
        daViewPreview: FProhibitedActionList.Add('735');
        daViewWindowsPreview: FProhibitedActionList.Add('104');
        daViewWindowsVariables: FProhibitedActionList.Add('103');
        daViewWindowsLayers: FProhibitedActionList.Add('107');
        daViewWindowsObjectList: FProhibitedActionList.Add('110');
        daViewWindowsPropertyWindow: FProhibitedActionList.Add('111');
        daViewWindowsTableStructure: FProhibitedActionList.Add('840');
        daViewWindowsRulers: FProhibitedActionList.Add('102');
        daViewWindowsToolbarActions: FProhibitedActionList.Add('105');
        daViewWindowsToolbarObjects: FProhibitedActionList.Add('106');
        daHelpContextSensitive: FProhibitedActionList.Add('718');
        daHelpContents: FProhibitedActionList.Add('590');
        daZoomTimes2: FProhibitedActionList.Add('842');
        daZoomRevert: FProhibitedActionList.Add('843');
        daZoomFit: FProhibitedActionList.Add('844');
    end;
end;

constructor TProhibitedAction.Create(ParentObj: TL17_);
begin
  inherited create;
  FParentObj := ParentObj;
  FProhibitedActionList := TStringList.Create();
end;

destructor TProhibitedAction.Destroy;
begin
  FProhibitedActionList.Free;
  inherited;
end;

{ TProhibitedFunction }

procedure TProhibitedFunction.Add(Value: TString);
var Pos: integer;
begin
    Pos:=FProhibitedFunctionList.IndexOf(Value);
    if Pos<>-1 then
      FProhibitedFunctionList.Delete(Pos);
    FProhibitedFunctionList.Add(Value);
end;

constructor TProhibitedFunction.Create(ParentObj: TL17_);
begin
  inherited create;
  FParentObj := ParentObj;
  FProhibitedFunctionList := TStringList.Create();
end;

destructor TProhibitedFunction.Destroy;
begin
  FProhibitedFunctionList.Free;
  inherited;
end;

{ TReadOnlyObject }

procedure TReadOnlyObject.Add(Value: TString);
var Pos: integer;
begin
    Pos:=FReadOnlyObjectList.IndexOf(Value);
    if Pos<>-1 then
      FReadOnlyObjectList.Delete(Pos);
    FReadOnlyObjectList.Add(Value);
end;

constructor TReadOnlyObject.Create(ParentObj: TL17_);
begin
  inherited create;
  FParentObj := ParentObj;
  FReadOnlyObjectList := TStringList.Create();
end;

destructor TReadOnlyObject.Destroy;
begin
  FReadOnlyObjectList.Free;
  inherited;
end;

{ TDesignerLanguages }

procedure TDesignerLanguages.Add(LCID: integer);
begin
  LlLocAddDesignLCID(FParentObj.hTheJob, LCID);
end;

procedure TDesignerLanguages.Clear;
begin
  LlLocAddDesignLCID(FParentObj.hTheJob, 0);
end;

constructor TDesignerLanguages.Create(ParentObj: TL17_);
begin
  FParentObj:=ParentObj;
end;

initialization
  GetMem(g_BufferStr, 1024 * sizeof(TChar));

finalization
  FreeMem(g_BufferStr);
  g_BufferStr := nil;
end.


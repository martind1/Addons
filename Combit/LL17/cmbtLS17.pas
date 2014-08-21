(* Pascal/Delphi constants and function definitions for LS17.DLL *)
(*  (c) 1991,..,1999,2000,..,06,... combit GmbH, Konstanz, Germany  *)
(*  [build of 2012-01-20 14:01:15] *)

unit cmbtLS17;

(* --- remarks: -----------------------------------------------------
- define USE_UNICODE_DLL to use the Unicode version of the DLL
- define UNICODE to use the Unicode functions by default
- define CMLS17_LINK_INDEXED to use the indexed import (faster)
*)

{$ifndef VER90}
{$ifndef VER100}
{$ifndef VER110}
{$ifndef VER120}
{$define ADOAVAILABLE}
{$endif}
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
{$define UNICODESTRING_AWARE}
{$define UNICODE}
{$define USE_UNICODE_DLL}
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

{$A+}

interface

uses windows
  , messages { hint: delete 'messages' for Pascal up to 7.x }
             { hint: if you get problems with 'activex' and Delphi < 3, use 'ole2' instead }
  , activex
  ;


type
{$ifdef UNICODE}
  TChar      = WChar;
  pTChar     = pWChar;
{$else}
  TChar      = char;
  pTChar     = pChar;
{$endif}
  pTRect     = ^TRECT;

(* type declarations *)

  _PCRECT                        = ^tRect;
  _PRECT                         = ^tRect;
  HLLSTG                         = lParam;
  HSTG                           = lParam;
  PHGLOBAL                       = ^tHandle;
  HLSCNVJOB                      = lParam;
  HLSMAILJOB                     = lParam;
  _LPCWORD                       = ^word;
  PSTREAM                        = ^IStream;
  _PCENHMETARECORD               = ^ENHMETARECORD;
  PPSTREAM                       = ^PSTREAM;


const
  CMBTLANG_DEFAULT            = -1;
  CMBTLANG_GERMAN             = 0;
  CMBTLANG_ENGLISH            = 1;
  CMBTLANG_ARAB               = 2;
  CMBTLANG_AFRIKAANS          = 3;
  CMBTLANG_ALBANIAN           = 4;
  CMBTLANG_BASQUE             = 5;
  CMBTLANG_BULGARIAN          = 6;
  CMBTLANG_BYELORUSSIAN       = 7;
  CMBTLANG_CATALAN            = 8;
  CMBTLANG_CHINESE            = 9;
  CMBTLANG_CROATIAN           = 10;
  CMBTLANG_CZECH              = 11;
  CMBTLANG_DANISH             = 12;
  CMBTLANG_DUTCH              = 13;
  CMBTLANG_ESTONIAN           = 14;
  CMBTLANG_FAEROESE           = 15;
  CMBTLANG_FARSI              = 16;
  CMBTLANG_FINNISH            = 17;
  CMBTLANG_FRENCH             = 18;
  CMBTLANG_GREEK              = 19;
  CMBTLANG_HEBREW             = 20;
  CMBTLANG_HUNGARIAN          = 21;
  CMBTLANG_ICELANDIC          = 22;
  CMBTLANG_INDONESIAN         = 23;
  CMBTLANG_ITALIAN            = 24;
  CMBTLANG_JAPANESE           = 25;
  CMBTLANG_KOREAN             = 26;
  CMBTLANG_LATVIAN            = 27;
  CMBTLANG_LITHUANIAN         = 28;
  CMBTLANG_NORWEGIAN          = 29;
  CMBTLANG_POLISH             = 30;
  CMBTLANG_PORTUGUESE         = 31;
  CMBTLANG_ROMANIAN           = 32;
  CMBTLANG_RUSSIAN            = 33;
  CMBTLANG_SLOVAK             = 34;
  CMBTLANG_SLOVENIAN          = 35;
  CMBTLANG_SERBIAN            = 36;
  CMBTLANG_SPANISH            = 37;
  CMBTLANG_SWEDISH            = 38;
  CMBTLANG_THAI               = 39;
  CMBTLANG_TURKISH            = 40;
  CMBTLANG_UKRAINIAN          = 41;
 CMBTLANG_CHINESE_TRADITIONAL = 48;
  LL_ERR_STG_NOSTORAGE           = -1000;
  LL_ERR_STG_BADVERSION          = -1001;
  LL_ERR_STG_READ                = -1002;
  LL_ERR_STG_WRITE               = -1003;
  LL_ERR_STG_UNKNOWNSYSTEM       = -1004;
  LL_ERR_STG_BADHANDLE           = -1005;
  LL_ERR_STG_ENDOFLIST           = -1006;
  LL_ERR_STG_BADJOB              = -1007;
  LL_ERR_STG_ACCESSDENIED        = -1008;
  LL_ERR_STG_BADSTORAGE          = -1009;
  LL_ERR_STG_CANNOTGETMETAFILE   = -1010;
  LL_ERR_STG_OUTOFMEMORY         = -1011;
  LL_ERR_STG_SEND_FAILED         = -1012;
  LL_ERR_STG_DOWNLOAD_PENDING    = -1013;
  LL_ERR_STG_DOWNLOAD_FAILED     = -1014;
  LL_ERR_STG_WRITE_FAILED        = -1015;
  LL_ERR_STG_UNEXPECTED          = -1016;
  LL_ERR_STG_CANNOTCREATEFILE    = -1017;
  LL_ERR_STG_UNKNOWN_CONVERTER   = -1018;
  LL_ERR_STG_INET_ERROR          = -1019;
  LL_WRN_STG_UNFAXED_PAGES       = -1100;
  LS_OPTION_HAS16BITPAGES        = 200;
                    (* has job 16 bit pages? *)
  LS_OPTION_BOXTYPE              = 201;
                    (* wait meter box type *)
  LS_OPTION_UNITS                = 203;
                    (* LL_UNITS_INCH_DIV_100 or LL_UNITS_MM_DIV_10 *)
  LS_OPTION_PRINTERCOUNT         = 204;
                    (* number of printers (1 or 2) *)
  LS_OPTION_ISSTORAGE            = 205;
                    (* returns whether file is STORAGE or COMPAT4 *)
  LS_OPTION_EMFRESOLUTION        = 206;
                    (* EMFRESOLUTION used to print the file *)
  LS_OPTION_JOB                  = 207;
                    (* returns current job number *)
  LS_OPTION_TOTALPAGES           = 208;
                    (* differs from GetPageCount() if print range in effect *)
  LS_OPTION_PAGESWITHFAXNUMBER   = 209;
  LS_OPTION_HASINPUTOBJECTS      = 210;
  LS_OPTION_HASFORCEDINPUTOBJECTS = 211;
  LS_OPTION_INPUTOBJECTSFINISHED = 212;
  LS_OPTION_HASHYPERLINKS        = 213;
  LS_OPTION_USED_PRINTERCOUNT    = 214;
                    (* count of printers actually used (compares DEVMODEs etc) *)
  LS_OPTION_PAGENUMBER           = 0;
                    (* page number of current page *)
  LS_OPTION_COPIES               = 1;
                    (* number of copies (same for all pages at the moment) *)
  LS_OPTION_PRN_ORIENTATION      = 2;
                    (* orientation (DMORIENT_LANDSCAPE, DMORIENT_PORTRAIT) *)
  LS_OPTION_PHYSPAGE             = 3;
                    (* is page "physical page" oriented? *)
  LS_OPTION_PRN_PIXELSOFFSET_X   = 4;
                    (* this and the following values are *)
  LS_OPTION_PRN_PIXELSOFFSET_Y   = 5;
                    (* values of the printer that the preview was *)
  LS_OPTION_PRN_PIXELS_X         = 6;
                    (* created on! *)
  LS_OPTION_PRN_PIXELS_Y         = 7;
  LS_OPTION_PRN_PIXELSPHYSICAL_X = 8;
  LS_OPTION_PRN_PIXELSPHYSICAL_Y = 9;
  LS_OPTION_PRN_PIXELSPERINCH_X  = 10;
  LS_OPTION_PRN_PIXELSPERINCH_Y  = 11;
  LS_OPTION_PRN_INDEX            = 12;
                    (* printer index of the page (0/1) *)
  LS_OPTION_PRN_PAPERTYPE        = 13;
  LS_OPTION_PRN_PAPERSIZE_X      = 14;
  LS_OPTION_PRN_PAPERSIZE_Y      = 15;
  LS_OPTION_PRN_FORCE_PAPERSIZE  = 16;
  LS_OPTION_STARTNEWSHEET        = 17;
  LS_OPTION_ISSUEINDEX           = 18;
  LS_OPTION_PROJECTNAME          = 100;
                    (* name of the original project (not page dependent) *)
  LS_OPTION_JOBNAME              = 101;
                    (* name of the job (WindowTitle of LlPrintWithBoxStart()) (not page dependent) *)
  LS_OPTION_PRTNAME              = 102;
                    (* deprecated! *)
  LS_OPTION_PRTDEVICE            = 103;
                    (* printer device ("HP Laserjet 4L") *)
  LS_OPTION_PRTPORT              = 104;
                    (* deprecated! *)
  LS_OPTION_USER                 = 105;
                    (* user string (not page dependent) *)
  LS_OPTION_CREATION             = 106;
                    (* creation date (not page dependent) *)
  LS_OPTION_CREATIONAPP          = 107;
                    (* creation application (not page dependent) *)
  LS_OPTION_CREATIONDLL          = 108;
                    (* creation DLL (not page dependent) *)
  LS_OPTION_CREATIONUSER         = 109;
                    (* creation user and computer name (not page dependent) *)
  LS_OPTION_FAXPARA_QUEUE        = 110;
                    (* NYI *)
  LS_OPTION_FAXPARA_RECIPNAME    = 111;
                    (* NYI *)
  LS_OPTION_FAXPARA_RECIPNUMBER  = 112;
                    (* NYI *)
  LS_OPTION_FAXPARA_SENDERNAME   = 113;
                    (* NYI *)
  LS_OPTION_FAXPARA_SENDERCOMPANY = 114;
                    (* NYI *)
  LS_OPTION_FAXPARA_SENDERDEPT   = 115;
                    (* NYI *)
  LS_OPTION_FAXPARA_SENDERBILLINGCODE = 116;
                    (* NYI *)
  LS_OPTION_FAX_AVAILABLEQUEUES  = 118;
                    (* NYI, nPageIndex=1 *)
  LS_OPTION_PRINTERALIASLIST     = 119;
                    (* alternative printer list (taken from project) *)
  LS_OPTION_PRTDEVMODE           = 120;
                    (* r/o, DEVMODEW structure, to be used with the LlConvertXxxx API *)
  LS_OPTION_USED_PRTDEVICE       = 121;
                    (* r/o, printer name that would actually be used *)
  LS_OPTION_USED_PRTDEVMODE      = 122;
                    (* r/o, DEVMODEW structure, to be used with the LlConvertXxxx API *)
  LS_PRINTFLAG_FIT               = $00000001;
  LS_PRINTFLAG_STACKEDCOPIES     = $00000002;
                    (* n times page1, n times page2, ... (else n times (page 1...x)) *)
  LS_PRINTFLAG_TRYPRINTERCOPIES  = $00000004;
                    (* first try printer copies, then simulated ones... *)
  LS_PRINTFLAG_SHOWDIALOG        = $00000008;
  LS_PRINTFLAG_METER             = $00000010;
  LS_PRINTFLAG_ABORTABLEMETER    = $00000020;
  LS_PRINTFLAG_METERMASK         = $00000070;
                    (* allows 7 styles of abort boxes... *)
  LS_PRINTFLAG_USEDEFPRINTERIFNULL = $00000080;
  LS_PRINTFLAG_FAX               = $00000100;
  LS_PRINTFLAG_OVERRIDEPROJECTCOPYCOUNT = $00000200;
  LS_VIEWERCONTROL_QUERY_CHARWIDTH = 1;
                    (* sent in wParam using LsGetViewerControlDefaultMessage() (return: 1 for SBCS, 2 for Unicode) *)
  LS_VIEWERCONTROL_CLEAR         = WM_USER+1;
  LS_VIEWERCONTROL_SET_HANDLE_EX = WM_USER+2;
                    (* wParam = HANDLE (NULL for RELEASE), lParam = internal struct handle; *)
  LS_VIEWERCONTROL_SET_HANDLE    = WM_USER+3;
                    (* wParam = HANDLE (NULL for RELEASE) *)
  LS_VIEWERCONTROLSETHANDLEFLAG_ADD = $0100;
  LS_VIEWERCONTROLSETHANDLEFLAG_DELETE_ON_CLOSE = $0200;
  LS_VIEWERCONTROL_GET_HANDLE    = WM_USER+4;
                    (* lParam = HANDLE (NULL for none) *)
  LS_VIEWERCONTROL_SET_FILENAME  = WM_USER+5;
                    (* lParam = LPCTSTR pszFilename (NULL for RELEASE), wParam = options *)
  LS_STGFILEOPEN_READONLY        = $00000000;
  LS_STGFILEOPEN_READWRITE       = $00000001;
  LS_STGFILEOPEN_FORCE_NO_READWRITE = $00000002;
                    (* never open read-write, even if formula elements are present! *)
  LS_STGFILEOPEN_DELETE_ON_CLOSE = $00000004;
  LS_STGFILEOPENFLAG_ADD         = $00000100;
  LS_VIEWERCONTROL_SET_OPTION    = WM_USER+6;
  LS_OPTION_MESSAGE              = 0;
                    (* communication message *)
  LS_OPTION_PRINTERASSIGNMENT    = 1;
                    (* set BEFORE setting the storage handle/filename! *)
  LS_PRNASSIGNMENT_USEDEFAULT    = $00000000;
  LS_PRNASSIGNMENT_ASKPRINTERIFNEEDED = $00000001;
  LS_PRNASSIGNMENT_ASKPRINTERALWAYS = $00000002;
  LS_PRNASSIGNMENT_ALWAYSUSEDEFAULT = $00000003;
                    (* default *)
  LS_OPTION_TOOLBAR              = 2;
                    (* TRUE to force viewer control to display a toolbar, FALSE otherwise (def: FALSE) *)
  LS_OPTION_SKETCHBAR            = 3;
                    (* TRUE to force viewer control to display a sketch bar (def: TRUE) *)
  LS_OPTION_SKETCHBARWIDTH       = 4;
                    (* TRUE to force viewer control to display a sketch bar (def: 50) *)
  LS_OPTION_TOOLBARSTYLE         = 5;
                    (* default: LS_OPTION_TOOLBARSTYLE_STANDARD, set BEFORE LS_OPTION_TOOLBAR to TRUE! *)
  LS_OPTION_TOOLBARSTYLE_STANDARD = 0;
                    (* OFFICE97 alike style *)
  LS_OPTION_TOOLBARSTYLE_OFFICEXP = 1;
                    (* DOTNET/OFFICE_XP alike style *)
  LS_OPTION_TOOLBARSTYLE_OFFICE2003 = 2;
  LS_OPTION_TOOLBARSTYLEMASK     = $0f;
  LS_OPTION_TOOLBARSTYLEFLAG_GRADIENT = $80;
                    (* starting with XP, use gradient style *)
  LS_OPTION_CODEPAGE             = 7;
                    (* lParam = codepage for MBCS aware string operations - set it if the system default is not applicable *)
  LS_OPTION_SAVEASFILEPATH       = 8;
                    (* w/o, lParam = "SaveAs" default filename (LPCTSTR!) *)
  LS_OPTION_USERDATA             = 9;
                    (* for LS_VIEWERCONTROL_SET_NTFYCALLBACK *)
  LS_OPTION_BGCOLOR              = 10;
                    (* background color *)
  LS_OPTION_ASYNC_DOWNLOAD       = 11;
                    (* download is ASYNC (def: TRUE) *)
  LS_OPTION_LANGUAGE             = 12;
                    (* CMBTLANG_xxx or -1 for ThreadLocale *)
  LS_OPTION_ASSUME_TEMPFILE      = 13;
                    (* viewer assumes that the LL file is a temp file, so data can not be saved into it *)
  LS_OPTION_IOLECLIENTSITE       = 14;
                    (* internal use *)
  LS_OPTION_TOOLTIPS             = 15;
                    (* lParam = flag value *)
  LS_OPTION_AUTOSAVE             = 16;
                    (* lParam = (BOOL)bAutoSave *)
  LS_OPTION_CHANGEDFLAG          = 17;
                    (* lParam = flag value *)
  LS_OPTION_SHOW_UNPRINTABLE_AREA = 18;
                    (* lParam = flags, default: TRUE *)
  LS_OPTION_NOUIRESET            = 19;
                    (* lParam = flags, default: TRUE *)
  LS_OPTION_NAVIGATIONBAR        = 20;
                    (* TRUE to force viewer control to display a sketch bar (def: TRUE) *)
  LS_OPTION_NAVIGATIONBARWIDTH   = 21;
                    (* TRUE to force viewer control to display a sketch bar (def: 50) *)
  LS_OPTION_IN_PREVIEWPANE       = 22;
                    (* TRUE to disable unneeded message boxes *)
  LS_OPTION_IN_LLVIEWER          = 23;
                    (* internal *)
  LS_OPTION_TABBARSTYLE          = 24;
  LS_OPTION_TABBARSTYLE_STANDARD = 0;
  LS_OPTION_TABBARSTYLE_OFFICEXP = 1;
  LS_OPTION_TABBARSTYLE_OFFICE2003 = 2;
  LS_OPTION_DESIGNERPREVIEW      = 25;
  LS_VIEWERCONTROL_GET_OPTION    = WM_USER+7;
  LS_VIEWERCONTROL_QUERY_ENDSESSION = WM_USER+8;
  LS_VIEWERCONTROL_GET_ZOOM      = WM_USER+9;
  LS_VIEWERCONTROL_SET_ZOOM      = WM_USER+10;
                    (* wParam = factor (lParam = 1 if in percent) *)
  LS_VIEWERCONTROL_GET_ZOOMED    = WM_USER+11;
                    (* TRUE if zoomed *)
  LS_VIEWERCONTROL_POP_ZOOM      = WM_USER+12;
  LS_VIEWERCONTROL_RESET_ZOOM    = WM_USER+13;
  LS_VIEWERCONTROL_SET_ZOOM_TWICE = WM_USER+14;
  LS_VIEWERCONTROL_SET_PAGE      = WM_USER+20;
                    (* wParam = page# (0..n-1) *)
  LS_VIEWERCONTROL_GET_PAGE      = WM_USER+21;
  LS_VIEWERCONTROL_GET_PAGECOUNT = WM_USER+22;
  LS_VIEWERCONTROL_GET_PAGECOUNT_FAXPAGES = WM_USER+23;
  LS_VIEWERCONTROL_GET_JOB       = WM_USER+24;
  LS_VIEWERCONTROL_GET_JOBPAGEINDEX = WM_USER+25;
  LS_VIEWERCONTROL_GET_METAFILE  = WM_USER+26;
                    (* wParam = page#, for IMMEDIATE use (will be released by LS DLL at some undefined time!) *)
  LS_VIEWERCONTROL_GET_ENABLED   = WM_USER+27;
                    (* wParam = ID *)
  LS_VCITEM_SEARCH_FIRST         = 0;
  LS_VCITEM_SEARCH_NEXT          = 1;
  LS_VCITEM_SEARCH_OPTS          = 2;
  LS_VCITEM_SEARCHFLAG_CASEINSENSITIVE = $8000;
  LS_VCITEM_SAVE_AS_FILE         = 3;
  LS_VCITEM_SEND_AS_MAIL         = 4;
  LS_VCITEM_SEND_AS_FAX          = 5;
  LS_VCITEM_PRINT_ONE            = 6;
  LS_VCITEM_PRINT_ALL            = 7;
  LS_VCITEM_PAGENUMBER           = 8;
  LS_VCITEM_ZOOM                 = 9;
  LS_VCITEM_THEATERMODE          = 10;
  LS_VCITEM_PREVSTG              = 11;
  LS_VCITEM_NEXTSTG              = 12;
  LS_VCITEM_SEARCH_DONE          = 13;
  LS_VCITEM_FIRSTPAGE            = 14;
  LS_VCITEM_NEXTPAGE             = 15;
  LS_VCITEM_PREVIOUSPAGE         = 16;
  LS_VCITEM_LASTPAGE             = 17;
  LS_VIEWERCONTROL_GET_SEARCHSTATE = WM_USER+28;
                    (* returns TRUE if search in progress *)
  LS_VIEWERCONTROL_SEARCH        = WM_USER+29;
                    (* wParam = LS_VCITEM_SEARCH_Xxxx enum, OR'ed optionally with LS_VCITEM_SEARCHFLAG_CASEINSENSITIVE, lParam=SearchText in control's charset flavour (ANSI/UNICODE) (NULL or empty to stop) *)
  LS_VIEWERCONTROL_PRINT_CURRENT = WM_USER+31;
                    (* wParam = 0 (default printer), 1 (with printer selection) *)
  LS_VIEWERCONTROL_PRINT_ALL     = WM_USER+32;
                    (* wParam = 0 (default printer), 1 (with printer selection) *)
  LS_VIEWERCONTROL_PRINT_TO_FAX  = WM_USER+33;
  LS_VIEWERCONTROL_UPDATE_TOOLBAR = WM_USER+35;
                    (* if LS_OPTION_TOOLBAR is TRUE *)
  LS_VIEWERCONTROL_GET_TOOLBAR   = WM_USER+36;
                    (* if LS_OPTION_TOOLBAR is TRUE, returns window handle of toolbar *)
  LS_VIEWERCONTROL_SAVE_TO_FILE  = WM_USER+37;
  LS_VIEWERCONTROL_SEND_AS_MAIL  = WM_USER+39;
  LS_VIEWERCONTROL_SET_OPTIONSTR = WM_USER+40;
                    (* see docs, wParam = (LPCTSTR)key, lParam = (LPCTSTR)value *)
  LS_VIEWERCONTROL_GET_OPTIONSTR = WM_USER+41;
                    (* see docs, wParam = (LPCTSTR)key, lParam = (LPCTSTR)value *)
  LS_VIEWERCONTROL_GET_OPTIONSTRLEN = WM_USER+42;
                    (* see docs, wParam = (LPCTSTR)key (returns size in TCHARs) *)
  LS_VIEWERCONTROL_SET_NTFYCALLBACK = WM_USER+43;
                    (* lParam = LRESULT ( WINAPI fn* )(UINT nMsg, LPARAM lParam, UINT nUserParameter); *)
  LS_VIEWERCONTROL_GET_NTFYCALLBACK = WM_USER+44;
                    (* LRESULT ( WINAPI fn* )(UINT nMsg, LPARAM lParam, UINT nUserParameter); *)
  LS_VIEWERCONTROL_GET_TOOLBARBUTTONSTATE = WM_USER+45;
                    (* wParam=nID -> -1=hidden, 1=enabled, 2=disabled (only when toobar present, to sync menu state) *)
  LS_VIEWERCONTROL_SET_FOCUS     = WM_USER+46;
  LS_VCSF_PREVIEW                = 1;
  LS_VCSF_SKETCHLIST             = 2;
  LS_VCSF_TOC                    = 3;
  LS_VIEWERCONTROL_ADDTOOLBARITEM = WM_USER+47;
  LS_VIEWERCONTROL_INTERNAL_CHECKERRORLIST = WM_USER+48;
  LS_VIEWERCONTROL_SET_THEATERMODE = WM_USER+49;
                    (* 0=non-theater, 1=with frame, 2=without frame *)
  LS_VIEWERCONTROL_SET_THEATERFLIPDELAY = WM_USER+50;
                    (* ms for each page *)
  LS_VIEWERCONTROL_SET_THEATERFLIPMODE = WM_USER+51;
                    (* wParam = mode *)
  LS_VCTFM_NONE                  = 0;
  LS_VCTFM_LINEAR                = 1;
                    (* lParam = (LPCTSTR)ProgID *)
  LS_VCTFM_FADE                  = 2;
  LS_VCTFM_WHEEL                 = 3;
  LS_VIEWERCONTROL_SELECT_THEATERXFORM = WM_USER+52;
  LS_VIEWERCONTROL_NTFY_PRVFSCHANGED = WM_USER+53;
                    (* wParam = ILLPreviewFileSystemChangeNotifier::enPrvFSChange.. *)
  LS_VIEWERCONTROL_SET_PROGRESSINFO = WM_USER+54;
                    (* wParam = nPercentage (-1=finished...), lParam = (LPCTSTR)sText (NULL for user-defined preview control) *)
  LS_VIEWERCONTROL_GET_FILENAME  = WM_USER+55;
                    (* lParam = LPTSTR pszFilename, wParam = sizeofTSTR(pszBuffer). Returns size needed if NULL filename *)
  LS_VIEWERCONTROL_QUERY_PRVFS_COMPLETE = WM_USER+56;
                    (* indicates whether the STGSYS file is complete (1=complete, 2=finished, but incomplete) *)
  LS_VIEWERCONTROL_ONSIZEMOVE    = WM_USER+57;
                    (* wParam = 0 (ENTER), 1 (EXIT) *)
  LS_VIEWERCONTROL_NTFY_SHOW     = WM_USER+58;
                    (* internal use *)
  LS_VIEWERCONTROL_GET_IDEVICEINFO = WM_USER+59;
                    (* internal use *)
  LS_VIEWERCONTROL_REMOVEFAILURETOOLTIPS = WM_USER+60;
                    (* internal use *)
  LS_VIEWERCONTROL_SET_LLNTFYSINK = WM_USER+61;
                    (* internal use *)
  LS_VIEWERCONTROL_OPEN_PREVSTG  = WM_USER+62;
  LS_VIEWERCONTROL_OPEN_NEXTSTG  = WM_USER+63;
  LS_VIEWERCONTROL_GET_THEATERSTATE = WM_USER+64;
                    (* returns TRUE if in theater mode *)
  LS_VIEWERCONTROL_SET_PROGRESSINFO_INTERNAL = WM_USER+65;
  LS_VIEWERCONTROL_NTFY_PAGELOADED = 1;
                    (* lParam = page# *)
  LS_VIEWERCONTROL_NTFY_UPDATETOOLBAR = 2;
                    (* called when control does NOT have an own toolbar. lParam = 1 if count of pages did change *)
  LS_VIEWERCONTROL_NTFY_PRINT_START = 3;
                    (* lParam = &scViewerControlPrintData, return 1 to abort print *)
  LS_VIEWERCONTROL_NTFY_PRINT_PAGE = 4;
                    (* lParam = &scViewerControlPrintData, return 1 to abort loop *)
  LS_VIEWERCONTROL_NTFY_PRINT_END = 5;
                    (* lParam = &scViewerControlPrintData *)
  LS_VIEWERCONTROL_NTFY_TOOLBARUPDATE = 6;
                    (* lParam = toolbar handle, called when control has an own toolbar *)
  LS_VIEWERCONTROL_NTFY_EXITBTNPRESSED = 7;
  LS_VIEWERCONTROL_NTFY_BTNPRESSED = 8;
                    (* lParam = control ID *)
  LS_VIEWERCONTROL_QUEST_BTNSTATE = 9;
                    (* lParam = control ID, -1 to hide, 1 to show, 2 to disable (0 to use default) *)
  LS_VIEWERCONTROL_NTFY_ERROR    = 10;
                    (* lParam = &scVCError. Return != 0 to suppress error mbox from control. *)
  LS_VIEWERCONTROL_NTFY_MAIL_SENT = 11;
                    (* lParam = Stream* of EML mail contents *)
  LS_VIEWERCONTROL_NTFY_DOWNLOADFINISHED = 12;
                    (* lParam = 0 (failed), 1 (ok) *)
  LS_VIEWERCONTROL_NTFY_KEYBOARDMESSAGE = 13;
                    (* lParam = const MSG*. Return TRUE if message should be taken out of the input queue *)
  LS_VIEWERCONTROL_NTFY_VIEWCHANGED = 14;
                    (* lParam = const scViewChangedInfo *)
  LS_VIEWERCONTROL_CMND_SAVEDATA = 15;
                    (* return: 0 = OK, -1 = failure, 1 = save in LL file too [event used only if AUTOSAVE is TRUE] *)
  LS_VIEWERCONTROL_NTFY_DATACHANGED = 16;
  LS_VIEWERCONTROL_NTFY_PROGRESS = 17;
                    (* lParam = percentage (-1=finished). return: 1 if internal progress bar shall be suppressed *)
  LS_VIEWERCONTROL_QUEST_SUPPORTCONTINUATION = 18;
                    (* return: 1 if continuation button () should be displayed *)
  LS_VIEWERCONTROL_CMND_CONTINUE = 19;
                    (* continue report! *)
  LS_VIEWERCONTROL_NTFY_VIEWERDRILLDOWN = 20;
                    (* lParam:  *)
  LS_VIEWERCONTROL_QUEST_DRILLDOWNSUPPORT = 21;
                    (* 1 to allow (default), 0 to deny (if provider cannot handle multiple threads or so) *)
  LS_VIEWERCONTROL_QUEST_HOST_WANTS_KEY = 22;
                    (* lParam: MSG-structure (message = WM_KEYDOWN, WM_KEYUP, WM_SYSKEYDOWN, WM_SYSKEYUP, WM_CHAR), wParam = key code, lParam = snoop (0), action (1) *)
  LS_MAILCONFIG_GLOBAL           = $0001;
  LS_MAILCONFIG_USER             = $0002;
  LS_MAILCONFIG_PROVIDER         = $0004;
  LS_DIO_CHECKBOX                = 0;
  LS_DIO_PUSHBUTTON              = 1;
  LSMAILVIEW_HTMLRIGHT_ALLOW_NONE = $0000;
  LSMAILVIEW_HTMLRIGHT_ALLOW_NEW_WINDOW = $0001;
  LSMAILVIEW_HTMLRIGHT_ALLOW_NAVIGATION = $0002;
  LSMAILVIEW_HTMLRIGHT_ALLOW_JAVA = $0004;
  LSMAILVIEW_HTMLRIGHT_ALLOW_SCRIPTING = $0008;
  LSMAILVIEW_HTMLRIGHT_ALLOW_ACTIVEX = $0010;
  LSMAILVIEW_HTMLRIGHT_ALLOW_ONLINE = $0020;
  LSMAILVIEW_HTMLRIGHT_ALLOW_BROWSERCONTEXTMENU = $0040;
  LSMAILVIEW_HTMLRIGHT_ALLOW_PRINT = $0080;
  LS_CONVERT_IS_TO_JPEGFILE      = 0;
  LS_CONVERT_IS_TO_DIBFILE       = 1;
  LS_CONVERT_IS_TO_EMRSTRETCHDIBITS = 2;
  LS_CONVERT_IS_TYPEMASK         = $0000000f;
  LS_CONVERT_IS_NOPERPIXELALPHA  = $00000010;
  LS_CONVERT_IS_SRCCOPY          = $00000020;
  LS_CONVERT_IS_NO_JPEGCONVERSION = $00000040;
                    (* for PDF Conversion (PDF export handles these itself) *)
  LS_STGPRINTEX_OPTION_FORCE_SIMPLEX = $00000001;
  LS_STGPRINTEX_OPTION_FORCE_DUPLEX_VERT = $00000002;
  LS_STGPRINTEX_OPTION_FORCE_DUPLEX_HORZ = $00000003;
  LS_STGPRINTEX_OPTIONMASK_DUPLEX = $00000003;
  LS_STGPRINTEX_OPTION_FORCE_PHYSPAGE = $00000004;
  LS_STGPRINTEX_OPTION_FORCE_LOGPAGE = $00000008;
  LS_STGPRINTEX_OPTIONMASK_PAGEAREA = $0000000C;

  {$ifdef UNICODE}
    function   LlStgsysStorageOpenA
	(lpszFilename:                   pCHAR;
	 pszTempPath:                    pCHAR;
	 bReadOnly:                      longbool;
	 bOneJobTranslation:             longbool
	): HLLSTG; stdcall;
   {$else}
    function   LlStgsysStorageOpen
	(lpszFilename:                   pCHAR;
	 pszTempPath:                    pCHAR;
	 bReadOnly:                      longbool;
	 bOneJobTranslation:             longbool
	): HLLSTG; stdcall;
  {$endif}

  {$ifdef UNICODE}
    function   LlStgsysStorageOpen
	(lpszFilename:                   pWCHAR;
	 pszTempPath:                    pWCHAR;
	 bReadOnly:                      longbool;
	 bOneJobTranslation:             longbool
	): HLLSTG; stdcall;
   {$else}
    function   LlStgsysStorageOpenW
	(lpszFilename:                   pWCHAR;
	 pszTempPath:                    pWCHAR;
	 bReadOnly:                      longbool;
	 bOneJobTranslation:             longbool
	): HLLSTG; stdcall;
  {$endif}

procedure  LlStgsysStorageClose
	(hStg:                           HLLSTG
	); stdcall;

function   LlStgsysGetAPIVersion
	(hStg:                           HLLSTG
	): integer; stdcall;

function   LlStgsysGetFileVersion
	(hStg:                           HLLSTG
	): integer; stdcall;

  {$ifdef UNICODE}
    function   LlStgsysGetFilenameA
	(hStg:                           HLLSTG;
	 nJob:                           integer;
	 nFile:                          integer;
	 pszBuffer:                      pCHAR;
	 nBufSize:                       cardinal
	): integer; stdcall;
   {$else}
    function   LlStgsysGetFilename
	(hStg:                           HLLSTG;
	 nJob:                           integer;
	 nFile:                          integer;
	 pszBuffer:                      pCHAR;
	 nBufSize:                       cardinal
	): integer; stdcall;
  {$endif}

  {$ifdef UNICODE}
    function   LlStgsysGetFilename
	(hStg:                           HLLSTG;
	 nJob:                           integer;
	 nFile:                          integer;
	 pszBuffer:                      pWCHAR;
	 nBufSize:                       cardinal
	): integer; stdcall;
   {$else}
    function   LlStgsysGetFilenameW
	(hStg:                           HLLSTG;
	 nJob:                           integer;
	 nFile:                          integer;
	 pszBuffer:                      pWCHAR;
	 nBufSize:                       cardinal
	): integer; stdcall;
  {$endif}

function   LlStgsysGetJobCount
	(hStg:                           HLLSTG
	): integer; stdcall;

function   LlStgsysSetJob
	(hStg:                           HLLSTG;
	 nJob:                           integer
	): integer; stdcall;

function   LlStgsysGetJob
	(hStg:                           HLLSTG
	): integer; stdcall;

function   LlStgsysGetPageCount
	(hStg:                           HLLSTG
	): integer; stdcall;

function   LlStgsysGetJobOptionValue
	(hStg:                           HLLSTG;
	 nOption:                        integer
	): integer; stdcall;

function   LlStgsysGetPageOptionValue
	(hStg:                           HLLSTG;
	 nPageIndex:                     integer;
	 nOption:                        integer
	): integer; stdcall;

  {$ifdef UNICODE}
    function   LlStgsysGetPageOptionStringA
	(hStg:                           HLLSTG;
	 nPageIndex:                     integer;
	 nOption:                        integer;
	 pszBuffer:                      pCHAR;
	 nBufSize:                       cardinal
	): integer; stdcall;
   {$else}
    function   LlStgsysGetPageOptionString
	(hStg:                           HLLSTG;
	 nPageIndex:                     integer;
	 nOption:                        integer;
	 pszBuffer:                      pCHAR;
	 nBufSize:                       cardinal
	): integer; stdcall;
  {$endif}

  {$ifdef UNICODE}
    function   LlStgsysGetPageOptionString
	(hStg:                           HLLSTG;
	 nPageIndex:                     integer;
	 nOption:                        integer;
	 pszBuffer:                      pWCHAR;
	 nBufSize:                       cardinal
	): integer; stdcall;
   {$else}
    function   LlStgsysGetPageOptionStringW
	(hStg:                           HLLSTG;
	 nPageIndex:                     integer;
	 nOption:                        integer;
	 pszBuffer:                      pWCHAR;
	 nBufSize:                       cardinal
	): integer; stdcall;
  {$endif}

  {$ifdef UNICODE}
    function   LlStgsysSetPageOptionStringA
	(hStg:                           HLLSTG;
	 nPageIndex:                     integer;
	 nOption:                        integer;
	 pszBuffer:                      pCHAR
	): integer; stdcall;
   {$else}
    function   LlStgsysSetPageOptionString
	(hStg:                           HLLSTG;
	 nPageIndex:                     integer;
	 nOption:                        integer;
	 pszBuffer:                      pCHAR
	): integer; stdcall;
  {$endif}

  {$ifdef UNICODE}
    function   LlStgsysSetPageOptionString
	(hStg:                           HLLSTG;
	 nPageIndex:                     integer;
	 nOption:                        integer;
	 pszBuffer:                      pWCHAR
	): integer; stdcall;
   {$else}
    function   LlStgsysSetPageOptionStringW
	(hStg:                           HLLSTG;
	 nPageIndex:                     integer;
	 nOption:                        integer;
	 pszBuffer:                      pWCHAR
	): integer; stdcall;
  {$endif}

function   LlStgsysAppend
	(hStg:                           HLLSTG;
	 hStgToAppend:                   HLLSTG
	): integer; stdcall;

function   LlStgsysDeleteJob
	(hStg:                           HLLSTG;
	 nPageIndex:                     integer
	): integer; stdcall;

function   LlStgsysDeletePage
	(hStg:                           HLLSTG;
	 nPageIndex:                     integer
	): integer; stdcall;

function   LlStgsysGetPageMetafile
	(hStg:                           HLLSTG;
	 nPageIndex:                     integer
	): tHandle; stdcall;

function   LlStgsysDestroyMetafile
	(hMF:                            tHandle
	): integer; stdcall;

function   LlStgsysDrawPage
	(hStg:                           HLLSTG;
	 hDC:                            HDC;
	 hPrnDC:                         HDC;
	 bAskPrinter:                    longbool;
	 const pRC:                      _PCRECT;
	 nPageIndex:                     integer;
	 bFit:                           longbool;
	 pReserved:                      pChar
	): integer; stdcall;

function   LlStgsysGetLastError
	(hStg:                           HLLSTG
	): integer; stdcall;

function   LlStgsysDeleteFiles
	(hStg:                           HLLSTG
	): integer; stdcall;

  {$ifdef UNICODE}
    function   LlStgsysPrintA
	(hStg:                           HLLSTG;
	 pszPrinterName1:                pCHAR;
	 pszPrinterName2:                pCHAR;
	 nStartPageIndex:                integer;
	 nEndPageIndex:                  integer;
	 nCopies:                        integer;
	 nFlags:                         cardinal;
	 pszMessage:                     pCHAR;
	 hWndParent:                     HWND
	): integer; stdcall;
   {$else}
    function   LlStgsysPrint
	(hStg:                           HLLSTG;
	 pszPrinterName1:                pCHAR;
	 pszPrinterName2:                pCHAR;
	 nStartPageIndex:                integer;
	 nEndPageIndex:                  integer;
	 nCopies:                        integer;
	 nFlags:                         cardinal;
	 pszMessage:                     pCHAR;
	 hWndParent:                     HWND
	): integer; stdcall;
  {$endif}

  {$ifdef UNICODE}
    function   LlStgsysPrint
	(hStg:                           HLLSTG;
	 pszPrinterName1:                pWCHAR;
	 pszPrinterName2:                pWCHAR;
	 nStartPageIndex:                integer;
	 nEndPageIndex:                  integer;
	 nCopies:                        integer;
	 nFlags:                         cardinal;
	 pszMessage:                     pWCHAR;
	 hWndParent:                     HWND
	): integer; stdcall;
   {$else}
    function   LlStgsysPrintW
	(hStg:                           HLLSTG;
	 pszPrinterName1:                pWCHAR;
	 pszPrinterName2:                pWCHAR;
	 nStartPageIndex:                integer;
	 nEndPageIndex:                  integer;
	 nCopies:                        integer;
	 nFlags:                         cardinal;
	 pszMessage:                     pWCHAR;
	 hWndParent:                     HWND
	): integer; stdcall;
  {$endif}

  {$ifdef UNICODE}
    function   LlStgsysStoragePrintA
	(lpszFilename:                   pCHAR;
	 pszTempPath:                    pCHAR;
	 pszPrinterName1:                pCHAR;
	 pszPrinterName2:                pCHAR;
	 nStartPageIndex:                integer;
	 nEndPageIndex:                  integer;
	 nCopies:                        integer;
	 nFlags:                         cardinal;
	 pszMessage:                     pCHAR;
	 hWndParent:                     HWND
	): integer; stdcall;
   {$else}
    function   LlStgsysStoragePrint
	(lpszFilename:                   pCHAR;
	 pszTempPath:                    pCHAR;
	 pszPrinterName1:                pCHAR;
	 pszPrinterName2:                pCHAR;
	 nStartPageIndex:                integer;
	 nEndPageIndex:                  integer;
	 nCopies:                        integer;
	 nFlags:                         cardinal;
	 pszMessage:                     pCHAR;
	 hWndParent:                     HWND
	): integer; stdcall;
  {$endif}

  {$ifdef UNICODE}
    function   LlStgsysStoragePrint
	(lpszFilename:                   pWCHAR;
	 pszTempPath:                    pWCHAR;
	 pszPrinterName1:                pWCHAR;
	 pszPrinterName2:                pWCHAR;
	 nStartPageIndex:                integer;
	 nEndPageIndex:                  integer;
	 nCopies:                        integer;
	 nFlags:                         cardinal;
	 pszMessage:                     pWCHAR;
	 hWndParent:                     HWND
	): integer; stdcall;
   {$else}
    function   LlStgsysStoragePrintW
	(lpszFilename:                   pWCHAR;
	 pszTempPath:                    pWCHAR;
	 pszPrinterName1:                pWCHAR;
	 pszPrinterName2:                pWCHAR;
	 nStartPageIndex:                integer;
	 nEndPageIndex:                  integer;
	 nCopies:                        integer;
	 nFlags:                         cardinal;
	 pszMessage:                     pWCHAR;
	 hWndParent:                     HWND
	): integer; stdcall;
  {$endif}

  {$ifdef UNICODE}
    function   LlStgsysGetPagePrinterA
	(hStg:                           HLLSTG;
	 nPageIndex:                     integer;
	 pszDeviceName:                  pCHAR;
	 nDeviceNameSize:                cardinal;
	 phDevMode:                      PHGLOBAL
	): integer; stdcall;
   {$else}
    function   LlStgsysGetPagePrinter
	(hStg:                           HLLSTG;
	 nPageIndex:                     integer;
	 pszDeviceName:                  pCHAR;
	 nDeviceNameSize:                cardinal;
	 phDevMode:                      PHGLOBAL
	): integer; stdcall;
  {$endif}

  {$ifdef UNICODE}
    function   LlStgsysGetPagePrinter
	(hStg:                           HLLSTG;
	 nPageIndex:                     integer;
	 pszDeviceName:                  pWCHAR;
	 nDeviceNameSize:                cardinal;
	 phDevMode:                      PHGLOBAL
	): integer; stdcall;
   {$else}
    function   LlStgsysGetPagePrinterW
	(hStg:                           HLLSTG;
	 nPageIndex:                     integer;
	 pszDeviceName:                  pWCHAR;
	 nDeviceNameSize:                cardinal;
	 phDevMode:                      PHGLOBAL
	): integer; stdcall;
  {$endif}

procedure  LsSetDebug
	(bOn:                            longbool
	); stdcall;

  {$ifdef UNICODE}
    function   LsGetViewerControlClassNameA : pCHAR; stdcall;
   {$else}
    function   LsGetViewerControlClassName : pCHAR; stdcall;
  {$endif}

  {$ifdef UNICODE}
    function   LsGetViewerControlClassName : pWCHAR; stdcall;
   {$else}
    function   LsGetViewerControlClassNameW : pWCHAR; stdcall;
  {$endif}

function   LsGetViewerControlDefaultMessage : cardinal; stdcall;

function   LsCreateViewerControlOverParent
	(hStg:                           HSTG;
	 hParentControl:                 HWND
	): integer; stdcall;

  {$ifdef UNICODE}
    function   LlStgsysGetJobOptionStringExA
	(hStg:                           HLLSTG;
	 pszKey:                         pCHAR;
	 pszBuffer:                      pCHAR;
	 nBufSize:                       cardinal
	): integer; stdcall;
   {$else}
    function   LlStgsysGetJobOptionStringEx
	(hStg:                           HLLSTG;
	 pszKey:                         pCHAR;
	 pszBuffer:                      pCHAR;
	 nBufSize:                       cardinal
	): integer; stdcall;
  {$endif}

  {$ifdef UNICODE}
    function   LlStgsysGetJobOptionStringEx
	(hStg:                           HLLSTG;
	 pszKey:                         pWCHAR;
	 pszBuffer:                      pWCHAR;
	 nBufSize:                       cardinal
	): integer; stdcall;
   {$else}
    function   LlStgsysGetJobOptionStringExW
	(hStg:                           HLLSTG;
	 pszKey:                         pWCHAR;
	 pszBuffer:                      pWCHAR;
	 nBufSize:                       cardinal
	): integer; stdcall;
  {$endif}

  {$ifdef UNICODE}
    function   LlStgsysSetJobOptionStringExA
	(hStg:                           HLLSTG;
	 pszKey:                         pCHAR;
	 pszBuffer:                      pCHAR
	): integer; stdcall;
   {$else}
    function   LlStgsysSetJobOptionStringEx
	(hStg:                           HLLSTG;
	 pszKey:                         pCHAR;
	 pszBuffer:                      pCHAR
	): integer; stdcall;
  {$endif}

  {$ifdef UNICODE}
    function   LlStgsysSetJobOptionStringEx
	(hStg:                           HLLSTG;
	 pszKey:                         pWCHAR;
	 pszBuffer:                      pWCHAR
	): integer; stdcall;
   {$else}
    function   LlStgsysSetJobOptionStringExW
	(hStg:                           HLLSTG;
	 pszKey:                         pWCHAR;
	 pszBuffer:                      pWCHAR
	): integer; stdcall;
  {$endif}

  {$ifdef UNICODE}
    function   LsConversionJobOpenA
	(hWndParent:                     HWND;
	 nLanguage:                      integer;
	 pszFormat:                      pCHAR
	): HLSCNVJOB; stdcall;
   {$else}
    function   LsConversionJobOpen
	(hWndParent:                     HWND;
	 nLanguage:                      integer;
	 pszFormat:                      pCHAR
	): HLSCNVJOB; stdcall;
  {$endif}

  {$ifdef UNICODE}
    function   LsConversionJobOpen
	(hWndParent:                     HWND;
	 nLanguage:                      integer;
	 pszFormat:                      pWCHAR
	): HLSCNVJOB; stdcall;
   {$else}
    function   LsConversionJobOpenW
	(hWndParent:                     HWND;
	 nLanguage:                      integer;
	 pszFormat:                      pWCHAR
	): HLSCNVJOB; stdcall;
  {$endif}

function   LsConversionJobClose
	(hCnvJob:                        HLSCNVJOB
	): integer; stdcall;

function   LsConversionConvertEMFToStream
	(hCnvJob:                        HLSCNVJOB;
	 hEMF:                           HENHMETAFILE;
	 pStream:                        PSTREAM
	): integer; stdcall;

function   LsConversionConvertStgToStream
	(hCnvJob:                        HLSCNVJOB;
	 hStg:                           HLLSTG;
	 pStream:                        PSTREAM
	): integer; stdcall;

  {$ifdef UNICODE}
    function   LsConversionPrintA
	(hCnvJob:                        HLSCNVJOB;
	 pStream:                        PSTREAM;
	 pszBufFilename:                 pCHAR;
	 nBufSize:                       cardinal
	): integer; stdcall;
   {$else}
    function   LsConversionPrint
	(hCnvJob:                        HLSCNVJOB;
	 pStream:                        PSTREAM;
	 pszBufFilename:                 pCHAR;
	 nBufSize:                       cardinal
	): integer; stdcall;
  {$endif}

  {$ifdef UNICODE}
    function   LsConversionPrint
	(hCnvJob:                        HLSCNVJOB;
	 pStream:                        PSTREAM;
	 pszBufFilename:                 pWCHAR;
	 nBufSize:                       cardinal
	): integer; stdcall;
   {$else}
    function   LsConversionPrintW
	(hCnvJob:                        HLSCNVJOB;
	 pStream:                        PSTREAM;
	 pszBufFilename:                 pWCHAR;
	 nBufSize:                       cardinal
	): integer; stdcall;
  {$endif}

function   LsConversionConfigurationDlg
	(hCnvJob:                        HLSCNVJOB;
	 hWndParent:                     HWND
	): integer; stdcall;

  {$ifdef UNICODE}
    function   LsConversionSetOptionStringA
	(hCnvJob:                        HLSCNVJOB;
	 pszKey:                         pCHAR;
	 pszData:                        pCHAR
	): integer; stdcall;
   {$else}
    function   LsConversionSetOptionString
	(hCnvJob:                        HLSCNVJOB;
	 pszKey:                         pCHAR;
	 pszData:                        pCHAR
	): integer; stdcall;
  {$endif}

  {$ifdef UNICODE}
    function   LsConversionSetOptionString
	(hCnvJob:                        HLSCNVJOB;
	 pszKey:                         pWCHAR;
	 pszData:                        pWCHAR
	): integer; stdcall;
   {$else}
    function   LsConversionSetOptionStringW
	(hCnvJob:                        HLSCNVJOB;
	 pszKey:                         pWCHAR;
	 pszData:                        pWCHAR
	): integer; stdcall;
  {$endif}

  {$ifdef UNICODE}
    function   LsConversionGetOptionStringA
	(hCnvJob:                        HLSCNVJOB;
	 pszKey:                         pCHAR;
	 pszBuffer:                      pCHAR;
	 nBufSize:                       cardinal
	): integer; stdcall;
   {$else}
    function   LsConversionGetOptionString
	(hCnvJob:                        HLSCNVJOB;
	 pszKey:                         pCHAR;
	 pszBuffer:                      pCHAR;
	 nBufSize:                       cardinal
	): integer; stdcall;
  {$endif}

  {$ifdef UNICODE}
    function   LsConversionGetOptionString
	(hCnvJob:                        HLSCNVJOB;
	 pszKey:                         pWCHAR;
	 pszBuffer:                      pWCHAR;
	 nBufSize:                       cardinal
	): integer; stdcall;
   {$else}
    function   LsConversionGetOptionStringW
	(hCnvJob:                        HLSCNVJOB;
	 pszKey:                         pWCHAR;
	 pszBuffer:                      pWCHAR;
	 nBufSize:                       cardinal
	): integer; stdcall;
  {$endif}

  {$ifdef UNICODE}
    function   LsConversionConvertEMFToFileA
	(hCnvJob:                        HLSCNVJOB;
	 hEMF:                           HENHMETAFILE;
	 pszFilename:                    pCHAR
	): integer; stdcall;
   {$else}
    function   LsConversionConvertEMFToFile
	(hCnvJob:                        HLSCNVJOB;
	 hEMF:                           HENHMETAFILE;
	 pszFilename:                    pCHAR
	): integer; stdcall;
  {$endif}

  {$ifdef UNICODE}
    function   LsConversionConvertEMFToFile
	(hCnvJob:                        HLSCNVJOB;
	 hEMF:                           HENHMETAFILE;
	 pszFilename:                    pWCHAR
	): integer; stdcall;
   {$else}
    function   LsConversionConvertEMFToFileW
	(hCnvJob:                        HLSCNVJOB;
	 hEMF:                           HENHMETAFILE;
	 pszFilename:                    pWCHAR
	): integer; stdcall;
  {$endif}

  {$ifdef UNICODE}
    function   LsConversionConvertStgToFileA
	(hCnvJob:                        HLSCNVJOB;
	 hStg:                           HLLSTG;
	 pszFilename:                    pCHAR
	): integer; stdcall;
   {$else}
    function   LsConversionConvertStgToFile
	(hCnvJob:                        HLSCNVJOB;
	 hStg:                           HLLSTG;
	 pszFilename:                    pCHAR
	): integer; stdcall;
  {$endif}

  {$ifdef UNICODE}
    function   LsConversionConvertStgToFile
	(hCnvJob:                        HLSCNVJOB;
	 hStg:                           HLLSTG;
	 pszFilename:                    pWCHAR
	): integer; stdcall;
   {$else}
    function   LsConversionConvertStgToFileW
	(hCnvJob:                        HLSCNVJOB;
	 hStg:                           HLLSTG;
	 pszFilename:                    pWCHAR
	): integer; stdcall;
  {$endif}

  {$ifdef UNICODE}
    function   LlStgsysStorageConvertA
	(pszStgFilename:                 pCHAR;
	 pszDstFilename:                 pCHAR;
	 pszFormat:                      pCHAR
	): integer; stdcall;
   {$else}
    function   LlStgsysStorageConvert
	(pszStgFilename:                 pCHAR;
	 pszDstFilename:                 pCHAR;
	 pszFormat:                      pCHAR
	): integer; stdcall;
  {$endif}

  {$ifdef UNICODE}
    function   LlStgsysStorageConvert
	(pszStgFilename:                 pWCHAR;
	 pszDstFilename:                 pWCHAR;
	 pszFormat:                      pWCHAR
	): integer; stdcall;
   {$else}
    function   LlStgsysStorageConvertW
	(pszStgFilename:                 pWCHAR;
	 pszDstFilename:                 pWCHAR;
	 pszFormat:                      pWCHAR
	): integer; stdcall;
  {$endif}

  {$ifdef UNICODE}
    function   LlStgsysConvertA
	(hStg:                           HLLSTG;
	 pszDstFilename:                 pCHAR;
	 pszFormat:                      pCHAR
	): integer; stdcall;
   {$else}
    function   LlStgsysConvert
	(hStg:                           HLLSTG;
	 pszDstFilename:                 pCHAR;
	 pszFormat:                      pCHAR
	): integer; stdcall;
  {$endif}

  {$ifdef UNICODE}
    function   LlStgsysConvert
	(hStg:                           HLLSTG;
	 pszDstFilename:                 pWCHAR;
	 pszFormat:                      pWCHAR
	): integer; stdcall;
   {$else}
    function   LlStgsysConvertW
	(hStg:                           HLLSTG;
	 pszDstFilename:                 pWCHAR;
	 pszFormat:                      pWCHAR
	): integer; stdcall;
  {$endif}

  {$ifdef UNICODE}
    function   LsMailConfigurationDialogA
	(hWndParent:                     HWND;
	 pszSubkey:                      pCHAR;
	 nFlags:                         cardinal;
	 nLanguage:                      integer
	): integer; stdcall;
   {$else}
    function   LsMailConfigurationDialog
	(hWndParent:                     HWND;
	 pszSubkey:                      pCHAR;
	 nFlags:                         cardinal;
	 nLanguage:                      integer
	): integer; stdcall;
  {$endif}

  {$ifdef UNICODE}
    function   LsMailConfigurationDialog
	(hWndParent:                     HWND;
	 pszSubkey:                      pWCHAR;
	 nFlags:                         cardinal;
	 nLanguage:                      integer
	): integer; stdcall;
   {$else}
    function   LsMailConfigurationDialogW
	(hWndParent:                     HWND;
	 pszSubkey:                      pWCHAR;
	 nFlags:                         cardinal;
	 nLanguage:                      integer
	): integer; stdcall;
  {$endif}

function   LsMailJobOpen
	(nLanguage:                      integer
	): HLSMAILJOB; stdcall;

function   LsMailJobClose
	(hJob:                           HLSMAILJOB
	): integer; stdcall;

  {$ifdef UNICODE}
    function   LsMailSetOptionStringA
	(hJob:                           HLSMAILJOB;
	 pszKey:                         pCHAR;
	 pszValue:                       pCHAR
	): integer; stdcall;
   {$else}
    function   LsMailSetOptionString
	(hJob:                           HLSMAILJOB;
	 pszKey:                         pCHAR;
	 pszValue:                       pCHAR
	): integer; stdcall;
  {$endif}

  {$ifdef UNICODE}
    function   LsMailSetOptionString
	(hJob:                           HLSMAILJOB;
	 pszKey:                         pWCHAR;
	 pszValue:                       pWCHAR
	): integer; stdcall;
   {$else}
    function   LsMailSetOptionStringW
	(hJob:                           HLSMAILJOB;
	 pszKey:                         pWCHAR;
	 pszValue:                       pWCHAR
	): integer; stdcall;
  {$endif}

  {$ifdef UNICODE}
    function   LsMailGetOptionStringA
	(hJob:                           HLSMAILJOB;
	 pszKey:                         pCHAR;
	 pszBuffer:                      pCHAR;
	 nBufSize:                       cardinal
	): integer; stdcall;
   {$else}
    function   LsMailGetOptionString
	(hJob:                           HLSMAILJOB;
	 pszKey:                         pCHAR;
	 pszBuffer:                      pCHAR;
	 nBufSize:                       cardinal
	): integer; stdcall;
  {$endif}

  {$ifdef UNICODE}
    function   LsMailGetOptionString
	(hJob:                           HLSMAILJOB;
	 pszKey:                         pWCHAR;
	 pszBuffer:                      pWCHAR;
	 nBufSize:                       cardinal
	): integer; stdcall;
   {$else}
    function   LsMailGetOptionStringW
	(hJob:                           HLSMAILJOB;
	 pszKey:                         pWCHAR;
	 pszBuffer:                      pWCHAR;
	 nBufSize:                       cardinal
	): integer; stdcall;
  {$endif}

function   LsMailSendFile
	(hJob:                           HLSMAILJOB;
	 hWndParent:                     HWND
	): integer; stdcall;

  {$ifdef UNICODE}
    function   LlStgsysStorageCreateA
	(lpszFilename:                   pCHAR;
	 pszTempPath:                    pCHAR;
	 hRefDC:                         HDC;
	 const prcArea:                  _PCRECT;
	 bPhysicalPage:                  longbool
	): HLLSTG; stdcall;
   {$else}
    function   LlStgsysStorageCreate
	(lpszFilename:                   pCHAR;
	 pszTempPath:                    pCHAR;
	 hRefDC:                         HDC;
	 const prcArea:                  _PCRECT;
	 bPhysicalPage:                  longbool
	): HLLSTG; stdcall;
  {$endif}

  {$ifdef UNICODE}
    function   LlStgsysStorageCreate
	(lpszFilename:                   pWCHAR;
	 pszTempPath:                    pWCHAR;
	 hRefDC:                         HDC;
	 const prcArea:                  _PCRECT;
	 bPhysicalPage:                  longbool
	): HLLSTG; stdcall;
   {$else}
    function   LlStgsysStorageCreateW
	(lpszFilename:                   pWCHAR;
	 pszTempPath:                    pWCHAR;
	 hRefDC:                         HDC;
	 const prcArea:                  _PCRECT;
	 bPhysicalPage:                  longbool
	): HLLSTG; stdcall;
  {$endif}

function   LlStgsysAppendEMF
	(hStg:                           HLLSTG;
	 hEMFToAppend:                   HENHMETAFILE;
	 hRefDC:                         HDC;
	 const prcArea:                  _PCRECT;
	 bPhysicalPage:                  longbool
	): integer; stdcall;

  {$ifdef UNICODE}
    function   LsProfileStartA
	(hThread:                        tHandle;
	 pszDescr:                       pCHAR;
	 pszFilename:                    pCHAR;
	 nTicksMS:                       integer
	): integer; stdcall;
   {$else}
    function   LsProfileStart
	(hThread:                        tHandle;
	 pszDescr:                       pCHAR;
	 pszFilename:                    pCHAR;
	 nTicksMS:                       integer
	): integer; stdcall;
  {$endif}

  {$ifdef UNICODE}
    function   LsProfileStart
	(hThread:                        tHandle;
	 pszDescr:                       pWCHAR;
	 pszFilename:                    pWCHAR;
	 nTicksMS:                       integer
	): integer; stdcall;
   {$else}
    function   LsProfileStartW
	(hThread:                        tHandle;
	 pszDescr:                       pWCHAR;
	 pszFilename:                    pWCHAR;
	 nTicksMS:                       integer
	): integer; stdcall;
  {$endif}

procedure  LsProfileEnd
	(hThread:                        tHandle
	); stdcall;

  {$ifdef UNICODE}
    function   LsMailViewA
	(hWndParent:                     HWND;
	 pszMailFile:                    pCHAR;
	 nRights:                        cardinal;
	 nLanguage:                      integer
	): integer; stdcall;
   {$else}
    function   LsMailView
	(hWndParent:                     HWND;
	 pszMailFile:                    pCHAR;
	 nRights:                        cardinal;
	 nLanguage:                      integer
	): integer; stdcall;
  {$endif}

  {$ifdef UNICODE}
    function   LsMailView
	(hWndParent:                     HWND;
	 pszMailFile:                    pWCHAR;
	 nRights:                        cardinal;
	 nLanguage:                      integer
	): integer; stdcall;
   {$else}
    function   LsMailViewW
	(hWndParent:                     HWND;
	 pszMailFile:                    pWCHAR;
	 nRights:                        cardinal;
	 nLanguage:                      integer
	): integer; stdcall;
  {$endif}

function   LsInternalCreateViewerControlOverParent13
	(hParentControl:                 HWND;
	 nFlags:                         cardinal
	): integer; stdcall;

function   LsInternalGetViewerControlFromParent13
	(hParentControl:                 HWND
	): HWND; stdcall;

procedure  LsSetDlgboxMode
	(nMode:                          cardinal
	); stdcall;

function   LsGetDlgboxMode : cardinal; stdcall;

function   LsGetViewerControlClassNameEx : pWCHAR; stdcall;

function   LsGetDebug : longbool; stdcall;

function   LsConvertImageStream
	(pGDICommentData:                pChar;
	 hGlobal:                        PHGLOBAL;
	 nOptions:                       cardinal
	): integer; stdcall;

function   LlStgsysStoragePrintExW
	(pszStgFileName:                 pWCHAR;
	 pszPrinter:                     pWCHAR;
	 nOptions:                       cardinal;
	 nUserParam:                     lParam;
	 pfnCallback:                    pChar
	): integer; stdcall;

function   LsProcessEnhMetaFileRecord
	(hDC:                            HDC;
	 const pEMR:                     _PCENHMETARECORD
	): longbool; stdcall;

function   LlStgsysGetPageData
	(hStg:                           HLLSTG;
	 nPageIndex:                     integer;
	 ppStream:                       PPSTREAM;
	 ppStreamTOC:                    PPSTREAM;
	 ppStreamIDX:                    PPSTREAM
	): longbool; stdcall;


implementation

  {$ifdef WIN64}
    const LibNameLS17DLL = 'CXLS17.DLL';
   {$else}
    const LibNameLS17DLL = 'CMLS17.DLL';
  {$endif}

  {$ifdef UNICODE}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LlStgsysStorageOpenA;           external LibNameLS17DLL index 1;
     {$else}
      function   LlStgsysStorageOpenA;           external LibNameLS17DLL name 'LlStgsysStorageOpenA';
    {$endif}
  {$else}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LlStgsysStorageOpen;            external LibNameLS17DLL index 1;
     {$else}
      function   LlStgsysStorageOpen;            external LibNameLS17DLL name 'LlStgsysStorageOpenA';
    {$endif}
  {$endif}
  {$ifdef UNICODE}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LlStgsysStorageOpen;            external LibNameLS17DLL index 2;
     {$else}
      function   LlStgsysStorageOpen;            external LibNameLS17DLL name 'LlStgsysStorageOpenW';
    {$endif}
  {$else}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LlStgsysStorageOpenW;           external LibNameLS17DLL index 2;
     {$else}
      function   LlStgsysStorageOpenW;           external LibNameLS17DLL name 'LlStgsysStorageOpenW';
    {$endif}
  {$endif}
  {$ifdef CMLS17_LINK_INDEXED}
    procedure  LlStgsysStorageClose;           external LibNameLS17DLL index 3;
   {$else}
    procedure  LlStgsysStorageClose;           external LibNameLS17DLL name 'LlStgsysStorageClose';
  {$endif}
  {$ifdef CMLS17_LINK_INDEXED}
    function   LlStgsysGetAPIVersion;          external LibNameLS17DLL index 4;
   {$else}
    function   LlStgsysGetAPIVersion;          external LibNameLS17DLL name 'LlStgsysGetAPIVersion';
  {$endif}
  {$ifdef CMLS17_LINK_INDEXED}
    function   LlStgsysGetFileVersion;         external LibNameLS17DLL index 5;
   {$else}
    function   LlStgsysGetFileVersion;         external LibNameLS17DLL name 'LlStgsysGetFileVersion';
  {$endif}
  {$ifdef UNICODE}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LlStgsysGetFilenameA;           external LibNameLS17DLL index 6;
     {$else}
      function   LlStgsysGetFilenameA;           external LibNameLS17DLL name 'LlStgsysGetFilenameA';
    {$endif}
  {$else}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LlStgsysGetFilename;            external LibNameLS17DLL index 6;
     {$else}
      function   LlStgsysGetFilename;            external LibNameLS17DLL name 'LlStgsysGetFilenameA';
    {$endif}
  {$endif}
  {$ifdef UNICODE}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LlStgsysGetFilename;            external LibNameLS17DLL index 7;
     {$else}
      function   LlStgsysGetFilename;            external LibNameLS17DLL name 'LlStgsysGetFilenameW';
    {$endif}
  {$else}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LlStgsysGetFilenameW;           external LibNameLS17DLL index 7;
     {$else}
      function   LlStgsysGetFilenameW;           external LibNameLS17DLL name 'LlStgsysGetFilenameW';
    {$endif}
  {$endif}
  {$ifdef CMLS17_LINK_INDEXED}
    function   LlStgsysGetJobCount;            external LibNameLS17DLL index 8;
   {$else}
    function   LlStgsysGetJobCount;            external LibNameLS17DLL name 'LlStgsysGetJobCount';
  {$endif}
  {$ifdef CMLS17_LINK_INDEXED}
    function   LlStgsysSetJob;                 external LibNameLS17DLL index 9;
   {$else}
    function   LlStgsysSetJob;                 external LibNameLS17DLL name 'LlStgsysSetJob';
  {$endif}
  {$ifdef CMLS17_LINK_INDEXED}
    function   LlStgsysGetJob;                 external LibNameLS17DLL index 37;
   {$else}
    function   LlStgsysGetJob;                 external LibNameLS17DLL name 'LlStgsysGetJob';
  {$endif}
  {$ifdef CMLS17_LINK_INDEXED}
    function   LlStgsysGetPageCount;           external LibNameLS17DLL index 10;
   {$else}
    function   LlStgsysGetPageCount;           external LibNameLS17DLL name 'LlStgsysGetPageCount';
  {$endif}
  {$ifdef CMLS17_LINK_INDEXED}
    function   LlStgsysGetJobOptionValue;      external LibNameLS17DLL index 11;
   {$else}
    function   LlStgsysGetJobOptionValue;      external LibNameLS17DLL name 'LlStgsysGetJobOptionValue';
  {$endif}
  {$ifdef CMLS17_LINK_INDEXED}
    function   LlStgsysGetPageOptionValue;     external LibNameLS17DLL index 12;
   {$else}
    function   LlStgsysGetPageOptionValue;     external LibNameLS17DLL name 'LlStgsysGetPageOptionValue';
  {$endif}
  {$ifdef UNICODE}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LlStgsysGetPageOptionStringA;   external LibNameLS17DLL index 13;
     {$else}
      function   LlStgsysGetPageOptionStringA;   external LibNameLS17DLL name 'LlStgsysGetPageOptionStringA';
    {$endif}
  {$else}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LlStgsysGetPageOptionString;    external LibNameLS17DLL index 13;
     {$else}
      function   LlStgsysGetPageOptionString;    external LibNameLS17DLL name 'LlStgsysGetPageOptionStringA';
    {$endif}
  {$endif}
  {$ifdef UNICODE}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LlStgsysGetPageOptionString;    external LibNameLS17DLL index 14;
     {$else}
      function   LlStgsysGetPageOptionString;    external LibNameLS17DLL name 'LlStgsysGetPageOptionStringW';
    {$endif}
  {$else}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LlStgsysGetPageOptionStringW;   external LibNameLS17DLL index 14;
     {$else}
      function   LlStgsysGetPageOptionStringW;   external LibNameLS17DLL name 'LlStgsysGetPageOptionStringW';
    {$endif}
  {$endif}
  {$ifdef UNICODE}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LlStgsysSetPageOptionStringA;   external LibNameLS17DLL index 15;
     {$else}
      function   LlStgsysSetPageOptionStringA;   external LibNameLS17DLL name 'LlStgsysSetPageOptionStringA';
    {$endif}
  {$else}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LlStgsysSetPageOptionString;    external LibNameLS17DLL index 15;
     {$else}
      function   LlStgsysSetPageOptionString;    external LibNameLS17DLL name 'LlStgsysSetPageOptionStringA';
    {$endif}
  {$endif}
  {$ifdef UNICODE}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LlStgsysSetPageOptionString;    external LibNameLS17DLL index 16;
     {$else}
      function   LlStgsysSetPageOptionString;    external LibNameLS17DLL name 'LlStgsysSetPageOptionStringW';
    {$endif}
  {$else}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LlStgsysSetPageOptionStringW;   external LibNameLS17DLL index 16;
     {$else}
      function   LlStgsysSetPageOptionStringW;   external LibNameLS17DLL name 'LlStgsysSetPageOptionStringW';
    {$endif}
  {$endif}
  {$ifdef CMLS17_LINK_INDEXED}
    function   LlStgsysAppend;                 external LibNameLS17DLL index 17;
   {$else}
    function   LlStgsysAppend;                 external LibNameLS17DLL name 'LlStgsysAppend';
  {$endif}
  {$ifdef CMLS17_LINK_INDEXED}
    function   LlStgsysDeleteJob;              external LibNameLS17DLL index 18;
   {$else}
    function   LlStgsysDeleteJob;              external LibNameLS17DLL name 'LlStgsysDeleteJob';
  {$endif}
  {$ifdef CMLS17_LINK_INDEXED}
    function   LlStgsysDeletePage;             external LibNameLS17DLL index 19;
   {$else}
    function   LlStgsysDeletePage;             external LibNameLS17DLL name 'LlStgsysDeletePage';
  {$endif}
  {$ifdef CMLS17_LINK_INDEXED}
    function   LlStgsysGetPageMetafile;        external LibNameLS17DLL index 20;
   {$else}
    function   LlStgsysGetPageMetafile;        external LibNameLS17DLL name 'LlStgsysGetPageMetafile';
  {$endif}
  {$ifdef CMLS17_LINK_INDEXED}
    function   LlStgsysDestroyMetafile;        external LibNameLS17DLL index 22;
   {$else}
    function   LlStgsysDestroyMetafile;        external LibNameLS17DLL name 'LlStgsysDestroyMetafile';
  {$endif}
  {$ifdef CMLS17_LINK_INDEXED}
    function   LlStgsysDrawPage;               external LibNameLS17DLL index 23;
   {$else}
    function   LlStgsysDrawPage;               external LibNameLS17DLL name 'LlStgsysDrawPage';
  {$endif}
  {$ifdef CMLS17_LINK_INDEXED}
    function   LlStgsysGetLastError;           external LibNameLS17DLL index 24;
   {$else}
    function   LlStgsysGetLastError;           external LibNameLS17DLL name 'LlStgsysGetLastError';
  {$endif}
  {$ifdef CMLS17_LINK_INDEXED}
    function   LlStgsysDeleteFiles;            external LibNameLS17DLL index 25;
   {$else}
    function   LlStgsysDeleteFiles;            external LibNameLS17DLL name 'LlStgsysDeleteFiles';
  {$endif}
  {$ifdef UNICODE}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LlStgsysPrintA;                 external LibNameLS17DLL index 26;
     {$else}
      function   LlStgsysPrintA;                 external LibNameLS17DLL name 'LlStgsysPrintA';
    {$endif}
  {$else}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LlStgsysPrint;                  external LibNameLS17DLL index 26;
     {$else}
      function   LlStgsysPrint;                  external LibNameLS17DLL name 'LlStgsysPrintA';
    {$endif}
  {$endif}
  {$ifdef UNICODE}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LlStgsysPrint;                  external LibNameLS17DLL index 27;
     {$else}
      function   LlStgsysPrint;                  external LibNameLS17DLL name 'LlStgsysPrintW';
    {$endif}
  {$else}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LlStgsysPrintW;                 external LibNameLS17DLL index 27;
     {$else}
      function   LlStgsysPrintW;                 external LibNameLS17DLL name 'LlStgsysPrintW';
    {$endif}
  {$endif}
  {$ifdef UNICODE}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LlStgsysStoragePrintA;          external LibNameLS17DLL index 28;
     {$else}
      function   LlStgsysStoragePrintA;          external LibNameLS17DLL name 'LlStgsysStoragePrintA';
    {$endif}
  {$else}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LlStgsysStoragePrint;           external LibNameLS17DLL index 28;
     {$else}
      function   LlStgsysStoragePrint;           external LibNameLS17DLL name 'LlStgsysStoragePrintA';
    {$endif}
  {$endif}
  {$ifdef UNICODE}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LlStgsysStoragePrint;           external LibNameLS17DLL index 29;
     {$else}
      function   LlStgsysStoragePrint;           external LibNameLS17DLL name 'LlStgsysStoragePrintW';
    {$endif}
  {$else}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LlStgsysStoragePrintW;          external LibNameLS17DLL index 29;
     {$else}
      function   LlStgsysStoragePrintW;          external LibNameLS17DLL name 'LlStgsysStoragePrintW';
    {$endif}
  {$endif}
  {$ifdef UNICODE}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LlStgsysGetPagePrinterA;        external LibNameLS17DLL index 30;
     {$else}
      function   LlStgsysGetPagePrinterA;        external LibNameLS17DLL name 'LlStgsysGetPagePrinterA';
    {$endif}
  {$else}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LlStgsysGetPagePrinter;         external LibNameLS17DLL index 30;
     {$else}
      function   LlStgsysGetPagePrinter;         external LibNameLS17DLL name 'LlStgsysGetPagePrinterA';
    {$endif}
  {$endif}
  {$ifdef UNICODE}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LlStgsysGetPagePrinter;         external LibNameLS17DLL index 31;
     {$else}
      function   LlStgsysGetPagePrinter;         external LibNameLS17DLL name 'LlStgsysGetPagePrinterW';
    {$endif}
  {$else}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LlStgsysGetPagePrinterW;        external LibNameLS17DLL index 31;
     {$else}
      function   LlStgsysGetPagePrinterW;        external LibNameLS17DLL name 'LlStgsysGetPagePrinterW';
    {$endif}
  {$endif}
  {$ifdef CMLS17_LINK_INDEXED}
    procedure  LsSetDebug;                     external LibNameLS17DLL index 32;
   {$else}
    procedure  LsSetDebug;                     external LibNameLS17DLL name 'LsSetDebug';
  {$endif}
  {$ifdef UNICODE}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LsGetViewerControlClassNameA;   external LibNameLS17DLL index 33;
     {$else}
      function   LsGetViewerControlClassNameA;   external LibNameLS17DLL name 'LsGetViewerControlClassNameA';
    {$endif}
  {$else}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LsGetViewerControlClassName;    external LibNameLS17DLL index 33;
     {$else}
      function   LsGetViewerControlClassName;    external LibNameLS17DLL name 'LsGetViewerControlClassNameA';
    {$endif}
  {$endif}
  {$ifdef UNICODE}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LsGetViewerControlClassName;    external LibNameLS17DLL index 34;
     {$else}
      function   LsGetViewerControlClassName;    external LibNameLS17DLL name 'LsGetViewerControlClassNameW';
    {$endif}
  {$else}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LsGetViewerControlClassNameW;   external LibNameLS17DLL index 34;
     {$else}
      function   LsGetViewerControlClassNameW;   external LibNameLS17DLL name 'LsGetViewerControlClassNameW';
    {$endif}
  {$endif}
  {$ifdef CMLS17_LINK_INDEXED}
    function   LsGetViewerControlDefaultMessage;   external LibNameLS17DLL index 35;
   {$else}
    function   LsGetViewerControlDefaultMessage;   external LibNameLS17DLL name 'LsGetViewerControlDefaultMessage';
  {$endif}
  {$ifdef CMLS17_LINK_INDEXED}
    function   LsCreateViewerControlOverParent;  external LibNameLS17DLL index 36;
   {$else}
    function   LsCreateViewerControlOverParent;  external LibNameLS17DLL name 'LsCreateViewerControlOverParent';
  {$endif}
  {$ifdef UNICODE}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LlStgsysGetJobOptionStringExA;  external LibNameLS17DLL index 41;
     {$else}
      function   LlStgsysGetJobOptionStringExA;  external LibNameLS17DLL name 'LlStgsysGetJobOptionStringExA';
    {$endif}
  {$else}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LlStgsysGetJobOptionStringEx;   external LibNameLS17DLL index 41;
     {$else}
      function   LlStgsysGetJobOptionStringEx;   external LibNameLS17DLL name 'LlStgsysGetJobOptionStringExA';
    {$endif}
  {$endif}
  {$ifdef UNICODE}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LlStgsysGetJobOptionStringEx;   external LibNameLS17DLL index 42;
     {$else}
      function   LlStgsysGetJobOptionStringEx;   external LibNameLS17DLL name 'LlStgsysGetJobOptionStringExW';
    {$endif}
  {$else}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LlStgsysGetJobOptionStringExW;  external LibNameLS17DLL index 42;
     {$else}
      function   LlStgsysGetJobOptionStringExW;  external LibNameLS17DLL name 'LlStgsysGetJobOptionStringExW';
    {$endif}
  {$endif}
  {$ifdef UNICODE}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LlStgsysSetJobOptionStringExA;  external LibNameLS17DLL index 43;
     {$else}
      function   LlStgsysSetJobOptionStringExA;  external LibNameLS17DLL name 'LlStgsysSetJobOptionStringExA';
    {$endif}
  {$else}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LlStgsysSetJobOptionStringEx;   external LibNameLS17DLL index 43;
     {$else}
      function   LlStgsysSetJobOptionStringEx;   external LibNameLS17DLL name 'LlStgsysSetJobOptionStringExA';
    {$endif}
  {$endif}
  {$ifdef UNICODE}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LlStgsysSetJobOptionStringEx;   external LibNameLS17DLL index 44;
     {$else}
      function   LlStgsysSetJobOptionStringEx;   external LibNameLS17DLL name 'LlStgsysSetJobOptionStringExW';
    {$endif}
  {$else}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LlStgsysSetJobOptionStringExW;  external LibNameLS17DLL index 44;
     {$else}
      function   LlStgsysSetJobOptionStringExW;  external LibNameLS17DLL name 'LlStgsysSetJobOptionStringExW';
    {$endif}
  {$endif}
  {$ifdef UNICODE}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LsConversionJobOpenA;           external LibNameLS17DLL index 45;
     {$else}
      function   LsConversionJobOpenA;           external LibNameLS17DLL name 'LsConversionJobOpenA';
    {$endif}
  {$else}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LsConversionJobOpen;            external LibNameLS17DLL index 45;
     {$else}
      function   LsConversionJobOpen;            external LibNameLS17DLL name 'LsConversionJobOpenA';
    {$endif}
  {$endif}
  {$ifdef UNICODE}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LsConversionJobOpen;            external LibNameLS17DLL index 46;
     {$else}
      function   LsConversionJobOpen;            external LibNameLS17DLL name 'LsConversionJobOpenW';
    {$endif}
  {$else}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LsConversionJobOpenW;           external LibNameLS17DLL index 46;
     {$else}
      function   LsConversionJobOpenW;           external LibNameLS17DLL name 'LsConversionJobOpenW';
    {$endif}
  {$endif}
  {$ifdef CMLS17_LINK_INDEXED}
    function   LsConversionJobClose;           external LibNameLS17DLL index 47;
   {$else}
    function   LsConversionJobClose;           external LibNameLS17DLL name 'LsConversionJobClose';
  {$endif}
  {$ifdef CMLS17_LINK_INDEXED}
    function   LsConversionConvertEMFToStream; external LibNameLS17DLL index 48;
   {$else}
    function   LsConversionConvertEMFToStream; external LibNameLS17DLL name 'LsConversionConvertEMFToStream';
  {$endif}
  {$ifdef CMLS17_LINK_INDEXED}
    function   LsConversionConvertStgToStream; external LibNameLS17DLL index 49;
   {$else}
    function   LsConversionConvertStgToStream; external LibNameLS17DLL name 'LsConversionConvertStgToStream';
  {$endif}
  {$ifdef UNICODE}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LsConversionPrintA;             external LibNameLS17DLL index 50;
     {$else}
      function   LsConversionPrintA;             external LibNameLS17DLL name 'LsConversionPrintA';
    {$endif}
  {$else}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LsConversionPrint;              external LibNameLS17DLL index 50;
     {$else}
      function   LsConversionPrint;              external LibNameLS17DLL name 'LsConversionPrintA';
    {$endif}
  {$endif}
  {$ifdef UNICODE}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LsConversionPrint;              external LibNameLS17DLL index 51;
     {$else}
      function   LsConversionPrint;              external LibNameLS17DLL name 'LsConversionPrintW';
    {$endif}
  {$else}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LsConversionPrintW;             external LibNameLS17DLL index 51;
     {$else}
      function   LsConversionPrintW;             external LibNameLS17DLL name 'LsConversionPrintW';
    {$endif}
  {$endif}
  {$ifdef CMLS17_LINK_INDEXED}
    function   LsConversionConfigurationDlg;   external LibNameLS17DLL index 52;
   {$else}
    function   LsConversionConfigurationDlg;   external LibNameLS17DLL name 'LsConversionConfigurationDlg';
  {$endif}
  {$ifdef UNICODE}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LsConversionSetOptionStringA;   external LibNameLS17DLL index 53;
     {$else}
      function   LsConversionSetOptionStringA;   external LibNameLS17DLL name 'LsConversionSetOptionStringA';
    {$endif}
  {$else}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LsConversionSetOptionString;    external LibNameLS17DLL index 53;
     {$else}
      function   LsConversionSetOptionString;    external LibNameLS17DLL name 'LsConversionSetOptionStringA';
    {$endif}
  {$endif}
  {$ifdef UNICODE}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LsConversionSetOptionString;    external LibNameLS17DLL index 54;
     {$else}
      function   LsConversionSetOptionString;    external LibNameLS17DLL name 'LsConversionSetOptionStringW';
    {$endif}
  {$else}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LsConversionSetOptionStringW;   external LibNameLS17DLL index 54;
     {$else}
      function   LsConversionSetOptionStringW;   external LibNameLS17DLL name 'LsConversionSetOptionStringW';
    {$endif}
  {$endif}
  {$ifdef UNICODE}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LsConversionGetOptionStringA;   external LibNameLS17DLL index 55;
     {$else}
      function   LsConversionGetOptionStringA;   external LibNameLS17DLL name 'LsConversionGetOptionStringA';
    {$endif}
  {$else}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LsConversionGetOptionString;    external LibNameLS17DLL index 55;
     {$else}
      function   LsConversionGetOptionString;    external LibNameLS17DLL name 'LsConversionGetOptionStringA';
    {$endif}
  {$endif}
  {$ifdef UNICODE}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LsConversionGetOptionString;    external LibNameLS17DLL index 56;
     {$else}
      function   LsConversionGetOptionString;    external LibNameLS17DLL name 'LsConversionGetOptionStringW';
    {$endif}
  {$else}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LsConversionGetOptionStringW;   external LibNameLS17DLL index 56;
     {$else}
      function   LsConversionGetOptionStringW;   external LibNameLS17DLL name 'LsConversionGetOptionStringW';
    {$endif}
  {$endif}
  {$ifdef UNICODE}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LsConversionConvertEMFToFileA;  external LibNameLS17DLL index 57;
     {$else}
      function   LsConversionConvertEMFToFileA;  external LibNameLS17DLL name 'LsConversionConvertEMFToFileA';
    {$endif}
  {$else}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LsConversionConvertEMFToFile;   external LibNameLS17DLL index 57;
     {$else}
      function   LsConversionConvertEMFToFile;   external LibNameLS17DLL name 'LsConversionConvertEMFToFileA';
    {$endif}
  {$endif}
  {$ifdef UNICODE}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LsConversionConvertEMFToFile;   external LibNameLS17DLL index 58;
     {$else}
      function   LsConversionConvertEMFToFile;   external LibNameLS17DLL name 'LsConversionConvertEMFToFileW';
    {$endif}
  {$else}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LsConversionConvertEMFToFileW;  external LibNameLS17DLL index 58;
     {$else}
      function   LsConversionConvertEMFToFileW;  external LibNameLS17DLL name 'LsConversionConvertEMFToFileW';
    {$endif}
  {$endif}
  {$ifdef UNICODE}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LsConversionConvertStgToFileA;  external LibNameLS17DLL index 59;
     {$else}
      function   LsConversionConvertStgToFileA;  external LibNameLS17DLL name 'LsConversionConvertStgToFileA';
    {$endif}
  {$else}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LsConversionConvertStgToFile;   external LibNameLS17DLL index 59;
     {$else}
      function   LsConversionConvertStgToFile;   external LibNameLS17DLL name 'LsConversionConvertStgToFileA';
    {$endif}
  {$endif}
  {$ifdef UNICODE}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LsConversionConvertStgToFile;   external LibNameLS17DLL index 60;
     {$else}
      function   LsConversionConvertStgToFile;   external LibNameLS17DLL name 'LsConversionConvertStgToFileW';
    {$endif}
  {$else}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LsConversionConvertStgToFileW;  external LibNameLS17DLL index 60;
     {$else}
      function   LsConversionConvertStgToFileW;  external LibNameLS17DLL name 'LsConversionConvertStgToFileW';
    {$endif}
  {$endif}
  {$ifdef UNICODE}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LlStgsysStorageConvertA;        external LibNameLS17DLL index 70;
     {$else}
      function   LlStgsysStorageConvertA;        external LibNameLS17DLL name 'LlStgsysStorageConvertA';
    {$endif}
  {$else}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LlStgsysStorageConvert;         external LibNameLS17DLL index 70;
     {$else}
      function   LlStgsysStorageConvert;         external LibNameLS17DLL name 'LlStgsysStorageConvertA';
    {$endif}
  {$endif}
  {$ifdef UNICODE}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LlStgsysStorageConvert;         external LibNameLS17DLL index 71;
     {$else}
      function   LlStgsysStorageConvert;         external LibNameLS17DLL name 'LlStgsysStorageConvertW';
    {$endif}
  {$else}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LlStgsysStorageConvertW;        external LibNameLS17DLL index 71;
     {$else}
      function   LlStgsysStorageConvertW;        external LibNameLS17DLL name 'LlStgsysStorageConvertW';
    {$endif}
  {$endif}
  {$ifdef UNICODE}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LlStgsysConvertA;               external LibNameLS17DLL index 72;
     {$else}
      function   LlStgsysConvertA;               external LibNameLS17DLL name 'LlStgsysConvertA';
    {$endif}
  {$else}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LlStgsysConvert;                external LibNameLS17DLL index 72;
     {$else}
      function   LlStgsysConvert;                external LibNameLS17DLL name 'LlStgsysConvertA';
    {$endif}
  {$endif}
  {$ifdef UNICODE}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LlStgsysConvert;                external LibNameLS17DLL index 73;
     {$else}
      function   LlStgsysConvert;                external LibNameLS17DLL name 'LlStgsysConvertW';
    {$endif}
  {$else}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LlStgsysConvertW;               external LibNameLS17DLL index 73;
     {$else}
      function   LlStgsysConvertW;               external LibNameLS17DLL name 'LlStgsysConvertW';
    {$endif}
  {$endif}
  {$ifdef UNICODE}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LsMailConfigurationDialogA;     external LibNameLS17DLL index 61;
     {$else}
      function   LsMailConfigurationDialogA;     external LibNameLS17DLL name 'LsMailConfigurationDialogA';
    {$endif}
  {$else}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LsMailConfigurationDialog;      external LibNameLS17DLL index 61;
     {$else}
      function   LsMailConfigurationDialog;      external LibNameLS17DLL name 'LsMailConfigurationDialogA';
    {$endif}
  {$endif}
  {$ifdef UNICODE}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LsMailConfigurationDialog;      external LibNameLS17DLL index 62;
     {$else}
      function   LsMailConfigurationDialog;      external LibNameLS17DLL name 'LsMailConfigurationDialogW';
    {$endif}
  {$else}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LsMailConfigurationDialogW;     external LibNameLS17DLL index 62;
     {$else}
      function   LsMailConfigurationDialogW;     external LibNameLS17DLL name 'LsMailConfigurationDialogW';
    {$endif}
  {$endif}
  {$ifdef CMLS17_LINK_INDEXED}
    function   LsMailJobOpen;                  external LibNameLS17DLL index 63;
   {$else}
    function   LsMailJobOpen;                  external LibNameLS17DLL name 'LsMailJobOpen';
  {$endif}
  {$ifdef CMLS17_LINK_INDEXED}
    function   LsMailJobClose;                 external LibNameLS17DLL index 64;
   {$else}
    function   LsMailJobClose;                 external LibNameLS17DLL name 'LsMailJobClose';
  {$endif}
  {$ifdef UNICODE}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LsMailSetOptionStringA;         external LibNameLS17DLL index 65;
     {$else}
      function   LsMailSetOptionStringA;         external LibNameLS17DLL name 'LsMailSetOptionStringA';
    {$endif}
  {$else}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LsMailSetOptionString;          external LibNameLS17DLL index 65;
     {$else}
      function   LsMailSetOptionString;          external LibNameLS17DLL name 'LsMailSetOptionStringA';
    {$endif}
  {$endif}
  {$ifdef UNICODE}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LsMailSetOptionString;          external LibNameLS17DLL index 66;
     {$else}
      function   LsMailSetOptionString;          external LibNameLS17DLL name 'LsMailSetOptionStringW';
    {$endif}
  {$else}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LsMailSetOptionStringW;         external LibNameLS17DLL index 66;
     {$else}
      function   LsMailSetOptionStringW;         external LibNameLS17DLL name 'LsMailSetOptionStringW';
    {$endif}
  {$endif}
  {$ifdef UNICODE}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LsMailGetOptionStringA;         external LibNameLS17DLL index 67;
     {$else}
      function   LsMailGetOptionStringA;         external LibNameLS17DLL name 'LsMailGetOptionStringA';
    {$endif}
  {$else}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LsMailGetOptionString;          external LibNameLS17DLL index 67;
     {$else}
      function   LsMailGetOptionString;          external LibNameLS17DLL name 'LsMailGetOptionStringA';
    {$endif}
  {$endif}
  {$ifdef UNICODE}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LsMailGetOptionString;          external LibNameLS17DLL index 68;
     {$else}
      function   LsMailGetOptionString;          external LibNameLS17DLL name 'LsMailGetOptionStringW';
    {$endif}
  {$else}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LsMailGetOptionStringW;         external LibNameLS17DLL index 68;
     {$else}
      function   LsMailGetOptionStringW;         external LibNameLS17DLL name 'LsMailGetOptionStringW';
    {$endif}
  {$endif}
  {$ifdef CMLS17_LINK_INDEXED}
    function   LsMailSendFile;                 external LibNameLS17DLL index 69;
   {$else}
    function   LsMailSendFile;                 external LibNameLS17DLL name 'LsMailSendFile';
  {$endif}
  {$ifdef UNICODE}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LlStgsysStorageCreateA;         external LibNameLS17DLL index 76;
     {$else}
      function   LlStgsysStorageCreateA;         external LibNameLS17DLL name 'LlStgsysStorageCreateA';
    {$endif}
  {$else}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LlStgsysStorageCreate;          external LibNameLS17DLL index 76;
     {$else}
      function   LlStgsysStorageCreate;          external LibNameLS17DLL name 'LlStgsysStorageCreateA';
    {$endif}
  {$endif}
  {$ifdef UNICODE}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LlStgsysStorageCreate;          external LibNameLS17DLL index 77;
     {$else}
      function   LlStgsysStorageCreate;          external LibNameLS17DLL name 'LlStgsysStorageCreateW';
    {$endif}
  {$else}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LlStgsysStorageCreateW;         external LibNameLS17DLL index 77;
     {$else}
      function   LlStgsysStorageCreateW;         external LibNameLS17DLL name 'LlStgsysStorageCreateW';
    {$endif}
  {$endif}
  {$ifdef CMLS17_LINK_INDEXED}
    function   LlStgsysAppendEMF;              external LibNameLS17DLL index 78;
   {$else}
    function   LlStgsysAppendEMF;              external LibNameLS17DLL name 'LlStgsysAppendEMF';
  {$endif}
  {$ifdef UNICODE}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LsProfileStartA;                external LibNameLS17DLL index 79;
     {$else}
      function   LsProfileStartA;                external LibNameLS17DLL name 'LsProfileStartA';
    {$endif}
  {$else}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LsProfileStart;                 external LibNameLS17DLL index 79;
     {$else}
      function   LsProfileStart;                 external LibNameLS17DLL name 'LsProfileStartA';
    {$endif}
  {$endif}
  {$ifdef UNICODE}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LsProfileStart;                 external LibNameLS17DLL index 80;
     {$else}
      function   LsProfileStart;                 external LibNameLS17DLL name 'LsProfileStartW';
    {$endif}
  {$else}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LsProfileStartW;                external LibNameLS17DLL index 80;
     {$else}
      function   LsProfileStartW;                external LibNameLS17DLL name 'LsProfileStartW';
    {$endif}
  {$endif}
  {$ifdef CMLS17_LINK_INDEXED}
    procedure  LsProfileEnd;                   external LibNameLS17DLL index 81;
   {$else}
    procedure  LsProfileEnd;                   external LibNameLS17DLL name 'LsProfileEnd';
  {$endif}
  {$ifdef UNICODE}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LsMailViewA;                    external LibNameLS17DLL index 83;
     {$else}
      function   LsMailViewA;                    external LibNameLS17DLL name 'LsMailViewA';
    {$endif}
  {$else}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LsMailView;                     external LibNameLS17DLL index 83;
     {$else}
      function   LsMailView;                     external LibNameLS17DLL name 'LsMailViewA';
    {$endif}
  {$endif}
  {$ifdef UNICODE}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LsMailView;                     external LibNameLS17DLL index 84;
     {$else}
      function   LsMailView;                     external LibNameLS17DLL name 'LsMailViewW';
    {$endif}
  {$else}
    {$ifdef CMLS17_LINK_INDEXED}
      function   LsMailViewW;                    external LibNameLS17DLL index 84;
     {$else}
      function   LsMailViewW;                    external LibNameLS17DLL name 'LsMailViewW';
    {$endif}
  {$endif}
  {$ifdef CMLS17_LINK_INDEXED}
    function   LsInternalCreateViewerControlOverParent13;            external LibNameLS17DLL index 87;
   {$else}
    function   LsInternalCreateViewerControlOverParent13;            external LibNameLS17DLL name 'LsInternalCreateViewerControlOverParent13';
  {$endif}
  {$ifdef CMLS17_LINK_INDEXED}
    function   LsInternalGetViewerControlFromParent13;         external LibNameLS17DLL index 88;
   {$else}
    function   LsInternalGetViewerControlFromParent13;         external LibNameLS17DLL name 'LsInternalGetViewerControlFromParent13';
  {$endif}
  {$ifdef CMLS17_LINK_INDEXED}
    procedure  LsSetDlgboxMode;                external LibNameLS17DLL index 89;
   {$else}
    procedure  LsSetDlgboxMode;                external LibNameLS17DLL name 'LsSetDlgboxMode';
  {$endif}
  {$ifdef CMLS17_LINK_INDEXED}
    function   LsGetDlgboxMode;                external LibNameLS17DLL index 90;
   {$else}
    function   LsGetDlgboxMode;                external LibNameLS17DLL name 'LsGetDlgboxMode';
  {$endif}
  {$ifdef CMLS17_LINK_INDEXED}
    function   LsGetViewerControlClassNameEx;  external LibNameLS17DLL index 93;
   {$else}
    function   LsGetViewerControlClassNameEx;  external LibNameLS17DLL name 'LsGetViewerControlClassNameEx';
  {$endif}
  {$ifdef CMLS17_LINK_INDEXED}
    function   LsGetDebug;                     external LibNameLS17DLL index 94;
   {$else}
    function   LsGetDebug;                     external LibNameLS17DLL name 'LsGetDebug';
  {$endif}
  {$ifdef CMLS17_LINK_INDEXED}
    function   LsConvertImageStream;           external LibNameLS17DLL index 95;
   {$else}
    function   LsConvertImageStream;           external LibNameLS17DLL name 'LsConvertImageStream';
  {$endif}
  {$ifdef CMLS17_LINK_INDEXED}
    function   LlStgsysStoragePrintExW;        external LibNameLS17DLL index 96;
   {$else}
    function   LlStgsysStoragePrintExW;        external LibNameLS17DLL name 'LlStgsysStoragePrintExW';
  {$endif}
  {$ifdef CMLS17_LINK_INDEXED}
    function   LsProcessEnhMetaFileRecord;     external LibNameLS17DLL index 97;
   {$else}
    function   LsProcessEnhMetaFileRecord;     external LibNameLS17DLL name 'LsProcessEnhMetaFileRecord';
  {$endif}
  {$ifdef CMLS17_LINK_INDEXED}
    function   LlStgsysGetPageData;            external LibNameLS17DLL index 98;
   {$else}
    function   LlStgsysGetPageData;            external LibNameLS17DLL name 'LlStgsysGetPageData';
  {$endif}

begin
end.

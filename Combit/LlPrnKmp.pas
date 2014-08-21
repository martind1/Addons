unit LlPrnKmp;
(* List & Label Komponente (statt PrnSource zu verwenden)
   Verwendet L17MD-Komponente (unser Ersatz für die Original DBL8_ von combit)
   Autor: Martin Dambach, Bernard Greb
   Letzte Änderung:
   01.03.02 MD     Erstellen
   04.03.02 BG     FDesignerFileExt eingebaut
   17.03.02 MD     L8MD statt DBL8_ verwendet: DetailSource1..9
   18.03.02 MD     Eigener DataSet
   19.03.02 MD     Auswahl Datensätze: (Aktueller, Markierte, Alle)
   18.05.03 MD     MuSelect-Zuweisung korrigiert
   25.03.04 MD     MuSelect auch bei DataSource via UseFltrList
   23.04.12 md     D2010, LL17
   15.05.14 md     MuSelect: property entfernt da mittlerweile im PSrc published

   Umstellung von LL8 nach LL17:
   L8MD_Kmp -> L17MD_Kmp
   uses cmbtl8 -> cmbtLL17


   Extension:                                         Temp
   xxt            xx = DesignerFileExt      Projekt   Print   Sketch
                  t = Typ: Report (LIST)      R         p       v
                  const.   Formular (LABEL)   F         q       w
                           Card (CARD)        C         d       x

   Todo:
   Repositioning
*)


interface

uses
  WinTypes, WinProcs, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DB, L17MD_Kmp, l17, l17db,
  Psrc_kmp, DPos_Kmp, Qwf_Form;

type
  TLlPrn = class(TPrnSource)
  private
    { Private-Deklarationen }
    FCloseAction: TCloseAction;
    FBeforeDlg: TBeforePrnEvent;

    FAutoShowSelectFile: boolean;
    FAutoShowPrintOptions: boolean;
    FDesignerFile: TLlDesignerFile;
    FDesignerFileExt: string;
    FAutoProjectType : TAutoProjectType;
    FAutoDestination : TAutoDestination;
    FDataSource: array[0..pred(MaxLlDataSource)] of TDataSource;   {0..9}
    FMasterSource: TDataSource;
    FAutoMasterMode: TAutoMasterMode;
    fConvertCRLF: boolean;
    FOnAutoDefineField: TAutoDefineFieldEvent;
    FOnAutoDefineVariable: TAutoDefineVariableEvent;
    procedure Prepare(DesignMode: boolean);
    procedure SetDesignerFile(Value: string);
    procedure SetDesignerFileExt(Value: string);
    procedure SetExtProject(Value: string);
    procedure SetExtPrinter(Value: string);
    procedure SetExtSketch(Value: string);
    function  GetDataSource(Index: integer): TDataSource;
    procedure SetDataSource(Index: integer; Value: TDataSource);
    procedure SetMasterSource(Value: TDataSource);
    function DesignerFileCount: integer;
  protected
    { Protected-Deklarationen }
    SaveDS: array[0..pred(MaxLlDataSource)] of record {Sicherung des DS}
                Active: boolean;
                ControlsDisabled: boolean;
                UseFltrList: boolean;
              end;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    { Public-Deklarationen }
    DlgLlPrn: TqForm;
    L17MD: TL17MD;                 {L&L Control}
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetupPrn(var HasChanged: boolean); override; {Drucker einrichten / Designer}
    procedure DoRun; override;     {Startet Dlg. Falls von LNav.DoPrn}
    procedure DoPrn;               {Startet Ausdruck. Von DlgLlPrn}
    function DesignerFilePath: string;   {ergibt kompletten Pfad  + Filename}
    function ProjectExt: string;         {Erweiterung ohne '.'}
    function PrintExt: string;           {Erweiterung ohne '.'}
    function SketchExt: string;          {Erweiterung ohne '.'}
  published
    { Published-Deklarationen }
    property CloseAction: TCloseAction read FCloseAction write FCloseAction default caNone;
    property BeforeDlg: TBeforePrnEvent read FBeforeDlg write FBeforeDlg;

    property ConvertCRLF: boolean read fConvertCRLF write fConvertCRLF default true;
    property AutoShowPrintOptions: boolean read fAutoShowPrintOptions write fAutoShowPrintOptions;
    property AutoShowSelectFile: boolean read fAutoShowSelectFile write fAutoShowSelectFile;
    property DataSource: TDataSource index 0 read GetDataSource write SetDataSource;
    property DetailSource1: TDataSource index 1 read GetDataSource write SetDataSource;
    property DetailSource2: TDataSource index 2 read GetDataSource write SetDataSource;
    property DetailSource3: TDataSource index 3 read GetDataSource write SetDataSource;
    property DetailSource4: TDataSource index 4 read GetDataSource write SetDataSource;
    property DetailSource5: TDataSource index 5 read GetDataSource write SetDataSource;
    property DetailSource6: TDataSource index 6 read GetDataSource write SetDataSource;
    property DetailSource7: TDataSource index 7 read GetDataSource write SetDataSource;
    property DetailSource8: TDataSource index 8 read GetDataSource write SetDataSource;
    property DetailSource9: TDataSource index 9 read GetDataSource write SetDataSource;
    property MasterSource: TDataSource read fMasterSource write SetMasterSource;
    property AutoDesignerFile: string read fDesignerFile write SetDesignerFile;
    property DesignerFileExt: string read fDesignerFileExt write SetDesignerFileExt;
    property AutoProjectType: TAutoProjectType Read FAutoProjectType write fAutoProjectType;
    property AutoDestination: TAutoDestination read FAutoDestination write fAutoDestination;
    property AutoMasterMode: TAutoMasterMode read FAutoMasterMode write FAutoMasterMode;
    property ExtProject: string read ProjectExt write SetExtProject;  {zur Anzeige im OI}
    property ExtPrinter: string read PrintExt write SetExtPrinter;    {zur Anzeige im OI}
    property ExtSketch: string read SketchExt write SetExtSketch;     {zur Anzeige im OI}
    property OnAutoDefineField: TAutoDefineFieldEvent read FOnAutoDefineField write FOnAutoDefineField;
    property OnAutoDefineVariable: TAutoDefineVariableEvent read FOnAutoDefineVariable write FOnAutoDefineVariable;
  end;

{var
  LlPrnID: integer;     {Zähler für LlPrnDlg-Formular Name   n.b.}

implementation

uses
  DbGrids, Uni, DBAccess, MemDS, UQue_Kmp,
  Prots, GNav_Kmp, Ausw_Dlg, Err__Kmp, NLnk_Kmp, KmpResString, Datn_Kmp,
  cmbtLL17;
const
  {ListProject, LabelProject, CardProject => Report, Formular, Card}
  ProjectExtTyp: array[TAutoProjectType] of char = ('R', 'F', 'C');
  PrintExtTyp:   array[TAutoProjectType] of char = ('p', 'q', 'd');
  SketchExtTyp:  array[TAutoProjectType] of char = ('v', 'w', 'x');


constructor TLlPrn.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fConvertCRLF := true;
  CopyFltr := false;
  OneRecord := false;
end;

procedure TLlPrn.Loaded;
begin
  inherited Loaded;
end;

destructor TLlPrn.Destroy;
begin
  inherited Destroy;
end;

procedure TLlPrn.Notification(AComponent: TComponent; Operation: TOperation);
var
  I: integer;
begin
  if Operation = opRemove then
  begin
    for I := 0 to pred(MaxLlDataSource) do
      if AComponent = FDataSource[I] then
        FDataSource[I] := nil;
    if AComponent = MasterSource then
      MasterSource := nil;
  end;
  inherited Notification(AComponent, Operation);
end;

function TLlPrn.GetDataSource(Index: integer): TDataSource;
begin
  Result := FDataSource[Index];
end;

procedure TLlPrn.SetDataSource(Index: integer; Value: TDatasource);
var
  I: integer;
begin
  FDataSource[Index] := Value;

//16.05.14 EACCESS bei MuSelect.GetDataSource im Designer
  if not (csDesigning in ComponentState) and
     (Index = 0) and (Value <> nil) and (FMasterSource = nil) and
     ((MuSelect = nil) or (MuSelect.DataSource <> Value)) then //erlaube Auswahl
  begin    {MuSelect suchen und eintragen:}
    for I := 0 to pred(Owner.ComponentCount) do
      if Owner.Components[I] is TDBGrid then
        with TDBGrid(Owner.Components[I]) do
          if DataSource = Value then
          begin
            MuSelect := TDBGrid(Owner.Components[I]);
            break;
          end;
  end;
  if Value <> nil then
    Value.FreeNotification(self); //notw. falls Owner unterschiedlich
end;

procedure TLlPrn.SetMasterSource(Value: TDataSource);
var
  I: integer;
begin
  FMasterSource := Value;
//16.05.14 EACCESS bei MuSelect.GetDataSource im Designer
  if not (csDesigning in ComponentState) and
     (Value <> nil) and   //ist immer Hauptsource
     ((MuSelect = nil) or (MuSelect.DataSource <> Value)) then //erlaube Auswahl
  begin    {MuSelect suchen und eintragen:}
    for I := 0 to pred(Owner.ComponentCount) do
      if Owner.Components[I] is TDBGrid then
        with TDBGrid(Owner.Components[I]) do
          if DataSource = Value then
          begin
            MuSelect := TDBGrid(Owner.Components[I]);
            break;
          end;
  end;
  if Value <> nil then
    Value.FreeNotification(self); //notw. falls Owner unterschiedlich
end;

procedure TLlPrn.SetExtProject(Value: string);
begin
end;

procedure TLlPrn.SetExtPrinter(Value: string);
begin
end;

procedure TLlPrn.SetExtSketch(Value: string);
begin
end;

procedure TLlPrn.SetDesignerFile(Value: string);
begin
  fDesignerFile := OnlyTableName(Value);
end;

procedure TLlPrn.SetDesignerFileExt(Value: string);
begin
  fDesignerFileExt := Copy(Value, 1, 2);
end;

function TLlPrn.ProjectExt: string;
begin
  result := DesignerFileExt + ProjectExtTyp[FAutoProjectType];
end;

function TLlPrn.PrintExt: string;
begin
  result := DesignerFileExt + PrintExtTyp[FAutoProjectType];
end;

function TLlPrn.SketchExt: string;
begin
  result := DesignerFileExt + SketchExtTyp[FAutoProjectType];
end;

function TLlPrn.DesignerFilePath: string;
// ergibt kompletten Pfad + Filename des Designerfiles in lokaler Umgebung
var
  S: string;
begin
  S := Format('%s.%s', [fDesignerFile, ProjectExt]);

  if (Datn <> nil) and (Datn.LlOrdner <> '') then
  begin  //Dateiablage in DB
    result := Datn.GetLokal(Datn.LlOrdner, S);
  end else
  begin
    result := AppDir + 'Reports\' + S;
    if not FileExists(result) then
    begin
      if FileExists(AppDir + S) then
        result := AppDir + S;
    end;
  end;
end;

function TLlPrn.DesignerFileCount: integer;
var
  S: string;
  ASearchRec: TSearchRec;
  K: integer;
begin    {ergibt Anzahl Files}
  //ChDir(AppDir + 'Reports\' + *.<Ext>);
  result := 0;
  S := Format('%s*.%s', [ExtractFilePath(DesignerFilePath), ProjectExt]);
  K := FindFirst(S, faAnyFile, ASearchRec);
  while K = 0 do
  begin
    Inc(result);
    K := FindNext(ASearchRec);
  end;
  SysUtils.FindClose(ASearchRec);
end;

procedure TLlPrn.SetupPrn(var HasChanged: boolean);
begin
  HasChanged := false;  // PrnSource.Drucker nicht ändern
  Prepare(true);
end;

procedure TLlPrn.DoRun;
begin
  Prepare(false);
end;

procedure TLlPrn.Prepare(DesignMode: boolean);
var
  Fertig: boolean;
  OldKeyFields: string;
  OldFltrList, OldSelfFltrList: string;
  ANavLink: TNavLink;
  FktExt, FktDescr: integer; {Funktionsnummern für L&L}
  iDS: integer;
  S1: string;
  AQuery: TUQuery;
  OldDataSet: TDataSet;
  function BoolToYesNo(B: boolean): TPropYesNo;
  begin
    if B then
      result := Yes else
      result := No;
  end;
  procedure InitNavLink(ANavLink: TNavLink);
  var
    IFld, IRow: integer;
    OldBookMark: TBookMark;
    OldActive: boolean;
  begin
    with ANavLink do
    try
      OldActive := DataSet.Active;
      DataSet.Active := true;
      if OneRecord then
      begin
        for IFld := 0 to pred(PrimaryKeyList.Count) do
          self.FltrList.AddFmt('%s=%s', [PrimaryKeyList[IFld],
            DataSet.FieldByName(PrimaryKeyList[IFld]).AsString]);
      end else
      if (MuSelect <> nil) and (MuSelect.SelectedRows.Count > 0) then
      begin                //korrekt nur bei ID-PKey mit 1 Segment!
        OldBookMark := DataSet.GetBookMark;
        for IRow := 0 to pred(MuSelect.SelectedRows.Count) do
        begin
          DataSet.Bookmark := MuSelect.SelectedRows[IRow];
          for IFld := 0 to pred(PrimaryKeyList.Count) do
          begin
            S1 := self.FltrList.Values[PrimaryKeyList[IFld]];
            AppendTok(S1, DataSet.FieldByName(PrimaryKeyList[IFld]).AsString, ';');
            self.FltrList.Values[PrimaryKeyList[IFld]] := S1;
          end;
        end;
        DataSet.GotoBookMark(OldBookMark);
        DataSet.FreeBookMark(OldBookMark);
      end;
      if assigned(FOnCopyFltr) then  {Benutzerereigniss aufrufen}
        FOnCopyFltr(self);
      DataSet.Active := OldActive;

      OldDataSet := ANavLink.DataSet;
      AQuery := TUQuery.Create(self);
      AQuery.DataBaseName := Query.DataBaseName;
      AQuery.SessionName := Query.SessionName;
      AQuery.MasterSource := Query.DataSource;
      AQuery.RequestLive := Query.RequestLive;
      //AQuery.OnCalcFields := Query.OnCalcFields;  obsolet. siehe SetDataSet}
      ANavLink.DataSet := AQuery;               {ruft SetDataSet!}
      AQuery.DisableControls;
      ANavLink.TableName := ANavLink.TableName;   {Sql in AQuery aktual.}

      OldKeyFields := ANavLink.KeyFields;
      if (self.KeyFields <> '') and (ANavLink.KeyFields <> self.KeyFields) then
        ANavLink.KeyFields := self.KeyFields;
      OldFltrList := ANavLink.FltrList.Text;
      if self.FltrList.Count > 0 then
      begin
        //ANavLink.FltrList.AddStrings(self.FltrList); warum alte Filter behalten???
        ANavLink.FltrList.Assign(self.FltrList);
      end;
      L17MD.RecordCount := ANavLink.RecordCount;
    except on E:Exception do
      EMess(self, E, 'Initialisierung LlPrn nicht vollständig', [0]);
    end;
  end;

var
  I1: integer;

begin {Prepare}
  L17MD := TL17MD.Create(Owner);
  ANavLink := nil;
  {*** Martin Dambach List&Label Persönlicher Lizenzierungsschlüssel:8RfwD ***}
  {*** Romuald Wandzik List&Label Persönlicher Lizenzierungsschlüssel:YyzvD ***}
  L17MD.LlSetOptionString(LL_OPTIONSTR_LICENSINGINFO, 'YyzvD');

  if SysParam.ProtBeforeOpen then  //Debug einschalten. Log nach %WINDIR%COMBIT.LOG
    L17MD.LlSetDebug($41) else      //LL_DEBUG_CMBTLL+LL_DEBUG_CMBTLL_LOGTOFILE);
    L17MD.LlSetDebug(0);            //aus

  L17MD.LlSetPrinterDefaultsDir(PChar(TempDir));   //"c:\\temp\\user");
  //L17MD.LlPreviewSetTempPath(PChar(TempDir));   //siehe unten
  Fertig := false;
  if not DesignMode then                //27.03.04 Qupe.Vers.Et
  begin
    if assigned(FBeforePrn) then
    try
      FBeforePrn(self, Fertig);
    except on E:Exception do
      begin
        EMess(self, E, 'Fehler bei BeforePrn', [0]);
        raise;                                      {wichtig!  HLW.AuFa.PSGrosset}
      end;
    end;
  end;
  if not Fertig then
  try
    L17MD.AutoDesignerFile := DesignerFilePath;
    L17MD.AutoProjectType := fAutoProjectType; //LabelProject;
    for iDS := 0 to pred(MaxLlDataSource) do
      L17MD.DataSource[iDS] := fDataSource[iDS];
    L17MD.MasterSource := fMasterSource;
    L17MD.AutoMasterMode := FAutoMasterMode;

    L17MD.SupportPageBreak := Yes; //BG120302
    //23.04.12 alt L17MD.AutoMultipage := Yes;
    L17MD.LlSetOption(LL_OPTION_AUTOMULTIPAGE, 1);

    L17MD.OnAutoDefineField := FOnAutoDefineField;
    L17MD.OnAutoDefineVariable := FOnAutoDefineVariable;

    if not DesignMode then
    begin
      L17MD.LlSetOption(LL_OPTION_XLATVARNAMES, 0);
      L17MD.LlSetOption(LL_OPTION_NOPARAMETERCHECK, 1);
      {L17MD.LlPrintSetOption(LL_PRNOPT_COPIES, Kopien);  hier nicht möglich. Erst nach LlPrintStart möglich}
    end;
    case fAutoProjectType of    //TAutoProjectType = (ptListProject, ptLabelProject, ptCardProject);
      ptLabelProject :
      begin
        FktExt := LL_PROJECT_LABEL;
        FktDescr := LL_OPTIONSTR_LABEL_PRJDESCR;
      end;
      ptCardProject  :
      begin
        FktExt := LL_PROJECT_CARD;
        FktDescr := LL_OPTIONSTR_CARD_PRJDESCR;
      end;
    else {ListProject}
      FktExt := LL_PROJECT_LIST;
      FktDescr := LL_OPTIONSTR_LIST_PRJDESCR;
    end;
    L17MD.LlSetFileExtensions(FktExt, PChar(ProjectExt), PChar(PrintExt), PChar(SketchExt));
    L17MD.LlSetOptionString(FktDescr, PChar(Display)); {Beschreibung im L&L Öffnen Dialog}

    if DesignerFileCount = 1 then    {keine Dateiauswahl da und 1 da}
      L17MD.AutoShowSelectFile := BoolToYesNo(false) else
      L17MD.AutoShowSelectFile := BoolToYesNo(FAutoShowSelectFile);
    L17MD.AutoShowPrintOptions := BoolToYesNo(FAutoShowPrintOptions);

    if self.Preview then
    begin
      L17MD.AutoDestination := adPreview;
      {L17MD.AutoShowSelectFile := BoolToYesNo(false);   }
      L17MD.AutoShowPrintOptions := BoolToYesNo(false);
    end else
      L17MD.AutoDestination := fAutoDestination;

    L17MD.ConvertCRLF := BoolToYesNo(fConvertCRLF);

    Fertig := false;
    SMess(SPsrc_Kmp_005,[0]);		// 'Ausdruck läuft ...'
    OldSelfFltrList := Self.FltrList.Text;
    if fMasterSource <> nil then
    begin
      if not DesignMode then
      begin
        ANavLink := DSGetNavLink(fMasterSource);
        if ANavLink <> nil then
          InitNavLink(ANavLink);

        for iDS := 0 to pred(MaxLlDataSource) do
          if (fDataSource[iDS] <> nil) and (fDataSource[iDS].DataSet <> nil) then
          begin
            SaveDS[iDS].Active := fDataSource[iDS].DataSet.Active;
            SaveDS[iDS].ControlsDisabled := fDataSource[iDS].DataSet.ControlsDisabled;
            fDataSource[iDS].DataSet.DisableControls;
          end;
      end;   {not Design}
      fMasterSource.DataSet.Active := true;
      for iDS := 0 to pred(MaxLlDataSource) do
        if (fDataSource[iDS] <> nil) and (fDataSource[iDS].DataSet <> nil) then
        try
          fDataSource[iDS].DataSet.Active := true;
        except on E:Exception do begin
            EMess(fDataSource[iDS].DataSet, E, 'TLlPrn.Prepare', [0]);
            raise;
          end;
        end;
    end else
    if (fDataSource[0] <> nil) and (fDataSource[0].DataSet <> nil) then
    begin
      if not DesignMode then
      begin
        ANavLink := DSGetNavLink(fDataSource[0]);
        if ANavLink <> nil then
        begin
          SaveDS[0].UseFltrList := ANavLink.UseFltrList;
          ANavLink.UseFltrList := true;
          InitNavLink(ANavLink);
        end;
      end;
      fDataSource[0].DataSet.Active := true;
    end;
    (*
    if ANavLink <> nil then
    begin
      OldAutoOpen := ANavLink.AutoOpen;
      ANavLink.AutoOpen := false;   {falls in FBeforePrn gespeichert wird}
    end;
    if ANavLink <> nil then
    begin
      ANavLink.AutoOpen := OldAutoOpen;
    end;
    *)
    if not Fertig then
    try
      if not DesignMode then
      begin
        L17MD.ExportType := Bemerkung.Values['Export.Type'];  //'HTML', 'PDF'

        if L17MD.ExportType <> '' then
        begin
          L17MD.AutoShowSelectFile := BoolToYesNo(false);
          L17MD.AutoShowPrintOptions := BoolToYesNo(false);  //if Export.Quiet then ...
          L17MD.AutoDestination := adPRNFile;  //23.04.12

          I1 := L17MD.LlXSetParameter(LL_LLX_EXTENSIONTYPE_EXPORT, L17MD.ExportType,
            'Export.File', Bemerkung.Values['Export.File']);
          I1 := L17MD.LlXSetParameter(LL_LLX_EXTENSIONTYPE_EXPORT, L17MD.ExportType,
            'Export.Path', Bemerkung.Values['Export.Path']);
          I1 := L17MD.LlXSetParameter(LL_LLX_EXTENSIONTYPE_EXPORT, L17MD.ExportType,
            'Export.Quiet', '1');
          {L17MD.LlPrintWithBoxStart(hJob, LL_PROJECT_LIST, 'Artikel.lst',
            LL_PRINT_EXPORT, LL_BOXTYPE_BRIDGEMETER, hWnd, 'Exporting to HTML');
          L17MD.LlPrintSetOptionString(LL_PRNOPTSTR_EXPORT, PChar(L17MD.ExportType));}
          //... Normale Druckschleife ...
//         end else
//         if L17MD.UsePageCount then
//         begin
//           OldAutoShowSelectFile := L17MD.AutoShowSelectFile;
//           OldAutoShowPrintOptions := L17MD.AutoShowPrintOptions;
//           OldAutoDestination := L17MD.AutoDestination;
//
//           L17MD.AutoShowSelectFile := BoolToYesNo(false);
//           L17MD.AutoDestination := L8.Preview;
//           L17MD.AutoShowPrintOptions := BoolToYesNo(false);
//           L17MD.PageCount := 1;
//           L17MD.CalcPageCount := true;
//           L17MD.AutoPrint(Display, TempDir);
//
//           L17MD.AutoShowSelectFile := OldAutoShowSelectFile;
//           L17MD.AutoShowPrintOptions := OldAutoShowPrintOptions;
//           L17MD.AutoDestination := OldAutoDestination;
        end;
        L17MD.Kopien := Kopien;
        L17MD.UsePageCount := false;

        L17MD.AutoPrint(Display, TempDir);
        if L17MD.UsePageCount then
        begin
          L17MD.CalcPageCount := false;
          if fMasterSource <> nil then
          begin
            fMasterSource.DataSet.First;
          end else
          if (fDataSource[0] <> nil) and (fDataSource[0].DataSet <> nil) then
          begin
            fDataSource[0].DataSet.First;
          end;

          L17MD.AutoPrint(Display, TempDir);
        end;
      end else
      begin
        L17MD.PageCount := 1;
        L17MD.AutoDesign(Display);
      end;
      if assigned(FAfterPrn) then
        FAfterPrn( self);            {Aufruf hier nur wenn erfolgreich gedruckt}
    except on E:Exception do
      // 'Fehler bei Quickreport(%s)'
      EMess(self, E, SPsrc_Kmp_009,[Display]);
    end;
    (* Restaurierung: *)
    Self.FltrList.Text := OldSelfFltrList;
    if fMasterSource <> nil then
    begin
      if ANavLink <> nil then
      try
        ANavLink.NoBuildSql := true;
        ANavLink.KeyFields := OldKeyFields;
        ANavLink.FltrList.Text := OldFltrList;
        ANavLink.DataSource.DataSet := OldDataSet;     {kein nlnk.SetDataSet!}
        AQuery.Free;
      finally
        ANavLink.NoBuildSql := false;
      end;
      for iDS := 0 to pred(MaxLlDataSource) do
        if (fDataSource[iDS] <> nil) and (fDataSource[iDS].DataSet <> nil) then
        begin
          fDataSource[iDS].DataSet.Active := SaveDS[iDS].Active;
          //if not SaveDS[iDS].ControlsDisabled then
            while fDataSource[iDS].DataSet.ControlsDisabled do
              fDataSource[iDS].DataSet.EnableControls;
        end;
    end else
    if (fDataSource[0] <> nil) and (fDataSource[0].DataSet <> nil) then
    begin
      if ANavLink <> nil then
      try
        ANavLink.NoBuildSql := true;
        Self.FltrList.Text := OldSelfFltrList;
        ANavLink.KeyFields := OldKeyFields;
        ANavLink.FltrList.Text := OldFltrList;
        ANavLink.DataSource.DataSet := OldDataSet;     {kein nlnk.SetDataSet!}
        ANavLink.UseFltrList := SaveDS[0].UseFltrList;
        AQuery.Free;
      finally
        ANavLink.NoBuildSql := false;
      end;
    end;
  finally
    L17MD.Free;
    if assigned(FOnFinished) then
      FOnFinished( self);            {Aufruf hier immer auch bei Abbruch,Fehler,..}
  end;
end;

procedure TLlPrn.DoPrn;
(* Startet Ausdruck. Von DlgLlPrn *)
begin
  //inherited DoRun;
end;

end.

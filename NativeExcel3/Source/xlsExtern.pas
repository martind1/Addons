//////////////////////////////////////////////////////////////////////////////
//
//	Unit:         xlsExtern
//
//
//      Description:  ExternSheets table
//                    used in RANGE3D and REF3D operands in formula
//
//////////////////////////////////////////////////////////////////////////////
//
//     Copyright (c) 2004-2013 NikaSoft. All rights reserved.
//     Author: A.V.Nikulitsa
//
//       site: http://www.nika-soft.com/ 
//     e-mail: support@nika-soft.com
//
//////////////////////////////////////////////////////////////////////////////

unit xlsExtern;
{$Q-}
{$R-}

interface

uses xlshash, xlsblob, xlsextbook;

{$I xlsdef.inc}
{$I xlsbase.inc}

type
  TGetSheetIDByName    = procedure (SheetName: widestring; Var SheetID: integer) of object;
  TGetSheetIndexByID   = procedure (SheetID: integer; Var SheetIndex: integer) of object;
//  TGetSheetNameByID    = procedure (SheetID: integer; Var SheetName: widestring) of object;
  TGetSheetNameByIndex = procedure (SheetIndex: integer; Var SheetName: widestring) of object;
  TGetNameByID         = procedure (NameID: integer; Var Name: widestring) of object;  
  TGetSheetIDByNameID  = function  (NameID: integer): integer of object;  
  TGetNameStoreIndexByID = function (NameID: integer): integer of object;  
  TGetNameIDByName       = function (Name: Widestring; CurSheetID: integer): integer of object;
  TGetExcel5BookExternID = function(): integer of object; 
  TExcel5ExternID2Name = function (Excel5ExternID: integer): WideString of object;
  TGetCalcRange         = function (ANameID: integer; cursheetindex: integer; var Range: IInterface): integer of object;

  TXLSSupBookItem = class;
 
  TXLSSupBook = class
  private
     FArr: TObjectArray;
     FSelfIndex: integer;
     FAddonFuncIndex: integer;

     function GetSelfIndex: integer;   
     procedure AppendSelfBook;
     function GetAddonFunctionName(supbookindex, index: integer): widestring;
     function RegisterAddonFunctionName(supbookindex: integer; funcname: widestring): integer;
     //function CreateAddonFunctionItem: integer;
  protected
     function GetItem(index: integer): TXLSSupBookItem;
  public
     constructor Create;
     destructor Destroy; override; 
     function Parse(Data: TXLSBlob): integer;
     function ParseExternalName(funcname: widestring): integer;
     
     property SelfBookIndex: integer read GetSelfIndex;
     function Store(DataList: TXLSBlobList; SheetsCount: integer): integer;
     function CreateItem(b: TXLSExternalBook): integer;
  end;

  TXLSSupBookItem = class
  private
    FSelfDoc: boolean;
    FDocUrl: WideString;
    FSheets: Array of Widestring;
    FFuncs: Array of Widestring;
    FFuncsHash: THashInteger;

    FIsAddonFunc: boolean;
    //FAddinFuncName: WideString; 
    function Parse(Data: TXLSBlob): integer;
    function ParseExternalName(funcname: widestring): integer;
    
    function GetAddonFunctionName(index: integer): widestring;
    function AddAddonFunction(funcname: widestring): integer;
    function RegisterAddonFunctionName(funcname: widestring): integer;
  protected
    function GetData(SheetCount: integer): TXLSBlob;
    procedure AddSheetName(AName: widestring);
  public
    constructor Create; overload;
    constructor Create(Data: TXLSBlob); overload;
    
    destructor Destroy;  override;
    property IsSelfDoc: boolean read FSelfDoc;
    property IsAddonFunc: boolean read FIsAddonFunc;
    property DocUrl: widestring read FDocUrl;
  end;

  TXLSExtBookItem = class
  private
     FBook: TXLSExternalBook;
     FDestroy: boolean;
     FSupBookIndex: integer; 
  public
     constructor Create(ABook: TXLSExternalBook; ADestroy: boolean);
     destructor Destroy; override;
     procedure SetSupBookIndex(AIndex: integer);
     function FuncExists(FuncName: widestring): boolean;
     function GetFunctionEntry(FuncName: widestring): THashFuncEntry;
     property SupBookIndex: integer read FSupBookIndex;
     property ExternalBook: TXLSExternalBook read FBook;
  end;

  TXLSExtBookList = class
  private
     FCount: integer;
     FArr: array of TXLSExtBookItem;
     procedure SetExtraFunctions;
     function BuildExtraFunctions: TXLSExternalBook;
     procedure Add(item: TXLSExtBookItem);
  protected
    function DecodeUrl(url: widestring): widestring;
  public 
     constructor Create;
     destructor Destroy; override;   
     function GetExtraBookIndex(FuncName: WideString): integer;
     function GetExtraBookFunctionEntry(AExtraBookIndex: integer; FuncName: Widestring):THashFuncEntry; 
     function GetSupBookIndex(AExtraBookIndex: integer): integer;
     procedure SetSupBookIndex(AExtraBookIndex: integer; ASupBookIndex: integer);
     function Sup2ExtraIndex(SupBookIndex: integer): integer;
     function GetItem(AExtraBookIndex: integer): TXLSExtBookItem;
     function FindByUrl(AUrl: widestring): integer;
  end;

  TXLSExternSheetItem = class (THashEntry)
  public
    Sheet1ID: integer;
    Sheet2ID: integer;
    Count: integer;
    StoreIndex: integer;
    StoreSheet1Index: integer;
    StoreSheet2Index: integer;
    SupBookIndex: integer;
  end;

  TXLSExternSheet = class(THash)
  protected
    function  CreateEntry: THashEntry; override;
  private
    FReferredID: Array of integer;
    FReferredCount: integer;
    FCurrentID: integer;
    FExternHash: THashInteger;

    FSupBook: TXLSSupBook;
    FExtraBooks: TXLSExtBookList;

    FGetSheetIDByName: TGetSheetIDByName;
    FGetSheetIndexByID: TGetSheetIndexByID;
//    FGetSheetNameByID: TGetSheetNameByID;
    FGetSheetNameByIndex: TGetSheetNameByIndex;
    FGetNameByID: TGetNameByID;
    FGetNameStoreIndexByID: TGetNameStoreIndexByID;
    FGetNameIDByName: TGetNameIDByName;   
    FGetSheetIDByNameID: TGetSheetIDByNameID;
    FExcel5ExternID2Name: TExcel5ExternID2Name;
    FGetExcel5BookExternID: TGetExcel5BookExternID; 
    FGetCalcRange: TGetCalcRange;

    function GetSheetIDByName(SheetName: WideString): integer;
//    function GetSheetNameByID(SheetID: integer): WideString;
    function GetSheetNameByIndex(SheetIndex: integer): WideString;
    function GetNewID: integer;
  public
    constructor Create(AGetSheetIDByName: TGetSheetIDByName;
                      AGetSheetIndexByID: TGetSheetIndexByID; 
//                      AGetSheetNameByID: TGetSheetNameByID;
                      AGetSheetNameByIndex: TGetSheetNameByIndex;
                      AGetNameByID: TGetNameByID;
                      AGetNameStoreIndexByID: TGetNameStoreIndexByID;
                      AGetNameIDByName: TGetNameIDByName;
                      AGetSheetIDByNameID: TGetSheetIDByNameID;
                      AGetExcel5BookExternID: TGetExcel5BookExternID;
                      AGetCalcRange: TGetCalcRange);
    destructor Destroy; override;
    procedure CreateReferredList;

    function AddExtern(ExternID: integer; SupBookIndex: integer; Sheet1Index, Sheet2Index: integer): integer;
    function AddExternIDBySheetID(ExternID, Sheet1ID, Sheet2ID: integer): integer;

    function GetExternID(ExternID: integer; Sheet1Name, Sheet2Name: WideString): integer;overload;
    function GetExternID(ExternID: integer; Sheet1Index, Sheet2Index: integer): integer;overload;
    function GetExternID(Sheet1Name, Sheet2Name: WideString): integer;overload;
    function GetExternID(Sheet1Index, Sheet2Index: integer): integer;overload;
    function GetExternIDByNameID(NameID: integer): integer;
    function TranslateExcel5ExternID(Excel5ExternID: integer): integer;

    function GetExternIndex(ExternID: integer): integer;
    function GetSheetIndexes(ExternID: integer; Var SupBookIndex, Sheet1Index, Sheet2Index: integer): integer;
    function GetSheetIDs(ExternID: integer; Var SupBookIndex, Sheet1ID, Sheet2ID: integer): integer;
    function GetSheetNames(ExternID: integer; Var SheetNames: WideString): integer;
    function GetReferredIndexes(Index: integer; Var SupBookIndex, Sheet1Index, Sheet2Index: integer): integer;
    function GetNameByID(ANameID: integer): widestring;
    function GetNameStoreIndexByID(ANameID: integer): integer;
    function GetNameIDByName(Name: Widestring; CurSheetID: integer): integer;
    function GetSheetIndexByID(SheetID: integer): integer;
    function GetExcel5BookExternID(): integer;
    function GetCalcRange(ANameID: integer; cursheetindex: integer; var Range: IInterface): integer;

//  function GetAddonFunctionExternID: integer;
//  function AddExtraFuncName(FuncName: String): integer;
  
    function GetExtraFuncName(ExternID: integer; FuncIndex: integer): widestring;
    function GetExtraFuncEntry(ExternID: integer; NameID: integer): THashFuncEntry;

    function IsExternIDAddonFuncs(ExternID:integer): boolean;
    function GetSupBookIndex(ExternID: integer): integer;
    function AddExtraFuncName(ExternId: integer; FuncName: WideString): integer;
    function GetExtraBookIndex(FuncName: WideString): integer;
    function GetExtraBookFunctionEntry(AExtraBookIndex: integer; FuncName: Widestring):THashFuncEntry; 
    function GetExtraBookExternID(AExtraBookIndex: integer): integer;

    function IsTheSameWorkbook(ExternID: integer): boolean;

    property ReferredCount: integer read FReferredCount;
    property SupBook: TXLSSupBook read FSupBook;
    property Excel5ExternID2Name: TExcel5ExternID2Name read FExcel5ExternID2Name write FExcel5ExternID2Name;
    procedure RegisterExternalBook(ExtBook: TXLSExternalBook);
    function ParseSupBook(Data: TXLSBlob): integer;
    
  end;


implementation
uses SysUtils, Classes;

constructor TXLSExternSheet.Create(AGetSheetIDByName: TGetSheetIDByName;
                   AGetSheetIndexByID: TGetSheetIndexByID; 
//                   AGetSheetNameByID: TGetSheetNameByID;
                   AGetSheetNameByIndex: TGetSheetNameByIndex;
                   AGetNameByID: TGetNameByID;
                   AGetNameStoreIndexByID: TGetNameStoreIndexByID;
                   AGetNameIDByName: TGetNameIDByName;
                   AGetSheetIDByNameID: TGetSheetIDByNameID;
                   AGetExcel5BookExternID: TGetExcel5BookExternID;
                   AGetCalcRange: TGetCalcRange);
begin
  inherited Create;
  FReferredCount := 0;
  FCurrentID := 0;
  FGetSheetIDByName  := AGetSheetIDByName;
  FGetSheetIndexByID := AGetSheetIndexByID;
//  FGetSheetNameByID  := AGetSheetNameByID;
  FGetSheetNameByIndex  := AGetSheetNameByIndex;
  FGetNameByID := AGetNameByID;
  FGetNameStoreIndexByID:= AGetNameStoreIndexByID;
  FGetNameIDByName      := AGetNameIDByName;
  FGetSheetIDByNameID   := AGetSheetIDByNameID;
  FExcel5ExternID2Name  := nil;
  FGetExcel5BookExternID := AGetExcel5BookExternID;
  FGetCalcRange := AGetCalcRange;

  FExternHash := THashInteger.Create;
  FSupBook := TXLSSupBook.Create();
  FExtraBooks := TXLSExtBookList.Create();
end;

destructor TXLSExternSheet.Destroy; 
begin
  if FReferredCount > 0 then SetLength(FReferredID, 0);
  FExternHash.Free;
  FSupBook.Free; 
  FExtraBooks.Free;
  inherited Destroy;
end;

function TXLSExternSheet.GetNewID: integer;
begin
  Inc(FCurrentID);
  Result := FCurrentID;
end;

procedure TXLSExternSheet.CreateReferredList;
Var lKeys: TStringList;
    cnt, i, j: integer;
    ExternID: integer;
    Res: integer;
    CurEntry: TXLSExternSheetItem;
    Ind: integer;
begin
 lKeys := Keys;
 cnt := lKeys.Count; 
 SetLength(FReferredID, 0);
 FReferredCount := 0;
 if cnt > 0 then begin
    SetLength(FReferredID, cnt);
    j := 0;
    for i := 0 to cnt - 1 do begin
      Res := 1;
      ExternID := strtointdef(lKeys[i], -1);
      CurEntry := TXLSExternSheetItem(FindHashEntry(lKeys[i]));
      if CurEntry = nil then Res := -1;
      if Res = 1 then begin
         if CurEntry.Count <= 0 then Res := -1;
      end;

      if (Res = 1) and (CurEntry.Sheet1ID >= 0) and (CurEntry.Sheet2ID >= 0) then begin

         if Res = 1 then begin
            CurEntry.StoreSheet1Index := GetSheetIndexByID(CurEntry.Sheet1ID);
            if CurEntry.StoreSheet1Index < 1 then Res := -1;
         end;

         if Res = 1 then begin
            if CurEntry.Sheet1ID = CurEntry.Sheet2ID then
               CurEntry.StoreSheet2Index := CurEntry.StoreSheet1Index
            else
               CurEntry.StoreSheet2Index := GetSheetIndexByID(CurEntry.Sheet2ID);
            if CurEntry.StoreSheet2Index < 1 then Res := -1;
         end;

         if Res = 1 then begin
            if CurEntry.StoreSheet2Index < CurEntry.StoreSheet1Index then begin
               Ind := CurEntry.StoreSheet2Index;
               CurEntry.StoreSheet2Index := CurEntry.StoreSheet1Index;
               CurEntry.StoreSheet1Index := Ind;
            end;
         end;
      end;

      if Res = 1 then  begin
         Inc(j); 
         CurEntry.StoreIndex := j;
         FReferredID[j - 1] := ExternID; 
      end else begin
         CurEntry.StoreIndex := -1;
         CurEntry.StoreSheet2Index := -1; 
         CurEntry.StoreSheet1Index := -1; 
      end;
    end; 
    SetLength(FReferredID, j);
    FReferredCount := j;
 end;
 lKeys.Free;
end;

function TXLSExternSheet.AddExtern(ExternID: integer; SupBookIndex: integer; Sheet1Index, Sheet2Index: integer): integer;
Var lKey: WideString; 
    CurEntry: TXLSExternSheetItem;
begin
  if SupBookIndex = SupBook.SelfBookIndex then begin
     //this workbook
     Result := GetExternID(ExternID, Sheet1Index, Sheet2Index); 
  end else begin
     //external workbook
     if Sheet1Index >= 65535 then Sheet1Index := -1;
     if Sheet2Index >= 65535 then Sheet2Index := -1;
     lKey := inttostr(SupBookIndex) + '!' + inttostr(Sheet1Index) + ':' + inttostr(Sheet2Index);

     If ExternID > 0 then Result := -1
                     else Result := FExternHash[lKey];
       
     if Result < 1 then begin
        //Create new entry
        if ExternID > 0 then begin
           if ExternID > FCurrentID then FCurrentID := ExternID;
           Result := ExternID;
        end else 
           Result := GetNewID;
        CurEntry := TXLSExternSheetItem(GetHashEntry(inttostr(Result)));
        if CurEntry <> nil then begin
           CurEntry.Sheet1ID := Sheet1Index;
           CurEntry.Sheet2ID := Sheet2Index;
           CurEntry.Count := 1; //!!! add refcount support
           CurEntry.SupBookIndex := SupBookIndex; 
           FExternHash[lKey] := Result;
        end else Result := -1;
     end;
  end;
end;


function TXLSExternSheet.GetExternID(Sheet1Index, Sheet2Index: integer): integer;
begin
  Result := GetExternID(-1, Sheet1Index, Sheet2Index);
end;

function TXLSExternSheet.GetExternID(ExternID: integer; Sheet1Index, Sheet2Index: integer): integer;
Var Sheet1Name, Sheet2NAme: WideString;
begin
  Sheet1Name := GetSheetNameByIndex(Sheet1Index);
  Sheet2Name := GetSheetNameByIndex(Sheet2Index);
  Result := GetExternID(ExternID, Sheet1Name, Sheet2Name);
end;

function TXLSExternSheet.GetExternID(Sheet1Name, Sheet2Name: WideString): integer;
begin
  Result := GetExternID(-1, Sheet1Name, Sheet2Name);
end;

function TXLSExternSheet.GetExternID(ExternID: integer; Sheet1Name, Sheet2Name: WideString): integer;
Var lKey: WideString;
    Sheet1ID, Sheet2ID: integer;
    ID: integer;
    CurEntry: TXLSExternSheetItem;
begin
  Result := 1;
  Sheet1ID := GetSheetIDByName(Sheet1Name);
  Sheet2ID := Sheet1ID;
  if Sheet1ID < 1 then Result := -1;
  if Result = 1 then begin
     if (Sheet1Name <> Sheet2Name) and (Sheet2Name <> '') then begin
       Sheet2ID := GetSheetIDByName(Sheet2Name);
       if Sheet2ID < 1 then Result := -1;
     end;
  end;
  if Result = 1 then begin
     if Sheet2ID < Sheet1ID then begin
        ID := Sheet2ID;
        Sheet2ID := Sheet1ID;
        Sheet1ID := ID;
     end;
     lKey := inttostr(Sheet1ID) + ':' + inttostr(Sheet2ID);
     If ExternID > 0 then Result := -1
                     else Result := FExternHash[lKey];
       
     if Result < 1 then begin
        //Create new entry
        if ExternID > 0 then begin
           if ExternID > FCurrentID then FCurrentID := ExternID;
           Result := ExternID;
        end else 
           Result := GetNewID;
        CurEntry := TXLSExternSheetItem(GetHashEntry(inttostr(Result)));
        if CurEntry <> nil then begin
           CurEntry.Sheet1ID := Sheet1ID;
           CurEntry.Sheet2ID := Sheet2ID;
           CurEntry.Count := 1; //!!! add refcount support
           CurEntry.SupBookIndex := SupBook.SelfBookIndex; 
           FExternHash[lKey] := Result;
        end else Result := -1;
     end;
  end;
end;

function TXLSExternSheet.AddExternIDBySheetID(ExternID, Sheet1ID, Sheet2ID: integer): integer;
Var lKey: WideString;
    ID: integer;
    CurEntry: TXLSExternSheetItem;
begin
  if Sheet2ID < Sheet1ID then begin
     ID := Sheet2ID;
     Sheet2ID := Sheet1ID;
     Sheet1ID := ID;
  end;

  lKey := inttostr(Sheet1ID) + ':' + inttostr(Sheet2ID);
  If ExternID > 0 then Result := -1
                  else Result := FExternHash[lKey];
    
  if Result < 1 then begin
     //Create new entry
     if ExternID > 0 then begin
        if ExternID > FCurrentID then FCurrentID := ExternID;
        Result := ExternID;
     end else 
        Result := GetNewID;

     CurEntry := TXLSExternSheetItem(GetHashEntry(inttostr(Result)));
     if CurEntry <> nil then begin
        CurEntry.Sheet1ID := Sheet1ID;
        CurEntry.Sheet2ID := Sheet2ID;
        CurEntry.Count := 1; //!!! add refcount support
        CurEntry.SupBookIndex := SupBook.SelfBookIndex; 
        FExternHash[lKey] := Result;
     end else Result := -1;
  end;
end;


function TXLSExternSheet.GetExternIDByNameID(NameID: integer): integer;
var SheetID: integer;
begin
   SheetID := FGetSheetIDByNameID(NameID);
   if (SheetID > 0) then begin
       Result := AddExternIDBySheetID(-1, SheetID, SheetID);
   end else begin 
       Result := -1;
   end;
end;

function TXLSExternSheet.GetExcel5BookExternID(): integer;
begin
   Result := FGetExcel5BookExternID();
end;

function TXLSExternSheet.GetCalcRange(ANameID: integer; cursheetindex: integer; var Range: IInterface): integer;
begin
   Result := FGetCalcRange(ANameID, cursheetindex, Range);
end;


function TXLSExternSheet.IsExternIDAddonFuncs(ExternID:integer): boolean;
var supbookindex: integer;
begin
  Result := false;
  supbookindex := GetSupBookIndex(ExternID);
  if supbookindex >= 0 then begin
     Result := (FExtraBooks.GetSupBookIndex(0) = supbookindex);   
  end;
end;

function TXLSExternSheet.GetExtraBookIndex(FuncName: WideString): integer;
begin
  Result := FExtraBooks.GetExtraBookIndex(FuncName);
end;

function TXLSExternSheet.GetExtraBookFunctionEntry(AExtraBookIndex: integer; FuncName: Widestring):THashFuncEntry; 
begin
  Result := FExtraBooks.GetExtraBookFunctionEntry(AExtraBookIndex, FuncName);
end;

function TXLSExternSheet.GetExtraFuncEntry(ExternID: integer; NameID: integer): THashFuncEntry;
var supbookindex: integer;
    funcname: widestring;
    extrabookindex: integer;
begin
  Result := nil;
  funcname := GetExtraFuncName(ExternID, NameID);
  supbookindex := GetSupBookIndex(ExternID);
  if (supbookindex >= 0) and (funcname <> '') then begin
     extrabookindex := FExtraBooks.Sup2ExtraIndex(supbookindex);
     if extrabookindex >= 0 then begin
        Result := FExtraBooks.GetExtraBookFunctionEntry(extrabookindex, funcname);
     end; 
  end;
end;



function TXLSExternSheet.GetExtraBookExternID(AExtraBookIndex: integer): integer;
var supbookindex: integer;
    extbook: TXLSExtBookItem;
begin
  supbookindex := FExtraBooks.GetSupBookIndex(AExtraBookIndex);
  if supbookindex < 0 then begin
     extbook := FExtraBooks.GetItem(AExtraBookIndex);
     supbookindex :=  FSupBook.CreateItem(extbook.ExternalBook);
     FExtraBooks.SetSupBookIndex(AExtraBookIndex, supbookindex);
  end;
  Result := AddExtern(-1, supbookindex, -1, -1); 
end;
  

{
function TXLSExternSheet.GetAddonFunctionExternID: integer;
var supbookindex: integer;
begin
   supbookindex := FSupBook.FAddonFuncIndex;
   if (supbookindex < 0) then begin
      supbookindex := FSupBook.CreateAddonFunctionItem();
   end;
   Result := AddExtern(-1, supbookindex, -1, -1); 
end;
}

function TXLSExternSheet.GetExtraFuncName(ExternID: integer; FuncIndex: integer): widestring;
var supbookindex: integer;
begin
   supbookindex := GetSupBookIndex(ExternID);
   if supbookindex >= 0 then begin
      Result := FSupBook.GetAddonFunctionName(supbookindex, FuncIndex);
   end else begin
      Result := '';
   end;
end;


function TXLSExternSheet.GetSupBookIndex(ExternID: integer): integer;
var CurEntry: TXLSExternSheetItem; 
begin
   CurEntry := TXLSExternSheetItem(GetHashEntry(inttostr(ExternID)));
   if Assigned(CurEntry) then begin
      Result := CurEntry.SupBookIndex;
   end else begin
      Result := -1;
   end;
end;

function TXLSExternSheet.AddExtraFuncName(ExternID: integer; FuncName: widestring): integer;
var supbookindex: integer;
begin
   supbookindex := GetSupBookIndex(ExternID);
   Result :=  FSupBook.RegisterAddonFunctionName(supbookindex, funcname);
end;

function TXLSExternSheet.IsTheSameWorkbook(ExternID: integer): boolean;
Var lKey: String;
    CurEntry: TXLSExternSheetItem;
begin
   if (ExternID = 0) and (Count = 0) then begin
      Result := true;
   end else begin
      lKey := inttostr(ExternID);
      CurEntry := TXLSExternSheetItem(FindHashEntry(lKey));
      if Assigned(CurEntry) then begin
         Result := (CurEntry.SupBookIndex = FSupBook.SelfBookIndex);
      end else begin
         Result := true;
      end;
   end;
end;

function TXLSExternSheet.GetExternIndex(ExternID: integer): integer;
Var lKey: String;
    CurEntry: TXLSExternSheetItem;
begin
  Result := 1;
  lKey := inttostr(ExternID);
  CurEntry := TXLSExternSheetItem(FindHashEntry(lKey));
  if CurEntry = nil then Result := -1;
  if Result = 1 then begin
     Result := CurEntry.StoreIndex;
  end;
end;

function TXLSExternSheet.GetSheetIndexes(ExternID: integer; Var SupBookIndex, Sheet1Index, Sheet2Index: integer): integer;
Var lKey: String;
    CurEntry: TXLSExternSheetItem;
    Ind: integer;
begin
  Result := 1;
  lKey := inttostr(ExternID);
  CurEntry := TXLSExternSheetItem(FindHashEntry(lKey));
  if CurEntry = nil then Result := -1;

  if Result = 1 then begin
     SupBookIndex :=  CurEntry.SupBookIndex;
     if SupBookIndex = SupBook.SelfBookIndex then begin
        if Result = 1 then begin
           Sheet1Index := GetSheetIndexByID(CurEntry.Sheet1ID);
           if Sheet1Index < 1 then Result := -1;
        end;
        if Result = 1 then begin
           if CurEntry.Sheet1ID = CurEntry.Sheet2ID then
              Sheet2Index := Sheet1Index
           else
              Sheet2Index := GetSheetIndexByID(CurEntry.Sheet2ID);
           if Sheet2Index < 1 then Result := -1;
        end;
        if Result = 1 then 
           if Sheet2Index < Sheet1Index then begin
              Ind := Sheet2Index;
              Sheet2Index := Sheet1Index;
              Sheet1Index := Ind;
           end;
     end else begin
        Sheet1Index := CurEntry.Sheet1ID;
        Sheet2Index := CurEntry.Sheet2ID;
     end;
  end;

end;


function TXLSExternSheet.GetSheetIDs(ExternID: integer; Var SupBookIndex, Sheet1ID, Sheet2ID: integer): integer;
Var lKey: String;
    CurEntry: TXLSExternSheetItem;
begin
  Result := 1;
  lKey := inttostr(ExternID);
  CurEntry := TXLSExternSheetItem(FindHashEntry(lKey));
  if CurEntry = nil then Result := -1;

  if Result = 1 then begin
     SupBookIndex :=  CurEntry.SupBookIndex;
     Sheet1ID := CurEntry.Sheet1ID;
     Sheet2ID := CurEntry.Sheet2ID;
  end;

end;

function TXLSExternSheet.GetReferredIndexes(Index: integer; Var SupBookIndex, Sheet1Index, Sheet2Index: integer): integer;
Var ExternID: integer;
begin
  ExternID := FReferredID[Index - 1];
  Result := GetSheetIndexes(ExternID, SupBookIndex, Sheet1Index, Sheet2Index);
end;


function TXLSExternSheet.GetSheetNames(ExternID: integer; Var SheetNames: WideString): integer;
Var Sheet1Index, Sheet2Index: integer;
    SupBookIndex: integer;
    SheetName: WideString;
begin

  Result := GetSheetIndexes(ExternID, SupBookIndex, Sheet1Index, Sheet2Index);
  if Result = 1 then begin
     if SupBookIndex <> SupBook.SelfBookIndex then begin
        //!!!!!
        Result := -1; 
     end;
  end;
  if Result = 1 then begin
     SheetName := GetSheetNameByIndex(Sheet1Index);
     if SheetName = '' then Result := -1;
  end;
  if Result = 1 then begin
     SheetNames := '''' + SheetName + '''';
     if Sheet1Index <> Sheet2Index then begin
        SheetName := GetSheetNameByIndex(Sheet2Index);
        if SheetName = '' then Result := -1;
        if Result = 1 then begin
           SheetNames := SheetNames + ':''' + SheetName + ''''; 
        end;
     end;
  end;
end;

function TXLSExternSheet.GetNameByID(ANameID: integer): widestring;
begin
  if Assigned(FGetNameByID) then
     FGetNameByID(ANameID, Result)
  else Result := '';
end;

function TXLSExternSheet.GetNameStoreIndexByID(ANameID: integer): integer;
begin
  if Assigned(FGetNameStoreIndexByID) then
     Result := FGetNameStoreIndexByID(ANameID)
  else Result := -1;
end;

function TXLSExternSheet.GetNameIDByName(Name: Widestring; CurSheetID: integer): integer;
begin
  if Assigned(FGetNameIDByName) then
     Result := FGetNameIDByName(Name, CurSheetID)
  else Result := -1;
end;

function TXLSExternSheet.GetSheetIDByName(SheetName: WideString): integer;
begin
  if Assigned(FGetSheetIDByName) then
     FGetSheetIDByName(SheetName, Result)
  else Result := -1;
end;

function TXLSExternSheet.GetSheetIndexByID(SheetID: integer): integer;
begin
  if Assigned(FGetSheetIndexByID) then
     FGetSheetIndexByID(SheetID, Result)
  else Result := -1;
end;

function TXLSExternSheet.TranslateExcel5ExternID(Excel5ExternID: integer): integer;
Var name: Widestring;
begin
  Result := 1;
  if Not(Assigned(FExcel5ExternID2Name)) then Result := -1;
  if Result = 1 then begin

     name := FExcel5ExternID2Name(Excel5ExternID);
     if name = '' then Result := -1;
  end;

  if Result = 1 then begin
     Result := GetExternID(name, name);
  end;
end;


{function TXLSExternSheet.GetSheetNameByID(SheetID: integer): WideString;
begin
  if Assigned(FGetSheetNameByID) then
     FGetSheetNameByID(SheetID, Result)
  else Result := '';
end;}


function TXLSExternSheet.GetSheetNameByIndex(SheetIndex: integer): WideString;
begin
  if Assigned(FGetSheetNameByIndex) then
     FGetSheetNameByIndex(SheetIndex, Result)
  else Result := '';
end;

function TXLSExternSheet.CreateEntry: THashEntry;
begin
  Result := TXLSExternSheetItem.Create;
end;


procedure TXLSExternSheet.RegisterExternalBook(ExtBook: TXLSExternalBook);
var item: TXLSExtBookItem;
begin
  if FExtraBooks.FindByUrl(ExtBook.Url) < 0 then begin
     item := TXLSExtBookItem.Create(ExtBook, false);
     FExtraBooks.Add(item);
  end;
end;


function TXLSExternSheet.ParseSupBook(Data: TXLSBlob): integer;
var supbookitem: TXLSSupBookItem;
    supbookindex: integer;
    extrabookindex: integer;
begin
  Result := 1;
  supbookindex := FSupBook.Parse(Data);
  if supbookindex >= 0 then begin
     supbookitem := FSupBook.GetItem(supbookindex);
     extrabookindex := FExtraBooks.FindByUrl(FExtraBooks.DecodeUrl(supbookitem.DocUrl));
     if extrabookindex >= 0 then begin
        FExtraBooks.SetSupBookIndex(extrabookindex, supbookindex);
     end; 
  end;
end;


{TXLSSupBookItem}
constructor TXLSSupBookItem.Create;
begin
  inherited Create;
  FSelfDoc := true;
  FIsAddonFunc := false;
  FFuncsHash := THashInteger.Create;
  //FAddinFuncName := '';             
end;

constructor TXLSSupBookItem.Create(Data: TXLSBlob);
begin
  inherited Create;
  FFuncsHash := THashInteger.Create;
  Parse(Data); 
end;

function TXLSSupBookItem.ParseExternalName(funcname: widestring): integer;
begin
   //if FIsAddonFunc then begin
   AddAddonFunction(funcname);  
   //end;
   Result := 1;
end;


function TXLSSupBookItem.GetAddonFunctionName(index: integer): widestring;
begin
   if (index < 1) or (index > Length(FFuncs)) then begin 
      Result := '';
   end else begin
      Result := FFuncs[index - 1];
   end;
end;

function TXLSSupBookItem.AddAddonFunction(funcname: widestring): integer;
begin
   Result := Length(FFuncs) + 1;
   SetLength(FFuncs, Result);
   FFuncs[Result - 1] := funcname;
   FFuncsHash[funcname] := Result;
end;

function TXLSSupBookItem.RegisterAddonFunctionName(funcname: widestring): integer;
begin
   Result := FFuncsHash[funcname];
   if Result <= 0 then begin
      Result := AddAddonFunction(funcname);
   end;
end;

function TXLSSupBookItem.Parse(Data: TXLSBlob): integer;
Var len: longword;
    offset: longword;
    numofsheet: word;
    val: word;
    i: integer;
begin
  Result := 1;
  offset := 0;
  len := Data.DataLength;
  while offset < len do begin
     numofsheet := Data.GetWord(offset); Inc(offset, 2);
     val := Data.GetWord(offset);
     if val = $0401 then begin
        //internal
        FSelfDoc := true;
        inc(offset, 2);
     end else if (numofsheet = 1) and (val = $3A01) then begin
        FIsAddonFunc := true;
        break;
     end else begin
        //external
        FDocUrl := Data.GetBiffString(offset, false, true);  
        FSelfDoc := false;
        SetLength(FSheets, numofsheet);  
        for i := 1 to numofsheet do begin
           FSheets[i - 1] := Data.GetBiffString(offset, false, true);  
        end;
     end;
  end;
end;




destructor TXLSSupBookItem.Destroy;  
begin
  SetLength(FSheets, 0);
  SetLength(FFuncs, 0);
  FFuncsHash.Free;
  inherited Destroy;
end;

function TXLSSupBookItem.GetData(SheetCount: integer): TXLSBlob;
Var len: integer;
    nmlen: integer;
    i, shcnt, fncnt: integer;
    lfuncname: string;
begin
  if FSelfDoc then begin
     Result := TXLSBlob.Create(4 + 4);
     Result.AddWord($01AE); 
     Result.AddWord($0004); 
     Result.AddWord(SheetCount); 
     Result.AddWord($0401); 
  end else if FIsAddonFunc then begin
     fncnt := Length(FFuncs);
     len := 4 + 4;
     if fncnt > 0 then begin
        for i := 0 to fncnt - 1 do begin
           lfuncname := FFuncs[i];
           len := len + 4 + 6 + 1 + 1 + Length(lfuncname) * 2 + 4;
        end;
     end;

     Result := TXLSBlob.Create(len);

     Result.AddWord($01AE); 
     Result.AddWord($0004); 
     Result.AddWord($0001); 
     Result.AddWord($3A01); 
     if fncnt > 0 then begin
        for i := 0 to fncnt - 1 do begin
           lfuncname := FFuncs[i];
           Result.AddWord($0023);  //External name 
           Result.AddWord(6 + 1 + 1 + Length(lfuncname) * 2 + 4); 
           Result.AddWord($0000); 
           Result.AddWord($0000); 
           Result.AddWord($0000); 
           Result.AddByte(Length(lfuncname)); 
           Result.AddByte($01); 
           Result.AddWideString(lfuncname);
           Result.AddByte($02);
           Result.AddByte($00);
           Result.AddByte($1C);
           Result.AddByte($17);
        end;
     end;
  
  end else begin
     len := 4 + 2;
     len := len + 3 + Length(FDocUrl) * 2; 
//     len := len + 3 + Length(FDocUrl); 
     shcnt := Length(FSheets);
     if shcnt > 0 then begin
        for i := 0 to shcnt - 1 do begin
           len := len + 3 + Length(FSheets[i]) * 2; 
        end; 
     end;
     nmlen := 0;
     fncnt := Length(FFuncs);
     if fncnt > 0 then begin
        for i := 0 to fncnt - 1 do begin
           lfuncname := FFuncs[i];
           nmlen := nmlen + 4 + 6 + 1 + 1 + Length(lfuncname) * 2 + 2;
        end; 
     end;
     Result := TXLSBlob.Create(len + nmlen);
     Result.AddWord($01AE); 
     Result.AddWord(len - 4); 
     Result.AddWord(shcnt); 

     Result.AddWord(Length(FDocUrl));
     Result.AddByte($01);
     Result.AddWideString(FDocUrl);
//     Result.AddByte($00);
//     Result.AddString(AnsiString(FDocUrl));
       
     if shcnt > 0 then begin
        for i := 0 to shcnt - 1 do begin
           Result.AddWord(Length(FSheets[i]));
           Result.AddByte($01);
           Result.AddWideString(FSheets[i]);
        end; 
     end;

     if fncnt > 0 then begin
        for i := 0 to fncnt - 1 do begin
           lfuncname := FFuncs[i];
           Result.AddWord($0023);  //External name 
           Result.AddWord(6 + 1 + 1 + Length(lfuncname) * 2 + 2); 
           Result.AddWord($0000); 
           Result.AddWord($0000); 
           Result.AddWord($0000); 
           Result.AddByte(Length(lfuncname)); 
           Result.AddByte($01); 
           Result.AddWideString(lfuncname);
           Result.AddWord($0000); 
        end;
     end;
  end; 
end;


procedure TXLSSupBookItem.AddSheetName(AName: widestring);
var cnt: integer;
begin
  cnt := Length(FSheets);
  SetLength(FSheets, cnt + 1);  
  FSheets[cnt] := AName;  
end;


{TXLSSupBook}
constructor TXLSSupBook.Create;
begin
  inherited Create;
  FSelfIndex := -1;
  FAddonFuncIndex := -1;
  FArr := TObjectArray.Create;
end;

destructor TXLSSupBook.Destroy;
begin
  FArr.Free;
  inherited Destroy;
end;

function TXLSSupBook.GetSelfIndex: integer;
begin
  Result := FSelfIndex;
  if Result < 0 then Result := 0;
end;

procedure TXLSSupBook.AppendSelfBook;
Var ind: integer;
begin
  ind := FArr.Count;
  FSelfIndex := ind;
  FArr[ind] := TXLSSupBookItem.Create; 
end;

function TXLSSupBook.ParseExternalName(funcname: widestring): integer;
var item: TXLSSupBookItem;
begin
   if FArr.Count > 0 then begin
      item := TXLSSupBookItem(FArr[FArr.Count - 1]);
      item.ParseExternalName(funcname);  
   end;
   Result := 1; 
end;


function TXLSSupBook.Parse(Data: TXLSBlob): integer;
var
  item: TXLSSupBookItem;
  ind: integer;
begin
  item := TXLSSupBookItem.Create(data);
  ind := FArr.Count;
  FArr[ind] := item; 
  if item.IsAddonFunc then FAddonFuncIndex := ind;
  if item.IsSelfDoc then FSelfIndex := ind;
  Result := ind;
end;


function TXLSSupBook.GetItem(index: integer): TXLSSupBookItem;
begin
  Result := TXLSSupBookItem(FArr[index]);
end;


function TXLSSupBook.GetAddonFunctionName(supbookindex, index: integer): widestring;
var 
   item: TXLSSupBookItem;
begin
   item := TXLSSupBookItem(FArr[supbookindex]);
   Result := item.GetAddonFunctionName(index);
end;

function TXLSSupBook.RegisterAddonFunctionName(supbookindex: integer; funcname: widestring): integer;
var 
   item: TXLSSupBookItem;
begin
   item := TXLSSupBookItem(FArr[supbookindex]);
   Result := item.RegisterAddonFunctionName(funcname);
end;

{function TXLSSupBook.CreateAddonFunctionItem: integer;
var 
   item: TXLSSupBookItem;
begin
  if FArr.Count < 1 then AppendSelfBook();
  item := TXLSSupBookItem.Create;
  item.FSelfDoc := false;
  item.FIsAddonFunc := true;
  FAddonFuncIndex := FArr.Count;
  FArr[FAddonFuncIndex] := item; 
  Result := FAddonFuncIndex;
end;}
                                         
function TXLSSupBook.CreateItem(b: TXLSExternalBook): integer;
var item: TXLSSupBookItem;
    i, cnt: integer; 
begin
  if FArr.Count < 1 then AppendSelfBook();
  item := TXLSSupBookItem.Create;
  item.FSelfDoc := false;
  item.FDocUrl := b.EncodedUrl;
  item.FIsAddonFunc := b.IsAddonFunc;
  if not(item.FIsAddonFunc) then begin
     //add sheets
     cnt := b.SheetsCount;
     if cnt > 0 then begin
        for i := 1 to cnt do begin
          item.AddSheetName(b.GetSheetName(i)); 
        end;
     end;
  end; 
  Result := FArr.Count;
  FArr[Result] := item; 
end;


function TXLSSupBook.Store(DataList: TXLSBlobList; SheetsCount: integer): integer;
var i, cnt: integer;
    item: TXLSSupBookItem;
    data: TXLSBlob;
begin
  Result := 1;
  if FArr.Count < 1 then AppendSelfBook();
  cnt := FArr.Count;
  for i := 0 to cnt - 1 do begin
     item := TXLSSupBookItem(FArr[i]);
     data := item.GetData(SheetsCount);
     DataList.Append(data); 
  end;
end;


{TXLSExtBookItem}
constructor TXLSExtBookItem.Create(ABook: TXLSExternalBook; ADestroy: boolean);
begin
  inherited Create;
  FBook := ABook;
  FDestroy := ADestroy;
  FSupBookIndex := -1;
end;

destructor TXLSExtBookItem.Destroy;
begin
  if FDestroy then FBook.Free; 
  inherited Destroy;
end;

procedure TXLSExtBookItem.SetSupBookIndex(AIndex: integer);
begin
  FSupBookIndex := AIndex;
end;

function TXLSExtBookItem.FuncExists(FuncName: widestring): boolean;
begin
  Result := FBook.FuncExists(FuncName);
end;


function TXLSExtBookItem.GetFunctionEntry(FuncName: widestring): THashFuncEntry;
begin
  Result := FBook.GetFunctionEntry(FuncName);
end;


{TXLSExtBookList} 
constructor TXLSExtBookList.Create;
begin
  inherited Create; 
  FCount := 0;
  SetExtraFunctions;
end;

destructor TXLSExtBookList.Destroy;
var i: integer;
begin
  if FCount > 0 then begin
     for i := 0 to FCount - 1 do begin
       FArr[i].Free;      
     end;
  end;                                                    
  inherited Destroy;
end;

procedure TXLSExtBookList.Add(item: TXLSExtBookItem);
begin
  Inc(FCount);
  SetLength(FArr, FCount);
  FArr[FCount - 1] := item;
end;

function TXLSExtBookList.BuildExtraFunctions: TXLSExternalBook;
begin
  Result := TXLSExternalBook.Create('');
  Result.AddFunc('ACCRINT'     ,     0,            1,     -1{5-7},               1,       0);  
  Result.AddFunc('ACCRINTM'    ,     1,            1,     -1{3-5},               1,       0);  
  Result.AddFunc('AMORDEGRC'   ,     2,            1,     -1{6-7},               1,       0);
  Result.AddFunc('AMORLINC'    ,     3,            1,     -1{6-7},               1,       0);
  Result.AddFunc('BESSELI'     ,     4,            1,      2,                    1,       0);
  Result.AddFunc('BESSELJ'     ,     5,            1,      2,                    1,       0);
  Result.AddFunc('BESSELK'     ,     6,            1,      2,                    1,       0);
  Result.AddFunc('BESSELY'     ,     7,            1,      2,                    1,       0);
  Result.AddFunc('BIN2DEC'     ,     8,            1,      1,                    1,       0);
  Result.AddFunc('BIN2HEX'     ,     9,            1,     -1{1-2},               1,       0);
  Result.AddFunc('BIN2OCT'     ,    10,            1,     -1{1-2},               1,       0);
  Result.AddFunc('COMPLEX'     ,    11,            1,     -1{2-3},               1,       0);
  Result.AddFunc('CONVERT'     ,    12,            1,      3,                    1,       0);
  Result.AddFunc('COUPDAYBS'   ,    13,            1,     -1{3-4},               1,       0);
  Result.AddFunc('COUPDAYS'    ,    14,            1,     -1{3-4},               1,       0);
  Result.AddFunc('COUPDAYSNC'  ,    15,            1,     -1{3-4},               1,       0);
  Result.AddFunc('COUPNCD'     ,    16,            1,     -1{3-4},               1,       0);
  Result.AddFunc('COUPNUM'     ,    17,            1,     -1{3-4},               1,       0);
  Result.AddFunc('COUPPCD'     ,    18,            1,     -1{3-4},               1,       0);
  Result.AddFunc('CUMIPMT'     ,    19,            1,      6,                    1,       0);
  Result.AddFunc('CUMPRINC'    ,    20,            1,      6,                    1,       0);
  Result.AddFunc('DEC2BIN'     ,    21,            1,     -1{1-2},               1,       0);
  Result.AddFunc('DEC2HEX'     ,    22,            1,     -1{1-2},               1,       0);
  Result.AddFunc('DEC2OCT'     ,    23,            1,     -1{1-2},               1,       0);
  Result.AddFunc('DELTA'       ,    24,            1,     -1{1-2},               1,       0);
  Result.AddFunc('DISC'        ,    25,            1,     -1{4-5},               1,       0);
  Result.AddFunc('DOLLARDE'    ,    26,            1,      2,                    1,       0);
  Result.AddFunc('DOLLARFR'    ,    27,            1,      2,                    1,       0);
  Result.AddFunc('DURATION'    ,    28,            1,     -1{5-6},               1,       0);
  Result.AddFunc('EDATE'       ,    29,            1,      2,                    1,       0);
  Result.AddFunc('EFFECT'      ,    30,            1,      2,                    1,       0);
  Result.AddFunc('EOMONTH'     ,    31,            1,      2,                    1,       0);
  Result.AddFunc('ERF'         ,    32,            1,     -1{1-2},               1,       0);
  Result.AddFunc('ERFC'        ,    33,            1,      1,                    1,       0);
  Result.AddFunc('FACTDOUBLE'  ,    34,            1,      1,                    1,       0);
  Result.AddFunc('FVSCHEDULE'  ,    35,            1,      2,                    1,       0, '12');
  Result.AddFunc('GCD'         ,    36,            1,     -1,                    0,       0);
  Result.AddFunc('GESTEP'      ,    37,            1,     -1{1-2},               1,       0);
  Result.AddFunc('HEX2BIN'     ,    38,            1,     -1{1-2},               1,       0);
  Result.AddFunc('HEX2DEC'     ,    39,            1,      1,                    1,       0);
  Result.AddFunc('HEC2OCT'     ,    40,            1,     -1{1-2},               1,       0);
  Result.AddFunc('IMABS'       ,    41,            1,      1,                    1,       0);
  Result.AddFunc('IMAGINARY'   ,    42,            1,      1,                    1,       0);
  Result.AddFunc('IMARGUMENT'  ,    43,            1,      1,                    1,       0);
  Result.AddFunc('IMCONJUGATE' ,    44,            1,      1,                    1,       0);
  Result.AddFunc('IMCOS'       ,    45,            1,      1,                    1,       0);
  Result.AddFunc('IMDIV'       ,    46,            1,      2,                    1,       0);
  Result.AddFunc('IMEXP'       ,    47,            1,      1,                    1,       0);
  Result.AddFunc('IMLN'        ,    48,            1,      1,                    1,       0);
  Result.AddFunc('IMLOG10'     ,    49,            1,      1,                    1,       0);
  Result.AddFunc('IMLOG2'      ,    50,            1,      1,                    1,       0);
  Result.AddFunc('IMPOWER'     ,    51,            1,      2,                    1,       0);
  Result.AddFunc('IMPRODUCT'   ,    52,            1,     -1,                    0,       0);
  Result.AddFunc('IMREAL'      ,    53,            1,      1,                    1,       0);
  Result.AddFunc('IMSIN'       ,    54,            1,      1,                    1,       0);
  Result.AddFunc('IMSQRT'      ,    55,            1,      1,                    1,       0);
  Result.AddFunc('IMSUB'       ,    56,            1,      2,                    1,       0);
  Result.AddFunc('IMSUM'       ,    57,            1,     -1,                    0,       0);
  Result.AddFunc('INTRATE'     ,    58,            1,     -1{4-5},               1,       0);
  Result.AddFunc('ISEVEN'      ,    59,            1,      1,                    1,       0);
  Result.AddFunc('ISODD'       ,    60,            1,      1,                    1,       0);
  Result.AddFunc('LCM'         ,    61,            1,     -1,                    0,       0);
  Result.AddFunc('MDURATION'   ,    62,            1,     -1{5-6},               1,       0);
  Result.AddFunc('MROUND'      ,    63,            1,      2,                    1,       0);
  Result.AddFunc('MULTINOMIAL' ,    64,            1,     -1,                    0,       0);
  Result.AddFunc('NETWORKDAYS' ,    65,            1,     -1{2-3},               1,       0, '110');
  Result.AddFunc('NOMINAL'     ,    66,            1,      2,                    1,       0);
  Result.AddFunc('OCT2BIN'     ,    67,            1,     -1{1-2},               1,       0);
  Result.AddFunc('OCT2DEC'     ,    68,            1,      1,                    1,       0);
  Result.AddFunc('OCT2HEX'     ,    69,            1,     -1{1-2},               1,       0);
  Result.AddFunc('ODDFPRICE'   ,    70,            1,     -1{8-9},               1,       0);
  Result.AddFunc('ODDFYIELD'   ,    71,            1,     -1{8-9},               1,       0);
  Result.AddFunc('ODDLPRICE'   ,    72,            1,     -1{7-8},               1,       0);
  Result.AddFunc('ODDLYIELD'   ,    73,            1,     -1{7-8},               1,       0);
  Result.AddFunc('PRICE'       ,    74,            1,     -1{6-7},               1,       0);
  Result.AddFunc('PRICEDISC'   ,    75,            1,     -1{4-5},               1,       0);
  Result.AddFunc('PRICEMAT'    ,    76,            1,     -1{5-6},               1,       0);
  Result.AddFunc('QUOTIENT'    ,    77,            1,      2,                    1,       0);
  Result.AddFunc('RANDBETWEEN' ,    78,            1,      2,                    1,       1);
  Result.AddFunc('RECEIVED'    ,    79,            1,     -1{4-5},               1,       0);
  Result.AddFunc('SERIESSUM'   ,    80,            1,      4,                    1,       0, '1110');
  Result.AddFunc('SQRTPI'      ,    81,            1,      2,                    1,       0);
  Result.AddFunc('TBILLEQ'     ,    82,            1,      3,                    1,       0);
  Result.AddFunc('TBILLPRICE'  ,    83,            1,      3,                    1,       0);
  Result.AddFunc('TBILLYIELD'  ,    84,            1,      3,                    1,       0);
  Result.AddFunc('WEEKNUM'     ,    85,            1,     -1{1-2},               1,       0);
  Result.AddFunc('WORKDAY'     ,    86,            1,     -1{2-3},               1,       0, '110');
  Result.AddFunc('XIRR'        ,    87,            1,     -1{2-3},               0,       0, '001');
  Result.AddFunc('XNPV'        ,    88,            1,      3,                    0,       0, '100');
  Result.AddFunc('YEARFRAC'    ,    89,            1,     -1{2-3},               1,       0);
  Result.AddFunc('YIELD'       ,    90,            1,     -1{6-7},               1,       0);
  Result.AddFunc('YIELDDISC'   ,    91,            1,     -1{4-5},               1,       0);
  Result.AddFunc('YIELDMAT'    ,    92,            1,     -1{5-6},               1,       0);
end;

procedure TXLSExtBookList.SetExtraFunctions;
var item: TXLSExtBookItem;
begin
  item := TXLSExtBookItem.Create(BuildExtraFunctions, true);
  Add(item);
end;

function TXLSExtBookList.GetExtraBookIndex(FuncName: WideString): integer;
var i: integer;
begin
  Result := -1;
  if FCount > 0 then begin
     for i := 0 to FCount - 1 do begin
       if FArr[i].FuncExists(FuncName) then begin
          Result := i;
          break;
       end;  
     end;
  end;
end;

function TXLSExtBookList.GetExtraBookFunctionEntry(AExtraBookIndex: integer; FuncName: Widestring):THashFuncEntry; 
begin
  if (AExtraBookIndex >= 0) and (AExtraBookIndex < FCount) then begin
     Result := FArr[AExtraBookIndex].GetFunctionEntry(FuncName);
  end else begin
     Result := nil;
  end;
end;


function TXLSExtBookList.GetSupBookIndex(AExtraBookIndex: integer): integer;
begin
  if (AExtraBookIndex >= 0) and (AExtraBookIndex < FCount) then begin
     Result := FArr[AExtraBookIndex].SupBookIndex;
  end else begin
     Result := -1;
  end;
end;

procedure TXLSExtBookList.SetSupBookIndex(AExtraBookIndex: integer; ASupBookIndex: integer);
begin
  if (AExtraBookIndex >= 0) and (AExtraBookIndex < FCount) then begin
     FArr[AExtraBookIndex].SetSupBookIndex(ASupBookIndex);
  end;                                  
end;

function TXLSExtBookList.Sup2ExtraIndex(SupBookIndex: integer): integer;
var i: integer;
begin
  Result := -1;
  if (SupBookIndex >= 0) and (FCount > 0) then begin
     for i := 0 to FCount - 1 do begin
       if FArr[i].SupBookIndex = SupBookIndex then begin
          Result := i;
          break;
       end;
     end;
  end;
end;

function TXLSExtBookList.GetItem(AExtraBookIndex: integer): TXLSExtBookItem;
begin
  if (AExtraBookIndex >= 0) and (AExtraBookIndex < FCount) then begin
     Result := FArr[AExtraBookIndex];
  end else begin
     Result := nil;
  end;                                  
end;

function TXLSExtBookList.FindByUrl(AUrl: widestring): integer;
var i: integer;
begin
  Result := -1;
  if FCount > 0 then begin
     for i := 0 to FCount - 1 do begin
         if FArr[i].ExternalBook.Url = AUrl then begin
            Result := i;
            break;
         end;
     end;
  end; 
end;


function TXLSExtBookList.DecodeUrl(url: widestring): widestring;
var cnt, i: integer;
    ch: widechar;
begin                            
  cnt := length(url);
  i := 1;
  Result := '';
  if (cnt > 0) and (url[i] = widechar($0001)) then begin
     inc(i); //skip chEncode
     while i <= cnt do begin
        ch := url[i];
        if (ch = widechar($0001)) and (cnt > i) then begin 
           //chVolume
           Result := Result + url[i+1] + ':\';
        end else if ch = widechar($0002) then begin
           //chSameVolume
           Result := Result + 'C:\';
        end else if ch = widechar($0003) then begin
           //chDownDir
           Result := Result + '\';
        end else if ch = widechar($0004) then begin
           //chUpDir
           Result := Result + '..\';
        end;
        inc(i);
     end;
  end else begin
     Result := url;
  end;
end;


end.

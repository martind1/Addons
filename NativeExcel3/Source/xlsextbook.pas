//////////////////////////////////////////////////////////////////////////////
//
//	Unit:         xlsextbook
//
//
//      Description:  External workbook
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

unit xlsextbook;
{$I xlsdef.inc}

{$Q-}
{$R-}

interface
uses xlslist, xlshash;

type

  THashFuncEntry = class (THashEntry)
  public
    FPtg:      integer;
    FArgsCnt:  integer;
    FRetClass: integer;
    FClass:    integer;
    FVol:      integer;   
    FArgClass: array of byte;
    FArgClassLen: smallint;
    FName: widestring;
    function GetArgClass(ArgNo: integer): byte;
    property ArgClass[Index: integer]: byte read GetArgClass;
  end;

  THashFunc = class(THash)
  protected
    function  CreateEntry: THashEntry; override;
  private
    FPtgHash: THashWideString;
    function  GetValue(aFuncName: WideString): THashFuncEntry;
    function  GetName(aPtg: integer): WideString;
    function  GetArgsCnt(aPtg: integer): integer;
  public
    property  Values[Key: WideString]: THashFuncEntry read GetValue; default;
    property  FuncName[aPtg: integer]: WideString read GetName;
    property  ArgsCnt[aPtg: integer]: integer read GetArgsCnt;
    constructor Create;
    destructor Destroy; override;
    procedure SetValue(aFuncName: WideString; aPtg, aRetClass, aArgsCnt, aClass, aVol: integer); overload;
    procedure SetValue(aFuncName: WideString; aPtg, aRetClass, aArgsCnt, aClass, aVol: integer; ArgsClass: string); overload;
  end;

  TXLSExternalBook = class
  private
    FUrl: widestring;
    FEncodedUrl: widestring;
    FSheets: TXLSStringList;
    FFuncs:  THashFunc; 
    function EncodeUrl(url: widestring): widestring;
    function GetSheetsCount: integer;
    function GetFuncsCount: integer;
    function GetIsAddonFunc: boolean;
  public                               
    Constructor Create(AUrl: widestring);
    Destructor Destroy; override;
    procedure AddSheet(ASheetName: widestring);
    procedure AddFunc(AFuncName: widestring); overload;
    procedure AddFunc(aFuncName: WideString; aPtg, aRetClass, aArgsCnt, aClass, aVol: integer); overload;
    procedure AddFunc(aFuncName: WideString; aPtg, aRetClass, aArgsCnt, aClass, aVol: integer; ArgsClass: string); overload;
    function FuncExists(AFuncName: widestring): boolean;
    property Url: widestring read  FUrl;
    property SheetsCount: integer read GetSheetsCount;
    property FuncsCount: integer read GetFuncsCount;
    function GetFunctionEntry(AFuncName: widestring): THashFuncEntry;
    property EncodedUrl: widestring read FEncodedUrl;
    function GetSheetName(SheetIndex: integer): widestring;
    property IsAddonFunc: boolean read GetIsAddonFunc;
  end;

implementation
uses sysutils;


{THashFuncEntry}
function THashFuncEntry.GetArgClass(ArgNo: integer): byte;
begin
  if FArgClassLen < ArgNo then Result := FClass
  else Result := FArgClass[ArgNo - 1];
end;

{THashFunc}
constructor THashFunc.Create;
begin
  inherited Create;
  FPtgHash := THashWideString.Create; 
end;

destructor THashFunc.Destroy;
begin
  FPtgHash.Free;
  inherited Destroy;
end;

function THashFunc.CreateEntry: THashEntry;
begin
  Result := THashFuncEntry.Create;
end;

function THashFunc.GetValue(aFuncName: widestring): THashFuncEntry;
var
  CurEntry: THashFuncEntry;
begin
  CurEntry := THashFuncEntry(FindHashEntry(aFuncName));
  if CurEntry = nil then
     Result := nil
  else
     Result := CurEntry;
end;

function THashFunc.GetName(aPtg: integer): widestring;
begin
  Result := FPtgHash[inttostr(aPtg)];
end;

function  THashFunc.GetArgsCnt(aPtg: integer): integer;
Var lFuncName: widestring;
    CurEntry: THashFuncEntry;
begin
  Result := -2;
  lFuncName := GetName(aPtg);
  if lFuncName <> '' then begin
     CurEntry := Values[lFuncName];
     if Assigned(CurEntry) then Result := CurEntry.FArgsCnt;
  end;
end;

procedure THashFunc.SetValue(aFuncName: widestring; aPtg, aRetClass, aArgsCnt, aClass, aVol: integer);
var
  CurEntry: THashFuncEntry;
  lFuncName: widestring;
begin
  lFuncName := UpperCase(aFuncName);
  FPtgHash[inttostr(aPtg)] := lFuncName;
  CurEntry := THashFuncEntry(GetHashEntry(lFuncName));
  if CurEntry <> nil then begin
     CurEntry.FPtg      := aPtg;
     CurEntry.FArgsCnt  := aArgsCnt;
     CurEntry.FClass    := aClass;
     CurEntry.FVol      := aVol;
     CurEntry.FRetClass := aRetClass; 
     CurEntry.FArgClassLen := 0;
     CurEntry.FName := aFuncName;
  end;
end;

procedure THashFunc.SetValue(aFuncName: widestring; aPtg, aRetClass, aArgsCnt, aClass, aVol: integer; ArgsClass: string);
var
  CurEntry: THashFuncEntry;
  i: integer;
  lFuncName: widestring;
begin
  lFuncName := UpperCase(aFuncName);
  FPtgHash[inttostr(aPtg)] := lFuncName;
  CurEntry := THashFuncEntry(GetHashEntry(lFuncName));
  if CurEntry <> nil then begin
     CurEntry.FPtg      := aPtg;
     CurEntry.FArgsCnt  := aArgsCnt;
     CurEntry.FClass    := aClass;
     CurEntry.FVol      := aVol;
     CurEntry.FRetClass := aRetClass; 
     CurEntry.FArgClassLen := Length(ArgsClass);
     CurEntry.FName := aFuncName;
     if CurEntry.FArgClassLen > 0 then begin
        SetLength(CurEntry.FArgClass, CurEntry.FArgClassLen);
        for i := 1 to CurEntry.FArgClassLen do begin
           CurEntry.FArgClass[i - 1] := strtoint(ArgsClass[i] + '');
        end;
     end; 
  end;
end;

Constructor TXLSExternalBook.Create(AUrl: widestring);
begin
  inherited Create;
  FUrl := AUrl;
  FEncodedUrl := EncodeUrl(FUrl);
  FSheets := TXLSStringList.Create();
  FFuncs := THashFunc.Create();
end;

Destructor TXLSExternalBook.Destroy;
begin
  FSheets.Free;
  FFuncs.Free;
  inherited Destroy; 
end;

procedure TXLSExternalBook.AddSheet(ASheetName: widestring);
begin
  FSheets.AddValue(ASheetName);
end;

procedure TXLSExternalBook.AddFunc(AFuncName: widestring);
begin
  FFuncs.SetValue(AFuncName, FuncsCount, 1, -1, 0, 0);
end;

procedure TXLSExternalBook.AddFunc(aFuncName: WideString; aPtg, aRetClass, aArgsCnt, aClass, aVol: integer); 
begin
  FFuncs.SetValue(aFuncName, aPtg, aRetClass, aArgsCnt, aClass, aVol); 
end;

procedure TXLSExternalBook.AddFunc(aFuncName: WideString; aPtg, aRetClass, aArgsCnt, aClass, aVol: integer; ArgsClass: string);
begin
  FFuncs.SetValue(aFuncName, aPtg, aRetClass, aArgsCnt, aClass, aVol, ArgsClass);
end;


function TXLSExternalBook.FuncExists(AFuncName: widestring): boolean;
begin
  Result := FFuncs.Exist[UpperCase(AFuncName)];
end;                           


function TXLSExternalBook.EncodeUrl(url: widestring): widestring;
var cnt, i: integer;
    ch: widechar;
    encoded: boolean;               
begin                            
  cnt := length(url);
  i := 1;
  Result := '';
  encoded := false;

  while i <= cnt do begin
     ch := url[i];
     if (i = 1) and (cnt > i) and (url[i + 1] = ':') then begin
        //chVolume
        Result := Result + widechar($0001) + ch;
        inc(i);
        if (cnt > i) and (url[i + 1] = '\') then inc(i);
        encoded := true;
     end else if ch = '\' then begin
        //chDownDir
        Result := Result + widechar($0003);
        encoded := true;
     end else if (ch = '.') and (cnt > i) and (url[i + 1] = '.') then begin
        //chUpDir
        inc(i);
        if (cnt > i) and (url[i + 1] = '\') then inc(i);
        Result := Result + widechar($0004);
        encoded := true;
     end else begin
        Result := Result + url[i];
     end;
     inc(i);
  end;
  //add chEncode
  if encoded then Result := widechar($0001) + Result;
end;



function TXLSExternalBook.GetSheetsCount: integer;
begin
  Result := FSheets.ListSize;
end;

function TXLSExternalBook.GetFuncsCount: integer;
begin
  Result := FFuncs.Count;
end;


function TXLSExternalBook.GetFunctionEntry(AFuncName: widestring): THashFuncEntry;
begin
  Result := FFuncs.Values[UpperCase(AFuncName)];
end;


function TXLSExternalBook.GetSheetName(SheetIndex: integer): widestring;
begin
  //one-index
  Result := FSheets.Value[SheetIndex - 1];
end;

function TXLSExternalBook.GetIsAddonFunc: boolean;
begin
  Result := FUrl = '';
end;

end.
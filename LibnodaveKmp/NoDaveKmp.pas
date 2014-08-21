unit NodaveKmp;
(* S7 Schnittstelle per Nodave dll (Schwenk, Rothenbacher)
   benötigt Nodave Komponente (http://sourceforge.net/projects/libnodave/?_test=b)

   Erweiterung um Advise List

   Simul: Schreibt Sim() in die SPS
   Das alte Simul gilt nicht mehr: es gibt immer eine (Soft-)SPS

01.04.12 md Erstellt (OpcS7Kmp)
*)
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,
  NoDaveComponent,
  DPos_Kmp;


type
  TNodaveKmp = class(TComponent)
  private
    { Private-Deklarationen }
    FNoDave: TNoDave;
    FConnected: boolean;
    FSimul: boolean;
    FReadBeforeWrite: boolean;
    FLbRead: TListBox;
    FLbWrite: TListBox;
    FArea: TNoDaveArea;  //daveDB
    procedure AddAdvise(DB, Start: integer; Typ: string);
    procedure LbReadSetValue(DB, Adr: integer; aTyp, aValue: string);
    procedure LbWriteSetValue(DB, Adr: integer; aTyp, aValue: string);
    function LbReadGetValue(DB, Adr: integer; aTyp: string): string;
    function AdvTyp(DB, Start: integer): string;
  protected
    { Protected-Deklarationen }
    InWrite: boolean;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure SetStatus(aStatus: integer; aMeldung: string);
  public
    { Public-Deklarationen }
    AdvList: TStringList;
    Status: integer;    //0=OK
    Meldung: string;    //Fehlermeldung
    AdvInterval: integer;
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
    procedure Connect;
    procedure Disconnect;
    procedure RemoveItems;
    procedure Sim(DB, Adr: integer; Typ, Str: string);
    procedure OnAdvise(aNoDave: TNoDave);
    function Read(Varname: string): string;
    procedure Write(Varname, aValue: string);

    procedure WriteString(DB, Adr: integer; S: string);
    procedure WriteDInt(DB, Adr: integer; I: integer);
    procedure WriteInt(DB, Adr: integer; I: smallint);
    procedure WriteWord(DB, Adr: integer; I: Word);
    procedure WriteDInts(DB, Adr: integer; Ints: array of integer);
    procedure WriteInts(DB, Adr: integer; Ints: array of integer);
    function ReadDInt(DB, Adr: integer; Adv: boolean): integer;
    function ReadInt(DB, Adr: integer; Adv: boolean): integer;
    function ReadWord(DB, Adr: integer; Adv: boolean): integer;
  published
    { Published-Deklarationen }
    property NoDave: TNoDave read FNoDave write FNoDave;
    property Connected: boolean read FConnected write FConnected;
    property Simul: boolean read FSimul write FSimul;
    property ReadBeforeWrite: boolean read FReadBeforeWrite write FReadBeforeWrite;
    property LbRead: TListBox read FLbRead write FLbRead;
    property LbWrite: TListBox read FLbWrite write FLbWrite;
  end;

implementation

uses
  Prots, Err__Kmp, nstr_kmp,
  NoDave;

{ TNodaveKmp }

constructor TNodaveKmp.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AdvList := TStringList.Create;
  //AdvList.Sorted := true; //Vorauss. für Duplicates
  //AdvList.Duplicates := dupIgnore;
  FArea := NoDaveComponent.daveDB;  //Datablock
end;

destructor TNodaveKmp.Destroy;
begin
  Disconnect;
  AdvList.Free;
  inherited Destroy;
end;

procedure TNodaveKmp.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if (Operation = opRemove) then
  begin
    if (AComponent = LbRead) then
      LbRead := nil else
    if (AComponent = LbWrite) then
      LbWrite := nil;
    if (AComponent = FNodave) then
      FNodave := nil;
  end;
  inherited Notification(AComponent, Operation);
end;

procedure TNodaveKmp.SetStatus(aStatus: integer; aMeldung: string);
begin
  Status := aStatus;
  Meldung := aMeldung;
end;

procedure TNodaveKmp.AddAdvise(DB, Start: integer; Typ: string);
// die Advicelist ist eine Liste der Advise-Items
// Ergebnisse stehen in lbRead.Items
var
  S1: string;
begin
  S1 := Format('%d.%d', [DB, Start]);
  AdvList.Values[S1] := Typ;
//05.04.12 beware. Wir haben noch kein Advise!  Nodave.Interval := AdvInterval;
end;

function TNodaveKmp.AdvTyp(DB, Start: integer): string;
// ergibt Typ oder '' wenn kein Advise
var
  S1: string;
begin
  S1 := Format('%d.%d', [DB, Start]);
  Result := AdvList.Values[S1];
end;

procedure TNodaveKmp.OnAdvise(aNoDave: TNoDave);
//ein Advise Event wurde ausgelöst
var
  Typ: string;
  DB, Start: integer;
  aValue: string;
begin
  if aNodave <> nil then
  begin
    DB := aNodave.DBNumber;
    Start := aNodave.BufOffs;
//    S1 := Format('%d.%d', [DB, Start]);
//    Typ := AdvList.Values[S1];
    Typ := AdvTyp(DB, Start);

    if Typ <> '' then
    begin
      // nur wenn in AdvList
      if SameText(Typ, 'DInt') then
      begin
        AValue := IntToStr(Nodave.GetDInt(0));
      end;
      if SameText(Typ, 'Int') then
      begin
        AValue := IntToStr(Nodave.GetInt(0));
      end;
      if SameText(Typ, 'W') then
      begin
        AValue := IntToStr(Nodave.GetWord(0));
      end;

      LbReadSetValue(DB, Start, Typ, aValue);
    end;
  end;

  // nächste Adv Aufgabe setzen:
  //todo
end;

procedure TNodaveKmp.LbReadSetValue(DB, Adr: integer; aTyp, aValue: string);
var
  S1, Varname: string;
begin
  if FLbRead <> nil then
  begin
    VarName := Format('DB%d.%s%04.4d', [DB, aTyp, Adr]);
    if aValue <> '' then
    begin
      S1 := aValue + ' | ' + TimeToStr(Now);
      if AdvList.Values[VarName] <> '' then
        S1 := S1 + ' | Adv';
      FLbRead.Items.Values[VarName] := S1;
    end else
    begin
      FLbRead.Items.Values[VarName] := '';
      //doch nicht (TWaKo.SpsWrite) FLbRead.Items.Add(VarName + '=');
    end;
  end;
end;

function TNodaveKmp.LbReadGetValue(DB, Adr: integer; aTyp: string): string;
var
  NextS: string;
  Varname: string;
begin
  Result := '';
  if FLbRead <> nil then
  begin
    VarName := Format('DB%d.%s%04.4d', [DB, aTyp, Adr]);
    Result := PStrTok(FLbRead.Items.Values[VarName], ' |', NextS, true);
  end;
end;

procedure TNodaveKmp.LbWriteSetValue(DB, Adr: integer; aTyp, aValue: string);
var
  Varname: string;
begin
  VarName := Format('DB%d.%s%04.4d', [DB, aTyp, Adr]);
  if FLbWrite <> nil then
  begin
    FLbWrite.Items.Values[VarName] := aValue;
    if aValue = '' then
      FLbWrite.Items.Add(VarName + '=');
  end;
  if FLbRead <> nil then
  begin
    if LbReadGetValue(DB, Adr, aTyp) <> '' then
      LbReadSetValue(DB, Adr, aTyp, aValue);
  end;
end;

procedure TNodaveKmp.Connect;
begin
//  if Simul then
//    FConnected := true else
  if not FConnected then
  begin
    Prot0('Nodave.Connect', [0]);
    NoDave.Connect;
    FConnected := true;
  end;
end;

procedure TNodaveKmp.Disconnect;
begin
//  if Simul then
//    FConnected := false else
  if FConnected then
  begin
    Prot0('Nodave.Disconnect', [0]);
    NoDave.DisConnect;
    FConnected := false;
  end;
end;

procedure TNodaveKmp.RemoveItems;
//Entfernt items. Für GWT.
var
  I: integer;
begin
  if FConnected then
  begin
    AdvList.Clear;
    if FLbRead <> nil then
      FLbRead.Items.Clear;
    if FLbWrite <> nil then
      FLbWrite.Items.Clear;
  end;
end;

(*** SPS Zugriff *************************************************************)

procedure TNodaveKmp.Sim(DB, Adr: integer; Typ, Str: string);
//Typ in DInt, Int, W (Word), Char
var
  S1, VarName: string;
  V_Longint, B_Longint: LongInt;
  V_Smallint, B_Smallint: Smallint;
  V_Word, B_Word: Word;
begin                {setzt SPS Read-Wert für Simulation: nur DInt Parameter}
  if Typ = '' then
    Typ := 'DInt';

  VarName := Format('DB%d,%s%d', [DB, Typ, Adr]);
  LbReadSetValue(DB, Adr, Typ, Str);

  if Simul then
  begin  //Soft-SPS befüllen
    Connect;
    if Str = '' then
      Str := '0';
    if SameText(Typ, 'DInt') then
    begin
      V_Longint := StrToInt(Str);
      B_Longint := daveSwapIed_32(V_Longint);
      NoDave.WriteBytes(FArea, DB, Adr, sizeof(B_Longint), @B_Longint);
    end;
    if SameText(Typ, 'Int') then
    begin
      V_Smallint := StrToInt(Str);
      B_Smallint := daveSwapIed_16(V_Smallint);
      NoDave.WriteBytes(FArea, DB, Adr, sizeof(B_Smallint), @B_Smallint);
    end;
    if SameText(Typ, 'W') then
    begin
      V_Word := StrToInt(Str);
      B_Word := daveSwapIed_16(V_Word);
      NoDave.WriteBytes(FArea, DB, Adr, sizeof(B_Word), @B_Word);
    end;
  end;
end;

procedure TNodaveKmp.Write(Varname, aValue: string);
// Test Verteiler
// DB90.DInt5 -> 90, 5, DInt
var
  S1, NextS: string;
  DB, Adr: integer;
begin
  S1 := PStrTok(Varname, '.', NextS);
  DB := StrToIntTol(S1);
  S1 := PStrTok('', '.', NextS);
  Adr := StrToIntTol(S1);
  if PosI('DInt', Varname) > 0 then
  begin
    WriteDInt(DB, Adr, StrToInt(aValue));
  end else
  if PosI('Int', Varname) > 0 then
  begin
    WriteInt(DB, Adr, StrToInt(aValue));
  end else
  if PosI('W', Varname) > 0 then
  begin
    WriteWord(DB, Adr, StrToInt(aValue));
  end else
  if PosI('Char', Varname) > 0 then
  begin
    WriteString(DB, Adr, aValue);
  end;
end;

function TNodaveKmp.Read(Varname: string): string;
// Test Verteiler
// DB90.DInt5 -> 90, 5, DInt
// DB90.DInt5.A -> 90, 5, DInt, Advise
var
  S1, NextS: string;
  DB, Adr: integer;
  Adv: boolean;
begin
  S1 := PStrTok(Varname, '.', NextS);
  DB := StrToIntTol(S1);
  S1 := PStrTok('', '.', NextS);
  Adr := StrToIntTol(S1);
  S1 := PStrTok('', '.', NextS);
  Adv := S1 <> '';
  if PosI('DInt', Varname) > 0 then
  begin
    Result := IntToStr(ReadDInt(DB, Adr, Adv));
  end else
  if PosI('Int', Varname) > 0 then
  begin
    Result := IntToStr(ReadInt(DB, Adr, Adv));
  end else
  if PosI('W', Varname) > 0 then
  begin
    Result := IntToStr(ReadWord(DB, Adr, Adv));
  end else
    Result := '?';
end;

procedure TNodaveKmp.WriteDInt(DB, Adr: integer; I: integer);
var
  S, VarName: string;
  B: Longint;
  Typ: string;
begin
  Typ := 'DInt';
  try
    VarName := Format('DB%d.%s%04.4d', [DB, Typ, Adr]);
    S := IntToStr(I);
    if Nodave <> nil then
    try
      Connect;
      //DoWriteValue(Address, 4, @Dummy);
      //TNoDave.WriteBytes(Area: TNoDaveArea; DB, Start, Size: Integer; Buffer: Pointer);
      B := daveSwapIed_32(I);
      NoDave.WriteBytes(FArea, DB, Adr, sizeof(B), @B);
    finally
    end else
    begin
      Application.ProcessMessages;
    end;
    LbWriteSetValue(DB, Adr, Typ, S);
    ProtP0('NDWriteDInt(%s,%s):%d', [VarName, S, B]);
  except on E:Exception do
    begin
      ProtP0('NDWriteDInt(%s,%s):%s', [VarName, S, E.Message]);
      SetStatus(21, E.Message);
    end;
  end;
end;

procedure TNodaveKmp.WriteInt(DB, Adr: integer; I: smallint);
var
  S, VarName: string;
  B: SmallInt;
  Typ: string;
begin
  Typ := 'Int';
  try
    VarName := Format('DB%d.Int%04.4d', [DB, Adr]);
    S := IntToStr(I);
    if Nodave <> nil then
    try
      Connect;
      //DoWriteValue(Address, 4, @Dummy);
      //TNoDave.WriteBytes(Area: TNoDaveArea; DB, Start, Size: Integer; Buffer: Pointer);
      B := daveSwapIed_16(I);
      NoDave.WriteBytes(FArea, DB, Adr, sizeof(B), @B);
    finally
    end else
    begin
      Application.ProcessMessages;
    end;
    LbWriteSetValue(DB, Adr, Typ, S);
    ProtP0('NDWriteInt(%s,%s):%d', [VarName, S, B]);
  except on E:Exception do
    begin
      ProtP0('NDWriteInt(%s,%s):%s', [VarName, S, E.Message]);
      SetStatus(21, E.Message);
    end;
  end;
end;

procedure TNodaveKmp.WriteWord(DB, Adr: integer; I: Word);
var
  S, VarName: string;
  B: Word;
  Typ: string;
begin
  Typ := 'W';
  try
    VarName := Format('DB%d.W%04.4d', [DB, Adr]);
    S := IntToStr(I);
    if Nodave <> nil then
    try
      Connect;
      //DoWriteValue(Address, 4, @Dummy);
      //TNoDave.WriteBytes(Area: TNoDaveArea; DB, Start, Size: Integer; Buffer: Pointer);
      B := daveSwapIed_16(I);
      NoDave.WriteBytes(FArea, DB, Adr, sizeof(B), @B);
    finally
    end else
    begin
      Application.ProcessMessages;
    end;
    LbWriteSetValue(DB, Adr, Typ, S);
    ProtP0('NDWriteWord(%s,%s):%d', [VarName, S, B]);
  except on E:Exception do
    begin
      ProtP0('NDWriteWord(%s,%s):%s', [VarName, S, E.Message]);
      SetStatus(21, E.Message);
    end;
  end;
end;

procedure TNodaveKmp.WriteString(DB, Adr: integer; S: string);
//der String hat bereits die richtige Länge
var
  VarName: string;
  AnS: AnsiString;
  I, L: integer;
  B: PAnsiChar;
  Typ: string;
begin
  Typ := 'Char';
  B := nil;
  try
    VarName := Format('DB%d.%s%04.4d', [DB, Typ, Adr]);
    if Nodave <> nil then
    try
      Connect;
      //DoWriteValue(Address, 4, @Dummy);
      //TNoDave.WriteBytes(Area: TNoDaveArea; DB, Start, Size: Integer; Buffer: Pointer);
      Ans := AnsiString(S);
      L := Length(Ans);
      GetMem(B, L);
      for I := 0 to L - 1 do
        B[I] := Ans[I + 1];
      NoDave.WriteBytes(FArea, DB, Adr, L, B);
    finally
      FreeMem(B);
      B := nil;
    end else
    begin
      Application.ProcessMessages;
    end;
    LbWriteSetValue(DB, Adr, Typ, S);
    ProtP0('NDWrite(%s):%s', [VarName, S]);
  except on E:Exception do
    begin
      ProtP0('NDWrite(%s,%s):%s', [VarName, S, E.Message]);
      SetStatus(21, E.Message);
    end;
  end;
end;

procedure TNodaveKmp.WriteDInts(DB, Adr: integer; Ints: array of integer);
var
  I, N: integer;
begin
  N := 0;
  for I := low(Ints) to high(Ints) do
  begin
    WriteDInt(DB, Adr + 4 * N, Ints[I]);
    Inc(N);
  end;
end;

procedure TNodaveKmp.WriteInts(DB, Adr: integer; Ints: array of integer);
var
  I, N: integer;
begin
  N := 0;
  for I := low(Ints) to high(Ints) do
  begin
    WriteInt(DB, Adr + 2 * N, Ints[I]);
    Inc(N);
  end;
end;

{* Lesen *}

function TNodaveKmp.ReadDInt(DB, Adr: integer; Adv: boolean): integer;
var
  Advise: boolean;
  S, VarName: string;
  B, R: LongInt;
  Typ: string;
begin
  Result := 0;
  Typ := 'DInt';
  VarName := Format('DB%d.%s%04.4d', [DB, Typ, Adr]);
  try
    Advise := Adv or (Nodave = nil);
    if Advise then
    begin
      S := LbReadGetValue(DB, Adr, Typ);
      if S = '' then
        Advise := false;
      AddAdvise(DB, Adr, Typ);
    end;
    if not Advise then
    begin
      if Nodave <> nil then
      try
        Connect;
        //ReadBytes(Area: TNoDaveArea; DB, Start, Size: Integer; Buffer: Pointer);
        //GetDInt(Address: Integer; Buffer: Pointer; BufOffs: Integer; BufLen: Integer): LongInt;
        Nodave.ReadBytes(FArea, DB, Adr, SizeOf(B), @B);
        R := Nodave.GetDInt(0, @B, 0, SizeOf(B));
        S := IntToStr(R);
      finally
      end else
      begin
        Application.ProcessMessages;
        S := '';
      end;
      ProtP0('NDRead(%s):%s', [VarName, S]);
    end;
    LbReadSetValue(DB, Adr, Typ, S);
    if Advise then
      SetStatus(12, 'Cache') else
      SetStatus(0, 'gelesen');
    Result := StrToIntTol(S);
  except on E:Exception do
    begin
      ProtP0('NDRead(%s):%s', [VarName, E.Message]);
      SetStatus(22, E.Message);
    end;
  end;
end;

function TNodaveKmp.ReadInt(DB, Adr: integer; Adv: boolean): integer;
var
  Advise: boolean;
  S, VarName: string;
  R: SmallInt;
  B: array[0..1] of Byte;
  Typ: string;
begin
  Result := 0;
  Typ := 'Int';
  VarName := Format('DB%d.%s%04.4d', [DB, Typ, Adr]);
  try
    Advise := Adv or (Nodave = nil);
    if Advise then
    begin
      S := LbReadGetValue(DB, Adr, Typ);
      if S = '' then
        Advise := false;
      AddAdvise(DB, Adr, Typ);
    end;
    if not Advise then
    begin
      if Nodave <> nil then
      try
        Connect;
        //ReadBytes(Area: TNoDaveArea; DB, Start, Size: Integer; Buffer: Pointer);
        //GetDInt(Address: Integer; Buffer: Pointer; BufOffs: Integer; BufLen: Integer): LongInt;
        Nodave.ReadBytes(FArea, DB, Adr, 2, @B);
        R := Nodave.GetInt(0, @B, 0, 2);
        S := IntToStr(R);
      finally
      end else
      begin
        Application.ProcessMessages;
        S := '';
      end;
      ProtP0('NDRead(%s):%s (%d,%d)', [VarName, S, B[0], B[1]]);
    end;
    LbReadSetValue(DB, Adr, Typ, S);
    if Advise then
      SetStatus(12, 'Cache') else
      SetStatus(0, 'gelesen');
    Result := StrToIntTol(S);
  except on E:Exception do
    begin
      ProtP0('NDRead(%s):%s', [VarName, E.Message]);
      SetStatus(22, E.Message);
    end;
  end;
end;

function TNodaveKmp.ReadWord(DB, Adr: integer; Adv: boolean): integer;
var
  Advise: boolean;
  S, VarName: string;
  B, R: Word;
  Typ: string;
begin
  Result := 0;
  Typ := 'W';
  VarName := Format('DB%d.%s%04.4d', [DB, Typ, Adr]);
  try
    Advise := Adv or (Nodave = nil);
    if Advise then
    begin
      S := LbReadGetValue(DB, Adr, Typ);
      if S = '' then
        Advise := false;
      AddAdvise(DB, Adr, Typ);
    end;
    if not Advise then
    begin
      if not Simul then
      try
        Connect;
        //ReadBytes(Area: TNoDaveArea; DB, Start, Size: Integer; Buffer: Pointer);
        //GetDInt(Address: Integer; Buffer: Pointer; BufOffs: Integer; BufLen: Integer): LongInt;
        Nodave.ReadBytes(FArea, DB, Adr, SizeOf(B), @B);
        R := Nodave.GetWord(0, @B, 0, SizeOf(B));
        S := IntToStr(R);
      finally
      end else
      begin
        Application.ProcessMessages;
        S := '';
      end;
      ProtP0('NDRead(%s):%s', [VarName, S]);
    end;
    LbReadSetValue(DB, Adr, Typ, S);
    if Advise then
      SetStatus(12, 'Cache') else
      SetStatus(0, 'gelesen');
    Result := StrToIntTol(S);
  except on E:Exception do
    begin
      ProtP0('NDRead(%s):%s', [VarName, E.Message]);
      SetStatus(22, E.Message);
    end;
  end;
end;

end.

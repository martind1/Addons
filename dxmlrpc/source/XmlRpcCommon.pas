
{*******************************************************}
{                                                       }
{ XML-RPC Library for Delphi, Kylix and DWPL (DXmlRpc)  }
{ XmlRpcCommon.pas                                      }
{                                                       }
{ for Delphi 6, 7                                       }
{ Release 2.0.0                                         }
{ Copyright (c) 2001-2003 by Team-DelphiXml-Rpc         }
{ e-mail: team-dxmlrpc@dwp42.org                        }
{ www: http://sourceforge.net/projects/delphixml-rpc/   }
{                                                       }
{ The initial developer of the code is                  }
{   Clifford E. Baeseman, codepunk@codepunk.com         }
{                                                       }
{ This file may be distributed and/or modified under    }
{ the terms of the GNU Lesser General Public License    }
{ (LGPL) version 2.1 as published by the Free Software  }
{ Foundation and appearing in the included file         }
{ license.txt.                                          }
{                                                       }
{*******************************************************}
{
  $Header: /cvsroot/delphi/ADDONS/dxmlrpc/source/XmlRpcCommon.pas,v 1.1 2011/01/25 16:39:53 cvs Exp $
  ----------------------------------------------------------------------------

  $Log: XmlRpcCommon.pas,v $
  Revision 1.1  2011/01/25 16:39:53  cvs
  2011

  Revision 1.1.1.1  2003/12/03 22:37:48  iwache
  Initial import of release 2.0.0

  ----------------------------------------------------------------------------
04.03.10 MD  StrToFloatIntl, FloatToStrIntl
21.12.11 MD  D2010 und Indy10
25.12.11 md  Umstellung auf Ansi
06.04.12 md  JclAnsiStrings
}
unit XmlRpcCommon;

{$DEFINE INDY9}
//MD<<
{$DEFINE INDY10}
{$DEFINE VER140_OR_HIGHER}
//>>MD
{$DEFINE ACTIVEX}

interface

uses
{$IFDEF WIN32}
  Windows,
{$ENDIF}
  SysUtils,
  Classes,
  JclAnsiStrings
{$IFDEF INDY9}
  , IdHash
{$ENDIF}
{$IFDEF INDY10}
, IdHashMessageDigest
{$ENDIF}
{$IFDEF ACTIVEX}
  {$IFDEF VER140_OR_HIGHER}
  , Variants
  {$ENDIF}
{$ENDIF}
  ;

type
  TRC4Data = record
    Key: array[0..255] of Byte; { current key }
    OrgKey: array[0..255] of Byte; { original key }
  end;

  TRC4 = class(TObject)
  private
    FData: TRC4Data;
    procedure RC4Init(var Data: TRC4Data; Key: Pointer; Len: Integer);
    procedure RC4Burn(var Data: TRC4Data);
    procedure RC4Crypt(var Data: TRC4Data; InData, OutData: Pointer; Len:
      Integer);
    procedure RC4Reset(var Data: TRC4Data);
  public
    constructor Create(const EncryptionKey: AnsiString);
    procedure EncryptStream(InStream, OutStream: TMemoryStream);
    function EncryptString(const Value: AnsiString): AnsiString;
    procedure DecryptStream(InStream, OutStream: TMemoryStream);
    function DecryptString(const Value: AnsiString): AnsiString;
    procedure BurnKey;
  end;

  { xml-rpc data types }
  TRPCDataType = (rpNone, rpString, rpInteger, rpBoolean, rpDouble,
    rpDate, rpBase64, rpStruct, rpArray, rpName, rpError);

function GetTempDir: string;

function FileIsExpired(const FileName: string; Elapsed: Integer): Boolean;

function EncodeEntities(const Data: AnsiString): AnsiString;

function DecodeEntities(const Data: AnsiString): AnsiString;

function Replace(const Data: AnsiString; const Find: AnsiString;
  const Replace: AnsiString): AnsiString;

function InStr(Start: Integer; const Data: AnsiString;
  const Find: AnsiString): Integer;

function Mid(const Data: AnsiString; Start: Integer): AnsiString;

function DateTimeToISO(ConvertDate: TDateTime): AnsiString;

function IsoToDateTime(const ISOStringDate: AnsiString): TDateTime;

function ParseString(const SearchString: AnsiString; Delimiter: AnsiChar;
  Substrings: TAnsiStrings; const AllowEmptyStrings: Boolean = False;
  ClearBeforeParse: Boolean = False): Integer;

function ParseStream(SearchStream: TStream; Delimiter: AnsiChar;
  Substrings: TAnsiStrings; AllowEmptyStrings: Boolean = False;
  ClearBeforeParse: Boolean = False): Integer;

function FixEmptyString(const Value: AnsiString): AnsiString;

function URLEncode(const Value: AnsiString): AnsiString;

function StreamToString(Stream: TStream): AnsiString;

procedure StringToStream(const Text: AnsiString; Stream: TStream);

{$IFDEF ACTIVEX}
function StreamToVariant(Stream: TStream): OleVariant;

procedure VariantToStream(V: OleVariant; Stream: TStream);
{$ENDIF}

//<<MD 04.03.10
function FloatToStrIntl(Value: Extended): AnsiString;
function StrToFloatIntl(const S: AnsiString): Extended;
//MD>>

{$IFDEF INDY9}
function Hash128AsHex(const Hash128Value: T4x4LongWordRecord): AnsiString;
{$ENDIF}

const
  ValidURLChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789$-_@.&+-!''*"(),;/#?:';

implementation

{------------------------------------------------------------------------------}

function URLEncode(const Value: AnsiString): AnsiString;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(Value) do
  begin
    if Pos(UpperCase(String(Value[I])), ValidURLChars) > 0 then
      Result := Result + Value[I]
    else
    begin
      if Value[I] = ' ' then
        Result := Result + '+'
      else
      begin
        Result := Result + '%';
        Result := Result + AnsiString(IntToHex(Byte(Value[I]), 2));
      end;
    end;
  end;
end;

{------------------------------------------------------------------------------}

function StrToIntl(const S: AnsiString): AnsiString;
// Ergibt String ohne Umlaute und ß
var
  I: integer;
begin
  Result := '';
  for I := 1 to length(S) do
  begin
    case S[I] of
      'Ä': Result := Result + 'AE';
      'Ö': Result := Result + 'OE';
      'Ü': Result := Result + 'UE';
      'ä': Result := Result + 'ae';
      'ö': Result := Result + 'oe';
      'ü': Result := Result + 'ue';
      'ß': Result := Result + 'ss';
    else
      Result := Result + S[I];
    end;
  end;
end;


function EncodeEntities(const Data: AnsiString): AnsiString;
begin
  Result := AnsiString(StringReplace(String(Data), '&', '&amp;', [rfReplaceAll]));
  Result := AnsiString(StringReplace(String(Result), '<', '&lt;', [rfReplaceAll]));
  Result := AnsiString(StringReplace(String(Result), '>', '&gt;', [rfReplaceAll]));
  Result := AnsiString(StringReplace(String(Result), '"', '&quot;', [rfReplaceAll]));
  Result := AnsiString(StringReplace(String(Result), #39, '&apos;', [rfReplaceAll]));

  //<<MD Umlaute
  //07.03.10 utf-8 encoding Result := StrToIntl(Result);
  //>>MD
end;

{------------------------------------------------------------------------------}

function DecodeEntities(const Data: AnsiString): AnsiString;
begin
  Result := AnsiString(StringReplace(String(Data), '&lt;', '<', [rfReplaceAll]));
  Result := AnsiString(StringReplace(String(Result), '&gt;', '>', [rfReplaceAll]));
  Result := AnsiString(StringReplace(String(Result), '&quot;', '"', [rfReplaceAll]));
  Result := AnsiString(StringReplace(String(Result), '&apos;', #39, [rfReplaceAll]));
  Result := AnsiString(StringReplace(String(Result), '&amp;', '&', [rfReplaceAll]));
end;

{------------------------------------------------------------------------------}
{ String Parsing Routine                                                       }
{------------------------------------------------------------------------------}

function ParseString(const SearchString: AnsiString; Delimiter: AnsiChar; Substrings:
    TAnsiStrings; const AllowEmptyStrings: Boolean = False; ClearBeforeParse:
    Boolean = False): Integer;
var
  Index: Integer;
  PrevCount: Integer;
  TempStr: AnsiString;
begin
  if (ClearBeforeParse) then
    Substrings.Clear;

  PrevCount := Substrings.Count;

  { ensure that the last substring is found }
  TempStr := SearchString + Delimiter;

  while (Length(TempStr) > 0) do
  begin
    Index := Pos(Delimiter, TempStr);
    if ((Index > 1) or AllowEmptyStrings) then
      Substrings.Add(Copy(TempStr, 1, Index - 1));
    Delete(TempStr, 1, Index);
  end;

  Result := Substrings.Count - PrevCount;
end;

{------------------------------------------------------------------------------}
{ stream parser                                                                }
{------------------------------------------------------------------------------}

function ParseStream(SearchStream: TStream; Delimiter: AnsiChar; Substrings:
    TAnsiStrings; AllowEmptyStrings: Boolean = False; ClearBeforeParse: Boolean =
    False): Integer;
begin
  Result := ParseString(StreamToString(SearchStream), Delimiter, Substrings,
    AllowEmptyStrings, ClearBeforeParse);
end;

{------------------------------------------------------------------------------}
{ convert stream to a string                                                   }
{------------------------------------------------------------------------------}

function StreamToString(Stream: TStream): AnsiString;
var
  StringStream: TStringStream;
begin
  Result := '';
  StringStream := TStringStream.Create;
  try
    //StringStream.Encoding := TEncoding.UTF8;
    StringStream.LoadFromStream(Stream);
    Result := AnsiString(StringStream.DataString);
  finally
    StringStream.Free;  //01.03.12
  end;

////MD<< 27.05.10
//  if Stream.Size > 0 then
//  begin
////>>MD
//    Stream.Seek(0, soFromBeginning);
//    SetLength(Result, Stream.Size);
//    Stream.Read(Result[1], Stream.Size);
//  end;
end;

{------------------------------------------------------------------------------}
{  Converts a string to a stream                                               }
{------------------------------------------------------------------------------}

procedure StringToStream(const Text: AnsiString; Stream: TStream);
begin
  Stream.Write(Text[1], Length(Text));
end;

{------------------------------------------------------------------------------}
{  Converts a date time to iso 8601 format                                     }
{------------------------------------------------------------------------------}

function DateTimeToISO(ConvertDate: TDateTime): AnsiString;
begin
  Result := AnsiString(FormatDateTime('yyyymmdd"T"hh:mm:ss', ConvertDate));
end;

{------------------------------------------------------------------------------}
{  Converts a ISO 8601 data to TDateTime                                       }
{------------------------------------------------------------------------------}

function IsoToDateTime(const ISOStringDate: AnsiString): TDateTime;
begin
  Result :=
  EncodeDate(
    StrToInt(String(ISOStringDate[1] +
                    ISOStringDate[2] +
                    ISOStringDate[3] +
                    ISOStringDate[4])),
    StrToInt(String(ISOStringDate[5] +
                    ISOStringDate[6])),
    StrToInt(String(ISOStringDate[7] +
                    ISOStringDate[8]))) +
  EncodeTime(
    StrToInt(String(ISOStringDate[10] +
                    ISOStringDate[11])),
    StrToInt(String(ISOStringDate[13] +
                    ISOStringDate[14])),
    StrToInt(String(ISOStringDate[16] +
                    ISOStringDate[17])),
    0);
end;

{------------------------------------------------------------------------------}
{  Returns part of a string                                                    }
{------------------------------------------------------------------------------}

function Mid(const Data: AnsiString; Start: Integer): AnsiString;
begin
  Result := Copy(Data, Start, Length(Data) - (Start - 1));
end;

{------------------------------------------------------------------------------}
{  Find position of string in sub string                                       }
{------------------------------------------------------------------------------}

function InStr(Start: Integer; const Data: AnsiString; const
  Find: AnsiString): Integer;
var
  C: Integer;
label
  SkipFind;
begin
  C := Start - 1;
  repeat
    if C > Length(Data) then
    begin
      C := 0;
      goto SkipFind;
    end;
    Inc(C);
  until Copy(Data, C, Length(Find)) = Find;
  SkipFind:
  Result := C;
end;

{------------------------------------------------------------------------------}
{  replace item in string                                                      }
{------------------------------------------------------------------------------}

function Replace(const Data: AnsiString; const Find: AnsiString;
  const Replace: AnsiString): AnsiString;
var
  C: Integer;
  Temp, Temp2: AnsiString;
begin
  Temp := Data;
  C := InStr(1, Temp, Find);
  while C <> 0 do
  begin
    Temp2 := Copy(Temp, 1, C - 1) + Replace + Mid(Temp, C + Length(Find));
    Temp := Temp2;
    C := InStr(C + Length(Replace), Temp, Find);
  end;
  Result := Temp;
end;

{------------------------------------------------------------------------------}
{Initialize the RC4 Engine                                                     }
{------------------------------------------------------------------------------}

procedure TRC4.RC4Init(var Data: TRC4Data; Key: Pointer; Len: Integer);
var
  XKey: array[0..255] of Byte;
  I, J: Integer;
  T: Byte;
begin
  if (Len <= 0) or (Len > 256) then
    raise Exception.Create('RC4: Invalid key length');
  for I := 0 to 255 do
  begin
    Data.Key[I] := I;
    XKey[I] := PByte(Integer(Key) + (I mod Len))^;
  end;
  J := 0;
  for I := 0 to 255 do
  begin
    J := (J + Data.Key[I] + XKey[I]) and $FF;
    T := Data.Key[I];
    Data.Key[I] := Data.Key[J];
    Data.Key[J] := T;
  end;
  Move(Data.Key, Data.OrgKey, 256);
end;

{------------------------------------------------------------------------------}
{Burn Key data from memory                                                     }
{------------------------------------------------------------------------------}

procedure TRC4.RC4Burn(var Data: TRC4Data);
begin
  FillChar(Data, Sizeof(Data), $FF);
end;

{------------------------------------------------------------------------------}
{Crypt and decrypt routine                                                     }
{------------------------------------------------------------------------------}

procedure TRC4.RC4Crypt(var Data: TRC4Data; InData, OutData: Pointer; Len:
  Integer);
var
  T, I, J: Byte;
  K: Integer;
begin
  I := 0;
  J := 0;
  for K := 0 to Len - 1 do
  begin
    I := (I + 1) and $FF;
    J := (J + Data.Key[I]) and $FF;
    T := Data.Key[I];
    Data.Key[I] := Data.Key[J];
    Data.Key[J] := T;
    T := (Data.Key[I] + Data.Key[J]) and $FF;
    PByteArray(OutData)[K] := PByteArray(InData)[K] xor Data.Key[T];
  end;
end;

{------------------------------------------------------------------------------}
{Reset the data keys                                                           }
{------------------------------------------------------------------------------}

procedure TRC4.RC4Reset(var Data: TRC4Data);
begin
  Move(Data.OrgKey, Data.Key, 256);
end;

{------------------------------------------------------------------------------}
{Remove keys from memory                                                       }
{------------------------------------------------------------------------------}

procedure TRC4.BurnKey;
begin
  RC4Burn(FData);
end;

{------------------------------------------------------------------------------}
{Decrypt a memory stream                                                       }
{------------------------------------------------------------------------------}

procedure TRC4.DecryptStream(InStream, OutStream: TMemoryStream);
begin
  OutStream.SetSize(InStream.Size);
  RC4Crypt(FData, InStream.Memory, OutStream.Memory, InStream.Size);
  RC4Reset(FData);
end;

{------------------------------------------------------------------------------}
{Secrypt a string value                                                        }
{------------------------------------------------------------------------------}

function TRC4.DecryptString(const Value: AnsiString): AnsiString;
begin
  SetLength(Result, Length(Value));
  RC4Crypt(FData, PByteArray(Value), PByteArray(Result), Length(Result));
end;

{------------------------------------------------------------------------------}
{Encrypt stream data                                                           }
{------------------------------------------------------------------------------}

procedure TRC4.EncryptStream(InStream, OutStream: TMemoryStream);
begin
  OutStream.SetSize(InStream.Size);
  RC4Crypt(FData, InStream.Memory, OutStream.Memory, InStream.Size);
  RC4Reset(FData);
end;

{------------------------------------------------------------------------------}
{Encrypt a string value                                                        }
{------------------------------------------------------------------------------}

function TRC4.EncryptString(const Value: AnsiString): AnsiString;
begin
  SetLength(Result, Length(Value));
  RC4Crypt(FData, PByteArray(Value), PByteArray(Result), Length(Result));
  Result := Result;
  RC4Reset(FData);
end;

{------------------------------------------------------------------------------}

constructor TRC4.Create(const EncryptionKey: AnsiString);
begin
  {initialize encryption engine}
  RC4Init(FData, PByteArray(EncryptionKey), Length(EncryptionKey));
end;

{------------------------------------------------------------------------------}
//check a file to see if the elapsed time is expired

function FileIsExpired(const FileName: string; Elapsed: Integer): Boolean;
var
  FHandle: Integer;
  FDate: TDateTime;
  FileTime: TTimeStamp;
  CurrentTime: TTimeStamp;
  DeltaTime: Integer;
begin
  FHandle := FileOpen(FileName, 0);
  try
    FDate := FileDateToDateTime(FileGetDate(FHandle));
    FileTime := DateTimeToTimeStamp(FDate);
    CurrentTime := DateTimeToTimeStamp(Now);
    DeltaTime := Round((CurrentTime.Time - FileTime.Time) / 60000);
    if (DeltaTime > Elapsed) then
      Result := True
    else
      Result := False;
  finally
    FileClose(FHandle);
  end;
end;

{------------------------------------------------------------------------------}

function GetTempDir: string;
{$IFDEF WIN32}
var
  Buf: array[0..MAX_PATH] of Char;
{$ENDIF}
begin
{$IFDEF WIN32}
  GetTempPath(Sizeof(Buf), Buf);
  Result := Buf;
  if Result[Length(Result)] <> '\' then
    Result := Result + '\';
{$ENDIF}
{$IFDEF LINUX}
  Result := '/var/tmp/';
{$ENDIF}
end;

{------------------------------------------------------------------------------}
{$IFDEF INDY9}

function Hash128AsHex(const Hash128Value: T4x4LongWordRecord): AnsiString;
begin
  Result := AnsiString(IntToHex(Hash128Value[0], 4)) +
            AnsiString(IntToHex(Hash128Value[1], 4)) +
            AnsiString(IntToHex(Hash128Value[2], 4)) +
            AnsiString(IntToHex(Hash128Value[3], 4));
end;

{$ENDIF}
{------------------------------------------------------------------------------}

function FixEmptyString(const Value: AnsiString): AnsiString;
begin
  Result := AnsiString(StringReplace(String(Value),
    AnsiString('<string></string>'), AnsiString('<string>[NULL]</string>'), [rfReplaceAll, rfIgnoreCase]));
  Result := AnsiString(StringReplace(String(Result),
    '<string></nil></string>', '<string>[NULL]</string>', [rfReplaceAll, rfIgnoreCase]));
  Result := AnsiString(StringReplace(String(Result),
    '<string></null></string>', '<string>[NULL]</string>', [rfReplaceAll, rfIgnoreCase]));
  Result := AnsiString(StringReplace(String(Result),
    '<string> </string>', '<string>[NULL]</string>', [rfReplaceAll, rfIgnoreCase]));

  // CLINTON 16/9/2003 - <string></string> was not compatable with XML-RPC spec.
  Result := AnsiString(StringReplace(String(Result),
    '<value></value>', '<value>[NULL]</value>', [rfReplaceAll, rfIgnoreCase]));
  Result := AnsiString(StringReplace(String(Result),
    '<value></nil></value>', '<value>[NULL]</value>', [rfReplaceAll, rfIgnoreCase]));
  Result := AnsiString(StringReplace(String(Result),
    '<value></null></value>', '<value>[NULL]</value>', [rfReplaceAll, rfIgnoreCase]));
  Result := AnsiString(StringReplace(String(Result),
    '<value> </value>', '<value>[NULL]</value>', [rfReplaceAll, rfIgnoreCase]));
end;

{$IFDEF ACTIVEX}

function StreamToVariant(Stream: TStream): OleVariant;
var
  V: OleVariant;
  P: Pointer;
begin
  V := VarArrayCreate([0, Stream.Size - 1], varByte);
  Stream.Position := 0;
  P := VarArrayLock(V);
  try
    Stream.Read(P^, Stream.Size);
  finally
    VarArrayUnlock(V);
  end;
  Result := V;
end;

procedure VariantToStream(V: OleVariant; Stream: TStream);
var
  P: Pointer;
begin
  Stream.Position := 0;
  Stream.Size := VarArrayHighBound(V, 1) - VarArrayLowBound(V, 1) + 1;
  P := VarArrayLock(V);
  Stream.Write(P^, Stream.Size);
  VarArrayUnlock(V);
  Stream.Position := 0;
end;

{$ENDIF}

//MD<< 04.03.10
function FloatToStrIntl(Value: Extended): AnsiString;
(* DezPkt = '.'  ohne TauPkt
   * Für SQL *)
var
  OldDecimalSeparator: Char;
begin
  OldDecimalSeparator := FormatSettings.DecimalSeparator;
  FormatSettings.DecimalSeparator := '.';
  try
    Result := AnsiString(FormatFloat('0.##########', Value));
  finally
    FormatSettings.DecimalSeparator := OldDecimalSeparator;
  end;
end;

function IsNum(Ch:AnsiChar): boolean;
begin
  Result := Ch in ['0'..'9'];
end;

function StrCgeChar(const S: AnsiString; chVon, chNach: AnsiChar): AnsiString;
{ersetzt ein Zeichen durch ein anderes. Wenn chNach = #0 wird das Zeichen gelöscht}
var
  I: integer;
begin
  Result := '';
  for I := 1 to length(S) do
    if S[I] = chVon then
    begin
      if chNach <> #0 then
        Result := Result + chNach;
    end else
      Result := Result + S[I];
end;

function StrToFloatIntl(const S: AnsiString): Extended;
{ String wird in verschiedenen internationalen Formaten korrekt interpretiert
  12,3  12.3  1.234,56  1 234.56  1,234.56  .5  ,5  (F, USA, GB, ES, CH, EU, ...)
  tolerant: die Umwandlung erfolgt ohne Exception via StrToFloatTol
  Hex-Zahlen werden nicht unterstützt (nichtdefiniertes Ergebnis)
  BG200104: um E erweitert}
var
  MyDecimalSeparator, MyThousandSeparator: AnsiChar;
  I: integer;
  S1: AnsiString;
begin
  MyDecimalSeparator := #0;
  MyThousandSeparator := #0;
  for I := 1 to length(S) - 1 do
  begin
    if not IsNum(S[I]) and IsNum(S[I + 1]) and (S[I] <> 'E') then
    begin
      if (MyThousandSeparator <> S[I]) and
         (MyDecimalSeparator = #0) then
      begin
        MyDecimalSeparator := S[I];
      end else
      if (MyDecimalSeparator = S[I]) then
      begin   //Separator kommt mehrmals vor -> Thousands
        MyThousandSeparator := MyDecimalSeparator;
        MyDecimalSeparator := #0;
      end else
      if (MyThousandSeparator <> S[I]) and
         (MyDecimalSeparator <> S[I]) then
      begin
        if MyThousandSeparator <> #0 then
          break;      //wir haben schon einen
        MyThousandSeparator := MyDecimalSeparator;
        MyDecimalSeparator := S[I];
      end;
    end;
  end; { for }
  S1 := S;
  if (MyDecimalSeparator in ['.', ',', #0]) and
     (MyThousandSeparator in ['.', ',', '''', ' ', #0]) then
  begin  //Dezimaltrenner gemäß lokale; Tausendertrenner entfernen
    if MyDecimalSeparator <> #0 then
      S1 := StrCgeChar(S1, MyDecimalSeparator, #255);
    if MyThousandSeparator <> #0 then
      S1 := StrCgeChar(S1, MyThousandSeparator, #0);
    if MyDecimalSeparator <> #0 then
      S1 := StrCgeChar(S1, #255, AnsiChar(FormatSettings.DecimalSeparator));
  end;
  Result := StrToFloat(String(S1));
end;

//>>MD

end.



{*******************************************************}
{                                                       }
{ XML-RPC Library for Delphi, Kylix and DWPL (DXmlRpc)  }
{ XmlRpcClient.pas                                      }
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
  $Header: /cvsroot/delphi/ADDONS/dxmlrpc/source/XmlRpcClient.pas,v 1.1 2011/01/25 16:39:53 cvs Exp $
  ----------------------------------------------------------------------------

  $Log: XmlRpcClient.pas,v $
  Revision 1.1  2011/01/25 16:39:53  cvs
  2011

  Revision 1.1.1.1  2003/12/03 22:37:51  iwache
  Initial import of release 2.0.0

  ----------------------------------------------------------------------------
}
(*
17.02.10 md  uppercase bei parse (boolean->BOOLEAN)
07.03.10 md  property Encoding: utf-8 senden
14.03.10 md  leere struct als struct zur�ckgeben (ptEmptyTag verarbeiten)
22.12.11 md  D2010 Encoding weg (immer UTF-8)
25.12.11 md  beware Unicode. Wieder nach Ansistring und FEncoding
06.04.12 md  JclAnsiStrings
12.04.12 md  ansitoutf8 jetzt mit Delphi System (statt LibXmlParser)
*)
unit XmlRpcClient;

{$DEFINE INDY9}

interface

uses
  SysUtils, Classes, Contnrs, JclAnsiStrings, XmlRpcTypes, XmlRpcCommon,
  IdHTTP,
  IdSSLOpenSSL,
{$IFDEF INDY9}
  IdHashMessageDigest,
  IdHash,
{$ENDIF}
  LibXmlParser;

type
  TRpcClientParser = class(TObject)
  private
    FStack: TObjectStack;
    FStructNames: TAnsiStringList;
    FRpcResult: IRpcResult;
    FParser: TXMLParser;
    FLastTag: AnsiString;
    FFixEmptyStrings: Boolean;
    procedure PushStructName(const Name: AnsiString);
    function PopStructName: AnsiString ;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Parse(Data: AnsiString);
    procedure StartTag;
    procedure EndTag;
    procedure DataTag;
    property FixEmptyStrings: Boolean read FFixEmptyStrings
        write FFixEmptyStrings;
  end;

  TRpcCaller = class(TRpcClientParser)
  private
    FHostName: AnsiString;
    FHostPort: Integer;
    FProxyName: AnsiString;
    FProxyPort: Integer;
    FProxyUserName: AnsiString;
    FProxyPassword: AnsiString;
    FSSLEnable: Boolean;
    FSSLRootCertFile: AnsiString;
    FSSLCertFile: AnsiString;
    FSSLKeyFile: AnsiString;
    FEndPoint: AnsiString;
    FProxyBasicAuth: Boolean;
    FEncoding: AnsiString;           //utf-8
    function Post(const RawData: AnsiString): AnsiString;
  public
    constructor Create;
    property EndPoint: AnsiString read FEndPoint write FEndPoint;
    property HostName: AnsiString read FHostName write FHostName;
    property HostPort: Integer read FHostPort write FHostPort;
    property ProxyName: AnsiString read FProxyName write FProxyName;
    property ProxyPort: Integer read FProxyPort write FProxyPort;
    property ProxyUserName: AnsiString read FProxyUserName write FProxyUserName;
    property ProxyPassword: AnsiString read FProxyPassword write FProxyPassword;
    property ProxyBasicAuth: Boolean read FProxyBasicAuth write FProxyBasicAuth;
    property SSLEnable: Boolean read FSSLEnable write FSSLEnable;
    property SSLRootCertFile: AnsiString read FSSLRootCertFile write
      FSSLRootCertFile;
    property SSLCertFile: AnsiString read FSSLCertFile write FSSLCertFile;
    property SSLKeyFile: AnsiString read FSSLKeyFile write FSSLKeyFile;
    property Encoding: AnsiString read FEncoding write FEncoding;
{$IFDEF INDY9}
    function Execute(RpcFunction: IRpcFunction; Ttl: Integer): IRpcResult; overload;
{$ENDIF}
    function Execute(const XmlRequest: AnsiString): IRpcResult; overload;
    function Execute(Value: IRpcFunction): IRpcResult; overload;
    procedure DeleteOldCache(Ttl: Integer);
  end;

const
  ERROR_EMPTY_RESULT = 600;
  ERROR_EMPTY_RESULT_MESSAGE = 'The xml-rpc server returned a empty response';
  ERROR_INVALID_RESPONSE = 601;
  ERROR_INVALID_RESPONSE_MESSAGE =
    'Invalid payload received from xml-rpc server';

implementation

uses
  Prots
{$IFDEF VER130}
  ,D5Tools
{$ENDIF}
  ;
  
{------------------------------------------------------------------------------}
{ RPC PARSER CONSTRUCTOR                                                       }
{------------------------------------------------------------------------------}

constructor TRpcClientParser.Create;
begin
  inherited Create;
end;

destructor TRpcClientParser.Destroy;
begin
  //CLINTON - 16/9/2003
  FStructNames.Free;
  FStack.Free;
  FParser.Free;
  inherited Destroy;
end;

//CLINTON 16/9/2003
// push/pop StructName used to store prior struct member name
procedure TRpcClientParser.PushStructName(const Name: AnsiString);
begin
  FStructNames.Add(Name);
end;

function TRpcClientParser.PopStructName: AnsiString ;
var
  I: Integer ;
begin
  I := FStructNames.Count - 1;
  Result := fStructNames[I];
  FStructNames.Delete(I);
end;

{------------------------------------------------------------------------------}
{ RETURN THE RESULT OBJECT  tastes great less filling ;)                       }
{------------------------------------------------------------------------------}

procedure TRpcClientParser.Parse(Data: AnsiString);
begin
  FRpcResult := TRpcResult.Create;

  { empty string fix }
  if (FFixEmptyStrings) then
    Data := FixEmptyString(Data);
  //MD 28.05.10 Test auf '' nach oben vor Pos(xml)
  {empty response}
  if (Trim(String(Data)) = '') then
  begin
    FRpcResult.SetError(ERROR_EMPTY_RESULT, ERROR_EMPTY_RESULT_MESSAGE);
    Exit;
  end;
  {simple error check}
  if not (Pos('xml', String(Data)) > 0) then
  begin
    FRpcResult.SetError(ERROR_INVALID_RESPONSE, ERROR_INVALID_RESPONSE_MESSAGE);
    Exit;
  end;

  if not Assigned(FParser) then
    FParser := TXMLParser.Create;
  if not Assigned(FStack) then
    FStack := TObjectStack.Create;
  //CLINTON - 16/9/2003
  if not Assigned(FStructNames) then
    FStructNames := TAnsiStringList.Create;

  FRpcResult.Clear;
  FParser.LoadFromBuffer(PAnsiChar(Data));


  FParser.StartScan;
  FParser.Normalize := False;
  while FParser.Scan do
  begin
    case FParser.CurPartType of
      ptStartTag:
        StartTag;
      ptContent:
        DataTag;
      ptEndTag:
        EndTag;
      //<<md 14.03.10
      ptEmptyTag: begin
                    StartTag;
                    EndTag;
                  end;
      //md>>
    end;
  end;
end;

{------------------------------------------------------------------------------}
{ CACHED WEB CALL Time To Live calculated in minutes                           }
{------------------------------------------------------------------------------}

{$IFDEF INDY9}

function TRpcCaller.Execute(RpcFunction: IRpcFunction; Ttl: Integer):
    IRpcResult;
var
  Strings: TAnsiStrings;
  XmlResult: AnsiString;
  XmlRequest: AnsiString;
  Hash: AnsiString;
  HashMessageDigest: TIdHashMessageDigest5;
begin
  XmlRequest := RpcFunction.RequestXML;
  HashMessageDigest := TIdHashMessageDigest5.Create;
  try
    { determine the md5 digest hash of the request }
    //Hash := Hash128AsHex(HashMessageDigest.HashValue(XmlRequest));
    //Indy10:
    Hash := AnsiString(HashMessageDigest.HashStringAsHex(String(XmlRequest)));

  finally
    HashMessageDigest.Free;
  end;
  Strings := TAnsiStringList.Create;
  try
    { if we have a cached file from a previous request
      that has not expired then load it }
    if FileExists(GetTempDir + String(Hash) + '.csh') then
    begin
      if not FileIsExpired(GetTempDir + String(Hash) + '.csh', Ttl) then
      begin
        Strings.LoadFromFile(GetTempDir + String(Hash) + '.csh');
        Parse(Strings.Text);
      end;
    end
    else
    begin
      { ok we got here so we where expired or did not exist
        make the call and cache the result this time }
      XmlResult := Post(XmlRequest);
      Parse(XmlResult);

      { save XmlResult in to the cache }
      Strings.Text := XmlResult;
      Strings.SaveToFile(GetTempDir + String(Hash) + '.csh');
    end;
  finally
    Strings.Free;
  end;
  RpcFunction.Clear;
end;

{$ENDIF}

{------------------------------------------------------------------------------}
{ NON - CACHED WEB CALL with IFunction parameter                                                     }
{------------------------------------------------------------------------------}

function TRpcCaller.Execute(Value: IRpcFunction): IRpcResult;
begin
  Result := Execute(Value.RequestXML);
  Value.Clear;
end;

{------------------------------------------------------------------------------}
{ NON - CACHED WEB CALL with XML string parameter                                                     }
{------------------------------------------------------------------------------}

function TRpcCaller.Execute(const XmlRequest: AnsiString): IRpcResult;
var
  XmlResponse: AnsiString;
begin
  //Prot0_D('XmlRequest='+CRLF+'%s', [XmlRequest]);
  XmlResponse := Post(XmlRequest);
  //Prot0_D('XmlResponse='+CRLF+'%s', [XmlResponse]);
  Parse(XmlResponse);
  Result := FRpcResult;
end;

{------------------------------------------------------------------------------}
{ DELETE ALL TEMPORARY EXPIRED DATA                                            }
{------------------------------------------------------------------------------}

procedure TRpcCaller.DeleteOldCache(Ttl: Integer);
var
  SearchRec: TSearchRec;
begin
  if FindFirst(GetTempDir + '*.csh', faAnyFile, SearchRec) = 0 then
  begin
    repeat
      if (SearchRec.Attr and faDirectory = 0) then
        if FileIsExpired(GetTempDir + SearchRec.Name, Ttl) then
          DeleteFile(GetTempDir + SearchRec.Name);
    until FindNext(SearchRec) <> 0;
    FindClose(SearchRec);
  end;
end;

{------------------------------------------------------------------------------}
{ POST THE REQUEST TO THE RPC SERVER                                           }
{------------------------------------------------------------------------------}

function TRpcCaller.Post(const RawData: AnsiString): AnsiString;
var
  SendStream: TStream;
  ResponseStream: TStream;
  Session: TIdHttp;
  //IdSSLIOHandlerSocket: TIdSSLIOHandlerSocket;
  //Indy10:
  IdSSLIOHandlerSocket: TIdSSLIOHandlerSocketOpenSSL;

begin
  SendStream := nil;
  ResponseStream := nil;
  IdSSLIOHandlerSocket := nil;
  try
    SendStream := TMemoryStream.Create;
    ResponseStream := TMemoryStream.Create;

    if SameText(String(Encoding), 'utf-8') then
    begin
      Prot0_D('XmlRequest=%s'+CRLF+'%s', [Encoding, AnsiToUtf8(RawData)]);
      StringToStream(AnsiToUtf8(RawData), SendStream);
    end else
    begin
      Prot0_D('XmlRequest=%s'+CRLF+'%s', [Encoding, RawData]);
      StringToStream(RawData, SendStream); { convert to a stream }
    end;

    SendStream.Position := 0;
    Session := TIdHttp.Create(nil);
    try
      IdSSLIOHandlerSocket := nil;
      if (FSSLEnable) then
      begin
        IdSSLIOHandlerSocket := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
        IdSSLIOHandlerSocket.SSLOptions.RootCertFile := String(FSSLRootCertFile);
        IdSSLIOHandlerSocket.SSLOptions.CertFile := String(FSSLCertFile);
        IdSSLIOHandlerSocket.SSLOptions.KeyFile := String(FSSLKeyFile);
        Session.IOHandler := IdSSLIOHandlerSocket;
      end;

      { proxy setup }
      if (FProxyName <> '') then
      begin
        {proxy basic auth}
        if (FProxyBasicAuth) then
          Session.ProxyParams.BasicAuthentication := True;

        Session.ProxyParams.ProxyServer := String(FProxyName);
        Session.ProxyParams.ProxyPort := FProxyPort;
        Session.ProxyParams.ProxyUserName := String(FProxyUserName);
        Session.ProxyParams.ProxyPassword := String(FProxyPassword);
      end;

      Session.Request.Accept := '*/*';
      Session.Request.ContentType := 'text/xml';
      Session.Request.Connection := 'Keep-Alive';
      Session.Request.ContentLength := Length(RawData);
      if not FSSLEnable then
        if FHostPort = 80 then
          Session.Post(String('http://' + FHostName + FEndPoint), SendStream,
            ResponseStream)
        else
          Session.Post('http://' + String(FHostName) + ':' + IntToStr(FHostPort) +
            String(FEndPoint), SendStream, ResponseStream);

      if FSSLEnable then
        Session.Post('https://' + String(FHostName) + ':' + IntToStr(FHostPort) +
          String(FEndPoint), SendStream, ResponseStream);

      Result := StreamToString(ResponseStream);
      Prot0_D('XmlResponse='+CRLF+'%s', [Result]);
      //test:
      //Prot0_D('XmlResponse=Utf8ToAnsi='+CRLF+'%s', [Utf8ToAnsi(Result)]);
    finally
      Session.Free;
    end;
  finally
    IdSSLIOHandlerSocket.Free;
    ResponseStream.Free;
    SendStream.Free;
  end;
end;

{------------------------------------------------------------------------------}

constructor TRpcCaller.Create;
begin
  inherited Create;
  FHostPort := 80;
  FSSLEnable := False;
  FProxyBasicAuth := False;
end;

{------------------------------------------------------------------------------}

procedure TRpcClientParser.DataTag;
var
  Data: AnsiString;
begin
  Data := FParser.CurContent;
  { should never be empty }
  if not (Trim(String(Data)) <> '') then
    Exit;
  { last tag empty ignore }
  if (FLastTag = '') then
    Exit;

  { struct name store for next pass}
  if (UpperCase(String(FLastTag)) = 'NAME') then
    if not (Trim(String(Data)) <> '') then
      Exit;

  {this will handle the default
   string pain in the ass}
  if UpperCase(String(FLastTag)) = 'VALUE' then
    FLastTag := 'STRING';

  {ugly null string hack}
  if (UpperCase(String(FLastTag)) = 'STRING') then
    if (Data = '[NULL]') then
      Data := '';

  {if the tag was a struct name we will
   just store it for the next pass    }
  if (UpperCase(String(FLastTag)) = 'NAME') then
  begin
    // CLINTON 16/9/2003
    PushStructName(Data);
    Exit;
  end;

  if (FStack.Count > 0) then
    if (TObject(FStack.Peek) is TRpcStruct) then
    begin
      if (UpperCase(String(FLastTag)) = 'STRING') then
        TRpcStruct(FStack.Peek).LoadRawData(dtString, PopStructName, Data);
      if (UpperCase(String(FLastTag)) = 'INT') then
        TRpcStruct(FStack.Peek).LoadRawData(dtInteger, PopStructName, Data);
      if (UpperCase(String(FLastTag)) = 'I4') then
        TRpcStruct(FStack.Peek).LoadRawData(dtInteger, PopStructName, Data);
      if (UpperCase(String(FLastTag)) = 'DOUBLE') then
        TRpcStruct(FStack.Peek).LoadRawData(dtFloat, PopStructName, Data);
      if (UpperCase(String(FLastTag)) = 'DATETIME.ISO8601') then
        TRpcStruct(FStack.Peek).LoadRawData(dtDateTime, PopStructName, Data);
      if (UpperCase(String(FLastTag)) = 'BASE64') then
        TRpcStruct(FStack.Peek).LoadRawData(dtBase64, PopStructName, Data);
      if (UpperCase(String(FLastTag)) = 'BOOLEAN') then
        TRpcStruct(FStack.Peek).LoadRawData(dtBoolean, PopStructName, Data);
    end;

  if (FStack.Count > 0) then
    if (TObject(FStack.Peek) is TRpcArray) then
    begin
      if (UpperCase(String(FLastTag)) = 'STRING') then
        TRpcArray(FStack.Peek).LoadRawData(dtString, Data);
      if (UpperCase(String(FLastTag)) = 'INT') then
        TRpcArray(FStack.Peek).LoadRawData(dtInteger, Data);
      if (UpperCase(String(FLastTag)) = 'I4') then
        TRpcArray(FStack.Peek).LoadRawData(dtInteger, Data);
      if (UpperCase(String(FLastTag)) = 'DOUBLE') then
        TRpcArray(FStack.Peek).LoadRawData(dtFloat, Data);
      if (UpperCase(String(FLastTag)) = 'DATETIME.ISO8601') then
        TRpcArray(FStack.Peek).LoadRawData(dtDateTime, Data);
      if (UpperCase(String(FLastTag)) = 'BASE64') then
        TRpcArray(FStack.Peek).LoadRawData(dtBase64, Data);
      if (UpperCase(String(FLastTag)) = 'BOOLEAN') then
        TRpcArray(FStack.Peek).LoadRawData(dtBoolean, Data);
    end;

  {here we are just getting a single value}
  if FStack.Count = 0 then
  begin
    if (UpperCase(String(FLastTag)) = 'STRING') then
      FRpcResult.AsRawString := Data;
    if (UpperCase(String(FLastTag)) = 'INT') then
      FRpcResult.AsInteger := StrToInt(String(Data));
    if (UpperCase(String(FLastTag)) = 'I4') then
      FRpcResult.AsInteger := StrToInt(String(Data));
    if (UpperCase(String(FLastTag)) = 'DOUBLE') then
      FRpcResult.AsFloat := StrToFloatIntl(String(Data));
    if (UpperCase(String(FLastTag)) = 'DATETIME.ISO8601') then
      FRpcResult.AsDateTime := IsoToDateTime(Data);
    if (UpperCase(String(FLastTag)) = 'BASE64') then
      FRpcResult.AsBase64Raw := Data;
    if (UpperCase(String(FLastTag)) = 'BOOLEAN') then
      FRpcResult.AsBoolean := StrToBool(String(Data));
  end;

  FLastTag := '';
end;

{------------------------------------------------------------------------------}

procedure TRpcClientParser.EndTag;
var
  RpcStruct: TRpcStruct;
  RpcArray: TRpcArray;
  Tag: AnsiString;
begin
  Tag := AnsiString(UpperCase(Trim(String(AnsiString(FParser.CurName)))));

  {if we get a struct closure then
   we pop it off the stack do a peek on
   the item before it and add  it}
  if (Tag = 'STRUCT') then
  begin
    {last item is a struct}
    if (TObject(FStack.Peek) is TRpcStruct) then
      if (FStack.Count > 0) then
      begin
        RpcStruct := TRpcStruct(FStack.Pop);
        if (FStack.Count > 0) then
        begin
          if (TObject(FStack.Peek) is TRpcArray) then
            TRpcArray(FStack.Peek).AddItem(RpcStruct);
          if (TObject(FStack.Peek) is TRpcStruct) then
            TRpcStruct(FStack.Peek).AddItem(PopStructName, RpcStruct)
        end
        else
          FRpcResult.AsStruct := RpcStruct;
        Exit;
      end;

    {last item is a array}
    if (TObject(FStack.Peek) is TRpcArray) then
      if (FStack.Count > 0) then
      begin
        RpcArray := TRpcArray(FStack.Pop);
        if (FStack.Count > 0) then
        begin
          if (TObject(FStack.Peek) is TRpcArray) then
            TRpcArray(FStack.Peek).AddItem(RpcArray);
          if (TObject(FStack.Peek) is TRpcStruct) then
            TRpcStruct(FStack.Peek).AddItem(PopStructName, RpcArray);
        end
        else
          FRpcResult.AsArray := RpcArray;
        Exit;
      end;
  end;

  if (Tag = 'ARRAY') then
  begin
    if (TObject(FStack.Peek) is TRpcArray) then
      if (FStack.Count > 0) then
      begin
        RpcArray := TRpcArray(FStack.Pop);
        if (FStack.Count > 0) then
        begin
          if (TObject(FStack.Peek) is TRpcStruct) then
            TRpcStruct(FStack.Peek).AddItem(PopStructName, RpcArray);
          if (TObject(FStack.Peek) is TRpcArray) then
            TRpcArray(FStack.Peek).AddItem(RpcArray);
        end
        else
          FRpcResult.AsArray := RpcArray;
        Exit;
      end;
  end;

  {if we get the params closure then we will pull the array
   and or struct and add it to the final result then clean up}
  if (Tag = 'PARAMS') then
    if (FStack.Count > 0) then
    begin
      if (TObject(FStack.Peek) is TRpcStruct) then
        FRpcResult.AsStruct := TRpcStruct(FStack.Pop);
      if (TObject(FStack.Peek) is TRpcArray) then
        FRpcResult.AsArray := TRpcArray(FStack.Pop);

      //CLINTON 16/9/2003
      {free the stack and the stack of the Struct names}
      FreeAndNil(FStack);
      FreeAndNil(FStructNames);
    end;
end;

{------------------------------------------------------------------------------}

procedure TRpcClientParser.StartTag;
var
  Tag: AnsiString;
  RpcStruct: TRpcStruct;
  RpcArray: TRpcArray;
begin
  Tag := AnsiString(UpperCase(Trim(String(FParser.CurName))));

  if (Tag = 'STRUCT') then
  begin
    RpcStruct := TRpcStruct.Create;
    try
      FStack.Push(RpcStruct);
      RpcStruct := nil;
    finally
      RpcStruct.Free;
    end;
  end;

  if (Tag = 'ARRAY') then
  begin
    RpcArray := TRpcArray.Create;
    try
      FStack.Push(RpcArray);
      RpcArray := nil;
    finally
      RpcArray.Free;
    end;
  end;
  FLastTag := Tag;
end;

end.


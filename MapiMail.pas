unit MapiMail;
{*******************************************************}
{                                                       }
{  TMapiMmail component for Borland Delphi 2.10.0           }
{*******************************************************}
(* www.swissdelphicenter.ch
developers knowledge base
...eine EMail mit Anlagen über MAPI verschicken?
Autor: Xavier Pacheco
Homepage: http://www.teamb.com
Kategorie: Objekte/ActiveX

Values: to
        attachment0 bis attachment999999
        subject
        body

   18.09.02 MD  überarbeitet:
                SMAPI entfernt, jetzt mit Borland MAPI.PAS
                Senden ohne Logon, da sonst Empfänger falsch
   30.11.09 MD  MapiResolveName i.V.m. Thunderbird implementiert
   16.11.12 md  XE2, Unicode, Blacki: Umbenannt (für ISA)
*)

interface

uses
  Classes;

function SendMapiMail(Handle: THandle; Mail: TStrings): Cardinal;


implementation

uses
  SysUtils, Windows, Mapi, Forms;

function SendMapiMail(Handle: THandle; Mail: TStrings): Cardinal;
//sendet Mail mit Infos in Stringlist.
//ergibt 0 (SUCCESS_SUCCESS) bei Erfolg. Fehlercode bei Fehler
// Fehlercodes und Flags siehe:
//  (http://msdn.microsoft.com/de-de/library/windows/desktop/hh707275%28v=vs.85%29.aspx)
type
  TAttachAccessArray = array [0..0] of TMapiFileDesc;
  PAttachAccessArray = ^TAttachAccessArray;
var
  MapiMessage: TMapiMessage;
  Receip: TMapiRecipDesc;
  Attachments: PAttachAccessArray;
  AttachCount: Integer;
  i1: integer;
  FileName: string;
  dwRet: Cardinal;
  MAPI_Session: Cardinal;
  WndList: Pointer;
begin
  dwRet := MapiLogon(Handle,
    PAnsiChar(''),
    PAnsiChar(''),
    MAPI_LOGON_UI or MAPI_NEW_SESSION,
    0, @MAPI_Session);

  if (dwRet <> SUCCESS_SUCCESS) then
  begin
    //Log('Error while trying to send email'),
    //  PChar('Error'),
    //  MB_ICONERROR or MB_OK);
    Result := dwRet;
  end
  else
  begin
    FillChar(MapiMessage, SizeOf(MapiMessage), #0);
    Attachments := nil;
    FillChar(Receip, SizeOf(Receip), #0);

    if Mail.Values['to'] <> '' then
    begin
      Receip.ulReserved := 0;
      Receip.ulRecipClass := MAPI_TO;
      Receip.lpszName := StrNew(PAnsiChar(AnsiString(Mail.Values['to'])));
      Receip.lpszAddress := StrNew(PAnsiChar(AnsiString('SMTP:' + Mail.Values['to'])));
      Receip.ulEIDSize := 0;
      MapiMessage.nRecipCount := 1;
      MapiMessage.lpRecips := @Receip;
    end;

    AttachCount := 0;

    for i1 := 0 to MaxInt do
    begin
      if Mail.Values['attachment' + IntToStr(i1)] = '' then
        break;
      Inc(AttachCount);
    end;

    if AttachCount > 0 then
    begin
      GetMem(Attachments, SizeOf(TMapiFileDesc) * AttachCount);

      for i1 := 0 to AttachCount - 1 do
      begin
        FileName := Mail.Values['attachment' + IntToStr(i1)];
        Attachments[i1].ulReserved := 0;
        Attachments[i1].flFlags := 0;
        Attachments[i1].nPosition := ULONG($FFFFFFFF);
        Attachments[i1].lpszPathName := StrNew(PAnsiChar(Ansistring(FileName)));
        Attachments[i1].lpszFileName :=
          StrNew(PAnsiChar(AnsiString(ExtractFileName(FileName))));
        Attachments[i1].lpFileType := nil;
      end;
      MapiMessage.nFileCount := AttachCount;
      MapiMessage.lpFiles := @Attachments^;
    end;

    if Mail.Values['subject'] <> '' then
      MapiMessage.lpszSubject := StrNew(PAnsiChar(Ansistring(Mail.Values['subject'])));
    if Mail.Values['body'] <> '' then
      MapiMessage.lpszNoteText := StrNew(PAnsiChar(Ansistring(Mail.Values['body'])));

    WndList := DisableTaskWindows(0);
    try
      Result := MapiSendMail(MAPI_Session, Handle,
        MapiMessage, MAPI_DIALOG, 0);
    finally
      EnableTaskWindows( WndList );
    end;

    for i1 := 0 to AttachCount - 1 do
    begin
      StrDispose(Attachments[i1].lpszPathName);
      StrDispose(Attachments[i1].lpszFileName);
    end;

    if Assigned(MapiMessage.lpszSubject) then
      StrDispose(MapiMessage.lpszSubject);
    if Assigned(MapiMessage.lpszNoteText) then
      StrDispose(MapiMessage.lpszNoteText);
    if Assigned(Receip.lpszAddress) then
      StrDispose(Receip.lpszAddress);
    if Assigned(Receip.lpszName) then
      StrDispose(Receip.lpszName);
    MapiLogOff(MAPI_Session, Handle, 0, 0);
  end;
end;

//procedure TForm1.Button1Click(Sender: TObject);
//var
//  mail: TStringList;
//begin
//  mail := TStringList.Create;
//  try
//    mail.values['to'] := 'Receiver-Email@test.xyz';
//    mail.values['subject'] := 'Hello';
//    mail.values['body'] := 'blah';
//    mail.values['body'] := 'blah';
//    mail.values['attachment0'] := 'C:\Test.txt';
//    // mail.values['attachment1']:='C:\Test2.txt';
//    sendEMail(Application.Handle, mail);
//  finally
//    mail.Free;
//  end;
//end;


initialization
end.

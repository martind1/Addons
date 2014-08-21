unit OnlyOpenOnce;
(*
   13.10.04 MD  UniqueString: leerlassen um kompletten Aufruf (mit Parameter) zu verwenden
   01.08.07 MD  Bug bei leerem UniqueString: letzter Parameter wurde ignoriert
   24.03.08 MD  Disabled wenn DelphiRunning
   29.06.09 MD  AskDelphiRunning
   22.12.11 md  D2010 (modiziziert DelphiRunning, Terminate)
   15.04.12 md  messageid dword. Rechechecks off bei wndproc
   18.04.12 md  Bug: gab MsgNr=0 nicht weiter. Ist Delphi WakeMainThread!!!
   01.02.14 md  Param an laufende Anw übergeben. ParamsString Unit-global. GlobalAddAtom


Params in laufender Anwendung empfangen:
procedure TFrmMain.BCOnlyOpenOnce(var Message: TMessage);  //message BC_ONLYOPENONCE;
var
  S: string;
begin
  SetLength(S, 255);
  SetLength(S, GlobalGetAtomName(Message.WParam, PChar(S), 255));
  GlobalDeleteAtom(Message.WParam);
end;

*)

{Add the following to the main project:

This is due to an idea from "The Graphical Gnome" <rdb@ktibv.nl>, found in
source spotted on http://www.gnomehome.demon.nl/uddf/index.htm

Thanks to Matthew Verdouw for fixing an error with the uniqueString, and adding a new property.

This uses a concept called a fileMapping (suggested on the borland delphi technical
pages) so that it is perfectly safe to use in a Multitasking win32 environment.

DO NOT ADD MORE THAN ONE OF THESE TO A FORM - your app will continually crash.}

interface

uses
  Windows, Classes, Dialogs, Forms, SysUtils;
  //Messages, ShellApi, Graphics, Controls;

type
  TOnlyOpenOnce = class(TComponent)
  private
    bIsAppVisible	: boolean;
    UniqueAppString: string;
    fEnabled: boolean;
    function DelphiRunning: boolean;
    function AskDelphiRunning(Meldung: string): boolean;
  protected
    { Protected declarations }
  public
    fMessageId: DWORD; //15.04.12Integer;
    fLastError: DWORD;
    Constructor Create(Owner: TComponent); override;
    Destructor Destroy; override;
    procedure Loaded; override;
    { Public declarations }
  published
    { Published declarations }
    Property UniqueString: String read UniqueAppString Write UniqueAppString;
    property IsAppVisible : boolean read bIsAppVisible write bIsAppVisible;
    property Enabled: boolean read fEnabled write fEnabled;
  end;

procedure Register;
Function checkMultiple: boolean;
procedure BroadcastFocusMessage;

implementation
//{$R OnlyOpenOnce.dcr}

uses
  Controls;

const
  WM_USER             = $0400;   //von Winapi.Messages
  BC_BASIS = WM_USER + 100;                 {Broadcast Messages}
  BC_ONLYOPENONCE = BC_BASIS + 32;

var
  fIsAppVisible : boolean;
  MessageId: DWORD; //15.04.12 Integer;
  FileHandle:THandle;
  WProc: TFNWndProc;
  UniquePChar: PChar;
  ParamsString: string;


{******************************************************************************}
procedure Register;
begin
  RegisterComponents('Addons', [TOnlyOpenOnce]);
end;

{******************************************************************************}
Constructor TOnlyOpenOnce.Create(Owner: TComponent);
{checks that the user has given a correct string, creates a PChar string using this
String, and gets a message ID for this String.  It then calls CheckMultiple}
begin
  Inherited create(Owner);
  fEnabled := true;
end;

{******************************************************************************}
Destructor TOnlyOpenOnce.destroy;
{Deallocates the pchar String, and resets the window procedure}
begin
  if not(csDesigning in ComponentState) then
  begin
    StrDispose(UniquePChar);
    if WProc<>nil then
      {restore old window procedure}
      SetWindowLong(Application.handle, GWL_WNDPROC, Longint(WProc));
    CloseHandle(FileHandle)
  end;
  inherited destroy;
end;

{******************************************************************************}
procedure TOnlyOpenOnce.Loaded;
var
  I: integer;
  S: string;
begin
   inherited Loaded;	{ always call the inherited method first }
   {originalversion:
   if length(UniqueAppString)=0 then
   	UniqueAppString:=Application.title;}
   if not(csDesigning in ComponentState) and fEnabled then
   begin
     //01.02.14 immer
     S := System.ParamStr(0);
     for I := 1 to System.ParamCount do
       S := S + ' ' + System.ParamStr(I);
     ParamsString := StringReplace(S, '\', '/', [rfReplaceAll]);
     if length(UniqueAppString) = 0 then
     begin
       UniqueAppString := ParamsString;
     end;

     //15.04.2012 weg XE2 Application.showmainForm:=false;
     {vergisst letzte Zeichen UniquePChar := StrAlloc(Length(UniqueAppString)+ 2);
     UniquePChar := StrPCopy(UniquePChar, UniqueAppString);}
     UniquePChar := StrNew(PChar(UniqueAppString));
     MessageID:=RegisterWindowMessage(UniquePChar);
     fLastError := GetLastError;
     fMessageID := MessageID;
     fIsAppVisible := bIsAppVisible;
     {The RegisterWindowMessage function defines a new window message that is
     guaranteed to be unique throughout the system.  If two apps use the same string,
     the same id will be generated.  The returned message value can be used when
     calling the SendMessage or PostMessage function}
     if CheckMultiple then
     begin
       if not AskDelphiRunning('OpenOnce') then
       begin
         //if (Owner <> nil) and (Owner is TForm) then TForm(Owner).Visible := false;
         Application.Terminate;  //Halt funktioniert nicht mehr in D2010 (Prg läuft nocht weiter)
         Application.ProcessMessages;  //damit in logondlg Terminated abgefragt werden kann
       end;
     end;
   end;
end;

{******************************************************************************}
//15.04.12 Function NewWndProc(Handle: HWND; msg: integer; WParam, lparam: Longint): Longint; StdCall
//vor 01.02.14 Function NewWndProc(Handle: HWND; msg: DWORD; WParam, lparam: Longint): Longint; StdCall
Function NewWndProc(Handle: HWND; msg: DWORD; WParam: WPARAM; LParam: LPARAM): Longint; StdCall
{the new windo procedure.  Checks the message received and if it is the message that
was registered with the UniqueAppString then it knows that another copy of itself
has been started, otherwise it passes the message on to the old window procedure}
begin
  result := 0;
  {check if this is the registered message}
  if Msg=MessageID then
  begin
    {if main form is minimised then restore it}
    if IsIconic(Application.handle) then
      Application.restore;
    if fIsAppVisible and (Application.MainForm <> nil) then
	    SetForeGroundWindow(Application.MainForm.Handle);
    if Application.MainForm <> nil then  //01.02.14
      SendMessage(Application.MainForm.Handle, BC_ONLYOPENONCE, WParam, LParam);
  end
  {otherwise pass the message to the old windows message proc}
  else
  begin
{$R-}
    //beware! WakeMainThread if msg <> 0 then
    try
      result := CallWindowProc(WProc,Handle,Msg,wParam,lParam);
    except on E:Exception do
      result := 0;
    end;
{$R+}
  end;
end;

{******************************************************************************}
Function CheckMultiple: boolean;
{creates a file mapping with a given name.  If a mapping of this name already
exists (the application is already running) then GetLastError will return
ErrorAlreadyExists so we send out a message to the other copies of this app.
If not, then we replace the standard windows procedure with our own and show the
main form}
begin
  FileHandle := CreateFileMapping(THandle(-1),
                                  nil,
                                  PAGE_READONLY,
                                  0,
                                  32,
                                  UniquePChar);
  if GetLastError = ERROR_ALREADY_EXISTS then
  begin
    Application.ShowMainForm := false;
    BroadCastFocusMessage;
    Result := True;
  end else
  begin
    if fIsAppVisible = True then
    begin
      ShowWindow(Application.Handle, SW_Shownormal);
      Application.ShowMainForm := True;
    end;
    WProc := TFNWndProc(SetWindowLong(Application.Handle, GWL_WNDPROC,
                        Longint(@NewWndProc)));
    Result := false;
  end;
end;

{******************************************************************************}
procedure BroadcastFocusMessage;
{ This is called when there is already an instance running. It broadcasts the
focus message}
var
  BSMRecipients: DWORD;
begin
  { Don't flash main form }
  Application.ShowMainForm := False;
  { Post message and inform other instance to focus itself }
  BSMRecipients := BSM_APPLICATIONS;
  BroadCastSystemMessage(BSF_IGNORECURRENTTASK or BSF_POSTMESSAGE,
                         @BSMRecipients, MessageID,
                         GlobalAddAtom(PWideChar(ParamsString)),
                         0);
end;

function TOnlyOpenOnce.DelphiRunning : boolean;
var
  H1, H4 : Hwnd;
const
  Tested: char = #0;
  A1 : array[0..12] of char = 'TApplication'#0;
  A2 : array[0..15] of char = 'TAlignPalette'#0;
  A3 : array[0..18] of char = 'TPropertyInspector'#0;
  A4 : array[0..11] of char = 'TAppBuilder'#0;
{$ifdef WIN32}
  {T1 : array[0..10] of char = 'Delphi 2.0'#0;}
  T1 : array[0..10] of char = 'Delphi 5'#0;
{$else}
  T1 : array[0..6] of char = 'Delphi'#0;
{$endif}
begin
  if Tested = #0 then
  begin
    H1 := FindWindow(A1, nil);  // T1: D2010 nicht );
//    H2 := FindWindow(A2, nil);
//    H3 := FindWindow(A3, nil);
    H4 := FindWindow(A4, nil);
    Result := (H1 <> 0) and
              //D2010 nicht (H2 <> 0) and (H3 <> 0) and
              (H4 <> 0);
    if Result then
      Tested := 'T' else
      Tested := 'F';
  end else
    Result := Tested = 'T';
end;

function TOnlyOpenOnce.AskDelphiRunning(Meldung: string): boolean;
begin
  if DelphiRunning then
    Result := MessageDlg(Format('DelphiRunning(%s)?', [Meldung]), mtConfirmation,
                         [mbYes, mbNo], 0) = mrYes else
    Result := false;
end;

end.

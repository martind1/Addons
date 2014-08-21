(****************************************************************)
(* nstimer.pas,  written by Paul Dorn                           *)
(* Placed in the Public Domain on November 25, 1997             *)
(* No royalties required for use or modification except for     *)
(* this notice.  This notice is not to be modified at any time  *)
(* or for any reason except that it may appear in its entirety  *)
(* at the top of the file or as close to the top of file as does*)
(* not render the file useless in the development environment.  *)
(****************************************************************)
(*
30.06.01 MD property SyncThread: boolean
            true = mit Synchronize (siehe Delphi-Hilfe).
                   System wartet bis OnTimer() beendet
            false = ohne synchronisierung. Echtes Multithreading.
                    Vorsicht: OnTimer() muß threadsicher sein!
18.09.02 MD InTimer Variable: true = im Timer Ereignis
15.10.11 md suspend und resume entfernen (deadlock Gefahr). Enable ergänzt.
27.12.11 md  inaktiv wenn Interval=0. sleep(100) wenn inaktiv.
*)
unit nstimer;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Dialogs,
  ExtCtrls;


type
  ENonSystemTimerError = class(Exception);

  TInternalTimerEvent = procedure of object;
  TTimerEvent = procedure(Sender: TComponent) of object;

  TTimerThread = class(TThread)
  protected
    TimeToSleep: DWord;
    ThreadInterval: DWord;
    Name: string;
  private
    WillQuiesce: Boolean;
    RestTime: DWORD;
    FSyncVcl: boolean;
    FOnInternalTimer: TInternalTimerEvent;
  protected
    procedure Execute; override;
  public
    procedure Quiesce;
    procedure Enable;
    property SyncVcl: boolean read FSyncVcl write FSyncVcl;
    property OnInternalTimer: TInternalTimerEvent read FOnInternalTimer write FOnInternalTimer;
  end;


  TNonSystemTimer = class(TComponent)
  private
    // Core Variables
    TimerThread: TTimerThread;

    // Property value holders
    FInterval: DWord;
    FEnabled: boolean;
    FSyncVcl: boolean;

    //Event Value Holders
    FOnTImer: TTimerEvent;

    procedure DoTimer;
    function OwnerDotName: string;
  protected
    procedure SetEnabled(NewEnabled: Boolean);
    procedure SetInterval(Value: DWord);
    procedure SetSyncVcl(Value: Boolean);
  public
    InTimer: boolean;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
    procedure Force;
  published
    property Enabled: boolean read FEnabled write SetEnabled;
    Property Interval: DWord read FInterval write SetInterval;
    property SyncVcl: boolean read FSyncVcl write SetSyncVcl;
    Property OnTimer: TTimerEvent read FOnTimer write FOnTimer;
  end;

procedure Register;

implementation
//{$R NSTIMER.dcr}
uses
  Forms;
  {Prots;}
var
  ThreadIndex: integer;

procedure Register;
begin
  RegisterComponents('Addons', [TNonSystemTimer]);
end;

procedure TTimerThread.Execute;
var
  OldRestTime: DWORD;
begin
  while not Terminated do
  begin
    if WillQuiesce or (ThreadInterval = 0) then  //0 = inaktiv
    begin
      //wir haben Pause
      //OldRestTime := RestTime;  //Debug Breakpoint
      sleep(100);
    end else
    if (TimeToSleep > 0) and (RestTime > 0) then
    begin
      //Sleep(TimeToSleep)
      if not Terminated and not WillQuiesce and (RestTime > 0) then
      begin
        if RestTime < 100 then
        begin
          OldRestTime := RestTime;
          RestTime := 0;
          sleep(OldRestTime);
        end else
        begin
          Dec(RestTime, 100);
          sleep(100);
        end;
      end;
    end else
    begin
      if TimeToSleep <= 0 then
      begin
        TimeToSleep := ThreadInterval;
        RestTime := 0;
      end else
        RestTime := TimeToSleep;
      if not Terminated and not WillQuiesce and Assigned(FOnInternalTimer) then
      try
        if FSyncVcl then
          Synchronize(FOnInternalTimer) else
          FOnInternalTimer;
      except
          //todo: in Liste eintragen zu späterem Auswerten
          //23.02.07 weg. WillQuiesce := true;
        on EThread do
          Terminate;
      end;
    end;
    //entfernt if WillQuiesce then
    //begin
    //  WillQuiesce := False;
    //  if not Terminated then
    //    Suspend;
    //end;
  end;
end;

procedure TTimerThread.Quiesce;
begin
  WillQuiesce := True;
end;

procedure TTimerThread.Enable;
begin
  WillQuiesce := False;
end;

constructor TNonSystemTimer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  TimerThread := TTimerThread.Create(True); // create a suspended thread
  TimerThread.OnInternalTimer := DoTimer;
  //TimerThread.OnTerminated := DoTerminate;
  //TimerThread.Name := self.Name;  //schlecht da leer
  Inc(ThreadIndex);
  TimerThread.Name := 'TimerThread' + IntToStr(ThreadIndex);

  SyncVcl := true;
  Interval := 1000;
end;

function TNonSystemTimer.OwnerDotName: string;
begin
  if Owner <> nil then
    Result := Owner.ClassName else
    Result := 'nil';
  if self.Name <> '' then
    Result := Result + '.' + self.Name else
    Result := Result + '.' + self.ClassName;
end;

procedure TNonSystemTimer.Loaded;
begin
  inherited;
  TimerThread.Name := Self.OwnerDotName;
end;

procedure TNonSystemTimer.Force;
//sofortige Ausführung der Timerfunktion erzwingen
begin
  TimerThread.TimeToSleep := 0;
end;

procedure TNonSystemTimer.SetInterval(Value: DWord);
begin
  TimerThread.TimeToSleep := Value;
  TimerThread.ThreadInterval := Value;
  FInterval := Value;
end;

procedure TNonSystemTimer.SetSyncVcl(Value: Boolean);
begin
  TimerThread.SyncVcl := Value;
  FSyncVcl := Value;
end;

procedure TNonSystemTimer.DoTimer;
begin
  if not (csDestroying in ComponentState) then  //18.04.13
  begin
    if Assigned(FOnTimer) then  //beware and not InTimer then
    try
      InTimer := true;
      FOnTimer(Self);
    finally
      InTimer := false;
    end;
  end;
end;

// procedure TNonSystemTimer.DoTerminate(Sender: TObject);
// begin
//   TerminateFlag := true;
// end;

destructor TNonSystemTimer.Destroy;
begin
  Enabled := False;
  TimerThread.OnInternalTimer := nil;
  //TimerThread.Free;  beware!
  //TimerThread.Quiesce;
  //if not TimerThread.Suspended then
//   TimerThread.Terminate;
//   if not TimerThread.Terminated then
//   begin
//     T1 := GetTickCount;
//     while not TimerThread.Suspended and   //wartet bis sleep(Interval) beendet
//           (GetTickCount - T1 <= Interval) do
//       Application.ProcessMessages;
//   end;
  TimerThread.Free;  //mit Terminate und WaitFor
  inherited Destroy;
end;

procedure TNonSystemTimer.SetEnabled(NewEnabled: Boolean);
begin
  if Enabled = NewEnabled then
    Exit;
  FEnabled := NewEnabled;
  if not (csDesigning in ComponentState) then
  begin
    if NewEnabled then
    begin
      while TimerThread.Suspended do  //ist zunächst suspended
        TimerThread.Resume;
      TimerThread.Enable;  //Timerfunktion wieder ausführen
    end else
      TimerThread.Quiesce; //Timerfunktion nicht mehr ausführen
  end;
end;


end.

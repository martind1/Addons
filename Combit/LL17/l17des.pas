unit l17des;

interface

{$ifdef ver140}
{$define d6plus}
{$endif}

{$ifdef ver150}
{$define d6plus}
{$endif}

{$ifdef ver170}
{$define d6plus}
{$endif}

{$ifdef ver180}
{$define d6plus}
{$endif}

{$ifdef ver190}
{$define d6plus}
{$endif}

{$ifdef ver200}
{$define d6plus}
{$endif}

{$ifdef ver210}
{$define d6plus}
{$endif}

{$ifdef ver220}
{$define d6plus}
{$endif}

{$ifdef ver230}
{$define d6plus}
{$endif}

uses l17, cmbtll17, l17db, SysUtils,
  Classes, forms, dialogs, windows, registry,

  {$ifndef d6plus} //Delphi6+
    dsgnintf
  {$else}
    DesignEditors, DesignIntf
  {$endif};

type
  (******************************************************************************)
  (*** TLlDesignerFileProperty interface ****************************************)
  (******************************************************************************)

  {Property editor for usage with lul designer files}

  TLlDesignerFileProperty = class(TPropertyEditor)
  public
    procedure Edit; override;
    function GetValue: string; override;
    procedure SetValue(const Value: string); override;
    function GetAttributes: TPropertyAttributes; override;
    procedure ShowMulInstanceWarning;
  end;



  (******************************************************************************)
  (*** TLlComponentEditor interface *********************************************)
  (******************************************************************************)

  TLlComponentEditor = class(TComponentEditor)

  public
    function GetVerbCount: integer; override;
    function GetVerb(Index: integer): string; override;
    procedure ExecuteVerb(Index: integer); override;
  end;

procedure Register;

implementation

{Helper Functions for Property/Component Editor}



function LastFile: TString; {Retrieve last file name from Registry}

  {$ifdef win32}
var 
  regist: TRegistry;
  buffer: TString;
begin
  regist := nil;
  try
    regist := TRegistry.Create;
    regist.RootKey := HKEY_CURRENT_USER;
    if regist.KeyExists('SOFTWARE\combit\CMBTLL\Delphi32') then
    begin
      regist.OpenKey('\SOFTWARE\combit\CMBTLL\Delphi32', False);
      buffer := regist.ReadString('LastFile');
      Result := buffer;
    end;
  finally
    regist.Free;
  end;
end;

{$endif}


procedure CallDesigner(theComponent: TDBL17_);
var  
  sProject: TString;
  nRet: longint;
begin
  case theComponent.AutoProjectType of
    ptListProject: 
      begin
        sProject := 'Design List';
      end;
    ptLabelProject: 
      begin
        sProject := 'Design Label';
      end;
    else
      begin
        sProject := 'Design Card';
      end;
  end;

  nRet := theComponent.AutoDesign(sProject);
  {LastFile call 16bit INI-File/ 32bit Registry}
  if nRet <> -1 then theComponent.AutoDesignerFile := LastFile;
end;


(******************************************************************************)
(*** TLlDesignerFileProperty implementation ***********************************)
(******************************************************************************)


procedure TLlDesignerFileProperty.Edit;
var 
  CompCount: integer;
  LlInstance: TDBL17_;
  RootForm: TComponent;
  Counter: integer;
begin
  {$ifndef d6plus}
  RootForm := Designer.Form;
  {$else}
  RootForm := Designer.Root;
  {$endif}

  Counter := 0;
  LlInstance := nil;
  if not (RootForm is TForm) then exit;
  try
    for CompCount := 0 to RootForm.ComponentCount - 1 do {loop through components}
    begin
      if (RootForm.Components[CompCount] is TDBL17_) then {lul instance}
      begin
        inc(Counter);
        LlInstance := TDBL17_(RootForm.Components[CompCount]);
      end;
    end;

    if (Counter = 1) then CallDesigner(LlInstance)
    else if (Counter > 1) then ShowMulInstanceWarning;

  finally
  end;
end;

function TLlDesignerFileProperty.GetValue: string;
begin
  Result := GetStrValue;
end;

procedure TLlDesignerFileProperty.SetValue(const Value: string);
begin
  SetStrValue(Value);
end;

function TLlDesignerFileProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;

procedure TLlDesignerFileProperty.ShowMulInstanceWarning;
begin
  ShowMessage('This feature is disabled when working with multiple component instances.' +
    #13 + 'Please use the component''s context menu.');
end;




(******************************************************************************)
(*** TLlComponentEditor implementation ****************************************)
(******************************************************************************)


function TLlComponentEditor.GetVerbCount: integer;
begin
  Result := 2;
end;


function TLlComponentEditor.GetVerb(Index: integer): string;
var 
  verb: TString;
  TheComponent: TDBL17_;
begin
  TheComponent := (Component as TDBL17_);
  case index of
    0: 
      begin
        verb := '&Design ';
        case TheComponent.AutoProjectType of
          ptListProject: verb := verb + 'List...';
          ptLabelProject: verb := verb + 'Label...';
          else 
            verb := verb + 'Card...';
        end;
      end;

    1: 
      begin
        verb := '&Print ';
        case TheComponent.AutoProjectType of
          ptListProject: verb := verb + 'List ';
          ptLabelProject: verb := verb + 'Label ';
          else 
            verb := verb + 'Card ';
        end;
        case TheComponent.AutoDestination of
          adPrinter: verb := verb + 'to Printer...';
          adPreview: verb := verb + 'to Preview...';
          adPRNFile: verb := verb + 'to File...';
          else 
            verb := verb + 'to User Destination...';
        end;
      end;
  end;
  Result := verb;
end;


procedure TLlComponentEditor.ExecuteVerb(Index: integer);
var 
  mComponent: TDBL17_;

  function MyGetTempPath: TString;

    {$ifdef win32}
  var 
    buffer: PChar;
  begin
    GetMem(Buffer, 256 * sizeof(tchar));
    try
      GetTempPath(256, Buffer);
      Result := StrPas(Buffer);
    finally
      Result := StrPas(Buffer);
      FreeMem(Buffer);
    end;
  end;

  {$else}
begin
  Result := '';
end;
{$endif}


begin
  case index of
    0: 
      begin
        mComponent := TDBL17_(Component);
        CallDesigner(mComponent);
      end;

    1: 
      begin
        mComponent := TDBL17_(Component);
        mComponent.AutoPrint('List && Label Print', MyGetTempPath);
      end;
  end;
end;

procedure Register;
begin
  RegisterPropertyEditor(TypeInfo(TLlDesignerFile), TDBL17_, '',
    TLlDesignerFileProperty);
  RegisterComponentEditor(TDBL17_, TLlComponentEditor);
end;


end.

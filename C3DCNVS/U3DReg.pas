unit U3DReg;

interface

uses Classes;

procedure Register;

implementation

uses
    SysUtils, Forms, {ori DsgnIntf,}
    DesignIntf, DesignEditors,

    U3DCnvs, U3DEdit;


{ Component editor - brings up Viewer editor when Extended clicking on
  Viewer property }
type
  TC3DCanvasEditor = class(TDefaultEditor)
  protected
    procedure EditProperty(const Prop: IProperty; var Continue: Boolean); override;
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

// Viewer Property

procedure TC3DCanvasEditor.EditProperty(const Prop: IProperty; var Continue: Boolean);
var
  PropName: string;
begin
  PropName := Prop.GetName;
  if (CompareText(PropName, 'VIEWER') = 0) then
  begin
    Prop.Edit;
    Continue := False;
  end;
end;

function TC3DCanvasEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

function TC3DCanvasEditor.GetVerb(Index: Integer): string;
begin
  if Index = 0 then
    Result := 'Edit Viewer'
  else Result := '';
end;

procedure TC3DCanvasEditor.ExecuteVerb(Index: Integer);
begin
  if Index = 0 then Edit;
end;

type
  TViewerProperty = class(TClassProperty)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

procedure TViewerProperty.Edit;
var
  Viewer: TViewer;
  ViewerEditor: TViewerEditorDlg;
begin
  Viewer := TViewer(GetOrdValue);
  ViewerEditor := TViewerEditorDlg.Create(Application);
  try
    ViewerEditor.EditorViewer := Viewer;
    ViewerEditor.ShowModal;
  finally
    ViewerEditor.Free;
  end;
end;

function TViewerProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paSubProperties];
end;

{ Registration }
procedure Register;
begin
  RegisterClasses([TViewer]);
  RegisterComponents('C3DCanvas',[TC3DCanvas]);
  RegisterComponentEditor(TC3DCanvas, TC3DCanvasEditor);
  RegisterPropertyEditor(TypeInfo(TViewer), nil, '', TViewerProperty);
end;

end.

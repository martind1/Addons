unit DBTreeView;
{ TDBTreeView is intened to provide the data representation as the tree.

  14.04.04 MD OnSetFltr Event
  14.04.04 MD GetNodeByData, NodeCache, FastAccess
              ! FastAccess nur möglich wenn Parents vor ihren Childs sortiert sind
              ! ansonsten muß Dataset nach ID sortiert sein!
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, CommCtrl, Forms, Dialogs,
  ComCtrls, DB;

type
  TDBTreeView = class;

  TOnEditingNodeEvent   = procedure (Sender: TObject; var Allow: Boolean) of object;
  TOnInsertingNodeEvent = procedure (Sender: TObject; var NewCaption: String; var Allow: Boolean) of object;
  TOnSetFltrEvent = procedure (Sender: TObject; Fltr: String) of object;

  EDBTreeView = class(Exception);

  TTreeDataLink = class(TDataLink)
  private
    FTreeView: TDBTreeView;
  protected
    procedure DataSetChanged; override;
    procedure RecordChanged(Field: TField); override;
    procedure ActiveChanged; override;
  public
    constructor Create(ATreeView: TDBTreeView);
  end;

  TFieldDataItem = class(TCollectionItem)
  public
    Values: TStringList;
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
  end;

  TBuildMethod = (bmFilter, bmRaw);

  TDBTreeView = class(TCustomTreeView)
  private
    FChanging: Boolean;
    FDataLink: TTreeDataLink;
    FRootID: Integer;
    FIDField : String;
    FParentIDField: String;
    FDisplayField: String;
    FBuildMethod : TBuildMethod;
    FStoredFieldsList : TStringList;
    FStoredFieldsData : TCollection;
    FNodeCache        : TStringList;
    FFastAccess        : boolean;
    FOnEditingNode     : TOnEditingNodeEvent;
    FOnInsertingNode   : TOnInsertingNodeEvent;
    FOnSetFltr         : TOnSetFltrEvent;
    FOnDeletingNode    : TOnEditingNodeEvent;
    FOnEditNode        : TNotifyEvent;
    FOnRebuildTree     : TNotifyEvent;
    procedure SetSource(Src: TDataSource);
    function  GetSource: TDataSource;
    procedure SetRootID(Value: Integer);
    procedure SetIDField(Value: String);
    procedure SetParentIDField(Value: String);
    procedure SetDisplayField(Value: String);
    procedure SetBuildMethod(Value: TBuildMethod);
    function  ValidDataSet: Boolean;
    function  ValidFields: Boolean;
    procedure StoredFieldsListChanged(Sender: TObject);
    procedure UpdateByDataSet;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure DataSetChanged;
    procedure RecordChanged(Field: TField);
    procedure Change(Node: TTreeNode); override;
    procedure Edit(const Item: TTVItem); override;
    procedure WndProc(var Message: TMessage); override;
    procedure InsertNew(Node: TTreeNode);
    procedure DeleteNode(Node: TTreeNode);
    procedure EditNode(Node: TTreeNode);
    function LocateID(Value: integer): boolean; //MD
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure   RebuildTree(KeepCurrentID: Boolean);
    function    GetStoredField(Node: TTreeNode; Field: String): String;
    property    Changing: Boolean read FChanging write FChanging;
    property    Items;
  published
    property Align;
    property Anchors;
    property AutoExpand;
    property BiDiMode;
    property BorderStyle;
    property BorderWidth;
    property ChangeDelay;
    property Color;
    property Ctl3D;
    property Constraints;
    property DragKind;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property HotTrack;
    property Images;
    property Indent;
    property ParentBiDiMode;
    property ParentColor default False;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property RightClickSelect;
    property RowSelect;
    property ShowButtons;
    property ShowHint;
    property ShowLines;
    property ShowRoot;
    property SortType;
    property StateImages;
    property TabOrder;
    property TabStop default True;
    property ToolTips;
    property Visible;
    property OnAdvancedCustomDraw;
    property OnAdvancedCustomDrawItem;
    property OnChange;
    property OnChanging;
    property OnClick;
    property OnCollapsed;
    property OnCollapsing;
    property OnCompare;
    property OnContextPopup;
    property OnCustomDraw;
    property OnCustomDrawItem;
    property OnDblClick;
    property OnDeletion;
    property OnDragDrop;
    property OnDragOver;
    property OnEdited;
    property OnEditing;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnExpanding;
    property OnExpanded;
    property OnGetImageIndex;
    property OnGetSelectedIndex;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;

    property DataSource: TDataSource read GetSource write SetSource;
    property RootID : Integer read FRootID write SetRootID;
    property IDField: String read FIDField write SetIDField;
    property ParentIDField: String read FParentIDField write SetParentIDField;
    property DisplayField: String read FDisplayField write SetDisplayField;
    property StoredFieldsList: TStringList read FStoredFieldsList write FStoredFieldsList;
    property BuildMethod: TBuildMethod read FBuildMethod write SetBuildMethod;
    property FastAccess: boolean read FFastAccess write FFastAccess;
    property OnEditingNode: TOnEditingNodeEvent read FOnEditingNode write FOnEditingNode;
    property OnInsertingNode: TOnInsertingNodeEvent read FOnInsertingNode write FOnInsertingNode;
    property OnSetFltr: TOnSetFltrEvent read FOnSetFltr write FOnSetFltr;
    property OnDeletingNode: TOnEditingNodeEvent read FOnDeletingNode write FOnDeletingNode;
    property OnEditNode: TNotifyEvent read FOnEditNode write FOnEditNode;
    property OnRebuildTree: TNotifyEvent read FOnRebuildTree write FOnRebuildTree;
  end;

implementation
//{$R DBTreeView.dcr}

{uses
  Qwf_Form;}

const
  ValidIDTypes : set of TFieldType = [ftLargeInt, ftSmallInt, ftInteger, ftWord, ftAutoInc,
    ftFloat, ftCurrency, ftBCD];
  MaxSubtreeItems = 100;

{ TFieldDataItem }

constructor TFieldDataItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  Values := TStringList.Create;
end;

destructor TFieldDataItem.Destroy;
begin
  Values.Free;
  inherited Destroy;
end;

{ TTreeDataLink }

constructor TTreeDataLink.Create(ATreeView: TDBTreeView);
begin
  inherited Create;
  FTreeView := ATreeView;
  VisualControl := True;
end;

procedure TTreeDataLink.DataSetChanged;
begin
  FTreeView.DataSetChanged;
end;

procedure TTreeDataLink.RecordChanged(Field: TField);
begin
  FTreeView.RecordChanged(Field);
end;

procedure TTreeDataLink.ActiveChanged;
begin
  if Active then
    FTreeView.RebuildTree(False) else
    FTreeView.Items.Clear;
end;

{ TDBTreeView }

constructor TDBTreeView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FChanging := False;
  FDataLink := TTreeDataLink.Create(Self);
  FDataLink.DataSource := nil;
  FRootID := 0;
  FStoredFieldsList := TStringList.Create;
  FNodeCache := TStringList.Create;
  FStoredFieldsList.OnChange := StoredFieldsListChanged;
  FStoredFieldsData := TCollection.Create(TFieldDataItem);
  FBuildMethod := bmFilter;
end;

destructor TDBTreeView.Destroy;
begin
  FDataLink.Free;
  FStoredFieldsList.Free;
  FNodeCache.Free;
  FStoredFieldsData.Free;
  inherited Destroy;
end;

procedure TDBTreeView.DataSetChanged;
begin
  if not HandleAllocated then Exit;
  if not FChanging then RebuildTree(True);
end;

procedure TDBTreeView.RecordChanged(Field: TField);
begin
  if not HandleAllocated then Exit;
  if not FChanging then RebuildTree(True);
end;

procedure TDBTreeView.SetSource(Src: TDataSource);
begin
  if Src = FDataLink.DataSource then Exit;
  FDataLink.DataSource := Src;
  if Src <> nil then Src.FreeNotification(Self);
end;

function TDBTreeView.GetSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

procedure TDBTreeView.StoredFieldsListChanged(Sender: TObject);
begin
  if FDataLink.Active then RebuildTree(True);
end;

procedure TDBTreeView.UpdateByDataSet;

  function FindNodeByID(Node: TTreeNode; AID: Integer): TTreeNode;
  var
    Child: TTreeNode;
  begin
    if Node <> nil then Child := Node.GetFirstChild else Child := Items.GetFirstNode;
    while Child <> nil do
    begin
      if Integer(Child.Data) = AID then
      begin
      	Result := Child;
        Exit;
      end;
      Result := FindNodeByID(Child, AID);
      if Result <> nil then Exit;
      Child := Child.GetNext;
    end;
    Result := nil;
  end;

var
  N : TTreeNode;
begin
  if FDataLink.Active then
  begin
    N := FindNodeByID(nil, FDataLink.DataSource.DataSet.FieldByName(IDField).AsInteger);
    if N <> nil then Selected := N;
  end;
end;

function TDBTreeView.LocateID(Value: integer): boolean;
//ersetzt Locate da es nicht mit SQL funktioniert. - MD
var
  AField: TField;
  BM: TBookmark;
begin
  Result := false;
  BM := nil;
  with FDataLink.DataSource.DataSet do
  try
    DisableControls;
    BM := GetBookmark;
    AField := FieldByName(IDField);
    while (AField.AsInteger < Value) and not EOF do
      Next;
    while (AField.AsInteger > Value) and not BOF do
      Prior;
    result := AField.AsInteger = Value;
  finally
    if not Result then
      GotoBookmark(BM);
    FreeBookmark(BM);
    EnableControls;
  end;
end;

procedure TDBTreeView.RebuildTree(KeepCurrentID: Boolean);
var
  OldFiltered: Boolean;
  OldFilter,
  AppliedFilter  : String;
  CurID      : Integer;
  Tmp        : String;
  TmpI       : Integer;
  DataSet    : TDataSet;

  procedure ProcessID(Node: TTreeNode);
  var
    Child: TTreeNode;
    I   : Integer;
    Itm : TFieldDataItem;
    Add : Boolean;
  begin
    if Node = nil then
      Tmp := IntToStr(FRootID) else
      Tmp := IntToStr(Integer(Node.Data));
    TmpI := StrToInt(Tmp);
    if assigned(FOnSetFltr) then
      FOnSetFltr(self, ParentIDField + '=' + Tmp) else
    if FBuildMethod = bmFilter then
      FDataLink.DataSet.Filter := AppliedFilter+'('+ParentIDField+' = '+Tmp+')';
    with DataSet do
    begin
      First;
      while not EOF do
      begin
      	if FBuildMethod = bmFilter then
          Add := True else
          Add := (FieldByName(ParentIDField).AsInteger = TmpI);
        if Add then
        begin
          Items.AddChildObject(Node, FieldByName(DisplayField).AsString,
            Pointer(FieldByName(IDField).AsInteger));
          Itm := FStoredFieldsData.Add as TFieldDataItem;
          Itm.Values.Add(FieldByName(IDField).AsString);
          for I := 1 to FStoredFieldsList.Count do
            Itm.Values.Add(FieldByName(FStoredFieldsList[I-1]).AsString);
        end;
        Next;
      end;
    end;
    if Node = nil then Child := Items.GetFirstNode else Child := Node.GetFirstChild;
    while Child <> nil do
    begin
      ProcessID(Child);
      Child := Child.GetNextSibling;
    end;
  end;

  procedure FastProcessID;
  var
    Node: TTreeNode;
    I   : Integer;
    Itm : TFieldDataItem;
    NewNode: TTreeNode;
  begin
    Tmp := IntToStr(FRootID);   //mit Root beginnen
    TmpI := StrToInt(Tmp);
    FNodeCache.Clear;
    with DataSet do
    begin
      First;
      while not EOF do
      begin
        I := FNodeCache.IndexOf(FieldByName(ParentIDField).AsString);
        if I >= 0 then
          Node := TTreeNode(FNodeCache.Objects[I]) else
          Node := TTreeNode(nil);

        NewNode := Items.AddChildObject(Node, FieldByName(DisplayField).AsString,
          Pointer(FieldByName(IDField).AsInteger));
        FNodeCache.AddObject(FieldByName(IDField).AsString, NewNode);

        Itm := FStoredFieldsData.Add as TFieldDataItem;
        Itm.Values.Add(FieldByName(IDField).AsString);
        for I := 1 to FStoredFieldsList.Count do
          Itm.Values.Add(FieldByName(FStoredFieldsList[I-1]).AsString);

        Next;
      end;
    end;
  end;

begin
  if not FDataLink.Active then Exit;
  DataSet := FDataLink.DataSource.DataSet;
  //if DataSet.RecordCount = 0 then Exit;
  if DataSet.BOF and DataSet.EOF then Exit;  //MD
  (*if FormGetLNav(Owner).NavLink.RecordCount = 0 then    //MD
    Exit;
  if DataSet.State <> dsBrowse then      //MD
    Exit;
  if FormGetLNav(Owner).dsQuery then    //MD
    Exit;*)
  if not ValidFields then
    Exit;
  FChanging := True;
  OldFiltered := false;
  OldFilter := '';
  if FBuildMethod = bmFilter then
  begin
    OldFiltered := DataSet.Filtered;
    OldFilter := DataSet.Filter;
    if OldFiltered and (OldFilter <> '') then
      AppliedFilter := '('+OldFilter+') AND ' else
      AppliedFilter := '';
  end;
  DataSet.DisableControls;
  try
    if KeepCurrentID and (Items.Count > 0) then
      CurID := DataSet.FieldByName(IDField).AsInteger else
      CurID := FRootID;
    Items.BeginUpdate;
    Items.Clear;
    FStoredFieldsData.Clear;
    if FBuildMethod = bmFilter then DataSet.Filtered := True;
    if FastAccess then
      FastProcessID else
      ProcessID(nil);
    if Items.Count > 0 then Items[0].Expand(False);
    if FBuildMethod = bmFilter then
    begin
      DataSet.Filter := OldFilter;
      DataSet.Filtered := OldFiltered;
    end;
    if KeepCurrentID then
    begin
      //if DataSet.Locate(IDField, CurID, []) then
      if LocateID(CurID) then
        UpdateByDataSet else
        if Items.Count > 0 then
          Selected := Items[0];
    end else
    if Items.Count > 0 then
      Selected := Items[0];
    Items.EndUpdate;
    if Selected <> nil then
    begin
      //LocateID(CurID);
      LocateID(Integer(Selected.Data))
    end;
  finally
    DataSet.EnableControls;
    FChanging := False;
    if Assigned(FOnRebuildTree) then FOnRebuildTree(Self);
  end;
end;

function TDBTreeView.GetStoredField(Node: TTreeNode; Field: String): String;
var
  FieldData: TFieldDataItem;
  I      : Integer;
  FldIdx : Integer;
begin
  FldIdx := FStoredFieldsList.IndexOf(Field);
  if FldIdx < 0 then
  begin
    Result := '';
    Exit;
  end;
  FieldData := nil;
  I := 0;
  while (FieldData = nil) and (I <= FStoredFieldsData.Count-1) do
  begin
    if TFieldDataItem(FStoredFieldsData.Items[I]).Values[0] = IntToStr(Integer(Node.Data)) then
      FieldData := FStoredFieldsData.Items[I] as TFieldDataItem;
    Inc(I);
  end;
  if FieldData <> nil then
    Result := FieldData.Values[FldIdx+1]
  else Result := '';
end;

procedure TDBTreeView.WndProc(var Message: TMessage);
begin
  inherited WndProc(Message);
  if not (csDesigning in ComponentState) and Assigned(FDataLink) and FDataLink.Active and
     not ReadOnly then
  begin
    if Message.Msg = WM_KEYDOWN then
    begin
      case TWMKey(Message).CharCode of
    	VK_INSERT : InsertNew(Selected);
        VK_DELETE : DeleteNode(Selected);
        VK_SPACE  : EditNode(Selected);
        VK_RETURN : Selected.Expanded := not Selected.Expanded;
      end;
    end;
    if Message.Msg = WM_LBUTTONDOWN then
    begin
      if Selected <> nil then Change(Selected);
    end;
  end;
end;

procedure TDBTreeView.Change(Node: TTreeNode);
begin
  if FChanging then Exit;
  inherited Change(Node);
  FChanging := True;
  if FDataLink.Active then
    //if not FDataLink.DataSource.DataSet.Locate(IDField, Integer(Node.Data), []) then
    if not LocateID(Integer(Node.Data)) then
      FDataLink.DataSource.DataSet.First;
  FChanging := False;
end;

procedure TDBTreeView.Edit(const Item: TTVItem);
begin
  inherited Edit(Item);
  if (not FDataLink.Active) or (Item.pszText = nil) then Exit;
  FChanging := True;
  with FDataLink.DataSource.DataSet do
  begin
    if not (State in [dsInsert, dsEdit]) then Edit;
    FieldByName(DisplayField).AsString := Item.pszText;
    Post;
  end;
  FChanging := False;
end;

procedure TDBTreeView.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent =  DataSource) then DataSource := nil;
end;

function TDBTreeView.ValidDataSet: Boolean;
begin
  Result:= False;
  if (FDataLink <> nil ) And Assigned(FDataLink.DataSet) And FDataLink.DataSet.Active then
    Result:= True;
end;

procedure TDBTreeView.SetRootID(Value: Integer);
begin
  FRootID := Value;
  RebuildTree(False);
end;

procedure TDBTreeView.SetIDField(Value: String);
Var AField: TField;
    Old : String;
begin
  Old := FIDField;
  AField:= nil;
  if ValidDataSet and
     not (csLoading in ComponentState) and (Length(Value) > 0) then
    AField := FDataLink.DataSet.FindField(Value); { no exceptions }
  if (AField <> nil) and not (AField.DataType in ValidIDTypes) then
  begin
    //MessageDlg(Name+': Incorrect field type ' + AField.ClassName, mtWarning, [mbOk], 0 );
    raise EDBTreeView.Create(Name+': Incorrect field type ' + AField.ClassName);
    Value:= Old;
  end;
  if Value = FParentIDField then
  begin
    //MessageDlg(Name+': IDField and ParendIDField cann''t refer to the same field!', mtWarning, [mbOk], 0 );
    raise EDBTreeView.Create(Name+': IDField and ParendIDField cann''t refer to the same field!');
    Value := Old;
  end;
  FIDField:= Value;
  if FDataLink.Active then RebuildTree(False);
end;

procedure TDBTreeView.SetParentIDField(Value: String);
Var AField: TField;
    Old : String;
begin
  Old := FParentIDField;
  AField:= nil;
  if ValidDataSet and
    not (csLoading in ComponentState) and (Length(Value) > 0) then
      AField := FDataLink.DataSet.FindField(Value); { no exceptions }
  if (AField <> nil) and not (AField.DataType in ValidIDTypes) then
  begin
    //MessageDlg(Name+': Incorrect field type ' + AField.ClassName, mtWarning, [mbOk], 0 );
    raise EDBTreeView.Create(Name+': Incorrect field type ' + AField.ClassName);
    Value:= Old;
  end;
  if Value = FIDField then
  begin
    //MessageDlg(Name+': IDField and ParendIDField cann''t refer to the same field!', mtWarning, [mbOk], 0 );
    raise EDBTreeView.Create(Name+': IDField and ParendIDField cann''t refer to the same field!');
    Value := Old;
  end;
  FParentIDField:= Value;
  if FDataLink.Active then RebuildTree(False);
end;

procedure TDBTreeView.SetDisplayField(Value: String);
begin
  FDisplayField:= Value;
  if FDataLink.Active then RebuildTree(True);
end;

procedure TDBTreeView.SetBuildMethod(Value: TBuildMethod);
begin
  FBuildMethod := Value;
  if FDataLink.Active then RebuildTree(True);
end;


procedure TDBTreeView.InsertNew(Node: TTreeNode);
var
  Allow: Boolean;
  S    : String;
  NewID: Integer;
  Max  : Integer;
  ParentID : Integer;
  NewNode: TTreeNode;

  procedure FindMax(N: TTreeNode);
  begin
    if Max < Integer(N.Data) then Max := Integer(N.Data);
    if N.GetNext <> nil then FindMax(N.GetNext);
  end;

begin
  if ReadOnly then Exit;
  S := 'New item';
  Allow := True;
  if Assigned(FOnInsertingNode) then FOnInsertingNode(Self, S, Allow);
  if not Allow then Exit;
  FChanging := True;
  with FDataLink.DataSource.DataSet do
  begin
    Insert;
    FieldByName(DisplayField).AsString := S;
    if Node = nil then ParentID := RootID else ParentID := Integer(Node.Data);
    FieldByName(ParentIDField).AsInteger := ParentID;
    if FieldByName(IDField).DataType = ftAutoInc then
    begin
      Post;
      NewID := FieldByName(IDField).AsInteger;
    end else
    begin
      if Items.Count > 0 then
      begin
    	Max := -2147483647;
      	FindMax(Items[0]);
      	NewID := Max + 1;
      end else NewID := 1;
      FieldByName(IDField).AsInteger := NewID;
      Post;
    end;
  end;
  NewNode := Items.AddChildObject(Node, S, Pointer(NewID));
  FChanging := False;
  Selected := NewNode;
  Selected.EditText;
end;

procedure TDBTreeView.DeleteNode(Node: TTreeNode);
var
  Allow: Boolean;
  GoRebuild: Boolean;

  procedure DelRecursive(N: TTreeNode);
  var Tmp: Integer;
  begin
    while N.Count > 0 do
    	DelRecursive(N.GetFirstChild);
    with FDataLink.DataSource.DataSet do
    begin
      //Locate(FIDField, Integer(N.Data), []);
      LocateID(Integer(N.Data));
      Tmp := FieldByName(FIDField).AsInteger;
      Delete;
      if FieldbyName(FIDField).AsInteger <> Tmp then N.Delete else GoRebuild := True;
    end;
  end;

begin
  if ReadOnly then Exit;
  Allow := True;
  if Assigned(FOnDeletingNode) then FOnDeletingNode(Self, Allow);
  if Allow then
  begin
    GoRebuild := False;
    FChanging := True;
    DelRecursive(Node);
    UpdateByDataSet;
    FChanging := False;
    if GoRebuild then RebuildTree(True);
  end;
end;

procedure TDBTreeView.EditNode(Node: TTreeNode); // User defined editing of CURRENT record
var
  Allow: Boolean;
  I    : Integer;
  Itm  : TFieldDataItem;
  BM   : TBookmark;
begin
  if ReadOnly or not Assigned(FOnEditNode) or (not FDataLink.Active) then Exit;
  FChanging := True;
  with FDataLink.DataSource.DataSet do
  begin
    BM := FDataLink.DataSource.DataSet.GetBookmark;
    //if not Locate(FIDField, Integer(Node.Data), []) then
    if not LocateID(Integer(Node.Data)) then
    begin
      FChanging := False;
      //MessageDlg('Impossible to synchronize data tree: possibly dataset have been changed!', mtError, [mbOK], 0);
      raise EDBTreeView.Create('Impossible to synchronize data tree: possibly dataset have been changed!');
      Exit;
    end;
  end;
  Allow := True;
  if Assigned(FOnEditingNode) then FOnEditingNode(Self, Allow);
  if Allow then
  begin
    FOnEditNode(Self); // user changes made
    Itm := nil;
    for I := 1 to FStoredFieldsData.Count do // looking for corresponding stored fields
      if TFieldDataItem(FStoredFieldsData.Items[I-1]).Values[0] = IntToStr(Integer(Node.Data)) then
      	Itm := FStoredFieldsData.Items[I-1] as TFieldDataItem;
    if Itm = nil then
      RebuildTree(True) // user did something stupid like inserting new record
    else with FDataLink.DataSource.DataSet do
    begin
      Itm.Values.Clear;
      Itm.Values.Add(FieldByName(IDField).AsString);
      for I := 1 to FStoredFieldsList.Count do
        Itm.Values.Add(FieldByName(FStoredFieldsList[I-1]).AsString);
    end;
    Node.Text := FDataLink.DataSource.DataSet.FieldByName(DisplayField).AsString;
  end;
  FDataLink.DataSource.DataSet.GotoBookmark(BM);
  FDataLink.DataSource.DataSet.FreeBookmark(BM);
  FChanging := False;
  Change(Node);
end;

function  TDBTreeView.ValidFields: Boolean;
var
  F : TField;
begin
  Result := False;
  if not FDataLink.Active then Exit;
  F := FDataLink.DataSet.FindField(FIDField);
  if F = nil then
  begin
    //MessageDlg(Name+': IDField not defined', mtWarning, [mbOK], 0);
    raise EDBTreeView.Create(Name+': IDField not defined');
    Exit;
  end else
  if not (F.DataType in ValidIDTypes) then
  begin
    //MessageDlg(Name+': IDField of incorrect type ' + F.ClassName, mtWarning, [mbOK], 0);
    raise EDBTreeView.Create(Name+': IDField of incorrect type ' + F.ClassName);
    Exit;
  end;
  F := FDataLink.DataSet.FindField(FParentIDField);
  if F = nil then
  begin
    //MessageDlg(Name+': ParentIDField not defined', mtWarning, [mbOK], 0);
    raise EDBTreeView.Create(Name+': ParentIDField not defined');
    Exit;
  end else
  if not (F.DataType in ValidIDTypes) then
  begin
    //MessageDlg(Name+': of incorrect type ' + F.ClassName, mtWarning, [mbOK], 0);
    raise EDBTreeView.Create(Name+': of incorrect type ' + F.ClassName);
    Exit;
  end;
  F := FDataLink.DataSet.FindField(FDisplayField);
  if (F = nil) then
  begin
    //MessageDlg(Name+': DisplayField not defined', mtWarning, [mbOK], 0);
    raise EDBTreeView.Create(Name+': DisplayField not defined');
    Exit;
  end;

  if UpperCase(FIDField) = UpperCase(FParentIDField) then
  begin
    //MessageDlg(Name+': IDField and ParendIDField cann''t refer to the same field!', mtWarning, [mbOK], 0);
    raise EDBTreeView.Create(Name+': IDField and ParendIDField cann''t refer to the same field!');
    Exit;
  end;

  Result := True;
end;

end.

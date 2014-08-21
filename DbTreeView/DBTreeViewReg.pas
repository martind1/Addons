unit DBTreeViewReg;

{

	TDBTreeView is intened to provide the data representation as the tree.

}

interface

uses Classes, DesignIntf, DesignEditors;

type

  TDBStringProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValueList(List: TStrings); virtual; abstract;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

	TDataFieldProperty = class(TDBStringProperty)
  public
    function GetDataSourcePropName: string; virtual;
    procedure GetValueList(List: TStrings); override;
  end;

  TFieldsListProperty = class(TClassProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;

procedure Register;

implementation

uses
  Windows, Messages, SysUtils, Graphics, Controls, CommCtrl, Forms, Dialogs,
  ComCtrls, DB, TypInfo, DBTreeView, fldchk;

const
	ValidIDTypes : set of TFieldType = [ftSmallInt, ftInteger, ftWord, ftAutoInc];
  MaxSubtreeItems = 100;


function TDBStringProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList, paSortList, paMultiSelect];
end;

procedure TDBStringProperty.GetValues(Proc: TGetStrProc);
var
  I: Integer;
  Values: TStringList;
begin
  Values := TStringList.Create;
  try
    GetValueList(Values);
    for I := 0 to Values.Count - 1 do Proc(Values[I]);
  finally
    Values.Free;
  end;
end;

function TDataFieldProperty.GetDataSourcePropName: string;
begin
  Result := 'DataSource';
end;

procedure TDataFieldProperty.GetValueList(List: TStrings);
var
  Instance: TComponent;
  PropInfo: PPropInfo;
  DataSource: TDataSource;
begin
  Instance := TComponent(GetComponent(0));
  PropInfo := TypInfo.GetPropInfo(Instance.ClassInfo, GetDataSourcePropName);

  if (PropInfo <> nil) and (PropInfo^.PropType^.Kind = tkClass) then
  begin
    DataSource := TObject(GetOrdProp(Instance, PropInfo)) as TDataSource;
    if (DataSource <> nil) and (DataSource.DataSet <> nil) then
      DataSource.DataSet.GetFieldNames(List);
  end;
end;

function TFieldsListProperty.GetAttributes: TPropertyAttributes;
begin
	Result := [paDialog, paReadOnly];
end;

procedure TFieldsListProperty.Edit;
var
	Dlg : TFldChooseDlg;
  Instance: TDBTreeView;
  //PropInfo: PPropInfo;
  DataSource: TDataSource;
  FieldsList : TStringList;
  I : Integer;
begin
  Instance := TDBTreeView(GetComponent(0));
  DataSource := Instance.DataSource;
  if (DataSource <> nil) and (DataSource.DataSet <> nil) then
  begin
    Dlg := TFldChooseDlg.Create(nil);
    Dlg.Caption := Instance.Name + '.StoredFieldsList';
    DataSource.DataSet.GetFieldNames(Dlg.FieldsLB.Items);
    FieldsList := Instance.StoredFieldsList;
    with Dlg.FieldsLB.Items do
      for I := 1 to Count do
        if FieldsList.IndexOf(Strings[I-1]) <> -1 then Dlg.FieldsLB.Checked[I-1] := True
          else Dlg.FieldsLB.Checked[I-1] := False;
    if Dlg.ShowModal = mrOK then
    begin
      FieldsList.Clear;
      for I := 1 to Dlg.FieldsLB.Items.Count do
        if Dlg.FieldsLB.Checked[I-1] then
          FieldsList.Add(Dlg.FieldsLB.Items[I-1]);
      (Instance as TDBTreeView).RebuildTree(True);
    end;
  	Dlg.Free;
  end
  else MessageDlg('Define the DataSource property first!', mtWarning, [mbOK], 0);
end;


procedure Register;
begin
  RegisterComponents('Addons', [TDBTreeView]);
  RegisterPropertyEditor(TypeInfo(string), TDBTreeView, 'IDField', TDataFieldProperty);
  RegisterPropertyEditor(TypeInfo(string), TDBTreeView, 'ParentIDField', TDataFieldProperty);
  RegisterPropertyEditor(TypeInfo(string), TDBTreeView, 'DisplayField', TDataFieldProperty);
  RegisterPropertyEditor(TypeInfo(TStringList), TDBTreeView, 'StoredFieldsList', TFieldsListProperty);
end;

end.

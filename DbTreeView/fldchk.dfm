object FldChooseDlg: TFldChooseDlg
  Left = 288
  Top = 296
  BorderStyle = bsDialog
  Caption = 'Choose fields'
  ClientHeight = 179
  ClientWidth = 273
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 177
    Height = 161
    Shape = bsFrame
  end
  object OKBtn: TButton
    Left = 188
    Top = 8
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelBtn: TButton
    Left = 188
    Top = 38
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object FieldsLB: TCheckListBox
    Left = 16
    Top = 16
    Width = 161
    Height = 145
    ItemHeight = 13
    TabOrder = 2
  end
end

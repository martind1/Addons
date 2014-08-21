object FormMain: TFormMain
  Left = 192
  Top = 107
  Width = 365
  Height = 421
  Caption = 'Simple testbed for PolyFit'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object LabelNumTerms: TLabel
    Left = 24
    Top = 344
    Width = 77
    Height = 13
    Caption = 'Number of terms'
  end
  object MemoResults: TMemo
    Left = 16
    Top = 16
    Width = 329
    Height = 313
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      'Memo1')
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
  end
  object ButtonClose: TButton
    Left = 272
    Top = 352
    Width = 73
    Height = 25
    Caption = 'Close'
    TabOrder = 1
    OnClick = ButtonCloseClick
  end
  object UpDownNumTerms: TUpDown
    Left = 81
    Top = 360
    Width = 15
    Height = 21
    Associate = EditNumTerms
    Min = 1
    Max = 5
    Position = 3
    TabOrder = 2
    Wrap = False
    OnClick = UpDownNumTermsClick
  end
  object EditNumTerms: TEdit
    Left = 32
    Top = 360
    Width = 49
    Height = 21
    ReadOnly = True
    TabOrder = 3
    Text = '3'
  end
end

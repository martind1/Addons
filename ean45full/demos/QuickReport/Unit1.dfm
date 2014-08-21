object Form1: TForm1
  Left = 160
  Top = 175
  Width = 407
  Height = 140
  Caption = 'Barcode library for Quickreport - demo'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 8
    Top = 8
    Width = 185
    Height = 41
    Caption = 'List supported barcode types'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 208
    Top = 8
    Width = 185
    Height = 41
    Caption = 'Barcode samples'
    TabOrder = 1
  end
  object Button3: TButton
    Left = 96
    Top = 64
    Width = 185
    Height = 41
    Caption = 'End'
    TabOrder = 2
    OnClick = Button3Click
  end
end

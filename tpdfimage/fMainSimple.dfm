object Form1: TForm1
  Left = 398
  Top = 110
  Width = 487
  Height = 610
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    471
    572)
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 20
    Top = 64
    Width = 437
    Height = 497
    Anchors = [akLeft, akTop, akRight, akBottom]
  end
  object Label1: TLabel
    Left = 256
    Top = 36
    Width = 32
    Height = 13
    Caption = 'Label1'
  end
  object btnLoad: TButton
    Left = 20
    Top = 28
    Width = 75
    Height = 25
    Caption = 'Load'
    TabOrder = 0
    OnClick = btnLoadClick
  end
  object btnPrev: TButton
    Left = 132
    Top = 28
    Width = 45
    Height = 25
    Caption = '<'
    TabOrder = 1
    OnClick = btnPrevClick
  end
  object btnNext: TButton
    Left = 184
    Top = 28
    Width = 45
    Height = 25
    Caption = '>'
    TabOrder = 2
    OnClick = btnNextClick
  end
  object btnZoomIn: TButton
    Left = 380
    Top = 28
    Width = 33
    Height = 25
    Caption = '+'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = btnZoomInClick
  end
  object btnZoomOut: TButton
    Left = 420
    Top = 28
    Width = 33
    Height = 25
    Caption = '-'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = btnZoomOutClick
  end
end

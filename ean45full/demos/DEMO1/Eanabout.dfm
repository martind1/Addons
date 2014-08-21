object PSoftAbout: TPSoftAbout
  Left = 111
  Top = 199
  BorderStyle = bsSingle
  Caption = 'About PSOFT'
  ClientHeight = 213
  ClientWidth = 543
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 328
    Top = 24
    Width = 196
    Height = 13
    Caption = 'PSOFT, ing. Peter ÈIRIP, Slovak republic'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 352
    Top = 40
    Width = 135
    Height = 13
    Caption = 'EMail : psoft@ke.telecom.sk'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 320
    Top = 80
    Width = 210
    Height = 13
    Caption = 'Thank you for use our Delphi components ...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Ean1: TEan
    Left = 8
    Top = 8
    Width = 297
    Height = 177
    AutoInc = False
    AutoIncFrom = 0
    AutoIncTo = 0
    BackgroundColor = clWhite
    Transparent = False
    ShowLabels = True
    StartStopLines = True
    TypBarCode = bcEan13
    LinesColor = clBlack
    Ean13AddUp = True
    FontAutoSize = True
    Security = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Arial'
    Font.Style = []
    BarCode = '9771210107001'
    DemoVersion = False
    Angle = 0
    Caption.Visible = False
    Caption.Font.Charset = DEFAULT_CHARSET
    Caption.Font.Color = clWindowText
    Caption.Font.Height = -13
    Caption.Font.Name = 'Arial'
    Caption.Font.Style = []
    Caption.AutoSize = True
    Caption.Alignment = taLeftJustify
    Caption.AutoCaption = True
    AutoSize = True
    DisableEditor = False
  end
  object Label4: TLabel
    Left = 358
    Top = 54
    Width = 126
    Height = 13
    Caption = 'www.ke.telecom.sk/psoft/'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Ean2: TEan
    Left = 448
    Top = 104
    Width = 81
    Height = 81
    AutoInc = False
    AutoIncFrom = 0
    AutoIncTo = 0
    BackgroundColor = clWhite
    Transparent = True
    ShowLabels = True
    StartStopLines = True
    TypBarCode = bcEan8
    LinesColor = clBlack
    Ean13AddUp = True
    FontAutoSize = True
    Security = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Arial'
    Font.Style = []
    BarCode = '12345670'
    DemoVersion = False
    Angle = 0
    Caption.Visible = False
    Caption.Font.Charset = DEFAULT_CHARSET
    Caption.Font.Color = clWindowText
    Caption.Font.Height = -13
    Caption.Font.Name = 'Arial'
    Caption.Font.Style = []
    Caption.AutoSize = True
    Caption.Alignment = taLeftJustify
    Caption.AutoCaption = True
    AutoSize = True
    DisableEditor = False
  end
  object BCName: TLabel
    Left = 8
    Top = 192
    Width = 297
    Height = 13
    AutoSize = False
    Caption = 'BCName'
  end
  object BitBtn1: TBitBtn
    Left = 352
    Top = 120
    Width = 75
    Height = 25
    TabOrder = 0
    Kind = bkClose
  end
  object Timer1: TTimer
    Interval = 2000
    OnTimer = Timer1Timer
    Left = 376
    Top = 160
  end
end

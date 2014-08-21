object EanDirectDraw: TEanDirectDraw
  Left = 6
  Top = 48
  BorderStyle = bsToolWindow
  Caption = 'Barcode printer - simple version (c) PSOFT, 1999'
  ClientHeight = 295
  ClientWidth = 423
  Font.Charset = EASTEUROPE_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 16
    Top = 128
    Width = 64
    Height = 14
    Caption = 'From position'
  end
  object Label3: TLabel
    Left = 16
    Top = 152
    Width = 30
    Height = 14
    Caption = 'Width '
  end
  object Label4: TLabel
    Left = 16
    Top = 176
    Width = 30
    Height = 14
    Caption = 'Height'
  end
  object Label5: TLabel
    Left = 192
    Top = 128
    Width = 54
    Height = 14
    Caption = 'Left margin'
  end
  object Label6: TLabel
    Left = 192
    Top = 152
    Width = 53
    Height = 14
    Caption = 'Top margin'
  end
  object Label7: TLabel
    Left = 192
    Top = 176
    Width = 166
    Height = 14
    Caption = 'Space between labels horizontally'
  end
  object Label8: TLabel
    Left = 192
    Top = 200
    Width = 154
    Height = 14
    Caption = 'Space between labels vertically'
  end
  object Label10: TLabel
    Left = 16
    Top = 200
    Width = 81
    Height = 14
    Caption = 'Number of labels'
  end
  object Label2: TLabel
    Left = 16
    Top = 224
    Width = 143
    Height = 14
    Caption = '(All distances in milimeters ...)'
  end
  object Label9: TLabel
    Left = 248
    Top = 0
    Width = 154
    Height = 55
    Caption = 'PSOFT'
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clWindowText
    Font.Height = -48
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object DemoLabel: TLabel
    Left = 216
    Top = 64
    Width = 201
    Height = 17
    Alignment = taCenter
    AutoSize = False
    Caption = 'Demo version'
    Color = 12639424
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
  object E_POSITION: TEdit
    Left = 120
    Top = 120
    Width = 50
    Height = 22
    Hint = 'Position on page counted form 0 to LabelCols*LabelRows'
    TabOrder = 0
    Text = '0'
  end
  object EAN: TEan
    Left = 8
    Top = 8
    Width = 193
    Height = 105
    Hint = 'Double click to invoke barcode editor'
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
    Caption.Visible = True
    Caption.Font.Charset = DEFAULT_CHARSET
    Caption.Font.Color = clWindowText
    Caption.Font.Height = -13
    Caption.Font.Name = 'Arial'
    Caption.Font.Style = []
    Caption.Alignment = taLeftJustify
    CaptionBottom.Visible = True
    CaptionBottom.Font.Charset = DEFAULT_CHARSET
    CaptionBottom.Font.Color = clWindowText
    CaptionBottom.Font.Height = -13
    CaptionBottom.Font.Name = 'Arial'
    CaptionBottom.Font.Style = []
    CaptionBottom.Alignment = taLeftJustify
    HorzLines.LinesCount = 0
    AutoCheckDigit = True
  end
  object E_WIDTH: TEdit
    Left = 120
    Top = 144
    Width = 50
    Height = 22
    TabOrder = 2
    Text = '40'
  end
  object E_HEIGHT: TEdit
    Left = 120
    Top = 168
    Width = 50
    Height = 22
    TabOrder = 3
    Text = '25'
  end
  object E_LEFT: TEdit
    Left = 368
    Top = 120
    Width = 50
    Height = 22
    TabOrder = 4
    Text = '20'
  end
  object E_TOP: TEdit
    Left = 368
    Top = 144
    Width = 50
    Height = 22
    TabOrder = 5
    Text = '20'
  end
  object E_HOR: TEdit
    Left = 368
    Top = 168
    Width = 50
    Height = 22
    TabOrder = 6
    Text = '5'
  end
  object E_VER: TEdit
    Left = 368
    Top = 192
    Width = 50
    Height = 22
    TabOrder = 7
    Text = '5'
  end
  object BitBtn1: TBitBtn
    Left = 8
    Top = 264
    Width = 100
    Height = 25
    Caption = '&Print barcodes'
    TabOrder = 8
    OnClick = BitBtn1Click
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      0400000000000001000000000000000000001000000010000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00300000000000
      0003377777777777777308888888888888807F33333333333337088888888888
      88807FFFFFFFFFFFFFF7000000000000000077777777777777770F8F8F8F8F8F
      8F807F333333333333F708F8F8F8F8F8F9F07F333333333337370F8F8F8F8F8F
      8F807FFFFFFFFFFFFFF7000000000000000077777777777777773330FFFFFFFF
      03333337F3FFFF3F7F333330F0000F0F03333337F77773737F333330FFFFFFFF
      03333337F3FF3FFF7F333330F00F000003333337F773777773333330FFFF0FF0
      33333337F3F37F3733333330F08F0F0333333337F7337F7333333330FFFF0033
      33333337FFFF7733333333300000033333333337777773333333}
    NumGlyphs = 2
  end
  object BitBtn2: TBitBtn
    Left = 112
    Top = 264
    Width = 100
    Height = 25
    Caption = '&Setup printer'
    TabOrder = 9
    OnClick = BitBtn2Click
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      0400000000000001000000000000000000001000000010000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555550FF0559
      1950555FF75F7557F7F757000FF055591903557775F75557F77570FFFF055559
      1933575FF57F5557F7FF0F00FF05555919337F775F7F5557F7F700550F055559
      193577557F7F55F7577F07550F0555999995755575755F7FFF7F5570F0755011
      11155557F755F777777555000755033305555577755F75F77F55555555503335
      0555555FF5F75F757F5555005503335505555577FF75F7557F55505050333555
      05555757F75F75557F5505000333555505557F777FF755557F55000000355557
      07557777777F55557F5555000005555707555577777FF5557F55553000075557
      0755557F7777FFF5755555335000005555555577577777555555}
    NumGlyphs = 2
  end
  object BitBtn3: TBitBtn
    Left = 216
    Top = 264
    Width = 100
    Height = 25
    TabOrder = 10
    Kind = bkHelp
  end
  object E_COUNT: TEdit
    Left = 120
    Top = 192
    Width = 50
    Height = 22
    TabOrder = 11
    Text = '20'
  end
  object PB: TProgressBar
    Left = 8
    Top = 240
    Width = 409
    Height = 16
    Min = 0
    Max = 100
    TabOrder = 12
    Visible = False
  end
  object BitBtn4: TBitBtn
    Left = 216
    Top = 88
    Width = 201
    Height = 25
    Caption = '&Barcode properties'
    TabOrder = 13
    OnClick = BitBtn4Click
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      0400000000000001000000000000000000001000000010000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333303333
      333333333337FF3333333333330003333333333333777F333333333333080333
      3333333F33777FF33F3333B33B000B33B3333373F777773F7333333BBB0B0BBB
      33333337737F7F77F333333BBB0F0BBB33333337337373F73F3333BBB0F7F0BB
      B333337F3737F73F7F3333BB0FB7BF0BB3333F737F37F37F73FFBBBB0BF7FB0B
      BBB3773F7F37337F377333BB0FBFBF0BB333337F73F333737F3333BBB0FBF0BB
      B3333373F73FF7337333333BBB000BBB33333337FF777337F333333BBBBBBBBB
      3333333773FF3F773F3333B33BBBBB33B33333733773773373333333333B3333
      333333333337F33333333333333B333333333333333733333333}
    NumGlyphs = 2
  end
  object BitBtn5: TBitBtn
    Left = 320
    Top = 264
    Width = 100
    Height = 25
    TabOrder = 14
    Kind = bkClose
  end
  object PS: TPrinterSetupDialog
    Left = 72
    Top = 152
  end
end

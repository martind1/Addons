object Rpt2: TRpt2
  Left = -4
  Top = -4
  Width = 808
  Height = 608
  VertScrollBar.Position = 30
  Caption = 'Rpt2'
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 13
  object QR2: TQuickRep
    Left = 14
    Top = -21
    Width = 794
    Height = 1123
    Frame.Color = clBlack
    Frame.DrawTop = False
    Frame.DrawBottom = False
    Frame.DrawLeft = False
    Frame.DrawRight = False
    BeforePrint = QR2BeforePrint
    Description.Strings = (
      'Example using Quick report Barcode components')
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    Options = [FirstPageHeader, LastPageFooter]
    Page.Columns = 1
    Page.Orientation = poPortrait
    Page.PaperSize = A4
    Page.Values = (
      100
      2970
      100
      2100
      100
      100
      0)
    PrintIfEmpty = True
    PrinterSettings.Copies = 1
    PrinterSettings.Duplex = False
    PrinterSettings.FirstPage = 0
    PrinterSettings.LastPage = 0
    PrinterSettings.OutputBin = First
    ShowProgress = False
    SnapToGrid = True
    Units = MM
    Zoom = 100
    object QRBand1: TQRBand
      Left = 38
      Top = 57
      Width = 718
      Height = 115
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      Color = clWhite
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        304.270833333333
        1899.70833333333)
      BandType = rbTitle
      object QRLabel1: TQRLabel
        Left = 156
        Top = 24
        Width = 406
        Height = 33
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          87.3125
          412.75
          63.5
          1074.20833333333)
        Alignment = taCenter
        AlignToBand = True
        AutoSize = True
        AutoStretch = False
        Caption = 'Example Barcode components'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -27
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 20
      end
      object QRMemo2: TQRMemo
        Left = 56
        Top = 72
        Width = 577
        Height = 23
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          60.8541666666667
          148.166666666667
          190.5
          1526.64583333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        Lines.Strings = (
          'Here we show all types of bar code supported by BARCODE library.')
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
    end
    object QRSubDetail1: TQRSubDetail
      Left = 38
      Top = 172
      Width = 718
      Height = 256
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      Color = clWhite
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        677.333333333333
        1899.70833333333)
      Master = QR2
      OnNeedData = QR2NeedData
      PrintBefore = False
      PrintIfEmpty = False
      object QR_BarcodeName: TQRLabel
        Left = 48
        Top = 24
        Width = 337
        Height = 30
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          79.375
          127
          63.5
          891.645833333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QR_BarcodeName'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -24
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 18
      end
      object E1: TQrEan
        Left = 32
        Top = 128
        Width = 174
        Height = 121
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          320.145833333333
          84.6666666666667
          338.666666666667
          460)
        BackgroundColor = clLime
        Transparent = True
        ShowLabels = True
        StartStopLines = True
        TypBarCode = bcEan13
        LinesColor = clBlack
        Ean13AddUp = True
        FontAutoSize = True
        Security = False
        DemoVersion = False
        BarCode = '9771210107001'
        Angle = 0
        LabelMask = '__________________________________________________'
        CharWidthMM = 3.5
        AutoSize = False
        DisableEditor = False
      end
      object QRText: TQRMemo
        Left = 48
        Top = 56
        Width = 337
        Height = 41
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          108.479166666667
          127
          148.166666666667
          891.645833333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object QRShape1: TQRShape
        Left = 16
        Top = 8
        Width = 697
        Height = 5
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          13.2291666666667
          42.3333333333333
          21.1666666666667
          1844.14583333333)
        Pen.Width = 3
        Shape = qrsHorLine
      end
      object E2: TQrEan
        Left = 224
        Top = 130
        Width = 174
        Height = 119
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          314.854166666667
          592.666666666667
          343.958333333333
          460)
        BackgroundColor = clLime
        Transparent = True
        ShowLabels = True
        StartStopLines = True
        TypBarCode = bcEan13
        LinesColor = clBlack
        Ean13AddUp = True
        FontAutoSize = True
        Security = False
        DemoVersion = False
        BarCode = '9771210107001'
        Angle = 0
        LabelMask = '__________________________________________________'
        CharWidthMM = 3.5
        AutoSize = False
        DisableEditor = False
      end
      object E3: TQrEan
        Left = 448
        Top = 128
        Width = 174
        Height = 120
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          317.5
          1185.33333333333
          338.666666666667
          460)
        BackgroundColor = clLime
        Transparent = True
        ShowLabels = True
        StartStopLines = True
        TypBarCode = bcEan13
        LinesColor = clBlack
        Ean13AddUp = True
        FontAutoSize = True
        Security = False
        DemoVersion = False
        BarCode = '9771210107001'
        Angle = 0
        LabelMask = '__________________________________________________'
        CharWidthMM = 3.5
        AutoSize = False
        DisableEditor = False
      end
      object L2: TQRLabel
        Left = 392
        Top = 40
        Width = 313
        Height = 81
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          214.3125
          1037.16666666667
          105.833333333333
          828.145833333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QR2'
        Color = clWhite
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object QRLabel2: TQRLabel
        Left = 392
        Top = 16
        Width = 179
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1037.16666666667
          42.3333333333333
          473.604166666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Set of available characters :'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
    end
    object QRBand2: TQRBand
      Left = 38
      Top = 38
      Width = 718
      Height = 19
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      Color = clWhite
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        50.2708333333333
        1899.70833333333)
      BandType = rbPageHeader
      object QRSysData1: TQRSysData
        Left = 640
        Top = 2
        Width = 46
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1693.33333333333
          5.29166666666667
          121.708333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        Color = clWhite
        Data = qrsPageNumber
        Transparent = False
        FontSize = 10
      end
    end
  end
end

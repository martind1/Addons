object Rpt3: TRpt3
  Left = 95
  Top = 77
  Width = 544
  Height = 375
  VertScrollBar.Position = 57
  Caption = 'Rpt3'
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 13
  object QR3: TQuickRep
    Left = 8
    Top = -25
    Width = 794
    Height = 1123
    Frame.Color = clBlack
    Frame.DrawTop = False
    Frame.DrawBottom = False
    Frame.DrawLeft = False
    Frame.DrawRight = False
    BeforePrint = QR3BeforePrint
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
    SnapToGrid = True
    Units = MM
    Zoom = 100
    object QRBand1: TQRBand
      Left = 38
      Top = 38
      Width = 718
      Height = 59
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
        156.104166666667
        1899.70833333333)
      BandType = rbTitle
      object QRLabel1: TQRLabel
        Left = -222
        Top = 16
        Width = 459
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          66.1458333333333
          341.3125
          42.3333333333333
          1214.4375)
        Alignment = taCenter
        AlignToBand = True
        AutoSize = False
        AutoStretch = False
        Caption = 'Demo for property CharWidthMM (8mm/char) '
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -21
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 16
      end
    end
    object QRSubDetail1: TQRSubDetail
      Left = 38
      Top = 97
      Width = 718
      Height = 135
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
        357.1875
        1899.70833333333)
      Master = QR3
      OnNeedData = QRSubDetail1NeedData
      PrintBefore = False
      PrintIfEmpty = False
      object L1: TQRLabel
        Left = 16
        Top = 16
        Width = 15
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          42.3333333333333
          42.3333333333333
          39.6875)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'L1'
        Color = clWhite
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object L2: TQRLabel
        Left = 16
        Top = 56
        Width = 15
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          42.3333333333333
          148.166666666667
          39.6875)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'L2'
        Color = clWhite
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object E1: TQrEan
        Left = 120
        Top = 15
        Width = 151
        Height = 105
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          277.8125
          317.5
          39.6875
          400)
        BackgroundColor = clWhite
        Transparent = False
        ShowLabels = True
        StartStopLines = True
        TypBarCode = bcCode39Standard
        LinesColor = clBlack
        Ean13AddUp = True
        FontAutoSize = True
        Security = False
        DemoVersion = False
        BarCode = 'PSOFT'
        Angle = 0
        CharWidthMM = 8
        AutoSize = True
        DisableEditor = False
      end
    end
  end
end

object Form2: TForm2
  Left = 370
  Top = 239
  Width = 918
  Height = 597
  Caption = 'Form2'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 13
  object QR1: TQuickRep
    Left = 8
    Top = 8
    Width = 794
    Height = 1123
    Frame.Color = clBlack
    Frame.DrawTop = False
    Frame.DrawBottom = False
    Frame.DrawLeft = False
    Frame.DrawRight = False
    BeforePrint = QR1BeforePrint
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    Functions.Strings = (
      'PAGENUMBER'
      'COLUMNNUMBER'
      'REPORTTITLE')
    Functions.DATA = (
      '0'
      '0'
      #39#39)
    OnNeedData = QR1NeedData
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
    PrinterSettings.Copies = 1
    PrinterSettings.OutputBin = First
    PrinterSettings.Duplex = False
    PrinterSettings.FirstPage = 0
    PrinterSettings.LastPage = 0
    PrinterSettings.UseStandardprinter = False
    PrinterSettings.UseCustomBinCode = False
    PrinterSettings.CustomBinCode = 0
    PrinterSettings.ExtendedDuplex = 0
    PrinterSettings.UseCustomPaperCode = False
    PrinterSettings.CustomPaperCode = 0
    PrinterSettings.PrintMetaFile = False
    PrintIfEmpty = False
    SnapToGrid = True
    Units = MM
    Zoom = 100
    PrevFormStyle = fsNormal
    PreviewInitialState = wsNormal
    object QRBand1: TQRBand
      Left = 38
      Top = 38
      Width = 718
      Height = 91
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
        240.770833333333
        1899.70833333333)
      BandType = rbTitle
      object QRLabel1: TQRLabel
        Left = 184
        Top = 8
        Width = 291
        Height = 50
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          132.291666666667
          486.833333333333
          21.1666666666667
          769.9375)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Barcode library'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -43
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 32
      end
      object QRLabel2: TQRLabel
        Left = 144
        Top = 56
        Width = 404
        Height = 23
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          60.8541666666667
          381
          148.166666666667
          1068.91666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'for latest version please look http://www.psoft.sk'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 14
      end
      object QRShape1: TQRShape
        Left = 0
        Top = 81
        Width = 718
        Height = 3
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          7.9375
          0
          214.3125
          1899.70833333333)
        Brush.Color = clBlack
        Shape = qrsRectangle
        VertAdjust = 0
      end
    end
    object QRBand2: TQRBand
      Left = 38
      Top = 129
      Width = 718
      Height = 128
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
        338.666666666667
        1899.70833333333)
      BandType = rbDetail
      object QrEan1: TQrEan
        Left = 8
        Top = 16
        Width = 177
        Height = 81
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          214.3125
          21.1666666666667
          42.3333333333333
          468.3125)
        BackgroundColor = clWhite
        Transparent = False
        ShowLabels = True
        StartStopLines = True
        TypBarCode = bcEan13
        LinesColor = clBlack
        Ean13AddUp = True
        FontAutoSize = True
        Security = False
        BarCode = '0012345678905'
        Angle = 0
        AutoSize = True
        DisableEditor = False
        HorzLines.LinesCount = 0
        AutoCheckDigit = True
        Ean = {
          54504630045445616E00044C656674020003546F700200055769647468027B06
          4865696768740250074175746F496E63080B4175746F496E6346726F6D020009
          4175746F496E63546F02000F4261636B67726F756E64436F6C6F720707636C57
          686974650B5472616E73706172656E74080A53686F774C6162656C73090E5374
          61727453746F704C696E6573090A547970426172436F64650707626345616E31
          330A4C696E6573436F6C6F720707636C426C61636B0A45616E31334164645570
          090C466F6E744175746F53697A6509085365637572697479080C466F6E742E43
          686172736574070F44454641554C545F434841525345540A466F6E742E436F6C
          6F72070C636C57696E646F77546578740B466F6E742E48656967687402F30946
          6F6E742E4E616D650605417269616C0A466F6E742E5374796C650B0007426172
          436F6465060D303031323334353637383930350F43617074696F6E2E56697369
          626C65091443617074696F6E2E466F6E742E43686172736574070F4445464155
          4C545F434841525345541243617074696F6E2E466F6E742E436F6C6F72070C63
          6C57696E646F77546578741343617074696F6E2E466F6E742E48656967687402
          F31143617074696F6E2E466F6E742E4E616D650605417269616C124361707469
          6F6E2E466F6E742E5374796C650B001143617074696F6E2E416C69676E6D656E
          74070D74614C6566744A7573746966791543617074696F6E426F74746F6D2E56
          697369626C65091A43617074696F6E426F74746F6D2E466F6E742E4368617273
          6574070F44454641554C545F434841525345541843617074696F6E426F74746F
          6D2E466F6E742E436F6C6F72070C636C57696E646F7754657874194361707469
          6F6E426F74746F6D2E466F6E742E48656967687402F31743617074696F6E426F
          74746F6D2E466F6E742E4E616D650605417269616C1843617074696F6E426F74
          746F6D2E466F6E742E5374796C650B001743617074696F6E426F74746F6D2E41
          6C69676E6D656E74070D74614C6566744A75737469667914486F727A4C696E65
          732E4C696E6573436F756E7402000E4175746F436865636B4469676974090B50
          44463431372E4D6F646507147073504446343137416C7068616E756D65726963
          145044463431372E53656375726974794C6576656C070E707350444634313741
          75746F4543105044463431372E5472756E636174656408135044463431372E50
          61696E744966536D616C6C090000}
      end
      object QRLabel3: TQRLabel
        Left = 200
        Top = 16
        Width = 78
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          529.166666666667
          42.3333333333333
          206.375)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Barcode type'
        Color = clWhite
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object QRLabel4: TQRLabel
        Left = 200
        Top = 40
        Width = 48
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          529.166666666667
          105.833333333333
          127)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'CharSet'
        Color = clWhite
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object QL_TYPE: TQRLabel
        Left = 328
        Top = 16
        Width = 59
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          867.833333333333
          42.3333333333333
          156.104166666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'QL_TYPE'
        Color = clWhite
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object QL_CHARSET: TQRMemo
        Left = 328
        Top = 40
        Width = 385
        Height = 81
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          214.3125
          867.833333333333
          105.833333333333
          1018.64583333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = True
        Color = clWhite
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
    end
    object QRBand3: TQRBand
      Left = 38
      Top = 257
      Width = 718
      Height = 72
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
        190.5
        1899.70833333333)
      BandType = rbSummary
      object QRLabel7: TQRLabel
        Left = 144
        Top = 8
        Width = 404
        Height = 23
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          60.8541666666667
          381
          21.1666666666667
          1068.91666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'for latest version please look http://www.psoft.sk'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 14
      end
      object QRLabel8: TQRLabel
        Left = 160
        Top = 32
        Width = 378
        Height = 23
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          60.8541666666667
          423.333333333333
          84.6666666666667
          1000.125)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'email : psoft@stonline.sk, barcode@psoft.sk'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 14
      end
    end
  end
end

object Form1: TForm1
  Left = 63
  Top = 172
  Width = 416
  Height = 75
  Caption = 'PSOFT Barcode library - PDF417 demo for ReportBuilder'
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  PixelsPerInch = 96
  TextHeight = 13
  object BitBtn1: TBitBtn
    Left = 160
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Print'
    TabOrder = 0
    OnClick = BitBtn1Click
    Glyph.Data = {
      4E010000424D4E01000000000000760000002800000012000000120000000100
      040000000000D800000000000000000000001000000010000000000000000000
      BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00DDDDDDDDDDDD
      DDDDDD000000DDD00000000000DDDD000000DD0777777777070DDD000000D000
      000000000070DD000000D0777777FFF77000DD000000D077777799977070DD00
      0000D0000000000000770D000000D0777777777707070D000000DD0000000000
      70700D000000DDD0FFFFFFFF07070D000000DDDD0FCCCCCF0000DD000000DDDD
      0FFFFFFFF0DDDD000000DDDDD0FCCCCCF0DDDD000000DDDDD0FFFFFFFF0DDD00
      0000DDDDDD000000000DDD000000DDDDDDDDDDDDDDDDDD000000DDDDDDDDDDDD
      DDDDDD000000DDDDDDDDDDDDDDDDDD000000}
  end
  object RPT: TppReport
    PrinterSetup.BinName = 'Default'
    PrinterSetup.DocumentName = 'Report'
    PrinterSetup.PaperName = 'A4'
    PrinterSetup.PrinterName = 'Default'
    PrinterSetup.mmMarginBottom = 6350
    PrinterSetup.mmMarginLeft = 6350
    PrinterSetup.mmMarginRight = 6350
    PrinterSetup.mmMarginTop = 6350
    PrinterSetup.mmPaperHeight = 297000
    PrinterSetup.mmPaperWidth = 210000
    UserName = 'Report'
    BeforePrint = RPTBeforePrint
    DeviceType = 'Screen'
    Left = 104
    Top = 8
    Version = '4.23'
    mmColumnWidth = 0
    object ppHeaderBand1: TppHeaderBand
      mmBottomOffset = 0
      mmHeight = 10319
      mmPrintPosition = 0
      object ppShape1: TppShape
        UserName = 'Shape1'
        Brush.Color = clSilver
        mmHeight = 7938
        mmLeft = 4233
        mmTop = 2381
        mmWidth = 191030
        BandType = 0
      end
      object ppLabel1: TppLabel
        UserName = 'Label1'
        Alignment = taCenter
        AutoSize = False
        Caption = 'PSOFT Barcode library - PDF417 demo for ReportBuilder'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 16
        Font.Style = []
        Transparent = True
        mmHeight = 6350
        mmLeft = 6085
        mmTop = 3440
        mmWidth = 184944
        BandType = 0
      end
    end
    object ppDetailBand1: TppDetailBand
      mmBottomOffset = 0
      mmHeight = 238655
      mmPrintPosition = 0
      object ppLabel2: TppLabel
        UserName = 'Label2'
        Caption = 'Compaction/Compression modes'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 14
        Font.Style = [fsUnderline]
        Transparent = True
        mmHeight = 5821
        mmLeft = 1058
        mmTop = 2117
        mmWidth = 75406
        BandType = 4
      end
      object BC: TRBEan
        UserName = 'BC'
        BackgroundColor = clWhite
        Transparent = False
        ShowLabels = True
        StartStopLines = True
        TypBarCode = bcPDF417
        LinesColor = clBlack
        Ean13AddUp = True
        FontAutoSize = True
        Security = False
        DemoVersion = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 14
        Font.Style = [fsUnderline]
        BarCode = 'PSOFT, http://www.psoft.sk, email: peter@psoft.sk'
        Angle = 0
        DisableEditor = False
        mmHeight = 31221
        mmLeft = 4498
        mmTop = 27781
        mmWidth = 52917
        BandType = 4
      end
      object ppLabel3: TppLabel
        UserName = 'Label3'
        AutoSize = False
        Caption = 
          'Text compaction - max.capacity: 1800 characters. Available chars' +
          ': A-Z, a-z, 0-9, &,:#-.$/+%*=^;<>@[\]_`~!"|()?'#39' CR, LF, TAB'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = []
        Transparent = True
        WordWrap = True
        mmHeight = 16933
        mmLeft = 4763
        mmTop = 9525
        mmWidth = 62971
        BandType = 4
      end
      object ppLabel4: TppLabel
        UserName = 'Label4'
        AutoSize = False
        Caption = 
          'Numeric compaction - max.capacity: 2700 digits. Available chars ' +
          ': 0-9'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = []
        Transparent = True
        WordWrap = True
        mmHeight = 16933
        mmLeft = 70908
        mmTop = 9525
        mmWidth = 62971
        BandType = 4
      end
      object BC2: TRBEan
        UserName = 'BC1'
        BackgroundColor = clWhite
        Transparent = False
        ShowLabels = True
        StartStopLines = True
        TypBarCode = bcPDF417
        LinesColor = clBlack
        Ean13AddUp = True
        FontAutoSize = True
        Security = False
        DemoVersion = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 14
        Font.Style = [fsUnderline]
        BarCode = 'PSOFT, http://www.psoft.sk, email: peter@psoft.sk'
        Angle = 0
        DisableEditor = False
        mmHeight = 31221
        mmLeft = 70644
        mmTop = 27781
        mmWidth = 52917
        BandType = 4
      end
      object ppLabel5: TppLabel
        UserName = 'Label5'
        AutoSize = False
        Caption = 
          'Binary compaction - max. capacity : 1100 bytes, Available chars ' +
          ': ASCII 0-255.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = []
        Transparent = True
        WordWrap = True
        mmHeight = 16933
        mmLeft = 133615
        mmTop = 9790
        mmWidth = 62971
        BandType = 4
      end
      object BC3: TRBEan
        UserName = 'BC2'
        BackgroundColor = clWhite
        Transparent = False
        ShowLabels = True
        StartStopLines = True
        TypBarCode = bcPDF417
        LinesColor = clBlack
        Ean13AddUp = True
        FontAutoSize = True
        Security = False
        DemoVersion = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 14
        Font.Style = [fsUnderline]
        BarCode = 'PSOFT, http://www.psoft.sk, email: peter@psoft.sk'
        Angle = 0
        DisableEditor = False
        mmHeight = 31221
        mmLeft = 139436
        mmTop = 27781
        mmWidth = 52917
        BandType = 4
      end
      object ppShape2: TppShape
        UserName = 'Shape2'
        mmHeight = 265
        mmLeft = 1852
        mmTop = 61648
        mmWidth = 194205
        BandType = 4
      end
      object ppLabel6: TppLabel
        UserName = 'Label6'
        Caption = 'Error levels/ Damaged barcode sample'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 14
        Font.Style = [fsUnderline]
        Transparent = True
        mmHeight = 5821
        mmLeft = 1058
        mmTop = 63765
        mmWidth = 87577
        BandType = 4
      end
      object ppLabel7: TppLabel
        UserName = 'Label7'
        Caption = 'Error level 0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = [fsUnderline]
        Transparent = True
        mmHeight = 4233
        mmLeft = 1588
        mmTop = 70908
        mmWidth = 17992
        BandType = 4
      end
      object RBEan1: TRBEan
        UserName = 'Ean1'
        BackgroundColor = clWhite
        Transparent = False
        ShowLabels = True
        StartStopLines = True
        TypBarCode = bcPDF417
        LinesColor = clBlack
        Ean13AddUp = True
        FontAutoSize = True
        Security = False
        DemoVersion = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = [fsUnderline]
        BarCode = 'PSOFT, http://www.psoft.sk, email: peter@psoft.sk'
        Angle = 0
        DisableEditor = False
        mmHeight = 4233
        mmLeft = 1588
        mmTop = 75936
        mmWidth = 54504
        BandType = 4
      end
      object RBEan2: TRBEan
        UserName = 'Ean2'
        BackgroundColor = clWhite
        Transparent = False
        ShowLabels = True
        StartStopLines = True
        TypBarCode = bcPDF417
        LinesColor = clBlack
        Ean13AddUp = True
        FontAutoSize = True
        Security = False
        DemoVersion = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = [fsUnderline]
        BarCode = 'PSOFT, http://www.psoft.sk, email: peter@psoft.sk'
        Angle = 0
        DisableEditor = False
        mmHeight = 6879
        mmLeft = 68792
        mmTop = 76465
        mmWidth = 54504
        BandType = 4
      end
      object ppLabel8: TppLabel
        UserName = 'Label8'
        Caption = 'Error level 1'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = [fsUnderline]
        Transparent = True
        mmHeight = 4233
        mmLeft = 68792
        mmTop = 71438
        mmWidth = 17992
        BandType = 4
      end
      object RBEan3: TRBEan
        UserName = 'Ean3'
        BackgroundColor = clWhite
        Transparent = False
        ShowLabels = True
        StartStopLines = True
        TypBarCode = bcPDF417
        LinesColor = clBlack
        Ean13AddUp = True
        FontAutoSize = True
        Security = False
        DemoVersion = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = [fsUnderline]
        BarCode = 'PSOFT, http://www.psoft.sk, email: peter@psoft.sk'
        Angle = 0
        DisableEditor = False
        mmHeight = 8731
        mmLeft = 138377
        mmTop = 76200
        mmWidth = 54504
        BandType = 4
      end
      object ppLabel9: TppLabel
        UserName = 'Label9'
        Caption = 'Error level 2'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = [fsUnderline]
        Transparent = True
        mmHeight = 4233
        mmLeft = 138377
        mmTop = 71173
        mmWidth = 17992
        BandType = 4
      end
      object ppLabel10: TppLabel
        UserName = 'Label10'
        Caption = 'Error level 3'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = [fsUnderline]
        Transparent = True
        mmHeight = 4233
        mmLeft = 2117
        mmTop = 89165
        mmWidth = 17992
        BandType = 4
      end
      object RBEan4: TRBEan
        UserName = 'Ean4'
        BackgroundColor = clWhite
        Transparent = False
        ShowLabels = True
        StartStopLines = True
        TypBarCode = bcPDF417
        LinesColor = clBlack
        Ean13AddUp = True
        FontAutoSize = True
        Security = False
        DemoVersion = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = [fsUnderline]
        BarCode = 'PSOFT, http://www.psoft.sk, email: peter@psoft.sk'
        Angle = 0
        DisableEditor = False
        mmHeight = 10583
        mmLeft = 2117
        mmTop = 94192
        mmWidth = 54504
        BandType = 4
      end
      object RBEan5: TRBEan
        UserName = 'Ean5'
        BackgroundColor = clWhite
        Transparent = False
        ShowLabels = True
        StartStopLines = True
        TypBarCode = bcPDF417
        LinesColor = clBlack
        Ean13AddUp = True
        FontAutoSize = True
        Security = False
        DemoVersion = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = [fsUnderline]
        BarCode = 'PSOFT, http://www.psoft.sk, email: peter@psoft.sk'
        Angle = 0
        DisableEditor = False
        mmHeight = 15610
        mmLeft = 69321
        mmTop = 94721
        mmWidth = 54504
        BandType = 4
      end
      object ppLabel11: TppLabel
        UserName = 'Label11'
        Caption = 'Error level 4'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = [fsUnderline]
        Transparent = True
        mmHeight = 4233
        mmLeft = 69321
        mmTop = 89694
        mmWidth = 17992
        BandType = 4
      end
      object RBEan6: TRBEan
        UserName = 'Ean6'
        BackgroundColor = clWhite
        Transparent = False
        ShowLabels = True
        StartStopLines = True
        TypBarCode = bcPDF417
        LinesColor = clBlack
        Ean13AddUp = True
        FontAutoSize = True
        Security = False
        DemoVersion = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = [fsUnderline]
        BarCode = 'PSOFT, http://www.psoft.sk, email: peter@psoft.sk'
        Angle = 0
        DisableEditor = False
        mmHeight = 19844
        mmLeft = 138907
        mmTop = 94456
        mmWidth = 54504
        BandType = 4
      end
      object ppLabel12: TppLabel
        UserName = 'Label12'
        Caption = 'Error level 5'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = [fsUnderline]
        Transparent = True
        mmHeight = 4233
        mmLeft = 138907
        mmTop = 89429
        mmWidth = 17992
        BandType = 4
      end
      object ppLabel13: TppLabel
        UserName = 'Label101'
        Caption = 'Error level 6'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = [fsUnderline]
        Transparent = True
        mmHeight = 4233
        mmLeft = 1588
        mmTop = 115888
        mmWidth = 17992
        BandType = 4
      end
      object RBEan7: TRBEan
        UserName = 'Ean7'
        BackgroundColor = clWhite
        Transparent = False
        ShowLabels = True
        StartStopLines = True
        TypBarCode = bcPDF417
        LinesColor = clBlack
        Ean13AddUp = True
        FontAutoSize = True
        Security = False
        DemoVersion = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = [fsUnderline]
        BarCode = 'PSOFT, http://www.psoft.sk, email: peter@psoft.sk'
        Angle = 0
        DisableEditor = False
        mmHeight = 24342
        mmLeft = 1588
        mmTop = 120915
        mmWidth = 54504
        BandType = 4
      end
      object RBEan8: TRBEan
        UserName = 'Ean8'
        BackgroundColor = clWhite
        Transparent = False
        ShowLabels = True
        StartStopLines = True
        TypBarCode = bcPDF417
        LinesColor = clBlack
        Ean13AddUp = True
        FontAutoSize = True
        Security = False
        DemoVersion = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = [fsUnderline]
        BarCode = 'PSOFT, http://www.psoft.sk, email: peter@psoft.sk'
        Angle = 0
        DisableEditor = False
        mmHeight = 36248
        mmLeft = 68792
        mmTop = 121444
        mmWidth = 54504
        BandType = 4
      end
      object ppLabel14: TppLabel
        UserName = 'Label14'
        Caption = 'Error level 7'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = [fsUnderline]
        Transparent = True
        mmHeight = 4233
        mmLeft = 68792
        mmTop = 116417
        mmWidth = 17992
        BandType = 4
      end
      object RBEan9: TRBEan
        UserName = 'Ean9'
        BackgroundColor = clWhite
        Transparent = False
        ShowLabels = True
        StartStopLines = True
        TypBarCode = bcPDF417
        LinesColor = clBlack
        Ean13AddUp = True
        FontAutoSize = True
        Security = False
        DemoVersion = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = [fsUnderline]
        BarCode = 'PSOFT, http://www.psoft.sk, email: peter@psoft.sk'
        Angle = 0
        DisableEditor = False
        mmHeight = 42863
        mmLeft = 138377
        mmTop = 121179
        mmWidth = 54504
        BandType = 4
      end
      object ppLabel15: TppLabel
        UserName = 'Label15'
        Caption = 'Error level 8'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = [fsUnderline]
        Transparent = True
        mmHeight = 4233
        mmLeft = 138377
        mmTop = 116152
        mmWidth = 17992
        BandType = 4
      end
      object ppLabel16: TppLabel
        UserName = 'Label13'
        Caption = 'Error level 6 - damaged, but readable code'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = [fsBold]
        Transparent = True
        mmHeight = 4233
        mmLeft = 2646
        mmTop = 162190
        mmWidth = 72231
        BandType = 4
      end
      object RBEan10: TRBEan
        UserName = 'Ean10'
        BackgroundColor = clWhite
        Transparent = False
        ShowLabels = True
        StartStopLines = True
        TypBarCode = bcPDF417
        LinesColor = clBlack
        Ean13AddUp = True
        FontAutoSize = True
        Security = False
        DemoVersion = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = [fsUnderline]
        BarCode = 'PSOFT, http://www.psoft.sk, email: peter@psoft.sk'
        Angle = 0
        DisableEditor = False
        mmHeight = 20373
        mmLeft = 2646
        mmTop = 167482
        mmWidth = 52388
        BandType = 4
      end
      object ppShape3: TppShape
        UserName = 'Shape3'
        Brush.Color = clSilver
        Brush.Style = bsCross
        mmHeight = 12965
        mmLeft = 42863
        mmTop = 178065
        mmWidth = 25665
        BandType = 4
      end
      object ppLine1: TppLine
        UserName = 'Line1'
        Pen.Color = clRed
        Pen.Width = 5
        Position = lpBottom
        Style = lsDouble
        Weight = 3.75
        mmHeight = 5292
        mmLeft = 10319
        mmTop = 168011
        mmWidth = 31485
        BandType = 4
      end
      object ppLabel17: TppLabel
        UserName = 'Label16'
        Caption = 'PSOFT'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 32
        Font.Style = [fsBold]
        Transparent = True
        mmHeight = 13494
        mmLeft = 7938
        mmTop = 172773
        mmWidth = 38100
        BandType = 4
      end
      object ppShape4: TppShape
        UserName = 'Shape4'
        mmHeight = 265
        mmLeft = 1852
        mmTop = 193411
        mmWidth = 194205
        BandType = 4
      end
      object ppLabel18: TppLabel
        UserName = 'Label18'
        Caption = 'Property Cols'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 14
        Font.Style = [fsUnderline]
        Transparent = True
        mmHeight = 5821
        mmLeft = 1588
        mmTop = 195263
        mmWidth = 30692
        BandType = 4
      end
      object ppLabel19: TppLabel
        UserName = 'Label19'
        Caption = 'Cols=1'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = [fsUnderline]
        Transparent = True
        mmHeight = 4233
        mmLeft = 1323
        mmTop = 205052
        mmWidth = 10848
        BandType = 4
      end
      object RBEan11: TRBEan
        UserName = 'Ean11'
        BackgroundColor = clWhite
        Transparent = False
        ShowLabels = True
        StartStopLines = True
        TypBarCode = bcPDF417
        LinesColor = clBlack
        Ean13AddUp = True
        FontAutoSize = True
        Security = False
        DemoVersion = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = [fsUnderline]
        BarCode = 'PSOFT, http://www.psoft.sk, email: peter@psoft.sk'
        Angle = 0
        DisableEditor = False
        mmHeight = 26723
        mmLeft = 1323
        mmTop = 210080
        mmWidth = 17198
        BandType = 4
      end
      object RBEan12: TRBEan
        UserName = 'Ean12'
        BackgroundColor = clWhite
        Transparent = False
        ShowLabels = True
        StartStopLines = True
        TypBarCode = bcPDF417
        LinesColor = clBlack
        Ean13AddUp = True
        FontAutoSize = True
        Security = False
        DemoVersion = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = [fsUnderline]
        BarCode = 'PSOFT, http://www.psoft.sk, email: peter@psoft.sk'
        Angle = 0
        DisableEditor = False
        mmHeight = 14552
        mmLeft = 46831
        mmTop = 210873
        mmWidth = 28310
        BandType = 4
      end
      object ppLabel20: TppLabel
        UserName = 'Label20'
        Caption = 'Cols=3'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = [fsUnderline]
        Transparent = True
        mmHeight = 4233
        mmLeft = 46831
        mmTop = 206111
        mmWidth = 10848
        BandType = 4
      end
      object RBEan13: TRBEan
        UserName = 'Ean13'
        BackgroundColor = clWhite
        Transparent = False
        ShowLabels = True
        StartStopLines = True
        TypBarCode = bcPDF417
        LinesColor = clBlack
        Ean13AddUp = True
        FontAutoSize = True
        Security = False
        DemoVersion = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = [fsUnderline]
        BarCode = 'PSOFT, http://www.psoft.sk, email: peter@psoft.sk'
        Angle = 0
        DisableEditor = False
        mmHeight = 10848
        mmLeft = 108744
        mmTop = 202936
        mmWidth = 66411
        BandType = 4
      end
      object ppLabel21: TppLabel
        UserName = 'Label21'
        Caption = 'Cols=5'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = [fsUnderline]
        Transparent = True
        mmHeight = 4233
        mmLeft = 109273
        mmTop = 196850
        mmWidth = 10848
        BandType = 4
      end
      object RBEan14: TRBEan
        UserName = 'Ean14'
        BackgroundColor = clWhite
        Transparent = False
        ShowLabels = True
        StartStopLines = True
        TypBarCode = bcPDF417
        LinesColor = clBlack
        Ean13AddUp = True
        FontAutoSize = True
        Security = False
        DemoVersion = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = [fsUnderline]
        BarCode = 'PSOFT, http://www.psoft.sk, email: peter@psoft.sk'
        Angle = 0
        DisableEditor = False
        mmHeight = 6085
        mmLeft = 107686
        mmTop = 227013
        mmWidth = 66411
        BandType = 4
      end
      object ppLabel23: TppLabel
        UserName = 'Label23'
        Caption = 'Cols=10'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = [fsUnderline]
        Transparent = True
        mmHeight = 4233
        mmLeft = 108744
        mmTop = 221457
        mmWidth = 12700
        BandType = 4
      end
    end
    object ppFooterBand1: TppFooterBand
      mmBottomOffset = 0
      mmHeight = 13229
      mmPrintPosition = 0
      object ppLabel22: TppLabel
        UserName = 'Label22'
        Alignment = taCenter
        AutoSize = False
        Caption = 
          'For latest version please visit http://www.psoft.sk, http://barc' +
          'ode.psoft.sk'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 16
        Font.Style = []
        Transparent = True
        mmHeight = 6350
        mmLeft = 4233
        mmTop = 3704
        mmWidth = 184944
        BandType = 8
      end
      object ppShape5: TppShape
        UserName = 'Shape5'
        Brush.Color = clSilver
        mmHeight = 7938
        mmLeft = 1323
        mmTop = 2381
        mmWidth = 191030
        BandType = 8
      end
    end
  end
end

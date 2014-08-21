object Form1: TForm1
  Left = 136
  Top = 29
  Width = 713
  Height = 554
  Caption = 
    'BarCode Components            Homepage : http://barcode.psoft.sk' +
    '               EMail : peter@psoft.sk'
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PC: TPageControl
    Left = 0
    Top = 37
    Width = 705
    Height = 490
    ActivePage = TabSheet2
    Align = alClient
    TabOrder = 0
    object SheetEAN: TTabSheet
      Caption = 'TEan'
      object Splitter1: TSplitter
        Left = 297
        Top = 0
        Width = 3
        Height = 462
        Cursor = crHSplit
      end
      object UpDown1: TUpDown
        Left = 633
        Top = 224
        Width = 16
        Height = 21
        Min = 0
        Max = 1000
        Position = 250
        TabOrder = 2
        Wrap = False
      end
      object UpDown2: TUpDown
        Left = 633
        Top = 248
        Width = 16
        Height = 21
        Min = 0
        Max = 1000
        Position = 100
        TabOrder = 0
        Wrap = False
      end
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 297
        Height = 462
        Align = alLeft
        TabOrder = 1
        object PE: TLabel
          Left = 8
          Top = 264
          Width = 265
          Height = 33
          AutoSize = False
          Caption = 'PE'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object Label1: TLabel
          Left = 9
          Top = 320
          Width = 274
          Height = 13
          Caption = 'Set of available chars for current type barcode :'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object ZnakovaSada: TLabel
          Left = 8
          Top = 336
          Width = 273
          Height = 105
          AutoSize = False
          Caption = 'Charset'
          WordWrap = True
        end
        object Label16: TLabel
          Left = 8
          Top = 16
          Width = 212
          Height = 13
          Caption = 'Use double click to invoke bar code editor ...'
        end
        object EAN1: TEan
          Left = 8
          Top = 32
          Width = 281
          Height = 217
          AutoInc = False
          AutoIncFrom = 0
          AutoIncTo = 0
          BackgroundColor = clWhite
          Transparent = False
          ShowLabels = True
          StartStopLines = True
          TypBarCode = bcISBN
          LinesColor = clBlack
          Ean13AddUp = True
          FontAutoSize = True
          Security = True
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -21
          Font.Name = 'Arial'
          Font.Style = []
          BarCode = '80-7226-102-9'
          LabelMask = '__________________________________________________'
          OnPaint = Ean1Paint
          DemoVersion = False
          Caption.Visible = True
          Caption.Text = 'ISBN 80-7226-102-9'
          Caption.Font.Charset = ANSI_CHARSET
          Caption.Font.Color = clWindowText
          Caption.Font.Height = -16
          Caption.Font.Name = 'Arial'
          Caption.Font.Style = [fsItalic]
          Caption.Alignment = taLeftJustify
          Caption.AutoCaption = True
          CaptionBottom.Visible = True
          CaptionBottom.Text = 'ISBN 80-7226-102-9'
          CaptionBottom.Font.Charset = DEFAULT_CHARSET
          CaptionBottom.Font.Color = clWindowText
          CaptionBottom.Font.Height = -27
          CaptionBottom.Font.Name = 'Arial'
          CaptionBottom.Font.Style = []
          CaptionBottom.AutoSize = False
          CaptionBottom.Alignment = taLeftJustify
          CaptionBottom.AutoCaption = True
          HorzLines.LinesCount = 0
          AutoCheckDigit = True
          PDF417.Mode = psPDF417Alphanumeric
          PDF417.SecurityLevel = psPDF417AutoEC
          PDF417.Truncated = False
          PDF417.PaintIfSmall = True
        end
        object CB9: TCheckBox
          Left = 8
          Top = 296
          Width = 201
          Height = 17
          Caption = 'Auto change bar code on (timer 1s)'
          TabOrder = 0
          OnClick = CB9Click
        end
      end
      object UpDown3: TUpDown
        Left = 633
        Top = 272
        Width = 16
        Height = 21
        Min = 0
        Position = 0
        TabOrder = 3
        Wrap = False
      end
      object PageControl2: TPageControl
        Left = 300
        Top = 0
        Width = 397
        Height = 462
        ActivePage = TabSheet6
        Align = alClient
        TabOrder = 4
        object TabSheet6: TTabSheet
          Caption = 'Main settings'
          object Label8: TLabel
            Left = 16
            Top = 336
            Width = 28
            Height = 13
            Caption = 'Width'
          end
          object Label9: TLabel
            Left = 16
            Top = 360
            Width = 31
            Height = 13
            Caption = 'Height'
          end
          object Label10: TLabel
            Left = 16
            Top = 384
            Width = 27
            Height = 13
            Caption = 'Angle'
          end
          object Label4: TLabel
            Left = 16
            Top = 256
            Width = 43
            Height = 13
            Caption = 'Bar code'
          end
          object BarCode: TEdit
            Left = 203
            Top = 248
            Width = 177
            Height = 21
            TabOrder = 0
            Text = 'BarCode'
            OnChange = BarCodeChange
          end
          object CB1: TCheckBox
            Left = 14
            Top = 280
            Width = 200
            Height = 17
            Alignment = taLeftJustify
            Caption = 'Supplement digits up'
            TabOrder = 1
            OnClick = CB1Click
          end
          object CB2: TCheckBox
            Left = 14
            Top = 304
            Width = 200
            Height = 17
            Alignment = taLeftJustify
            Caption = 'AutoFontSize'
            TabOrder = 2
            OnClick = CB2Click
          end
          object EdWidth: TEdit
            Left = 200
            Top = 328
            Width = 81
            Height = 21
            TabOrder = 3
            Text = '281'
            OnChange = EdWidthChange
          end
          object EdHeight: TEdit
            Left = 200
            Top = 352
            Width = 81
            Height = 21
            TabOrder = 4
            Text = '201'
            OnChange = EdHeightChange
          end
          object EdAngle: TEdit
            Left = 200
            Top = 376
            Width = 81
            Height = 21
            TabOrder = 5
            Text = '0'
            OnChange = EdAngleChange
          end
          object UpDown4: TUpDown
            Left = 281
            Top = 328
            Width = 15
            Height = 21
            Associate = EdWidth
            Min = 0
            Max = 5000
            Position = 281
            TabOrder = 6
            Wrap = False
          end
          object UpDown5: TUpDown
            Left = 281
            Top = 352
            Width = 15
            Height = 21
            Associate = EdHeight
            Min = 0
            Max = 5000
            Position = 201
            TabOrder = 7
            Wrap = False
          end
          object UpDown6: TUpDown
            Left = 281
            Top = 376
            Width = 15
            Height = 21
            Associate = EdAngle
            Min = 0
            Max = 5000
            Position = 0
            TabOrder = 8
            Wrap = False
          end
          object BCStyle: TCheckBox
            Left = 13
            Top = 231
            Width = 177
            Height = 17
            Caption = 'Barcode type names'
            TabOrder = 9
            OnClick = BCStyleClick
          end
          object TypBarCode: TRadioGroup
            Left = 13
            Top = 0
            Width = 372
            Height = 225
            Caption = 'TypBarCode'
            Columns = 2
            ItemIndex = 1
            Items.Strings = (
              'bcEan8'
              'bcEan13'
              'bcCodabar'
              'bcCode39Standard'
              'bcCode39Full'
              'bcCode93Standard'
              'bcCode93Full'
              'bcCode128'
              'bcABCCodabar'
              'bc25Datalogic'
              'bc25Interleaved'
              'bc25Matrix'
              'bc25Industrial'
              'bc25IATA'
              'bc25Invert')
            TabOrder = 10
            OnClick = TypBarCodeClick
          end
        end
        object TabSheet4: TTabSheet
          Caption = 'Fonts, Colors && Caption'
          object Label2: TLabel
            Left = 24
            Top = 32
            Width = 84
            Height = 13
            Caption = 'Background color'
          end
          object Label3: TLabel
            Left = 25
            Top = 56
            Width = 51
            Height = 13
            Caption = 'Lines color'
          end
          object Label5: TLabel
            Left = 24
            Top = 80
            Width = 21
            Height = 13
            Caption = 'Font'
          end
          object Label13: TLabel
            Left = 24
            Top = 104
            Width = 245
            Height = 13
            Caption = '(Warning : for rotated bar codes only true type fonts)'
          end
          object BitBtn3: TBitBtn
            Left = 203
            Top = 72
            Width = 177
            Height = 25
            Caption = '&Font'
            TabOrder = 0
            OnClick = BitBtn3Click
            Glyph.Data = {
              76010000424D7601000000000000760000002800000020000000100000000100
              0400000000000001000000000000000000001000000010000000000000000000
              800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
              3333333333333333333333333333333333333333FFF33FFFFF33333300033000
              00333337773377777333333330333300033333337FF33777F333333330733300
              0333333377FFF777F33333333700000073333333777777773333333333033000
              3333333337FF777F333333333307300033333333377F777F3333333333703007
              33333333377F7773333333333330000333333333337777F33333333333300003
              33333333337777F3333333333337007333333333337777333333333333330033
              3333333333377333333333333333033333333333333733333333333333333333
              3333333333333333333333333333333333333333333333333333}
            NumGlyphs = 2
          end
          object CC2: TComboBox
            Left = 203
            Top = 48
            Width = 177
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            Items.Strings = (
              'clBlack'
              'clMaroon'
              'clGreen'
              'clOlive'
              'clNavy'
              'clPurple'
              'clNavy'
              'clGray'
              'clSilver'
              'clRed'
              'clLime'
              'clYellow'
              'clBlue'
              'clFuchsia'
              'clAqua'
              'clWhite')
            TabOrder = 1
            OnChange = CC2Change
          end
          object CC1: TComboBox
            Left = 203
            Top = 24
            Width = 177
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            Items.Strings = (
              'clBlack'
              'clMaroon'
              'clGreen'
              'clOlive'
              'clNavy'
              'clPurple'
              'clNavy'
              'clGray'
              'clSilver'
              'clRed'
              'clLime'
              'clYellow'
              'clBlue'
              'clFuchsia'
              'clAqua'
              'clWhite')
            TabOrder = 2
            OnChange = CC1Change
          end
          object BoxCaption: TGroupBox
            Left = 24
            Top = 248
            Width = 361
            Height = 169
            Caption = 'Caption'
            TabOrder = 3
            object Label11: TLabel
              Left = 16
              Top = 24
              Width = 21
              Height = 13
              Caption = 'Text'
            end
            object Label12: TLabel
              Left = 16
              Top = 48
              Width = 46
              Height = 13
              Caption = 'Alignment'
            end
            object Label14: TLabel
              Left = 16
              Top = 120
              Width = 245
              Height = 13
              Caption = '(Warning : for rotated bar codes only true type fonts)'
            end
            object Label15: TLabel
              Left = 16
              Top = 96
              Width = 21
              Height = 13
              Caption = 'Font'
            end
            object CaptionText: TEdit
              Left = 184
              Top = 16
              Width = 161
              Height = 21
              TabOrder = 0
              OnChange = CaptionTextChange
            end
            object CaptionAlignment: TComboBox
              Left = 184
              Top = 40
              Width = 161
              Height = 21
              Style = csDropDownList
              ItemHeight = 13
              Items.Strings = (
                'taLeftJustify'
                'taRightJustify'
                'taCenter')
              TabOrder = 1
              OnChange = CaptionAlignmentChange
            end
            object CaptionAutoSize: TCheckBox
              Left = 16
              Top = 68
              Width = 181
              Height = 17
              Alignment = taLeftJustify
              Caption = 'Autosize'
              State = cbChecked
              TabOrder = 2
              OnClick = CaptionAutoSizeClick
            end
            object BitBtn5: TBitBtn
              Left = 184
              Top = 88
              Width = 161
              Height = 25
              Caption = '&Font'
              TabOrder = 3
              OnClick = BitBtn5Click
              Glyph.Data = {
                76010000424D7601000000000000760000002800000020000000100000000100
                0400000000000001000000000000000000001000000010000000000000000000
                800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
                FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
                3333333333333333333333333333333333333333FFF33FFFFF33333300033000
                00333337773377777333333330333300033333337FF33777F333333330733300
                0333333377FFF777F33333333700000073333333777777773333333333033000
                3333333337FF777F333333333307300033333333377F777F3333333333703007
                33333333377F7773333333333330000333333333337777F33333333333300003
                33333333337777F3333333333337007333333333337777333333333333330033
                3333333333377333333333333333033333333333333733333333333333333333
                3333333333333333333333333333333333333333333333333333}
              NumGlyphs = 2
            end
            object CaptionAuto: TCheckBox
              Left = 16
              Top = 144
              Width = 185
              Height = 17
              Alignment = taLeftJustify
              Caption = 'Auto update caption'
              State = cbChecked
              TabOrder = 4
              OnClick = CaptionAutoClick
            end
          end
          object CBCaption: TCheckBox
            Left = 24
            Top = 224
            Width = 97
            Height = 17
            Caption = 'Show caption'
            State = cbChecked
            TabOrder = 4
            OnClick = CBCaptionClick
          end
          object SelectCaption: TComboBox
            Left = 208
            Top = 224
            Width = 161
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            Items.Strings = (
              'Up'
              'Down')
            TabOrder = 5
            OnChange = SelectCaptionChange
          end
        end
        object TabSheet3: TTabSheet
          Caption = 'Misc.'
          object CB_AutoSize: TCheckBox
            Left = 16
            Top = 16
            Width = 289
            Height = 17
            Alignment = taLeftJustify
            Caption = 'Auto size (check min. width for barcode)'
            TabOrder = 0
            OnClick = CB_AutoSizeClick
          end
          object CB_Editor: TCheckBox
            Left = 16
            Top = 40
            Width = 289
            Height = 17
            Alignment = taLeftJustify
            Caption = 'Disable editor (DblClick on barcode invoke editor)'
            TabOrder = 1
            OnClick = CB_EditorClick
          end
          object Se: TCheckBox
            Left = 14
            Top = 64
            Width = 291
            Height = 17
            Alignment = taLeftJustify
            Caption = 'Security'
            TabOrder = 2
            OnClick = SeClick
          end
          object CB3: TCheckBox
            Left = 14
            Top = 88
            Width = 291
            Height = 17
            Alignment = taLeftJustify
            Caption = 'StartStopLines'
            TabOrder = 3
            OnClick = CB3Click
          end
          object CB4: TCheckBox
            Left = 14
            Top = 112
            Width = 291
            Height = 17
            Alignment = taLeftJustify
            Caption = 'ShowLabels'
            TabOrder = 4
            OnClick = CB4Click
          end
          object CB5: TCheckBox
            Left = 14
            Top = 136
            Width = 291
            Height = 17
            Alignment = taLeftJustify
            Caption = 'Transparent'
            TabOrder = 5
            OnClick = CB5Click
          end
        end
        object TabSheet7: TTabSheet
          Caption = 'Exports'
          object FTGroup: TRadioGroup
            Left = 8
            Top = 16
            Width = 161
            Height = 129
            Caption = 'File type'
            ItemIndex = 0
            Items.Strings = (
              'Bitmap (*.bmp)'
              'Windows Metafile (*.wmf)'
              'Enhanced Metafile (*.emf)'
              'GIF'
              'JPEG')
            TabOrder = 0
            OnClick = FTGroupClick
          end
          object BitBtn4: TBitBtn
            Left = 8
            Top = 176
            Width = 161
            Height = 25
            Caption = 'Export to file'
            TabOrder = 1
            OnClick = BitBtn4Click
          end
          object EdFileName: TEdit
            Left = 8
            Top = 152
            Width = 161
            Height = 21
            TabOrder = 2
            Text = 'C:\BARCODE.BMP'
          end
        end
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'Components for Quick Report'
      object ScrollBox1: TScrollBox
        Left = 0
        Top = 0
        Width = 697
        Height = 462
        Align = alClient
        TabOrder = 0
        object Label17: TLabel
          Left = 32
          Top = 120
          Width = 283
          Height = 13
          Caption = 'Samples of barcode, show all needed properties of barcode.'
        end
        object Label18: TLabel
          Left = 32
          Top = 176
          Width = 172
          Height = 13
          Caption = 'Show all supported types of barcode'
        end
        object Label19: TLabel
          Left = 32
          Top = 232
          Width = 139
          Height = 13
          Caption = 'Show property CharWidthMM'
        end
        object Ean2: TEan
          Left = 504
          Top = 16
          Width = 205
          Height = 113
          AutoInc = False
          AutoIncFrom = 0
          AutoIncTo = 0
          BackgroundColor = clWhite
          Transparent = False
          ShowLabels = True
          StartStopLines = True
          TypBarCode = bcISBN
          LinesColor = clBlack
          Ean13AddUp = True
          FontAutoSize = True
          Security = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -21
          Font.Name = 'Arial'
          Font.Style = []
          BarCode = '80-7226-102-9 12345'
          DemoVersion = False
          Caption.Visible = True
          Caption.Text = 'ISBN 80-7226-102-9'
          Caption.Font.Charset = DEFAULT_CHARSET
          Caption.Font.Color = clWindowText
          Caption.Font.Height = -13
          Caption.Font.Name = 'Arial'
          Caption.Font.Style = []
          Caption.Alignment = taLeftJustify
          Caption.AutoCaption = True
          CaptionBottom.Visible = True
          CaptionBottom.Font.Charset = DEFAULT_CHARSET
          CaptionBottom.Font.Color = clWindowText
          CaptionBottom.Font.Height = -13
          CaptionBottom.Font.Name = 'Arial'
          CaptionBottom.Font.Style = []
          CaptionBottom.Alignment = taLeftJustify
          HorzLines.LinesCount = 0
          AutoCheckDigit = True
          PDF417.Mode = psPDF417Alphanumeric
          PDF417.SecurityLevel = psPDF417AutoEC
          PDF417.Truncated = False
          PDF417.PaintIfSmall = True
        end
        object BitBtn9: TBitBtn
          Left = 360
          Top = 112
          Width = 75
          Height = 25
          Caption = '&Preview'
          TabOrder = 0
          OnClick = BitBtn9Click
          Glyph.Data = {
            76010000424D7601000000000000760000002800000020000000100000000100
            0400000000000001000000000000000000001000000010000000000000000000
            800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
            5555555FFFFFFFFFF5555550000000000555557777777777F5555550FFFFFFFF
            0555557F5FFFF557F5555550F0000FFF0555557F77775557F5555550FFFFFFFF
            0555557F5FFFFFF7F5555550F000000F0555557F77777757F5555550FFFFFFFF
            0555557F5FFFFFF7F5555550F000000F0555557F77777757F5555550FFFFFFFF
            0555557F5FFF5557F5555550F000FFFF0555557F77755FF7F5555550FFFFF000
            0555557F5FF5777755555550F00FF0F05555557F77557F7555555550FFFFF005
            5555557FFFFF7755555555500000005555555577777775555555555555555555
            5555555555555555555555555555555555555555555555555555}
          NumGlyphs = 2
        end
        object BitBtn13: TBitBtn
          Left = 360
          Top = 168
          Width = 75
          Height = 25
          Caption = '&Preview'
          TabOrder = 1
          OnClick = BitBtn13Click
          Glyph.Data = {
            76010000424D7601000000000000760000002800000020000000100000000100
            0400000000000001000000000000000000001000000010000000000000000000
            800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
            5555555FFFFFFFFFF5555550000000000555557777777777F5555550FFFFFFFF
            0555557F5FFFF557F5555550F0000FFF0555557F77775557F5555550FFFFFFFF
            0555557F5FFFFFF7F5555550F000000F0555557F77777757F5555550FFFFFFFF
            0555557F5FFFFFF7F5555550F000000F0555557F77777757F5555550FFFFFFFF
            0555557F5FFF5557F5555550F000FFFF0555557F77755FF7F5555550FFFFF000
            0555557F5FF5777755555550F00FF0F05555557F77557F7555555550FFFFF005
            5555557FFFFF7755555555500000005555555577777775555555555555555555
            5555555555555555555555555555555555555555555555555555}
          NumGlyphs = 2
        end
        object BitBtn14: TBitBtn
          Left = 360
          Top = 224
          Width = 75
          Height = 25
          Caption = '&Preview'
          TabOrder = 2
          OnClick = BitBtn14Click
          Glyph.Data = {
            76010000424D7601000000000000760000002800000020000000100000000100
            0400000000000001000000000000000000001000000010000000000000000000
            800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
            5555555FFFFFFFFFF5555550000000000555557777777777F5555550FFFFFFFF
            0555557F5FFFF557F5555550F0000FFF0555557F77775557F5555550FFFFFFFF
            0555557F5FFFFFF7F5555550F000000F0555557F77777757F5555550FFFFFFFF
            0555557F5FFFFFF7F5555550F000000F0555557F77777757F5555550FFFFFFFF
            0555557F5FFF5557F5555550F000FFFF0555557F77755FF7F5555550FFFFF000
            0555557F5FF5777755555550F00FF0F05555557F77557F7555555550FFFFF005
            5555557FFFFF7755555555500000005555555577777775555555555555555555
            5555555555555555555555555555555555555555555555555555}
          NumGlyphs = 2
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Information'
      object Memo2: TMemo
        Left = 0
        Top = 0
        Width = 697
        Height = 462
        Align = alClient
        Lines.Strings = (
          'Bar Code components , Version 3.01, (c) PSOFT'
          '(3.1.1999)'
          ''
          'BarCode.zip file contains the following components:'
          ''
          'TEan       - component for Bar Code design & display'
          'TDBEan     - data aware TEan'
          'TQrEan, TQrDBEan - versions of component for Quick Report'
          ''
          
            'BarCode.Exe - demo demonstrating all features of components TEan' +
            ', TQrEan.'
          
            'This demo version demonstrates all features of individual compon' +
            'ents. '
          'Data Aware components are not included here. '
          
            'Data Aware is enhanced with properties DataSource, DataField and' +
            ' Field '
          '(these are not included in TEan).'
          ''
          'Components work with most common types of Bar Codes :'
          #9'EAN 8'
          #9'EAN 13'
          #9'Codabar, ABC Codabar'
          #9'Code 39 Standard/Full'
          #9'Code 93 Standard/Full'
          #9'Code 128'
          
            #9'2/5 Interleaved, 2/5 Matrix, 2/5 Datalogic, 2/5 Industrial, 2/5' +
            ' IATA, 2/5 Invert.'
          ''
          'Trial version requires running Delphi. '
          'If Delphi is not running, Bar Codes will be crossed over.'
          ''
          'Licence - this demo version can be freely distributed . '
          'Library with source code costs $89.'
          
            'This price includes password for a full functional BarCode libra' +
            'ry, '
          'information on components sent via E-mail, One free upgrade, '
          'any additional upgrades are 50 % off the original price.'
          ''
          
            'Data aware components are not included in the demo version of ex' +
            'ecutable, only as componet, '
          
            'to allow viewing this demo for users without DBE installed on th' +
            'eir system. '
          'These components can be used same way as the TEan components.'
          'Data aware components have an additional properties:'
          
            '    DataSource          ... same as the other data aware compone' +
            'nts'
          '    DataField'
          '    Field'
          ''
          ''
          
            'You can use the componets directly from Delphi after their succe' +
            'sful installation.'
          ''
          ''
          ''
          'EMail : psoft@ke.telecom.sk')
        TabOrder = 0
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 705
    Height = 37
    Align = alTop
    TabOrder = 1
    object Label6: TLabel
      Left = 8
      Top = 8
      Width = 69
      Height = 24
      Caption = 'PSOFT'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object Label7: TLabel
      Left = 5
      Top = 6
      Width = 69
      Height = 24
      Caption = 'PSOFT'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object BitBtn1: TBitBtn
      Left = 576
      Top = 4
      Width = 75
      Height = 29
      TabOrder = 0
      Kind = bkClose
    end
    object BitBtn2: TBitBtn
      Left = 496
      Top = 4
      Width = 75
      Height = 29
      Caption = '&About'
      TabOrder = 1
      OnClick = BitBtn2Click
      Glyph.Data = {
        42010000424D4201000000000000760000002800000011000000110000000100
        040000000000CC00000000000000000000001000000010000000000000000000
        BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
        7777700000007777777777777777700000007777777774F77777700000007777
        7777444F77777000000077777774444F777770000000700000444F44F7777000
        000070FFF444F0744F777000000070F8884FF0774F777000000070FFFFFFF077
        74F77000000070F88888F077774F7000000070FFFFFFF0777774F000000070F8
        8777F07777774000000070FFFF00007777777000000070F88707077777777000
        000070FFFF007777777770000000700000077777777770000000777777777777
        777770000000}
    end
    object BitBtn11: TBitBtn
      Left = 88
      Top = 4
      Width = 129
      Height = 29
      Caption = 'PSOFT Homepage'
      TabOrder = 2
      OnClick = BitBtn11Click
    end
    object BitBtn12: TBitBtn
      Left = 224
      Top = 4
      Width = 113
      Height = 29
      Caption = 'Mail'
      TabOrder = 3
      OnClick = BitBtn12Click
    end
    object Button1: TButton
      Left = 344
      Top = 4
      Width = 113
      Height = 29
      Caption = 'Show HTML'
      TabOrder = 4
      OnClick = Button1Click
    end
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 260
    Top = 169
  end
end

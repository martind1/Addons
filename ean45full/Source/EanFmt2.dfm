object EANSetupFmt: TEANSetupFmt
  Left = 306
  Top = 424
  BorderIcons = [biHelp]
  BorderStyle = bsToolWindow
  Caption = 'Bar code editor'
  ClientHeight = 368
  ClientWidth = 471
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ZAL: TPageControl
    Left = 1
    Top = 1
    Width = 385
    Height = 264
    ActivePage = SH_MAIN
    MultiLine = True
    TabOrder = 0
    object SH_MAIN: TTabSheet
      Caption = 'Text && bar code type'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object ZNAKY: TLabel
        Left = 8
        Top = 120
        Width = 361
        Height = 81
        AutoSize = False
        Caption = 'AVAILABLE CHARS'
        WordWrap = True
      end
      object Label1: TLabel
        Left = 8
        Top = 16
        Width = 66
        Height = 13
        Caption = 'Bar code type'
      end
      object Label2: TLabel
        Left = 8
        Top = 37
        Width = 103
        Height = 13
        Caption = 'Bar code number/text'
      end
      object Label3: TLabel
        Left = 8
        Top = 104
        Width = 102
        Height = 13
        Caption = 'Set of availables char'
      end
      object EANMEMO: TMemo
        Left = 144
        Top = 32
        Width = 233
        Height = 49
        Lines.Strings = (
          'EANMEMO')
        TabOrder = 2
        Visible = False
      end
      object CBTyp: TComboBox
        Left = 144
        Top = 8
        Width = 233
        Height = 21
        Style = csDropDownList
        TabOrder = 0
        OnChange = CBTypChange
        Items.Strings = (
          'Ean 8'
          'Ean 13'
          'Codabar'
          'Code39 Standard'
          'Code39 Full'
          'Code93 Standard'
          'Code93 Full'
          'Code128'
          'ABCCodabar'
          '2/5 Datalogic'
          '2/5 Interleaved'
          '2/5 Matrix'
          '2/5 Industrial'
          '2/5 IATA'
          '2/5 Invert'
          'ITF14')
      end
      object AddUp: TCheckBox
        Left = 5
        Top = 82
        Width = 152
        Height = 17
        Alignment = taLeftJustify
        Caption = 'EAN && ISBN Add Up'
        Checked = True
        State = cbChecked
        TabOrder = 1
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Colors && Fonts'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label4: TLabel
        Left = 5
        Top = 16
        Width = 84
        Height = 13
        Caption = 'Background color'
      end
      object Label5: TLabel
        Left = 5
        Top = 40
        Width = 51
        Height = 13
        Caption = 'Lines color'
      end
      object L3: TLabel
        Left = 5
        Top = 112
        Width = 64
        Height = 13
        Caption = 'Bar code font'
      end
      object EAN_Font: TLabel
        Left = 192
        Top = 112
        Width = 103
        Height = 13
        Caption = 'Bar code  font sample'
      end
      object BGColor: TComboBox
        Left = 192
        Top = 8
        Width = 145
        Height = 22
        Style = csOwnerDrawFixed
        TabOrder = 0
        OnChange = BGColorChange
        OnDrawItem = BGColorDrawItem
        Items.Strings = (
          'Aqua'
          'Black'
          'Blue'
          'Dark Gray'
          'Fuchsia'
          'Gray'
          'Green'
          'Lime'
          'Light Gray'
          'Maroon'
          'Navy'
          'Olive'
          'Purple'
          'Red'
          'Silver'
          'Teal'
          'White'
          'Yellow')
      end
      object LinesColor: TComboBox
        Left = 192
        Top = 32
        Width = 145
        Height = 22
        Style = csOwnerDrawFixed
        TabOrder = 1
        OnChange = LinesColorChange
        OnDrawItem = BGColorDrawItem
        Items.Strings = (
          'Aqua'
          'Black'
          'Blue'
          'Dark Gray'
          'Fuchsia'
          'Gray'
          'Green'
          'Lime'
          'Light Gray'
          'Maroon'
          'Navy'
          'Olive'
          'Purple'
          'Red'
          'Silver'
          'Teal'
          'White'
          'Yellow')
      end
      object Transparent: TCheckBox
        Left = 2
        Top = 60
        Width = 203
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Transparent'
        TabOrder = 2
        OnClick = TransparentClick
      end
      object FontAutoSize: TCheckBox
        Left = 2
        Top = 81
        Width = 203
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Font auto size'
        Checked = True
        State = cbChecked
        TabOrder = 3
        OnClick = TransparentClick
      end
      object BitBtn2: TBitBtn
        Left = 194
        Top = 136
        Width = 135
        Height = 25
        Caption = 'Change font'
        TabOrder = 4
        OnClick = BitBtn2Click
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Caption'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GR_Caption: TGroupBox
        Left = 8
        Top = 24
        Width = 225
        Height = 178
        Caption = 'Caption'
        TabOrder = 0
        object L4: TLabel
          Left = 8
          Top = 24
          Width = 46
          Height = 13
          Caption = 'Alignment'
        end
        object L2: TLabel
          Left = 8
          Top = 96
          Width = 21
          Height = 13
          Caption = 'Text'
        end
        object Label7: TLabel
          Left = 8
          Top = 128
          Width = 21
          Height = 13
          Caption = 'Font'
        end
        object CA_Font: TLabel
          Left = 112
          Top = 128
          Width = 94
          Height = 13
          Caption = 'Sample caption font'
        end
        object CA_Alignment: TComboBox
          Left = 112
          Top = 16
          Width = 105
          Height = 21
          Style = csDropDownList
          TabOrder = 0
          Items.Strings = (
            'Left'
            'Right'
            'Center')
        end
        object CA_AutoCaption: TCheckBox
          Left = 8
          Top = 48
          Width = 209
          Height = 17
          Alignment = taLeftJustify
          Caption = 'AutoCaption'
          TabOrder = 1
          OnClick = CA_AutoCaptionClick
        end
        object CA_AutoSize: TCheckBox
          Left = 8
          Top = 72
          Width = 209
          Height = 17
          Alignment = taLeftJustify
          Caption = 'AutoSize'
          TabOrder = 2
        end
        object CA_TEXT: TEdit
          Left = 112
          Top = 96
          Width = 105
          Height = 21
          TabOrder = 3
        end
        object FONT_UP: TBitBtn
          Left = 112
          Top = 152
          Width = 97
          Height = 23
          Caption = 'Change font'
          TabOrder = 4
          OnClick = FONT_UPClick
        end
      end
      object CA_Visible: TCheckBox
        Left = 8
        Top = 8
        Width = 217
        Height = 17
        Caption = 'Upper caption visible'
        TabOrder = 1
        OnClick = CA_VisibleClick
      end
      object BCA_Visible: TCheckBox
        Left = 240
        Top = 8
        Width = 145
        Height = 17
        Caption = 'Bottom caption visible'
        TabOrder = 2
        OnClick = CA_VisibleClick
      end
      object BGR_CAPTION: TGroupBox
        Left = 240
        Top = 24
        Width = 137
        Height = 178
        Caption = 'Caption'
        TabOrder = 3
        object BCA_FONT: TLabel
          Left = 8
          Top = 128
          Width = 94
          Height = 13
          Caption = 'Sample caption font'
        end
        object BCA_Alignment: TComboBox
          Left = 8
          Top = 16
          Width = 121
          Height = 21
          Style = csDropDownList
          TabOrder = 0
          Items.Strings = (
            'Left'
            'Right'
            'Center')
        end
        object BCA_AutoCaption: TCheckBox
          Left = 8
          Top = 48
          Width = 121
          Height = 17
          Alignment = taLeftJustify
          Caption = 'AutoCaption'
          TabOrder = 1
          OnClick = CA_AutoCaptionClick
        end
        object BCA_AutoSize: TCheckBox
          Left = 8
          Top = 72
          Width = 121
          Height = 17
          Alignment = taLeftJustify
          Caption = 'AutoSize'
          TabOrder = 2
        end
        object BCA_TEXT: TEdit
          Left = 8
          Top = 96
          Width = 121
          Height = 21
          TabOrder = 3
        end
        object FONT_DOWN: TBitBtn
          Left = 8
          Top = 152
          Width = 97
          Height = 23
          Caption = 'Change font'
          TabOrder = 4
          OnClick = FONT_UPClick
        end
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'Mask'
      object Label6: TLabel
        Left = 136
        Top = 8
        Width = 120
        Height = 13
        Caption = 'Please, check all digits ...'
      end
      object C1: TCheckBox
        Tag = 101
        Left = 8
        Top = 24
        Width = 97
        Height = 17
        Caption = 'C1'
        TabOrder = 0
      end
      object C2: TCheckBox
        Tag = 102
        Left = 8
        Top = 40
        Width = 97
        Height = 17
        Caption = 'C2'
        TabOrder = 1
      end
      object c3: TCheckBox
        Tag = 103
        Left = 8
        Top = 56
        Width = 97
        Height = 17
        Caption = 'c3'
        TabOrder = 2
      end
      object c4: TCheckBox
        Tag = 104
        Left = 8
        Top = 72
        Width = 97
        Height = 17
        Caption = 'c4'
        TabOrder = 3
      end
      object c5: TCheckBox
        Tag = 5
        Left = 8
        Top = 88
        Width = 97
        Height = 17
        Caption = 'c5'
        TabOrder = 4
      end
      object c6: TCheckBox
        Left = 8
        Top = 104
        Width = 97
        Height = 17
        Caption = 'CheckBox1'
        TabOrder = 5
      end
      object c7: TCheckBox
        Left = 8
        Top = 120
        Width = 97
        Height = 17
        Caption = 'CheckBox2'
        TabOrder = 6
      end
      object c8: TCheckBox
        Left = 8
        Top = 136
        Width = 97
        Height = 17
        Caption = 'CheckBox3'
        TabOrder = 7
      end
      object c9: TCheckBox
        Left = 8
        Top = 152
        Width = 97
        Height = 17
        Caption = 'CheckBox4'
        TabOrder = 8
      end
      object c10: TCheckBox
        Left = 8
        Top = 168
        Width = 97
        Height = 17
        Caption = 'CheckBox5'
        TabOrder = 9
      end
      object c11: TCheckBox
        Left = 136
        Top = 24
        Width = 97
        Height = 17
        Caption = 'CheckBox1'
        TabOrder = 10
      end
      object c12: TCheckBox
        Left = 136
        Top = 40
        Width = 97
        Height = 17
        Caption = 'CheckBox2'
        TabOrder = 11
      end
      object c13: TCheckBox
        Left = 136
        Top = 56
        Width = 97
        Height = 17
        Caption = 'CheckBox3'
        TabOrder = 12
      end
      object c14: TCheckBox
        Left = 136
        Top = 72
        Width = 97
        Height = 17
        Caption = 'CheckBox4'
        TabOrder = 13
      end
      object c15: TCheckBox
        Left = 136
        Top = 88
        Width = 97
        Height = 17
        Caption = 'CheckBox5'
        TabOrder = 14
      end
      object c16: TCheckBox
        Left = 136
        Top = 104
        Width = 97
        Height = 17
        Caption = 'CheckBox1'
        TabOrder = 15
      end
      object c17: TCheckBox
        Left = 136
        Top = 120
        Width = 97
        Height = 17
        Caption = 'CheckBox2'
        TabOrder = 16
      end
      object c18: TCheckBox
        Left = 136
        Top = 136
        Width = 97
        Height = 17
        Caption = 'CheckBox3'
        TabOrder = 17
      end
      object c19: TCheckBox
        Left = 136
        Top = 152
        Width = 97
        Height = 17
        Caption = 'CheckBox4'
        TabOrder = 18
      end
      object c20: TCheckBox
        Left = 136
        Top = 168
        Width = 97
        Height = 17
        Caption = 'CheckBox5'
        TabOrder = 19
      end
      object c21: TCheckBox
        Left = 240
        Top = 24
        Width = 97
        Height = 17
        Caption = 'CheckBox1'
        TabOrder = 20
      end
      object c22: TCheckBox
        Left = 240
        Top = 40
        Width = 97
        Height = 17
        Caption = 'CheckBox2'
        TabOrder = 21
      end
      object c23: TCheckBox
        Left = 240
        Top = 56
        Width = 97
        Height = 17
        Caption = 'CheckBox3'
        TabOrder = 22
      end
      object c24: TCheckBox
        Left = 240
        Top = 72
        Width = 97
        Height = 17
        Caption = 'CheckBox4'
        TabOrder = 23
      end
      object c25: TCheckBox
        Left = 240
        Top = 88
        Width = 97
        Height = 17
        Caption = 'CheckBox5'
        TabOrder = 24
      end
      object c26: TCheckBox
        Left = 240
        Top = 104
        Width = 97
        Height = 17
        Caption = 'CheckBox1'
        TabOrder = 25
      end
      object c27: TCheckBox
        Left = 240
        Top = 120
        Width = 97
        Height = 17
        Caption = 'CheckBox2'
        TabOrder = 26
      end
      object c28: TCheckBox
        Left = 240
        Top = 136
        Width = 97
        Height = 17
        Caption = 'CheckBox3'
        TabOrder = 27
      end
      object c29: TCheckBox
        Left = 240
        Top = 152
        Width = 97
        Height = 17
        Caption = 'CheckBox4'
        TabOrder = 28
      end
      object c30: TCheckBox
        Left = 240
        Top = 168
        Width = 97
        Height = 17
        Caption = 'CheckBox5'
        TabOrder = 29
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Misc.'
      object LblAngle: TLabel
        Left = 16
        Top = 96
        Width = 79
        Height = 13
        Caption = 'Angle in degrees'
      end
      object L1: TLabel
        Left = 16
        Top = 128
        Width = 28
        Height = 13
        Caption = 'Width'
      end
      object Label8: TLabel
        Left = 16
        Top = 160
        Width = 31
        Height = 13
        Caption = 'Height'
      end
      object StartStopLines: TCheckBox
        Left = 16
        Top = 16
        Width = 213
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Show start/stop lines'
        Checked = True
        State = cbChecked
        TabOrder = 0
        OnClick = TransparentClick
      end
      object ShowLabels: TCheckBox
        Left = 16
        Top = 40
        Width = 213
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Show labels'
        Checked = True
        State = cbChecked
        TabOrder = 1
        OnClick = TransparentClick
      end
      object SecurityZoom: TCheckBox
        Left = 16
        Top = 64
        Width = 213
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Security zoom'
        Checked = True
        State = cbChecked
        TabOrder = 2
        OnClick = TransparentClick
      end
      object EAN_ANGLE: TEdit
        Left = 216
        Top = 88
        Width = 57
        Height = 21
        TabOrder = 3
        Text = '0'
      end
      object UD_Angle: TUpDown
        Left = 273
        Top = 88
        Width = 16
        Height = 21
        Associate = EAN_ANGLE
        Max = 360
        TabOrder = 4
      end
      object EAN_Width: TEdit
        Left = 216
        Top = 120
        Width = 57
        Height = 21
        TabOrder = 5
        Text = '0'
      end
      object EAN_Height: TEdit
        Left = 216
        Top = 152
        Width = 57
        Height = 21
        TabOrder = 6
        Text = '0'
      end
      object UD_Width: TUpDown
        Left = 273
        Top = 120
        Width = 16
        Height = 21
        Associate = EAN_Width
        Max = 30000
        TabOrder = 7
      end
      object UD_Height: TUpDown
        Left = 273
        Top = 152
        Width = 16
        Height = 21
        Associate = EAN_Height
        Max = 10000
        TabOrder = 8
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'Functions'
      object BitBtn3: TBitBtn
        Left = 8
        Top = 8
        Width = 129
        Height = 73
        Caption = 'Export to HTML'
        Glyph.Data = {
          360C0000424D360C000000000000360000002800000020000000200000000100
          180000000000000C000000000000000000000000000000000000FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF3030303030303030303030303030303030
          3030303030303030303030303030303030303030303030303030303030303030
          3030303030303030303030303030303030000000FFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFF000000BFB8BFAFA8AFAFB8AFAFA8AFBFA8AFAFA8
          AFAFB8AFAFA8AFBFA8BFAFA8AFAFB8AF8F888FEFDFDFEFFFEFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFF0000008F00000000005057000000000000000000
          00000000000000000000000000000000000000001000000000000000506750FF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFF0000008F988F5067605047500000000000000000
          0000000000000000000000000000000000000000000050474050675000000000
          0000000000FFFFFFFFFFFFFFFFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000000000000000
          0000000000000000000000000030203000000000000000000000000000000070
          778F000000FFFFFFFFFFFFFFFFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFF
          000000000000000000FFA89FFFA8AFFFB8BFFFCF8FFFDFCFFFCFEFFFEFFFFFFF
          FFFFFFFFFFFFFFFFFFFF000000303020500040BFA8BFDFCFDFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFF000000000000FFA8AFFF888FFFCF8FFFCFCFFFCFDFFFEF
          CFFFFFEFFFFFFFFFFFFF000000303030404700AFA8AFCFCFCFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFF000000000000BF0000FFA8BFFFB88FFFCFCFFFCF
          DFFFEFEFFFFFEFFFFFFF000000303030404740AFB8AFCFDFEFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFF000000000000000000FF88AFFF88AFFFB88FFF88
          8FFFCFDFFFCFCFFFEFEF000000000010000000AFA8AF00000050675000000050
          6750000000FFFFFFFFFFFFFFFFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFF000000FF7770FF8800FF988FFF889FFFA8AFFFB8
          AFFFCFBFFFCFCFFFDFDF000000102000102000BFA8BFDFEFDFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFF000000FF4740FF4740FF6760FF00000000000000000000
          00FFB8AFFF889FFFCFCF0000008F888F0000008F888FCFCFCFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFF000000FF2030FF3040FF4740FF5750FF4760FF67700000000010000000
          00000000FFA8AFFFB8BF000000101010000010CFDFDF00000000000000000000
          0000000000FFFFFFFFFFFFFFFFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFF000000200000FF1020FF0020FF00000000000000000000001010000000
          00102000000000FFA8AF000000204710204700EFEFEFEFEFEFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFF000000401000FF0010FF2020CF20201020100000000000000000
          0030302000000000000000000050675000000070778F000000FFFFFF506750FF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFF000000CF0010FF0000BF10200000000000000000
          00000000000000000000000000000000000000FFFFFF000000FFFFFF00000000
          0000000000FFFFFFFFFFFFFFFFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFF000000000000FF1010FF1020FF20203010108F88
          AFEFEFEFEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFF000000CF00000000000000000000000000000000
          00000000000000FFFFFF00000000000000000000000000000000000000000070
          778F000000FFFFFFFFFFFFFFFFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFBF0000000000000000308830FFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFF000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFF000000FFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFF70470070474070470070573070470070474070470070
          5730704700704740705730FFFFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFF0000007088700000
          0000000000000000000000000000000000000070887000000000000000000000
          0000000000FFFFFFFFFFFFFFFFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFAFA8AFAFA8AFAFA8AFAFA8AF000000000000FFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAF57
          009F57008F5700603000201000503000602000403000403000602000FFFFFF00
          0000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAF57
          00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF503000FFFFFF00
          0000FFFFFFFFFFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAF57
          00AF5700AF5700AF5700AF5700AF5700AF5700AF5700000000603000FFFFFF00
          0000FFFFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00
          0000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        Layout = blGlyphTop
        TabOrder = 0
        OnClick = BitBtn3Click
      end
    end
    object SH_PDF417: TTabSheet
      Caption = 'PDF417'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label9: TLabel
        Left = 16
        Top = 16
        Width = 47
        Height = 13
        Caption = 'Error level'
      end
      object Label10: TLabel
        Left = 16
        Top = 40
        Width = 27
        Height = 13
        Caption = 'Mode'
      end
      object PDF_COLSlbl: TLabel
        Left = 16
        Top = 64
        Width = 20
        Height = 13
        Caption = 'Cols'
      end
      object PDF_ROWSlbl: TLabel
        Left = 16
        Top = 88
        Width = 27
        Height = 13
        Caption = 'Rows'
      end
      object PDF_ErrorLevel: TComboBox
        Left = 120
        Top = 8
        Width = 185
        Height = 21
        Style = csDropDownList
        TabOrder = 0
        OnChange = PDF_ErrorLevelChange
        Items.Strings = (
          'Auto error level'
          'Error level 0'
          'Error level 1'
          'Error level 2'
          'Error level 3'
          'Error level 4'
          'Error level 5'
          'Error level 6'
          'Error level 7'
          'Error level 8')
      end
      object PDF_MODE: TComboBox
        Left = 120
        Top = 32
        Width = 185
        Height = 21
        Style = csDropDownList
        TabOrder = 1
        OnChange = PDF_MODEChange
        Items.Strings = (
          'Alphanumeric'
          'Binary'
          'BinaryHex'
          'Numeric'
          'Automatic')
      end
      object PDF_COLS: TEdit
        Left = 120
        Top = 56
        Width = 49
        Height = 21
        TabOrder = 2
        OnChange = PDF_COLSChange
      end
      object PDF_ROWS: TEdit
        Left = 120
        Top = 80
        Width = 49
        Height = 21
        TabOrder = 3
        OnChange = PDF_ROWSChange
      end
      object PDF_TRUNCATED: TCheckBox
        Left = 16
        Top = 120
        Width = 97
        Height = 17
        Caption = 'Truncated'
        TabOrder = 4
        OnClick = PDF_TRUNCATEDClick
      end
    end
    object SHEET_PRINT: TTabSheet
      Caption = 'Print'
      object Label11: TLabel
        Left = 8
        Top = 48
        Width = 28
        Height = 13
        Caption = 'Width'
      end
      object Label12: TLabel
        Left = 8
        Top = 72
        Width = 31
        Height = 13
        Caption = 'Height'
      end
      object Label17: TLabel
        Left = 8
        Top = 8
        Width = 83
        Height = 13
        Caption = 'Units in milimeters'
      end
      object Label20: TLabel
        Left = 8
        Top = 128
        Width = 28
        Height = 13
        Caption = 'Count'
      end
      object GroupBox1: TGroupBox
        Left = 200
        Top = 0
        Width = 169
        Height = 209
        Caption = 'Margins'
        TabOrder = 0
        object Label13: TLabel
          Left = 8
          Top = 24
          Width = 18
          Height = 13
          Caption = 'Left'
        end
        object Label14: TLabel
          Left = 8
          Top = 48
          Width = 19
          Height = 13
          Caption = 'Top'
        end
        object Label15: TLabel
          Left = 8
          Top = 72
          Width = 25
          Height = 13
          Caption = 'Right'
        end
        object Label16: TLabel
          Left = 8
          Top = 96
          Width = 33
          Height = 13
          Caption = 'Bottom'
        end
        object Label18: TLabel
          Left = 8
          Top = 120
          Width = 79
          Height = 13
          Caption = 'Space horizontal'
        end
        object Label19: TLabel
          Left = 8
          Top = 144
          Width = 68
          Height = 13
          Caption = 'Space vertical'
        end
        object LBL_FORMAT: TLabel
          Left = 8
          Top = 184
          Width = 153
          Height = 13
          Alignment = taCenter
          AutoSize = False
          Caption = 'LBL_FORMAT'
        end
        object E_LEFT: TEdit
          Left = 96
          Top = 16
          Width = 65
          Height = 21
          TabOrder = 0
          Text = '10'
          OnChange = E_WIDTHChange
        end
        object E_TOP: TEdit
          Left = 96
          Top = 40
          Width = 65
          Height = 21
          TabOrder = 1
          Text = '10'
          OnChange = E_WIDTHChange
        end
        object E_RIGHT: TEdit
          Left = 96
          Top = 64
          Width = 65
          Height = 21
          TabOrder = 2
          Text = '10'
          OnChange = E_WIDTHChange
        end
        object E_BOTTOM: TEdit
          Left = 96
          Top = 88
          Width = 65
          Height = 21
          TabOrder = 3
          Text = '10'
          OnChange = E_WIDTHChange
        end
        object E_SPACEX: TEdit
          Left = 96
          Top = 112
          Width = 65
          Height = 21
          TabOrder = 4
          Text = '10'
          OnChange = E_WIDTHChange
        end
        object E_SPACEY: TEdit
          Left = 96
          Top = 136
          Width = 65
          Height = 21
          TabOrder = 5
          Text = '10'
          OnChange = E_WIDTHChange
        end
      end
      object E_WIDTH: TEdit
        Left = 120
        Top = 40
        Width = 65
        Height = 21
        TabOrder = 1
        Text = '40'
        OnChange = E_WIDTHChange
      end
      object E_HEIGHT: TEdit
        Left = 120
        Top = 64
        Width = 65
        Height = 21
        TabOrder = 2
        Text = '20'
        OnChange = E_WIDTHChange
      end
      object E_COUNT: TEdit
        Left = 120
        Top = 120
        Width = 65
        Height = 21
        TabOrder = 3
        Text = '1'
      end
      object BitBtn1: TBitBtn
        Left = 8
        Top = 184
        Width = 177
        Height = 25
        Caption = '&Print'
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
        TabOrder = 4
        OnClick = BitBtn1Click
      end
      object E_NEXT: TCheckBox
        Left = 8
        Top = 152
        Width = 145
        Height = 17
        Caption = 'Use next method'
        TabOrder = 5
      end
    end
    object SH_COPYRIGHT: TTabSheet
      Caption = 'About'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Image2: TImage
        Left = 96
        Top = 0
        Width = 185
        Height = 129
        Center = True
        Picture.Data = {
          07544269746D6170C6380000424DC63800000000000036040000280000007300
          0000740000000100080000000000903400000000000000000000000100000001
          0000070A0A004B8A8700224B4800B1C8C8005166640081ABA8000B272600C7E7
          E6008B8B8D004A2B2300564D4A0081726B00B4AEAC0010161700B6D8D800DBF6
          F8004A3C3700575B5A006897930045827B0090989900797B7C00401F1600385B
          580097B8B80010373500CBC9C800BBBCBB002D0D0500D6D9D9001D413C002A2A
          2900755C560058787400698C8A004245480061443A00909492003A170E009BA9
          A8006E534A0055352B004C291C00E4EAEA00F0F9F900B2A29C0033353500516E
          6C00191F1D00729F9C007C655B00567F7B0096817A00A5968C00000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000F0F0F0F0F0F0F0F0707070707070707071D07070707071D07070707071D
          07070707070707070707070707070707070707070707070707071D07071D0707
          1D070707070707070707071D2B07070707070E070707072B07071D07071D072B
          1D071D0707071D07071D0707070E070707070F0303000F0F0F0F0F0F0F0F070E
          0E0303030303030E030303030303030303030303030303030303030303030303
          03030303031A03031A03030303030E03031A030E031A03030303030303030303
          030303031A030E03030303030303030E03030303030E030303030E03030E0303
          0E03031A0E0E070F27000F0F0F0F2B0F2B1D03180C1827052718272727272727
          272727272727272705272727270C270C270C2727270C270C2727272705272727
          0527272727272705270527052727272727272727272727270527052727272727
          2727270527052727270527050C27270527052727272718051B18070707000F0F
          0F0F0F0F070E0327052525142514142514253125141425312514121425141425
          1414081425251414251425252514251425252525142525122512252525251425
          1412142531141414141225141414142512142531251412142514141414252514
          122514253125251414142514271803070F000F0F0F0F0F0F071D1A3131082512
          3522123512252522252208082508250808081208121212122512220812081208
          1222250808250825082225082508080825082522250808080808252208082522
          2522081208250808252212082522252225221235251208083522252508080822
          1427030E07000F0F2C0F2B2B0E1B312534211515331515331515151533151515
          1515151515151515151533151533151521151515151515151533151515151515
          1515151533151515151515151515151515151515151515151515151515151521
          15151515211515330B33341333150B15210834080827030E0F000F2C0F2C310D
          300D0D0D0D0D0D0D0D0D0D260D000D0D0D0D0D0D0D000D06000D0D0D00303000
          0D0D0D0D0D0D0D0D300D0D0D0D2630301C0D0D0D0D0D0D300D000D0D0D0D0D0D
          0D0D0D000D0D0D000D0D0D0D000D000D0D0D0D0D0D0D0D0D0D0D0D0D0D000D0D
          16000D00002E150814271B072B000F2B2C2B1F0D0D06020B1225312531251212
          1231122512141214121412142225142508142214142522142531252514122512
          3131222231312531253122222525311412251431221214313114123131312214
          25121412121431251212311214142225251222253105351E00002F082227030E
          07000F0F0F0F1E0A043322050505050505051805050505180505050505050505
          1805050505050505051818050505050505051805053118051805050531180505
          1805050505050505180505310505050505050505050518050505050505050505
          05050505051805050527051223002F120827031D0F000F0F070F21172F122221
          0113011301131313010113130113010113010121130101131321010113130122
          2113131313131301130101130113131301130121130113221313011301010112
          01011313132F0122011313131301131313131301130101013313010113212112
          313004120805030E0F000F0F2C2C331917120113171E02021E1713121702021E
          02172F22330217220117022F1221022F130217130101010101011304171E1E02
          17041213021722222217020215332117021E021E1717172F2212210202040122
          012F022F2201132F1E0202020202022F01120113140604221427031D2B000F0F
          0F0F040604220400000617171E1713190006171702060002210000221700000D
          13170006170006010122220112011900061717020D00172F0030122202000000
          2F02000D1E1702170419000231210600000622132219001E0122012117171702
          171E00001712331233062F140827182B07000F0F2C0F17302F22060017310112
          01122F000D01222231210D0017000D2F300617000211001E040000190606061E
          2F040006011212122F0030170D30310200020D001700001E1717170213190004
          13060D0200060101121900021213010113170217171E000017012222170D0408
          2527031D07000F2B2C2C1130041306000231011212122F000022121212330D00
          170D0D0200041219001E002E04000D0421041900060200062201011213000617
          000617000222060004000019020202021319001E060D130400190131121E0002
          050112020D001E021E1E02210112130104061114141403070F002C2B0F2C1730
          2F011700000217170217011900191717170600022F000000191222130000001E
          04003017171719003033190019172F173000022F0000001E122200002F230006
          171717172F190000062F310200192F021706000617022F1E0000171702171717
          010113010406040808271B072B000F0F0F2C1130041213130219060619021301
          171E191919190401131E061E13120122171E19022F1E1E19061E191E01223304
          1E1906191E043133191902120113021E13012F1E191919191717191E2112012F
          1E02171919191E1906191733171E191919191E022F011322040D0B2214270307
          2B000F0F0F2C1730042201012201121212010101011201011201120101011212
          1301011212011201011201120101011201212222011212010101010112121312
          1301121213011201121201010101120101010112012212120112011212120112
          011201122222012201120101040D2F0808271B072B000F0F0F0F11302F13132F
          2121042F2F2F042F2F13040413221301130101131212132F2F2F042F042F0404
          13041313011201213304171313042F172F2121132F0404130101120101010101
          01010101010121042F042F13010101130101212F04211313212121212F130122
          17302F081405031D0F000F0F0F0F1730042222031A1A1B0E030E030E1A1B0318
          150413010101010121040B310C0E0303031A1D1A030E0113122F04152703030E
          0303031D03051708031D0322131313010113010101011313010121030E03052F
          010113010113011A0E1B272F131B0E0E18133301043011140827031D0F000F0F
          0F0F110D0433312C2C2C2C2C2C2C2C2C2C2C2C2C2C0E22041213010121180F2C
          2C2C2C2C2C2C2C2C2C0F31131313032C2C2C2C2C0F2C2C0F0F0E23272C2C2C27
          1301010101010122210101120133222C2C2C0E2F010112011301012C2C2C0717
          2F072C2C0713132211302F080827030E07000F2B0F0F04300421052C2C2C0E14
          31123131311B2B2C2C2C2C310412212F1D2C2C2C071B05141205313105313313
          2F0E2C2C2C07180531313105051302182C2C2C052F1301130122130122120113
          0121222C2C2C0E04010113010113222C2C2C1D0421072C2C0E2F010104300414
          082703070F000F0F0F2C110D2F33142C2C2C1B17131313132104041B2C2C2C0F
          3321211A2C2C2C2B33042F132121212121130121312C2C2C0733171321211304
          13132F052C2C2C270B22010113010133010113010113122C2C2C032F01010101
          0113122C2C2C0E17211D2C2C07210122040D0B220827031D2B000F0F0F2C110D
          2F33052C2C2C182F12010101010121210F2C2C2C18042F2C2C2C2C1517331313
          33131333132F122F1A2C2C2C122101010101010101012F272C2C2C0C04212121
          213321132F2F13131221222C2C2C1D04130121211321222C2C2C1D17212B2C2C
          1D213322173004080827031D0F000F0F0F2B040D0433142C2C2C032F01010101
          1301012F1B0F2C2C1D04222C2C2C2C221422221222222522222221040E2C2C2C
          2D1313010101010101012F052C2C2C2C2C2C2C0F0F0F0F2B2B0E312F2101222C
          2C2C1D25222222122222272C2C2C1D04211D2C2C07211322040D2F081427031D
          07000F0F2B0F040D2F21312C2C2C1B2F221301010122332F032C2C2C1A0A272C
          2C2C2C2C0F0F2C2C2C2C2C2C2C2B222F032C2C2C221313010101010101012F0C
          2C2C2C2C2B070F072B070F2C2C2C2C032F21082C2C2C2C0F0F2C0F0F2C2C2C2C
          2C2C1D17212B2C2C1D33130104302F080827031D0F000F2C0F2C04002F13142C
          2C2C1B21220101011301222F182C2C2C0E11252C2C2C2C03031B031818181B18
          03052F211A2C2C2C311301011301010101012F052C2C2C18333333013321011B
          2C2C2C2C2D2F252C2C2C2B030318030303181D2C2C2C1A04211D2C2C07211522
          040D04081427030707000F0F0F2C17300413052C2C2C182F2201010101012204
          1D2C2C2C0317152C2C2C2C11172104132F13212F212121210E2C2C2C25131301
          010101010101040C2C2C2C312F13131321132104072C2C2C0304222C2C2C0E17
          042F212F2F17222C2C2C1D04212B2C2C1D331301040D212208271B072B000F0F
          2B2C040D2F13312C2C2C1B043301130101212F082C2C2C0F2233210E2C2C2C03
          0415131322131313131312211B2C2C2C1413010101010101010104052C2C2C05
          2F011301222233041A2C2C2C1A21222C2C2C0E04010113010113122C2C2C0317
          21072C2C07213322040D2F08142703072B000F2C0F0F040D0413142C2C2C0321
          3333132F212F272C2C0F0F03170121122B2C2C2C1B212F222F2122333333212F
          0E2C2C2C31130101010101010101040C2C2C2C2721330B2121212F272C2C2C2C
          2704222C2C2C0E17010101130113222C2C2C0E04212B2C2C1D13132217302F22
          0827031D2B000F0F2B0F040D2F21312C2C2C2C1A071D0E0E070F2C2C2C2C1B2F
          0101132F122B2C2C2C2C2B0E1D1D0E0E1D0E312F032C2C2C3121010101010101
          01012F052C2C2C2C1D0E071D1D1D0F2C2C2C2C032F13222C2C2C0E0401010101
          0113122C2C2C1D1721072C2C07211322040604081427030707000F0F2C070430
          0422312C0F2C2C2C2C0F2C2C2C2C0F1D18010433010113012F21311B2B2C2C0F
          2C2C2C2C0F2C272F1B2C0F0F1221010113010101010121310F2C2C2C2C2C2C2C
          2C2B2C2C0F03122F3313222C2C0F0E2F011213010113222C2C2C0304210E2C0F
          0E331322170D0408142703072B000F0F0F0F1130173333332213332233221533
          21222F2F2F0122010101120101332F2F21333333223315221501212121011522
          13130101010113010101332F2201332122342133222222213304331333012F33
          343321210113120101331322333313332F3313331333012204302F080827030E
          2B000F0F2C2C17062F2233211301130113330133330122330101130113011313
          0122130113132133131333131321132213331313130101131301131313330101
          1321212213132213131513013301131201121322013313121213132201331301
          01012213010122010122011217300422122703070F000F2C0F2C170D33053131
          3112123131313131312222222222012212121212221322332231313114123122
          0531121214223131143112313131313131123131140531221222121212313322
          2212212233132233131233223322343315223313131313011213220101010122
          17302F081427030E2B000F2B0F0F0406180F0F0F0F070F0F0F0F0F2C0F1B1414
          2527271B1B031B27270C140B271A2B2B2B2B2C2B1D1D2B2B2C0F2C0F2C2B2C2C
          2C2C2C2C2B2C2B1D1A2C2B071D1B1425271834210B2F140C2D0C272512123421
          3434340B320428170B221213010101010101010104302F08082703072B000F2B
          2C0F11301B0F0F0F0F0F0F0F0F0F2C2C2C1B08140C1A1A1A1A1A14271B1A1A1A
          2B2C2B2B2C2B2B2B2B2B2B2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2B1D2C2C2C
          1D1A0C2D252D0C3424282D350B3435352D3435343535340B2024240A020B3301
          1301130101010122040D04081427030E0F000F2C0F2C1106032C0F0705050307
          0F0F0F2C2C0C08271A1A1A1B1A1B0C270C1A1D2B2B2B1D1D1D2B2B1D2B2C2C2C
          2C2C2B2C2C2C2C2C2C2C2C2C2C2C2B1D2B2C2B2B1B1B1A1B2D34342D34343432
          322032342D35353535340B2824242429101134130101011201010101040D0B08
          082703072B002C0F2B2C1730180F0F0F0501010131180E070F0C25271B1A1A1A
          2D0C1B0C0C1D2B2B2B1D1A2B1D1D1A2B2C2B2C2B2C2B2C2B2B2B2C2C2C2C2C2B
          2C2B2B1A2B2C2B1A1B2D340C1A353228350B2428202028240B342D3535343428
          2929091F24290222011313010101012204302F081431031D0F000F0F2B2C170D
          030F0F0F0F0F0703051321220F05080C1B0C1B1B272D1B1A2B2C2B2B2B2B2B2B
          2B2B2C2C2B2C2C2C2C2C2C2B2C2C2C2C2C2C2C2B2B2B1D1A2C2C1D1D0C22320A
          341B0C2D350B3534322829262A292828340B2028242429162909291701120101
          01010101040D2F0814271B070F000F2C0F2C1130182C0F0F070E180501122227
          070C0C1B1B0C2D080C1B1A1D2C2B2B2C2B2B2B2B2C2B2C2C2C2C2C2C2C2C2C2B
          2C2C2C2C2C2C2C2B2B1D1A1A2B2B1A0C0C34340B28341B2D32280B2D34242416
          1626162A292824282832242A2A09291E2F2213121301010104302F080805030E
          07000F2B0F2C1730032C0F2B122121050E2B0F2C0F1B0C1B1B1408081D1D1D2B
          2C2C2B2B2B2B2C2C2C2B2C2C2C2C2C2C2B2C2B2C2C2C2C2C2C2C2B2B2B1D1B1D
          2C1D1B1B35352D0A0A3432340B0B0B3232100A2924241C26162429320B32242A
          2A2924101E13332213010101040D04081427031D0F000F2C2C0F110D1B2C0F0F
          180512313118030E0F0C141B1A0C1A1A2B2B1D1D1D2B2B2B1D2B2C2C2C2C2C2B
          2C2C2C2B2C2C2C2C2C2C2C2C2B2B2B1D1D1A1B1D2C1D1A1B3534343411241032
          32352D200A24240A24242A1C2A2A290B34340B28292A29242902122101010122
          040D21080827030707000F0F2B2C1730030F0F0F0F0F0F0E31212F081D1B0C1D
          2B1D2B1D1D2B2B1D1D1D1D2B2B2B2C2B2C2B2B2C2B2C2B2C2B2C2C2C2C2C2C2B
          2B1D1D1D1A1B0C1D2C2B1D1A35340A0B0B2824240A3224161020281129242A09
          29290B342D2D3532282929322916333301010101043004081431031D0F000F2C
          0F0F17301B0F0F0F0E183101121218032C1D1A2B2B2B1D2B2B2B2B2B2B2B1D2B
          2C2C2C2C2C2C2C2C2C2C2C2B2B2B2C2C2C2C2B2B1D1D1D1D1B0C0C2B2C2B1A0C
          352D34350B0B2010293224101028340B323524282928350C0C2D2D343228320B
          242A1E2222130101040D21080827030707000F2B2C0F1730032C0F0731010518
          070F0F2C2C2B1D1D1D2C2B2B2B2B2B2B2B2C2B2C2C2C2C2C2C2C2C2C2C2B2B2B
          2B2B2B2C2B2B2B2B1D031A1A270C1A2C2B1D1B3534353228200B24290A321F29
          2020320C2D0C350B29282D0C0C0C0C2D35343420242A092122130122040D0414
          082703070F000F0F0F2C0A30182C0F0F180E0F0F0F0F0F2C2C2B1A1D2C2B1A1D
          2B2B2B2C2C2B2C2C2C2C2B2C2C2B2C2C2C2B2B1D1D1D1D2B2B2B2B1D1B1B1A1A
          141B1A2C2B1A1B34283228102424291028282824322028350C1A1B3535352D0C
          273531353535342826242A1E1201010104302F080827030E2B002C2B0F0F0430
          030F0F0F12131205180E0F2C2C071D2B2B2B1D2B2B2B2B2B2C2C2B2B2B2B2C2B
          2C2C2C2B2B2B1D1D1A1A1A1D1D1D2B1D1A0C180C1B272B2C2B1A0C20320B2832
          32242929242432343210280C1A1A1B1A1D1B2D2D0B342D3535320B2A26292A09
          0B221322170D2F141405031D0F000F0F2C2B11301B2C0F070703180512013127
          2C1D1D1D1D1D2B2B2B1D1D1D2B2B2B2B2C2C2C2C2C2C2B2B1D1D1A1B1B1A1A1A
          1D1D1D1D1A1B1B0C2D1A2C2C2C1D0C35330B0B350C3424291024282834242F1B
          1B0C320A340C350B0B35352D352028292A292A160A010122040D2F2522270307
          07000F0F2B0F110D032C0F0F0F0F0E03051333122C1D1D1D2B1D1D1D1D1A1D2B
          1D2B2C2B2C2C2C2C2C2B2B2B1D1A1A0C1B1B1B1B1A1A1D1D1A1B0C0C141D2C2C
          2B2B1D1A35340C2D0C0B290A291010323510322D2D0C353209290B353232342D
          3528292A2A292A2A09131322170D2F0814051B072B000F0F0F2C110D030F0F0F
          0513011205030E072C0E1B1D2B2B1A2B1D1D1D2B1D2B2B2C2B2C2C2B2B2B1D1D
          1B0C142508081514271B1B1D1A1B2D14142B2C2C2C2C2B2B1A1B2D0B3420161C
          09292434080B340B352D08200A10100B2410352D0B292A262A2A2A292A040122
          11302F082227030E2B000F2C0F0F17061B2C0F073113013118072B2C2C030C1D
          1D2B2B1D1D2B1D2B2B2B2B2C2C2C2B2B2B2B1A1B14150B041111230B142D0C1B
          1A1B08081B2C2C2C2B2B2B2B2B1D0C35343228091629322D0B34340B320B2820
          24091F3229242D0C32242A262A262A2929192222040D2F14082703072B000F2B
          0F2B11301B0F2C0F0F070E05312222312B2B0C1D1A1D2B1D2B2B2B2B2B2C2B2C
          2C2B2B1D1D1D1B140B0A2E2E2E2E101115082D1B1A1B15142B2B2B1D1D2C2B2B
          2B2B1D1A340B3532292928343232350B352D352D29002A0B162A352D292A2626
          2A2A242829301322040D2F0814271B072B002C0F0F2C1730032C0F0F0F070318
          311301140F2C0C1B1B1D1D1D2B2B2B2B2C2C2C2B2B2B1D1D1D1B2D08112E1F1F
          301F2E100A04152D1B1B141B2C2B2B1D1D2B2B2B2B2B1D1D35340B2824293026
          280B353432340C342A2A1F2826290C342A2616162A2A28282430112204302F08
          122703070F000F0F2B0F11301B0F2C0F311301121803070F2C2C0F1A180C1B1D
          1A2B2B2B2B2B2B2B1D2B1D1A1A0C08042E1F2E2E230A110A11110B08271B272B
          2C2B2B2B1A1D2B2C2B2B1D2B1D1B2D2824100916292820281128343226162910
          26292D282926262A162A24322409170817300B0808271B1D07000F0F2C2C1730
          032C0F0705030F0F0F0F2C0F0F2C2C2C2B1D1B1A1D1D2B1D2B2B2B2B1D1D1D1A
          1A270B232E230A150814252D14351515140C1B2C2C2B2C2B1A2B2B2B2B1D2C1D
          1D353428162A242824323224162034162A1609161C3432162A162A292A162A24
          24241E34110D2F14140503072B000F2B0F2B11301B0F2C0F3131030E070F0F2C
          2C2C2C2C2C2C2C2B1A1D1D2B1D2B1A1D1D1A1A1A270B0A23200B082D1B1B1A1D
          1D1D0C1515081B2C2C2C2B2C2B2B2B2B2B1D0C250B2820241C262A2924202028
          1032321C162A2A1C2A1B29262A1C292A2626262A24242E3304002F0808271B07
          2B000F0F0F0F1730032C0F0F18120113123118030F2C2C2C2C2C2C2C2C1A1B1D
          1A1D1A1A1D1A1B0C1523231108271A1A1D1D2B1D1D2C2B0C08150C2C2C2C2C2C
          2B2C2B2B2B1B10242024241626092A2810242909292026262626291C3235262A
          2A2629262626292A2424290B040D0B22142703072B000F2B0F2C110D1B2C0F0F
          0F0F0F0718131301070F2C2C0F2C2C2C2C0F1B0C1A27141B1A1A270823231115
          271B1D2B2C2B2C2C2B2B2C1D1415081D2C2C2B1B1A2B1A2D1B1A343434291C16
          26292A290929092929291C2A2A242A2A2D2926261C2A2416262A242924242904
          04162F22082703072B000F2C0F2C1730032C0F070E183131123118180F2C2B0F
          2C2C2C2C2C2C1D2D2708150C1A1B0811231115271B1D2B1D2B1D1D1A1B1A2B2B
          1B08341A2C1D1A2D082D1510292424092426261C1C2626162A161C0926261C16
          24262A353226292616262926162A2A2A2928090A040D2F0814271B072B000F2B
          0F2C17301B0F0F0F132F1312030F070F0F0F0F0F2C2C2C2C2C2C2C1D080B0B27
          1B0C0B23111515270C1B0C081414250834251B1D1D1415272C2C1A2D34202424
          2616161629161C261C1C1C1C26162A261C1626240926343526290B292A262A26
          2626162A2A242A0A040D0B221427031D0F000F0F0F2C1730032C0F0F03180531
          1205050E070F0F0F0F2C2C2C2C2C2C2C140A0B271B140A110B15150C0C0C2514
          0C1A1A2B1D1D1A1D1D1B25151A2C1D1D08202810162A1C16092A261626162A26
          26161C26261C09091C35352A26320B291C262A2A2A262A24292A090A110D2F08
          142703072B002C0F2B2C110D182C0F0F0F0F0F0E18131313070F0F0F2C2B0F2C
          0F2C2C2C1A11042D27150A11040415251B1A1B1D2B1D1A1A2B2C1A0C1A1A1B15
          252B2B1A2D34201016262616261C26261C262A261C26261C26162909342D2926
          32242426162A292924162A2929292A10110D2F14082703070F000F0F0F0F0430
          032C0F0F18011301311203070F0F0F0F0F2C0F2C0F2C2C2C2C15112D2D112311
          0B0B082D0C0C2D0C0C0808080808142D1A1D1A27150C2C1D1A0C0B2909161609
          1C261C1C1C1C1C1C1C2626262A16291B0B2A2A200B291C2616262A2828262A29
          2929091011300414122703072B000F2B0F0F11301B2C0F073131030E070F0F0F
          0F070F0F0F0F072C0F2C2C2C2C0C2F14082323040B15141B1B140C0C141B2714
          0C1B1D1D1D2C1D1A14081D2B2B0C082029091629262626261C1C160909261C1C
          16260B2D292616282424161C262A2A2034242A2A2A292A29110D2F0814270307
          0F000F0F2C2C1730030F2C0F070F0F0F0F0F1818070F0F0F0F0F0F0F0F2C2C2C
          2C1A0B140B23110415080C1A1A1D2B2B1A2D321115271D2B2B2B2B1D0C152D2C
          2B1A2D32242A26160926261C1C1C1C1C1C092928261C282A262629292A242626
          2A292A2A20282A2A2929092E0A302108140C03072B000F0F0F0F11301B2C0F0F
          0F0F0F0F0F0F1818070F0F0F0F0F0F0F0F2C2C2C2C2B0B151110111515141A1D
          2B2B2B1D141123040B0B2D1D2C2C2B1D1B14152B2B1D2D0B0A09160D16262626
          092916160929281626092416091616292A161C262A2A26262A262A292A242429
          11300B08141803070F000F0F2B2C1730032C0F0703180518180318181818180F
          0F0F0F0F2C0F2C2C2C2B15151123112F080C1A1A2C2C2B270A040C1A1A14081B
          2C2C1D2B1A1B341B2B2B1B34202926161F261C1629092616161C1C1C24242409
          26262A292A262A261624162A162609242A2810290A1F2108140C0E2B2B000F2C
          0F0F11301B2C0F0F3313311212310101123131070F0F2B0F0F2B0F2C2C2B150B
          0A0A110B080C1A1A1D2B1D14080C2B2C2C1A1A1D2B2B2C2B1D1A2D082B2B1A2D
          0B100929291626261C1C1C1C1C1C2624242A29162626162A1616162A2624242A
          292A29292932292E2330150805181A070F000F2B0F2C1730032C2C0F22310F0F
          0F0F1801070F0F0F0F0F0F0F0F2C2C2C2C2B15322323110B341B1A1D1A2B1D1B
          2B1A1D2C2B1D2B2B2C2B2B2B2B1D1A081A2C1D0C3423292424102A001C261626
          1C26092426160926292626292A2626162629291624292A2924320A29101F1514
          27181D2B0F000F0F0F2C1130182C0F0F01120F0F0F0F0512070F0F0F0F0F0F0F
          2B0F2C2C2C2C080423230A04081B1D1D2B2B2B1A1D0C1D2C2C1D1A1D1D2C2C2B
          2B2B1D0C2D2C1D1B3520100A100A291C260D26262424161C1029162A26260909
          262A242924281629202824242410291F233015142718072B0F000F2C2B2C1730
          032C0F0F18131203180513050F0F0F0F0F0F0F0F0F2C2C2C2C2C1411232E0A15
          0C1D1D2B2B2B2B1D1B1A1A2C2C1D1D1D2B2C2C2C2C2C2B1A2D2B2C1D2D340A24
          0A2820001616322409292424321626162A2616092A16292929292A203432320B
          10292A2E1F1F22140C031D2B0F000F0F0F0F1130032C0F0F0F0331121212180F
          0F0F0F0F0F0F2C2B2C0F0F2C2C2C1411231004141B1D2B2B2C2C2B2B1A1A1D2C
          2B2B1A2B2C2C2C2C2C2C2B1D0C1B2C1D1B34280A0A290A2A2628282424261629
          2809261616260929161C2A26162A24352D350B2029291F101F2E0814270E1D0F
          0F000F0F0F2C1730032C0F0F070E030E070F07030F0F0F0F0F2C0F0F2C2C2C2C
          2C2C2D11230A151B1D1D2B2B2C2C2C2B1D1D1D2C2C2B1A2B2C2C2C2C2C2C2C2B
          1A2D2B2B1B14110B0B1F28322424200C352426161616162A1616292424242926
          16292835353535242910292E30230827181A070F0F000F2B2C0F1130182C2C0F
          18130101180F0E01070F0F0F0F0F0F2C072C2C2C2C2C1B112311271A1D2B2C2C
          2C2C2C2C2B1D1D2C2C1D1D2C2C2C2C2C2C2B2C2B1D2D1D2B1D0C342508280B35
          0B293435242A16261C1609092609092A282032292A24240B2D3534242929092E
          0D0A1427180E2B0F0F000F0F0F2C1730032C0F0701050731310F1822070F0F0F
          0F0F2C2C2C2C2C2C2C2B2D1110151B1D2B2C2C2C2C2C2C2C2B1D1D2C2C2B1D2B
          2C2C2C2C2C2C2C2C2B1B1B2B2B1A2D2D35350C2D28240B101629282A262A2A2A
          092A092A092932322A29240B2D35242410101F2E0D111418030E2B0F0F002C2B
          2C0F11301B2C0F0F22310F05120F0301070F0F0F2C0F0F2C0F2C2C2C2B0C0423
          23141D2B2C2C2C2C2C2C2C2C2C1D1D2C2C2B1A2B2C2C2B1D1D1D2B2C2B1A082B
          2B1D1A1B2D0C1B0C0B2828091624242416261C262A0924202A09283229242834
          2D0B2A242429291F1F1505180E1D0F0F0F000F0F0F2C1730032C0F0701310F18
          01050112070F0F0F2C2C0F2C2C2C2C2B2725112E0A0C2B2B2C2B2B2B2B2C2C2C
          2B1D1A2C2C2B1A1D1D2B2B1D1D1A1D2B2B1D141A2C2B2B2B1D1B2D1A2D281616
          261609092A26262A2A29242829292A28280B34343520102410091F301F14271B
          0E070F0F0F000F0F2C0F110D1B2C0F0F18030F070531050E0F0F0F0F0F0F2C2C
          2C2C2B0B1F0B231F111A2B2C2B1D1D2B2B2B2C2B1A1B1B2B2C2B0C0C1B0C2725
          0808141A2B1D140B1D2C2C2C2B1D1B1A35202909292629162A292928292A2920
          2A2916283535343428292424241F1F1F232D2703072B0F0F0F000F0F2B2C1130
          030F0F0F0F070E180303070F0F070F2C0F2C2C2C2C2C0B0D232E3023151A2B2C
          1D1A1B08080B15141408272B2C2B0C0B11232E1F2E2E110B140C142311150B0C
          2B2C1D1B2D0B24292A262A292A2A2824292924242A2A2628340B322829292424
          0929090D0427180E1D2C0F0F0F000F2B0F0F110D1B2C0F0F0E12131201012203
          0F0F0F0F2C2C2C2C2C0C301F300D2E0A0B1A2B1D14041F301F2E2311040B142C
          2C2C1B0B23230A0B08080B04111515112E1023112D1D2C1D0C35322A16092626
          2A292A2A2A2924292A24242D2D3229292924282409301F1F15181B07070F0F0F
          0F000F0F0F2C1130032C0F0722120E0F0F073101072C0F0F2C2C2C2C2B23000D
          00000D2E110C0C040A1132080C0C08110A0B1B1D2B2C2B1A0C3515342534082D
          0C1415112323111111342B2C1B1B2D200909162A16261C2609292A2929242835
          3532242929292810291F3023271803072B0F0F0F0F000F0F2C0F11301B0F0F07
          13050F0F0F0F18130E0F0F0F2C2C2C2C1A30300D0D0D001F230B112E110B0814
          080B0B150C1A2B2B2B2C2C2C2C2C2B2C2B2B2B2B1D1B041111251B0B0A21272B
          2B2B1D2D2829282A1616162A280B0B35242835322424320B29242429092E000B
          181B1D2B0F0F0F0F0F000F0F0F0F200D1B0F0F0F0501050303050105072C0F2C
          2C2C2C2C1B300D301F263000301111152D1B1B1B1B1A1A1D2B2B2B2B2B2C2C2C
          2C2C2C2C2B2C2B1D1D0C04230415082F15082D1A2C1D2D1B1B0B24162A292A29
          0B0C0C35280B0C282A2932202924242430301F14270E072B0F0F0F0F0F000F0F
          2B2C170D030F0F0F07180122011205070F0F2B2C2C2C2C2B231C260D300D1F1F
          2E110B1B2B2B2B2C2C2C2B2C2B2C2B2B2C2C2C2C2C2C2B2C2C2B2B2B1A150A11
          0A0415271427271A2B1D2D353432282A1C2A29341B1D1B3424280B0B2824282A
          242910291F0D041818072B0F0F0F0F2C2B000F0F0F0F1106030F0F0F0E070F07
          070F0F0F0F0F0F2C2C2C2C14000D0D00000D0D30302E111B1D2C2B2B2C2C2C2C
          2B2C2B2C2C2C2C2C2C2C2C2B2B2B1D1B081123040B110414252D1D1D2B1D1B2D
          35352D0B342D3534350C1A3434202429242429292424291F0D30141B0307070F
          0F0F0F0F0F000F0F0F0F11301B2B070301120E070E0E0E0E2B2C0F2C2C2C2C10
          1F1F000D0D000000003010151B1D2B2B2C2B2B2C2B2C2C2B2C2C2C2C2C2B2B2B
          1A1B1411232311110B271B15081A1B1D2C1D2D1B2D352D1A1A1A2D20350C1A35
          282A292A29292A24292829301F11180307070F0F0F0F2C0F0F000F0F0F2C1130
          1B0501011301011201010112070F2C2C2C2C2D0D300D2E0A300D1F2311231F2E
          11141D1A1D1D1D2B2C2C2C2C2C2C2C2C2B1A0C14150B0404112F0A04150C2D08
          2D1B0C1A2B1D0C2D0B2828322424240B1A0C32092A2A242820282924242E262E
          1F14030E070F0F0F2C0F0F0F0F000F0F0F2B04060C1231070131070707070707
          0F0F0F0F2C2C08232311111115152D2708151F0D2E0A0B081515081B1D2B2C2C
          2C2C2C1A341123100A230A0408142D080B270C271B0C1B2B1D1B353228292A16
          2A2929323528262A292932340B2428282416300D11030E1D0F0F0F0F2C0F2C2C
          0F000F0F0F2C04300C03070F05180F0F0F0F0F0F0F0F2C2C2C2C080B08232E2E
          2E0B0C151123230B04232E0D1F1F2E23230B081A2C2C1B0411041504152F0A11
          2D1A1B2D150C1A1B2D2D2B2C1A0C353220282A2929291629242A29292924340B
          3228280A290D1F2E1B0307070F0F0F0F0F0F0F2B0F000F0F2B0F110D03072B0E
          12050707071D2B0F0F0F0F2C2C2C1B11111511110814080B100D0B1B080A1104
          150411100A1104081D2B14080C0C252D141B1A271A1D1B1B0C0C1A1D1A1D2C1D
          1B2D0B2429292A2924242924292A292A28350C352824292430091F080E0E072B
          0F0F2C0F0F0F0F2C0F000F2B2C0F11061805130101130113220101180F0F2C2C
          2C2C2C1A15110A2D1A0C042E0D11271A152F1B140B11271B080B15150C1A0815
          08140C1B080C1B0C1B1D2B1D1D1A1A1D2B2C2C1D1B352824292A292A29292924
          2A292424342D2D34280A242E300611031D072B0F0F0F0F0F2C2C2B0F0F000F0F
          0F0F110D1B07070313120707070E1212070F0F0F2C2C2C2C2B25250C15110B04
          041A1D18230B14140827140C081514140C1D2D1B08080C270C0C0C1B1A2B2B1D
          1D1D1A1A2C2C2B1A2D0B2824292A292A2A2A2A292A292924342D350B28240930
          0610181A2B2B0F0F0F0F0F0F0F0F0F0F0F000F0F2B2C2F0D1B0F0F0F03030F0F
          0F0F18050F0F0F2C2C2C2C2C2C2C2B081B08140C141B1A2D111B1B1B0C271B1B
          270C0C0C1A2B1A1A1B1B0C0C1D1D1B1A2B2B2B2C1D1D1A1B2B2C2B1A2D0B3224
          24292A292A2A2A162A2A2A28343434322829163010141D070F2B0F2C0F0F0F0F
          0F2B2C0F0F002B0F2C0F0A30030F0F0F0F0F0F0F0F0F3105070F0F0F0F2C0F2C
          2C2C2B0B1414080C08081A27081B1B1B1A0C1B0C1A0C1B1B1D1D2B1D2B2B1B1D
          2B2B2B1D2B2B2C2B1A1A1A2D142B2C1D2D3432242928292A2A29292A2A2A2932
          350B32200A26301F221D072B2B2C0F0F0F0F2C0F0F0F0F0F0F002C2B0F2B1106
          032C0F0F0F070E070F0F0318070F0F0F2C2C2C2C2C2C21230815141B2D14271A
          1D1B1B1B1B1D1A1A1B1A1A1A1B1D2B2C2B2C2B2B2B1D2B2B2B2C2B1D1A1A1B27
          251D2B2B0C0B2824292A292A283224292A2A29283224240A16301F210E2B2B0F
          0F0F2C0F0F0F0F0F0F0F0F0F2C000F0F2C0F17301B0F2C0F03010122030F0E22
          070F0F2B0F2C2C2C2C2B10300B1414080C1A1A1B1D1D1D1A1A1D1A1D1D1D1D1D
          1D1D2B2B2B2B2B1D1D2B2B2C2B2C1D1D1A1A0C142D1D2B1D1B34282916292824
          28292A2A2A2A24282924282A0D2E2F1A0F070F0F0F0F0F0F0F2C0F0F0F0F0F0F
          0F000F0F2C0F1106180F0F0F22010E12310F18010F0F0F0F0F2C2C2C2C2B0A1F
          23081414141B1A1A1B1A1B1D1D1D1D1D1D1D2B2C2B2C2C2C1D1A1D2B2C2B2B2B
          2B2C2C1D1B0C14141B1D2C1D2D0B282926292829292A2A262A24242428283026
          2E0B0E2B0F0F0F0F0F0F0F0F0F0F0F0F0F2C2B2C0F000F2B2C0F110D1B2C0F0F
          22050F31310F0E01070F0F2C0F0F2C2C2C2B15112E11142714140C1B1B1A1A1D
          1D1D1D1D1D1D2B1D2B2B2C2B1D1A2B1D2B2C2C2C2B1D1D0C0C0C0C1A1D2B2C2B
          1B350B242A162929292A2A24282824282830301F2F1D2B072B0F2C0F0F2C0F0F
          0F0F0F0F2C0F0F0F0F002C2C2B2C1730032C0F0701050F0501183101070F0F0F
          2C2C2C2C2C1D08080B0B040B270C0C0C0C1B1A1D2B2B2B1D2B2B1D1D2B2B2C2B
          2B2B2B2B2B2B2C1D1A1B2D1B1D1A2B2B2B2C2C2B1A0C140B0A2A2A242A242432
          2820322800161F151D2B0F0F2C0F0F0F0F0F0F0F0F2C0F0F0F0F0F0F0F000F0F
          0F0F110D182C0F2B18180F07310112030F0F0F0F0F2C2C2C2C2C2727270C0B04
          080B14271B0C1A1A1D2B1D1D1D2B1D2B2B2B2C2C2C2C1D2C1D1D1D1A1A1A1A1A
          1D1A2B2B1D2B2C1D1A0C0C35340B0B24280B203232202926302E152B0F2B0F0F
          2C0F0F2C0F2B0F0F0F0F0F0F0F0F0F2C0F000F0F0F2C1130032B07070707070F
          070E07070F0F0F0F2C0F2C2C2C2C1A1B0C1A1B1A270B0814272D270C1A1A1A1A
          1B1A1A1D2B2B2B2B2B1D1A1B1B1B2B1D2B2B1D1A1D1D2B2B1D2C2C2B1A0C3420
          320B2D352D343232112A0D3023271D2C0F0F0F0F0F0F0F2C0F2B2C0F0F0F0F0F
          0F2C0F0F0F000F2C2B0F1730270533220101120112311331070F0F0F0F2C2C0F
          2C2C2C1D1A0C1A1B0C2D1D0C140C140C1B0C1B1A0C1A1D1D2B1D1A2B1D1D2B2B
          2B1D1D2B1D1D1D1A1B1B1A1D2B2C2B1D0C35340B0B32342D2D340B29300D2E11
          180F0F0F0F0F2C2C0F0F2C0F0F2C0F0F2C2C0F0F0F2B0F0F0F000F0F2B2B1130
          18070E030E0E180131030E0E0F0F0F0F0F0F0F2C2C2C2C2C1A271A1B271B0C1B
          140C1B1A1B1A1B1A1D1A1D1D1D2B1A1D1D2B2B2B2B1D1A1D1D1D2B1A1B1A1D1A
          2B2B2B1A0C353535352D353534283026300A212B2B0F0F0F2C0F0F0F0F0F0F0F
          0F0F0F0F0F0F2B0F0F0F0F0F0F000F0F0F2C170D032C0F0F0F18311201120E0F
          0F0F0F0F0F0F0F0F2C0F2C2C2B0C1B1A031A1A1B0C0C1B141B0C1A1A1B1B1A1D
          1D1D1A1D2B2B2B2B2B2B1D2B2B1D2B1D2B2B1D1D2B2C1A1A0C0C0C2D2D353428
          09260D10040C2C2B0F0F0F0F0F0F2C0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
          0F000F2B0F0F230D030F0F0F3113050F07312118070F0F2C0F0F2C0F2C2C2C2C
          2C1A1B1A1A1B1B0C1B1B1B1B1A1B1B1A1D1D1A1A1A1D1A1D1D1D1D1D2B1D1D1D
          1D1A1D2B1A1A2B2B2C2B1D1B0C2D35350B242A00300232311D0F0F0F2C0F0F0F
          0F0F0F0F0F0F0F0F2C0F0F0F0F0F0F0F0F0F0F0F0F000F0F0F0F1730182C2C07
          18030F0F0F0F0325072C0F0F2C0F2C2C2B2C2C2C2C2B1B1B270C1B1B27141A1B
          0C1B271B1D1A1B1A1A1D1D1A1A1A1A1D2B1D1D1D1D1A1A2B1A1D2C2C2B1D1A0C
          350B20191C2630110B25032C0F0F0F0F0F0F0F0F2B0F0F0F0F0F0F0F0F0F2C0F
          0F0F0F2C0F0F0F0F2C000F0F0F2C0A0D1B2C2C0F0F2C0F0F2C0F0F0F0F0F0F2C
          0F2C0F2C0F2C2C2C2C2C1D0C250C1A1A0C271B080814271A1B0C1B1B1B1D2B1A
          1A1A1A1D1A1D1D1A1A1A2B2B2B2B2C2B1D2708202E00002610040827032C0F2C
          2C0F0F2C0F0F0F0F2C0F0F0F2C0F0F0F0F0F0F0F0F0F0F0F0F2C0F0F0F000F0F
          0F0F3111271D1D1D1D0E1D1D0E0E1D071D0E1D0E0E071A1D071D1D1D1D1D2B1B
          0C1B2B1A1B1D0314140C1A1A1B1A1A1A1A0E1D1D1D1A1D1A1B1A1A1D1D2B1D0C
          14080B0A1F0D000030282F08051B1D0F0F0F0F0F0F0F0F0F0F0F2C0F0F2C0F0F
          0F0F0F0F0F0F0F0F0F2C0F0F0F0F0F0F0F000F0F072C2C1A2F0D000000000D00
          000D0D00000D3000000D00003000000D0000000030041B1A1A1A1B0C1B1B1B1A
          1B1D031A1D1A1A1D1D1A1A1A031A1D1D2B1A150D0D301F2E2304340C1B03031D
          0F0F0F0F0F0F0F0F2C0F2C0F0F0F0F0F0F0F2B0F0F2C0F0F0F0F0F0F0F0F0F0F
          0F0F0F2C0F000F2B0F2B2C2C2C1A180C0C181818180C0C1818270C18180C180C
          27270C1B27140B1F00000A1A270C0C1B140C1B1B1A1A1A1A1D1D1A1D1A1A1D1A
          1A1D1D082F0B04271A071D2B2B2B2C2B2C0F2C2C0F0F0F0F0F0F0F0F0F0F0F0F
          0F2C0F0F2C0F0F0F0F0F0F2C0F2C0F0F0F0F0F2C0F0F0F0F0F000F0F0F0F0F0F
          0F2C2B0F0F2C2B2C0F0F0F0F2C0F0F2C2B2C0F2C0F2C0F2C0F2C2C1D122E0D17
          140C1B1B0C1B1B181B1B1D1A1A1A1A1A1A1B1A032B0C170D1F211D2C2C2C0F2C
          2C0F0F2C0F0F0F0F0F0F2B0F0F0F2B0F0F0F0F2C0F2B0F0F2B0F0F0F2B0F0F0F
          0F0F2B0F2B0F0F0F0F0F0F2B0F000F0F0F2C0F0F0F0F0F0F0F0F0F0F0F2C2B0F
          2C0F0F0F2C0F2B0F0F0F2C0F2C0F2C2C2C0C040D0D17140C031B1A1D1A1A1B1B
          1A1A1A1B181A1D1D142E0D23251A2B2C2C2C0F0F2B0F0F0F2B0F0F0F2B0F0F0F
          0F0F0F0F0F0F0F2B0F0F0F0F0F0F0F0F0F0F0F2B0F0F0F2C0F0F0F0F0F2B0F2C
          0F000F0F0F0F2B0F2C2B0F2C2B0F2C2B0F0F2C2B0F0F2B0F0F0F0F0F2C0F2B2C
          0F0F2C2C2C2C1A1510300D2E0A08271B1B031B1A1B14111F302E1710300D111A
          2C2C2C0F0F0F2C0F0F2C2B2C0F2C2B2C0F2C2B0F2C2B0F2B2C2B0F0F2B0F0F2B
          2C2B0F2B0F2B2C0F2B0F0F2B0F2B0F2B2C0F2B0F2C000F0F0F0F0F0F0F0F0F0F
          0F0F0F0F0F0F0F0F0F0F0F0F0F2B0F0F0F0F0F0F0F0F2C0F2B2C2C2B1A08171F
          30301F10232323231F1F0D1F1F2E2E2E11151D2C2C2C0F2C0F0F0F0F0F0F0F0F
          0F0F0F0F0F0F2C0F0F2C0F0F2C0F2C0F2C0F2C0F0F2C0F2C0F2C0F2C0F0F2C0F
          2C0F2C0F2C0F0F2C0F000F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
          0F0F0F0F0F0F0F0F0F0F0F2C0F2C0F2C0F2C070314041E1F1F1F1F2E2E0A1518
          1D1D1A1D0E2B2C2C0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
          0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F000F0F
          0F0F0F0F0F0F2C0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F070F0F0F
          0F0F0F2C0F0F0F0F0F0F070303180303030E070F0F0F0F0F0F0F0F0F0F0F0F0F
          0F0F0F2B0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
          0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F00}
      end
      object Memo1: TMemo
        Left = 8
        Top = 128
        Width = 361
        Height = 89
        Alignment = taCenter
        BorderStyle = bsNone
        Color = clSilver
        Ctl3D = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clTeal
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        Lines.Strings = (
          ''
          'Thank you for using PSOFT components.'
          'If you have questions about barcode, please contact us.'
          ''
          'peter@psoft.sk'
          'http://www.psoft.sk , http://barcode.psoft.sk')
        ParentCtl3D = False
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
      end
    end
  end
  object BtnOk: TBitBtn
    Left = 391
    Top = 120
    Width = 75
    Height = 25
    Kind = bkOK
    NumGlyphs = 2
    TabOrder = 1
    OnClick = BtnOkClick
  end
  object BtnCancel: TBitBtn
    Left = 391
    Top = 24
    Width = 75
    Height = 25
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 2
    OnClick = BtnCancelClick
  end
  object BtnHelp: TBitBtn
    Left = 391
    Top = 56
    Width = 75
    Height = 25
    Kind = bkHelp
    NumGlyphs = 2
    TabOrder = 3
  end
  object BtnApply: TBitBtn
    Left = 391
    Top = 88
    Width = 75
    Height = 25
    Caption = 'Apply'
    Glyph.Data = {
      F6000000424DF600000000000000760000002800000010000000100000000100
      0400000000008000000000000000000000001000000010000000000000000000
      BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
      7777770000000000007770330770000330777033077000033077703307700003
      30777033000000033077703333333333307770330000000330777030FFFFFFF0
      30777030FCCCCFF030777030FFCCCFF030777037FCCCCFF000777077CCCFCFF0
      8077777CCC777700007777CCC77777777777777C777777777777}
    TabOrder = 4
    OnClick = BtnApplyClick
  end
  object Ean: TEan
    Left = 8
    Top = 280
    Width = 377
    Height = 80
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
    PDF417.Mode = psPDF417Alphanumeric
    PDF417.SecurityLevel = psPDF417AutoEC
    PDF417.Truncated = False
    PDF417.PaintIfSmall = True
  end
  object FD: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Left = 428
    Top = 152
  end
  object CO: TColorDialog
    Left = 396
    Top = 152
  end
  object SD: TSaveDialog
    DefaultExt = 'html'
    Filter = 'HTML file|*.htm;*.html'
    Left = 396
    Top = 186
  end
end

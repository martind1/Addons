object ViewerEditorDlg: TViewerEditorDlg
  Left = 195
  Top = 94
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Viewer Settings'
  ClientHeight = 265
  ClientWidth = 341
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 238
    Height = 233
    Align = alClient
    BevelInner = bvLowered
    BorderWidth = 2
    TabOrder = 0
    object Panel2: TPanel
      Left = 4
      Top = 200
      Width = 230
      Height = 29
      Align = alBottom
      Caption = 'Panel2'
      TabOrder = 0
      object Panel4: TPanel
        Left = 203
        Top = 1
        Width = 26
        Height = 27
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 0
      end
      object TrBLongitude: TTrackBar
        Left = 2
        Top = 2
        Width = 207
        Height = 21
        Hint = 'Longitude Setting'
        Max = 180
        Min = -180
        ParentShowHint = False
        Position = 90
        ShowHint = True
        TabOrder = 1
        TickMarks = tmBoth
        TickStyle = tsNone
        OnChange = TrBLongitudeChange
      end
    end
    object Panel3: TPanel
      Left = 207
      Top = 4
      Width = 27
      Height = 196
      Align = alRight
      TabOrder = 1
      object TrBLatitude: TTrackBar
        Left = 4
        Top = 4
        Width = 21
        Height = 191
        Hint = 'Latitude Setting'
        Max = 180
        Min = -180
        Orientation = trVertical
        ParentShowHint = False
        Position = 50
        ShowHint = True
        TabOrder = 0
        TickMarks = tmBoth
        TickStyle = tsNone
        OnChange = TrBLatitudeChange
      end
    end
  end
  object Panel5: TPanel
    Left = 238
    Top = 0
    Width = 103
    Height = 233
    Align = alRight
    TabOrder = 1
    object Label3: TLabel
      Left = 12
      Top = 99
      Width = 20
      Height = 13
      Caption = '&Size'
      FocusControl = TrBSize
    end
    object Label5: TLabel
      Left = 68
      Top = 76
      Width = 18
      Height = 13
      Caption = 'deg'
    end
    object Label2: TLabel
      Left = 12
      Top = 57
      Width = 38
      Height = 13
      Caption = '&Latitude'
      FocusControl = TrBLatitude
    end
    object Label4: TLabel
      Left = 68
      Top = 34
      Width = 18
      Height = 13
      Caption = 'deg'
    end
    object Label1: TLabel
      Left = 12
      Top = 14
      Width = 47
      Height = 13
      Caption = 'Lon&gitude'
      FocusControl = TrBLongitude
    end
    object Label6: TLabel
      Left = 12
      Top = 142
      Width = 42
      Height = 13
      Caption = '&Distance'
      FocusControl = EdDistance
      Visible = False
    end
    object Label7: TLabel
      Left = 12
      Top = 185
      Width = 27
      Height = 13
      Caption = '&Zoom'
      FocusControl = EdZoom
      Visible = False
    end
    object EdZoom: TEdit
      Left = 12
      Top = 200
      Width = 72
      Height = 21
      Enabled = False
      TabOrder = 4
      Text = '0'
      Visible = False
      OnChange = EdZoomChange
      OnKeyPress = EdZoomKeyPress
    end
    object EdDistance: TEdit
      Left = 12
      Top = 157
      Width = 72
      Height = 21
      Enabled = False
      TabOrder = 3
      Text = '0'
      Visible = False
      OnChange = EdDistanceChange
      OnKeyPress = EdDistanceKeyPress
    end
    object EdLatitude: TEdit
      Left = 12
      Top = 72
      Width = 55
      Height = 21
      Enabled = False
      TabOrder = 1
      Text = '0'
      OnChange = EdLatitudeChange
      OnKeyPress = EdLatitudeKeyPress
    end
    object EdLongitude: TEdit
      Left = 12
      Top = 29
      Width = 55
      Height = 21
      Enabled = False
      TabOrder = 0
      Text = '0'
      OnChange = EdLongitudeChange
      OnKeyPress = EdLongitudeKeyPress
    end
    object EdSize: TEdit
      Left = 12
      Top = 115
      Width = 72
      Height = 21
      Enabled = False
      TabOrder = 2
      Text = '0.5'
      OnChange = EdSizeChange
      OnKeyPress = EdSizeKeyPress
    end
    object TrBSize: TTrackBar
      Left = 7
      Top = 136
      Width = 83
      Height = 21
      Hint = 'Size Setting'
      Max = 100
      Min = -10
      Position = 5
      TabOrder = 5
      TickMarks = tmBoth
      TickStyle = tsNone
      OnChange = TrBSizeChange
    end
  end
  object Panel6: TPanel
    Left = 0
    Top = 233
    Width = 341
    Height = 32
    Align = alBottom
    TabOrder = 2
    object Panel7: TPanel
      Left = 172
      Top = 1
      Width = 168
      Height = 30
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object BitBtn2: TBitBtn
        Left = 90
        Top = 3
        Width = 75
        Height = 25
        DoubleBuffered = True
        Kind = bkCancel
        ParentDoubleBuffered = False
        TabOrder = 1
        OnClick = BitBtn2Click
      end
      object BitBtn1: TBitBtn
        Left = 4
        Top = 3
        Width = 75
        Height = 25
        DoubleBuffered = True
        Kind = bkOK
        ParentDoubleBuffered = False
        TabOrder = 0
      end
    end
  end
end

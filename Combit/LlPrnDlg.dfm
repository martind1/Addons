object DlgLlPrn: TDlgLlPrn
  Left = 460
  Top = 134
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  Caption = 'List & Labe Dialog'
  ClientHeight = 191
  ClientWidth = 484
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = True
  PopupMenu = PopupMenu1
  Scaled = False
  ShowHint = True
  Visible = True
  WindowState = wsMinimized
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 16
  object PanBottom: TPanel
    Left = 0
    Top = 157
    Width = 484
    Height = 34
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object BtnClose: TBitBtn
      Left = 405
      Top = 6
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Schlie&'#223'en'
      DoubleBuffered = True
      ParentDoubleBuffered = False
      TabOrder = 3
    end
    object BtnSetup: TBitBtn
      Left = 317
      Top = 6
      Width = 75
      Height = 25
      Hint = 'Drucker ausw'#228'hlen'
      Caption = '&Einrichten'
      DoubleBuffered = True
      ParentDoubleBuffered = False
      TabOrder = 2
    end
    object BtnPrn: TBitBtn
      Left = 229
      Top = 6
      Width = 75
      Height = 25
      Hint = 'Ausgabe auf Drucker'
      Caption = '&Drucker'
      DoubleBuffered = True
      ParentDoubleBuffered = False
      TabOrder = 1
      OnClick = BtnPrnClick
    end
    object BtnScr: TBitBtn
      Left = 141
      Top = 6
      Width = 75
      Height = 25
      Hint = 'Seitenvorschau'
      Caption = '&Bildschirm'
      Default = True
      DoubleBuffered = True
      ParentDoubleBuffered = False
      TabOrder = 0
    end
  end
  object PanTop: TPanel
    Left = 0
    Top = 0
    Width = 484
    Height = 157
    Align = alClient
    TabOrder = 1
  end
  object Nav: TLNavigator
    FormKurz = 'AUSW1'
    AutoEditStart = True
    PageBookStart = 'Multi'
    DetailBookStart = 'etc.'
    StaticFields = False
    Options = []
    OnStart = NavStart
    PollInterval = 0
    AutoCommit = True
    AutoOpen = False
    ConfirmDelete = True
    EditSingle = False
    ErfassSingle = False
    NoOpen = False
    NoGotoPos = False
    Left = 18
    Top = 162
  end
  object PopupMenu1: TPopupMenu
    Left = 47
    Top = 161
    object MiLookUp: TMenuItem
      Caption = 'LookUp'
      ShortCut = 113
    end
  end
end

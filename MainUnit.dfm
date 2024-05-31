object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 406
  ClientWidth = 625
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  DesignSize = (
    625
    406)
  TextHeight = 15
  object ScrollBox2: TScrollBox
    Left = 8
    Top = 48
    Width = 161
    Height = 350
    VertScrollBar.Tracking = True
    Anchors = [akLeft, akTop, akBottom]
    TabOrder = 0
    OnMouseWheelDown = ScrollBox2MouseWheelDown
    OnMouseWheelUp = ScrollBox2MouseWheelUp
  end
  object Button1: TButton
    Left = 8
    Top = 8
    Width = 161
    Height = 34
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1079#1072#1084#1077#1090#1082#1091
    TabOrder = 1
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 180
    Top = 48
    Width = 431
    Height = 343
    Anchors = [akLeft, akTop, akRight, akBottom]
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssVertical
    TabOrder = 2
    OnChange = Memo1Change
  end
  object Button2: TButton
    Left = 486
    Top = 8
    Width = 121
    Height = 33
    Anchors = [akTop, akRight]
    Caption = #1059#1076#1072#1083#1080#1090#1100' '#1079#1072#1084#1077#1090#1082#1091
    TabOrder = 3
    OnClick = Button2Click
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=notes.db'
      'LockingMode=Normal'
      'DriverID=SQLite')
    Connected = True
    Left = 24
    Top = 376
  end
  object FDQuery1: TFDQuery
    Active = True
    Connection = FDConnection1
    SQL.Strings = (
      'CREATE TABLE IF NOT EXISTS notes ('
      '    id   INTEGER  PRIMARY KEY AUTOINCREMENT,'
      '    body TEXT,'
      '    date DATETIME DEFAULT (datetime('#39'now'#39', '#39'localtime'#39') ) '
      '                  NOT NULL'
      ');'
      ''
      'select * from notes;')
    Left = 56
    Top = 376
  end
end

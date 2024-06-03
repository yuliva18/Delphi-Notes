object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 343
  ClientWidth = 583
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  DesignSize = (
    583
    343)
  TextHeight = 15
  object ScrollBox2: TScrollBox
    Left = 8
    Top = 80
    Width = 161
    Height = 255
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
  object Button2: TButton
    Left = 444
    Top = 8
    Width = 131
    Height = 33
    Anchors = [akTop, akRight]
    Caption = #1059#1076#1072#1083#1080#1090#1100' '#1079#1072#1084#1077#1090#1082#1091
    TabOrder = 2
    OnClick = Button2Click
  end
  object Memo1: TMemo
    Left = 175
    Top = 80
    Width = 400
    Height = 255
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      'Memo1')
    ParentFont = False
    ParentShowHint = False
    ShowHint = False
    TabOrder = 3
    OnChange = Memo1Change
  end
  object Edit1: TEdit
    Left = 175
    Top = 48
    Width = 400
    Height = 23
    Anchors = [akLeft, akTop, akRight]
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    TextHint = #1047#1072#1075#1086#1083#1086#1074#1086#1082' '
    OnChange = Edit1Change
  end
  object ComboBox1: TComboBox
    Left = 8
    Top = 48
    Width = 161
    Height = 23
    TabOrder = 5
    Text = 'ComboBox1'
    OnChange = ComboBox1Change
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=notes.db'
      'LockingMode=Normal'
      'DriverID=SQLite')
    Connected = True
    Left = 24
    Top = 360
  end
  object FDQuery1: TFDQuery
    Active = True
    Connection = FDConnection1
    SQL.Strings = (
      'CREATE TABLE IF NOT EXISTS notes ('
      '    id   INTEGER  PRIMARY KEY AUTOINCREMENT,'
      '    title TEXT,'
      '    body TEXT,'
      '    date DATETIME DEFAULT (datetime('#39'now'#39', '#39'localtime'#39') ) '
      '                  NOT NULL'
      ');'
      ''
      'select * from notes;')
    Left = 56
    Top = 360
  end
end

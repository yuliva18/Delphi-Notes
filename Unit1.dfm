object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 424
  ClientWidth = 637
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  DesignSize = (
    637
    424)
  TextHeight = 15
  object ScrollBox2: TScrollBox
    Left = 8
    Top = 48
    Width = 161
    Height = 368
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
    Caption = 'Button1'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 180
    Top = 48
    Width = 449
    Height = 361
    Anchors = [akLeft, akTop, akRight, akBottom]
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssVertical
    TabOrder = 2
    OnChange = Memo1Change
  end
  object Button2: TButton
    Left = 504
    Top = 8
    Width = 121
    Height = 33
    Anchors = [akTop, akRight]
    Caption = 'Button2'
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
      
        'create table if not exists notes(id integer primary key autoincr' +
        'ement, body text);'
      'select * from notes;')
    Left = 56
    Top = 376
  end
end

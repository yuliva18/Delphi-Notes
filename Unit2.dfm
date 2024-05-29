object NoteFrame: TNoteFrame
  Left = 0
  Top = 0
  Width = 281
  Height = 157
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  ParentBackground = False
  ParentColor = False
  ParentFont = False
  TabOrder = 0
  DesignSize = (
    281
    157)
  object Label1: TLabel
    Left = 3
    Top = 9
    Width = 25
    Height = 15
    Anchors = [akLeft]
    Caption = 'Title'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
  object Label2: TLabel
    Left = 3
    Top = 70
    Width = 27
    Height = 15
    Anchors = [akLeft]
    Caption = 'Body'
    Color = clBtnFace
    ParentColor = False
  end
  object Label3: TLabel
    Left = 3
    Top = 130
    Width = 24
    Height = 15
    Anchors = [akLeft]
    Caption = 'Date'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHotLight
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    StyleElements = [seClient, seBorder]
  end
end

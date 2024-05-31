object NoteFrame: TNoteFrame
  Left = 0
  Top = 0
  Width = 200
  Height = 70
  Align = alTop
  TabOrder = 0
  OnClick = DoClickEvent
  DesignSize = (
    200
    70)
  object BodyLabel: TLabel
    Left = 3
    Top = 13
    Width = 194
    Height = 15
    Anchors = [akLeft, akRight]
    AutoSize = False
    Caption = 'Body'
    EllipsisPosition = epEndEllipsis
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    StyleElements = [seClient, seBorder]
    OnClick = DoClickEvent
  end
  object DateLabel: TLabel
    Left = 3
    Top = 34
    Width = 194
    Height = 15
    Anchors = [akLeft, akRight]
    AutoSize = False
    Caption = 'Date'
    EllipsisPosition = epEndEllipsis
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGrayText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    StyleElements = [seClient, seBorder]
    OnClick = DoClickEvent
  end
end

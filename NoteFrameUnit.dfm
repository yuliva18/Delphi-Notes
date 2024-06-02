object NoteFrame: TNoteFrame
  Left = 0
  Top = 0
  Width = 200
  Height = 92
  Align = alTop
  TabOrder = 0
  OnClick = DoClickEvent
  DesignSize = (
    200
    92)
  object BodyLabel: TLabel
    Left = 3
    Top = 38
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
    Font.Style = []
    ParentFont = False
    StyleElements = [seClient, seBorder]
    OnClick = DoClickEvent
    ExplicitTop = 30
  end
  object DateLabel: TLabel
    Left = 3
    Top = 64
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
    ExplicitTop = 51
  end
  object TitleLabel: TLabel
    Left = 3
    Top = 13
    Width = 194
    Height = 15
    Anchors = [akLeft, akRight]
    AutoSize = False
    Caption = 'Title'
    EllipsisPosition = epEndEllipsis
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    StyleElements = [seClient, seBorder]
    OnClick = DoClickEvent
    ExplicitTop = 8
  end
end

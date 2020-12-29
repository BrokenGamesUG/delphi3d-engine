object Hauptform: THauptform
  Left = 214
  Top = 77
  Caption = 'Hauptform'
  ClientHeight = 784
  ClientWidth = 1024
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object RenderPanel: TPanel
    Left = 0
    Top = 0
    Width = 1024
    Height = 784
    Align = alClient
    TabOrder = 0
    OnResize = RenderPanelResize
  end
  object ApplicationEvents1: TApplicationEvents
    OnIdle = ApplicationEvents1Idle
    Left = 32
    Top = 32
  end
end

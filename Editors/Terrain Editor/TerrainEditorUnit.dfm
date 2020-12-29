object Hauptform: THauptform
  Left = 214
  Top = 77
  Caption = 'Hauptform'
  ClientHeight = 854
  ClientWidth = 806
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object RenderPanel: TPanel
    Left = 0
    Top = 0
    Width = 185
    Height = 854
    Align = alLeft
    TabOrder = 0
  end
  object ApplicationEvents1: TApplicationEvents
    OnIdle = ApplicationEvents1Idle
    Left = 32
    Top = 32
  end
  object MainMenu1: TMainMenu
    Left = 64
    Top = 32
    object Datei1: TMenuItem
      Caption = 'File'
      object New1: TMenuItem
        Caption = 'New'
        OnClick = New1Click
      end
      object NewfromGrayscale1: TMenuItem
        Caption = 'New from Grayscale'
      end
      object Open1: TMenuItem
        Caption = 'Open'
      end
      object Save1: TMenuItem
        Caption = 'Save'
      end
      object SaveAs1: TMenuItem
        Caption = 'Save as'
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'Exit'
        OnClick = Exit1Click
      end
    end
    object Einstellungen1: TMenuItem
      Caption = 'Settings'
      object Hintergrund1: TMenuItem
        Caption = 'Background'
        object Himmel1: TMenuItem
          AutoCheck = True
          Caption = 'Blue Sky'
          Checked = True
          RadioItem = True
        end
        object Wei1: TMenuItem
          AutoCheck = True
          Caption = 'White'
          RadioItem = True
          OnClick = Wei1Click
        end
        object BenutzerdefinierteFarbe1: TMenuItem
          AutoCheck = True
          Caption = 'Custom Color'
          RadioItem = True
          OnClick = BenutzerdefinierteFarbe1Click
        end
      end
      object DeferredShading1: TMenuItem
        AutoCheck = True
        Caption = 'Deferred Shading'
        Checked = True
        OnClick = DeferredShading1Click
      end
    end
    object errain1: TMenuItem
      Caption = 'Terrain'
      OnClick = errain1Click
    end
    object Water1: TMenuItem
      Caption = 'Water'
      OnClick = Water1Click
    end
    object Vegetation1: TMenuItem
      Caption = 'Vegetation'
      OnClick = Vegetation1Click
    end
    object LoadTestScene1: TMenuItem
      Caption = 'TestScene1'
      OnClick = LoadTestScene1Click
    end
  end
  object ColorDialog1: TColorDialog
    Color = clWhite
    Options = [cdFullOpen]
    Left = 32
    Top = 80
  end
end

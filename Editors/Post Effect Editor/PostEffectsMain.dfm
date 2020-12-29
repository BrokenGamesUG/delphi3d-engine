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
  Menu = MainMenu
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object RenderPanel: TPanel
    Left = 0
    Top = 0
    Width = 806
    Height = 854
    Align = alClient
    TabOrder = 0
  end
  object ApplicationEvents1: TApplicationEvents
    OnActivate = ApplicationEvents1Activate
    OnDeactivate = ApplicationEvents1Deactivate
    OnIdle = ApplicationEvents1Idle
    Left = 40
    Top = 16
  end
  object MainMenu: TMainMenu
    Left = 136
    Top = 16
    object Datei1: TMenuItem
      Caption = 'File'
      object CloseBtn: TMenuItem
        Caption = 'Close'
      end
    end
    object Einstellungen1: TMenuItem
      Caption = 'View'
      object SceneMenu: TMenuItem
        Caption = 'Scene'
        object SceneDefenderRadio: TMenuItem
          AutoCheck = True
          Caption = 'Defender'
          RadioItem = True
          OnClick = BigAction
        end
        object SceneCubesRadio: TMenuItem
          AutoCheck = True
          Caption = 'Cubes'
          Checked = True
          RadioItem = True
          OnClick = BigAction
        end
        object SceneLucyRadio: TMenuItem
          Tag = 3
          AutoCheck = True
          Caption = 'Lucy'
          RadioItem = True
          OnClick = BigAction
        end
        object SceneHalfSphereRadio: TMenuItem
          Tag = 1
          AutoCheck = True
          Caption = 'Half Sphere'
          RadioItem = True
          OnClick = BigAction
        end
        object SceneWiredCubeRadio: TMenuItem
          Tag = 2
          AutoCheck = True
          Caption = 'Wired Cube'
          RadioItem = True
          OnClick = BigAction
        end
        object N2: TMenuItem
          Caption = '-'
        end
        object SceneCustomModelRadio: TMenuItem
          AutoCheck = True
          Caption = 'Custom Model'
          RadioItem = True
          OnClick = BigAction
        end
      end
      object BackgroundMenu: TMenuItem
        Caption = 'Background'
        object BackgroundSkyRadio: TMenuItem
          AutoCheck = True
          Caption = 'Sky'
          Checked = True
          RadioItem = True
          OnClick = BigAction
        end
        object BackgroundWhiteRadio: TMenuItem
          AutoCheck = True
          Caption = 'White'
          RadioItem = True
          OnClick = BigAction
        end
        object BackgroundBlackRadio: TMenuItem
          AutoCheck = True
          Caption = 'Black'
          RadioItem = True
          OnClick = BigAction
        end
        object BackgroundGreyRadio: TMenuItem
          AutoCheck = True
          Caption = 'Grey'
          RadioItem = True
          OnClick = BigAction
        end
        object N1: TMenuItem
          Caption = '-'
        end
        object BackgroundCustomColorRadio: TMenuItem
          AutoCheck = True
          Caption = 'Custom Color'
          RadioItem = True
          OnClick = BigAction
        end
      end
    end
    object ShowEditorBtn: TMenuItem
      Caption = 'Show Editor'
      OnClick = BigAction
    end
  end
  object BackgroundColorDialog: TColorDialog
    Color = clWhite
    Options = [cdFullOpen]
    Left = 32
    Top = 80
  end
  object MeshOpenDialog: TOpenDialog
    Filter = 'Meshes (*.x;*.mx, *.fbx, *.xml)|*.x;*.mx;*.fbx;*.xml|All|*.*'
    Left = 136
    Top = 80
  end
end

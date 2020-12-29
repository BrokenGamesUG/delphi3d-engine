object Hauptform: THauptform
  Left = 603
  Top = 86
  BorderStyle = bsSingle
  Caption = 'Hauptform'
  ClientHeight = 795
  ClientWidth = 878
  Color = clBtnFace
  DragMode = dmAutomatic
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object RenderPanel: TPanel
    Left = 0
    Top = 0
    Width = 185
    Height = 767
    Align = alLeft
    DragMode = dmAutomatic
    TabOrder = 0
  end
  object PlayBtn: TButton
    Left = 0
    Top = 767
    Width = 878
    Height = 28
    Align = alBottom
    Caption = 'Play'
    TabOrder = 1
    OnClick = PatternChange
  end
  object ScrollBox1: TScrollBox
    Left = 676
    Top = 0
    Width = 202
    Height = 767
    VertScrollBar.Tracking = True
    Align = alRight
    TabOrder = 2
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 198
      Height = 41
      Align = alTop
      AutoSize = True
      DoubleBuffered = False
      ParentDoubleBuffered = False
      TabOrder = 0
    end
  end
  object ApplicationEvents1: TApplicationEvents
    OnIdle = ApplicationEvents1Idle
    Left = 32
    Top = 32
  end
  object MainMenu1: TMainMenu
    Left = 88
    Top = 32
    object Datei1: TMenuItem
      Caption = 'Datei'
      object Neu1: TMenuItem
        Caption = 'New'
        ShortCut = 16462
        OnClick = Neu1Click
      end
      object Open1: TMenuItem
        Caption = 'Open'
        ShortCut = 16463
        OnClick = Open1Click
      end
      object Save1: TMenuItem
        Caption = 'Save'
        ShortCut = 16467
        OnClick = Save1Click
      end
      object Saveas1: TMenuItem
        Caption = 'Save as'
        ShortCut = 49235
        OnClick = Saveas1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Beenden1: TMenuItem
        Caption = 'Beenden'
        OnClick = Beenden1Click
      end
    end
    object View1: TMenuItem
      Caption = 'View'
      object ShowGrid1: TMenuItem
        AutoCheck = True
        Caption = 'Show Grid'
        Checked = True
      end
      object ShowPath1: TMenuItem
        AutoCheck = True
        Caption = 'Show Path'
        Checked = True
      end
      object ShowReferencemodel1: TMenuItem
        AutoCheck = True
        Caption = 'Show Referencemodel'
        Checked = True
      end
      object ShowShadowmap1: TMenuItem
        AutoCheck = True
        Caption = 'Show Shadowmap'
      end
      object ChooseBackgroundcolor1: TMenuItem
        Caption = 'Choose Backgroundcolor'
        OnClick = ChooseBackgroundcolor1Click
      end
      object estRotation1: TMenuItem
        AutoCheck = True
        Caption = 'Test Rotation'
      end
      object estMovement1: TMenuItem
        Caption = 'Test Movement'
        object MovementOffCheck: TMenuItem
          AutoCheck = True
          Caption = 'Off'
          Checked = True
          RadioItem = True
        end
        object N1x1: TMenuItem
          AutoCheck = True
          Caption = '1x'
          RadioItem = True
        end
        object N2x1: TMenuItem
          AutoCheck = True
          Caption = '2x'
          RadioItem = True
        end
        object N4x1: TMenuItem
          AutoCheck = True
          Caption = '4x'
          RadioItem = True
        end
        object N8x1: TMenuItem
          AutoCheck = True
          Caption = '8x'
          RadioItem = True
        end
        object MovementSpeedBtn: TMenuItem
          AutoCheck = True
          Caption = 'Speed'
          RadioItem = True
          OnClick = MovementSpeedBtnClick
        end
      end
      object estOffset1: TMenuItem
        Caption = 'Test Offset'
        OnClick = estOffset1Click
      end
      object ShowTestMesh: TMenuItem
        AutoCheck = True
        Caption = 'Test Mesh'
      end
      object estmeshAnimation1: TMenuItem
        Caption = 'Testmesh Animation'
        OnClick = estmeshAnimation1Click
      end
      object SetTestmeshSize1: TMenuItem
        Caption = 'Set Testmesh Size'
        OnClick = SetTestmeshSize1Click
      end
      object ShowPosteffectEditor1: TMenuItem
        Caption = 'Show PosteffectEditor'
        OnClick = ShowPosteffectEditor1Click
      end
      object SetReferenceSize1: TMenuItem
        Caption = 'Set Reference Size'
        OnClick = SetReferenceSize1Click
      end
      object BindtoBone1: TMenuItem
        Caption = 'Bind to Bone'
        OnClick = BindtoBone1Click
      end
      object SetParticleeffectsize1: TMenuItem
        Caption = 'Set Particleeffect size'
        OnClick = SetParticleeffectsize1Click
      end
      object GameView1: TMenuItem
        AutoCheck = True
        Caption = 'Game View'
      end
      object AnimationBoundTest1: TMenuItem
        Caption = 'AnimationBoundTest'
        OnClick = AnimationBoundTest1Click
      end
    end
  end
  object TextureOpenDialog: TOpenDialog
    Filter = 
      'Textures (*.tga;*.png;*.jpg)|*.tga;*.png;*.jpg|All Files (*.*)|*' +
      '.*'
    Left = 32
    Top = 88
  end
  object PFXOpenDialog: TOpenDialog
    DefaultExt = 'pfx'
    Filter = 'ParticleEffectFile (*.pfx)|*.pfx'
    Left = 32
    Top = 152
  end
  object PFXSaveDialog: TSaveDialog
    DefaultExt = 'pfx'
    Filter = 'ParticleEffectFile (*.pfx)|*.pfx|All Files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 80
    Top = 152
  end
  object ColorDialog1: TColorDialog
    Options = [cdFullOpen]
    Left = 32
    Top = 208
  end
  object ModelOpenDialog: TOpenDialog
    Filter = 'Models|*.x;*.mx|All Files (*.*)|*.*'
    Left = 96
    Top = 88
  end
end

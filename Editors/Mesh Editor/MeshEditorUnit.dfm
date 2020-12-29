object Hauptform: THauptform
  Left = 505
  Top = 172
  Caption = 'Mesh Editor'
  ClientHeight = 858
  ClientWidth = 988
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object RenderPanel: TPanel
    Left = 260
    Top = 0
    Width = 728
    Height = 839
    Align = alClient
    TabOrder = 0
    OnResize = RenderPanelResize
  end
  object MainStatusBar: TStatusBar
    Left = 0
    Top = 839
    Width = 988
    Height = 19
    Panels = <
      item
        Width = 400
      end
      item
        Text = 
          'Hold right mouse button to rotate camera | Hold middle mouse but' +
          'ton to pan camera'
        Width = 600
      end
      item
        Width = 50
      end>
  end
  object ToolBox: TCategoryPanelGroup
    Left = 0
    Top = 0
    Width = 260
    Height = 839
    VertScrollBar.Tracking = True
    HeaderFont.Charset = DEFAULT_CHARSET
    HeaderFont.Color = clWindowText
    HeaderFont.Height = -11
    HeaderFont.Name = 'Tahoma'
    HeaderFont.Style = []
    TabOrder = 2
    object AnimationCategory: TCategoryPanel
      Top = 433
      Height = 581
      Caption = 'Animation'
      TabOrder = 0
      object Animations: TLabel
        Left = 0
        Top = 0
        Width = 239
        Height = 13
        Align = alTop
        Caption = 'Animations'
        ExplicitWidth = 51
      end
      object Label3: TLabel
        Left = 8
        Top = 280
        Width = 33
        Height = 13
        Caption = 'Length'
      end
      object Label2: TLabel
        Left = 3
        Top = 373
        Width = 79
        Height = 13
        Caption = 'Defaultnaimation'
      end
      object AniList: TListBox
        Left = 0
        Top = 13
        Width = 239
        Height = 217
        Align = alTop
        ItemHeight = 13
        ScrollWidth = 500
        TabOrder = 0
      end
      object AniPlayStopBtn: TButton
        Left = 3
        Top = 245
        Width = 97
        Height = 25
        Caption = 'Play'
        TabOrder = 1
        OnClick = AniPlayStopBtnClick
      end
      object LoopedChk: TCheckBox
        Left = 112
        Top = 249
        Width = 89
        Height = 17
        Caption = 'Looped'
        TabOrder = 2
      end
      object BlendCheckBox: TCheckBox
        Left = 172
        Top = 249
        Width = 97
        Height = 17
        Caption = 'Blend'
        Checked = True
        State = cbChecked
        TabOrder = 3
      end
      object LengthOverrideEdit: TEdit
        Left = 47
        Top = 277
        Width = 121
        Height = 21
        NumbersOnly = True
        TabOrder = 4
        Text = '0'
      end
      object PauseBtn: TButton
        Left = 3
        Top = 304
        Width = 97
        Height = 25
        Caption = 'Pause/Continue'
        TabOrder = 5
        OnClick = PauseBtnClick
      end
      object StopBtn: TButton
        Left = 106
        Top = 304
        Width = 97
        Height = 25
        Caption = 'Stop'
        TabOrder = 6
        OnClick = StopBtnClick
      end
      object ImportAnimationBtn: TButton
        Left = 51
        Top = 335
        Width = 97
        Height = 25
        Caption = 'Import Animation'
        TabOrder = 7
        OnClick = ImportAnimationBtnClick
      end
      object DefaultAnimationEdt: TEdit
        Left = 88
        Top = 365
        Width = 129
        Height = 21
        TabOrder = 8
      end
      object MarkAsDefaultBtn: TButton
        Left = 24
        Top = 392
        Width = 177
        Height = 25
        Caption = 'Set Marked As Default'
        TabOrder = 9
        OnClick = MarkAsDefaultBtnClick
      end
      object GroupBox1: TGroupBox
        Left = 3
        Top = 423
        Width = 223
        Height = 130
        Caption = 'Copy Animation'
        TabOrder = 10
        object Label4: TLabel
          Left = 15
          Top = 20
          Width = 48
          Height = 13
          Caption = 'Startframe'
        end
        object Label5: TLabel
          Left = 16
          Top = 47
          Width = 45
          Height = 13
          Caption = 'Endframe'
        end
        object StartframeEdit: TEdit
          Left = 69
          Top = 17
          Width = 124
          Height = 21
          TabOrder = 0
          Text = '0'
        end
        object EndframeEdit: TEdit
          Left = 67
          Top = 44
          Width = 126
          Height = 21
          TabOrder = 1
          Text = '100'
        end
        object CreateAnimationBtn: TButton
          Left = 45
          Top = 95
          Width = 132
          Height = 25
          Caption = 'Create New Animation'
          TabOrder = 3
          OnClick = CreateAnimationBtnClick
        end
        object NewAnimationNameEdit: TEdit
          Left = 19
          Top = 71
          Width = 182
          Height = 21
          TabOrder = 2
          Text = 'New Animation Name'
          OnDblClick = NewAnimationNameEditDblClick
        end
      end
    end
    object GeometryCategory: TCategoryPanel
      Top = 0
      Height = 433
      Caption = 'Geometry'
      TabOrder = 1
      object Label1: TLabel
        Left = 0
        Top = 0
        Width = 239
        Height = 13
        Align = alTop
        Caption = 'Bones'
        ExplicitWidth = 30
      end
      object Label6: TLabel
        Left = 0
        Top = 226
        Width = 239
        Height = 13
        Align = alTop
        Caption = 'Size for visualization'
        ExplicitWidth = 95
      end
      object BoneLst: TListBox
        Left = 0
        Top = 13
        Width = 239
        Height = 188
        Align = alTop
        ItemHeight = 13
        TabOrder = 0
        OnDblClick = BoneLstDblClick
      end
      object ShowBonesCheck: TCheckBox
        Left = 0
        Top = 201
        Width = 239
        Height = 25
        Align = alTop
        Caption = 'Show Bones'
        TabOrder = 1
      end
      object SizeTrack: TTrackBar
        Left = 0
        Top = 239
        Width = 239
        Height = 26
        Align = alTop
        Max = 1000
        Position = 500
        TabOrder = 2
        TickMarks = tmBoth
        TickStyle = tsNone
        OnChange = SizeTrackChange
      end
      object AnimationOverwritePanel: TPanel
        Left = 0
        Top = 265
        Width = 239
        Height = 142
        Align = alTop
        AutoSize = True
        BevelInner = bvLowered
        Caption = 'AnimationOverwritePanel'
        ShowCaption = False
        TabOrder = 3
        object Label7: TLabel
          AlignWithMargins = True
          Left = 5
          Top = 5
          Width = 229
          Height = 13
          Margins.Bottom = 6
          Align = alTop
          Caption = 'Selected Bone Transformation Overwrite'
          ExplicitWidth = 191
        end
        object AxisRadioGroup: TRadioGroup
          Left = 2
          Top = 50
          Width = 235
          Height = 61
          Align = alTop
          Caption = 'Axis Choose'
          ItemIndex = 0
          Items.Strings = (
            'X'
            'Y'
            'Z')
          TabOrder = 0
        end
        object RotationTrackBar: TTrackBar
          Left = 2
          Top = 111
          Width = 235
          Height = 29
          Align = alTop
          Max = 360
          TabOrder = 1
        end
        object BoneOverwriteCheckBox: TCheckBox
          AlignWithMargins = True
          Left = 5
          Top = 27
          Width = 229
          Height = 17
          Margins.Bottom = 6
          Align = alTop
          Caption = 'Overwrite enabled'
          TabOrder = 2
        end
      end
    end
  end
  object ApplicationEvents1: TApplicationEvents
    OnIdle = ApplicationEvents1Idle
    Left = 32
    Top = 80
  end
  object MainMenu1: TMainMenu
    Left = 96
    Top = 32
    object FileMenu: TMenuItem
      Caption = 'File'
      object OpenMenuItem: TMenuItem
        Caption = '&Open'
        OnClick = BigChangeMainMenu
      end
      object SaveMenuItem: TMenuItem
        Caption = '&Save'
        OnClick = BigChangeMainMenu
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object CloseMenuItem: TMenuItem
        Caption = '&Close'
        OnClick = BigChangeMainMenu
      end
    end
    object ViewMenu: TMenuItem
      Caption = 'View'
      object ResetCameraMenuItem: TMenuItem
        Caption = 'Reset Camera'
        OnClick = BigChangeMainMenu
      end
    end
    object SettingsMenu: TMenuItem
      Caption = 'Settings'
      object DeferredShadingMenuItem: TMenuItem
        AutoCheck = True
        Caption = 'Deferred Shading'
        Checked = True
      end
      object ChooseBackgroundcolorMenuItem: TMenuItem
        Caption = 'Choose Backgroundcolor'
        OnClick = BigChangeMainMenu
      end
      object WireframeMenuItem: TMenuItem
        AutoCheck = True
        Caption = 'Wireframe'
      end
      object MetalShaderMenu: TMenuItem
        Caption = 'EnvironmentMapping'
        object NoneMenuItem: TMenuItem
          AutoCheck = True
          Caption = 'None'
          Checked = True
          RadioItem = True
          OnClick = BigChangeMainMenuEnvironmentClick
        end
        object MetalMenuItem: TMenuItem
          AutoCheck = True
          Caption = 'Metal'
          RadioItem = True
          OnClick = BigChangeMainMenuEnvironmentClick
        end
        object MatcapMenuItem: TMenuItem
          AutoCheck = True
          Caption = 'Matcap'
          RadioItem = True
          OnClick = BigChangeMainMenuEnvironmentClick
        end
        object N2: TMenuItem
          Caption = '-'
        end
        object PickTextureMenuItem: TMenuItem
          Caption = 'Pick Texture'
          OnClick = BigChangeMainMenuEnvironmentClick
        end
      end
      object ShadowsMenuItem: TMenuItem
        AutoCheck = True
        Caption = 'Shadows'
        Checked = True
        OnClick = BigChangeMainMenu
      end
      object SetLightToViewMenuItem: TMenuItem
        Caption = 'Set Light to View'
        OnClick = BigChangeMainMenu
      end
      object StayOnTopMenuItem: TMenuItem
        AutoCheck = True
        Caption = 'Stay Always On Top'
        OnClick = BigChangeMainMenu
      end
      object Posteffects1: TMenuItem
        Caption = 'Posteffects'
        OnClick = Posteffects1Click
      end
      object ShowGrid1: TMenuItem
        AutoCheck = True
        Caption = 'Show Grid'
        Checked = True
      end
    end
    object ShowMaterialeditorBtn: TMenuItem
      Caption = 'Show Materialeditor'
      OnClick = BigChangeMainMenu
    end
  end
  object MeshOpenDialog: TOpenDialog
    Filter = 
      'Meshdateien (*.mx,*.x, *.xml)|*.mx;*.x;*.xml;*.fbx|MegaX (*.mx)|' +
      '*.mx|X-Datei (*.x)|*.x|MeshXML (*.xml)|*.xml|FBX-File (*.fbx)|*.' +
      'fbx|Alle Dateien|*.*'
    Options = [ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 160
    Top = 32
  end
  object TextureOpenDialog: TOpenDialog
    Filter = 'Texture (*.psd,*.png,*.tga)|*.tga;*.psd;*.png|Alle Dateien|*.*'
    Options = [ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 223
    Top = 32
  end
  object MeshSaveDialogXML: TSaveDialog
    DefaultExt = 'mx'
    Filter = 'MeshXML (*.xml)|*.xml'
    Options = [ofReadOnly, ofHideReadOnly, ofOldStyleDialog, ofEnableSizing]
    Left = 160
    Top = 88
  end
  object ColorDialog1: TColorDialog
    Left = 32
    Top = 160
  end
end

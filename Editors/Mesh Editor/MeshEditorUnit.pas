unit MeshEditorUnit;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  AppEvnts,
  Variants,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  Engine.Core,
  Engine.Core.Types,
  Engine.GFXApi,
  Engine.GFXApi.Types,
  Vcl.Buttons,
  Engine.Input,
  ExtCtrls,
  Engine.Math,
  Engine.Helferlein,
  Engine.Helferlein.Windows,
  Engine.Core.Lights,
  Math,
  StdCtrls,
  Menus,
  Engine.Mesh,
  Engine.Mesh.Editor,
  ComCtrls,
  Grids,
  ValEdit,
  Engine.Posteffects,
  Engine.Posteffects.Editor,
  Engine.Collision,
  Engine.Vertex,
  ShellApi,
  Generics.Collections,
  StrUtils,
  Engine.Math.Collision3D,
  Engine.Animation,
  Engine.Helferlein.VCLUtils,
  Data.Bind.EngExt,
  Vcl.Bind.DBEngExt,
  System.Rtti,
  System.Bindings.Outputs,
  Vcl.Bind.Editors,
  Data.Bind.Components,
  ClipBrd;

type
  THauptform = class(TForm)
    ApplicationEvents1 : TApplicationEvents;
    RenderPanel : TPanel;
    MainMenu1 : TMainMenu;
    FileMenu : TMenuItem;
    CloseMenuItem : TMenuItem;
    OpenMenuItem : TMenuItem;
    N1 : TMenuItem;
    MeshOpenDialog : TOpenDialog;
    TextureOpenDialog : TOpenDialog;
    SaveMenuItem : TMenuItem;
    MeshSaveDialogXML : TSaveDialog;
    MainStatusBar : TStatusBar;
    SettingsMenu : TMenuItem;
    DeferredShadingMenuItem : TMenuItem;
    ColorDialog1 : TColorDialog;
    ChooseBackgroundcolorMenuItem : TMenuItem;
    WireframeMenuItem : TMenuItem;
    MetalShaderMenu : TMenuItem;
    ShadowsMenuItem : TMenuItem;
    SetLightToViewMenuItem : TMenuItem;
    StayOnTopMenuItem : TMenuItem;
    NoneMenuItem : TMenuItem;
    MetalMenuItem : TMenuItem;
    MatcapMenuItem : TMenuItem;
    N2 : TMenuItem;
    PickTextureMenuItem : TMenuItem;
    ViewMenu : TMenuItem;
    ResetCameraMenuItem : TMenuItem;
    Posteffects1 : TMenuItem;
    ShowGrid1 : TMenuItem;
    ShowMaterialeditorBtn : TMenuItem;
    ToolBox : TCategoryPanelGroup;
    GeometryCategory : TCategoryPanel;
    AnimationCategory : TCategoryPanel;
    Label1 : TLabel;
    BoneLst : TListBox;
    ShowBonesCheck : TCheckBox;
    Label6 : TLabel;
    SizeTrack : TTrackBar;
    AnimationOverwritePanel : TPanel;
    Label7 : TLabel;
    AxisRadioGroup : TRadioGroup;
    RotationTrackBar : TTrackBar;
    BoneOverwriteCheckBox : TCheckBox;
    Animations : TLabel;
    AniList : TListBox;
    AniPlayStopBtn : TButton;
    LoopedChk : TCheckBox;
    BlendCheckBox : TCheckBox;
    LengthOverrideEdit : TEdit;
    Label3 : TLabel;
    PauseBtn : TButton;
    StopBtn : TButton;
    ImportAnimationBtn : TButton;
    Label2 : TLabel;
    DefaultAnimationEdt : TEdit;
    MarkAsDefaultBtn : TButton;
    GroupBox1 : TGroupBox;
    Label4 : TLabel;
    Label5 : TLabel;
    StartframeEdit : TEdit;
    EndframeEdit : TEdit;
    CreateAnimationBtn : TButton;
    NewAnimationNameEdit : TEdit;
    procedure FormCreate(Sender : TObject);
    procedure ApplicationEvents1Idle(Sender : TObject; var Done : Boolean);
    procedure FormClose(Sender : TObject; var Action : TCloseAction);
    procedure AniPlayStopBtnClick(Sender : TObject);
    procedure MarkAsDefaultBtnClick(Sender : TObject);
    procedure CreateAnimationBtnClick(Sender : TObject);
    procedure SizeTrackChange(Sender : TObject);
    procedure PauseBtnClick(Sender : TObject);
    procedure StopBtnClick(Sender : TObject);
    procedure ImportAnimationBtnClick(Sender : TObject);
    procedure BigChangeMainMenuEnvironmentClick(Sender : TObject);
    procedure BigChangeMainMenu(Sender : TObject);
    procedure RenderPanelResize(Sender : TObject);
    procedure NewAnimationNameEditDblClick(Sender : TObject);
    procedure Posteffects1Click(Sender : TObject);
    procedure BoneLstDblClick(Sender : TObject);
    procedure FormActivate(Sender : TObject);
    private
      { Private-Deklarationen }
      originalPanelWindowProc : TWndMethod;

      FOpenedFile : string;
      procedure DragAndDropWindowProc(var Msg : TMessage);
      procedure DropFile(Msg : TWMDROPFILES);
      procedure LoadMeshFile(filename : string);
      procedure SaveMeshAsXML(filename : string);
      function MouseOverRenderPanel : Boolean;
    public
      procedure SyncToGUI;
      { Public-Deklarationen }
  end;

var
  Hauptform : THauptform;
  DXMouse : TMouse;
  DXKeyboard : TKeyboard;
  InputManager : TInputDeviceManager;
  KamPos : RVector3;
  Alpha, Beta, r : single;
  CameraTarget : RVector3;
  Mesh : TMesh;
  MausPos : RIntVector2;
  CameraMovement : Boolean;
  CamPos : RVector3;
  ReplaceColor : RColor;
  ReflectionTexture : TTexture;
  FormReady : Boolean;
  CaptionString : string;
  Posteffects : TPostEffectManager;

const
  DEFAULT_MODEL_FILENAME = ''; // if set to something else then '', Model will be directly loaded on create form

implementation

{$R *.dfm}


procedure THauptform.FormCreate(Sender : TObject);
var
  temp : integer;
begin
  {$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}
  FormatSettings.DecimalSeparator := '.';

  ContentManager.ObservationEnabled := True;

  Application.HintHidePause := 5000;
  if ParamCount > 1 then
  begin
    Height := Screen.Monitors[0].Height;
    Width := Screen.Monitors[0].Width;
    Top := Screen.Monitors[0].Top;
    Left := Screen.Monitors[0].Left;
  end
  else
  begin
    Height := Screen.WorkAreaHeight;
    Width := Screen.Width;
    Top := 0;
    Left := 0;
  end;
  GFXD := TGFXD.create(RenderPanel.Handle, false, RenderPanel.Width, RenderPanel.Height, True, True, aaNone, 32, DirectX11Device, True);
  GFXD.Settings.DeferredShading := HFileIO.ReadBoolFromIni(AbsolutePath('LocalSettings.ini'), 'Editor', 'DeferredShading', True);
  DeferredShadingMenuItem.Checked := GFXD.Settings.DeferredShading;

  GFXD.MainScene.MainDirectionalLight.Direction := RVector3.create(-0.016, -0.336, -0.352);
  GFXD.MainScene.MainDirectionalLight.Color := RVector4.create(1, 1, 0.924, 0.8);
  // GFXD.DirectionalLights.Add(TDirectionalLight.create(RVector4.create(0.616, 0.62, 1.0, 0.84), RVector3.create(-1, 0.224, -0.152)));
  GFXD.MainScene.Ambient := RVector4.create(1, 1, 1, 0.628);

  GFXD.MainScene.ShadowTechnique := stShadowmapping;
  if HFileIO.TryReadIntFromIni(AbsolutePath('LocalSettings.ini'), 'Editor', 'ShadowMapResolution', temp) then
      GFXD.MainScene.ShadowMapping.Resolution := temp;
  GFXD.MainScene.ShadowMapping.Shadowbias := 5.0;

  LinePool := TLinePool.create(nil, 100000);

  DragAcceptFiles(Self.Handle, True);
  Self.originalPanelWindowProc := Self.WindowProc;
  Self.WindowProc := DragAndDropWindowProc;

  InputManager := TInputDeviceManager.create(false, RenderPanel.Handle);
  DXMouse := InputManager.DirectInputFactory.ErzeugeTMouseDirectInput(false);
  DXKeyboard := InputManager.DirectInputFactory.ErzeugeTKeyboardDirectInput(false);

  GFXD.MainScene.Camera.PerspectiveCamera(RVector3.create(10, 10, 10), RVector3.ZERO);
  r := 150;
  Alpha := PI / 3;
  Beta := PI / 4;
  ReplaceColor := RColor.CPINK;

  FOpenedFile := '';
  ReflectionTexture := TTexture.CreateTextureFromFile(FormatDateiPfad('MetalVelvet.png'), GFXD.Device3D);
  if ParamCount > 0 then
      LoadMeshFile(FormatDateiPfad(ParamStr(1)))
  else if not DEFAULT_MODEL_FILENAME.IsEmpty then
      LoadMeshFile(FormatDateiPfad(DEFAULT_MODEL_FILENAME));

  if HFileIO.ReadBoolFromIni(AbsolutePath('LocalSettings.ini'), 'Editor', 'PostEffects', True) then
      Posteffects := TPostEffectManager.CreateFromFile(nil, 'PostEffects.fxs')
  else
      Posteffects := TPostEffectManager.CreateFromFile(nil, 'PostEffects_Empty.fxs');

  FormReady := True;
end;

procedure THauptform.FormActivate(Sender : TObject);
begin
  MausPos := RIntVector2(RenderPanel.ScreenToClient(Vcl.Controls.Mouse.CursorPos));
end;

procedure THauptform.FormClose(Sender : TObject; var Action : TCloseAction);
begin
  Mesh.Free;
  ReflectionTexture.Free;
  LinePool.Free;
  Posteffects.Free;
  GFXD.Free;
  DXMouse.Free;
  DXKeyboard.Free;
  InputManager.Free;
end;

procedure THauptform.BoneLstDblClick(Sender : TObject);
begin
  if BoneLst.HasSelection then
  begin
    Clipboard.AsText := BoneLst.SelectedItems[0];
  end;
end;

procedure THauptform.SyncToGUI;
var
  Info : TStrings;
begin
  if Mesh <> nil then
  begin
    // Animation
    AniList.Clear;
    Info := Mesh.AnimationController.GetAnimationInfo;
    AniList.Items.AddStrings(Info);
    Info.Free;

    BoneLst.Clear;
    Info := Mesh.GetBoneList;
    BoneLst.Items.AddStrings(Info);
    Info.Free;

    SizeTrackChange(Self);
  end;
end;

procedure THauptform.LoadMeshFile(filename : string);
begin
  Mesh.Free;
  try
    Mesh := TMesh.CreateFromFile(GFXD.MainScene, filename);
    Mesh.ShowEditorForm;
    FOpenedFile := filename;
    NoneMenuItem.Click;
    SyncToGUI;
  except
    on e : Exception do
    begin
      if DebugHook <> 0 then raise;
      ShowMessage('Laden fehlgeschlagen: ' + e.Message);
      Mesh := nil;
    end;
  end;
  CaptionString := 'Mesh Editor';
  if FOpenedFile <> '' then
      CaptionString := CaptionString + ' [' + FOpenedFile + ']';
end;

procedure THauptform.BigChangeMainMenuEnvironmentClick(Sender : TObject);
begin
  if Sender = PickTextureMenuItem then
  begin
    if TextureOpenDialog.Execute then
    begin
      ReflectionTexture.Free;
      ReflectionTexture := TTexture.CreateTextureFromFile(TextureOpenDialog.filename, GFXD.Device3D);
    end;
  end
  else
  begin
    if assigned(Mesh) then
    begin
      if Sender = NoneMenuItem then
      begin
        Mesh.CustomShader.Clear;
      end;
      if Sender = MetalMenuItem then
      begin
        Mesh.CustomShader.Clear;
        Mesh.CustomShader.Add(RMeshShader.create('MetalShader.fx',
          procedure(Shader : TShader; Stage : EnumRenderStage; PassIndex : integer)
          begin
            Shader.SetTexture(tsVariable2, ReflectionTexture);
          end));
      end;
      if Sender = MatcapMenuItem then
      begin
        ReflectionTexture.Free;
        ReflectionTexture := TTexture.CreateTextureFromFile(AbsolutePath('Matcap\JG_Drink01.png'), GFXD.Device3D);
        Mesh.CustomShader.Clear;
        Mesh.CustomShader.Add(RMeshShader.create('MatcapShader.fx',
          procedure(Shader : TShader; Stage : EnumRenderStage; PassIndex : integer)
          begin
            Shader.SetTexture(tsVariable2, ReflectionTexture);
          end));
      end;
    end;
  end;
end;

procedure THauptform.BigChangeMainMenu(Sender : TObject);
begin
  // File - Menu ///////////////////////////////////////////////////////////////
  if Sender = SaveMenuItem then
  begin
    if FOpenedFile <> '' then
        MeshSaveDialogXML.InitialDir := ExtractFilePath(FOpenedFile);
    if MeshSaveDialogXML.Execute then
        SaveMeshAsXML(MeshSaveDialogXML.filename);
  end;
  if Sender = OpenMenuItem then
  begin
    if MeshOpenDialog.Execute then
    begin
      LoadMeshFile(MeshOpenDialog.filename);
    end;
  end;
  if Sender = CloseMenuItem then Close;

  // View - Menu ///////////////////////////////////////////////////////////////
  if Sender = ResetCameraMenuItem then
  begin
    r := 150;
    Alpha := PI / 3;
    Beta := PI / 4;
    CameraTarget := RVector3(0);
  end;

  // Settings - Menu ///////////////////////////////////////////////////////////
  if Sender = DeferredShadingMenuItem then GFXD.Settings.DeferredShading := DeferredShadingMenuItem.Checked;
  if Sender = StayOnTopMenuItem then
  begin
    if StayOnTopMenuItem.Checked then
        FormStyle := TFormStyle.fsStayOnTop
    else
        FormStyle := TFormStyle.fsNormal;
  end;
  if Sender = SetLightToViewMenuItem then GFXD.MainScene.MainDirectionalLight.Direction := GFXD.MainScene.Camera.CameraDirection;
  if Sender = ShadowsMenuItem then
  begin
    if GFXD.MainScene.ShadowTechnique = EnumShadowTechnique.stNone then GFXD.MainScene.ShadowTechnique := EnumShadowTechnique.stShadowmapping
    else GFXD.MainScene.ShadowTechnique := EnumShadowTechnique.stNone;
  end;
  if Sender = ChooseBackgroundcolorMenuItem then
  begin
    ColorDialog1.Color := GFXD.MainScene.Backgroundcolor.AsBGRCardinal;
    if ColorDialog1.Execute then
    begin
      GFXD.MainScene.Backgroundcolor.AsBGRCardinal := ColorDialog1.Color;
    end;
  end;
  // Misc //////////////////////////////////////////////////////////////////////////
  if (Sender = ShowMaterialeditorBtn) and assigned(Mesh) then Mesh.ShowEditorForm;
end;

procedure THauptform.RenderPanelResize(Sender : TObject);
begin
  if assigned(GFXD) then GFXD.ChangeResolution(RIntVector2.create(RenderPanel.Width, RenderPanel.Height));
end;

procedure THauptform.ApplicationEvents1Idle(Sender : TObject; var Done : Boolean);
var
  i : integer;
  Bone, Transformation : RMatrix4x3;
  tempMouse, diffMouse : RIntVector2;
  ClickRay : RRAy;
  BoneName : string;
begin
  Caption := Format('FPS: %d %s Deferred Shading: %s', [GFXD.FPS, CaptionString, BoolToStr(GFXD.Settings.DeferredShading, True)]);
  InputManager.Idle;
  TimeManager.TickTack;

  GFXD.Settings.DeferredShading := DeferredShadingMenuItem.Checked;

  if MouseOverRenderPanel and Active then
  begin
    if DXKeyboard.KeyDown(TasteEsc) then
    begin
      Close;
      exit;
    end;

    DXMouse.Position := RIntVector2(RenderPanel.ScreenToClient(Vcl.Controls.Mouse.CursorPos));
    tempMouse := RIntVector2(RenderPanel.ScreenToClient(Vcl.Controls.Mouse.CursorPos));
    ClickRay := GFXD.MainScene.Camera.Clickvector(tempMouse.X, tempMouse.Y);
    diffMouse := tempMouse - MausPos;
    if DXMouse.ButtonIsDown(mbLeft) and RenderPanel.MouseInClient then
    begin
      if assigned(Mesh) then Mesh.Position := RPlane.XZ.IntersectRay(ClickRay);
    end;
    if DXMouse.ButtonIsDown(mbRight) and RenderPanel.MouseInClient then
    begin
      Alpha := Alpha + (diffMouse.X) / 500.0;
      Beta := Beta - (diffMouse.Y) / 500.0;
      LinePool.AddSphere(CameraTarget, 0.005 * r, RColor.CRED, 8);
      CameraMovement := CameraMovement or (diffMouse.X <> 0) or (diffMouse.Y <> 0);
    end;
    if DXMouse.ButtonIsDown(mbMiddle) and RenderPanel.MouseInClient then
    begin
      CameraTarget := CameraTarget + GFXD.MainScene.Camera.ScreenLeft * (diffMouse.X) * 0.001 * r;
      CameraTarget := CameraTarget + GFXD.MainScene.Camera.ScreenUp * (diffMouse.Y) * 0.001 * r;
      LinePool.AddSphere(CameraTarget, 0.005 * r, RColor.CRED, 8);
      CameraMovement := CameraMovement or (diffMouse.X <> 0) or (diffMouse.Y <> 0);
    end;
    MausPos := tempMouse;

    if DXMouse.dZ < 0 then r := r * 4 / 3;
    if DXMouse.dZ > 0 then r := r * 3 / 4;

    if DXKeyboard.KeyUp(TasteL) then SetLightToViewMenuItem.Click;
    if DXKeyboard.KeyUp(TasteDruck) then GFXD.ScreenShot(HFilepathManager.GetSpecialPath(spDesktop, Handle));
  end;
  CamPos := Kugeldrehung(Alpha, Beta, 0, 0, 0, r);

  if ShowBonesCheck.Checked then
  begin
    for i := 0 to BoneLst.Count - 1 do
    begin
      BoneName := BoneLst.Items[i];
      if BoneName.Contains('$') then continue;
      if not Mesh.TryGetBonePosition(BoneName, Bone) then assert(false, 'Bone not found - should not happen ;)');
      if i = BoneLst.ItemIndex then
      begin
        LinePool.AddSphere(Bone.Translation, 3, RColor.CYELLOW, 16);
        LinePool.AddCoordinateSystem(Bone.To4x4);
      end
      else LinePool.AddCoordinateSystem(Bone.To4x4)
        // LinePool.AddBox(BonePoint, BoneUp, RVector3.UNITY.Cross(BoneUp), RVector3.Create(10), RColor.CPINK, 1);
    end;
  end;

  if (BoneLst.ItemIndex > -1) and BoneOverwriteCheckBox.Checked and assigned(Mesh) then
  begin
    BoneName := BoneLst.Items[BoneLst.ItemIndex];
    case AxisRadioGroup.ItemIndex of
      0 : Transformation := RMatrix4x3.CreateRotationX(RotationTrackBar.Position / RotationTrackBar.Max * 2 * PI);
      1 : Transformation := RMatrix4x3.CreateRotationY(RotationTrackBar.Position / RotationTrackBar.Max * 2 * PI);
      2 : Transformation := RMatrix4x3.CreateRotationZ(RotationTrackBar.Position / RotationTrackBar.Max * 2 * PI);
    end;
    Mesh.TrySetBoneTransformation(BoneName, Transformation);
  end;

  if WireframeMenuItem.Checked or ShowBonesCheck.Checked then GFXD.Device3D.SetRenderState(rsFILLMODE, fmWireframe)
  else GFXD.Device3D.SetRenderState(rsFILLMODE, fmSolid);
  if ShowGrid1.Checked then
      LinePool.AddGrid(RVector3.ZERO, RVector3.UnitX, RVector3.unitZ, RVector2.create(11, 11), $40000000, 12);
  GFXD.MainScene.Camera.PerspectiveCamera(CamPos + CameraTarget, CameraTarget);
  GFXD.RenderTheWholeUniverseMegaGameProzedureDingMussNochLängerWerdenDeswegenHierMüllZeugsBlubsKeks;
  Done := false;
end;

procedure THauptform.DragAndDropWindowProc(var Msg : TMessage);
begin
  if Msg.Msg = WM_DROPFILES then
      DropFile(TWMDROPFILES(Msg))
  else
      originalPanelWindowProc(Msg);
end;

procedure THauptform.DropFile(Msg : TWMDROPFILES);
var
  numFiles : longInt;
  buffer : array [0 .. MAX_PATH] of Char;
begin
  numFiles := DragQueryFile(Msg.Drop, $FFFFFFFF, nil, 0);
  if numFiles = 0 then
  begin
    exit;
  end
  else if numFiles > 1 then
  begin
    ShowMessage('You can only drop one file at a time in this window!');
    exit;
  end;

  DragQueryFile(Msg.Drop, 0, @buffer, sizeof(buffer));
  LoadMeshFile(string(buffer));
end;

procedure THauptform.SaveMeshAsXML(filename : string);
  procedure CopyRessource(RessourceSourceFileName, DestinationFilePath : string);
  var
    DestinationFileName : string;
  begin
    if RessourceSourceFileName = '' then exit;
    if not FileExists(RessourceSourceFileName) then raise Exception.create('THauptform.SaveMeshAsXML.CopyRessource: Can''t find file ("' + RessourceSourceFileName + '")');
    DestinationFileName := DestinationFilePath + Extractfilename(RessourceSourceFileName);
    if RessourceSourceFileName = DestinationFileName then exit;
    CopyFile(PWideChar(RessourceSourceFileName), PWideChar(DestinationFileName), false);
  end;

var
  filepath : string;
begin
  if not assigned(Mesh) then exit;
  Mesh.SaveToFile(filename);
  // activate real pathes to copy ressources
  Mesh.ShowRealPath := True;
  filepath := ExtractFilePath(MeshSaveDialogXML.filename);
  CopyRessource(Mesh.GeometryFile, filepath);
  CopyRessource(Mesh.DiffuseTetxure, filepath);
  CopyRessource(Mesh.NormalTexture, filepath);
  CopyRessource(Mesh.SpecularTexture, filepath);
  Mesh.ShowRealPath := false;

  MainStatusBar.Panels[0].Text := 'Datei wurde gespeichert.';
end;

procedure THauptform.StopBtnClick(Sender : TObject);
begin
  if assigned(Mesh) then
      Mesh.AnimationController.Stop(True);
end;

procedure THauptform.MarkAsDefaultBtnClick(Sender : TObject);
var
  Info : TObjectList<Engine.Animation.TAnimationController.TAnimationInfo>;
begin
  if AniList.ItemIndex > -1 then
  begin
    Info := Mesh.AnimationController.GetAnimationInfoExtended;
    Mesh.AnimationController.DefaultAnimation := Info[AniList.ItemIndex].Name;
    DefaultAnimationEdt.Text := Info[AniList.ItemIndex].Name;
    Info.Free;
  end;
end;

function THauptform.MouseOverRenderPanel : Boolean;
var
  Pointi : TPoint;
begin
  Pointi := RenderPanel.ScreenToClient(Vcl.Controls.Mouse.CursorPos);
  Result := ((RenderPanel.Left <= Pointi.X) and (RenderPanel.Left + RenderPanel.Width >= Pointi.X)) and ((RenderPanel.Top <= Pointi.Y) and (RenderPanel.Top + RenderPanel.Height >= Pointi.Y));
end;

procedure THauptform.NewAnimationNameEditDblClick(Sender : TObject);
begin
  NewAnimationNameEdit.SelectAll;
end;

procedure THauptform.PauseBtnClick(Sender : TObject);
begin
  if assigned(Mesh) then
      Mesh.AnimationController.Pause;
end;

procedure THauptform.Posteffects1Click(Sender : TObject);
begin
  Posteffects.ShowDebugForm;
end;

procedure THauptform.AniPlayStopBtnClick(Sender : TObject);
var
  Info : TObjectList<Engine.Animation.TAnimationController.TAnimationInfo>;
  Index : integer;
begin
  if AniList.Items.Count > 0 then
  begin
    if AniList.ItemIndex <= -1 then
        index := 0
    else index := AniList.ItemIndex;
    Info := Mesh.AnimationController.GetAnimationInfoExtended;
    if LoopedChk.Checked then Mesh.AnimationController.Play(Info[index].Name, alLoop, StrToInt(LengthOverrideEdit.Text))
    else Mesh.AnimationController.Play(Info[index].Name, alSingle, StrToInt(LengthOverrideEdit.Text), BlendCheckBox.Checked);
    Info.Free;
  end;
end;

procedure THauptform.CreateAnimationBtnClick(Sender : TObject);
var
  Info : TObjectList<Engine.Animation.TAnimationController.TAnimationInfo>;
  SourceName : string;
begin
  if AniList.ItemIndex >= 0 then
  begin
    if AniList.ItemIndex > -1 then
    begin
      Info := Mesh.AnimationController.GetAnimationInfoExtended;
      SourceName := AniList.Items[AniList.ItemIndex];
      Mesh.AnimationDriverBone.CreateNewAnimation(NewAnimationNameEdit.Text, Info[AniList.ItemIndex].Name,
        StrToInt(StartframeEdit.Text), StrToInt(EndframeEdit.Text));
      Mesh.AnimationDriverMorph.CreateNewAnimation(NewAnimationNameEdit.Text, Info[AniList.ItemIndex].Name,
        StrToInt(StartframeEdit.Text), StrToInt(EndframeEdit.Text));
      SyncToGUI;
      AniList.ItemIndex := AniList.Items.IndexOf(SourceName);
      Info.Free;
    end;
  end;
end;

procedure THauptform.ImportAnimationBtnClick(Sender : TObject);
var
  OverrideName : string;
begin
  if assigned(Mesh) and MeshOpenDialog.Execute() then
  begin
    OverrideName := InputBox('Override animation name', 'New Name:', '');
    Mesh.AnimationDriverBone.ImportAnimationFromFile(MeshOpenDialog.filename, OverrideName);
    SyncToGUI;
  end;
end;

procedure THauptform.SizeTrackChange(Sender : TObject);
begin
  if assigned(Mesh) then
  begin
    if SizeTrack.Position > 500 then Mesh.Scale := (SizeTrack.Position - 499) * 2
    else Mesh.Scale := SizeTrack.Position / 500;
  end;
end;

end.

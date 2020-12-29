unit PFXMain;

interface

uses
  Windows,
  Messages,
  SysUtils,
  AppEvnts,
  Variants,
  Graphics,
  Controls,
  Forms,
  Rtti,
  Engine.Vertex,
  Dialogs,
  Engine.Animation,
  Engine.Core.Lights,
  Engine.Core,
  Engine.Core.Types,
  Engine.ParticleEffects,
  Engine.ParticleEffects.Types,
  Engine.ParticleEffects.Emitters,
  Engine.ParticleEffects.Simulators,
  Engine.PostEffects,
  Engine.PostEffects.Editor,
  Engine.Physics,
  Engine.Mesh,
  ExtCtrls,
  Engine.Math,
  Engine.Math.Collision3D,
  Engine.GfxApi.Types,
  Engine.Helferlein,
  Engine.Helferlein.Windows,
  Math,
  StdCtrls,
  Menus,
  Engine.Input,
  System.Classes,
  Vcl.Grids,
  Vcl.ComCtrls,
  Shellapi,
  Engine.Serializer,
  Engine.ParticleEffects.Particles,
  Engine.Helferlein.VCLUtils,
  Generics.Collections;

type

  THauptform = class(TForm)
    ApplicationEvents1 : TApplicationEvents;
    RenderPanel : TPanel;
    MainMenu1 : TMainMenu;
    Datei1 : TMenuItem;
    Beenden1 : TMenuItem;
    TextureOpenDialog : TOpenDialog;
    PFXOpenDialog : TOpenDialog;
    PFXSaveDialog : TSaveDialog;
    N1 : TMenuItem;
    Neu1 : TMenuItem;
    Open1 : TMenuItem;
    Save1 : TMenuItem;
    Saveas1 : TMenuItem;
    PlayBtn : TButton;
    View1 : TMenuItem;
    ShowGrid1 : TMenuItem;
    ChooseBackgroundcolor1 : TMenuItem;
    ColorDialog1 : TColorDialog;
    ShowPath1 : TMenuItem;
    ShowReferencemodel1 : TMenuItem;
    ModelOpenDialog : TOpenDialog;
    ScrollBox1 : TScrollBox;
    Panel1 : TPanel;
    estRotation1 : TMenuItem;
    estMovement1 : TMenuItem;
    ShowTestMesh : TMenuItem;
    ShowShadowmap1 : TMenuItem;
    N1x1 : TMenuItem;
    N2x1 : TMenuItem;
    N4x1 : TMenuItem;
    N8x1 : TMenuItem;
    MovementOffCheck : TMenuItem;
    estmeshAnimation1 : TMenuItem;
    ShowPosteffectEditor1 : TMenuItem;
    SetReferenceSize1 : TMenuItem;
    estOffset1 : TMenuItem;
    BindtoBone1 : TMenuItem;
    SetParticleeffectsize1 : TMenuItem;
    SetTestmeshSize1 : TMenuItem;
    GameView1 : TMenuItem;
    AnimationBoundTest1 : TMenuItem;
    MovementSpeedBtn : TMenuItem;
    procedure FormCreate(Sender : TObject);
    procedure ApplicationEvents1Idle(Sender : TObject; var Done : Boolean);
    procedure FormClose(Sender : TObject; var Action : TCloseAction);
    procedure Beenden1Click(Sender : TObject);
    procedure PatternChange(Sender : TObject);
    procedure Neu1Click(Sender : TObject);
    procedure Open1Click(Sender : TObject);
    procedure Save1Click(Sender : TObject);
    procedure Saveas1Click(Sender : TObject);
    procedure ChooseBackgroundcolor1Click(Sender : TObject);
    procedure FormShow(Sender : TObject);
    procedure estmeshAnimation1Click(Sender : TObject);
    procedure ShowPosteffectEditor1Click(Sender : TObject);
    procedure SetReferenceSize1Click(Sender : TObject);
    procedure estOffset1Click(Sender : TObject);
    procedure BindtoBone1Click(Sender : TObject);
    procedure SetParticleeffectsize1Click(Sender : TObject);
    procedure SetTestmeshSize1Click(Sender : TObject);
    procedure AnimationBoundTest1Click(Sender : TObject);
    procedure MovementSpeedBtnClick(Sender : TObject);
    private
      { Private-Deklarationen }
      procedure WMDROPFILES(var Msg : TMessage); message WM_DROPFILES;
      procedure VCLEvent(Sender : string; NewValue : TValue);
    public
      procedure Render;
      function MausInRenderpanel : Boolean;
      procedure LoadParticleEffect(Path : string);
      procedure UpdateParticleEffect;
      { Public-Deklarationen }
  end;

var
  Hauptform : THauptform;
  DXMouse : TMouse;
  CamPos : RVector3;
  Moving : Boolean;
  Alpha, Beta, r, YOffset, MovementSpeed, PFXSize : single;
  Input : TInputDeviceManager;
  ParticleEffect : TParticleEffect;
  MainPattern : TParticleEffectPattern;
  PhysicManager : TPhysicManager;
  MountedFile : string;
  PatternForm : TBoundForm;
  Ground, TestMesh : TMesh;
  DragLoadPFX, BoundBone : string;
  PostEffectManager : TPostEffectManager;
  AnimationBoundTest : TTimer;

implementation

{$R *.dfm}


procedure THauptform.FormCreate(Sender : TObject);
var
  temp : single;
begin
  TXMLSerializer.CacheXMLDocuments := False;
  ReportMemoryLeaksOnShutdown := DebugHook <> 0;
  DragAcceptFiles(Handle, True);
  FormatSettings.DecimalSeparator := ',';
  Application.HintHidePause := 5000;
  Height := Screen.WorkAreaHeight;
  Width := Screen.Width;
  Top := 0;
  Left := 0;
  RenderPanel.Width := ClientWidth - ScrollBox1.Width;

  ContentManager.ObservationEnabled := True;

  GFXD := TGFXD.Create(RenderPanel.Handle, False, RenderPanel.Width, RenderPanel.Height, True, True, EnumAntialiasingLevel.aaNone, 32, DirectX11Device);
  GFXD.MainScene.ShadowTechnique := EnumShadowTechnique.stShadowmapping;
  GFXD.MainScene.Shadowmapping.Shadowbias := 0.01;
  GFXD.MainScene.Shadowmapping.Slopebias := 0.5;

  GFXD.MainScene.MainDirectionalLight.Direction := RVector3.Create(-0.024, -0.672, -0.368);
  GFXD.MainScene.MainDirectionalLight.Color := RVector4.Create(1, 1, 1, 0.52);
  GFXD.MainScene.Ambient := RVector4.Create(1, 1, 1, 0.772);

  PostEffectManager := TPostEffectManager.Create(GFXD.MainScene);
  PostEffectManager.LoadFromFile('PostEffects.fxs');
  PostEffectManager.Add('ShadowDrawer', TPostEffectDrawDepthBuffer.Create());
  PostEffectManager.Get<TPostEffectDrawDepthBuffer>('ShadowDrawer').Enabled := False;
  PostEffectManager.Get<TPostEffectDrawDepthBuffer>('ShadowDrawer').DepthBuffer := GFXD.MainScene.Shadowmapping.ShadowMap;
  PostEffectManager.Get<TPostEffectDrawDepthBuffer>('ShadowDrawer').Near := 0;
  PostEffectManager.Get<TPostEffectDrawDepthBuffer>('ShadowDrawer').far := 100;

  VertexEngine := TVertexEngine.Create(GFXD.MainScene);

  ColorDialog1.Color := GFXD.MainScene.Backgroundcolor.AsBGRCardinal;
  Input := TInputDeviceManager.Create(False, RenderPanel.Handle);
  DXMouse := Input.DirectInputFactory.ErzeugeTMouseDirectInput(False);
  PhysicManager := TPhysicManager.Create;
  PhysicManager.AddForceField(TGlobalForceField.Create(-RVector3.UNITY * 50));
  // PhysicManager.AddForceField(TWhiteHoleForceField.Create(RVector3.ZERO, 10, 600));
  PhysicManager.AddObstacle(TPlaneObstacle.Create(RPlane.XZ));
  PhysicManager.AddObstacle(TPlaneObstacle.Create(RPlane.CreateFromNormal(RVector3.Create(0, 0, 20), -RVector3.UNITZ)));
  PhysicManager.AddObstacle(TPlaneObstacle.Create(RPlane.CreateFromNormal(RVector3.Create(0, 0, -20), RVector3.UNITZ)));
  PhysicManager.AddObstacle(TPlaneObstacle.Create(RPlane.CreateFromNormal(RVector3.Create(20, 0, 0), -RVector3.UNITX)));
  PhysicManager.AddObstacle(TPlaneObstacle.Create(RPlane.CreateFromNormal(RVector3.Create(-20, 0, 0), RVector3.UNITX)));
  ParticleEffectEngine := TParticleEffectEngine.Create(GFXD.MainScene, PhysicManager);
  ParticleEffectEngine.AssetPath := HFileIO.ReadFromIni(HFilepathManager.RelativeToAbsolute('WorkingPath.ini'), 'General', 'WorkingPath');
  ParticleEffectEngine.DeferredShading := False;
  ParticleEffectEngine.Shadows := False;
  ParticleEffectEngine.SafeBackground := False;
  LinePool := TLinePool.Create(GFXD.MainScene, 20000);
  Ground := TMesh.CreateFromFile(GFXD.MainScene, AbsolutePath('Bridge2.xml'));
  Ground.Position := -Ground.BoundingBoxTransformed.Center.SetY(0.05);
  if not TryStrToFloat(HFileIO.ReadFromIni(HFilepathManager.RelativeToAbsolute('Settings.ini'), 'General', 'ReferenceSize', '1.0'), temp, EngineFloatFormatSettings) then temp := 1.0;
  Ground.Scale := temp;
  r := 31.6;
  Alpha := 1.052;
  Beta := 1.011;
  Neu1Click(self);

  DragLoadPFX := 'cataclysm_cast.pfx';
end;

procedure THauptform.FormShow(Sender : TObject);
begin
  PatternForm := TFormGenerator.GenerateForm(Panel1, TParticleEffectPattern);
  PatternForm.OnChange := VCLEvent;
  PatternForm.BoundInstance := MainPattern;

  if ParamStr(1) <> '' then LoadParticleEffect(ParamStr(1));
end;

procedure THauptform.FormClose(Sender : TObject; var Action : TCloseAction);
begin
  AnimationBoundTest.Free;
  PostEffectManager.Free;
  TestMesh.Free;
  PatternForm.Free;
  PhysicManager.Free;
  ParticleEffect.Free;
  Ground.Free;
  ParticleEffectEngine.Free;
  VertexEngine.Free;
  LinePool.Free;
  GFXD.Free;
  DXMouse.Free;
  Input.Free;
  Halt;
end;

procedure THauptform.LoadParticleEffect(Path : string);
var
  pattern : TParticleEffectPattern;
  result : integer;
begin
  if MountedFile <> '' then result := MessageDlg('Do you like to merge the effects?', mtConfirmation, [mbYes, mbNo, mbCancel], 0)
  else result := mrNo;
  PFXSize := 1.0;
  case result of
    mrYes :
      begin
        pattern := TParticleEffectPattern.CreateFromFile(Path, ParticleEffectEngine);
        MainPattern.AddFromPattern(pattern);
        PatternForm.BoundInstance := MainPattern;
      end;
    mrNo :
      begin
        MountedFile := Path;
        MainPattern := TParticleEffectPattern.CreateFromFile(Path, ParticleEffectEngine);
        PatternForm.BoundInstance := MainPattern;
        FreeAndNil(ParticleEffect);
      end;
    mrCancel :;
  end;
end;

procedure THauptform.Render;
var
  i : integer;
begin
  if ShowGrid1.Checked then
  begin
    LinePool.AddGrid(RVector3.ZERO - RVector3.Create(0, 0.02, 0), RVector3.UNITX, RVector3.UNITZ, RVector2.Create(20, 20), $FF202020, 21);
    LinePool.AddLine(RVector3.Create(0, 0.01, 0), RVector3.UNITX * 10 - RVector3.Create(0, 0.01, 0), $FFFF0000);
    LinePool.AddLine(RVector3.Create(0, 0.01, 0), RVector3.UNITZ * 10 - RVector3.Create(0, 0.01, 0), $FF0000FF);
  end;
  if ShowPath1.Checked then
  begin
    if assigned(ParticleEffect) then LinePool.AddSphere(ParticleEffect.Position, 0.1, RColor.CPINK);
    for i := 0 to MainPattern.SimulationData.Count - 1 do
        MainPattern.SimulationData[i].DrawDebug;
    for i := 0 to MainPattern.Emitter.Count - 1 do
        MainPattern.Emitter[i].DrawDebug;
  end;

  Ground.Visible := ShowReferencemodel1.Checked;
  if ShowReferencemodel1.Checked then
  begin
    ParticleEffectEngine.Softparticlerange := 0.3;
  end
  else ParticleEffectEngine.Softparticlerange := -1;

  if assigned(TestMesh) then TestMesh.Visible := ShowTestMesh.Checked;
  PostEffectManager.Get<TPostEffectDrawDepthBuffer>('ShadowDrawer').Enabled := ShowShadowmap1.Checked;

  GFXD.MainScene.Camera.PerspectiveCamera(CamPos, RVector3.ZERO);
  GFXD.RenderTheWholeUniverseMegaGameProzedureDingMussNochLängerWerdenDeswegenHierMüllZeugsBlubsKeks;
end;

procedure THauptform.Save1Click(Sender : TObject);
begin
  if (MountedFile <> '') or PFXSaveDialog.Execute then
  begin
    if (MountedFile = '') then MountedFile := PFXSaveDialog.FileName;
    MainPattern.SaveToFile(MountedFile);
  end;
end;

procedure THauptform.Saveas1Click(Sender : TObject);
begin
  MountedFile := '';
  Save1Click(self);
end;

procedure THauptform.SetParticleeffectsize1Click(Sender : TObject);
var
  Size : string;
begin
  Size := InputBox('Set size', 'Size:', '1.0').Replace(',', '.');
  TryStrToFloat(Size, PFXSize, EngineFloatFormatSettings);
end;

procedure THauptform.SetReferenceSize1Click(Sender : TObject);
var
  Size : single;
begin
  Size := 1.0;
  TryStrToFloat(InputBox('Reference Size', 'Set Reference Size', '1.0').Replace(',', '.'), Size, EngineFloatFormatSettings);
  Ground.Scale := Size;
  HFileIO.WriteToIni(HFilepathManager.RelativeToAbsolute('Settings.ini'), 'General', 'ReferenceSize', FloatToStrF(Size, ffGeneral, 4, 4, EngineFloatFormatSettings));
end;

procedure THauptform.SetTestmeshSize1Click(Sender : TObject);
var
  Size : single;
begin
  if not assigned(TestMesh) then exit;
  Size := 1.0;
  TryStrToFloat(InputBox('Testmesh Size', 'Set Testmesh Size', HConvert.FloatToStr(TestMesh.Scale)).Replace(',', '.'), Size, EngineFloatFormatSettings);
  if Size < 0 then Size := abs(Size) * 2 / 125;
  TestMesh.Scale := Size;
end;

procedure THauptform.ShowPosteffectEditor1Click(Sender : TObject);
begin
  PostEffectManager.ShowDebugForm;
end;

procedure THauptform.UpdateParticleEffect;
begin

end;

procedure THauptform.VCLEvent(Sender : string; NewValue : TValue);
begin
  MainPattern.UpdateSimulatorsInData;
end;

procedure THauptform.WMDROPFILES(
  var
  Msg :
  TMessage);
var
  PFilename : PChar;
  i : integer;
  Size : integer;
begin
  inherited;
  PFilename := nil;
  i := DragQueryFile(Msg.WParam, $FFFFFFFF, PFilename, 255);
  if i >= 0 then
  begin
    Size := DragQueryFile(Msg.WParam, 0, nil, 0) + 1;
    PFilename := StrAlloc(Size);
    DragQueryFile(Msg.WParam, 0, PFilename, Size);
    DragLoadPFX := string(PFilename);
    StrDispose(PFilename);

    if HFilepathManager.IsFileType(DragLoadPFX, 'xml') then
    begin
      FormatSettings.DecimalSeparator := '.';
      TestMesh.Free;
      TestMesh := TMesh.CreateFromFile(GFXD.MainScene, DragLoadPFX);
      if TestMesh.BoundingSphereTransformed.Radius > 50 then TestMesh.Scale := 2 / 125;
      TestMesh.Front := RVector3.UNITX;

      ShowTestMesh.Checked := True;
      DragLoadPFX := '';
      FormatSettings.DecimalSeparator := ',';
    end;
  end;
  DragFinish(Msg.WParam);
end;

function THauptform.MausInRenderpanel : Boolean;
var
  Pointi : TPoint;
begin
  Pointi := ScreenToClient(Vcl.Controls.Mouse.CursorPos);
  result := ((RenderPanel.Left <= Pointi.X) and (RenderPanel.Left + RenderPanel.Width >= Pointi.X)) and ((RenderPanel.Top <= Pointi.Y) and (RenderPanel.Top + RenderPanel.Height >= Pointi.Y));
  result := result and Active;
end;

procedure THauptform.MovementSpeedBtnClick(Sender : TObject);
var
  Input : string;
begin
  Input := InputBox('Movement speed', 'Movement speed', '').Replace(',', '.');
  TryStrToFloat(Input, MovementSpeed, EngineFloatFormatSettings);
end;

procedure THauptform.Neu1Click(Sender : TObject);
begin
  MountedFile := '';
  FreeAndNil(ParticleEffect);
  MainPattern := TParticleEffectPattern.Create(ParticleEffectEngine);
  if assigned(PatternForm) then PatternForm.BoundInstance := MainPattern;
end;

procedure THauptform.Open1Click(Sender : TObject);
begin
  if PFXOpenDialog.Execute then
  begin
    LoadParticleEffect(PFXOpenDialog.FileName);
  end;
end;

procedure THauptform.PatternChange(Sender : TObject);
begin
  if Sender = ScrollBox1 then
  begin

  end;

  if (Sender = PlayBtn) then
  begin
    ParticleEffect.Free;
    ParticleEffect := ParticleEffectEngine.CreateParticleEffectFromPattern(MainPattern);
    ParticleEffect.StartEmission;
  end;
end;

procedure THauptform.AnimationBoundTest1Click(Sender : TObject);
var
  temp : string;
  startframe, endframe, length : integer;
begin
  if assigned(TestMesh) then
  begin
    temp := InputBox('Animation definieren', 'Startanimations-Frame', '');
    if not TryStrToInt(temp, startframe) then exit;
    temp := InputBox('Animation definieren', 'Endanimations-Frame', '');
    if not TryStrToInt(temp, endframe) then exit;
    TestMesh.AnimationDriverBone.CreateNewAnimation('test', 'AnimStack::Take 001', startframe, endframe);
    TestMesh.AnimationController.DefaultAnimation := 'test';
    AnimationBoundTest.Free;
    AnimationBoundTest := TTimer.Create(round((endframe - startframe + 1) * 33.33333));
    AnimationBoundTest.Expired := True;
  end;
end;

procedure THauptform.ApplicationEvents1Idle(Sender : TObject; var Done : Boolean);
var
  tempMouse, diffMouse : RIntVector2;
  factor : single;
  Matrix : RMatrix4x3;
begin
  Caption := 'FPS:' + Inttostr(GFXD.FPS) + ' with ' + Inttostr(ParticleEffectEngine.ParticlesRenderedInLastFrame) + ' Particles ' + Inttostr(GFXD.MainScene.Lights.Count) + ' Lights';
  TimeManager.TickTack;
  Input.DirectInputFactory.Idle;

  if DragLoadPFX <> '' then
  begin
    LoadParticleEffect(DragLoadPFX);
    DragLoadPFX := '';
    PlayBtn.Click;
  end;

  if assigned(ParticleEffect) then
  begin
    ParticleEffect.Size := PFXSize;
    if MausInRenderpanel and Moving and DXMouse.ButtonIsDown(mbLeft) then
        ParticleEffect.Position := RPlane.XZ.IntersectRay(GFXD.MainScene.Camera.Clickvector(DXMouse.Position));
    if assigned(TestMesh) and TestMesh.TryGetBonePosition(BoundBone, Matrix) then
    begin
      Matrix.SwapXY;
      ParticleEffect.Base := Matrix;
      ParticleEffect.Position := ParticleEffect.Position.SetY(ParticleEffect.Position.Y + YOffset);
    end
    else ParticleEffect.Position := ParticleEffect.Position.SetY(YOffset);
  end;

  if MausInRenderpanel then
  begin
    tempMouse := DXMouse.Position;
    DXMouse.Position := RIntVector2(RenderPanel.ScreenToClient(Vcl.Controls.Mouse.CursorPos));
    diffMouse := tempMouse - DXMouse.Position;
    if DXMouse.ButtonIsDown(mbRight) then
    begin
      Alpha := Alpha + (diffMouse.X) / 500.0;
      Beta := Beta - (diffMouse.Y) / 500.0;
    end;
    if DXMouse.dZ < 0 then r := r * 4 / 3;
    if DXMouse.dZ > 0 then r := r * 3 / 4;

    if DXMouse.ButtonDown(mbLeft) then Moving := True;
    if not DXMouse.ButtonIsDown(mbLeft) then Moving := False;

    if assigned(ParticleEffect) then
    begin
      if DXMouse.ButtonUp(mbLeft) then ParticleEffect.StartEmission;
      if DXMouse.ButtonUp(mbExtra1) then ParticleEffect.StopEmission;
    end;
  end;
  CamPos := Kugeldrehung(Alpha, Beta, 0, 0, 0, r);
  if GameView1.Checked then CamPos := 10.0 * 3.8 * RVector3.Create(0.394721269607544, 0.812130928039551, 0.429695725440979);

  if estRotation1.Checked and assigned(ParticleEffect) then
  begin
    ParticleEffect.Position := RVector3.Create(0, 5, 0);
    ParticleEffect.Front := RVector3.UNITZ.RotatePitchYawRoll(TimeManager.GetFloatingTimestamp / 3000 * RVector3.Create(1, 1.5, 2));
    if ShowPath1.Checked then LinePool.AddLine(RVector3.ZERO, ParticleEffect.Front * 10, RColor.CWHITE);
  end;
  if not MovementOffCheck.Checked and assigned(ParticleEffect) then
  begin
    if N2x1.Checked then factor := 2.0
    else if N4x1.Checked then factor := 4.0
    else if N8x1.Checked then factor := 8.0
    else if MovementSpeedBtn.Checked then factor := MovementSpeed / { 2 * PI * }10
    else factor := 1.0;
    ParticleEffect.Position := RVector3.Create(0, 5, 10).RotatePitchYawRoll(0, factor * TimeManager.GetFloatingTimestamp / 1000, 0) + RVector3.Create(0, YOffset, 0);
    ParticleEffect.Front := ParticleEffect.Position.Cross(RVector3.UNITY).Normalize;
    if ShowPath1.Checked then LinePool.AddSphere(ParticleEffect.Position.SetY(0), 1, RColor.CWHITE);
  end;
  if assigned(AnimationBoundTest) and AnimationBoundTest.Expired and assigned(ParticleEffect) then
  begin
    TestMesh.AnimationController.Play('test', alSingle);
    ParticleEffect.StartEmission;
    AnimationBoundTest.Start;
  end;

  ParticleEffectEngine.Idle;

  Render;
  Done := False;
end;

procedure THauptform.Beenden1Click(Sender : TObject);
begin
  Close;
end;

procedure THauptform.BindtoBone1Click(Sender : TObject);
begin
  BoundBone := InputBox('Bind to Bone', 'Bonename:', '');
end;

procedure THauptform.ChooseBackgroundcolor1Click(Sender : TObject);
begin
  if ColorDialog1.Execute then GFXD.MainScene.Backgroundcolor.AsBGRCardinal := ColorDialog1.Color;
end;

procedure THauptform.estmeshAnimation1Click(Sender : TObject);
var
  temp : string;
  startframe, endframe : integer;
begin
  if assigned(TestMesh) then
  begin
    temp := InputBox('Animation definieren', 'Startanimations-Frame', '');
    if not TryStrToInt(temp, startframe) then exit;
    temp := InputBox('Animation definieren', 'Endanimations-Frame', '');
    if not TryStrToInt(temp, endframe) then exit;
    TestMesh.AnimationDriverBone.CreateNewAnimation('test', 'AnimStack::Take 001', startframe, endframe);
    TestMesh.AnimationController.Play('test', alLoop);
    TestMesh.AnimationController.DefaultAnimation := 'test';
  end;
end;

procedure THauptform.estOffset1Click(Sender : TObject);
var
  Input : string;
begin
  Input := InputBox('Offset', 'Give a y offset:', '0.0').Replace(',', '.');
  TryStrToFloat(Input, YOffset, EngineFloatFormatSettings);
end;

end.

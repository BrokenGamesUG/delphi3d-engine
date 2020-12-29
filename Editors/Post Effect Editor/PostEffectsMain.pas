unit PostEffectsMain;

interface

uses
  // System
  System.Messaging,
  WinApi.Windows,
  WinApi.Messages,
  System.Classes,
  System.SysUtils,
  ShellApi,
  Vcl.Controls,
  Vcl.AppEvnts,
  Vcl.ExtCtrls,
  Vcl.Dialogs,
  Vcl.Forms,
  Vcl.StdCtrls,
  Vcl.Menus,
  Generics.Collections,
  // Engine
  Engine.Core,
  Engine.Core.Types,
  Engine.Core.Lights,
  Engine.GFXapi.Types,
  Engine.Input,
  Engine.Log,
  Engine.Math,
  Engine.Math.Collision3D,
  Engine.Math.Collision2D,
  Engine.Helferlein,
  Engine.Helferlein.Windows,
  Engine.Helferlein.VCLUtils,
  Engine.Mesh,
  Engine.PostEffects,
  Engine.PostEffects.Editor,
  Engine.SkyBox;

type

  THauptform = class(TForm)
    ApplicationEvents1 : TApplicationEvents;
    RenderPanel : TPanel;
    MainMenu : TMainMenu;
    Datei1 : TMenuItem;
    CloseBtn : TMenuItem;
    Einstellungen1 : TMenuItem;
    SceneMenu : TMenuItem;
    SceneCubesRadio : TMenuItem;
    SceneLucyRadio : TMenuItem;
    BackgroundMenu : TMenuItem;
    BackgroundSkyRadio : TMenuItem;
    BackgroundWhiteRadio : TMenuItem;
    BackgroundCustomColorRadio : TMenuItem;
    BackgroundColorDialog : TColorDialog;
    SceneCustomModelRadio : TMenuItem;
    MeshOpenDialog : TOpenDialog;
    SceneHalfSphereRadio : TMenuItem;
    SceneWiredCubeRadio : TMenuItem;
    BackgroundBlackRadio : TMenuItem;
    BackgroundGreyRadio : TMenuItem;
    N1 : TMenuItem;
    N2 : TMenuItem;
    ShowEditorBtn : TMenuItem;
    SceneDefenderRadio : TMenuItem;
    procedure FormCreate(Sender : TObject);
    procedure ApplicationEvents1Idle(Sender : TObject; var Done : Boolean);
    procedure FormClose(Sender : TObject; var Action : TCloseAction);
    procedure BigAction(Sender : TObject);
    procedure ApplicationEvents1Activate(Sender : TObject);
    procedure ApplicationEvents1Deactivate(Sender : TObject);
    private
      { Private-Deklarationen }
      FOriginalPanelWindowProc : TWndMethod;
      procedure DragAndDropWindowProc(var Msg : TMessage);
      procedure DropFile(Msg : TWMDROPFILES);
    public
      { Public-Deklarationen }
  end;

var
  Hauptform : THauptform;
  Input : TInputDeviceManager;
  PreventFocus : Boolean = false;
  CamPos : RVector3;
  LastMousePos : RIntVector2;
  Alpha, Beta, r : single;
  // Background
  SkyBox : TSky;
  // Scene
  Cubes : TObjectList<TMesh>;
  CustomModel : TMesh;
  PostEffectManager : TPostEffectManager;

implementation

{$R *.dfm}


procedure THauptform.FormCreate(Sender : TObject);
const
  CUBE_COUNT = 5; // per axis and per positive and negative
var
  x, y, z : integer;
begin
  DragAcceptFiles(Self.Handle, True);
  Self.FOriginalPanelWindowProc := Self.WindowProc;
  Self.WindowProc := DragAndDropWindowProc;

  RandSeed := 0;
  ReportMemoryLeaksOnShutdown := DebugHook <> 0;
  ClientHeight := Screen.WorkAreaHeight;
  ClientWidth := Screen.WorkAreaWidth;
  Top := 0;
  Left := -8;
  GFXD := TGFXD.Create(RenderPanel.Handle, false, RenderPanel.Width, RenderPanel.Height, True, false, EnumAntialiasingLevel.aaNone, 32, DirectX11Device, True);
  GFXD.MainScene.MainDirectionalLight.Direction := RVector3.Create(1, -1, 1);
  PostEffectManager := TPostEffectManager.Create(GFXD.MainScene);
  Input := TInputDeviceManager.Create(false, RenderPanel.Handle);
  Mouse := Input.DirectInputFactory.ErzeugeTMouseDirectInput(false);
  Keyboard := Input.DirectInputFactory.ErzeugeTKeyboardDirectInput(false);

  r := 150;
  Alpha := PI / 3;
  Beta := PI / 4;

  Cubes := TObjectList<TMesh>.Create;
  for x := -CUBE_COUNT to CUBE_COUNT do
    for y := -CUBE_COUNT to CUBE_COUNT do
      for z := -CUBE_COUNT to CUBE_COUNT do
        if random < 0.3 then
        begin
          Cubes.Add(TMesh.CreateFromFile(GFXD.MainScene, FormatDateiPfad('\Models\Cube.x')));
          Cubes.Last.Position := RVector3.Create(x * 9, y * 9, z * 9);
        end;

  SkyBox := TSkySphere.Create(GFXD.MainScene);
  GFXD.MainScene.Backgroundcolor := $FF9CC8FE; // ground from half sky sphere
  GFXD.MainScene.Ambient := $60FFFFFF;
  BigAction(Self);

  PostEffectManager.LoadFromFile('Default.fxs');
end;

procedure THauptform.FormClose(Sender : TObject; var Action : TCloseAction);
begin
  Mouse.Free;
  Keyboard.Free;
  Cubes.Free;
  PostEffectManager.Free;
  CustomModel.Free;
  SkyBox.Free;
  GFXD.Free;
  Input.Destroy;
end;

procedure THauptform.ApplicationEvents1Activate(Sender : TObject);
begin
  GFXD.FPSCounter.FrameLimit := 0;
end;

procedure THauptform.ApplicationEvents1Deactivate(Sender : TObject);
begin
  GFXD.FPSCounter.FrameLimit := 5;
end;

procedure THauptform.ApplicationEvents1Idle(Sender : TObject; var Done : Boolean);
var
  diffMouse : RIntVector2;
  i : integer;
begin
  Caption := 'FPS:' + Inttostr(GFXD.FPS);
  TimeManager.TickTack;
  Input.Idle;

  Mouse.Position := RIntVector2(RenderPanel.ScreenToClient(Vcl.Controls.Mouse.CursorPos));
  if MouseOverForm and Active then
  begin
    diffMouse := Mouse.Position - LastMousePos;
    if Mouse.ButtonIsDown(mbRight) then
    begin
      Alpha := Alpha + diffMouse.x / 500;
      Beta := Beta - diffMouse.y / 500;
    end;
    if Mouse.dZ < 0 then r := r * 4 / 3;
    if Mouse.dZ > 0 then r := r * 3 / 4;

    if Keyboard.KeyUp(TasteLeerTaste) then PostEffectManager.ShowDebugForm;
  end;
  LastMousePos := Mouse.Position;
  CamPos := Kugeldrehung(Alpha, Beta, 0, 0, 0, r);

  SkyBox.Visible := BackgroundSkyRadio.Checked;

  for i := 0 to Cubes.Count-1 do
   Cubes[i].Visible := SceneCubesRadio.Checked  ;
  if assigned(CustomModel) then CustomModel.Visible := not SceneCubesRadio.Checked;

  GFXD.MainScene.Camera.PerspectiveCamera(CamPos, RVector3.ZERO);
  GFXD.RenderTheWholeUniverseMegaGameProzedureDingMussNochLängerWerdenDeswegenHierMüllZeugsBlubsKeks;
  Done := false;
end;

procedure THauptform.BigAction(Sender : TObject);
begin
  if Sender = CloseBtn then Close;

  if Sender = ShowEditorBtn then PostEffectManager.ShowDebugForm;

  // Background Color
  if Sender = BackgroundSkyRadio then GFXD.MainScene.Backgroundcolor := $FF9CC8FE;
  if Sender = BackgroundWhiteRadio then GFXD.MainScene.Backgroundcolor := $FFFFFFFF;
  if Sender = BackgroundBlackRadio then GFXD.MainScene.Backgroundcolor := $FF000000;
  if Sender = BackgroundGreyRadio then GFXD.MainScene.Backgroundcolor := $FF757575;
  if Sender = BackgroundCustomColorRadio then
    if BackgroundColorDialog.Execute then GFXD.MainScene.Backgroundcolor.AsBGRCardinal := BackgroundColorDialog.Color;

  // Scene
  if Sender = SceneDefenderRadio then
  begin
    CustomModel.Free;
    CustomModel := TMesh.CreateFromFile(GFXD.MainScene,AbsolutePath('\Models\Defender.xml'));
  end;
  if Sender = SceneLucyRadio then
  begin
    CustomModel.Free;
    CustomModel := TMesh.CreateFromFile(GFXD.MainScene,AbsolutePath('\Models\Lucy.x'));
    CustomModel.Position := CustomModel.Position.SetY(-CustomModel.BoundingSphereTransformed.Radius / 2);
  end;
  if Sender = SceneHalfSphereRadio then
  begin
    CustomModel.Free;
    CustomModel := TMesh.CreateFromFile(GFXD.MainScene,AbsolutePath('\Models\HalfSphere.x'));
  end;
  if Sender = SceneWiredCubeRadio then
  begin
    CustomModel.Free;
    CustomModel := TMesh.CreateFromFile(GFXD.MainScene,AbsolutePath('\Models\WiredCube.x'));
  end;
  if Sender = SceneCustomModelRadio then
    if MeshOpenDialog.Execute then
    begin
      FreeAndNil(CustomModel);
      CustomModel := TMesh.CreateFromFile(GFXD.MainScene,MeshOpenDialog.FileName);
    end;
end;

procedure THauptform.DragAndDropWindowProc(var Msg : TMessage);
begin
  if Msg.Msg = WM_DROPFILES then
      DropFile(TWMDROPFILES(Msg))
  else
      FOriginalPanelWindowProc(Msg);
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
  FreeAndNil(CustomModel);
  CustomModel := TMesh.CreateFromFile(GFXD.MainScene, string(buffer));
  SceneCustomModelRadio.Checked := True;
end;

end.

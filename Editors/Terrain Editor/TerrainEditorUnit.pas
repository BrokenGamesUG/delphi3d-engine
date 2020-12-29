unit TerrainEditorUnit;

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
  Engine.Input,
  Engine.vertex,
  Engine.Gui,
  Engine.Mesh,
  Dialogs,
  Engine.Core,
  Engine.Core.Types,
  Engine.GfxApi,
  Engine.GfxApi.Types,
  ExtCtrls,
  Engine.Math,
  Engine.Helferlein,
  Engine.Helferlein.Windows,
  Engine.Helferlein.VCLUtils,
  Math,
  StdCtrls,
  Menus,
  Winapi.ShellApi,
  generics.Collections,
  Engine.Math.Collision3D,
  Engine.SkyBox,
  Engine.Terrain,
  Engine.Terrain.Editor,
  Engine.Water,
  Engine.Water.Editor,
  Engine.Vegetation,
  Engine.Vegetation.Editor,
  Engine.PostEffects,
  Engine.PostEffects.Editor,
  Vcl.ComCtrls,
  FileCtrl;

type

  THauptform = class(TForm)
    ApplicationEvents1 : TApplicationEvents;
    RenderPanel : TPanel;
    MainMenu1 : TMainMenu;
    Datei1 : TMenuItem;
    Exit1 : TMenuItem;
    Einstellungen1 : TMenuItem;
    Hintergrund1 : TMenuItem;
    Himmel1 : TMenuItem;
    Wei1 : TMenuItem;
    BenutzerdefinierteFarbe1 : TMenuItem;
    ColorDialog1 : TColorDialog;
    errain1 : TMenuItem;
    N1 : TMenuItem;
    New1 : TMenuItem;
    Open1 : TMenuItem;
    Save1 : TMenuItem;
    SaveAs1 : TMenuItem;
    NewfromGrayscale1 : TMenuItem;
    DeferredShading1 : TMenuItem;
    Water1 : TMenuItem;
    Vegetation1 : TMenuItem;
    LoadTestScene1 : TMenuItem;
    procedure FormCreate(Sender : TObject);
    procedure ApplicationEvents1Idle(Sender : TObject; var Done : Boolean);
    procedure FormClose(Sender : TObject; var Action : TCloseAction);
    procedure Exit1Click(Sender : TObject);
    procedure Wei1Click(Sender : TObject);
    procedure BenutzerdefinierteFarbe1Click(Sender : TObject);
    procedure errain1Click(Sender : TObject);
    procedure New1Click(Sender : TObject);
    procedure DeferredShading1Click(Sender : TObject);
    procedure Water1Click(Sender : TObject);
    procedure Vegetation1Click(Sender : TObject);
    procedure LoadTestScene1Click(Sender : TObject);
    private
      { Private-Deklarationen }
    public
      { Public-Deklarationen }
      originalPanelWindowProc : TWndMethod;
      procedure DragAndDropWindowProc(var Msg : TMessage);
      procedure DropFile(Msg : TWMDROPFILES);
  end;

var
  Hauptform : THauptform;
  Input : TInputDeviceManager;
  CamPos : RVector3;
  Alpha, Beta, r : single;
  SkyBox : TSky;
  Terrain : TTerrain;
  MausPos : RIntVector2;
  WaterManager : TWaterManager;
  PostEffects : TPostEffectManager;

implementation

{$R *.dfm}


procedure THauptform.FormCreate(Sender : TObject);
begin
  ReportMemoryLeaksOnShutdown := DebugHook <> 0;
  FormatSettings.DecimalSeparator := ',';
  Application.HintHidePause := 5000;
  Height := Screen.WorkAreaHeight;
  Width := Screen.Width;
  Top := 0;
  Left := 0;
  RenderPanel.Width := ClientWidth;

  GFXD := TGFXD.create(RenderPanel.Handle, false, RenderPanel.Width, RenderPanel.Height, true, false, EnumAntialiasingLevel.aaNone, 32, DirectX11Device);
  GFXD.Settings.DeferredShading := true;
  GFXD.MainScene.ShadowMapping.Resolution := 2048;
  GFXD.MainScene.ShadowMapping.Shadowbias := 1;
  Input := TInputDeviceManager.create(false, RenderPanel.Handle);
  LinePool := TLinePool.create();
  Mouse := Input.DirectInputFactory.ErzeugeTMouseDirectInput(false);
  Keyboard := Input.DirectInputFactory.ErzeugeTKeyboardDirectInput(false);
  GFXD.MainScene.Camera.PerspectiveCamera(RVector3.create(10, 10, 10), RVector3.ZERO);
  ContentManager.ObservationEnabled := true;

  PostEffects := TPostEffectManager.CreateFromFile(GFXD.MainScene, AbsolutePath('Defaults.fxs'));

  DragAcceptFiles(Self.Handle, true);
  Self.originalPanelWindowProc := Self.WindowProc;
  Self.WindowProc := DragAndDropWindowProc;

  r := 84.375;
  Alpha := -0.963;
  Beta := 0.825;

  New1Click(Self);
  SkyBox := TSkySphere.create(GFXD.MainScene);
  GFXD.MainScene.Backgroundcolor := $9CC8FE;

  WaterManager := TWaterManager.create();
  Vegetation := TVegetationManager.create(GFXD.MainScene);
end;

procedure THauptform.LoadTestScene1Click(Sender : TObject);
begin
  if FileExists(FormatDateiPfad('Test.ter')) then Terrain.LoadFromFile(FormatDateiPfad('Test.ter'));
  if FileExists(FormatDateiPfad('Test.veg')) then Vegetation.LoadFromFile(FormatDateiPfad('Test.veg'));
  if FileExists(FormatDateiPfad('Test.wat')) then WaterManager.LoadFromFile(FormatDateiPfad('Test.wat'));
end;

procedure THauptform.FormClose(Sender : TObject; var Action : TCloseAction);
begin
  PostEffects.Free;
  LinePool.Free;
  Vegetation.Free;
  WaterManager.Free;
  Terrain.Free;
  SkyBox.Free;
  GFXD.Free;
  Mouse.Free;
  Keyboard.Free;
  Input.Free;
end;

procedure THauptform.Vegetation1Click(Sender : TObject);
begin
  Terrain.HideDebugForm;
  WaterManager.HideEditor;
  Vegetation.ShowEditor(Terrain);
end;

procedure THauptform.Water1Click(Sender : TObject);
begin
  Terrain.HideDebugForm;
  Vegetation.HideEditor;
  WaterManager.ShowEditor;
end;

procedure THauptform.errain1Click(Sender : TObject);
begin
  WaterManager.HideEditor;
  Vegetation.HideEditor;
  Terrain.ShowDebugForm;
end;

procedure THauptform.Wei1Click(Sender : TObject);
begin
  GFXD.MainScene.Backgroundcolor := $00FFFFFF;
end;

procedure THauptform.New1Click(Sender : TObject);
begin
  MountedFile := '';
  Terrain.Free;
  Terrain := TTerrain.CreateEmpty(GFXD.MainScene, 512);
end;

procedure THauptform.ApplicationEvents1Idle(Sender : TObject;
  var Done : Boolean);
var
  tempMouse, diffMouse : RIntVector2;
  ClickRay : RRay;
  MouseState : EnumKeyState;
begin
  Caption := 'FPS:' + Inttostr(GFXD.FPS);
  TimeManager.TickTack;
  Input.DirectInputFactory.Idle;
  Mouse.Position := RIntVector2(RenderPanel.ScreenToClient(Vcl.Controls.Mouse.CursorPos));

  WaterManager.Idle;
  Vegetation.Idle;

  if MouseOverForm and active then
  begin
    if Keyboard.KeyUp(TasteEsc) then
    begin
      Close;
      exit;
    end;
    if Keyboard.KeyUp(TasteD) then GFXD.Settings.DeferredShading := not GFXD.Settings.DeferredShading;
    if Keyboard.KeyUp(TasteLeerTaste) then Vegetation1.Click;
    tempMouse := RIntVector2(RenderPanel.ScreenToClient(Vcl.Controls.Mouse.CursorPos));
    ClickRay := GFXD.MainScene.Camera.Clickvector(tempMouse.x, tempMouse.y);
    diffMouse := tempMouse - MausPos;
    if Mouse.ButtonIsDown(mbRight) and Mouse.IsDragging then
    begin
      Alpha := Alpha + (diffMouse.x) / 500.0;
      Beta := Beta - (diffMouse.y) / 500.0;
    end;

    Terrain.RenderBrush(ClickRay);
    if Mouse.ButtonDown(mbLeft) then MouseState := ksDown
    else if Mouse.ButtonUp(mbLeft) then MouseState := ksUp
    else if Mouse.ButtonIsDown(mbLeft) then MouseState := ksIsDown
    else MouseState := ksIsUp;
    if active then
    begin
      Terrain.Manipulate(ClickRay, (diffMouse.x <> 0) or (diffMouse.y <> 0), Keyboard.KeyIsDown(TasteSTRGLinks) or Keyboard.KeyIsDown(TasteSTRGRechts), MouseState, Mouse.ButtonUp(mbRight));
    end;

    MausPos := tempMouse;
    r := r * Power(3 / 4, Mouse.dZ);

    if Keyboard.KeyUp(TasteP) then PostEffects.ShowDebugForm;
  end;

  WaterManager.IdleEditor(MouseOverForm and active);
  Vegetation.IdleEditor(MouseOverForm and active);

  CamPos := Kugeldrehung(Alpha, Beta, 0, 0, 0, r);

  GFXD.MainScene.Camera.PerspectiveCamera(CamPos, RVector3.ZERO);
  SkyBox.Visible := Himmel1.Checked;
  LinePool.AddCoordinateSystem(GFXD.MainScene.Camera.Position + (GFXD.MainScene.Camera.Clickvector(RVector2.create(0.05, 0.95)).Direction * 2), 0.1);
  GFXD.RenderTheWholeUniverseMegaGameProzedureDingMussNochLängerWerdenDeswegenHierMüllZeugsBlubsKeks;

  Done := false;
end;

procedure THauptform.Exit1Click(Sender : TObject);
begin
  Close;
end;

procedure THauptform.BenutzerdefinierteFarbe1Click(Sender : TObject);
begin
  if ColorDialog1.Execute then
  begin
    GFXD.MainScene.Backgroundcolor.AsBGRCardinal := ColorDialog1.Color;
  end;
end;

procedure THauptform.DeferredShading1Click(Sender : TObject);
begin
  GFXD.Settings.DeferredShading := not GFXD.Settings.DeferredShading;
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
  filepath : string;
  i : integer;
begin
  numFiles := DragQueryFile(Msg.Drop, $FFFFFFFF, nil, 0);

  numFiles := DragQueryFile(TWMDROPFILES(Msg).Drop, $FFFFFFFF, buffer, MAX_PATH);

  for i := 0 to numFiles - 1 do
  begin
    if DragQueryFile(TWMDROPFILES(Msg).Drop, i, buffer, MAX_PATH) = 0 then exit;
    filepath := string(buffer);
    if ExtractFileExt(filepath) = '.ter' then Terrain.LoadFromFile(filepath);
    if ExtractFileExt(filepath) = '.obj' then Terrain.LoadFromOBJ(filepath);
  end;
end;

end.

unit GUIMain;

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
  ShellApi,
  Engine.Input,
  Engine.vertex,
  Engine.Log,
  Dialogs,
  Engine.Core,
  ExtCtrls,
  Engine.Math,
  Engine.Helferlein,
  Engine.Helferlein.Windows,
  Engine.Math.Collision3D,
  Math,
  StdCtrls,
  Menus,
  generics.Collections,
  Engine.Mesh,
  Engine.PostEffects,
  Engine.SkyBox,
  Vcl.ComCtrls,
  Engine.GUI,
  Engine.GfxApi.Types,
  Engine.Serializer,
  RTTI;

type

  THauptform = class(TForm)
    ApplicationEvents1 : TApplicationEvents;
    RenderPanel : TPanel;
    procedure FormCreate(Sender : TObject);
    procedure ApplicationEvents1Idle(Sender : TObject; var Done : Boolean);
    procedure FormClose(Sender : TObject; var Action : TCloseAction);
    procedure RenderPanelResize(Sender : TObject);
    private
      { Private-Deklarationen }
      FOriginalPanelWindowProc : TWndMethod;
      procedure DragAndDropWindowProc(var Msg : TMessage);
      procedure DropFile(Msg : TWMDROPFILES);
    public
      procedure Render;
      function MausInRenderpanel : Boolean;
      { Public-Deklarationen }
  end;

var
  Hauptform : THauptform;
  Input : TInputDeviceManager;
  DXMouse : TMouse;
  DXKeyboard : TKeyboard;
  CamPos : RVector3;
  Alpha, Beta, r : single;
  SkyBox : TSky;
  MausPos : RIntVector2;
  CameraMovement : Boolean;
  Meshes : TObjectList<TMesh>;
  GraphicsPath, Langpath : string;

implementation

{$R *.dfm}


procedure THauptform.FormCreate(Sender : TObject);
const
  MESH_GRID = 5;
var
  x, y : Integer;
  Mesh : TMesh;
begin
  DragAcceptFiles(Self.Handle, True);
  Self.FOriginalPanelWindowProc := Self.WindowProc;
  Self.WindowProc := DragAndDropWindowProc;

  ReportMemoryLeaksOnShutdown := DebugHook <> 0;
  FormatSettings.DecimalSeparator := '.';
  Application.HintHidePause := 5000;
  Height := Screen.WorkAreaHeight;
  Width := Screen.Width;
  Top := 0;
  Left := 0;
  RenderPanel.Width := ClientWidth;
  GFXD := TGFXD.create(RenderPanel.Handle, false, RenderPanel.Width, RenderPanel.Height, True, True, EnumAntialiasingLevel.aaNone, 32, DirectX11Device);
  Input := TInputDeviceManager.create(false, RenderPanel.Handle);
  LinePool := TLinePool.create();
  RHWLinePool := TRHWLinePool.create();
  DXMouse := Input.DirectInputFactory.ErzeugeTMouseDirectInput(false);
  DXKeyboard := Input.DirectInputFactory.ErzeugeTKeyboardDirectInput(false);
  GFXD.MainScene.Camera.PerspectiveCamera(RVector3.create(10, 10, 10), RVector3.ZERO);

  VertexEngine := TVertexEngine.create(GFXD.MainScene);
  ContentManager.ObservationEnabled := True;

  r := 150;
  Alpha := PI / 3;
  Beta := PI / 4;

  SkyBox := TSkySphere.create(GFXD.MainScene, false);
  GFXD.MainScene.Backgroundcolor := RColor.CPINK;
  Meshes := TObjectList<TMesh>.create;
  for x := -MESH_GRID to MESH_GRID do
    for y := -MESH_GRID to MESH_GRID do
    begin
      Mesh := TMesh.CreateFromFile(GFXD.MainScene, 'Cube.fbx');
      Mesh.Position := RVector3.create(x, 0, y) * 10;
      Meshes.Add(Mesh);
    end;
  GUI := TGUI.create(GFXD.MainScene);
  GUI.HintComponent := TGUIComponent.create(GUI, TGUIStyleSheet.CreateFromText('backgroundcolor:$80FFFFFF;visibility:false;size:200 100;'), 'Hint');
  TXMLSerializer.CacheXMLDocuments := false;
  GraphicsPath := HFileIO.ReadFromIni(FormatDateiPfad('GUIEditorSettings.ini'), 'General', 'Graphicspath');
  if GraphicsPath <> '' then
  begin
    GUI.AssetPath := GraphicsPath;
    GUI.StyleManager.LoadStylesFromFolder(GraphicsPath);
    HFilepathManager.ForEachFile(GraphicsPath + '/../Fonts/',
      procedure(const Filename : string)
      begin
        HSystem.RegisterFontFromFile(Filename);
      end, '*.ttf');
  end;
  Langpath := HFileIO.ReadFromIni(FormatDateiPfad('GUIEditorSettings.ini'), 'General', 'Langpath');
  if Langpath <> '' then
  begin
    HInternationalizer.LoadLangFiles(AbsolutePath(Langpath));
    HInternationalizer.ChooseLanguage('de');
  end;
  Engine.GUI.DefaultFontFamily := 'Arial';

  GUI.LoadFromFile('test.gui');
  if HFilepathManager.FileExists('test.scss') then GUI.StyleManager.LoadStylesFromFile('test.scss');
end;

procedure THauptform.FormClose(Sender : TObject; var Action : TCloseAction);
begin
  Meshes.Free;
  GUI.Free;
  DXKeyboard.Free;
  LinePool.Free;
  RHWLinePool.Free;
  SkyBox.Free;
  VertexEngine.Free;
  GFXD.Free;
  DXMouse.Free;
  Input.Free;
end;

procedure THauptform.Render;
begin
  GFXD.MainScene.Camera.PerspectiveCamera(CamPos, RVector3.ZERO);
  GFXD.RenderTheWholeUniverseMegaGameProzedureDingMussNochLängerWerdenDeswegenHierMüllZeugsBlubsKeks;
end;

procedure THauptform.RenderPanelResize(Sender : TObject);
begin
  if assigned(GFXD) then GFXD.ChangeResolution(RIntVector2.create(RenderPanel.Width, RenderPanel.Height));
end;

function THauptform.MausInRenderpanel : Boolean;
var
  Pointi : TPoint;
begin
  Pointi := ScreenToClient(Vcl.Controls.Mouse.CursorPos);
  Result := ((RenderPanel.Left <= Pointi.x) and (RenderPanel.Left + RenderPanel.Width >= Pointi.x)) and ((RenderPanel.Top <= Pointi.y) and (RenderPanel.Top + RenderPanel.Height >= Pointi.y));
end;

procedure THauptform.ApplicationEvents1Idle(Sender : TObject;
var Done : Boolean);
var
  tempMouse, diffMouse : RIntVector2;
  ClickRay : RRay;
  i : Integer;
  Used : Boolean;
begin
  Caption := 'FPS:' + Inttostr(GFXD.FPS);
  TimeManager.TickTack;
  Input.DirectInputFactory.Idle;

  if MausInRenderpanel and Active then
  begin
    DXMouse.Position := RIntVector2(RenderPanel.ScreenToClient(Vcl.Controls.Mouse.CursorPos));
    tempMouse := RIntVector2(RenderPanel.ScreenToClient(Vcl.Controls.Mouse.CursorPos));
    ClickRay := GFXD.MainScene.Camera.Clickvector(tempMouse.x, tempMouse.y);
    diffMouse := tempMouse - MausPos;
    if DXMouse.ButtonIsDown(mbRight) then
    begin
      Alpha := Alpha + (diffMouse.x) / 500.0;
      Beta := Beta - (diffMouse.y) / 500.0;
      CameraMovement := CameraMovement or (diffMouse.x <> 0) or (diffMouse.y <> 0);
    end;
    MausPos := tempMouse;
    GUI.HandleMouse(DXMouse);

    Used := false;
    for i := 0 to DXKeyboard.DataFromLastFrame.Count - 1 do
    begin
      if DXKeyboard.DataFromLastFrame[i].Value then Used := GUI.KeyboardUp(DXKeyboard.DataFromLastFrame[i].Key) or Used
      else Used := GUI.KeyboardDown(DXKeyboard.DataFromLastFrame[i].Key) or Used;
    end;

    if DXMouse.dZ < 0 then r := r * 4 / 3;
    if DXMouse.dZ > 0 then r := r * 3 / 4;

    if DXKeyboard.KeyUp(TasteEsc) then
    begin
      Close;
      exit;
    end;
  end;
  CamPos := Kugeldrehung(Alpha, Beta, 0, 0, 0, r);
  GUI.Idle;
  Render;
  Done := false;
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
  FilePath : string;
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
  FilePath := string(buffer);
  GUI.LoadFromFile(FilePath);
end;

end.

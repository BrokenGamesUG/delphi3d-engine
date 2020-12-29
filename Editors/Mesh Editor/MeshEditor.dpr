program MeshEditor;

{$R 'Shader.res' '..\..\Engine\Shader\Shader.rc'}

uses
  Forms,
  MeshEditorUnit in 'MeshEditorUnit.pas' {Hauptform},
  Engine.Mesh in '..\..\Engine\Engine.Mesh.pas',
  Engine.AssetLoader.AssimpLoader in '..\..\Engine\Engine.AssetLoader.AssimpLoader.pas',
  Engine.AssetLoader.MeshAsset in '..\..\Engine\Engine.AssetLoader.MeshAsset.pas',
  Engine.AssetLoader in '..\..\Engine\Engine.AssetLoader.pas',
  Engine.AssetLoader.XFileLoader in '..\..\Engine\Engine.AssetLoader.XFileLoader.pas',
  Engine.Animation in '..\..\Engine\Engine.Animation.pas',
  Engine.Math in '..\..\Engine\Engine.Math.pas',
  Engine.DX9Api in '..\..\Engine\Engine.DX9Api.pas',
  Engine.DX11Api in '..\..\Engine\Engine.DX11Api.pas',
  assimpheader in '..\..\Engine\assimp\assimpheader.pas',
  Engine.AssetLoader.FBXLoader in '..\..\Engine\Engine.AssetLoader.FBXLoader.pas',
  Engine.Core.Types in '..\..\Engine\Engine.Core.Types.pas',
  D3DCompiler_JSB in '..\..\Engine\FixedDX11Header\D3DCompiler_JSB.pas',
  Winapi.D3D11 in '..\..\Engine\FixedDX11Header\Winapi.D3D11.pas',
  D3DX11_JSB in '..\..\Engine\FixedDX11Header\D3DX11_JSB.pas',
  Engine.PostEffects.Editor in '..\..\Engine\Engine.PostEffects.Editor.pas',
  Engine.PostEffects in '..\..\Engine\Engine.PostEffects.pas',
  Engine.Core.Camera in '..\..\Engine\Engine.Core.Camera.pas',
  Engine.Core.Lights in '..\..\Engine\Engine.Core.Lights.pas',
  Engine.Core in '..\..\Engine\Engine.Core.pas',
  Engine.GfxApi.Classmapper in '..\..\Engine\Engine.GfxApi.Classmapper.pas',
  Engine.GfxApi in '..\..\Engine\Engine.GfxApi.pas',
  Engine.GfxApi.Types in '..\..\Engine\Engine.GfxApi.Types.pas',
  Engine.Math.Collision2D in '..\..\Engine\Engine.Math.Collision2D.pas',
  Engine.Math.Collision3D in '..\..\Engine\Engine.Math.Collision3D.pas',
  Engine.Helferlein.DataStructures.Helper in '..\..\Engine\Engine.Helferlein.DataStructures.Helper.pas',
  Engine.Helferlein.DataStructures in '..\..\Engine\Engine.Helferlein.DataStructures.pas',
  Engine.Helferlein in '..\..\Engine\Engine.Helferlein.pas',
  Engine.Helferlein.Windows in '..\..\Engine\Engine.Helferlein.Windows.pas',
  Engine.Mesh.Editor in '..\..\Engine\Engine.Mesh.Editor.pas' {MeshEditorForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(THauptform, Hauptform);
  Application.Run;
end.

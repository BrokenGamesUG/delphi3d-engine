program TerrainEditor;

{$R 'Shader.res' '..\..\Engine\Shader\Shader.rc'}

uses
  Forms,
  Engine.Terrain.Editor in '..\..\Engine\Engine.Terrain.Editor.pas' {TerrainDebugForm},
  Engine.Terrain in '..\..\Engine\Engine.Terrain.pas',
  TerrainEditorUnit in 'TerrainEditorUnit.pas',
  Engine.Helferlein.VCLUtils in '..\..\Engine\Engine.Helferlein.VCLUtils.pas',
  Engine.Water.Editor in '..\..\Engine\Engine.Water.Editor.pas',
  Engine.Water in '..\..\Engine\Engine.Water.pas',
  Engine.Vegetation in '..\..\Engine\Engine.Vegetation.pas',
  Engine.Vegetation.Editor in '..\..\Engine\Engine.Vegetation.Editor.pas',
  Engine.Serializer in '..\..\Engine\Engine.Serializer.pas',
  Engine.GfxApi in '..\..\Engine\Engine.GfxApi.pas',
  Engine.Core in '..\..\Engine\Engine.Core.pas',
  Engine.DX9Api in '..\..\Engine\Engine.DX9Api.pas',
  Engine.Helferlein in '..\..\Engine\Engine.Helferlein.pas',
  Engine.DX11Api in '..\..\Engine\Engine.DX11Api.pas',
  Engine.Mesh in '..\..\Engine\Engine.Mesh.pas',
  Engine.Core.Types in '..\..\Engine\Engine.Core.Types.pas',
  Engine.PostEffects in '..\..\Engine\Engine.PostEffects.pas';

{$R *.res}


begin
  Application.Initialize;
  Application.CreateForm(THauptform, Hauptform);
  Application.Run;

end.

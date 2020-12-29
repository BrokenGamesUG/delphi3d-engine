program GUI;

{$R 'Shader.res' '..\..\Engine\Shader\Shader.rc'}

uses
  Forms,
  GUIMain in 'GUIMain.pas' {Hauptform},
  Engine.GUI in '..\..\Engine\Engine.GUI.pas',
  Engine.GUI.Editor in '..\..\Engine\Engine.GUI.Editor.pas',
  Engine.DX9Api in '..\..\Engine\Engine.DX9Api.pas',
  Engine.DX11Api in '..\..\Engine\Engine.DX11Api.pas',
  Engine.GfxApi in '..\..\Engine\Engine.GfxApi.pas',
  Engine.Core in '..\..\Engine\Engine.Core.pas',
  Engine.Core.Types in '..\..\Engine\Engine.Core.Types.pas',
  Engine.PostEffects in '..\..\Engine\Engine.PostEffects.pas',
  Engine.Vertex in '..\..\Engine\Engine.Vertex.pas',
  Engine.SkyBox in '..\..\Engine\Engine.SkyBox.pas',
  Engine.Mesh in '..\..\Engine\Engine.Mesh.pas',
  Engine.Helferlein in '..\..\Engine\Engine.Helferlein.pas',
  Engine.Serializer in '..\..\Engine\Engine.Serializer.pas',
  Engine.Math in '..\..\Engine\Engine.Math.pas',
  Engine.Input in '..\..\Engine\Engine.Input.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(THauptform, Hauptform);
  Application.Run;
end.

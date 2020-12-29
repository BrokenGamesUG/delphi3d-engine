program ParticleEffectEditor;

{$R 'Shader.res' '..\..\Engine\Shader\Shader.rc'}

uses
  Forms,
  PFXMain in 'PFXMain.pas'{Hauptform},
  Engine.Core in '..\..\Engine\Engine.Core.pas',
  Engine.ParticleEffects.Particles in '..\..\Engine\Engine.ParticleEffects.Particles.pas',
  Engine.ParticleEffects.Simulators in '..\..\Engine\Engine.ParticleEffects.Simulators.pas',
  Engine.ParticleEffects.Emitters in '..\..\Engine\Engine.ParticleEffects.Emitters.pas',
  Engine.ParticleEffects.Types in '..\..\Engine\Engine.ParticleEffects.Types.pas',
  Engine.ParticleEffects.Renderer in '..\..\Engine\Engine.ParticleEffects.Renderer.pas',
  Engine.Helferlein in '..\..\Engine\Engine.Helferlein.pas',
  Engine.Helferlein.VCLUtils in '..\..\Engine\Engine.Helferlein.VCLUtils.pas',
  Engine.ParticleEffects in '..\..\Engine\Engine.ParticleEffects.pas',
  Engine.Vertex in '..\..\Engine\Engine.Vertex.pas',
  Engine.Core.Types in '..\..\Engine\Engine.Core.Types.pas',
  Engine.DX11Api in '..\..\Engine\Engine.DX11Api.pas',
  Engine.GfxApi in '..\..\Engine\Engine.GfxApi.pas',
  Engine.GfxApi.Types in '..\..\Engine\Engine.GfxApi.Types.pas',
  Engine.Helferlein.Windows in '..\..\Engine\Engine.Helferlein.Windows.pas';

{$R *.res}


begin
  Application.Initialize;
  Application.CreateForm(THauptform, Hauptform);
  Application.Run;

end.

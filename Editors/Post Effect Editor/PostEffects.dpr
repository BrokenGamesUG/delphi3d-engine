program PostEffects;

{$R 'Shader.res' '..\..\Engine\Shader\Shader.rc'}

uses
  Forms,
  PostEffectsMain in 'PostEffectsMain.pas'{Hauptform},
  Engine.PostEffects.Editor in '..\..\Engine\Engine.PostEffects.Editor.pas',
  Engine.PostEffects in '..\..\Engine\Engine.PostEffects.pas',
  Engine.Core in '..\..\Engine\Engine.Core.pas',
  Engine.Core.Types in '..\..\Engine\Engine.Core.Types.pas',
  Engine.DX11Api in '..\..\Engine\Engine.DX11Api.pas';

{$R *.res}


begin
  Application.Initialize;
  Application.CreateForm(THauptform, Hauptform);
  Application.Run;

end.

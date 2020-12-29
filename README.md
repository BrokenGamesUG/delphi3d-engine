# Delphi3D-Engine
A 3D-graphic and game engine for Delphi and Windows. It was used to develop the game [Rise of Legions](https://riseoflegions.com).

# Usage
## Engine
Either copy all files in your project or the way we usually link to it: Add the Engine directory and all subdirectory to your search path in Delphi (must be configured for each target 32-bit and 64-bit). The engine is tested (in Rise of Legions) to work with 32-bit using the graphic components (client) and 64-bit working without any graphic (server).

## Editors
The editors in this repository should be working and give you hints about the engine usage and can be used to create and configure effects. (tested in Delphi 10.1 Berlin)

# Warning
To be honest this engine has lots of neat functionality, but is not easy to use. This project was developed by my friend an my since our studies for many years. There is a lot of features, but no real documentation (except sometimes more sometimes less code comments) and surely a lot of bugs if anyone new to the engine will use it. I would advice to use this engine with care and have a look at the source code of Rise of Legions or the editors for some hints about the usage of some modules.

# Features

* Graphics
  * DirectX 11 graphic adapter
  * Camera
  * Forward and Deferred Lighting
  * Mesh + Skinned Mesh Animation + Morph Animation + FBX support
  * dXML - Dynamic UI system based on HTML+CSS+Vuejs style
  * Particle Effects
  * Post Effects
  * Dynamic shader creation with django like block system
  * Terrain Rendering
  * Vegetation Rendering
  * Water Rendering
  * Dynamic custom vertex rendering
* Component-driven Eventsystem
* Input handling for mouse and keyboard (also multiple mice support with RAW input)
* Network
* Scripting adapter for DWScript
* Automatic serialization with attributes
* Sound system (adapter for FMOD and OpenAL)
* DataQuery - LinQ similar query language
* Math
  * Vector and Matrix arithmetic
  * 3D and 2D Collision arithmetic
  * Pathfinding
* Tons of helpers
* Partially translated headers for Steam API and FMOD
  
## Workarounds

The DirectX SDK throws a lot of warnings which are printed by Delphi in the editor output. This printing consumes a lot of performance, e.g. the editors seems to run slowly when this happens. To work around this you can use the dxcpl.exe for the DirectX SDK to mute the warning showing up.

The engine has been tested to work with Delphi 10.1 Berlin, but the DirectX-Headers contains some bugs, which has been fixed by us. Ensure to include the directory FixedDX11Header in your project, so the correct files are used. In newer Delphi versions some of the bugs might be fixed, rendering our patches obsolete.

## License

[![License: MPL 2.0](https://img.shields.io/badge/License-MPL%202.0-brightgreen.svg)](https://opensource.org/licenses/MPL-2.0)

The code base is distributed under MPL 2.0

It make use of other Open-Source-Software stated below:

[assimp](https://github.com/assimp/assimp) - Modified, 3-clause BSD-License - Used for importing model files like FBX.

[DWScript](https://www.delphitools.info/dwscript/) - MPL 1.1 - Used as scripting language.

[Imaging](https://github.com/galfar/imaginglib) - MPL - Used for importing texture of complex formats.

[Jedi-WinApi](https://sourceforge.net/projects/jedi-apilib/) - MPL 1.1 - Used for various windows functions.

[LockBox](https://github.com/TurboPack/LockBox) - MPL 1.1 - Used for hashing.

[VerySimpleXML](https://github.com/Dennis1000/verysimplexml) - MPL 1.1 - Used for XML parsing.

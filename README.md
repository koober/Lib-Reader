# Lib Reader

Auto-generated snapshot of three.js ShaderLib.
Intended to help read, understand, copy/paste chunks etc.

[View](https://koober.github.io/Lib-Reader/).

Using Perl built in to Git bash for Windows, it generates html derived from the ShaderLib folder, and reads uniforms from ShaderLib.js, including any of your custom shaders. Naming conventions should be adhered to.
Rename a mesh_vert and mesh_frag file of your choice, but in the same format; e.g. meshmylambert_vert.glsl and meshmylambert_frag.glsl.
 If you want to copy ShaderLib to a new location,  edit lr.pl path.
For default usage, save LibReader folder next to your local threejs folder, and run lr.pl from within LibReader.

|
|__LibReader
|
|__threejs88
|__threejs94

All html files will be updated, including any customized files.

Tested on Windows 8 /10 with Git-bash and on Linux with bash.

Open git bash for windows from the LibReader folder and type

    perl lr.pl
    
A 'temp' folder should appear and the html files overwritten with new files describing the contents of 

    threejs89/src/renderers/shaders/
    
including any of your custom shaders.


#ShaderLib Reader

Auto-generated snapshot of three.js ShaderLib.
Intended to help read, understand, copy/paste chunks etc.

[View R97](https://koober.github.io/Lib-Reader/r97)


[View R94](https://koober.github.io/Lib-Reader/r94)


[View R87](https://koober.github.io/Lib-Reader/r87)



Using Perl built in to Git bash for Windows, it generates html derived from the ShaderLib folder, and reads uniforms from ShaderLib.js, including any of your custom shaders. Naming conventions should be adhered to.
Rename a mesh_vert and mesh_frag file of your choice, but in the same format; e.g. meshmylambert_vert.glsl and meshmylambert_frag.glsl.
 If you want to copy ShaderLib to a new location,  edit lr.pl path.
For default usage, save LibReader folder next to your local threejs folder, and run lr.pl from within LibReader.

|
|__LibReader
|
|__threejs87
|__threejs97

All html files will be updated, including any customized files.

Open bash from the LibReader folder and type

    perl lr.pl
    
A 'rXX' folder should appear and the html files overwritten with new files describing the contents of 

    threejs97/src/renderers/shaders/
    
including any of your custom shaders.


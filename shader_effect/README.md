# Shader Effect

**注意**

**最後一次構建：2014年1月20日下午18:00。**

**這章的源代碼能夠在[assetts folder](http://qmlbook.org/assets)找到。**

* http://labs.qt.nokia.com/2012/02/02/qt-graphical-effects-in-qt-labs/

* http://labs.qt.nokia.com/2011/05/03/qml-shadereffectitem-on-qgraphicsview/

* http://qt-project.org/doc/qt-4.8/declarative-shadereffects.html

* http://www.opengl.org/registry/doc/GLSLangSpec.4.20.6.clean.pdf

* http://www.khronos.org/registry/gles/specs/2.0/GLSL_ES_Specification_1.0.17.pdf

* http://www.lighthouse3d.com/opengl/glsl/

* http://wiki.delphigl.com/index.php/Tutorial_glsl

* [Qt5Doc qtquick-shaders](http://doc.qt.nokia.com/5.0-snapshot/qtquick-shaders.html)

著色器允許我們利用SceneGraph的接口直接調用在強大的GPU上運行的OpenGL來創建渲染效果。著色器使用ShaderEffect與ShaderEffectSource元素來實現。著色器本身的算法使用OpenGL Shading Language（OpenGL著色語言）來實現。

實際上這意味著你需要混合使用QML代碼與著色器代碼。執行時，會將著色器代碼發送到GPU，並在GPU上編譯執行。QML著色器元素（Shader QML Elements）允許你與OpenGL著色器程序的屬性交互。

讓我們首先來看看OpenGL著色器。

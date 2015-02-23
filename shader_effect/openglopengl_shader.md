# OpenGL著色器（OpenGL Shader）

OpenGL的渲染管線分為幾個步驟。一個簡單的OpenGL渲染管線將包含一個頂點著色器和一個片段著色器。

![](http://qmlbook.org/_images/openglpipeline.png)

頂點著色器接收頂點數據，並且在程序最後賦值給gl_Position。然後，頂點將會被裁剪，轉換和柵格化後作為像素輸出。
片段（像素）進入片段著色器，進一步對片段操作並將結果的顏色賦值給gl_FragColor。頂點著色器調用多邊形每個角的點（頂點=3D中的點），負責這些點的3D處理。片段（片度=像素）著色器調用每個像素並決定這個像素的顏色。

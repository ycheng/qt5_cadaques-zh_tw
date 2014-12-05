# 著色器元素（Shader Elements）

為了對著色器編程，Qt Quick提供了兩個元素。ShaderEffectSource與ShaderEffect。ShaderEffect將會使用自定義的著色器，ShaderEffectSource可以將一個QML元素渲染為一個紋理然後再渲染這個紋理。由于ShaderEffect能夠應用自定義的著色器到它的矩形幾何形狀，並且能夠使用在著色器中操作資源。一個資源可以是一個圖片，它被作為一個紋理或者著色器資源。

默認下著色器使用這個資源並且不作任何改變進行渲染。

```
import QtQuick 2.0

Rectangle {
    width: 480; height: 240
    color: '#1e1e1e'

    Row {
        anchors.centerIn: parent
        spacing: 20
        Image {
            id: sourceImage
            width: 80; height: width
            source: 'assets/tulips.jpg'
        }
        ShaderEffect {
            id: effect
            width: 80; height: width
            property variant source: sourceImage
        }
        ShaderEffect {
            id: effect2
            width: 80; height: width
            // the source where the effect shall be applied to
            property variant source: sourceImage
            // default vertex shader code
            vertexShader: "
                uniform highp mat4 qt_Matrix;
                attribute highp vec4 qt_Vertex;
                attribute highp vec2 qt_MultiTexCoord0;
                varying highp vec2 qt_TexCoord0;
                void main() {
                    qt_TexCoord0 = qt_MultiTexCoord0;
                    gl_Position = qt_Matrix * qt_Vertex;
                }"
            // default fragment shader code
            fragmentShader: "
                varying highp vec2 qt_TexCoord0;
                uniform sampler2D source;
                uniform lowp float qt_Opacity;
                void main() {
                    gl_FragColor = texture2D(source, qt_TexCoord0) * qt_Opacity;
                }"
        }
    }
}
```

![](http://qmlbook.org/_images/defaultshader.png)

在上邊這個例子中，我們在一行中顯示了3張圖片，第一張是原始圖片，第二張使用默認的著色器渲染出來的圖片，第三張使用了Qt5源碼中默認的頂點與片段著色器的代碼進行渲染的圖片。

**注意**

**如果你不想看到原始圖片，而只想看到被著色器渲染後的圖片，你可以設置Image為不可見（visible:false）。著色器仍然會使用圖片數據，但是圖像元素（Image Element）將不會被渲染。**

讓我們仔細看看著色器代碼。

```
vertexShader: "
    uniform highp mat4 qt_Matrix;
    attribute highp vec4 qt_Vertex;
    attribute highp vec2 qt_MultiTexCoord0;
    varying highp vec2 qt_TexCoord0;
    void main() {
        qt_TexCoord0 = qt_MultiTexCoord0;
        gl_Position = qt_Matrix * qt_Vertex;
    }"
```

著色器代碼來自Qt這邊的一個字符串，綁定了頂點著色器（vertexShader）與片段著色器（fragmentShader）屬性。每個著色器代碼必須有一個main(){....}函數，它將被GPU執行。Qt已經默認提供了以qt_開頭的變量。

下面是這些變量簡短的介紹：

* uniform-在處理過程中不能夠改變的值。

* attribute-連接外部數據

* varying-著色器之間的共享數據

* highp-高精度值

* lowp-低精度值

* mat4-4x4浮點數（float）矩陣

* vec2-包含兩個浮點數的向量

* sampler2D-2D紋理

* float-浮點數

可以查看[OpenGL ES 2.0 API Quick Reference Card](http://www.khronos.org/opengles/sdk/docs/reference_cards/OpenGL-ES-2_0-Reference-card.pdf)獲得更多信息。

現在我們可以更好的理解下面這些變量：

* qt_Matrix：model-view-projection（模型-視圖-投影）矩陣

* qt_Vertex：當前頂點坐標

* qt_MultiTexCoord0：紋理坐標

* qt_TexCoord0：共享紋理坐標

我們已經有可以使用的投影矩陣（projection matrix），當前頂點與紋理坐標。紋理坐標與作為資源（source）的紋理相關。在main()函數中，我們保存紋理坐標，留在後面的片段著色器中使用。每個頂點著色器都需要賦值給gl_Postion，在這裡使用項目矩陣乘以頂點，得到我們3D坐標系中的點。

片段著色器從頂點著色器中接收我們的紋理坐標，這個紋理仍然來自我們的QML資源屬性（source property）。在著色器代碼與QML之間傳遞變量是如此的簡單。此外我們的透明值，在著色器中也可以使用，變量是qt_Opacity。每
個片段著色器需要給gl_FragColor變量賦值，在這裡默認著色器代碼使用資源紋理（source texture）的像素顏色與透明值相乘。

```
fragmentShader: "
    varying highp vec2 qt_TexCoord0;
    uniform sampler2D source;
    uniform lowp float qt_Opacity;
    void main() {
        gl_FragColor = texture2D(source, qt_TexCoord0) * qt_Opacity;
    }"
```

在後面的例子中，我們將會展示一些簡單的著色器例子。首先我們會集中在片段著色器上，然後在回到頂點著色器上。

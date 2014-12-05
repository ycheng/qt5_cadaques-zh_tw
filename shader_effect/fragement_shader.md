# 片段著色器（Fragement Shader）

片段著色器調用每個需要渲染的像素。我們將開發一個紅色透鏡，它將會增加圖片的紅色通道的值。

**配置場景（Setting up the scene）**

首先我們配置我們的場景，在區域中央使用一個網格顯示我們的源圖片（source image）。

```
import QtQuick 2.0

Rectangle {
    width: 480; height: 240
    color: '#1e1e1e'

    Grid {
        anchors.centerIn: parent
        spacing: 20
        rows: 2; columns: 4
        Image {
            id: sourceImage
            width: 80; height: width
            source: 'assets/tulips.jpg'
        }
    }
}
```

![](http://qmlbook.org/_images/redlense1.png)

**紅色著色器（A red Shader）**

下一步我們添加一個著色器，顯示一個紅色矩形框。由于我們不需要紋理，我們從頂點著色器中移除紋理。

```
            vertexShader: "
                uniform highp mat4 qt_Matrix;
                attribute highp vec4 qt_Vertex;
                void main() {
                    gl_Position = qt_Matrix * qt_Vertex;
                }"
            fragmentShader: "
                uniform lowp float qt_Opacity;
                void main() {
                    gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0) * qt_Opacity;
                }"
```

在片段著色器中，我們簡單的給gl_FragColor賦值為vec4(1.0, 0.0, 0.0, 1.0)，它代表紅色， 並且不透明（alpha=1.0）。

![](http://qmlbook.org/_images/redlense2.png)

**使用紋理的紅色著色器（A red shader with texture）**

現在我們想要將這個紅色應用在紋理的每個像素上。我們需要將紋理加回頂點著色器。由于我們不再在頂點著色器中做任何其它的事情，所以默認的頂點著色器已經滿足我們的要求。

```
        ShaderEffect {
            id: effect2
            width: 80; height: width
            property variant source: sourceImage
            visible: root.step>1
            fragmentShader: "
                varying highp vec2 qt_TexCoord0;
                uniform sampler2D source;
                uniform lowp float qt_Opacity;
                void main() {
                    gl_FragColor = texture2D(source, qt_TexCoord0) * vec4(1.0, 0.0, 0.0, 1.0) * qt_Opacity;
                }"
        }
```

完整的著色器重新包含我們的源圖片作為屬性，由于我們沒有特殊指定，使用默認的頂點著色器，我沒有重寫頂點著色器。

在片段著色器中，我們提取紋理片段texture2D(source,qt_TexCoord0)，並且與紅色一起應用。

![](http://qmlbook.org/_images/redlense3.png)

**紅色通道屬性（The red channel property）**

這樣的代碼用來修改紅色通道的值看起來不是很好，所以我們想要將這個值包含在QML這邊。我們在ShaderEffect中增加一個redChannel屬性，並在我們的片段著色器中申明一個uniform lowpfloat redChannel。這就是從一個著色器代碼中標記一個值到QML這邊的方法，非常簡單。

```
        ShaderEffect {
            id: effect3
            width: 80; height: width
            property variant source: sourceImage
            property real redChannel: 0.3
            visible: root.step>2
            fragmentShader: "
                varying highp vec2 qt_TexCoord0;
                uniform sampler2D source;
                uniform lowp float qt_Opacity;
                uniform lowp float redChannel;
                void main() {
                    gl_FragColor = texture2D(source, qt_TexCoord0) * vec4(redChannel, 1.0, 1.0, 1.0) * qt_Opacity;
                }"
        }
```

為了讓這個透鏡更真實，我們改變vec4顏色為vec4(redChannel, 1.0, 1.0, 1.0)，這樣其它顏色與1.0相乘，只有紅色部分使用我們的redChannel變量。

![](http://qmlbook.org/_images/redlense4.png)

**紅色通道的動畫（The red channel animated**）

由于redChannel屬性僅僅是一個正常的屬性，我們也可以像其它QML中的屬性一樣使用動畫。我們使用QML屬性在GPU上改變這個值，來影響我們的著色器，這真酷！

```
        ShaderEffect {
            id: effect4
            width: 80; height: width
            property variant source: sourceImage
            property real redChannel: 0.3
            visible: root.step>3
            NumberAnimation on redChannel {
                from: 0.0; to: 1.0; loops: Animation.Infinite; duration: 4000
            }

            fragmentShader: "
                varying highp vec2 qt_TexCoord0;
                uniform sampler2D source;
                uniform lowp float qt_Opacity;
                uniform lowp float redChannel;
                void main() {
                    gl_FragColor = texture2D(source, qt_TexCoord0) * vec4(redChannel, 1.0, 1.0, 1.0) * qt_Opacity;
                }"
        }
```

下面是最後的結果。

![](http://qmlbook.org/_images/redlense5.png)

在這4秒內，第二排的著色器紅色通道的值從0.0到1.0。圖片從沒有紅色信息（0.0 red）到一個正常的圖片（1.0 red）。

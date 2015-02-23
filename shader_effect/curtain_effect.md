# 劇幕效果（Curtain Effect）

在最後的自定義效果例子中，我們將帶來一個劇幕效果。這個效果是2011年5月Qt實驗室發布的著色器效果中的一部分。目前網址已經轉到blog.qt.digia.com，不知道還能不能找到。

![](http://qmlbook.org/_images/curtain.png)

當時我非常喜歡這些效果，劇幕效果是我最喜愛的一個。我喜歡劇幕打開然後遮擋後面的背景對象。

我將代碼移植適配到Qt5上，這非常簡單。同時我做了一些簡化讓它能夠更好的展示。如果你對整個例子有興趣，可以訪問Qt實驗室的博客。

只有一個小組件作為背景，劇幕實際上是一張圖片，叫做fabric.jpg，它是ShaderEffect的資源。整個效果使用頂點著色器來擺動劇幕，使用片段著色器提供陰影的效果。下面是一個簡單的圖片，讓你更加容易理解代碼。

![](http://qmlbook.org/_images/curtain_diagram.png)

劇幕的波形陰影通過一個在劇幕寬度上的sin曲線使用7的振幅來計算（7*PI=221.99..）另一個重要的部分是擺動，當劇幕打開或者關閉時，使用動畫來播放劇幕的topWidth。bottomWidth使用SpringAnimation來跟隨topWidth變化。這樣我們就能創建出底部擺動的劇幕效果。計算得到的swing提供了搖擺的強度，用來對頂點的y值進行插值。

劇幕效果放在CurtainEffect.qml組件中，fabric圖像作為紋理資源。在陰影的使用上沒有新的東西加入，唯一不同的是在頂點著色器中操作gl_Postion和片段著色器中操作gl_FragColor。

```
import QtQuick 2.0

ShaderEffect {
    anchors.fill: parent

    mesh: GridMesh {
        resolution: Qt.size(50, 50)
    }

    property real topWidth: open?width:20
    property real bottomWidth: topWidth
    property real amplitude: 0.1
    property bool open: false
    property variant source: effectSource

    Behavior on bottomWidth {
        SpringAnimation {
            easing.type: Easing.OutElastic;
            velocity: 250; mass: 1.5;
            spring: 0.5; damping: 0.05
        }
    }

    Behavior on topWidth {
        NumberAnimation { duration: 1000 }
    }


    ShaderEffectSource {
        id: effectSource
        sourceItem: effectImage;
        hideSource: true
    }

    Image {
        id: effectImage
        anchors.fill: parent
        source: "assets/fabric.jpg"
        fillMode: Image.Tile
    }

    vertexShader: "
        attribute highp vec4 qt_Vertex;
        attribute highp vec2 qt_MultiTexCoord0;
        uniform highp mat4 qt_Matrix;
        varying highp vec2 qt_TexCoord0;
        varying lowp float shade;

        uniform highp float topWidth;
        uniform highp float bottomWidth;
        uniform highp float width;
        uniform highp float height;
        uniform highp float amplitude;

        void main() {
            qt_TexCoord0 = qt_MultiTexCoord0;

            highp vec4 shift = vec4(0.0, 0.0, 0.0, 0.0);
            highp float swing = (topWidth - bottomWidth) * (qt_Vertex.y / height);
            shift.x = qt_Vertex.x * (width - topWidth + swing) / width;

            shade = sin(21.9911486 * qt_Vertex.x / width);
            shift.y = amplitude * (width - topWidth + swing) * shade;

            gl_Position = qt_Matrix * (qt_Vertex - shift);

            shade = 0.2 * (2.0 - shade ) * ((width - topWidth + swing) / width);
        }"

    fragmentShader: "
        uniform sampler2D source;
        varying highp vec2 qt_TexCoord0;
        varying lowp float shade;
        void main() {
            highp vec4 color = texture2D(source, qt_TexCoord0);
            color.rgb *= 1.0 - shade;
            gl_FragColor = color;
        }"
}
```

這個效果在curtaindemo.qml文件中使用。

```
import QtQuick 2.0

Rectangle {
    id: root
    width: 480; height: 240
    color: '#1e1e1e'

    Image {
        anchors.centerIn: parent
        source: 'assets/wiesn.jpg'
    }

    CurtainEffect {
        id: curtain
        anchors.fill: parent
    }

    MouseArea {
        anchors.fill: parent
        onClicked: curtain.open = !curtain.open
    }
}
```

劇幕效果通過自定義的open屬性打開。我們使用了一個MouseArea來觸發打開和關閉劇幕。

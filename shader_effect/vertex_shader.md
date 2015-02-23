# 頂點著色器（Vertex Shader）

頂點著色器用來操作ShaderEffect提供的頂點。正常情況下，ShaderEffect有4個頂點（左上top-left，右上top-right，左下bottom-left，右下bottom-right）。每個頂點使用vec4類型記錄。為了實現頂點著色器的可視化，我們將編寫一個吸收的效果。這個效果通常被用來讓一個矩形窗口消失為一個點。

![](http://qmlbook.org/_images/genieeffect.png)

**配置場景（Setting up the scene）**

首先我們再一次配置場景。

```
import QtQuick 2.0

Rectangle {
    width: 480; height: 240
    color: '#1e1e1e'

    Image {
        id: sourceImage
        width: 160; height: width
        source: "assets/lighthouse.jpg"
        visible: false
    }
    Rectangle {
        width: 160; height: width
        anchors.centerIn: parent
        color: '#333333'
    }
    ShaderEffect {
        id: genieEffect
        width: 160; height: width
        anchors.centerIn: parent
        property variant source: sourceImage
        property bool minimized: false
        MouseArea {
            anchors.fill: parent
            onClicked: genieEffect.minimized = !genieEffect.minimized
        }
    }
}
```

這個場景使用了一個黑色背景，並且提供了一個使用圖片作為資源紋理的ShaderEffect。使用image元素的原圖片是不可見的，只是給我們的吸收效果提供資源。此外我們在ShaderEffect的位置添加了一個同樣大小的黑色矩形框，這樣我們可以更加明確的知道我們需要點擊哪裡來重置效果。

![](http://qmlbook.org/_images/geniescene.png)

點擊圖片將會觸發效果，MouseArea覆蓋了ShaderEffect。在onClicked操作中，我們綁定了自定義的布爾變量屬性minimized。我們稍後使用這個屬性來觸發效果。

**最小化與正常化（Minimize and normalize）**

在我們配置好場景後，我們定義一個real類型的屬性，叫做minimize，這個屬性包含了我們當前最小化的值。這個值在0.0到1.0之間，由一個連續的動畫來控制它。

```
        property real minimize: 0.0

        SequentialAnimation on minimize {
            id: animMinimize
            running: genieEffect.minimized
            PauseAnimation { duration: 300 }
            NumberAnimation { to: 1; duration: 700; easing.type: Easing.InOutSine }
            PauseAnimation { duration: 1000 }
        }

        SequentialAnimation on minimize {
            id: animNormalize
            running: !genieEffect.minimized
            NumberAnimation { to: 0; duration: 700; easing.type: Easing.InOutSine }
            PauseAnimation { duration: 1300 }
        }
```

這個動畫綁定了由minimized屬性觸發。現在我們已經配置好我們的環境，最後讓我們看看頂點著色器的代碼。

```
        vertexShader: "
            uniform highp mat4 qt_Matrix;
            attribute highp vec4 qt_Vertex;
            attribute highp vec2 qt_MultiTexCoord0;
            varying highp vec2 qt_TexCoord0;
            uniform highp float minimize;
            uniform highp float width;
            uniform highp float height;
            void main() {
                qt_TexCoord0 = qt_MultiTexCoord0;
                highp vec4 pos = qt_Vertex;
                pos.y = mix(qt_Vertex.y, height, minimize);
                pos.x = mix(qt_Vertex.x, width, minimize);
                gl_Position = qt_Matrix * pos;
            }"
```

頂點著色器被每個頂點調用，在我們這個例子中，一共調用了四次。默認下提供qt已定義的參數，如qt_Matrix，qt_Vertex，qt_MultiTexCoord0，qt_TexCoord0。我們在之前已經討論過這些變量。此外我們從ShaderEffect中鏈接minimize，width與height的值到我們的頂點著色器代碼中。在main函數中，我們將當前紋理值保存在qt_TexCoord()中，讓它在片段著色器中可用。現在我們拷貝當前位置，並修改頂點的x,y的位置。

```
highp vec4 pos = qt_Vertex;
pos.y = mix(qt_Vertex.y, height, minimize);
pos.x = mix(qt_Vertex.x, width, minimize);
```

mix(...)函數提供了一種在兩個參數之間（0.0到1.0）的線性插值的算法。在我們的例子中，在當前y值與高度值之間基于minimize的值插值獲得y值，x的值獲取類似。記住minimize的值是由我們的連續動畫控制，並且在0.0到1.0之間（反之亦然）。

![](http://qmlbook.org/_images/genieminimize.png)

這個結果的效果不是真正吸收效果，但是已經能朝著這個目標完成了一大步。

**基礎彎曲（Primitive Bending）**

我們已經完成了最小化我們的坐標。現在我們想要修改一下對x值的操作，讓它依賴當前的y值。這個改變很簡單。y值計算在前。x值的插值基于當前頂點的y坐標。

```
highp float t = pos.y / height;
pos.x = mix(qt_Vertex.x, width, t * minimize);
```

這個結果造成當y值比較大時，x的位置更靠近width的值。也就是說上面2個頂點根本不受影響，它們的y值始終為0，下面兩個頂點的x坐標值更靠近width的值，它們最後轉向同一個x值。

![](http://qmlbook.org/_images/geniebending.png)

```
import QtQuick 2.0

Rectangle {
    width: 480; height: 240
    color: '#1e1e1e'

    Image {
        id: sourceImage
        width: 160; height: width
        source: "assets/lighthouse.jpg"
        visible: false
    }
    Rectangle {
        width: 160; height: width
        anchors.centerIn: parent
        color: '#333333'
    }
    ShaderEffect {
        id: genieEffect
        width: 160; height: width
        anchors.centerIn: parent
        property variant source: sourceImage
        property real minimize: 0.0
        property bool minimized: false


        SequentialAnimation on minimize {
            id: animMinimize
            running: genieEffect.minimized
            PauseAnimation { duration: 300 }
            NumberAnimation { to: 1; duration: 700; easing.type: Easing.InOutSine }
            PauseAnimation { duration: 1000 }
        }

        SequentialAnimation on minimize {
            id: animNormalize
            running: !genieEffect.minimized
            NumberAnimation { to: 0; duration: 700; easing.type: Easing.InOutSine }
            PauseAnimation { duration: 1300 }
        }


        vertexShader: "
            uniform highp mat4 qt_Matrix;
            uniform highp float minimize;
            uniform highp float height;
            uniform highp float width;
            attribute highp vec4 qt_Vertex;
            attribute highp vec2 qt_MultiTexCoord0;
            varying highp vec2 qt_TexCoord0;
            void main() {
                qt_TexCoord0 = qt_MultiTexCoord0;
                // M1>>
                highp vec4 pos = qt_Vertex;
                pos.y = mix(qt_Vertex.y, height, minimize);
                highp float t = pos.y / height;
                pos.x = mix(qt_Vertex.x, width, t * minimize);
                gl_Position = qt_Matrix * pos;
```

**更好的彎曲（Better Bending）**

現在簡單的彎曲並不能真正的滿足我們的要求，我們將添加幾個部件來提升它的效果。首先我們增加動畫，支持一個自定義的彎曲屬性。這是非常必要的，由于彎曲立即發生，y值的最小化需要被推遲。兩個動畫在同一持續時間計算總和（300+700+100與700+1300）。

```
        property real bend: 0.0
        property bool minimized: false


        // change to parallel animation
        ParallelAnimation {
            id: animMinimize
            running: genieEffect.minimized
            SequentialAnimation {
                PauseAnimation { duration: 300 }
                NumberAnimation {
                    target: genieEffect; property: 'minimize';
                    to: 1; duration: 700;
                    easing.type: Easing.InOutSine
                }
                PauseAnimation { duration: 1000 }
            }
            // adding bend animation
            SequentialAnimation {
                NumberAnimation {
                    target: genieEffect; property: 'bend'
                    to: 1; duration: 700;
                    easing.type: Easing.InOutSine }
                PauseAnimation { duration: 1300 }
            }
        }
```

此外，為了使彎曲更加平滑，不再使用y值影響x值的彎曲函數，pos.x現在依賴新的彎曲屬性動畫：

```
highp float t = pos.y / height;
t = (3.0 - 2.0 * t) * t * t;
pos.x = mix(qt_Vertex.x, width, t * bend);
```

彎曲從0.0平滑開始，逐漸加快，在1.0時逐漸平滑。下面是這個函數在指定範圍內的曲線圖。對于我們，只需要關注0到1的區間。

![](http://qmlbook.org/_images/curve.png)

想要獲得最大化的視覺改變，需要增加我們的頂點數量。可以使用網眼（mesh）來增加頂點：

```
mesh: GridMesh { resolution: Qt.size(16, 16) }
```

現在ShaderEffect被分布為16x16頂點的網格，替換了之前2x2的頂點。這樣頂點之間的插值將會看起來更加平滑。

![](http://qmlbook.org/_images/geniesmoothbending.png)

你可以看見曲線的變化，在最後讓彎曲變得非常平滑。這讓彎曲有了更加強大的效果。

**側面收縮（Choosing Sides）**

最後一個增強，我們希望能夠收縮邊界。邊界朝著吸收的點消失。直到現在它總是在朝著width值的點消失。添加一個邊界屬性，我們能夠修改這個點在0到width之間。

```
ShaderEffect {
    ...
    property real side: 0.5

    vertexShader: "
        ...
        uniform highp float side;
        ...
        pos.x = mix(qt_Vertex.x, side * width, t * bend);
    "
}
```

![](http://qmlbook.org/_images/geniehalfside.png)

**包裝（Packing）**

最後將我們的效果包裝起來。將我們吸收效果的代碼提取到一個叫做GenieEffect的自定義組件中。它使用ShaderEffect作為根元素。移除掉MouseArea，這不應該放在組件中。綁定minimized屬性來觸發效果。

```
import QtQuick 2.0

ShaderEffect {
    id: genieEffect
    width: 160; height: width
    anchors.centerIn: parent
    property variant source
    mesh: GridMesh { resolution: Qt.size(10, 10) }
    property real minimize: 0.0
    property real bend: 0.0
    property bool minimized: false
    property real side: 1.0


    ParallelAnimation {
        id: animMinimize
        running: genieEffect.minimized
        SequentialAnimation {
            PauseAnimation { duration: 300 }
            NumberAnimation {
                target: genieEffect; property: 'minimize';
                to: 1; duration: 700;
                easing.type: Easing.InOutSine
            }
            PauseAnimation { duration: 1000 }
        }
        SequentialAnimation {
            NumberAnimation {
                target: genieEffect; property: 'bend'
                to: 1; duration: 700;
                easing.type: Easing.InOutSine }
            PauseAnimation { duration: 1300 }
        }
    }

    ParallelAnimation {
        id: animNormalize
        running: !genieEffect.minimized
        SequentialAnimation {
            NumberAnimation {
                target: genieEffect; property: 'minimize';
                to: 0; duration: 700;
                easing.type: Easing.InOutSine
            }
            PauseAnimation { duration: 1300 }
        }
        SequentialAnimation {
            PauseAnimation { duration: 300 }
            NumberAnimation {
                target: genieEffect; property: 'bend'
                to: 0; duration: 700;
                easing.type: Easing.InOutSine }
            PauseAnimation { duration: 1000 }
        }
    }

    vertexShader: "
        uniform highp mat4 qt_Matrix;
        attribute highp vec4 qt_Vertex;
        attribute highp vec2 qt_MultiTexCoord0;
        uniform highp float height;
        uniform highp float width;
        uniform highp float minimize;
        uniform highp float bend;
        uniform highp float side;
        varying highp vec2 qt_TexCoord0;
        void main() {
            qt_TexCoord0 = qt_MultiTexCoord0;
            highp vec4 pos = qt_Vertex;
            pos.y = mix(qt_Vertex.y, height, minimize);
            highp float t = pos.y / height;
            t = (3.0 - 2.0 * t) * t * t;
            pos.x = mix(qt_Vertex.x, side * width, t * bend);
            gl_Position = qt_Matrix * pos;
        }"
}
```

你現在可以像這樣簡單的使用這個效果：

```
import QtQuick 2.0

Rectangle {
    width: 480; height: 240
    color: '#1e1e1e'

    GenieEffect {
        source: Image { source: 'assets/lighthouse.jpg' }
        MouseArea {
            anchors.fill: parent
            onClicked: parent.minimized = !parent.minimized
        }
    }
}
```

我們簡化了代碼，移除了背景矩形框，直接使用圖片完成效果，替換了在一個單獨的圖像元素中加載它。

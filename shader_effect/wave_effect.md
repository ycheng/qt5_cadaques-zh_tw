# 波浪效果（Wave Effect）

在這個更加復雜的例子中，我們使用片段著色器創建一個波浪效果。波浪的形成是基于sin曲線，並且它影響了使用的紋理坐標的顏色。

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
            width: 160; height: width
            source: "assets/coastline.jpg"
        }
        ShaderEffect {
            width: 160; height: width
            property variant source: sourceImage
            property real frequency: 8
            property real amplitude: 0.1
            property real time: 0.0
            NumberAnimation on time {
                from: 0; to: Math.PI*2; duration: 1000; loops: Animation.Infinite
            }

            fragmentShader: "
                varying highp vec2 qt_TexCoord0;
                uniform sampler2D source;
                uniform lowp float qt_Opacity;
                uniform highp float frequency;
                uniform highp float amplitude;
                uniform highp float time;
                void main() {
                    highp vec2 pulse = sin(time - frequency * qt_TexCoord0);
                    highp vec2 coord = qt_TexCoord0 + amplitude * vec2(pulse.x, -pulse.x);
                    gl_FragColor = texture2D(source, coord) * qt_Opacity;
                }"
        }
    }
}
```

波浪的計算是基于一個脈衝與紋理坐標的操作。我們使用一個基于當前時間與使用的紋理坐標的sin波浪方程式來實現脈衝。

```
highp vec2 pulse = sin(time - frequency * qt_TexCoord0);
```

離開了時間的因素，我們僅僅只有扭曲，而不是像波浪一樣運動的扭曲。

我們使用不同的紋理坐標作為顏色。

```
highp vec2 coord = qt_TexCoord0 + amplitude * vec2(pulse.x, -pulse.x);
```

紋理坐標受我們的x脈衝值影響，結果就像一個移動的波浪。

![](http://qmlbook.org/_images/wave.png)

如果我們沒有在片段著色器中使用像素的移動，這個效果可以首先考慮使用頂點著色器來完成。

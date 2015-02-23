# Qt圖像效果庫（Qt GraphicsEffect Library）

圖像效果庫是一個著色器效果的集合，是由Qt開發者提供制作的。它是一個很好的工具，你可以將它應用在你的程序中，它也是一個學習如何創建著色器的例子。

圖像效果庫附帶了一個手動測試平台，這個工具可以幫助你測試發現不同的效果
測試工具在$QTDIR/qtgraphicaleffects/tests/manual/testbed下。

![](http://qmlbook.org/_images/graphicseffectstestbed.png)

效果庫包含了大約20種效果，下面是效果列表和一些簡短的描述。

| 種類 | 效果 | 描述 |
| -- | -- | -- |
| 混合（Blend）| 混合（Blend） | 使用混合模式合並兩個資源項 |
| 顏色（Color） | 亮度與對比度（BrightnessContrast） | 調整亮度與對比度 |
|  | 著色（Colorize）| 設置HSL顏色空間顏色 |
| | 顏色疊加（ColorOverlay） | 應用一個顏色層 |
| | 降低飽和度（Desaturate） | 減少顏色飽和度 |
| | 伽馬調整（GammaAdjust） | 調整發光度 |
| | 色調飽和度（HueSaturation） | 調整HSL顏色空間顏色 |
| | 色階調整（LevelAdjust） | 調整RGB顏色空間顏色 |
| 漸變（Gradient） | 圓錐漸變（ConicalGradient） | 繪制一個圓錐漸變 |
| | 線性漸變（LinearGradient） | 繪制一個線性漸變 |
| | 射線漸變（RadialGradient） | 繪制一個射線漸變 |
| 失真（Distortion） | 置換（Displace） | 按照指定的置換源移動源項的像素 |
| 陰影（Drop Shadow） | 陰影 （DropShadow） | 繪制一個陰影 |
| | 內陰影（InnerShadow） | 繪制一個內陰影 |
| 模糊 （Blur）| 快速模糊（FastBlur） | 應用一個快速模糊效果 |
| | 高斯模糊（GaussianBlur） | 應用一個高質量模糊效果 |
| | 蒙版模糊（MaskedBlur）| 應用一個多種強度的模糊效果 |
| | 遞歸模糊（RecursiveBlur） | 重復模糊，提供一個更強的模糊效果 |
| 運動模糊（Motion Blur） | 方向模糊（DirectionalBlur） | 應用一個方向的運動模糊效果 |
| | 放射模糊（RadialBlur） | 應用一個放射運動模糊效果 |
| | 變焦模糊（ZoomBlur） | 應用一個變焦運動模糊效果 |
| 發光（Glow）| 發光（Glow） | 繪制一個外發光效果 |
| | 矩形發光（RectangularGlow） | 繪制一個矩形外發光效果 |
| 蒙版（Mask）| 透明蒙版（OpacityMask） | 使用一個源項遮擋另一個源項 |
| | 閾值蒙版（ThresholdMask） | 使用一個閾值，一個源項遮擋另一個源項 |

下面是一個使用快速模糊效果的例子：

```
import QtQuick 2.0
import QtGraphicalEffects 1.0

Rectangle {
    width: 480; height: 240
    color: '#1e1e1e'

    Row {
        anchors.centerIn: parent
        spacing: 16

        Image {
            id: sourceImage
            source: "assets/tulips.jpg"
            width: 200; height: width
            sourceSize: Qt.size(parent.width, parent.height)
            smooth: true
        }

        FastBlur {
            width: 200; height: width
            source: sourceImage
            radius: blurred?32:0
            property bool blurred: false

            Behavior on radius {
                NumberAnimation { duration: 1000 }
            }

            MouseArea {
                id: area
                anchors.fill: parent
                onClicked: parent.blurred = !parent.blurred
            }
        }
    }
}
```

左邊是原圖片。點擊右邊的圖片將會觸發blurred屬性，模糊在1秒內從0到32。左邊顯示模糊後的圖片。

![](http://qmlbook.org/_images/fastblur.png)

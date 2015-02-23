# 像素緩衝（Pixels Buffer）

當你使用畫布時，你可以檢索讀取畫布上的像素數據，或者操作畫布上的像素。讀取圖像數據使用createImageData(sw,sh)或者getImageData(sx,sy,sw,sh)。這兩個函數都會返回一個包含寬度（width），高度（height）和數據（data）的圖像數據（ImageData）對象。圖像數據包含了一維數組像素數據，使用RGBA格式進行檢索。每個數據的數據範圍在0到255之間。設置畫布的像素數據你可以使用putImageData(imagedata,dx,dy)函數來完成。

另一種檢索畫布內容的方法是將畫布的數據存儲進一張圖片中。可以使用畫布的函數save(path)或者toDataURL(mimeType)來完成，toDataURL(mimeType)會返回一個圖片的地址，這個鏈接可以直接用Image元素來讀取。

```
import QtQuick 2.0

Rectangle {
    width: 240; height: 120
    Canvas {
        id: canvas
        x: 10; y: 10
        width: 100; height: 100
        property real hue: 0.0
        onPaint: {
            var ctx = getContext("2d")
            var x = 10 + Math.random(80)*80
            var y = 10 + Math.random(80)*80
            hue += Math.random()*0.1
            if(hue > 1.0) { hue -= 1 }
            ctx.globalAlpha = 0.7
            ctx.fillStyle = Qt.hsla(hue, 0.5, 0.5, 1.0)
            ctx.beginPath()
            ctx.moveTo(x+5,y)
            ctx.arc(x,y, x/10, 0, 360)
            ctx.closePath()
            ctx.fill()
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                var url = canvas.toDataURL('image/png')
                print('image url=', url)
                image.source = url
            }
        }
    }

    Image {
        id: image
        x: 130; y: 10
        width: 100; height: 100
    }

    Timer {
        interval: 1000
        running: true
        triggeredOnStart: true
        repeat: true
        onTriggered: canvas.requestPaint()
    }
}
```

在我們這個例子中，我們每秒在左邊的畫布中繪制一個的圓形。當使用鼠標點擊畫布內容時，會將內容存儲為一個圖片鏈接。在右邊將會展示這個存儲的圖片。

**注意**

**在Qt5的Alpha版本中，檢索圖像數據似乎不能工作。**

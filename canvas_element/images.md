# 圖片（Images）

QML畫布支持多種資源的圖片繪制。在畫布中使用一個圖片需要先加載圖片資源。在我們的例子中我們使用Component.onCompleted操作來加載圖片。

```
    onPaint: {
        var ctx = getContext("2d")


        // draw an image
        ctx.drawImage('assets/ball.png', 10, 10)

        // store current context setup
        ctx.save()
        ctx.strokeStyle = 'red'
        // create a triangle as clip region
        ctx.beginPath()
        ctx.moveTo(10,10)
        ctx.lineTo(55,10)
        ctx.lineTo(35,55)
        ctx.closePath()
        // translate coordinate system
        ctx.translate(100,0)
        ctx.clip()  // create clip from triangle path
        // draw image with clip applied
        ctx.drawImage('assets/ball.png', 10, 10)
        // draw stroke around path
        ctx.stroke()
        // restore previous setup
        ctx.restore()

    }

    Component.onCompleted: {
        loadImage("assets/ball.png")
    }
```

在左邊，足球圖片使用10×10的大小繪制在左上方的位置。在右邊我們對足球圖片進行了裁剪。圖片或者輪廓路徑都可以使用一個路徑來裁剪。裁剪需要定義一個裁剪路徑，然後調用clip()函數來實現裁剪。在clip()之前所有的繪制操作都會用來進行裁剪。如果還原了之前的狀態或者定義裁剪區域為整個畫布時，裁剪是無效的。

![](http://qmlbook.org/_images/canvas_image.png)

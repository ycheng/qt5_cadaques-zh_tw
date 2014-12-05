# 轉換（Transformation）

畫布有多種方式來轉換坐標系。這些操作非常類似于QML元素的轉換。你可以通過縮放（scale），旋轉（rotate），translate（移動）來轉換坐標系。與QML元素的轉換不同的是，轉換原點通常就是畫布原點。例如，從中心點放大一個封閉的路徑，你需要先將畫布原點移動到整個封閉的路徑的中心點上。使用這些轉換的方法你可以創建一些更加復雜的轉換。

```
// transform.qml

import QtQuick 2.0

Canvas {
    id: root
    width: 240; height: 120
    onPaint: {
        var ctx = getContext("2d")
        ctx.strokeStyle = "blue"
        ctx.lineWidth = 4

        ctx.beginPath()
        ctx.rect(-20, -20, 40, 40)
        ctx.translate(120,60)
        ctx.stroke()

        // draw path now rotated
        ctx.strokeStyle = "green"
        ctx.rotate(Math.PI/4)
        ctx.stroke()
    }
}
```

![](http://qmlbook.org/_images/transform.png)

除了移動畫布外，也可以使用scale(x,y)來縮放x,y坐標軸。旋轉使用rotate(angle)，angle是角度（360度=2*Math.PI）。使用setTransform(m11,m12,m21,m22,dx,dy)來完成矩陣轉換。

**警告**

**QML畫布中的轉換與HTML5畫布中的機制有些不同。不確定這是不是一個Bug。**

**注意**

**重置矩陣你可以調用resetTransform()函數來完成，這個函數會將轉換矩陣還原為單位矩陣。**

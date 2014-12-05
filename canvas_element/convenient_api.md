# 便捷的接口（Convenient API）

在繪制矩形時，我們提供了一個便捷的接口，而不需要調用stroke或者fill來完成。

```
// convenient.qml

import QtQuick 2.0

Canvas {
    id: root
    width: 120; height: 120
    onPaint: {
        var ctx = getContext("2d")
        ctx.fillStyle = 'green'
        ctx.strokeStyle = "blue"
        ctx.lineWidth = 4

        // draw a filles rectangle
        ctx.fillRect(20, 20, 80, 80)
        // cut our an inner rectangle
        ctx.clearRect(30,30, 60, 60)
        // stroke a border from top-left to
        // inner center of the larger rectangle
        ctx.strokeRect(20,20, 40, 40)
    }
}
```

![](http://qmlbook.org/_images/convenient.png)

**注意**

**畫筆的繪制區域由中間向兩邊延展。一個寬度為4像素的畫筆將會在繪制路徑的裡面繪制2個像素，外面繪制2個像素。**

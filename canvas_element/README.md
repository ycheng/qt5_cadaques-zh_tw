# Canvas Element

**注意**

**最後一次構建：2014年1月20日下午18:00。**

**這章的源代碼能夠在[assetts folder](http://qmlbook.org/assets)找到。**

![](http://qmlbook.org/_images/glowlines.png)

在早些時候的Qt4中加入QML時，一些開發者討論如何在QtQuick中繪制一個圓形。類似圓形的問題，一些開發者也對于其它的形狀的支持進行了討論。在QtQuick中沒有圓形，只有矩形。在Qt4中，如果你需要一個除了矩形外的形狀，你需要使用圖片或者使用你自己寫的C++圓形元素。

Qt5中引進了畫布元素（canvas element），允許腳本繪制。畫布元素（canvas element）提供了一個依賴于分辨率的位圖畫布，你可以使用JavaScript腳本來繪制圖形，制作遊戲或者其它的動態圖像。畫布元素（canvas element）是基于HTML5的畫布元素來完成的。

畫布元素（canvas element）的基本思想是使用一個2D對象來渲染路徑。這個2D對象包括了必要的繪圖函數，畫布元素（canvas element）充當繪制畫布。2D對象支持畫筆，填充，漸變，文本和繪制路徑創建命令。

讓我們看看一個簡單的路徑繪制的例子：

```
import QtQuick 2.0

Canvas {
    id: root
    // canvas size
    width: 200; height: 200
    // handler to override for drawing
    onPaint: {
        // get context to draw with
        var ctx = getContext("2d")
        // setup the stroke
        ctx.lineWidth = 4
        ctx.strokeStyle = "blue"
        // setup the fill
        ctx.fillStyle = "steelblue"
        // begin a new path to draw
        ctx.beginPath()
        // top-left start point
        ctx.moveTo(50,50)
        // upper line
        ctx.lineTo(150,50)
        // right line
        ctx.lineTo(150,150)
        // bottom line
        ctx.lineTo(50,150)
        // left line through path closing
        ctx.closePath()
        // fill using fill style
        ctx.fill()
        // stroke using line width and stroke style
        ctx.stroke()
    }
}
```

這個例子產生了一個在坐標（50,50），高寬為100的填充矩形框，並且使用了畫筆來修飾邊界。

![](http://qmlbook.org/_images/rectangle.png)

畫筆的寬度被設置為4個像素，並且定義strokeStyle（畫筆樣式）為藍色。最後的形狀由設置填充樣式（fillStyle）為steelblue顏色，然後填充完成的。只有調用stroke或者fill函數，創建的路徑才會繪制，它們與其它的函數使用是相互獨立的。調用stroke或者fill將會繪制當前的路徑，創建的路徑是不可重用的，只有繪制狀態能夠被存儲和恢復。

在QML中，畫布元素（canvas element）充當了繪制的容器。2D繪制對象提供了實際繪制的方法。繪制需要在onPaint事件中完成。

```
Canvas {
    width: 200; height: 200
    onPaint: {
        var ctx = getContext("2d")
        // setup your path
        // fill or/and stroke
    }
}
```

畫布自身提供了典型的二維笛卡爾坐標系統，左上角是（0,0）坐標。Y軸坐標軸向下，X軸坐標軸向右。

典型繪制命令調用如下：

1. 裝載畫筆或者填充模式

2. 創建繪制路徑

3. 使用畫筆或者填充繪制路徑

```
    onPaint: {
        var ctx = getContext("2d")

        // setup the stroke
        ctx.strokeStyle = "red"

        // create a path
        ctx.beginPath()
        ctx.moveTo(50,50)
        ctx.lineTo(150,50)

        // stroke path
        ctx.stroke()
    }
```


這將產生一個從P1（50，50）到P2（150,50）水平線。

![](http://qmlbook.org/_images/line.png)

**注意**

**通常在你重置了路徑後你將會設置一個開始點，所以，在beginPath()這個操作後，你需要使用moveTo來設置開始點。**

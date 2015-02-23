# 布局元素（Layout Items）

QML使用anchors（錨）對元素進行布局。anchoring（錨定）是基礎元素對象的基本屬性，可以被所有的可視化QML元素使用。一個anchors（錨）就像一個協議，並且比幾何變化更加強大。Anchors（錨）是相對關系的表達式，你通常需要與其它元素搭配使用。

![](http://qmlbook.org/_images/anchors.png)

一個元素有6條錨定線（top頂，bottom底，left左，right右，horizontalCenter水平中，verticalCenter垂直中）。在文本元素（Text Element）中有一條文本的錨定基線（baseline）。每一條錨定線都有一個偏移（offset）值，在top（頂），bottom（底），left（左），right（右）的錨定線中它們也被稱作邊距。對于horizontalCenter（水平中）與verticalCenter（垂直中）與baseline（文本基線）中被稱作偏移值。

![](http://qmlbook.org/_images/anchorgrid.png)

1. 元素填充它的父元素。
```
        GreenSquare {
            BlueSquare {
                width: 12
                anchors.fill: parent
                anchors.margins: 8
                text: '(1)'
            }
        }
```

2. 元素左對齊它的父元素。
```
        GreenSquare {
            BlueSquare {
                width: 48
                y: 8
                anchors.left: parent.left
                anchors.leftMargin: 8
                text: '(2)'
            }
        }
```

3. 元素的左邊與它父元素的右邊對齊。
```
        GreenSquare {
            BlueSquare {
                width: 48
                anchors.left: parent.right
                text: '(3)'
            }
        }
```

4. 元素中間對齊。Blue1與它的父元素水平中間對齊。Blue2與Blue1中間對齊，並且它的頂部對齊Blue1的底部。
```
        GreenSquare {
            BlueSquare {
                id: blue1
                width: 48; height: 24
                y: 8
                anchors.horizontalCenter: parent.horizontalCenter
            }
            BlueSquare {
                id: blue2
                width: 72; height: 24
                anchors.top: blue1.bottom
                anchors.topMargin: 4
                anchors.horizontalCenter: blue1.horizontalCenter
                text: '(4)'
            }
        }
```

5. 元素在它的父元素中居中。
```
        GreenSquare {
            BlueSquare {
                width: 48
                anchors.centerIn: parent
                text: '(5)'
            }
        }
```

6. 元素水平方向居中對齊父元素並向後偏移12像素，垂直方向居中對齊。
```
        GreenSquare {
            BlueSquare {
                width: 48
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.horizontalCenterOffset: -12
                anchors.verticalCenter: parent.verticalCenter
                text: '(6)'
            }
        }
```

**注意**

**我們的方格都打開了拖拽。試著拖放幾個方格。你可以發現第一個方格無法被拖拽因為它每個邊都被固定了，當然第一個方格的父元素能夠被拖拽是因為它的父元素沒有被固定。第二個方格能夠在垂直方向上拖拽是因為它只有左邊被固定了。類似的第三個和第四個方格也只能在垂直方向上拖拽是因為它們都使用水平居中對齊。第五個方格使用居中布局，它也無法被移動，第六個方格與第五個方格類似。拖拽一個元素意味著會改變它的x,y坐標。anchoring（錨定）比幾何變化（例如x,y坐標變化）更強大是因為錨定線（anchored lines）的限制，我們將在後面討論動畫時看到這些功能的強大。**

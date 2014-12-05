# 簡單的轉換（Simple Transformations）

轉換操作改變了一個對象的幾何狀態。QML元素對象通常能夠被平移，旋轉，縮放。下面我們將講解這些簡單的操作和一些更高級的用法。
我們先從一個簡單的轉換開始。用下面的場景作為我們學習的開始。

簡單的位移是通過改變x,y坐標來完成的。旋轉是改變rotation（旋轉）屬性來完成的，這個值使用角度作為單位（0~360）。縮放是通過改變scale（比例）的屬性來完成的，小于1意味著縮小，大于1意味著放大。旋轉與縮放不會改變對象的幾何形狀，對象的x,y（坐標）與width/height（寬/高）也類似。只有繪制指令是被轉換的對象。

在我們展示例子之前我想要介紹一些東西：ClickableImage元素（ClickableImage element），ClickableImage僅僅是一個包含鼠標區域的圖像元素。我們遵循一個簡單的原則，三次使用相同的代碼描述一個用戶界面最好可以抽象為一個組件。

```
// ClickableImage.qml

// Simple image which can be clicked

import QtQuick 2.0

Image {
    id: root
    signal clicked

    MouseArea {
        anchors.fill: parent
        onClicked: root.clicked()
    }
}
```

![](http://qmlbook.org/_images/rockets.png)

我們使用我們可點擊圖片元素來顯示了三個火箭。當點擊時，每個火箭執行一種簡單的轉換。點擊背景將會重置場景。

```
// transformation.qml


import QtQuick 2.0

Item {
    // set width based on given background
    width: bg.width
    height: bg.height

    Image { // nice background image
        id: bg
        source: "assets/background.png"
    }

    MouseArea {
        id: backgroundClicker
        // needs to be before the images as order matters
        // otherwise this mousearea would be before the other elements
        // and consume the mouse events
        anchors.fill: parent
        onClicked: {
            // reset our little scene
            rocket1.x = 20
            rocket2.rotation = 0
            rocket3.rotation = 0
            rocket3.scale = 1.0
        }
    }

    ClickableImage {
        id: rocket1
        x: 20; y: 100
        source: "assets/rocket.png"
        onClicked: {
            // increase the x-position on click
            x += 5
        }
    }

    ClickableImage {
        id: rocket2
        x: 140; y: 100
        source: "assets/rocket.png"
        smooth: true // need antialising
        onClicked: {
            // increase the rotation on click
            rotation += 5
        }
    }

    ClickableImage {
        id: rocket3
        x: 240; y: 100
        source: "assets/rocket.png"
        smooth: true // need antialising
        onClicked: {
            // several transformations
            rotation += 5
            scale -= 0.05
        }
    }
}
```

![](http://qmlbook.org/_images/rockets_transformed.png)

火箭1在每次點擊後X軸坐標增加5像素，火箭2每次點擊後會旋轉。火箭3每次點擊後會縮小。對于縮放和旋轉操作我們都設置了smooth:true來增加反鋸齒，由于性能的原因通常是被關閉的（與剪裁屬性clip類似）。當你看到你的圖形中出現鋸齒時，你可能就需要打開平滑（smooth）。

**注意**

**為了獲得更好的顯示效果，當縮放圖片時推薦使用已縮放的圖片來替代，過量的放大可能會導致圖片模糊不清。當你在縮放圖片時你最好考慮使用smooth:true來提高圖片顯示質量。**

使用MouseArea來覆蓋整個背景，點擊背景可以初始化火箭的值。

**注意**

**在代碼中先出現的元素有更低的堆疊順序（叫做z順序值z-order），如果你點擊火箭1足夠多次，你會看見火箭1移動到了火箭2下面。z軸順序也可以使用元素對象的z-property來控制。**

![](http://qmlbook.org/_images/order_matters.png)

**由于火箭2後出現在代碼中，火箭2將會放在火箭1上面。這同樣適用于MouseArea（鼠標區域），一個後出現在代碼中的鼠標區域將會與之前的鼠標區域重疊，後出現的鼠標區域才能捕捉到鼠標事件。**

**請記住：文檔中元素的順序很重要。**

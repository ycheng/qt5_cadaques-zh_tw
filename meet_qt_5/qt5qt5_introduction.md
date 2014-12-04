# Qt5介紹（Qt5 Introduction）

## 1.2.1 Qt Quick

Qt Quick是Qt5的使用界面技術。Qt Quick自身包含了以下幾種技術：

* QML-使用於用戶界面的標示語言

* JavaScript-動態腳本語言

* Qt C++-具有高度可移植性的C++程式庫.

![](http://qmlbook.org/_images/qt5_overview.png)

類似HTML語言，QML是一個標識語言。它由QtQuick封裝在Item {}的元素的標識組成。它從頭設計了用戶界面的設計，並且可以讓開發人員快速，簡單的理解。用戶界面可以使用JavaScript代碼來提供和加強更多的功能。Qt Quick可以使用你自己本地已有的Qt C++輕鬆快速的擴展它的能力。簡單宣告式的UI作為前端，本地部分被稱作後端。這樣你可以將程序的計算密集部分與來自應用程序用戶界面操作部分分開。

在典型的項目中前端開發使用QML/JaveScript，後端代碼開發使用Qt C++來完成系統接口和繁重的計算工作。這樣就很自然的將設計界面的開發者和功能開發者分開了。後端開發測試使用Qt自有的單元測試框架後，輸出給前端開發者使用。

## 1.2.2 一個用戶界面（Digesting an User Interface）

讓我們來使用QtQuick來創建一個簡單的用戶界面，範例QML語言某些方面的特性。最後我們將獲得一個旋轉的風車。

我們開始創建一個空的main.qml檔案。所有的QML文件都已.qml作為後綴。作為一個標識語言（類似HTML）一個QML文檔需要並且只有一個根元素，在我們的案例中是一個基於background的圖像高度與寬度的幾何圖形元素：

```
import QtQuick 2.0

Image {
    id: root
    source: "images/background.png"
}
```

QML不會對最上層元素設置任何限制，我們使用一個backgournd圖像作為資源的圖像元素來作為我們的根元素。

![](http://qmlbook.org/_images/background.png)

**注意**

**每一個元素都有屬性，比如一個圖像有寬度，高度但是也有一些其它的屬性例如資源。圖像元素的大小能夠自動的從圖像大小上得出。否則我們應該設置寬度和高度屬性來顯示有效的像素。**

**大多數典型的元素都放置在QtQuick2.0模塊中，我們首先應該在第一行作這個重要的聲明。**

**id是這個特殊的屬性是可選的，包含了一個標識符，在檔案後面的地方可以直接引用。**

**重要提示：一個id屬性無法在它被設置後改變，並且在程序執行期間無法被設置。使用root作為根元素id僅僅是作者的習慣，可以在比較大的QML檔案中方便的引用最頂層元素。**

風車作為前景元素使用圖像的方式放置在我們的用戶界面上。

![](http://qmlbook.org/_images/pinwheel.png)

正常情況下你的用戶界面應該有不同類型的元素構成，而不是像我們的例子一樣只有圖像元素。

```
Image {
    id: root
    ...
    Image {
        id: wheel
        anchors.centerIn: parent
        source: "images/pinwheel.png"
    }
    ...
}
```

為了把風車放在中間的位置，我們使用了一個復雜的屬性，稱之為錨。錨定允許你指定幾何對象與父對象或者同級對象之間的位置關系。比如放置我在另一個元素中間（anchors.centerIn:parent）.有左邊（left），右邊（right），頂部（top），底部（bottom），中央（centerIn），填充（fill），垂直中央（verticalCenter）和水平中央（horizontalCenter）來表示元素之間的關系。確保他們能夠匹配，錨定一個對象的左側頂部的一個元素這樣的做法是沒有意義的。所以我們設置風車在父對象background的中央。

**注意**

**有時你需要進行一些微小的調整。使用anchors.horizontalCenterOffset或者anchors.verticalCenterOffset可以幫你實現這個功能。類似的調整屬性也可以用於其他所有的錨。查閱Qt的幫助檔案可以知道完整的錨屬性列表。**

**注意**

**將一個圖像作為根矩形元素的子元素放置範例了一種聲明式語言的重要概念。你描述了用戶界面的層和分組的順序，最頂部的一層（根矩形框）先繪制，然後子層按照包含它的元素局部坐標繪制在包含它的元素上。**

為了讓我們的範例更加有趣一點，我們應該讓程序有一些交互功能。當用戶點擊場景上某個位置時，讓我們的風車轉動起來。

我們使用mouseArea元素，並且讓它與我們的根元素大小一樣。

```
Image {
    id: root
    ...
    MouseArea {
        anchors.fill: parent
        onClicked: wheel.rotation += 90
    }
    ...
}
```

當用戶點擊覆蓋區域時，鼠標區域會發出一個信號。你可以重寫onClicked函數來鏈接這個信號。在這個案例中引用了風車的圖像並且讓他旋轉增加90度。

**注意**

**對於每個工作的信號，命名方式都是on + SignalName的標題。當屬性的值發生改變時也會發出一個信號。它們的命名方式是：on + PropertyName + Chagned。
如果一個寬度（width）屬性改變了，你可以使用onWidthChanged: print(width)來得到這個監控這個新的寬度值。**

現在風車將會旋轉，但是還不夠流暢。風車的旋轉角度屬性被直接改變了。我們應該怎樣讓90度的旋轉可以持續一段時間呢。現在是動畫效果發揮作用的時候了。一個動畫定義了一個屬性的在一段時間內的變化過程。為了實現這個效果，我們使用一個動畫類型叫做屬性行為。這個行為指定了一個動畫來定義屬性的每一次改變並賦值給屬性。每次屬性改變，動畫都會運行。這是QML中聲明動畫的幾種方式中的一種方式。

```
Image {
    id: root
    Image {
        id: wheel
        Behavior on rotation {
            NumberAnimation {
                duration: 250
            }
        }
    }
}
```

現在每當風車旋轉角度發生改變時都會使用NumberAnimation來實現250毫秒的旋轉動畫效果。每一次90度的轉變都需要花費250ms。

現在風車看起來好多了，我希望以上這些能夠讓你能夠對Qt Quick編程有一些了解。

# 動態視圖（Dynamic Views）

Repeater元素適合有限的靜態數據，但是在真正使用時，模型通常更加復雜和龐大，我們需要一個更加智能的解決方案。QtQuick提供了ListView和GridView元素，這兩個都是基于Flickable（可滑動）區域的元素，因此用戶可以放入更大的數據。同時，它們限制了同時實例化的代理數量。對于一個大型的模型，這意味著在同一個場景下只會加載有限的元素。

![](http://qmlbook.org/_images/listview-basic.png)

![](http://qmlbook.org/_images/gridview-basic.png)

這兩個元素的用法非常類似，我們由ListView開始，然後會描述GridView的模型起點來進行比較。

ListView與Repeater元素像素，它使用了一個model，使用delegate來實例化，並且在兩個delegate之間能夠設置間隔sapcing。下面的列表顯示了怎樣設置一個簡單的鏈表。

```
import QtQuick 2.0

Rectangle {
    width: 80
    height: 300

    color: "white"

    ListView {
        anchors.fill: parent
        anchors.margins: 20

        clip: true

        model: 100

        delegate: numberDelegate
        spacing: 5
    }

    Component {
        id: numberDelegate

        Rectangle {
            width: 40
            height: 40

            color: "lightGreen"

            Text {
                anchors.centerIn: parent

                font.pixelSize: 10

                text: index
            }
        }
    }
}
```

![](http://qmlbook.org/_images/listview-basic.png)

如果模型包含的數據比屏幕上顯示的更多，ListView元素只會顯示部分的鏈表內容。然後由于QtQuick的默認行為導致的問題，列表視圖不會限制被顯示的代理項（delegates）只在限制區域內顯示。這意味著代理項可以在列表視圖外顯示，用戶可以看見在列表視圖外動態的創建和銷毀這些代理項（delegates）。為了防止這個問題，ListView通過設置clip屬性為true，來激活裁剪功能。下面的圖片展示了這個結果，左邊是clip屬性設置為false的對比。

![](http://qmlbook.org/_images/listview-clip.png)

對于用戶，ListView（列表視圖）是一個滾動區域。它支持慣性滾動，這意味著它可以快速的翻閱內容。默認模式下，它可以在內容最後繼續伸展，然後反彈回去，這個信號告訴用戶已經到達內容的末尾。

視圖末尾的行為是由到boundsBehavior屬性的控制的。這是一個枚舉值，並且可以配置為默認的Flickable.DragAndOvershootBounds，視圖可以通過它的邊界線來拖拽和翻閱，配置為Flickable.StopAtBounds，視圖將不再可以移動到它的邊界線之外。配置為Flickable.DragOverBounds，用戶可以將視圖拖拽到它的邊界線外，但是在邊界線上翻閱將無效。

使用snapMode屬性可以限制一個視圖內元素的停止位置。默認行為下是ListView.NoSnap，允許視圖內元素在任何位置停止。將snapMode屬性設置為ListView.SnapToItem，視圖頂部將會與元素對象的頂部對齊排列。使用ListView.SnapOneItem，當鼠標或者觸摸釋放時，視圖將會停止在第一個可見的元素，這種模式對于瀏覽頁面非常便利。

## 6.3.1 方向（Orientation）

默認的鏈表視圖只提供了一個垂直方向的滾動條，但是水平滾動條也是需要的。鏈表視圖的方向由屬性orientation控制。它能夠被設置為默認值ListView.Vertical或者ListView.Horizontal。下面是一個水平鏈表視圖。

```
import QtQuick 2.0

Rectangle {
    width: 480
    height: 80

    color: "white"

    ListView {
        anchors.fill: parent
        anchors.margins: 20

        clip: true

        model: 100

        orientation: ListView.Horizontal

        delegate: numberDelegate
        spacing: 5
    }

    Component {
        id: numberDelegate

        Rectangle {
            width: 40
            height: 40

            color: "lightGreen"

            Text {
                anchors.centerIn: parent

                font.pixelSize: 10

                text: index
            }
        }
    }
}
```

![](http://qmlbook.org/_images/listview-horizontal.png)

按照上面的設置，水平鏈表視圖默認的元素順序方向是由左到右。可以通過設置layoutDirection屬性來控制元素順序方向，它可以設置為Qt.LeftToRight或者Qt.RightToLeft。

## 6.3.2 鍵盤導航和高亮

當使用基于觸摸方式的鏈表視圖時，默認提供的視圖已經足夠使用。在使用鍵盤甚至僅僅通過方向鍵選擇一個元素的場景下，需要有標識當前選中元素的機制。在QML中，這被叫做高亮。

視圖支持設置一個當前視圖中顯示代理元素中的高亮代理。它是一個附加的代理元素，這個元素僅僅只實例化一次，並移動到與當前元素相同的位置。

在下面例子的演示中，有兩個屬性來完成這個工作。首先是focus屬性設置為true，它設置鏈表視圖能夠獲得鍵盤焦點。然後是highlight屬性，指出使用的高亮代理元素。高亮代理元素的x,y與height屬性由當前元素指定。如果寬度沒有特別指定，當前元素的寬度也可以用于高亮代理元素。

在例子中，ListView.view.width屬性被綁定用于高亮元素的寬度。關于代理元素的使綁定屬性將在後面的章節討論，但是最好知道相同的綁定屬性也可以用于高亮代理元素。

```
import QtQuick 2.0

Rectangle {
    width: 240
    height: 300

    color: "white"

    ListView {
        anchors.fill: parent
        anchors.margins: 20

        clip: true

        model: 100

        delegate: numberDelegate
        spacing: 5

        highlight: highlightComponent
        focus: true
    }

    Component {
        id: highlightComponent

        Rectangle {
            width: ListView.view.width
            color: "lightGreen"
        }
    }

    Component {
        id: numberDelegate

        Item {
            width: 40
            height: 40

            Text {
                anchors.centerIn: parent

                font.pixelSize: 10

                text: index
            }
        }
    }
}
// M1>>
```

![](http://qmlbook.org/_images/listview-highlight.png)

當使用高亮與鏈表視圖（ListView）結合時，一些屬性可以用來控制它的行為。highlightRangeMode控制了高亮如何影響視圖中當前的顯示。默認設置ListView.NoHighLighRange意味著高亮與視圖中的元素距離不相關。

ListView.StrictlyEnforceRnage確保了高亮始終可見，如果某個動作嘗試將高亮移出當前視圖可見範圍，當前元素將會自動切換，確保了高亮始終可見。

ListView.ApplyRange，它嘗試保持高亮代理始終可見，但是不會強制切換當前元素始終可見。如果在需要的情況下高亮代理允許被移出當前視圖。

在默認配置下，視圖負責高亮移動到指定位置，移動的速度與大小的改變能夠被控制，使用一個速度值或者一個動作持續時間來完成它。這些屬性包括highlightMoveSpeed，highlightMoveDuration，highlightResizeSpeed和highlightResizeDuration。默認下速度被設置為每秒400像素，動作持續時間為-1，表明速度和距離控制了動作的持續時間。如果速度與動作持續時間都被設置，動畫將會採用速度較快的結果來完成。

為了更加詳細的控制高亮的移動，highlightFollowCurrentItem屬性設置為false。這意味著視圖將不再負責高亮代理的移動。取而代之可以通過一個行為（Bahavior）或者一個動畫來控制它。

在下面的例子中，高亮代理的y坐標屬性與ListView.view.currentItem.y屬性綁定。這確保了高亮始終跟隨當前元素。然而，由于我們沒有讓視圖來移動這個高亮代理，我們需要控制這個元素如何移動，通過Behavior on y來完成這個操作，在下面的例子中，移動分為三步完成：淡出，移動，淡入。注意怎樣使用SequentialAnimation和PropertyAnimation元素與NumberAnimation結合創建更加復雜的移動效果。

```
    Component {
        id: highlightComponent

        Item {
            width: ListView.view.width
            height: ListView.view.currentItem.height

            y: ListView.view.currentItem.y

            Behavior on y {
                SequentialAnimation {
                    PropertyAnimation { target: highlightRectangle; property: "opacity"; to: 0; duration: 200 }
                    NumberAnimation { duration: 1 }
                    PropertyAnimation { target: highlightRectangle; property: "opacity"; to: 1; duration: 200 }
                }
            }

            Rectangle {
                id: highlightRectangle
                anchors.fill: parent
                color: "lightGreen"
            }
        }
    }
```

## 6.3.3 頁眉與頁腳（Header and Footer）

這一節是鏈表視圖最後的內容，我們能夠向鏈表視圖中插入一個頁眉（header）元素和一個頁腳（footer）元素。這部分是鏈表的開始或者結尾處被作為代理元素特殊的區域。對于一個水平鏈表視圖，不會存在頁眉或者頁腳，但是也有開始和結尾處，這取決于layoutDirection的設置。

下面這個例子展示了如何使用一個頁眉和頁腳來突出鏈表的開始與結尾。這些特殊的鏈表元素也有其它的作用，例如，它們能夠保持鏈表中的按鍵加載更多的內容。

```
import QtQuick 2.0

Rectangle {
    width: 80
    height: 300

    color: "white"

    ListView {
        anchors.fill: parent
        anchors.margins: 20

        clip: true

        model: 4

        delegate: numberDelegate
        spacing: 5

        header: headerComponent
        footer: footerComponent
    }

    Component {
        id: headerComponent

        Rectangle {
            width: 40
            height: 20

            color: "yellow"
        }
    }

    Component {
        id: footerComponent

        Rectangle {
            width: 40
            height: 20

            color: "red"
        }
    }

    Component {
        id: numberDelegate

        Rectangle {
            width: 40
            height: 40

            color: "lightGreen"

            Text {
                anchors.centerIn: parent

                font.pixelSize: 10

                text: index
            }
        }
    }
}
```

**注意**

**頁眉與頁腳代理元素不遵循鏈表視圖（ListView）的間隔（spacing）屬性，它們被直接放在相鄰的鏈表元素之上或之下。這意味著頁眉與頁腳的間隔必須通過頁眉與頁腳元素自己設置。**

![](http://qmlbook.org/_images/listview-header-footer.png)

## 6.3.4 網格視圖（The GridView）

使用網格視圖（GridView）與使用鏈表視圖（ListView）的方式非常類似。真正不同的地方是網格視圖（GridView）使用了一個二維數組來存放元素，而鏈表視圖（ListView）是使用的線性鏈表來存放元素。

![](http://qmlbook.org/_images/gridview-basic.png)

與鏈表視圖（ListView）比較，網格視圖（GridView）不依賴于元素間隔和大小來配置元素。它使用單元寬度（cellWidth）與單元高度（cellHeight）屬性來控制數組內的二維元素的內容。每個元素從左上角開始依次放入單元格。

```
import QtQuick 2.0

Rectangle {
    width: 240
    height: 300

    color: "white"

    GridView {
        anchors.fill: parent
        anchors.margins: 20

        clip: true

        model: 100

        cellWidth: 45
        cellHeight: 45

        delegate: numberDelegate
    }

    Component {
        id: numberDelegate

        Rectangle {
            width: 40
            height: 40

            color: "lightGreen"

            Text {
                anchors.centerIn: parent

                font.pixelSize: 10

                text: index
            }
        }
    }
}
```

一個網格視圖（GridView）也包含了頁腳與頁眉，也可以使用高亮代理並且支持捕捉模式（snap mode）的多種反彈行為。它也可以使用不同的方向（orientations）與定向（directions）來定位。

定向使用flow屬性來控制。它可以被設置為GridView.LeftToRight或者GridView.TopToBottom。模型的值從左往右向網格中填充，行添加是從上往下。視圖使用一個垂直方向的滾動條。後面添加的元素也是由上到下，由左到右。

此外還有flow屬性和layoutDirection屬性，能夠適配網格從左到右或者從右到左，這依賴于你使用的設置值。

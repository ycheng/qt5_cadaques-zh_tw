# 定位元素（Positioning Element）

有一些QML元素被用于放置元素對象，它們被稱作定位器，QtQuick模塊提供了Row，Column，Grid，Flow用來作為定位器。你可以在下面的插圖中看到它們使用相同內容的顯示效果。

**注意**

**在我們詳細介紹前，我們先介紹一些相關的元素，紅色（red），藍色（blue），綠色（green），高亮（lighter）與黑暗（darker）方塊，每一個組件都包含了一個48乘48的著色區域。下面是關于RedSquare（紅色方塊）的代碼：**

```
// RedSquare.qml

import QtQuick 2.0

Rectangle {
    width: 48
    height: 48
    color: "#ea7025"
    border.color: Qt.lighter(color)
}
```

**請注意使用了Qt.lighter（color）來指定了基于填充色的邊界高亮色。我們將會在後面的例子中使用到這些元素，希望後面的代碼能夠容易讀懂。請記住每一個矩形框的初始化大小都是48乘48像素大小。**

Column（列）元素將它的子對象通過頂部對齊的列方式進行排列。spacing屬性用來設置每個元素之間的間隔大小。

![](http://qmlbook.org/_images/column.png)

```
// column.qml

import QtQuick 2.0

DarkSquare {
    id: root
    width: 120
    height: 240

    Column {
        id: column
        anchors.centerIn: parent
        spacing: 8
        RedSquare { }
        GreenSquare { width: 96 }
        BlueSquare { }
    }
}

// M1<<
```

Row（行）元素將它的子對象從左到右，或者從右到左依次排列，排列方式取決于layoutDirection屬性。spacing屬性用來設置每個元素之間的間隔大小。

![](http://qmlbook.org/_images/row.png)

```
// row.qml

import QtQuick 2.0

BrightSquare {
    id: root
    width: 400; height: 120

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 20
        BlueSquare { }
        GreenSquare { }
        RedSquare { }
    }
}
```

Grid（柵格）元素通過設置rows（行數）和columns（列數）將子對象排列在一個柵格中。可以只限制行數或者列數。如果沒有設置它們中的任意一個，柵格元素會自動計算子項目總數來獲得配置，例如，設置rows（行數）為3，添加了6個子項目到元素中，那麼會自動計算columns（列數）為2。屬性flow（流）與layoutDirection（布局方向）用來控制子元素的加入順序。spacing屬性用來控制所有元素之間的間隔。

![](http://qmlbook.org/_images/grid.png)

```
// grid.qml

import QtQuick 2.0

BrightSquare {
    id: root
    width: 160
    height: 160

    Grid {
        id: grid
        rows: 2
        columns: 2
        anchors.centerIn: parent
        spacing: 8
        RedSquare { }
        RedSquare { }
        RedSquare { }
        RedSquare { }
    }

}
```

最後一個定位器是Flow（流）。通過flow（流）屬性和layoutDirection（布局方向）屬性來控制流的方向。它能夠從頭到底的橫向布局，也可以從左到右或者從右到左進行布局。作為加入流中的子對象，它們在需要時可以被包裝成新的行或者列。為了讓一個流可以工作，必須指定一個寬度或者高度，可以通過屬性直接設定，或者通過anchor（錨定）布局設置。

![](http://qmlbook.org/_images/flow.png)

```
// flow.qml

import QtQuick 2.0

BrightSquare {
    id: root
    width: 160
    height: 160

    Flow {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20
        RedSquare { }
        BlueSquare { }
        GreenSquare { }
    }
}
```

通常Repeater（重復元素）與定位器一起使用。它的工作方式就像for循環與迭代器的模式一樣。在這個最簡單的例子中，僅僅提供了一個循環的例子。

![](http://qmlbook.org/_images/repeater.png)

```
// repeater.qml

import QtQuick 2.0

DarkSquare {
    id: root
    width: 252
    height: 252
    property variant colorArray: ["#00bde3", "#67c111", "#ea7025"]


    Grid{
        anchors.fill: parent
        anchors.margins: 8
        spacing: 4
        Repeater {
            model: 16
            Rectangle {
                width: 56; height: 56
                property int colorIndex: Math.floor(Math.random()*3)
                color: root.colorArray[colorIndex]
                border.color: Qt.lighter(color)
                Text {
                    anchors.centerIn: parent
                    color: "#f0f0f0"
                    text: "Cell " + index
                }
            }
        }
    }
}
```

在這個重復元素的例子中，我們使用了一些新的方法。我們使用一個顏色數組定義了一組顏色屬性。重復元素能夠創建一連串的矩形框（16個，就像模型中定義的那樣）。每一次的循環都會創建一個矩形框作為repeater的子對象。在矩形框中，我們使用了JS數學函數Math.floor(Math.random()*3)來選擇顏色。這個函數會給我們生成一個0~2的隨機數，我們使用這個數在我們的顏色數組中選擇顏色。注意之前我們說過JavaScript是QtQuick中的一部分，所以這些典型的庫函數我們都可以使用。

一個重復元素循環時有一個index（索引）屬性值。當前的循環索引（0,1,2,....15）。我們可以使用這個索引值來做一些操作，例如在我們這個例子中使用Text（文本）顯示當前索引值。

**注意**

**高級的大數據模型處理和使用動態代理的動態視圖會在模型與視圖（model-view）章節中講解。當有一小部分的靜態數據需要顯示時，使用重復元素是最好的方式。**

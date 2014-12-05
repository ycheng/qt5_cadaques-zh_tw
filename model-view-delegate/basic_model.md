# 基礎模型（Basic Model）

最基本的分離數據與顯示的方法是使用Repeater元素。它被用于實例化一組元素項，並且很容易與一個用于填充用戶界面的定位器相結合。

最基本的實現舉例，repeater元素用于實現子元素的標號。每個子元素都擁有一個可以訪問的屬性index，用于區分不同的子元素。在下面的例子中，一個repeater元素創建了10個子項，子項的數量由model屬性控制。對于每個子項Rectangle包含了一個Text元素，你可以將text屬性設置為index的值，因此可以看到子項的編號是0~9。

```
import QtQuick 2.0

Column {
    spacing: 2

    Repeater {
        model: 10

        Rectangle {
            width: 100
            height: 20

            radius: 3

            color: "lightBlue"

            Text {
                anchors.centerIn: parent
                text: index
            }
        }
    }
}
```

![](http://qmlbook.org/_images/repeater-number.png)

這是一個不錯的編號列表，有時我們想顯示一些更復雜的數據。使用一個JavaScript序列來替換整形變量model的值可以達到我們的目的。序列可以使用任何類型的內容，可以是字符串，整數，或者對象。在下面的例子中，使用了一個字符串鏈表。我們仍然使用index的值作為變量，並且我們也訪問modelData中包含的每個元素的數據。

```
import QtQuick 2.0

Column {
    spacing: 2

    Repeater {
        model: ["Enterprise", "Colombia", "Challenger", "Discovery", "Endeavour", "Atlantis"]

        Rectangle {
            width: 100
            height: 20

            radius: 3

            color: "lightBlue"

            Text {
                anchors.centerIn: parent
                text: index +": "+modelData
            }
        }
    }
}
```

![](http://qmlbook.org/_images/repeater-array.png)

將數據暴露成一組序列，你可以通過標號迅速的找到你需要的信息。想象一下這個模型的草圖，這是一個最簡單的模型，也是通常都會使用的模型，ListModel（鏈表模型）。一個鏈表模型由許多ListElement（鏈表元素）組成。在每個鏈表元素中，可以綁定值到屬性上。例如在下面這個例子中，每個元素都提供了一個名字和一個顏色。

每個元素中的屬性綁定連接到repeater實例化的子項上。這意味著變量name和surfaceColor可以被repeater創建的每個Rectangle和Text項引用。這不僅可以方便的訪問數據，也可以使源代碼更加容易閱讀。surfaceColor是名字左邊圓的顏色，而不是模糊的數據序列列i或者行j。

```
import QtQuick 2.0

Column {
    spacing: 2

    Repeater {
        model: ListModel {
            ListElement { name: "Mercury"; surfaceColor: "gray" }
            ListElement { name: "Venus"; surfaceColor: "yellow" }
            ListElement { name: "Earth"; surfaceColor: "blue" }
            ListElement { name: "Mars"; surfaceColor: "orange" }
            ListElement { name: "Jupiter"; surfaceColor: "orange" }
            ListElement { name: "Saturn"; surfaceColor: "yellow" }
            ListElement { name: "Uranus"; surfaceColor: "lightBlue" }
            ListElement { name: "Neptune"; surfaceColor: "lightBlue" }
        }

        Rectangle {
            width: 100
            height: 20

            radius: 3

            color: "lightBlue"

            Text {
                anchors.centerIn: parent
                text: name
            }

            Rectangle {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 2

                width: 16
                height: 16

                radius: 8

                border.color: "black"
                border.width: 1

                color: surfaceColor
            }
        }
    }
}
```

![](http://qmlbook.org/_images/repeater-model.png)

repeater的內容的每個子項實例化時綁定了默認的屬性delegate（代理）。這意味著例1（第一個代碼段）的代碼與下面顯示的代碼是相同的。注意，唯一的不同是delegate屬性名，將會在後面詳細講解。

```
import QtQuick 2.0

Column {
    spacing: 2

    Repeater {
        model: 10

        delegate: Rectangle {
            width: 100
            height: 20

            radius: 3

            color: "lightBlue"

            Text {
                anchors.centerIn: parent
                text: index
            }
        }
    }
}
```

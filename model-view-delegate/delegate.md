# 代理（Delegate）

當使用模型與視圖來自定義用戶界面時，代理在創建顯示時扮演了大量的角色。在模型中的每個元素通過代理來實現可視化，用戶真實可見的是這些代理元素。

每個代理訪問到索引號或者綁定的屬性，一些是來自數據模型，一些來自視圖。來自模型的數據將會通過屬性傳遞到代理。來自視圖的數據將會通過屬性傳遞視圖中與代理相關的狀態信息。

通常使用的視圖綁定屬性是ListView.isCurrentItem和ListView.view。第一個是一個布爾值，標識這個元素是否是視圖當前元素，這個值是只讀的，引用自當前視圖。通過訪問視圖，可以創建可復用的代理，這些代理在被包含時會自動匹配視圖的大小。在下面這個例子中，每個代理的width（寬度）屬性與視圖的width（寬度）屬性綁定，每個代理的背景顏色color依賴于綁定的屬性ListView.isCurrentItem屬性。

```
import QtQuick 2.0

Rectangle {
    width: 120
    height: 300

    color: "white"

    ListView {
        anchors.fill: parent
        anchors.margins: 20

        clip: true

        model: 100

        delegate: numberDelegate
        spacing: 5

        focus: true
    }

    Component {
        id: numberDelegate

        Rectangle {
            width: ListView.view.width
            height: 40

            color: ListView.isCurrentItem?"gray":"lightGray"

            Text {
                anchors.centerIn: parent

                font.pixelSize: 10

                text: index
            }
        }
    }
}
```

![](http://qmlbook.org/_images/delegates-basic.png)

如果在模型中的每個元素與一個動作相關，例如點擊作用于一個元素時，這個功能是代理完成的。這是由事件管理分配給視圖的，這個操作控制了視圖中元素的導航，代理控制了特定元素上的動作。

最基礎的方法是在每個代理中創建一個MouseArea（鼠標區域）並且響應onClicked信號。在後面章節中將會演示這個例子。

## 6.4.1 動畫添加與移除元素（Animating Added and Removed Items）

在某些情況下，視圖中的顯示內容會隨著時間而改變。由于模型數據的改變，元素會添加或者移除。在這些情況下，一個比較好的做法是使用可視化隊列給用戶一個方向的感覺來幫助用戶知道哪些數據被加入或者移除。

為了方便使用，QML視圖為每個代理綁定了兩個信號，onAdd和onRemove。使用動畫連接它們，可以方便創建識別哪些內容被添加或刪除的動畫。

下面這個例子演示了如何動態填充一個鏈表模型（ListModel）。在屏幕下方，有一個添加新元素的按鈕。當點擊它時，會調用模型的append方法來添加一個新的元素。這個操作會觸發視圖創建一個新的代理，並發送GridView.onAdd信號。SequentialAnimation隊列動畫與這個信號連接綁定，使用代理的scale屬性來放大視圖元素。

當視圖中的一個代理點擊時，將會調用模型的remove方法將一個元素從模型中移除。這個操作將會導致GridView.onRemove信號的發送，觸發另一個SequentialAnimation。這時，代理的銷毀將會延遲直到動畫完成。為了完成這個操作，PropertyAction元素需要在動畫前設置GridView.delayRemove屬性為true，並在動畫後設置為false。這樣確保了動畫在代理項移除前完成。

```
import QtQuick 2.0

Rectangle {
    width: 480
    height: 300

    color: "white"

    ListModel {
        id: theModel

        ListElement { number: 0 }
        ListElement { number: 1 }
        ListElement { number: 2 }
        ListElement { number: 3 }
        ListElement { number: 4 }
        ListElement { number: 5 }
        ListElement { number: 6 }
        ListElement { number: 7 }
        ListElement { number: 8 }
        ListElement { number: 9 }
    }

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 20

        height: 40

        color: "darkGreen"

        Text {
            anchors.centerIn: parent

            text: "Add item!"
        }

        MouseArea {
            anchors.fill: parent

            onClicked: {
                theModel.append({"number": ++parent.count});
            }
        }

        property int count: 9
    }

    GridView {
        anchors.fill: parent
        anchors.margins: 20
        anchors.bottomMargin: 80

        clip: true

        model: theModel

        cellWidth: 45
        cellHeight: 45

        delegate: numberDelegate
    }

    Component {
        id: numberDelegate

        Rectangle {
            id: wrapper

            width: 40
            height: 40

            color: "lightGreen"

            Text {
                anchors.centerIn: parent

                font.pixelSize: 10

                text: number
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    if (!wrapper.GridView.delayRemove)
                        theModel.remove(index);
                }
            }

            GridView.onRemove: SequentialAnimation {
                PropertyAction { target: wrapper; property: "GridView.delayRemove"; value: true }
                NumberAnimation { target: wrapper; property: "scale"; to: 0; duration: 250; easing.type: Easing.InOutQuad }
                PropertyAction { target: wrapper; property: "GridView.delayRemove"; value: false }
            }

            GridView.onAdd: SequentialAnimation {
                NumberAnimation { target: wrapper; property: "scale"; from: 0; to: 1; duration: 250; easing.type: Easing.InOutQuad }
            }
        }
    }
}
```

## 6.4.2 形變的代理（Shape-Shifting Delegates）

在使用鏈表時通常會使用當前項激活時展開的機制。這個操作可以被用于動態的將當前項目填充到整個屏幕來添加一個新的用戶界面，或者為鏈表中的當前項提供更多的信息。

在下面的例子中，當點擊鏈表項時，鏈表項都會展開填充整個鏈表視圖（ListView）。額外的間隔區域被用于添加更多的信息，這種機制使用一個狀態來控制，當一個鏈表項展開時，代理項都能輸入expanded（展開）狀態，在這種狀態下一些屬性被改變。

首先，包裝器（wrapper）的高度（height）被設置為鏈表視圖（ListView）的高度。標簽圖片被放大並且下移，使圖片從小圖片的位置移向大圖片的位置。除了這些之外，兩個隱藏項，實際視圖（factsView）與關閉按鍵（closeButton）切換它的opactiy（透明度）顯示出來。最後設置鏈表視圖（ListView）。

設置鏈表視圖（ListView）包含了設置內容Y坐標（contentsY），這是視圖頂部可見的部分代理的Y軸坐標。另一個變化是設置視圖的交互（interactive）為false。這個操作阻止了視圖的移動，用戶不再能夠通過滾動條切換當前項。

由于設置第一個鏈表項為可點擊，向它輸入一個expanded（展開）狀態，導致了它的代理項被填充到整個鏈表並且內容重置。當點擊關閉按鈕時，清空狀態，導致它的代理項返回上一個狀態，並且重新設置鏈表視圖（ListView）有效。

```
import QtQuick 2.0

Item {
    width: 300
    height: 480

    ListView {
        id: listView

        anchors.fill: parent

        delegate: detailsDelegate
        model: planets
    }

    ListModel {
        id: planets

        ListElement { name: "Mercury"; imageSource: "images/mercury.jpeg"; facts: "Mercury is the smallest planet in the Solar System. It is the closest planet to the sun. It makes one trip around the Sun once every 87.969 days." }
        ListElement { name: "Venus"; imageSource: "images/venus.jpeg"; facts: "Venus is the second planet from the Sun. It is a terrestrial planet because it has a solid, rocky surface. The other terrestrial planets are Mercury, Earth and Mars. Astronomers have known Venus for thousands of years." }
        ListElement { name: "Earth"; imageSource: "images/earth.jpeg"; facts: "The Earth is the third planet from the Sun. It is one of the four terrestrial planets in our Solar System. This means most of its mass is solid. The other three are Mercury, Venus and Mars. The Earth is also called the Blue Planet, 'Planet Earth', and 'Terra'." }
        ListElement { name: "Mars"; imageSource: "images/mars.jpeg"; facts: "Mars is the fourth planet from the Sun in the Solar System. Mars is dry, rocky and cold. It is home to the largest volcano in the Solar System. Mars is named after the mythological Roman god of war because it is a red planet, which signifies the colour of blood." }
    }

    Component {
        id: detailsDelegate

        Item {
            id: wrapper

            width: listView.width
            height: 30

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top

                height: 30

                color: "#ffaa00"

                Text {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter

                    font.pixelSize: parent.height-4

                    text: name
                }
            }

            Rectangle {
                id: image

                color: "black"

                anchors.right: parent.right
                anchors.top: parent.top
                anchors.rightMargin: 2
                anchors.topMargin: 2

                width: 26
                height: 26

                Image {
                    anchors.fill: parent

                    fillMode: Image.PreserveAspectFit

                    source: imageSource
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: parent.state = "expanded"
            }

            Item {
                id: factsView

                anchors.top: image.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom

                opacity: 0

                Rectangle {
                    anchors.fill: parent

                    color: "#cccccc"

                    Text {
                        anchors.fill: parent
                        anchors.margins: 5

                        clip: true
                        wrapMode: Text.WordWrap

                        font.pixelSize: 12

                        text: facts
                    }
                }
            }

            Rectangle {
                id: closeButton

                anchors.right: parent.right
                anchors.top: parent.top
                anchors.rightMargin: 2
                anchors.topMargin: 2

                width: 26
                height: 26

                color: "red"

                opacity: 0

                MouseArea {
                    anchors.fill: parent
                    onClicked: wrapper.state = ""
                }
            }

            states: [
                State {
                    name: "expanded"

                    PropertyChanges { target: wrapper; height: listView.height }
                    PropertyChanges { target: image; width: listView.width; height: listView.width; anchors.rightMargin: 0; anchors.topMargin: 30 }
                    PropertyChanges { target: factsView; opacity: 1 }
                    PropertyChanges { target: closeButton; opacity: 1 }
                    PropertyChanges { target: wrapper.ListView.view; contentY: wrapper.y; interactive: false }
                }
            ]

            transitions: [
                Transition {
                    NumberAnimation {
                        duration: 200;
                        properties: "height,width,anchors.rightMargin,anchors.topMargin,opacity,contentY"
                    }
                }
            ]
        }
    }
}
```

![](http://qmlbook.org/_images/delegates-expanding-small.png)

![](http://qmlbook.org/_images/delegates-expanding-large.png)

這個技術展示了展開代理來填充視圖能夠簡單的通過代理的形變來完成。例如當瀏覽一個歌曲的鏈表時，可以通過放大當前項來對該項添加更多的說明。

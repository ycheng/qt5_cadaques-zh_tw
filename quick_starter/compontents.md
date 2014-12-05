# 組件（Compontents）


一個組件是一個可以重復使用的元素，QML提供幾種不同的方法來創建組件。但是目前我們只對其中一種方法進行講解：一個文件就是一個基礎組件。一個以文件為基礎的組件在文件中創建了一個QML元素，並且將文件以元素類型來命名（例如Button.qml）。你可以像任何其它的QtQuick模塊中使用元素一樣來使用這個組件。在我們下面的例子中，你將會使用你的代碼作為一個Button（按鈕）來使用。

讓我們來看看這個例子，我們創建了一個包含文本和鼠標區域的矩形框。它類似于一個簡單的按鈕，我們的目標就是讓它足夠簡單。

```
    Rectangle { // our inlined button ui
        id: button
        x: 12; y: 12
        width: 116; height: 26
        color: "lightsteelblue"
        border.color: "slategrey"
        Text {
            anchors.centerIn: parent
            text: "Start"
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                status.text = "Button clicked!"
            }
        }
    }

    Text { // text changes when button was clicked
        id: status
        x: 12; y: 76
        width: 116; height: 26
        text: "waiting ..."
        horizontalAlignment: Text.AlignHCenter
    }
```

用戶界面將會看起來像下面這樣。左邊是初始化的狀態，右邊是按鈕點擊後的效果。

![](http://qmlbook.org/_images/button_waiting.png)

![](http://qmlbook.org/_images/button_clicked.png)

我們的目標是提取這個按鈕作為一個可重復使用的組件。我們可以簡單的考慮一下我們的按鈕會有的哪些API（應用程序接口），你可以自己考慮一下你的按鈕應該有些什麼。下面是我考慮的結果：

```
// my ideal minimal API for a button
Button {
    text: "Click Me"
    onClicked: { // do something }
}
```

我想要使用text屬性來設置文本，然後實現我們自己的點擊操作。我也期望這個按鈕有一個比較合適的初始化大小（例如width:240）。
為了完成我們的目標，我創建了一個Button.qml文件，並且將我們的代碼拷貝了進去。我們在根級添加一個屬性導出方便使用者修改它。

我們在根級導出了文本和點擊信號。通常我們命名根元素為root讓引用更加方便。我們使用了QML的alias（別名）的功能，它可以將內部嵌套的QML元素的屬性導出到外面使用。有一點很重要，只有根級目錄的屬性才能夠被其它文件的組件訪問。

```
// Button.qml

import QtQuick 2.0

Rectangle {
    id: root
    // export button properties
    property alias text: label.text
    signal clicked

    width: 116; height: 26
    color: "lightsteelblue"
    border.color: "slategrey"

    Text {
        id: label
        anchors.centerIn: parent
        text: "Start"
    }
    MouseArea {
        anchors.fill: parent
        onClicked: {
            root.clicked()
        }
    }
}
```

使用我們新的Button元素只需要在我們的文件中簡單的聲明一下就可以了，之前的例子將會被簡化。

```
    Button { // our Button component
        id: button
        x: 12; y: 12
        text: "Start"
        onClicked: {
            status.text = "Button clicked!"
        }
    }

    Text { // text changes when button was clicked
        id: status
        x: 12; y: 76
        width: 116; height: 26
        text: "waiting ..."
        horizontalAlignment: Text.AlignHCenter
    }
```

現在你可以在你的用戶界面代碼中隨意的使用Button{ ...}來作為按鈕了。一個真正的按鈕將更加復雜，比如提供按鍵反饋或者添加一些裝飾。

**注意**

**就個人而言，可以更進一步的使用基礎元素對象（Item）作為根元素。這樣可以防止用戶改變我們設計的按鈕的顏色，並且可以提供出更多相關控制的API（應用程序接口）。我們的目標是導出一個最小的API（應用程序接口）。實際上我們可以將根矩形框（Rectangle）替換為一個基礎元素（Item），然後將一個矩形框（Rectangle）嵌套在這個根元素（root item）就可以完成了。**

```
Item {
    id: root
    Rectangle {
        anchors.fill parent
        color: "lightsteelblue"
        border.color: "slategrey"
    }
    ...
}
```

使用這項技術可以很簡單的創建一系列可重用的組件。

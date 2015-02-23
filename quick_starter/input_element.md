# 輸入元素（Input Element）

我們已經使用過MouseArea（鼠標區域）作為鼠標輸入元素。這裡我們將更多的介紹關于鍵盤輸入的一些東西。我們開始介紹文本編輯的元素：TextInput（文本輸入）和TextEdit（文本編輯）。

## 4.7.1 文本輸入（TextInput）

文本輸入允許用戶輸入一行文本。這個元素支持使用正則表達式驗證器來限制輸入和輸入掩碼的模式設置。

```
// textinput.qml

import QtQuick 2.0

Rectangle {
    width: 200
    height: 80
    color: "linen"

    TextInput {
        id: input1
        x: 8; y: 8
        width: 96; height: 20
        focus: true
        text: "Text Input 1"
    }

    TextInput {
        id: input2
        x: 8; y: 36
        width: 96; height: 20
        text: "Text Input 2"
    }
}
```

![](http://qmlbook.org/_images/textinput.png)

用戶可以通過點擊TextInput來改變焦點。為了支持鍵盤改變焦點，我們可以使用KeyNavigation（按鍵向導）這個附加屬性。

```
// textinput2.qml

import QtQuick 2.0

Rectangle {
    width: 200
    height: 80
    color: "linen"

    TextInput {
        id: input1
        x: 8; y: 8
        width: 96; height: 20
        focus: true
        text: "Text Input 1"
        KeyNavigation.tab: input2
    }

    TextInput {
        id: input2
        x: 8; y: 36
        width: 96; height: 20
        text: "Text Input 2"
        KeyNavigation.tab: input1
    }
}
```

KeyNavigation（按鍵向導）附加屬性可以預先設置一個元素id綁定切換焦點的按鍵。

一個文本輸入元素（text input element）只顯示一個閃爍符和已經輸入的文本。用戶需要一些可見的修飾來鑑別這是一個輸入元素，例如一個簡單的矩形框。當你放置一個TextInput（文本輸入）在一個元素中時，你需要確保其它的元素能夠訪問它導出的大多數屬性。

我們提取這一段代碼作為我們自己的組件，稱作TLineEditV1用來重復使用。

```
// TLineEditV1.qml

import QtQuick 2.0

Rectangle {
    width: 96; height: input.height + 8
    color: "lightsteelblue"
    border.color: "gray"

    property alias text: input.text
    property alias input: input

    TextInput {
        id: input
        anchors.fill: parent
        anchors.margins: 4
        focus: true
    }
}
```

**注意**

**如果你想要完整的導出TextInput元素，你可以使用property alias input: input來導出這個元素。第一個input是屬性名字，第二個input是元素id。**

我們使用TLineEditV1組件重寫了我們的KeyNavigation（按鍵向導）的例子。

```
    Rectangle {
        ...
        TLineEditV1 {
            id: input1
            ...
        }
        TLineEditV1 {
            id: input2
            ...
        }
    }
```

![](http://qmlbook.org/_images/textinput3.png)

嘗試使用Tab按鍵來導航，你會發現焦點無法切換到input2上。這個例子中使用focus:true的方法不正確，這個問題是因為焦點被轉移到input2元素時，包含TlineEditV1的頂部元素接收了這個焦點並且沒有將焦點轉發給TextInput（文本輸入）。為了防止這個問題，QML提供了FocusScope（焦點區域）。

## 4.7.2 焦點區域（FocusScope）

一個焦點區域（focus scope）定義了如果焦點區域接收到焦點，它的最後一個使用focus:true的子元素接收焦點，它將會把焦點傳遞給最後申請焦點的子元素。我們創建了第二個版本的TLineEdit組件，稱作TLineEditV2，使用焦點區域（focus scope）作為根元素。

```
// TLineEditV2.qml

import QtQuick 2.0

FocusScope {
    width: 96; height: input.height + 8
    Rectangle {
        anchors.fill: parent
        color: "lightsteelblue"
        border.color: "gray"

    }

    property alias text: input.text
    property alias input: input

    TextInput {
        id: input
        anchors.fill: parent
        anchors.margins: 4
        focus: true
    }
}
```

現在我們的例子將像下面這樣：

```
    Rectangle {
        ...
        TLineEditV2 {
            id: input1
            ...
        }
        TLineEditV2 {
            id: input2
            ...
        }
    }
```

按下Tab按鍵可以成功的在兩個組件之間切換焦點，並且能夠正確的將焦點鎖定在組件內部的子元素中。

## 4.7.3 文本編輯（TextEdit）

文本編輯（TextEdit）元素與文本輸入（TextInput）非常類似，它支持多行文本編輯。它不再支持文本輸入的限制，但是提供了已繪制文本的大小查詢（paintedHeight，paintedWidth）。我們也創建了一個我們自己的組件TTextEdit，可以編輯它的背景，使用focus scope（焦點區域）來更好的切換焦點。

```
// TTextEdit.qml

import QtQuick 2.0

FocusScope {
    width: 96; height: 96
    Rectangle {
        anchors.fill: parent
        color: "lightsteelblue"
        border.color: "gray"

    }

    property alias text: input.text
    property alias input: input

    TextEdit {
        id: input
        anchors.fill: parent
        anchors.margins: 4
        focus: true
    }
}
```

你可以像下面這樣使用這個組件：

```
// textedit.qml

import QtQuick 2.0

Rectangle {
    width: 136
    height: 120
    color: "linen"

    TTextEdit {
        id: input
        x: 8; y: 8
        width: 120; height: 104
        focus: true
        text: "Text Edit"
    }
}
```

![](http://qmlbook.org/_images/textedit.png)

## 4.7.4 按鍵元素（Key Element）

附加屬性key允許你基于某個按鍵的點擊來執行代碼。例如使用up，down按鍵來移動一個方塊，left，right按鍵來旋轉一個元素，plus，minus按鍵來縮放一個元素。

```
// keys.qml

import QtQuick 2.0

DarkSquare {
    width: 400; height: 200

    GreenSquare {
        id: square
        x: 8; y: 8
    }
    focus: true
    Keys.onLeftPressed: square.x -= 8
    Keys.onRightPressed: square.x += 8
    Keys.onUpPressed: square.y -= 8
    Keys.onDownPressed: square.y += 8
    Keys.onPressed: {
        switch(event.key) {
            case Qt.Key_Plus:
                square.scale += 0.2
                break;
            case Qt.Key_Minus:
                square.scale -= 0.2
                break;
        }

    }
}
```

![](http://qmlbook.org/_images/keys.png)

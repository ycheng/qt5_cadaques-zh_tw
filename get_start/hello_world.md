# 你好世界（Hello World）

為了測試你的安裝，我們創建一個簡單的應用程序hello world.打開Qt Creator並且創建一個Qt Quick UI Project（File->New File 或者 Project-> Qt Quick Project -> Qt Quick UI）並且給項目取名 HelloWorld。

**注意**

**Qt Creator集成開發環境允許你創建不同類型的應用程序。如果沒有另外說明，我們都創建Qt Quick UI Project。**

**提示**

**一個典型的Qt Quick應用程序在運行時解釋，與本地插件或者本地代碼在運行時解釋代碼一樣。對于才開始的我們不需要關注本地端的解釋開發，只需要把注意力集中在Qt5運行時的方面。**

Qt Creator將會為我們創建幾個文件。HellWorld.qmlproject文件是項目文件，保存了項目的配置信息。這個文件由Qt Creator管理，我們不需要編輯它。

另一個文件HelloWorld.qml保存我們應用程序的代碼。打開它，並且嘗試想想這個應用程序要做什麼，然後再繼續讀下去。

```
// HelloWorld.qml

import QtQuick 2.0

Rectangle {
    width: 360
    height: 360
    Text {
        anchors.centerIn: parent
        text: "Hello World"
    }
    MouseArea {
        anchors.fill: parent
        onClicked: {
            Qt.quit();
        }
    }
}
```

HelloWorld.qml使用QML語言來編寫。我們將在下一章更深入的討論QML語言，現在只需要知道它描述了一系列有層次的用戶界面。這個代碼指定了顯示一個360乘以360像素的一個矩形，矩形中間有一個“Hello World"的文本。鼠標區域覆蓋了整個矩形，當用戶點擊它時，程序就會退出。

你自己可以運行這個應用程序，點擊左邊的運行或者從菜單選擇select Bulid->Run。

如果一切順利，你將看到下面這個窗口：

![](http://qmlbook.org/_images/example.png)

Qt 5似乎已經可以工作了，我們接著繼續。

**建議**

**如果你是一個名系統集成人員，你會想要安裝最新穩定的Qt版本，將這個Qt版本的源代碼編譯到你特定的目標機器上。**

**從頭開始構建**

如果你想使用命令行的方式構建Qt5，你首先需要拷貝一個代碼庫並構建他。

```
git clone git://gitorious.org/qt/qt5.git
cd qt5
./init-repository
./configure -prefix $PWD/qtbase -opensource
make -j4
```

等待兩杯咖啡的時間編譯完成後，qtbase文件夾中將會出現可以使用的Qt5。任何飲料都好，不過我喜歡喝著咖啡等待最好的結果。

如果你想測試你的編譯，只需簡單的啟動qtbase/bin/qmlscene並且選擇一個QtQuick的例子運行，或者跟著我們進入下一章。

為了測試你的安裝，我們創建了一個簡單的hello world應用程序。創建一個空的qml文件example1.qml，使用你最喜愛的文本編輯器並且粘貼一下內容：

```
// HelloWorld.qml

import QtQuick 2.0

Rectangle {
    width: 360
    height: 360
    Text {
        anchors.centerIn: parent
        text: "Greetings from Qt5"
    }
    MouseArea {
        anchors.fill: parent
        onClicked: {
            Qt.quit();
        }
    }
}
```

你現在使用來自Qt5的默認運行環境來可以運行這個例子：

```
$ qtbase/bin/qmlscene
```

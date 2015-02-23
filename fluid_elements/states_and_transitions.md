# 狀態與過渡（States and Transitions）

通常我們將用戶界面描述為一種狀態。一個狀態定義了一組屬性的改變，並且會在一定的條件下被觸發。另外在這些狀態轉化的過程中可以有一個過渡，定義了這些屬性的動畫或者一些附加的動作。當進入一個新的狀態時，動作也可以被執行。

## 5.2.1 狀態（States）

在QML中，使用State元素來定義狀態，需要與基礎元素對象（Item）的states序列屬性連接。狀態通過它的狀態名來鑑別，由組成它的一系列簡單的屬性來改變元素。默認的狀態在初始化元素屬性時定義，並命名為“”（一個空的字符串）。

```
    Item {
        id: root
        states: [
            State {
                name: "go"
                PropertyChanges { ... }
            },
            State {
                name: "stop"
                PropertyChanges { ... }
            }
        ]
    }
```

狀態的改變由分配一個元素新的狀態屬性名來完成。

**注意**

**另一種切換屬性的方法是使用狀態元素的when屬性。when屬性能夠被設置為一個表達式的結果，當結果為true時，狀態被使用**。

```
    Item {
        id: root
        states: [
            ...
        ]

        Button {
            id: goButton
            ...
            onClicked: root.state = "go"
        }
    }
```

![](http://qmlbook.org/_images/trafficlight_sketch.png)

例如一個交通信號燈有兩個信號燈。上面的一個信號燈使用紅色，下面的信號燈使用綠色。在這個例子中，兩個信號燈不會同時發光。讓我們看看狀態圖。

![](http://qmlbook.org/_images/trafficlight_states.png)

當系統啟動時，它會自動切換到停止模式作為默認狀態。停止狀態改變了light1為紅色並且light2為黑色（關閉）。一個外部的事件能夠觸發現在的狀態變換為“go”狀態。在go狀態下，我們改變顏色屬性，light1變為黑色（關閉），light2變為綠色。

為了實現這個方案，我們給這兩個燈繪制一個用戶界面的草圖，為了簡單起見，我們使用兩個包含園邊的矩形框，設置園半徑為寬度的一半（寬度與高度相同）。

```
    Rectangle {
        id: light1
        x: 25; y: 15
        width: 100; height: width
        radius: width/2
        color: "black"
    }

    Rectangle {
        id: light2
        x: 25; y: 135
        width: 100; height: width
        radius: width/2
        color: "black"
    }
```

就像在狀態圖中定義的一樣，我們有一個“go”狀態和一個“stop”狀態，它們將會分別將交通燈改變為紅色和綠色。我們設置state屬性到stop來確保初始化狀態為stop狀態。

**注意**

**我們可以只使用“go”狀態來達到同樣的效果，設置顏色light1為紅色，顏色light2為黑色。初始化狀態“”（空字符串）定義初始化屬性，並且扮演類似“stop”狀態的角色。**

```
    state: "stop"

    states: [
        State {
            name: "stop"
            PropertyChanges { target: light1; color: "red" }
            PropertyChanges { target: light2; color: "black" }
        },
        State {
            name: "go"
            PropertyChanges { target: light1; color: "black" }
            PropertyChanges { target: light2; color: "green" }
        }
    ]
```

PropertyChanges{ target: light2; color: "black" }在這個例子中不是必要的，因為light2初始化顏色已經是黑色了。在一個狀態中，只需要描述屬性如何從它們的默認狀態改變（而不是前一個狀態的改變）。

使用鼠標區域覆蓋整個交通燈，並且綁定在點擊時切換go和stop狀態。

```
    MouseArea {
        anchors.fill: parent
        onClicked: parent.state = (parent.state == "stop"? "go" : "stop")
    }
```

![](http://qmlbook.org/_images/trafficlight_ui.png)

我們現在已經成功實現了交通燈的狀態切換。為了讓用戶界面看起來更加自然，我們需要使用動畫效果來增加一些過渡。一個過渡能夠被狀態的改變觸發。

**注意**

**可以使用一個簡單邏輯的腳本來替換QML狀態。開發人員很容易落入這種陷阱，寫的代碼更像一個JavaScript程序而不是一個QML程序。**

## 5.2.2 過渡（Transitions）

一系列的過渡能夠被加入任何元素，一個過渡由狀態的改變觸發執行。你可以使用屬性的from:和to:來定義狀態改變的指定過渡。這兩個屬性就像一個過濾器，當過濾器為true時，過渡生效。你也可以使用“*”來表示任何狀態。例如from:"*"; to:"*"表示從任一狀態到另一個任一狀態的默認值，這意味著過渡用于每個狀態的切換。

在這個例子中，我們期望從狀態“go”到“stop”轉換時實現一個顏色改變的動畫。對于從“stop”到“go”狀態的改變，我們期望保持顏色的直接改變，不使用過渡。我們使用from和to來限制過渡只在從“go”到“stop”時生效。在過渡中我們給每個燈添加兩個顏色的動畫，這個動畫將按照狀態的描述來改變屬性。

```
    transitions: [
        Transition {
            from: "stop"; to: "go"
            ColorAnimation { target: light1; properties: "color"; duration: 2000 }
            ColorAnimation { target: light2; properties: "color"; duration: 2000 }
        }
    ]
```

你可以點擊用戶界面來改變狀態。試試點擊用戶界面，當狀態從“stop”到“go”時，你將會發現改變立刻發生了。

![](http://qmlbook.org/_images/trafficlight_transition.png)

接下來，你可以修改下這個例子，例如縮小未點亮的等來突出點亮的等。為此，你需要在狀態中添加一個屬性用來縮放，並且操作一個動畫來播放縮放屬性的過渡。另一個選擇是可以添加一個“attention”狀態，燈會出現黃色閃爍，為此你需要添加為這個過渡添加一個一秒連續的動畫來顯示黃色（使用“to”屬性來實現，一秒後變為黑色）。也許你也可以改變緩衝曲線來使這個例子更加生動。

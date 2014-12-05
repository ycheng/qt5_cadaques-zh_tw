# 動畫（Animations）

動畫被用于屬性的改變。一個動畫定義了屬性值改變的曲線，將一個屬性值變化從一個值過渡到另一個值。動畫是由一連串的目標屬性活動定義的，平緩的曲線算法能夠引發一個定義時間內屬性的持續變化。所有在QtQuick中的動畫都由同一個計時器來控制，因此它們始終都保持同步，這也提高了動畫的性能和顯示效果。

**注意**

**動畫控制了屬性的改變，也就是值的插入。這是一個基本的概念，QML是基于元素，屬性與腳本的。每一個元素都提供了許多的屬性，每一個屬性都在等待使用動畫。在這本書中你將會看到這是一個壯闊的場景，你會發現你自己在看一些動畫時欣賞它們的美麗並且肯定自己的創造性想法。然後請記住：動畫控制了屬性的改變，每個元素都有大量的屬性供你任意使用。**

![](http://qmlbook.org/_images/animation.png)

```
// animation.qml

import QtQuick 2.0

Image {
    source: "assets/background.png"

    Image {
        x: 40; y: 80
        source: "assets/rocket.png"

        NumberAnimation on x {
            to: 240
            duration: 4000
            loops: Animation.Infinite
        }
        RotationAnimation on rotation {
            to: 360
            duration: 4000
            loops: Animation.Infinite
        }
    }
}
```

上面這個例子在x坐標和旋轉屬性上應用了一個簡單的動畫。每一次動畫持續4000毫秒並且永久循環。x軸坐標動畫展示了火箭的x坐標逐漸移至240，旋轉動畫展示了當前角度到360度的旋轉。兩個動畫同時運行，並且在加載用戶界面完成後開始。

現在你可以通過to屬性和duration屬性來實現動畫效果。或者你可以在opacity或者scale上添加動畫作為例子，集成這兩個參數，你可以實現火箭逐漸消失在太空中，試試吧!

## 5.1.1 動畫元素（Animation Elements）

有幾種類型的動畫，每一種都在特定情況下都有最佳的效果，下面列出了一些常用的動畫：

* PropertyAnimation（屬性動畫）- 使用屬性值改變播放的動畫

* NumberAnimation（數字動畫）- 使用數字改變播放的動畫

* ColorAnimation（顏色動畫）- 使用顏色改變播放的動畫

* RotationAnimation（旋轉動畫）- 使用旋轉改變播放的動畫

除了上面這些基本和通常使用的動畫元素，QtQuick還提供了一切特殊場景下使用的動畫：

* PauseAnimation（停止動畫）- 運行暫停一個動畫

* SequentialAnimation（順序動畫）- 允許動畫有序播放

* ParallelAnimation（並行動畫）- 允許動畫同時播放

* AnchorAnimation（錨定動畫）- 使用錨定改變播放的動畫

* ParentAnimation（父元素動畫）- 使用父對象改變播放的動畫

* SmotthedAnimation（平滑動畫）- 跟蹤一個平滑值播放的動畫

* SpringAnimation（彈簧動畫）- 跟蹤一個彈簧變換的值播放的動畫

* PathAnimation（路徑動畫）- 跟蹤一個元素對象的路徑的動畫

* Vector3dAnimation（3D容器動畫）- 使用QVector3d值改變播放的動畫

我們將在後面學習怎樣創建一連串的動畫。當使用更加復雜的動畫時，我們可能需要在播放一個動畫時中改變一個屬性或者運行一個腳本。對于這個問題，QtQuick提供了一個動作元素：

* PropertyAction（屬性動作）- 在播放動畫時改變屬性

* ScriptAction（腳本動作）- 在播放動畫時運行腳本

在這一章中我們將會使用一些小的例子來討論大多數類型的動畫。

## 5.1.2 應用動畫（Applying Animations）

動畫可以通過以下幾種方式來應用：

* 屬性動畫 - 在元素完整加載後自動運行

* 屬性動作 - 當屬性值改變時自動運行

* 獨立運行動畫 - 使用start()函數明確指定運行或者running屬性被設置為true（比如通過屬性綁定）

後面我們會談論如何在狀態變換時播放動畫。

**擴展可點擊圖像元素版本2（ClickableImage Version2）**

為了演示動畫的使用方法，我們重新實現了ClickableImage組件並且使用了一個文本元素（Text Element）來擴展它。

```
// ClickableImageV2.qml
// Simple image which can be clicked

import QtQuick 2.0

Item {
    id: root
    width: container.childrenRect.width
    height: container.childrenRect.height
    property alias text: label.text
    property alias source: image.source
    signal clicked

    Column {
        id: container
        Image {
            id: image
        }
        Text {
            id: label
            width: image.width
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            color: "#111111"
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.clicked()
    }
}
```

為了給圖片下面的元素定位，我們使用了Column（列）定位器，並且使用基于列的子矩形（childRect）屬性來計算它的寬度和高度（width and height）。我們導出了文本（text）和圖形源（source）屬性，一個點擊信號（clicked signal）。我們使用文本元素的wrapMode屬性來設置文本與圖像一樣寬並且可以自動換行。

**注意**

**由于幾何依賴關系的反向（父幾何對象依賴于子幾何對象）我們不能對ClickableImageV2設置寬度/高度（width/height），因為這樣將會破壞我們已經做好的屬性綁定。這是我們內部設計的限制，作為一個設計組件的人你需要明白這一點。通常我們更喜歡內部幾何圖像依賴于父幾何對象。**

![](http://qmlbook.org/_images/animationtypes_start.png)

三個火箭位于相同的y軸坐標（y = 200）。它們都需要移動到y = 40。每一個火箭都使用了一種的方法來完成這個功能。

```
    ClickableImageV3 {
        id: rocket1
        x: 40; y: 200
        source: "assets/rocket2.png"
        text: "animation on property"
        NumberAnimation on y {
            to: 40; duration: 4000
        }
    }
```

**第一個火箭**


第一個火箭使用了Animation on <property>屬性變化的策略來完成。動畫會在加載完成後立即播放。點擊火箭可以重置它回到開始的位置。在動畫播放時重置第一個火箭不會有任何影響。在動畫開始前的幾分之一秒設置一個新的y軸坐標讓人感覺挺不安全的，應當避免這樣的屬性值競爭的變化。

```
    ClickableImageV3 {
        id: rocket2
        x: 152; y: 200
        source: "assets/rocket2.png"
        text: "behavior on property"
        Behavior on y {
            NumberAnimation { duration: 4000 }
        }

        onClicked: y = 40
        // random y on each click
    //        onClicked: y = 40+Math.random()*(205-40)
    }
```

**第二個火箭**

第二個火箭使用了behavior on <property>屬性行為策略的動畫。這個行為告訴屬性值每時每刻都在變化，通過動畫的方式來改變這個值。可以使用行為元素的enabled : false來設置行為失效。當你點擊這個火箭時它將會開始運行（y軸坐標逐漸移至40）。然後其它的點擊對于位置的改變沒有任何的影響。你可以試著使用一個隨機值（例如 40+(Math.random()*(205-40)）來設置y軸坐標。你可以發現動畫始終會將移動到新位置的時間匹配在4秒內完成。

```
    ClickableImageV3 {
        id: rocket3
        x: 264; y: 200
        source: "assets/rocket2.png"
        onClicked: anim.start()
    //        onClicked: anim.restart()

        text: "standalone animation"

        NumberAnimation {
            id: anim
            target: rocket3
            properties: "y"
            from: 205
            to: 40
            duration: 4000
        }
    }
```

**第三個火箭**

第三個火箭使用standalone animation獨立動畫策略。這個動畫由一個私有的元素定義並且可以寫在文檔的任何地方。點擊火箭調用動畫函數start()來啟動動畫。每一個動畫都有start()，stop()，resume()，restart()函數。這個動畫自身可以比其他類型的動畫更早的獲取到更多的相關信息。我們只需要定義目標和目標元素的屬性需要怎樣改變的一個動畫。我們定義一個to屬性的值，在這個例子中我們也定義了一個from屬性的值允許動畫可以重復運行。

![](http://qmlbook.org/_images/animationtypes.png)

點擊背景能夠重新設置所有的火箭回到它們的初始位置。第一個火箭無法被重置，只有重啟程序重新加載元素才能重置它。

**注意**

**另一個啟動/停止一個動畫的方法是綁定一個動畫的running屬性。當需要用戶輸入控制屬性時這種方法非常有用：**

```
    NumberAnimation {
        ...
        // animation runs when mouse is pressed
        running: area.pressed
    }
    MouseArea {
        id: area
    }
```

## 5.1.3 緩衝曲線（Easing Curves）

屬性值的改變能夠通過一個動畫來控制，緩衝曲線屬性影響了一個屬性值改變的插值算法。我們現在已經定義的動畫都使用了一種線性的插值算法，因為一個動畫的默認緩衝類型是Easing.Linear。在一個小場景下的x軸與y軸坐標改變可以得到最好的視覺效果。一個線性插值算法將會在動畫開始時使用from的值到動畫結束時使用的to值繪制一條直線，所以緩衝類型定義了曲線的變化情況。精心為一個移動的對象挑選一個合適的緩衝類型將會使界面更加自然，例如一個頁面的滑出，最初使用緩慢的速度滑出，然後在最後滑出時使用高速滑出，類似翻書一樣的效果。

**注意**

**不要過度的使用動畫。用戶界面動畫的設計應該盡量小心，動畫是讓界面更加生動而不是充滿整個界面。眼睛對于移動的東西非常敏感，很容易幹擾用戶的使用。**

在下面的例子中我們將會使用不同的緩衝曲線，每一種緩衝曲線都都使用了一個可點擊圖片來展示，點擊將會在動畫中設置一個新的緩衝類型並且使用這種曲線重新啟動動畫。

![](http://qmlbook.org/_images/easingtypes.png)

**擴展可點擊圖像V3（ClickableImage V3）**

我們給圖片和文本添加了一個小的外框來增強我們的ClickableImage。添加一個屬性property bool framed: false來作為我們的API，基于framed的值我們能夠設置這個框是否可見，並且不破壞之前用戶的使用。下面是我們做的修改。

```
// ClickableImageV2.qml
// Simple image which can be clicked

import QtQuick 2.0

Item {
    id: root
    width: container.childrenRect.width + 16
    height: container.childrenRect.height + 16
    property alias text: label.text
    property alias source: image.source
    signal clicked

    // M1>>
    // ... add a framed rectangle as container
    property bool framed : false

    Rectangle {
        anchors.fill: parent
        color: "white"
        visible: root.framed
    }
```

這個例子的代碼非常簡潔。我們使用了一連串的緩衝曲線的名稱（property variant easings）並且在一個Repeater（重復元素）中將它們分配給一個ClickableImage。圖片的源路徑通過一個命名方案來定義，一個叫做“InQuad”的緩衝曲線在“curves/InQuad.png”中有一個對應的圖片。如果你點擊一個曲線圖，這個點擊將會分配一個緩衝類型給動畫然後重新啟動動畫。動畫自身是用來設置方塊的x坐標屬性在2秒內變化的獨立動畫。

```
// easingtypes.qml

import QtQuick 2.0

DarkSquare {
    id: root
    width: 600
    height: 340

    // A list of easing types
    property variant easings : [
        "Linear", "InQuad", "OutQuad", "InOutQuad",
        "InCubic", "InSine", "InCirc", "InElastic",
        "InBack", "InBounce" ]


    Grid {
        id: container
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 16
        height: 200
        columns: 5
        spacing: 16
        // iterates over the 'easings' list
        Repeater {
            model: easings
            ClickableImageV3 {
                framed: true
                // the current data entry from 'easings' list
                text: modelData
                source: "curves/" + modelData + ".png"
                onClicked: {
                    // set the easing type on the animation
                    anim.easing.type = modelData
                    // restart the animation
                    anim.restart()
                }
            }
        }
    }

    // The square to be animated
    GreenSquare {
        id: square
        x: 40; y: 260
    }

    // The animation to test the easing types
    NumberAnimation {
        id: anim
        target: square
        from: 40; to: root.width - 40 - square.width
        properties: "x"
        duration: 2000
    }
}
```

當你運行這個例子時，請注意觀察動畫的改變速度。一些動畫對于這個對象看起來很自然，一些看起來非常惱火。

除了duration屬性與easing.type屬性，你也可以對動畫進行微調。例如PropertyAnimation屬性，大多數動畫都支持附加的easing.amplitude（緩衝振幅），easing.overshoot（緩衝溢出），easing.period（緩衝週期），這些屬性允許你對個別的緩衝曲線進行微調。不是所有的緩衝曲線都支持這些參數。可以查看Qt PropertyAnimation文檔中的緩衝列表（easing table）來查看一個緩衝曲線的相關參數。

**注意**

**對于用戶界面正確的動畫非常重要。請記住動畫是幫助用戶界面更加生動而不是刺激用戶的眼睛。**

## 5.1.4 動畫分組（Grouped Animations）

通常使用的動畫比一個屬性的動畫更加復雜。例如你想同時運行幾個動畫並把他們連接起來，或者在一個一個的運行，或者在兩個動畫之間執行一個腳本。動畫分組提供了很好的幫助，作為命名建議可以叫做一組動畫。有兩種方法來分組：平行與連續。你可以使用SequentialAnimation（連續動畫）和ParallelAnimation（平行動畫）來實現它們，它們作為動畫的容器來包含其它的動畫元素。

![](http://qmlbook.org/_images/groupedanimation.png)

當開始時，平行元素的所有子動畫都會平行運行，它允許你在同一時間使用不同的屬性來播放動畫。

```
// parallelanimation.qml
import QtQuick 2.0

BrightSquare {
    id: root
    width: 300
    height: 200
    property int duration: 3000

    ClickableImageV3 {
        id: rocket
        x: 20; y: 120
        source: "assets/rocket2.png"
        onClicked: anim.restart()
    }

    ParallelAnimation {
        id: anim
        NumberAnimation {
            target: rocket
            properties: "y"
            to: 20
            duration: root.duration
        }
        NumberAnimation {
            target: rocket
            properties: "x"
            to: 160
            duration: root.duration
        }
    }
}
```

![](http://qmlbook.org/_images/parallelanimation_sequence.png)

一個連續的動畫將會一個一個的運行子動畫。

```
// sequentialanimation.qml
import QtQuick 2.0

BrightSquare {
    id: root
    width: 300
    height: 200
    property int duration: 3000

    ClickableImageV3 {
        id: rocket
        x: 20; y: 120
        source: "assets/rocket2.png"
        onClicked: anim.restart()
    }

    SequentialAnimation {
        id: anim
        NumberAnimation {
            target: rocket
            properties: "y"
            to: 20
            // 60% of time to travel up
            duration: root.duration*0.6
        }
        NumberAnimation {
            target: rocket
            properties: "x"
            to: 160
            // 40% of time to travel sideways
            duration: root.duration*0.4
        }
    }
}
```

![](http://qmlbook.org/_images/sequentialanimation_sequence.png)

分組動畫也可以被嵌套，例如一個連續動畫可以擁有兩個平行動畫作為子動畫。我們來看看這個足球的例子。這個動畫描述了一個從左向右扔一個球的行為：

![](http://qmlbook.org/_images/soccer_init.png)

要弄明白這個動畫我們需要剖析這個目標的運動過程。我們需要記住這個動畫是通過屬性變化來實現的動畫，下面是不同部分的轉換：

* 從左向右的x坐標轉換（X1）。

* 從下往上的y坐標轉換（Y1）然後跟著一個從上往下的Y坐標轉換（Y2）。

* 整個動畫過程中360度旋轉。

這個動畫將會花掉3秒鐘的時間。

![](http://qmlbook.org/_images/soccer_plan.png)

我們使用一個空的基本元素對象（Item）作為根元素，它的寬度為480，高度為300。

```
import QtQuick 1.1

Item {
    id: root
    width: 480
    height: 300
    property int duration: 3000

    ...
}
```

我們定義動畫的總持續時間作為參考，以便更好的同步各部分的動畫。

下一步我們需需要添加一個背景，在我們這個例子中有兩個矩形框分別使用了綠色漸變和藍色漸變填充。

```
    Rectangle {
        id: sky
        width: parent.width
        height: 200
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#0080FF" }
            GradientStop { position: 1.0; color: "#66CCFF" }
        }
    }
    Rectangle {
        id: ground
        anchors.top: sky.bottom
        anchors.bottom: root.bottom
        width: parent.width
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#00FF00" }
            GradientStop { position: 1.0; color: "#00803F" }
        }
    }
```

![](http://qmlbook.org/_images/soccer_stage1.png)

上面部分的藍色區域高度為200像素，下面部分的區域使用上面的藍色區域的底作為錨定的頂，使用根元素的底作為底。

讓我們將足球加入到屏幕上，足球是一個圖片，位于路徑“assets/soccer_ball.png”。首先我們需要將它放置在左下角接近邊界處。

```
    Image {
        id: ball
        x: 20; y: 240
        source: "assets/soccer_ball.png"

        MouseArea {
            anchors.fill: parent
            onClicked: {
                ball.x = 20; ball.y = 240
                anim.restart()
            }
        }
    }
```

![](http://qmlbook.org/_images/soccer_stage2.png)

圖片與鼠標區域連接，點擊球將會重置球的狀態，並且動畫重新開始。

首先使用一個連續的動畫來播放兩次的y軸變換。

```
    SequentialAnimation {
        id: anim
        NumberAnimation {
            target: ball
            properties: "y"
            to: 20
            duration: root.duration * 0.4
        }
        NumberAnimation {
            target: ball
            properties: "y"
            to: 240
            duration: root.duration * 0.6
        }
    }
```

![](http://qmlbook.org/_images/soccer_stage3.png)

在動畫總時間的40%的時間裡完成上升部分，在動畫總時間的60%的時間裡完成下降部分，一個動畫完成後播放下一個動畫。目前還沒有使用任何緩衝曲線。緩衝曲線將在後面使用easing curves來添加，現在我們只關心如何使用動畫來完成過渡。

現在我們需要添加x軸坐標轉換。x軸坐標轉換需要與y軸坐標轉換同時進行，所以我們需要將y軸坐標轉換的連續動畫和x軸坐標轉換一起壓縮進一個平行動畫中。

```
    ParallelAnimation {
        id: anim
        SequentialAnimation {
            // ... our Y1, Y2 animation
        }
        NumberAnimation { // X1 animation
            target: ball
            properties: "x"
            to: 400
            duration: root.duration
        }
    }
```

![](http://qmlbook.org/_images/soccer_stage4.png)

最後我們想要旋轉這個球，我們需要向平行動畫中添加一個新的動畫，我們選擇RotationAnimation來實現旋轉。

```
    ParallelAnimation {
        id: anim
        SequentialAnimation {
            // ... our Y1, Y2 animation
        }
        NumberAnimation { // X1 animation
            // X1 animation
        }
        RotationAnimation {
            target: ball
            properties: "rotation"
            to: 720
            duration: root.duration
        }
    }
```

我們已經完成了整個動畫鏈表，然後我們需要給動畫提供一個正確的緩衝曲線來描述一個移動的球。對于Y1動畫我們使用Easing.OutCirc緩衝曲線，它看起來更像是一個圓週運動。Y2使用了Easing.OutBounce緩衝曲線，因為在最後球會發生反彈。（試試使用Easing.InBounce，你會發現反彈將會立刻開始。）。X1和ROT1動畫都使用線性曲線。

下面是這個動畫最後的代碼，提供給你作為參考：

```
    ParallelAnimation {
        id: anim
        SequentialAnimation {
            NumberAnimation {
                target: ball
                properties: "y"
                to: 20
                duration: root.duration * 0.4
                easing.type: Easing.OutCirc
            }
            NumberAnimation {
                target: ball
                properties: "y"
                to: 240
                duration: root.duration * 0.6
                easing.type: Easing.OutBounce
            }
        }
        NumberAnimation {
            target: ball
            properties: "x"
            to: 400
            duration: root.duration
        }
        RotationAnimation {
            target: ball
            properties: "rotation"
            to: 720
            duration: root.duration * 1.1
        }
    }
```

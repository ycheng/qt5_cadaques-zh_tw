# QML語法（QML Syntax）

QML是一種描述用戶界面的聲明式語言。它將用戶界面分解成一些更小的元素，這些元素能夠結合成一個組件。QML語言描述了用戶界面元素的形狀和行為。用戶界面能夠使用JavaScript來提供修飾，或者增加更加復雜的邏輯。從這個角度來看它遵循HTML-JavaScript模式，但QML是被設計用來描述用戶界面的，而不是文本文檔。

從QML元素的層次結構來理解是最簡單的學習方式。子元素從父元素上繼承了坐標系統，它的x,y坐標總是相對應于它的父元素坐標系統。

![](http://qmlbook.org/_images/scene.png)

讓我們開始用一個簡單的QML文件例子來解釋這個語法。

```
// rectangle.qml

import QtQuick 2.0

// The root element is the Rectangle
Rectangle {
    // name this element root
    id: root

    // properties: <name>: <value>
    width: 120; height: 240

    // color property
    color: "#D8D8D8"

    // Declare a nested element (child of root)
    Image {
    	id: rocket

        // reference the parent
        x: (parent.width - width)/2; y: 40

        source: 'assets/rocket.png'
    }

    // Another child of root
    Text {
        // un-named element

        // reference element by id
        y: rocket.y + rocket.height + 20

        // reference root element
        width: root.width

        horizontalAlignment: Text.AlignHCenter
        text: 'Rocket'
    }
}
```

* import聲明導入了一個指定的模塊版本。一般來說會導入QtQuick2.0來作為初始元素的引用。

* 使用//可以單行注釋，使用/**/可以多行注釋，就像C/C++和JavaScript一樣。

* 每一個QML文件都需要一個根元素，就像HTML一樣。

* 一個元素使用它的類型聲明，然後使用{}進行包含。

* 元素擁有屬性，他們按照name:value的格式來賦值。

* 任何在QML文檔中的元素都可以使用它們的id進行訪問（id是一個任意的標識符）。

* 元素可以嵌套，這意味著一個父元素可以擁有多個子元素。子元素可以通過訪問parent關鍵字來訪問它們的父元素。

**建議**

**你會經常使用id或者關鍵字parent來訪問你的父對象。有一個比較好的方法是命名你的根元素對象id為root（id:root），這樣就不用去思考你的QML文檔中的根元素應該用什麼方式命名了。**

**提示**

**你可以在你的操作系統命令行模式下使用QtQuick運行環境來運行這個例子，比如像下面這樣：**

```
$ $QTDIR/bin/qmlscene rectangle.qml
```

將$QTDIR替換為你的Qt的安裝路徑。qmlscene會執行Qt Quick運行環境初始化，並且解釋這個QML文件。

在Qt Creator中你可以打開對應的項目文件然後運行rectangle.qml文檔。

## 4.1.1 屬性（Properties）

元素使用他們的元素類型名進行聲明，使用它們的屬性或者創建自定義屬性來定義。一個屬性對應一個值，例如 width:100，text: 'Greeting', color: '#FF0000'。一個屬性有一個類型定義並且需要一個初始值。

```
    Text {
        // (1) identifier
        id: thisLabel

        // (2) set x- and y-position
        x: 24; y: 16

        // (3) bind height to 2 * width
        height: 2 * width

        // (4) custom property
        property int times: 24

        // (5) property alias
        property alias anotherTimes: thisLabel.times

        // (6) set text appended by value
        text: "Greetings " + times

        // (7) font is a grouped property
        font.family: "Ubuntu"
        font.pixelSize: 24

        // (8) KeyNavigation is an attached property
        KeyNavigation.tab: otherLabel

        // (9) signal handler for property changes
        onHeightChanged: console.log('height:', height)

        // focus is neeed to receive key events
        focus: true

        // change color based on focus value
        color: focus?"red":"black"
    }
```

讓我們來看看不同屬性的特點：

1. id是一個非常特殊的屬性值，它在一個QML文件中被用來引用元素。id不是一個字符串，而是一個標識符和QML語法的一部分。一個id在一個QML文檔中是唯一的，並且不能被設置為其它值，也無法被查詢（它的行為更像C++世界裡的指針）。

2. 一個屬性能夠設置一個值，這個值依賴于它的類型。如果沒有對一個屬性賦值，那麼它將會被初始化為一個默認值。你可以查看特定的元素的文檔來獲得這些初始值的信息。

3. 一個屬性能夠依賴一個或多個其它的屬性，這種操作稱作屬性綁定。當它依賴的屬性改變時，它的值也會更新。這就像訂了一個協議，在這個例子中height始終是width的兩倍。

4. 添加自己定義的屬性需要使用property修飾符，然後跟上類型，名字和可選擇的初始化值（property <type> <name> : <value>）。如果沒有初始值將會給定一個系統初始值作為初始值。**注意如果屬性名與已定義的默認屬性名不重復，使用default關鍵字你可以將一個屬性定義為默認屬性。這在你添加子元素時用得著，如果他們是可視化的元素，子元素會自動的添加默認屬性的子類型鏈表（children property list）**。

5. 另一個重要的聲明屬性的方法是使用alias關鍵字（property alias <name> : <reference>）。alias關鍵字允許我們轉發一個屬性或者轉發一個屬性對象自身到另一個作用域。我們將在後面定義組件導出內部屬性或者引用根級元素id會使用到這個技術。一個屬性別名不需要類型，它使用引用的屬性類型或者對象類型。

6. text屬性依賴于自定義的timers（int整型數據類型）屬性。int整型數據會自動的轉換為string字符串類型數據。這樣的表達方式本身也是另一種屬性綁定的例子，文本結果會在times屬性每次改變時刷新。

7. 一些屬性是按組分配的屬性。當一個屬性需要結構化並且相關的屬性需要聯系在一起時，我們可以這樣使用它。另一個組屬性的編碼方式是 font{family: "UBuntu"; pixelSize: 24 }。

8. 一些屬性是元素自身的附加屬性。這樣做是為了全局的相關元素在應用程序中只出現一次（例如鍵盤輸入）。編碼方式<element>.<property>: <value> 。

9. 對于每個元素你都可以提供一個信號操作。這個操作在屬性值改變時被調用。例如這裡我們完成了當height（高度）改變時會使用控制台輸出一個信息。

**警告**

**一個元素id應該只在當前文檔中被引用。QML提供了動態作用域的機制，後加載的文檔會覆蓋之前加載文檔的元素id號，這樣就可以引用已加載並且沒有被覆蓋的元素id，這有點類似創建全局變量。但不幸的是這樣的代碼閱讀性很差。目前這個還沒有辦法解決這個問題，所以你使用這個機制的時候最好仔細一些甚至不要使用這種機制。如果你想向文檔外提供元素的調用，你可以在根元素上使用屬性導出的方式來提供。**

## 4.1.2 腳本（Scripting）

QML與JavaScript是最好的配合。在JavaScrpit的章節中我們將會更加詳細的介紹這種關系，現在我們只需要了解這種關系就可以了。

```
    Text {
        id: label

        x: 24; y: 24

        // custom counter property for space presses
        property int spacePresses: 0

        text: "Space pressed: " + spacePresses + " times"

        // (1) handler for text changes
        onTextChanged: console.log("text changed to:", text)

        // need focus to receive key events
        focus: true

        // (2) handler with some JS
        Keys.onSpacePressed: {
            increment()
        }

        // clear the text on escape
        Keys.onEscapePressed: {
            label.text = ''
        }

        // (3) a JS function
        function increment() {
            spacePresses = spacePresses + 1
        }
    }
```

1. 文本改變操作onTextChanged會將每次空格鍵按下導致的文本改變輸出到控制台。

2. 當文本元素接收到空格鍵操作（用戶在鍵盤上點擊空格鍵），會調用JavaScript函數increment()。

3. 定義一個JavaScript函數使用這種格式function (){....}，在這個例子中是增加spacePressed的計數。每次spacePressed的增加都會導致它綁定的屬性更新。

**注意**

**QML的：（屬性綁定）與JavaScript的=（賦值）是不同的。綁定是一個協議，並且存在于整個生命週期。然而JavaScript賦值（=）只會產生一次效果。當一個新的綁定生效或者使用JavaScript賦值給屬性時，綁定的生命週期就會結束。例如一個按鍵的操作設置文本屬性為一個空的字符串將會銷毀我們的增值顯示：**

```
Keys.onEscapePressed: {
    label.text = ''
}
```

**在點擊取消（ESC）後，再次點擊空格鍵（space-bar）將不會更新我們的顯示，之前的text屬性綁定（text: "Space pressed:" + spacePresses + "times")被銷毀。**

**當你對改變屬性的策略有衝突時（文本的改變基于一個增值的綁定並且可以被JavaScript賦值清零），類似于這個例子，你最好不要使用綁定屬性。你需要使用賦值的方式來改變屬性，屬性綁定會在賦值操作後被銷毀（銷毀協議！）。**


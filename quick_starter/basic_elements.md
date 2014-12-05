# 基本元素（Basic Elements）

元素可以被分為可視化元素與非可視化元素。一個可視化元素（例如矩形框Rectangle）有著幾何形狀並且可以在屏幕上顯示。一個非可視化元素（例如計時器Timer）提供了常用的功能，通常用于操作可視化元素。

現在我們將專注于幾個基礎的可視化元素，例如Item（基礎元素對象），Rectangle（矩形框），Text（文本），Image（圖像）和MouseArea（鼠標區域）。

## 4.2.1 基礎元素對象（Item Element）

Item（基礎元素對象）是所有可視化元素的基礎對象，所有其它的可視化元素都繼承自Item。它自身不會有任何繪制操作，但是定義了所有可視化元素共有的屬性：

| Group（分組） | 	Properties（屬性） |
| -- | -- |
| Geometry（幾何屬性） | x,y（坐標）定義了元素左上角的位置，width，height（長和寬）定義元素的顯示範圍，z（堆疊次序）定義元素之間的重疊順序。 |
| Layout handling（布局操作）| anchors（錨定），包括左（left），右（right），上（top），下（bottom），水平與垂直居中（vertical center，horizontal center），與margins（間距）一起定義了元素與其它元素之間的位置關系。 |
| Key handlikng（按鍵操作） | 附加屬性key（按鍵）和keyNavigation（按鍵定位）屬性來控制按鍵操作，處理輸入焦點（focus）可用操作。 |
| Transformation（轉換） | 縮放（scale）和rotate（旋轉）轉換，通用的x,y,z屬性列表轉換（transform），旋轉基點設置（transformOrigin）。 |
| Visual（可視化） | 不透明度（opacity）控制透明度，visible（是否可見）控制元素是否顯示，clip（裁剪）用來限制元素邊界的繪制，smooth（平滑）用來提高渲染質量。 |
| State definition（狀態定義） | states（狀態列表屬性）提供了元素當前所支持的狀態列表，當前屬性的改變也可以使用transitions（轉變）屬性列表來定義狀態轉變動畫。 |

為了更好的理解不同的屬性，我們將會在這章中盡量的介紹這些元素的顯示效果。請記住這些基本的屬性在所有可視化元素中都是可以使用的，並且在這些元素中的工作方式都是相同的。

**注意**

**Item（基本元素對象）通常被用來作為其它元素的容器使用，類似HTML語言中的div元素（div element）。**

## 4.2.2 矩形框元素（Rectangle Element）

Rectangle（矩形框）是基本元素對象的一個擴展，增加了一個顏色來填充它。它還支持邊界的定義，使用border.color（邊界顏色），border.width（邊界寬度）來自定義邊界。你可以使用radius（半徑）屬性來創建一個圓角矩形。

```
    Rectangle {
        id: rect1
        x: 12; y: 12
        width: 76; height: 96
        color: "lightsteelblue"
    }
    Rectangle {
        id: rect2
        x: 112; y: 12
        width: 76; height: 96
        border.color: "lightsteelblue"
        border.width: 4
        radius: 8
    }
```

![](http://qmlbook.org/_images/rectangle2.png)

**注意**

**顏色的命名是來自SVG顏色的名稱（查看[http://www.w3.org/TR/css3-color/#svg-color]( http://www.w3.org/TR/css3-color/#svg-color)可以獲取更多的顏色名稱）。你也可以使用其它的方法來指定顏色，比如RGB字符串（'#FF4444'），或者一個顏色名字（例如'white'）。**

此外，填充的顏色與矩形的邊框也支持自定義的漸變色。

```
    Rectangle {
        id: rect1
        x: 12; y: 12
        width: 176; height: 96
        gradient: Gradient {
            GradientStop { position: 0.0; color: "lightsteelblue" }
            GradientStop { position: 1.0; color: "slategray" }
        }
        border.color: "slategray"
    }
```

![](http://qmlbook.org/_images/rectangle3.png)

一個漸變色是由一系列的梯度值定義的。每一個值定義了一個位置與顏色。位置標記了y軸上的位置（0 = 頂，1 = 底）。GradientStop（傾斜點）的顏色標記了顏色的位置。

**注意**

**一個矩形框如果沒有width/height（寬度與高度）將不可見。如果你有幾個相互關聯width/height（寬度與高度）的矩形框，在你組合邏輯中出了錯後可能就會發生矩形框不可見，請注意這一點。**

**注意**

**這個函數無法創建一個梯形，最好使用一個已有的圖像來創建梯形。有一種可能是在旋轉梯形時，旋轉的矩形幾何結構不會發生改變，但是這會導致幾何元素相同的可見區域的混淆。從作者的觀點來看類似的情況下最好使用設計好的梯形圖形來完成繪制。**

## 4.2.3 文本元素（Text Element）

顯示文本你需要使用Text元素（Text Element）。它最值得注意的屬性時字符串類型的text屬性。這個元素會使用給出的text（文本）與font（字體）來計算初始化的寬度與高度。可以使用字體屬性組來（font property group）來改變當前的字體，例如font.family，font.pixelSize，等等。改變文本的顏色值只需要改變顏色屬性就可以了。

```
    Text {
        text: "The quick brown fox"
        color: "#303030"
        font.family: "Ubuntu"
        font.pixelSize: 28
    }
```

![](http://qmlbook.org/_images/text.png)

文本可以使用horizontalAlignment與verticalAlignment屬性來設置它的對齊效果。為了提高文本的渲染效果，你可以使用style和styleColor屬性來配置文字的外框效果，浮雕效果或者凹陷效果。對于過長的文本，你可能需要使用省略號來表示，例如A very ... long text，你可以使用elide屬性來完成這個操作。elide屬性允許你設置文本左邊，右邊或者中間的省略位置。如果你不想'....'省略號出現，並且希望使用文字換行的方式顯示所有的文本，你可以使用wrapMode屬性（這個屬性只在明確設置了寬度後才生效）：

```
Text {
    width: 40; height: 120
    text: 'A very long text'
    // '...' shall appear in the middle
    elide: Text.ElideMiddle
    // red sunken text styling
    style: Text.Sunken
    styleColor: '#FF4444'
    // align text to the top
    verticalAlignment: Text.AlignTop
    // only sensible when no elide mode
    // wrapMode: Text.WordWrap
}
```

一個text元素（text element）只顯示的文本，它不會渲染任何背景修飾。除了顯示的文本，text元素背景是透明的。為一個文本元素提供背景是你自己需要考慮的問題。

**注意**

**知道一個文本元素（Text Element）的初始寬度與高度是依賴于文本字符串和設置的字體這一點很重要。一個沒有設置寬度或者文本的文本元素（Text Element）將不可見，默認的初始寬度是0。**

**注意**

**通常你想要對文本元素布局時，你需要區分文本在文本元素內部的邊界對齊和由元素邊界自動對齊。前一種情況你需要使用horizontalAlignment和verticalAlignment屬性來完成，後一種情況你需要操作元素的幾何形狀或者使用anchors（錨定）來完成。**

## 4.2.4 圖像元素（Image Element）


一個圖像元素（Image Element）能夠顯示不同格式的圖像（例如PNG,JPG,GIF,BMP）。想要知道更加詳細的圖像格式支持信息，可以查看Qt的相關文檔。source屬性（source property）提供了圖像文件的鏈接信息，fillMode（文件模式）屬性能夠控制元素對象的大小調整行為。

```
    Image {
        x: 12; y: 12
        // width: 48
        // height: 118
        source: "assets/rocket.png"
    }
    Image {
        x: 112; y: 12
        width: 48
        height: 118/2
        source: "assets/rocket.png"
        fillMode: Image.PreserveAspectCrop
        clip: true
    }
```

![](http://qmlbook.org/_images/image.png)

**注意**

**一個URL可以是使用'/'語法的本地路徑（"./images/home.png"）或者一個網絡鏈接（"[http://example.org/home.png](http://example.org/home.png)"）。**

**注意**

**圖像元素（Image element）使用PreserveAspectCrop可以避免裁剪圖像數據被渲染到圖像邊界外。默認情況下裁剪是被禁用的（clip:false）。你需要打開裁剪（clip:true）來約束邊界矩形的繪制。這對任何可視化元素都是有效的。**

**建議**

**使用QQmlImageProvider你可以通過C++代碼來創建自己的圖像提供器，這允許你動態創建圖像並且使用線程加載。**

## 4.2.5 鼠標區域元素（MouseArea Element）


為了與不同的元素交互，你通常需要使用MouseArea（鼠標區域）元素。這是一個矩形的非可視化元素對象，你可以通過它來捕捉鼠標事件。當用戶與可視化端口交互時，mouseArea通常被用來與可視化元素對象一起執行命令。

```
    Rectangle {
        id: rect1
        x: 12; y: 12
        width: 76; height: 96
        color: "lightsteelblue"
        MouseArea {
            id: area
            width: parent.width
            height: parent.height
            onClicked: rect2.visible = !rect2.visible
        }
    }

    Rectangle {
        id: rect2
        x: 112; y: 12
        width: 76; height: 96
        border.color: "lightsteelblue"
        border.width: 4
        radius: 8
    }
```

![](http://qmlbook.org/_images/mousearea1.png)

![](http://qmlbook.org/_images/mousearea2.png)

**注意**

**這是QtQuick中非常重要的概念，輸入處理與可視化顯示分開。這樣你的交互區域可以比你顯示的區域大很多。**

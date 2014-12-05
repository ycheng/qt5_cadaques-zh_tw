# 高級用法（Advanced Techniques）

## 6.5.1 路徑視圖（The PathView）

路徑視圖（PathView）非常強大，但也非常復雜，這個視圖由QtQuick提供。它創建了一個可以讓子項沿著任意路徑移動的視圖。沿著相同的路徑，使用縮放（scale），透明（opacity）等元素可以更加詳細的控制過程。

當使用路徑視圖（PathView）時，你必須定義一個代理和一個路徑。在這些之上，路徑視圖（PathView）本身也可以自定義一些屬性的區間。通常會使用pathItemCount屬性，它控制了一次可見的子項總數。preferredHighLightBegin屬性控制了高亮區間，preferredHighlightEnd與highlightRangeMode，控制了當前項怎樣沿著路徑顯示。

在關注高亮區間之前，我們必須先看看路徑（path）這個屬性。路徑（path）屬性使用一個路徑（path）元素來定義路徑視圖（PathView）內代理的滾動路徑。路徑使用startx與starty屬性來鏈接路徑（path）元素，例如PathLine,PathQuad和PathCubic。這些元素都使用二維數組來構造路徑。

當路徑定義好之後，可以使用PathPercent和PathAttribute元素來進一步設置。它們被放置在路徑元素之間，並且為經過它們的路徑和代理提供更加細致的控制。PathPercent提供了如何控制每個元素之間覆蓋區域部分的路徑，然後反過來控制分布在這條路徑上的代理元素，它們被按比例的分布播放。

preferredHightlightBegin與preferredHighlightEnd屬性由PathView（路徑視圖）輸入到圖片元素中。它們的值在0~1之間。結束值大于等于開始值。例如設置這些屬性值為0.5，當前項只會顯示當前百分之50的圖像在這個路徑上。

在Path中，PathAttribute元素也是被放置在元素之間的，就像PathPercent元素。它們可以讓你指定屬性的值然後插入的路徑中去。這些屬性與代理綁定可以用來控制任意的屬性。

![](http://qmlbook.org/_images/pathview-coverview.png)

下面這個例子展示了路徑視圖（PathView）如何創建一個卡片視圖，並且用戶可以滑動它。我們使用了一些技巧來完成這個例子。路徑由PathLine元素組成。使用PathPercent元素，它確保了中間的元素居中，並且給其它的元素提供了足夠的空間。使用PathAttribute元素來控制旋轉，大小和深度值（z-value）。

在這個路徑之上（path），需要設置路徑視圖（PathView）的pathItemCount屬性。它控制了路徑的濃密度。路徑視圖的路徑（PathView.onPath）使用preferredHighlightBegin與preferredHighlightEnd來控制可見的代理項。

```
    PathView {
        anchors.fill: parent

        delegate: flipCardDelegate
        model: 100

        path: Path {
            startX: root.width/2
            startY: 0

            PathAttribute { name: "itemZ"; value: 0 }
            PathAttribute { name: "itemAngle"; value: -90.0; }
            PathAttribute { name: "itemScale"; value: 0.5; }
            PathLine { x: root.width/2; y: root.height*0.4; }
            PathPercent { value: 0.48; }
            PathLine { x: root.width/2; y: root.height*0.5; }
            PathAttribute { name: "itemAngle"; value: 0.0; }
            PathAttribute { name: "itemScale"; value: 1.0; }
            PathAttribute { name: "itemZ"; value: 100 }
            PathLine { x: root.width/2; y: root.height*0.6; }
            PathPercent { value: 0.52; }
            PathLine { x: root.width/2; y: root.height; }
            PathAttribute { name: "itemAngle"; value: 90.0; }
            PathAttribute { name: "itemScale"; value: 0.5; }
            PathAttribute { name: "itemZ"; value: 0 }
        }

        pathItemCount: 16

        preferredHighlightBegin: 0.5
        preferredHighlightEnd: 0.5
    }
```


代理如下面所示，使用了一些從PathAttribute中鏈接的屬性，itemZ,itemAngle和itemScale。需要注意代理鏈接的屬性只在wrapper中可用。因此，rotxs屬性在Rotation元素中定義為可訪問值。

另一個需要注意的是路徑視圖（PathView）鏈接的PathView.onPath屬性的用法。通常對于這個屬性都綁定為可見，這樣允許路徑視圖（PathView）緩衝不可見的元素。這不是通過剪裁處理來實現的，因為路徑視圖（PathView）的代理比其它的視圖，例如鏈表視圖（ListView）或者柵格視圖（GridView）放置更加隨意。

```
    Component {
        id: flipCardDelegate

        Item {
            id: wrapper

            width: 64
            height: 64

            visible: PathView.onPath

            scale: PathView.itemScale
            z: PathView.itemZ

            property variant rotX: PathView.itemAngle
            transform: Rotation { axis { x: 1; y: 0; z: 0 } angle: wrapper.rotX; origin { x: 32; y: 32; } }

            Rectangle {
                anchors.fill: parent
                color: "lightGray"
                border.color: "black"
                border.width: 3
            }

            Text {
                anchors.centerIn: parent
                text: index
                font.pixelSize: 30
            }
        }
    }
```

當在路徑視圖（PathView）上使用圖像轉換或者其它更加復雜的元素時，有一個性能優化的技巧是綁定圖像元素（Image）的smooth屬性與PathView.view.moving屬性。這意味著圖像在移動時可能不夠完美，但是能夠比較平滑的轉換。當視圖在移動時，對于平滑縮放的處理是沒有意義的，因為用戶根本看不見這個過程。

## 6.5.2 XML模型（A Model from XML）

由于XML是一種常見的數據格式，QML提供了XmlListModel元素來包裝XML數據。這個元素能夠獲取本地或者網絡上的XML數據，然後通過XPath解析這些數據。

下面這個例子展示了從RSS流中獲取圖片，源屬性（source）引用了一個網絡地址，這個數據會自動下載。

![](http://qmlbook.org/_images/xmllistmodel-images.png)

當數據下載完成後，它會被加工作為模型的子項。查詢屬性（query）是一個XPath代理的基礎查詢，用來創建模型項。在這個例子中，這個路徑是/rss/channel/item，所以，在一個模型子項創建後，每一個子項的標簽，都包含了一個頻道標簽，包含一個RSS標簽。

每一個模型項，一些規則需要被提取，由XmlRole元素來代理。每一個規則都需要一個名稱，這樣代理才能夠通過屬性綁定來訪問。每個這樣的屬性的值都通過XPath查詢來確定。例如標題屬性（title）符合title/string()查詢，返回內容中在之間的值。

圖像源屬性（imageSource）更加有趣，因為它不僅僅是從XML中提取字符串，也需要加載它。在流數據的支持下，每個子項包含了一個圖片。使用XPath的函數substring-after與substring-before，可以提取本地的圖片資源。這樣imageSource屬性就可以直接被作為一個Image元素的source屬性使用。

```
import QtQuick 2.0
import QtQuick.XmlListModel 2.0

Item {
    width: 300
    height: 480

    Component {
        id: imageDelegate

        Item {
            width: listView.width
            height: 400

	    Column {
                Text {
                    text: title
                }

                Image {
                    source: imageSource
                }
            }
        }
    }

    XmlListModel {
        id: imageModel

        source: "http://feeds.nationalgeographic.com/ng/photography/photo-of-the-day/"
        query: "/rss/channel/item"

        XmlRole { name: "title"; query: "title/string()" }
        XmlRole { name: "imageSource"; query: "substring-before(substring-after(description/string(), 'img src=\"'), '\"')" }
    }

    ListView {
        id: listView

        anchors.fill: parent

        model: imageModel
        delegate: imageDelegate
    }
}
```

## 6.5.3 鏈表分段（Lists with Sections）

有時，鏈表的數據需要劃分段。例如使用首字母來劃分聯系人，或者音樂。使用鏈表視圖可以把平面列表按類別劃分。

![](http://qmlbook.org/_images/listview-sections.png)

為了使用分段，section.property與section.criteria必須安裝。section.property定義了哪些屬性用于內容的劃分。在這裡，最重要的是知道每一段由哪些連續的元素構成，否則相同的屬性名可能出現在幾個不同的地方。

section.criteria能夠被設置為ViewSection.FullString或者ViewSection.FirstCharacter。默認下使用第一個值，能夠被用于模型中有清晰的分段，例如音樂專輯。第二個是使用一個屬性的首字母來分段，這說明任何屬性都可以被使用。通常的例子是用于聯系人名單的姓。

當段被定義好後，每個子項能夠使用綁定屬性ListView.section，ListView.previousSection與ListView.nextSection來訪問。使用這些屬性，可以檢測段的第一個與最後一個子項。

使用鏈表視圖（ListView）的section.delegate屬性可以給段指定代理組件。它能夠創建段標題，並且可以在任意子項之前插入這個段代理。使用綁定屬性section可以訪問當前段的名稱。

下面這個例子使用國際分類展示了分段的一些概念。國籍（nation）作為section.property，段代理組件（section.delegate）使用每個國家作為標題。在每個段中，spacemen模型中的名字使用spaceManDelegate組件來代理顯示。

```
import QtQuick 2.0

Rectangle {
    width: 300
    height: 290

    color: "white"

    ListView {
        anchors.fill: parent
        anchors.margins: 20

        clip: true

        model: spaceMen

        delegate: spaceManDelegate

        section.property: "nation"
        section.delegate: sectionDelegate
    }

    Component {
        id: spaceManDelegate

        Item {
            width: 260
            height: 20

            Text {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 10

                font.pixelSize: 12

                text: name
            }
        }
    }

    Component {
        id: sectionDelegate

        Rectangle {
            width: 260
            height: 20

            color: "lightGray"

            Text {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 10

                font.pixelSize: 12
                font.bold: true

                text: section
            }
        }
    }


    ListModel {
        id: spaceMen

        ListElement { name: "Abdul Ahad Mohmand"; nation: "Afganistan"; }
        ListElement { name: "Marcos Pontes"; nation: "Brazil"; }
        ListElement { name: "Alexandar Panayotov Alexandrov"; nation: "Bulgaria"; }
        ListElement { name: "Georgi Ivanov"; nation: "Bulgaria"; }
        ListElement { name: "Roberta Bondar"; nation: "Canada"; }
        ListElement { name: "Marc Garneau"; nation: "Canada"; }
        ListElement { name: "Chris Hadfield"; nation: "Canada"; }
        ListElement { name: "Guy Laliberte"; nation: "Canada"; }
        ListElement { name: "Steven MacLean"; nation: "Canada"; }
        ListElement { name: "Julie Payette"; nation: "Canada"; }
        ListElement { name: "Robert Thirsk"; nation: "Canada"; }
        ListElement { name: "Bjarni Tryggvason"; nation: "Canada"; }
        ListElement { name: "Dafydd Williams"; nation: "Canada"; }
    }
}
```

## 6.5.4 性能協調（Tunning Performance）

一個模型視圖的性能很大程度上依賴于代理的創建。例如滾動下拉一個鏈表視圖時，代理從外部加入到視圖底部，並且從視圖頂部移出。如果設置剪裁（clip）屬性為false，並且代理項花了很多時間來初始化，用戶會感覺到視圖滾動體驗很差。

為了優化這個問題，你可以在滾動時使用像素來調整。使用cacheBuffer屬性，在上訴情況下的垂直滾動，它將會調整在鏈表視圖的上下需要預先準備好多少像素的代理項，結合異步加載圖像元素（Image），例如在它們進入視圖之前加載。

創建更多的代理項將會犧牲一些流暢的體驗，並且花更多的時間來初始化每個代理。這並不代表可以解決一些更加復雜的代理項的問題。在每次實例化代理時，它的內容都會被評估和編輯。這需要花費時間，如果它花費了太多的時間，它將會導致一個很差的滾動體驗。在一個代理中包含太多的元素也會降低滾動的性能。

為了補救這個問題，我們推薦使用動態加載元素。當它們需要時，可以初始化這些附加的元素。例如，一個展開代理可能推遲它的詳細內容的實例化，直到需要使用它時。每個代理中最好減少JavaScript的數量。將每個代理中復雜的JavaScript調用放在外面來實現。這將會減少每個代理在創建時編譯JavaScript。

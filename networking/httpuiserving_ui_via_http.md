# 通過HTTP服務UI（Serving UI via HTTP）

通過HTTP加載一個簡單的用戶界面，我們需要一個web服務器，它為UI文件服務。但是首先我們需要有用戶界面，我們在項目裡創建一個創建了紅色矩形框的main.qml。

```
// main.qml
import QtQuick 2.0

Rectangle {
    width: 320
    height: 320
    color: '#ff0000'
}
```

我們加載一段python腳本來提供這個文件：

```
$ cd <PROJECT>
# python -m SimpleHTTPServer 8080
```

現在我們可以通過[http://localhost:8000/main.qml](http://localhost:8000/main.qml)來訪問，你可以像下面這樣測試：

```
$ curl http://localhost:8000/main.qml
```

或者你可以用瀏覽器來訪問。瀏覽器無法識別QML，並且無法通過文檔來渲染。我們需要創建一個可以瀏覽QML文檔的瀏覽器。為了渲染文檔，我們需要指出qmlscene的位置。不幸的是qmlscene只能讀取本地文件。我們為了突破這個限制，我們可以使用自己寫的qmlscene或者使用QML動態加載。我們選擇動態加載的方式。我們選擇一個加載元素來加載遠程的文檔。

```
// remote.qml
import QtQuick 2.0

Loader {
    id: root
    source: 'http://localhost:8080/main2.qml'
    onLoaded: {
        root.width = item.width
        root.height = item.height
    }
}
```

我們現在可以使用qmlscene來加載remote.qml文檔。這裡仍然有一個小問題。加載器將會調整加載項的大小。我們的qmlscene需要適配大小。可以使用--resize-to-root選項來運行qmlscene。

```
$ qmlscene --resize-to-root remote.qml
```

按照root元素調整大小，告訴qmlscene按照root元素的大小調它的窗口大小。remote現在從本地服務器加載main.qml，並且可以自動調整加載的用戶界面。方便且簡單。

**注意**

**如果你不想使用一個本地服務器，你可以使用來自GitHub的gist服務。Gist是一個在線剪切板服務，就像PasteBin等等。可以在[https://gist.github.com](https://gist.github.com )下使用。我創建了一個簡單的gist例子，地址是[https://gist.github.com/jryannel/7983492](https://gist.github.com/jryannel/7983492)。這將會返回一個綠色矩形框。由于gist連接提供的是HTML代碼，我們需要連接一個/raw來讀取原始文件而不是HTML代碼。**

```
// remote.qml
import QtQuick 2.0

Loader {
    id: root
    source: 'https://gist.github.com/jryannel/7983492/raw'
    onLoaded: {
        root.width = item.width
        root.height = item.height
    }
}
```

從網絡加載另一個文件，你只需要引用組件名。例如一個Button.qml，只要它們在同一個遠程文件夾下就能夠像正常一樣訪問。

## 11.1.1 網絡組件（Networked Components）

我們做了一個小實驗。我們在遠程端添加一個按鈕作為可以復用的組件。

```
- src/main.qml
- src/Button.qml
```

我們修改main.qml來使用button：

```
import QtQuick 2.0

Rectangle {
    width: 320
    height: 320
    color: '#ff0000'

    Button {
        anchors.centerIn: parent
        text: 'Click Me'
        onClicked: Qt.quit()
    }
}
```

再次加載我們的web服務器：

```
$ cd src
# python -m SimpleHTTPServer 8080
```

再次使用http加載遠mainQML文件：

```
$ qmlscene --resize-to-root remote.qml
```

我們看到一個錯誤：

```
http://localhost:8080/main2.qml:11:5: Button is not a type
```

所以，在遠程加載時，QML無法解決Button組件的問題。如果代碼使用本地加載qmlscene src/main.qml，將不會有問題。Qt能夠直接解析本地文件，並且檢測哪些組件可用，但是使用http的遠程訪問沒有“list-dir”函數。我們可以在main.qml中使用import聲明來強制QML加載元素：

```
import "http://localhost:8080" as Remote

...

Remote.Button { ... }
```

再次運行qmlscene後，它將正常工作：

```
$ qmlscene --resize-to-root remote.qml
```

這是完整的代碼：

```
// main2.qml
import QtQuick 2.0
import "http://localhost:8080" 1.0 as Remote

Rectangle {
    width: 320
    height: 320
    color: '#ff0000'

    Remote.Button {
        anchors.centerIn: parent
        text: 'Click Me'
        onClicked: Qt.quit()
    }
}
```

一個更好的選擇是在服務器端使用qmldir文件來控制輸出：

```
// qmldir
Button 1.0 Button.qml
```

然後更新main.qml：

```
import "http://localhost:8080" 1.0 as Remote

...

Remote.Button { ... }
```

當從本地文件系統使用組件時，它們的創建沒有延遲。當組件通過網絡加載時，它們的創建是異步的。創建時間的影響是未知的，當其它組件已經完成時，一個組件可能還沒有完成加載。當通過網絡加載組件時，需要考慮這些。

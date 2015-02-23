# HTTP請求（HTTP Requests）

從c++方面來看，Qt中完成http請求通常是使用QNetworkRequest和QNetworkReply，然後使用Qt/C++將響應推送到集成的QML。所以我們嘗試使用QtQuick的工具給我們的網絡信息尾部封裝了小段信息，然後推送這些信息。為此我們使用一個幫助對象來構造http請求，和循環響應。它使用java腳本的XMLHttpRequest對象的格式。

XMLHttpRequest對象允許用戶注冊一個響應操作函數和一個鏈接。一個請求能夠使用http動作來發送（如get，post，put，delete，等等）。當響應到達時，會調用注冊的操作函數。操作函數會被調用多次。每次調用請求的狀態都已經改變（例如信息頭部已接收，或者響應完成）。

下面是一個簡短的例子：

```
function request() {
    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
            print('HEADERS_RECEIVED');
        } else if(xhr.readyState === XMLHttpRequest.DONE) {
            print('DONE');
        }
    }
    xhr.open("GET", "http://example.com");
    xhr.send();
}
```

從一個響應中你可以獲取XML格式的數據或者是原始文本。可以遍歷XML結果但是通常使用原始文本來匹配JSON格式響應。使用JSON.parse(text）可以JSON文檔將轉換為JS對象使用。

```
...
} else if(xhr.readyState === XMLHttpRequest.DONE) {
    var object = JSON.parse(xhr.responseText.toString());
    print(JSON.stringify(object, null, 2));
}
```

在響應操作中，我們訪問原始響應文本並且將它轉換為一個javascript對象。JSON對象是一個可以使用的JS對象（在javascript中，一個對象可以是對象或者一個數組）。

**注意**

**toString()轉換似乎讓代碼更加穩定。在不使用顯式的轉換下我有幾次都解析錯誤。不確定是什麼問題引起的。**

## 11.3.1 Flickr調用（Flickr Call）

讓我們看看更加真實的例子。一個典型的例子是使用網絡相冊服務來取得公共訂閱中新上傳的圖片。我們可以使用[http://api.flicker.com/services/feeds/photos_public.gne](http://api.flicker.com/services/feeds/photos_public.gne)鏈接。不幸的是它默認返回XML流格式的數據，在qml中可以很方便的使用XmlListModel來解析。為了達到只關注JSON數據的目的，我們需要在請求中附加一些參數可以得到JSON響應：[http://api.flickr.com/services/feeds/photo_public.gne?format=json&nojsoncallback=1](http://api.flickr.com/services/feeds/photo_public.gne?format=json&nojsoncallback=1)。這將會返回一個沒有JSON回調的JSON響應。

**注意**
**一個JSON回調將JSON響應包裝在一個函數調用中。這是一個HTML編程中的快捷方式，使用腳本標記來創建一個JSON請求。響應將觸發本地定義的回調函數。在QML中沒有JSON回調的工作機制。**

使用curl來查看響應：

```
curl "http://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags=munich"
```

響應如下：

```
{
    "title": "Recent Uploads tagged munich",
    ...
    "items": [
        {
        "title": "Candle lit dinner in Munich",
        "media": {"m":"http://farm8.staticflickr.com/7313/11444882743_2f5f87169f_m.jpg"},
        ...
        },{
        "title": "Munich after sunset: a train full of \"must haves\" =",
        "media": {"m":"http://farm8.staticflickr.com/7394/11443414206_a462c80e83_m.jpg"},
        ...
        }
    ]
    ...
}
```

JSON文檔已經定義了結構體。一個對象包含一個標題和子項的屬性。標題是一個字符串，子項是一組對象。當轉換文本為一個JSON文檔後，你可以單獨訪問這些條目，它們都是可用的JS對象或者結構體數組。

```
// JS code
obj = JSON.parse(response);
print(obj.title) // => "Recent Uploads tagged munich"
for(var i=0; i<obj.items.length; i++) {
    // iterate of the items array entries
    print(obj.items[i].title) // title of picture
    print(obj.items[i].media.m) // url of thumbnail
}
```

我們可以使用obj.items數組將JS數組作為鏈表視圖的模型，試著完成這個操作。首先我們需要取得響應並且將它轉換為可用的JS對象。然後設置response.items屬性作為鏈表視圖的模型。

```
function request() {
    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function() {
        if(...) {
            ...
        } else if(xhr.readyState === XMLHttpRequest.DONE) {
            var response = JSON.parse(xhr.responseText.toString());
            // set JS object as model for listview
            view.model = response.items;
        }
    }
    xhr.open("GET", "http://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags=munich");
    xhr.send();
}
```

下面是完整的源代碼，當組件加載完成後，我們創建請求。然後使用請求的響應作為我們鏈表視圖的模型。

```
import QtQuick 2.0

Rectangle {
    width: 320
    height: 480
    ListView {
        id: view
        anchors.fill: parent
        delegate: Thumbnail {
            width: view.width
            text: modelData.title
            iconSource: modelData.media.m
        }
    }

    function request() {
        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
                print('HEADERS_RECEIVED')
            } else if(xhr.readyState === XMLHttpRequest.DONE) {
                print('DONE')
                var json = JSON.parse(xhr.responseText.toString())
                view.model = json.items
            }
        }
        xhr.open("GET", "http://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags=munich");
        xhr.send();
    }

    Component.onCompleted: {
        request()
    }
}
```

當文檔完整加載後（Component.onCompleted）,我們從Flickr請求最新的訂閱內容。我們解析JSON的響應並且設置item數組作為我們視圖的模型。鏈表視圖有一個代理可以在一行中顯示圖標縮略圖和標題文本。

另一種方法是添加一個ListModel，並且將每個子項添加到鏈表模型中。為了支持更大的模型，需要支持分頁和懶加載。

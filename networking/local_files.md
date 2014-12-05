# 本地文件（Local files）

使用XMLHttpRequest也可以加載本地文件（XML/JSON）。例如加載一個本地名為“colors.json”的文件可以這樣使用：

```
xhr.open("GET", "colors.json");
```

我們使用它讀取一個顏色表並且使用表格來顯示。從QtQuick這邊無法修改文件。為了將源數據存儲回去，我們需要一個基于HTTP服務器的REST服務支持或者一個用來訪問文件的QtQuick擴展。

```
import QtQuick 2.0

Rectangle {
    width: 360
    height: 360
    color: '#000'

    GridView {
        id: view
        anchors.fill: parent
        cellWidth: width/4
        cellHeight: cellWidth
        delegate: Rectangle {
            width: view.cellWidth
            height: view.cellHeight
            color: modelData.value
        }
    }

    function request() {
        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
                print('HEADERS_RECEIVED')
            } else if(xhr.readyState === XMLHttpRequest.DONE) {
                print('DONE');
                var obj = JSON.parse(xhr.responseText.toString());
                view.model = obj.colors
            }
        }
        xhr.open("GET", "colors.json");
        xhr.send();
    }

    Component.onCompleted: {
        request()
    }
}
```

也可以使用XmlListModel來替代XMLHttpRequest訪問本地文件。

```
import QtQuick.XmlListModel 2.0

XmlListModel {
    source: "http://localhost:8080/colors.xml"
    query: "/colors"
    XmlRole { name: 'color'; query: 'name/string()' }
    XmlRole { name: 'value'; query: 'value/string()' }
}
```

XmlListModel只能用來讀取XML文件，不能讀取JSON文件。

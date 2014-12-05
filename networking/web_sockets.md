# Web Sockets

webSockets不是Qt提供的。將WebSockets加入到Qt/QML中需要花費一些工作。從作者的角度來看WebSockets有巨大的潛力來添加HTTP服務缺少的功能-通知。HTTP給了我們get和post的功能，但是post還不是一個通知。目前客戶端輪詢服務器來獲得應用程序的服務，服務器也需要能通知客戶端變化和事件。你可以與QML接口比較：屬性，函數，信號。也可以叫做獲取/設置/調用和通知。

QML WebSocket插件將會在Qt5中加入。你可以試試來自qt playground的web sockets插件。為了測試，我們使用一個現有的web socket服務實現了echo server。

首先確保你使用的Qt5.2.x。

```
$ qmake --version
... Using Qt version 5.2.0 ...
```

然後你需要克隆web socket的代碼庫，並且編譯它。

```
$ git clone git@gitorious.org:qtplayground/websockets.git
$ cd websockets
$ qmake
$ make
$ make install
```

現在你可以在qml模塊中使用web socket。

```
import Qt.WebSockets 1.0

WebSocket {
    id: socket
}
```

測試你的web socket，我們使用來自[http://websocket.org](http://websocket.org)的echo server 。

```
import QtQuick 2.0
import Qt.WebSockets 1.0

Text {
    width: 480
    height: 48

    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter

    WebSocket {
        id: socket
        url: "ws://echo.websocket.org"
        active: true
        onTextMessageReceived: {
            text = message
        }
        onStatusChanged: {
            if (socket.status == WebSocket.Error) {
                console.log("Error: " + socket.errorString)
            } else if (socket.status == WebSocket.Open) {
                socket.sendTextMessage("ping")
            } else if (socket.status == WebSocket.Closed) {
                text += "\nSocket closed"
            }
        }
    }
}
```

你可以看到我們使用socket.sendTextMessage("ping")作為響應在文本區域中。

![](http://qmlbook.org/_images/ws_echo.png)

## 11.8.1 WS Server

你可以使用Qt WebSocket的C++部分來創建你自己的WS Server或者使用一個不同的WS實現。它非常有趣，是因為它允許連接使用大量擴展的web應用程序服務的高質量渲染的QML。在這個例子中，我們將使用基于web socket的ws模塊的Node JS。你首先需要安裝node.js。然後創建一個ws_server文件夾，使用node package manager（npm）安裝ws包。

```
$ cd ws_server
$ npm install ws
```

npm工具下載並安裝了ws包到你的本地依賴文件夾中。

一個server.js文件是我們服務器的實現。服務器代碼將在端口3000創建一個web socket服務並監聽連接。在一個連接加入後，它將會發送一個歡迎並等待客戶端信息。每個客戶端發送到socket信息都會發送回客戶端。

```
var WebSocketServer = require('ws').Server;

var server = new WebSocketServer({ port : 3000 });

server.on('connection', function(socket) {
	console.log('client connected');
	socket.on('message', function(msg) {
		console.log('Message: %s', msg);
		socket.send(msg);
	});
	socket.send('Welcome to Awesome Chat');
});

console.log('listening on port ' + server.options.port);
```

你需要獲取使用的JavaScript標記和回調函數。

## 11.8.2 WS Client

在客戶端我們需要一個鏈表視圖來顯示信息，和一個文本輸入來輸入新的聊天信息。

在例子中我們使用一個白色的標簽。

```
// Label.qml
import QtQuick 2.0

Text {
    color: '#fff'
    horizontalAlignment: Text.AlignLeft
    verticalAlignment: Text.AlignVCenter
}
```

我們的聊天視圖是一個鏈表視圖，文本被加入到鏈表模型中。每個條目顯示使用行前綴和信息標簽。我們使用單元將它分為24列。

```
// ChatView.qml
import QtQuick 2.0

ListView {
    id: root
    width: 100
    height: 62

    model: ListModel {}

    function append(prefix, message) {
        model.append({prefix: prefix, message: message})
    }

    delegate: Row {
        width: root.width
        height: 18
        property real cw: width/24
        Label {
            width: cw*1
            height: parent.height
            text: model.prefix
        }
        Label {
            width: cw*23
            height: parent.height
            text: model.message
        }
    }
}
```

聊天輸入框是一個簡單的使用顏色包裹邊界的文本輸入。

```
// ChatInput.qml
import QtQuick 2.0

FocusScope {
    id: root
    width: 240
    height: 32
    Rectangle {
        anchors.fill: parent
        color: '#000'
        border.color: '#fff'
        border.width: 2
    }

    property alias text: input.text

    signal accepted(string text)

    TextInput {
        id: input
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 4
        anchors.rightMargin: 4
        onAccepted: root.accepted(text)
        color: '#fff'
        focus: true
    }
}
```

當web socket返回一個信息後，它將會把信息添加到聊天視圖中。這也同樣適用于狀態改變。也可以當用戶輸入一個聊天信息，將聊天信息拷貝添加到客戶端的聊天視圖中，並將信息發送給服務器。

```
// ws_client.qml
import QtQuick 2.0
import Qt.WebSockets 1.0

Rectangle {
    width: 360
    height: 360
    color: '#000'

    ChatView {
        id: box
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: input.top
    }
    ChatInput {
        id: input
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        focus: true
        onAccepted: {
            print('send message: ' + text)
            socket.sendTextMessage(text)
            box.append('>', text)
            text = ''
        }
    }
    WebSocket {
        id: socket

        url: "ws://localhost:3000"
        active: true
        onTextMessageReceived: {
            box.append('<', message)
        }
        onStatusChanged: {
            if (socket.status == WebSocket.Error) {
                box.append('#', 'socket error ' + socket.errorString)
            } else if (socket.status == WebSocket.Open) {
                box.append('#', 'socket open')
            } else if (socket.status == WebSocket.Closed) {
                box.append('#', 'socket closed')
            }
        }
    }
}
```

你首先需要運行服務器，然後是客戶端。在我們簡單例子中沒有客戶端重連的機制。

運行服務器

```
$ cd ws_server
$ node server.js
```

運行客戶端

```
$ cd ws_client
$ qmlscene ws_client.qml
```

當輸入文本並點擊發送後，你可以看到類似下面這樣。

![](http://qmlbook.org/_images/ws_client.png)

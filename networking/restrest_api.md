# REST接口（REST API）

為了使用web服務，我們首先需要創建它。我們使用Flask（http://flask.pocoo.org），一個基于python創建簡單的顏色web服務的HTTP服務器應用。你也可以使用其它的web服務器，只要它接收和返回JSON數據。通過web服務來管理一組已經命名的顏色。在這個例子中，管理意味著CRUD（創建-讀取-更新-刪除）。

在Flask中一個簡單的web服務可以寫入一個文件。我們使用一個空的服務器.py文件開始，在這個文件中我們創建一些規則並且從額外的JSON文件中加載初始顏色。你可以查看Flask文檔獲取更多的幫助。

```
from flask import Flask, jsonify, request
import json

colors = json.load(file('colors.json', 'r'))

app = Flask(__name__)

# ... service calls go here

if __name__ == '__main__':
    app.run(debug = True)
```

當你運行這個腳本後，它會在http://localhost:5000。

我們開始添加我們的CRUD（創建，讀取，更新，刪除）到我們的web服務。

## 11.5.1 讀取請求（Read Request）

從web服務讀取數據，我們提供GET方法來讀取所有的顏色。

```
@app.route('/colors', methods = ['GET'])
def get_colors():
    return jsonify( { "colors" :  colors })
```

這將會返回‘/colors’下的顏色。我們使用curl來創建一個http請求測試。

```
curl -i -GET http://localhost:5000/colors
```

這將會返回給我們JSON數據的顏色鏈表。

## 11.5.2 讀取接口（Read Entry）

為了通過名字讀取顏色，我們提供更加詳細的後綴，定位在‘/colors/'下。名稱是後綴的參數，用來識別一個獨立的顏色。

```
@app.route('/colors/<name>', methods = ['GET'])
def get_color(name):
    for color in colors:
        if color["name"] == name:
            return jsonify( color )
```

我們再次使用curl測試，例如獲取一個紅色的接口。

```
curl -i -GET http://localhost:5000/colors/red
```

這將返回一個JSON數據的顏色。

## 11.5.3 創建接口（Create Entry）

目前我們僅僅使用了HTTP GET方法。為了在服務器端創建一個接口，我們使用POST方法，並且將新的顏色信息發使用POST數據發送。後綴與獲取所有顏色相同，但是我們需要使用一個POST請求。

```
@app.route('/colors', methods= ['POST'])
def create_color():
    color = {
        'name': request.json['name'],
        'value': request.json['value']
    }
    colors.append(color)
    return jsonify( color ), 201
```

curl非常靈活，允許我們使用JSON數據作為新的接口包含在POST請求中。

```
curl -i -H "Content-Type: application/json" -X POST -d '{"name":"gray1","value":"#333"}' http://localhost:5000/colors
```

## 11.5.4 更新接口（Update Entry）

我們使用PUT HTTP方法來添加新的update接口。後綴與取得一個顏色接口相同。當顏色更新後，我們獲取更新後JSON數據的顏色。

```
@app.route('/colors/<name>', methods= ['PUT'])
def update_color(name):
    for color in colors:
        if color["name"] == name:
            color['value'] = request.json.get('value', color['value'])
            return jsonify( color )
```

在curl請求中，我們用JSON數據來定義更新值，後綴名用來識別哪個顏色需要更新。

```
curl -i -H "Content-Type: application/json" -X PUT -d '{"value":"#666"}' http://localhost:5000/colors/red
```

## 11.5.5 刪除接口（Delete Entry）

使用DELETE HTTP來完成刪除接口。使用與顏色相同的後綴，但是使用DELETE HTTP方法。

```
@app.route('/colors/<name>', methods=['DELETE'])
def delete_color(name):
    success = False
    for color in colors:
        if color["name"] == name:
            colors.remove(color)
            success = True
    return jsonify( { 'result' : success } )
```

這個請求看起來與GET請求一個顏色類似。

```
curl -i -X DELETE http://localhost:5000/colors/red
```

現在我們能夠讀取所有顏色，讀取指定顏色，創建新的顏色，更新顏色和刪除顏色。我們知道使用HTTP後綴來訪問我們的接口。

| 動作 | HTTP協議 | 後綴  |
| -- | -- | -- |
| 讀取所有 | GET | http://localhost:5000/colors   |
| 創建接口 | POST | http://localhost:5000/colors  |
| 讀取接口 | GET | http://localhost:5000/colors/name |
| 更新接口 | PUT | http://localhost:5000/colors/name |
| 刪除接口 | DELETE  | http://localhost:500/colors/name |

REST服務已經完成，我們現在只需要關注QML和客戶端。為了創建一個簡單好用的接口，我們需要映射每個動作為一個獨立的HTTP請求，並且給我們的用戶提供一個簡單的接口。

## 11.5.6 REST客戶端（REST Client）

為了展示REST客戶端，我們寫了一個小的顏色表格。這個顏色表格顯示了通過HTTP請求從web服務取得的顏色。我們的用戶界面提供以下命令：

* 獲取顏色鏈表

* 創建顏色

* 讀取最後的顏色

* 更新最後的顏色

* 刪除最後的顏色

我們將我們的接口包裝在一個JS文件中，叫做colorservice.js，並將它導入到我們的UI中作為服務（Service）。在服務模塊中，我們創建了幫助函數來為我們構造HTTP請求：

```
// colorservice.js
function request(verb, endpoint, obj, cb) {
    print('request: ' + verb + ' ' + BASE + (endpoint?'/' + endpoint:''))
    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function() {
        print('xhr: on ready state change: ' + xhr.readyState)
        if(xhr.readyState === XMLHttpRequest.DONE) {
            if(cb) {
                var res = JSON.parse(xhr.responseText.toString())
                cb(res);
            }
        }
    }
    xhr.open(verb, BASE + (endpoint?'/' + endpoint:''));
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.setRequestHeader('Accept', 'application/json');
    var data = obj?JSON.stringify(obj):''
    xhr.send(data)
}
```

包含四個參數。verb，定義了使用HTTP的動作（GET，POST，PUT，DELETE）。第二個參數是作為基礎地址的後綴（例如’[http://localhost:5000/colors](http://localhost:5000/colors)'）。第三個參數是可選對象，作為JSON數據發送給服務的數據。最後一個選項是定義當響應返回時的回調。回調接收一個響應數據的響應對象。

在我們發送請求前，我們需要明確我們發送和接收的JSON數據修改的請求頭。

```
// colorservice.js
function get_colors(cb) {
    // GET http://localhost:5000/colors
    request('GET', null, null, cb)
}

function create_color(entry, cb) {
    // POST http://localhost:5000/colors
    request('POST', null, entry, cb)
}

function get_color(name, cb) {
    // GET http://localhost:5000/colors/<name>
    request('GET', name, null, cb)
}

function update_color(name, entry, cb) {
    // PUT http://localhost:5000/colors/<name>
    request('PUT', name, entry, cb)
}

function delete_color(name, cb) {
    // DELETE http://localhost:5000/colors/<name>
    request('DELETE', name, null, cb)
}
```

這些代碼在服務實現中。在UI中我們使用服務來實現我們的命令。我們有一個存儲id的ListModel和存儲數據的gridModel為GridView提供數據。命令使用Button元素來發送。

讀取服務器顏色鏈表。

```
// rest.qml
import "colorservice.js" as Service
...
// read colors command
Button {
    text: 'Read Colors';
    onClicked: {
        Service.get_colors( function(resp) {
            print('handle get colors resp: ' + JSON.stringify(resp));
            gridModel.clear();
            var entries = resp.data;
            for(var i=0; i<entries.length; i++) {
                gridModel.append(entries[i]);
            }
        });
    }
}
```

在服務器上創建一個新的顏色。

```
// rest.qml
import "colorservice.js" as Service
...
// create new color command
Button {
    text: 'Create New';
    onClicked: {
        var index = gridModel.count-1
        var entry = {
            name: 'color-' + index,
            value: Qt.hsla(Math.random(), 0.5, 0.5, 1.0).toString()
        }
        Service.create_color(entry, function(resp) {
            print('handle create color resp: ' + JSON.stringify(resp))
            gridModel.append(resp)
        });
    }
}
```

基于名稱讀取一個顏色。

```
// rest.qml
import "colorservice.js" as Service
...
// read last color command
Button {
    text: 'Read Last Color';
    onClicked: {
        var index = gridModel.count-1
        var name = gridModel.get(index).name
        Service.get_color(name, function(resp) {
            print('handle get color resp:' + JSON.stringify(resp))
            message.text = resp.value
        });
    }
}
```

基于顏色名稱更新服務器上的一個顏色。

```
// rest.qml
import "colorservice.js" as Service
...
// update color command
Button {
    text: 'Update Last Color'
    onClicked: {
        var index = gridModel.count-1
        var name = gridModel.get(index).name
        var entry = {
            value: Qt.hsla(Math.random(), 0.5, 0.5, 1.0).toString()
        }
        Service.update_color(name, entry, function(resp) {
            print('handle update color resp: ' + JSON.stringify(resp))
            var index = gridModel.count-1
            gridModel.setProperty(index, 'value', resp.value)
        });
    }
}
```

基于顏色名稱刪除一個顏色。

```
// rest.qml
import "colorservice.js" as Service
...
// delete color command
Button {
    text: 'Delete Last Color'
    onClicked: {
        var index = gridModel.count-1
        var name = gridModel.get(index).name
        Service.delete_color(name)
        gridModel.remove(index, 1)
    }
}
```

在CRUD（創建，讀取，更新，刪除）操作使用REST接口。也可以使用其它的方法來創建web服務接口。可以基于模塊，每個模塊都有自己的後綴。可以使用JSON RPC（[http://www.jsonrpc.org/](http://www.jsonrpc.org/)）來定義接口。當然基于XML的接口也可以使用，但是JSON在作為JavaScript部分解析進QML/JS中更有優勢。

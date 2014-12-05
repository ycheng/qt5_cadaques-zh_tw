# HTML5畫布移植（Porting from HTML5 Canvas）

* [https://developer.mozilla.org/en/Canvas_tutorial/Transformations](https://developer.mozilla.org/en/Canvas_tutorial/Transformations)

* [http://en.wikipedia.org/wiki/Spirograph](http://en.wikipedia.org/wiki/Spirograph)

移植一個HTML5畫布圖像到QML畫布非常簡單。在成百上千的例子中，我們選擇了一個來移植。

**螺旋圖形（Spiro Graph）**

我們使用一個來自Mozila項目的螺旋圖形例子來作為我們的基礎示例。原始的HTML5代碼被作為畫布教程發布。

下面是我們需要修改的代碼：

* Qt Quick要求定義變量使用，所以我們需要添加var的定義：
```
for (var i=0;i<3;i++) {
    ...
}
```

* 修改繪制方法接收Context2D對象：
```
function draw(ctx) {
    ...
}
```

* 由于不同的大小，我們需要對每個螺旋適配轉換：
```
ctx.translate(20+j*50,20+i*50);
```

最後我們實現onPaint操作。在onPaint中我們請求一個context，並且調用我們的繪制方法。

```
    onPaint: {
        var ctx = getContext("2d");
        draw(ctx);
    }
```

下面這個結果就是我們使用QML畫布移植的螺旋圖形。

![](http://qmlbook.org/_images/spirograph.png)

**發光線（Glowing Lines）**

下面有一個更加復雜的移植來自W3C組織。[原始的發光線](http://www.w3.org/TR/2dcontext/#examples)有些很不錯的地方，這使得移植更加具有挑戰性。

![](http://qmlbook.org/_images/html_glowlines.png)

```
<!DOCTYPE HTML>
<html lang="en">
<head>
    <title>Pretty Glowing Lines</title>
</head>
<body>

<canvas width="800" height="450"></canvas>
<script>
var context = document.getElementsByTagName('canvas')[0].getContext('2d');

// initial start position
var lastX = context.canvas.width * Math.random();
var lastY = context.canvas.height * Math.random();
var hue = 0;

// closure function to draw
// a random bezier curve with random color with a glow effect
function line() {

    context.save();

    // scale with factor 0.9 around the center of canvas
    context.translate(context.canvas.width/2, context.canvas.height/2);
    context.scale(0.9, 0.9);
    context.translate(-context.canvas.width/2, -context.canvas.height/2);

    context.beginPath();
    context.lineWidth = 5 + Math.random() * 10;

    // our start position
    context.moveTo(lastX, lastY);

    // our new end position
    lastX = context.canvas.width * Math.random();
    lastY = context.canvas.height * Math.random();

    // random bezier curve, which ends on lastX, lastY
    context.bezierCurveTo(context.canvas.width * Math.random(),
    context.canvas.height * Math.random(),
    context.canvas.width * Math.random(),
    context.canvas.height * Math.random(),
    lastX, lastY);

    // glow effect
    hue = hue + 10 * Math.random();
    context.strokeStyle = 'hsl(' + hue + ', 50%, 50%)';
    context.shadowColor = 'white';
    context.shadowBlur = 10;
    // stroke the curve
    context.stroke();
    context.restore();
}

// call line function every 50msecs
setInterval(line, 50);

function blank() {
    // makes the background 10% darker on each call
    context.fillStyle = 'rgba(0,0,0,0.1)';
    context.fillRect(0, 0, context.canvas.width, context.canvas.height);
}

// call blank function every 50msecs
setInterval(blank, 40);

</script>
</body>
</html>
```

在HTML5中，context2D對象可以隨意在畫布上繪制。在QML中，只能在onPaint操作中繪制。在HTML5中，通常調用setInterval使用計時器觸發線段的繪制或者清屏。由于QML中不同的操作方法，僅僅只是調用這些函數不能實現我們想要的結果，因為我們需要通過onPaint操作來實現。我們也需要修改顏色的格式。讓我們看看需要改變哪些東西。

修改從畫布元素開始。為了簡單，我們使用畫布元素（Canvas）作為我們QML文件的根元素。

```
import QtQuick 2.0

Canvas {
   id: canvas
   width: 800; height: 450

   ...
}
```

代替直接調用的setInterval函數，我們使用兩個計時器來請求重新繪制。一個計時器觸發間隔較短，允許我們可以執行一些代碼。我們無法告訴繪制函數哪個操作是我想觸發的，我們為每個操作定義一個布爾標識，當重新繪制請求時，我們請求一個操作並且觸發它。

下面是線段繪制的代碼，清屏操作類似。

```
...
property bool requestLine: false

Timer {
    id: lineTimer
    interval: 40
    repeat: true
    triggeredOnStart: true
    onTriggered: {
        canvas.requestLine = true
        canvas.requestPaint()
    }
}

Component.onCompleted: {
    lineTimer.start()
}
...
```

現在我們已經有了告訴onPaint操作中我們需要執行哪個操作的指示。當我們進入onPaint處理每個繪制請求時，我們需要提取畫布元素中的初始化變量。

```
Canvas {
    ...
    property real hue: 0
    property real lastX: width * Math.random();
    property real lastY: height * Math.random();
    ...
}
```

現在我們的繪制函數應該像這樣：

```
onPaint: {
    var context = getContext('2d')
    if(requestLine) {
        line(context)
        requestLine = false
    }
    if(requestBlank) {
        blank(context)
        requestBlank = false
    }
}
```

線段繪制函數提取畫布作為一個參數。

```
function line(context) {
    context.save();
    context.translate(canvas.width/2, canvas.height/2);
    context.scale(0.9, 0.9);
    context.translate(-canvas.width/2, -canvas.height/2);
    context.beginPath();
    context.lineWidth = 5 + Math.random() * 10;
    context.moveTo(lastX, lastY);
    lastX = canvas.width * Math.random();
    lastY = canvas.height * Math.random();
    context.bezierCurveTo(canvas.width * Math.random(),
        canvas.height * Math.random(),
        canvas.width * Math.random(),
        canvas.height * Math.random(),
        lastX, lastY);

    hue += Math.random()*0.1
    if(hue > 1.0) {
        hue -= 1
    }
    context.strokeStyle = Qt.hsla(hue, 0.5, 0.5, 1.0);
    // context.shadowColor = 'white';
    // context.shadowBlur = 10;
    context.stroke();
    context.restore();
}
```

最大的變化是使用QML的Qt.rgba()和Qt.hsla()。在QML中需要把變量值適配在0.0到1.0之間。

同樣應用在清屏函數中。

```
function blank(context) {
    context.fillStyle = Qt.rgba(0,0,0,0.1)
    context.fillRect(0, 0, canvas.width, canvas.height);
}
```

下面是最終結果（目前沒有陰影）類似下面這樣。

![](http://qmlbook.org/_images/glowlines.png)

查看下面的鏈接獲得更多的信息：

* [W3C HTML Canvas 2D Context Specification](http://www.w3.org/TR/2dcontext/)

* [Mozilla Canvas Documentation](https://developer.mozilla.org/en/HTML/Canvas)

* [HTML5 Canvas Tutorial](http://www.html5canvastutorials.com/)


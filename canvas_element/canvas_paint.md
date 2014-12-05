# 畫布繪制（Canvas Paint）

在這個例子中我們將使用畫布（Canvas）創建一個簡單的繪制程序。

![](http://qmlbook.org/_images/canvaspaint.png)

在我們場景的頂部我們使用行定位器排列四個方形的顏色塊。一個顏色塊是一個簡單的矩形，使用鼠標區域來檢測點擊。

```
    Row {
        id: colorTools
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: 8
        }
        property variant activeSquare: red
        property color paintColor: "#33B5E5"
        spacing: 4
        Repeater {
            model: ["#33B5E5", "#99CC00", "#FFBB33", "#FF4444"]
            ColorSquare {
                id: red
                color: modelData
                active: parent.paintColor == color
                onClicked: {
                    parent.paintColor = color
                }
            }
        }
    }
```

顏色存儲在一個數組中，作為繪制顏色使用。當用戶點擊一個矩形時，矩形內的顏色被設置為colorTools的paintColor屬性。

為了在畫布上跟蹤鼠標事件，我們使用鼠標區域（MouseArea）覆蓋畫布元素，並連接點擊和移動操作。

```
    Canvas {
        id: canvas
        anchors {
            left: parent.left
            right: parent.right
            top: colorTools.bottom
            bottom: parent.bottom
            margins: 8
        }
        property real lastX
        property real lastY
        property color color: colorTools.paintColor

        onPaint: {
            var ctx = getContext('2d')
            ctx.lineWidth = 1.5
            ctx.strokeStyle = canvas.color
            ctx.beginPath()
            ctx.moveTo(lastX, lastY)
            lastX = area.mouseX
            lastY = area.mouseY
            ctx.lineTo(lastX, lastY)
            ctx.stroke()
        }
        MouseArea {
            id: area
            anchors.fill: parent
            onPressed: {
                canvas.lastX = mouseX
                canvas.lastY = mouseY
            }
            onPositionChanged: {
                canvas.requestPaint()
            }
        }
    }
```

鼠標點擊存儲在laxstX與lastY屬性中。每次鼠標位置的改變會觸發畫布的重繪，這將會調用onPaint操作。

最後繪制用戶的筆劃，在onPaint操作中，我們繪制從最近改變的點上開始繪制一條新的路徑，然後我們從鼠標區域採集新的點，使用選擇的顏色繪制線段到新的點上。鼠標位置被存儲為新改變的位置。

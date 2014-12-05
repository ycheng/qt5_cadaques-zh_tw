# 捕捉圖像（Capturing Images）

Camera元素一個關鍵特性就是可以用來拍照。我們將在一個簡單的定格動畫程序中使用到它。在這章中，你將學習如何顯示一個視圖查找器，截圖和追蹤拍攝的圖片。

用戶界面如下所示。它由三部分組成，背景是一個視圖查找器，右邊有一列按鈕，底部有一連串拍攝的圖片。我們想要拍攝一系列的圖片，然後點擊Play Sequence按鈕。這將回放圖片，並創建一個簡單的定格電影。

![](http://qmlbook.org/_images/camera-ui.png)

相機的視圖查找器部分是在VideoOutput中使用一個簡單的Camera元素作為資源。這將給用戶顯示一個來自相機的流媒體視頻。

```
    VideoOutput {
        anchors.fill: parent
        source: camera
    }

    Camera {
        id: camera
    }
```

使用一個水平放置的ListView顯示來自ListModel的圖片，這個部件叫做imagePaths。在背景中使用一個半透明的Rectangle。

```
    ListModel {
        id: imagePaths
    }

    ListView {
        id: listView

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10

        height: 100

        orientation: ListView.Horizontal
        spacing: 10

        model: imagePaths

        delegate: Image { source: path; fillMode: Image.PreserveAspectFit; height: 100; }

        Rectangle {
            anchors.fill: parent
            anchors.topMargin: -10

            color: "black"
            opacity: 0.5
        }
    }
```

為了拍攝圖像，你需要知道Camera元素包含了一組子對象用來完成各種工作。使用Camera.imageCapture用來捕捉圖像。當你調用capture方法時，一張圖片就被拍攝下來了。Camera.imageCapture的結果將會發送imageCaptured信號，接著發送imageSaved信號。

```
        Button {
            id: shotButton

            width: 200
            height: 75

            text: "Take Photo"
            onClicked: {
                camera.imageCapture.capture();
            }
        }
```

為了攔截子元素的信號，需要一個Connections元素。在這個例子中，我們不需要顯示預覽圖片，僅僅只是將結果圖片加入底部的ListView中。就如下面的例子展示的一樣，圖片保存的路徑由信號的path參數提供。

```
    Connections {
        target: camera.imageCapture

        onImageSaved: {
            imagePaths.append({"path": path})
            listView.positionViewAtEnd();
        }
    }
```

為了顯示預覽，連接imageCaptured信號，並且使用preview信號參數作為Image元素的source。requestId信號參數與imageCaptured和imageSaved一起發送。這個值由capture方法返回。這樣，就可以完整的跟蹤拍攝的圖片了。預覽的圖片首先被使用，然後替換為保存的圖片。然而在這個例子中我們不需要這樣做。

最後是自動回放的部分。使用Timer元素來驅動它，並且加上一些JavaScript。_imageIndex變量被用來跟蹤當前顯示的圖片。當最後一張圖片被顯示時，回放停止。在例子中，當播放序列時，root.state被用來隱藏用戶界面。

```
    property int _imageIndex: -1

    function startPlayback()
    {
        root.state = "playing";
        setImageIndex(0);
        playTimer.start();
    }

    function setImageIndex(i)
    {
        _imageIndex = i;

        if (_imageIndex >= 0 && _imageIndex < imagePaths.count)
            image.source = imagePaths.get(_imageIndex).path;
        else
            image.source = "";
    }

    Timer {
        id: playTimer

        interval: 200
        repeat: false

        onTriggered: {
            if (_imageIndex + 1 < imagePaths.count)
            {
                setImageIndex(_imageIndex + 1);
                playTimer.start();
            }
            else
            {
                setImageIndex(-1);
                root.state = "";
            }
        }
    }
```

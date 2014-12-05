# 視頻流（Video Streams）

VideoOutput元素不被限制與MediaPlayer元素綁定使用的。它也可以直接用來加載實時視頻資源顯示一個流媒體。應用程序使用Camera元素作為資源。來自Camera的視頻流給用戶提供了一個實時流媒體。

```
import QtQuick 2.0
import QtMultimedia 5.0

Item {
    width: 1024
    height: 600

    VideoOutput {
        anchors.fill: parent
        source: camera
    }

    Camera {
        id: camera
    }
}
```

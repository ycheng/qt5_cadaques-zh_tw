# Multimedia

在QtMultimedia模塊中的multimedia元素可以播放和記錄媒體資源，例如聲音，視頻，或者圖片。解碼和編碼的操作由特定的後台完成。例如在Linux上的gstreamer框架，Windows上的DirectShow，和OS X上的QuickTime。
multimedia元素不是QtQuick核心的接口。它的接口通過導入QtMultimedia 5.0來加入，如下所示：

```
import QtMultimedia 5.0
```

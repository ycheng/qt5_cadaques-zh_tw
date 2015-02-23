# 媒體播放（Playing Media）

在QML應用程序中，最基本的媒體應用是播放媒體。使用MediaPlayer元素可以完成它，如果源是一個圖片或者視頻，可以選擇結合VideoOutput元素。MediaPlayer元素有一個source屬性指向需要播放的媒體。當媒體源被綁定後，簡單的調用play函數就可以開始播放。

如果你想播放一個可視化的媒體，例如圖片或者視頻等，你需要配置一個VideoOutput元素。MediaPlayer播放通過source屬性與視頻輸出綁定。

在下面的例子中，給MediaPlayer元素一個視頻文件作為source。一個VideoOutput被創建和綁定到媒體播放器上。一旦主要部件完全初始化，例如在Component.onCompleted中，播放器的play函數被調用。

```
import QtQuick 2.0
import QtMultimedia 5.0
import QtSystemInfo 5.0

Item {
    width: 1024
    height: 600

    MediaPlayer {
        id: player
        source: "trailer_400p.ogg"
    }

    VideoOutput {
        anchors.fill: parent
        source: player
    }

    Component.onCompleted: {
        player.play();
    }

    ScreenSaver {
        screenSaverEnabled: false;
    }
}
// M1>>
```

除了上面介紹的視頻播放，這個例子也包括了一小段代碼用于禁止屏幕保護。這將阻止視頻被中斷。通過設置ScreenSaver元素的screenSaverEnabled屬性為false來完成。通過導入QtSystemInfo 5.0可以使用ScreenSaver元素。

基礎操作例如當播放媒體時可以通過MediaPlayer元素的volume屬性來控制音量。還有一些其它有用的屬性。例如，duration與position屬性可以用來創建一個進度條。如果seekable屬性為true，當撥動進度條時可以更新position屬性。下面這個例子展示了在上面的例子基礎上如何添加基礎播放。

```
    Rectangle {
        id: progressBar

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 100

        height: 30

        color: "lightGray"

        Rectangle {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            width: player.duration>0?parent.width*player.position/player.duration:0

            color: "darkGray"
        }

        MouseArea {
            anchors.fill: parent

            onClicked: {
                if (player.seekable)
                    player.position = player.duration * mouse.x/width;
            }
        }
    }
```

默認情況下position屬性每秒更新一次。這意味著進度條將只會在大跨度下的時間週期下才會更新，需要媒體持續時間足夠長，進度條像素足夠寬。然而，這個可以通過mediaObject屬性的notifyInterval屬性改變。它可以設置每個position之間更新的毫秒數，增加用戶界面的平滑度。

```
    Connections {
        target: player
        onMediaObjectChanged: {
            if (player.mediaObject)
                player.mediaObject.notifyInterval = 50;
        }
    }
```

當使用MediaPlayer創建一個媒體播放器時，最好使用status屬性來監聽播放器。這個屬性是一個枚舉，它枚舉了播放器可能出現的狀態，從MediaPlayer.Buffered到MediaPlayer.InvalidMedia。下面是這些狀態值的總結：

* MediaPlayer.UnknownStatus - 未知狀態

* MediaPlayer.NoMedia - 播放器沒有指定媒體資源，播放停止

* MediaPlayer.Loading - 播放器正在加載媒體

* MediaPlayer.Loaded - 媒體已經加載完畢，播放停止

* MediaPlayer.Stalled - 加載媒體已經停止

* MediaPlayer.Buffering - 媒體正在緩衝

* MediaPlayer.Buffered - 媒體緩衝完成

* MediaPlayer.EndOfMedia - 媒體播放完畢，播放停止

* MediaPlayer.InvalidMedia - 無法播放媒體，播放停止

正如上面提到的這些枚舉項，播放狀態會隨著時間變化。調用play，pause或者stop將會切換狀態，但由于媒體的原因也會影響這些狀態。例如，媒體播放完畢，它將會無效，導致播放停止。當前的播放狀態可以使用playbackState屬性跟蹤。這個值可能是MediaPlayer.PlayingState，MediaPlayer.PasuedState或者MediaPlayer.StoppedState。

使用autoPlay屬性，MediaPlayer在source屬性改變時將會嘗試進入播放狀態。類似的屬性autoLoad將會導致播放器在source屬性改變時嘗試加載媒體。默認下autoLoad是被允許的。

當然也可以讓MediaPlayer循環播放一個媒體項。loops屬性控制source將會被重復播放多少次。設置屬性為MediaPlayer.Infinite將會導致不停的重播。非常適合持續的動畫或者一個重復的背景音樂。

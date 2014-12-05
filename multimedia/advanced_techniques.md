# 高級用法（Advanced Techniques）

## 10.5.1 實現一個播放列表（Implementing a Playlist）

Qt 5 multimedia接口沒有提供播放列表。幸好，它非常容易實現。通過設置模型子項與MediaPlayer元素可以實現它，如下所示。當playstate通過player控制時，Playlist元素負責設置MediaPlayer的source。

```
    Playlist {
        id: playlist

        mediaPlayer: player

        items: ListModel {
            ListElement { source: "trailer_400p.ogg" }
            ListElement { source: "trailer_400p.ogg" }
            ListElement { source: "trailer_400p.ogg" }
        }
    }

    MediaPlayer {
        id: player
    }
```

Playlist元素的第一部分如下，注意使用setIndex函數來設置source元素的索引值。我們也實現了next與previous函數來操作鏈表。

```
Item {
    id: root

    property int index: 0
    property MediaPlayer mediaPlayer
    property ListModel items: ListModel {}

    function setIndex(i)
    {
        console.log("setting index to: " + i);

        index = i;

        if (index < 0 || index >= items.count)
        {
            index = -1;
            mediaPlayer.source = "";
        }
        else
            mediaPlayer.source = items.get(index).source;
    }

    function next()
    {
        setIndex(index + 1);
    }

    function previous()
    {
        setIndex(index + 1);
    }
```

讓播放列表自動播放下一個元素的訣竅是使用MediaPlayer的status屬性。當得到MediaPlayer.EndOfMedia狀態時，索引值增加，恢復播放，或者當列表達到最後時，停止播放。

```
    Connections {
        target: root.mediaPlayer

        onStopped: {
            if (root.mediaPlayer.status == MediaPlayer.EndOfMedia)
            {
                root.next();
                if (root.index == -1)
                    root.mediaPlayer.stop();
                else
                    root.mediaPlayer.play();
            }
        }
    }
```

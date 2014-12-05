# 聲音效果（Sounds Effects）

當播放聲音效果時，從請求播放到真實響應播放的響應時間非常重要。在這種情況下，SoundEffect元素將會派上用場。設置source屬性，一個簡單調用play函數會直接開始播放。

當敲擊屏幕時，可以使用它來完成音效反饋，如下所示：

```
    SoundEffect {
        id: beep
        source: "beep.wav"
    }

    Rectangle {
        id: button

        anchors.centerIn: parent

        width: 200
        height: 100

        color: "red"

        MouseArea {
            anchors.fill: parent
            onClicked: beep.play()
        }
    }
```

這個元素也可以用來完成一個配有音效的轉換。為了從轉換觸發，使用ScriptAction元素。

```
    SoundEffect {
        id: swosh
        source: "swosh.wav"
    }

    transitions: [
        Transition {
            ParallelAnimation {
                ScriptAction { script: swosh.play(); }
                PropertyAnimation { properties: "rotation"; duration: 200; }
            }
        }
    ]
```

除了調用play函數，在MediaPlayer中類似屬性也可以使用。比如volume和loops。loops可以設置為SoundEffect.Infinite來提供無限重復播放。停止播放調用stop函數。

**注意**

**當後台使用PulseAudio時，stop將不會立即停止，但會阻止繼續循環。這是由于底層API的限制造成的。**

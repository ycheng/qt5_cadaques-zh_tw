# 粒子畫筆（Particle Painter）

到目前為止我們只使用了基于粒子畫筆的圖像來實現粒子可視化。Qt也提供了一些其它的粒子畫筆：

* 粒子項（ItemParticle）：基于粒子畫筆的代理

* 自定義粒子（CustomParticle）：基于粒子畫筆的著色器

粒子項可以將QML元素項作為粒子發射。你需要制定自己的粒子代理。

```
    ItemParticle {
        id: particle
        system: particleSystem
        delegate: itemDelegate
    }
```

在這個例子中，我們的代理是一個隨機圖片（使用Math.random()完成），有著白色邊框和隨機大小。

```
    Component {
        id: itemDelegate
        Rectangle {
            id: container
            width: 32*Math.ceil(Math.random()*3); height: width
            color: 'white'
            Image {
                anchors.fill: parent
                anchors.margins: 4
                source: 'assets/fruits'+Math.ceil(Math.random()*10)+'.jpg'
            }
        }
    }
```

每秒發出四個粒子，每個粒子擁有4秒的生命週期。粒子自動淡入淡出。

![](http://qmlbook.org/_images/itemparticle.png)

對于更多的動態情況，也可以由你自己創建一個子項，讓粒子系統來控制它，使用take(item, priority)來完成。粒子系統控制你的粒子就像控制普通的粒子一樣。你可以使用give(item)來拿回子項的控制權。你也可以操作子項粒子，甚至可以使用freeze(item)來停止它，使用unfreeze(item)來恢復它。

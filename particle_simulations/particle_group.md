# 粒子組（Particle Group）

在本章開始時，我們已經介紹過粒子組了，默認下，粒子都屬于空組（""）。使用GroupGoal控制器可以改變粒子組。為了實現可視化，我們創建了一個煙花示例，火箭進入，在空中爆炸形成壯觀的煙火。

![](http://qmlbook.org/_images/firework_teaser.png)

這個例子分為兩部分。第一部分叫做“發射時間（Launch Time）”連接場景，加入粒子組，第二部分叫做“爆炸煙花（Let there be firework）”，專注于粒子組的變化。

讓我們看看這兩部分。

**發射時間（Launch Time）**

首先我們創建一個典型的黑色場景：

```
import QtQuick 2.0
import QtQuick.Particles 2.0

Rectangle {
    id: root
    width: 480; height: 240
    color: "#1F1F1F"
    property bool tracer: false
}
```

tracer使用被用作場景追蹤的開關，然後定義我們的粒子系統：

```
ParticleSystem {
    id: particleSystem
}
```

我們添加兩種粒子圖片畫筆（一個用于火箭，一個用于火箭噴射煙霧）：

```
ImageParticle {
    id: smokePainter
    system: particleSystem
    groups: ['smoke']
    source: "assets/particle.png"
    alpha: 0.3
    entryEffect: ImageParticle.None
}

ImageParticle {
    id: rocketPainter
    system: particleSystem
    groups: ['rocket']
    source: "assets/rocket.png"
    entryEffect: ImageParticle.None
}
```

你可以看到在這些畫筆定義中，它們使用groups屬性來定義粒子的歸屬。只需要定義一個名字，Qt Quick將會隱式的創建這個分組。

現在我們需要將這些火箭發射到空中。我們在場景底部創建一個粒子發射器，將速度設置為朝上的方向。為了模擬重力，我們設置一個向下的加速度：

```
Emitter {
    id: rocketEmitter
    anchors.bottom: parent.bottom
    width: parent.width; height: 40
    system: particleSystem
    group: 'rocket'
    emitRate: 2
    maximumEmitted: 4
    lifeSpan: 4800
    lifeSpanVariation: 400
    size: 32
    velocity: AngleDirection { angle: 270; magnitude: 150; magnitudeVariation: 10 }
    acceleration: AngleDirection { angle: 90; magnitude: 50 }
    Tracer { color: 'red'; visible: root.tracer }
}
```

發射器屬于'rocket'粒子組，與我們的火箭粒子畫筆相同。通過粒子組將它們聯系在一起。發射器將粒子發射到'rocket'粒子組中，火箭畫筆將會繪制它們。

對于煙霧，我們使用一個追蹤發射器，它將會跟在火箭的後面。我們定義'smoke'組，並且它會跟在'rocket'粒子組後面：

```
TrailEmitter {
    id: smokeEmitter
    system: particleSystem
    emitHeight: 1
    emitWidth: 4
    group: 'smoke'
    follow: 'rocket'
    emitRatePerParticle: 96
    velocity: AngleDirection { angle: 90; magnitude: 100; angleVariation: 5 }
    lifeSpan: 200
    size: 16
    sizeVariation: 4
    endSize: 0
}
```

向下模擬從火箭裡面噴射出的煙。emitHeight與emitWidth指定了圍繞跟隨在煙霧粒子發射後的粒子。如果不指定這個值，跟隨的粒子將會被拿掉，但是對于這個例子，我們想要提升顯示效果，粒子流從一個接近于火箭尾部的中間點發射出。

如果你運行這個例子，你會發現一些火箭正常飛起，一些火箭卻飛出場景。這不是我們想要的，我們需要在它們離開場景前讓他們慢下來，這裡可以使用摩擦控制器來設置一個最小閾值：

```
Friction {
    groups: ['rocket']
    anchors.top: parent.top
    width: parent.width; height: 80
    system: particleSystem
    threshold: 5
    factor: 0.9
}
```

在摩擦控制器中，你也需要定義哪個粒子組受控制器影響。當火箭經過從頂部向下80像素的區域時，所有的火箭將會以0.9的factor減慢（你可以試試100，你會發現它們立即停止了），直到它們的速度達到每秒5個像素。隨著火箭粒子向下的加速度繼續生效，火箭開始向地面下沉，直到它們的生命週期結束。

由于在空氣中向上運動是非常困難的，並且非常不穩定，我們在火箭上升時模擬一些紊流：

```
Turbulence {
    groups: ['rocket']
    anchors.bottom: parent.bottom
    width: parent.width; height: 160
    system: particleSystem
    strength: 25
    Tracer { color: 'green'; visible: root.tracer }
}
```

當然，紊流控制器也需要定義它會影響哪些粒子組。紊流控制器的區域從底部向上160像素（直到摩擦控制器邊界上），它們也可以相互覆蓋。

當你運行程序時，你可以看到火箭開始上升，然後在摩擦控制器區域開始減速，向下的加速度仍然生效，火箭開始後退。下一步我們開始制作爆炸煙花。

![](http://qmlbook.org/_images/firework_rockets.png)

**注意**

**使用tracers跟蹤區域可以顯示場景中的不同區域。火箭粒子發射的紅色區域，藍色區域是紊流控制器區域，最後在綠色的摩擦控制器區域減速，並且再次下降是由于向下的加速度仍然生效。**

**爆炸煙花（Let there be fireworks）**

讓火箭變成美麗的煙花，我們需要添加一個粒子組來封裝這個變化：

```
ParticleGroup {
    name: 'explosion'
    system: particleSystem
}
```

我們使用GroupGoal控制器來改變粒子組。這個組控制器被放置在屏幕中間垂直線附近，它將會影響'rocket'粒子組。使用groupGoal屬性，我們設置目標組改變為我們之前定義的'explosion'組：

```
GroupGoal {
    id: rocketChanger
    anchors.top: parent.top
    width: parent.width; height: 80
    system: particleSystem
    groups: ['rocket']
    goalState: 'explosion'
    jump: true
    Tracer { color: 'blue'; visible: root.tracer }
}
```

jump屬性定義了粒子組的變化是立即變化而不是在某個時間段後變化。

**注意**

**在Qt5的alpha發布版中，粒子組的持續改變無法工作，有好的建議嗎？**

由于火箭粒子變為我們的爆炸粒子，當火箭粒子進入GroupGoal控制器區域時，我們需要在粒子組中添加一個煙花：

```
// inside particle group
TrailEmitter {
    id: explosionEmitter
    anchors.fill: parent
    group: 'sparkle'
    follow: 'rocket'
    lifeSpan: 750
    emitRatePerParticle: 200
    size: 32
    velocity: AngleDirection { angle: -90; angleVariation: 180; magnitude: 50 }
}
```

爆炸釋放粒子到'sparkle'粒子組。我們稍後會定義這個組的粒子畫筆。軌蹟發射器跟隨火箭粒子每秒發射200個火箭爆炸粒子。粒子的方向向上，並改變180度。

由于向'sparkle'粒子組發射粒子，我們需要定義一個粒子畫筆用于繪制這個組的粒子：

```
ImageParticle {
    id: sparklePainter
    system: particleSystem
    groups: ['sparkle']
    color: 'red'
    colorVariation: 0.6
    source: "assets/star.png"
    alpha: 0.3
}
```

閃爍的煙花是紅色的星星，使用接近透明的顏色來渲染出發光的效果。

為了使煙花更加壯觀，我們也需要添加給我們的粒子組添加第二個軌蹟發射器，它向下發射錐形粒子：

```
// inside particle group
TrailEmitter {
    id: explosion2Emitter
    anchors.fill: parent
    group: 'sparkle'
    follow: 'rocket'
    lifeSpan: 250
    emitRatePerParticle: 100
    size: 32
    velocity: AngleDirection { angle: 90; angleVariation: 15; magnitude: 400 }
}
```

其它的爆炸軌蹟發射器與這個設置類似，就這樣。

下面是最終結果。

![](http://qmlbook.org/_images/firework_final.png)

下面是火箭煙花的所有代碼。

```
import QtQuick 2.0
import QtQuick.Particles 2.0

Rectangle {
    id: root
    width: 480; height: 240
    color: "#1F1F1F"
    property bool tracer: false

    ParticleSystem {
        id: particleSystem
    }

    ImageParticle {
        id: smokePainter
        system: particleSystem
        groups: ['smoke']
        source: "assets/particle.png"
        alpha: 0.3
    }

    ImageParticle {
        id: rocketPainter
        system: particleSystem
        groups: ['rocket']
        source: "assets/rocket.png"
        entryEffect: ImageParticle.Fade
    }

    Emitter {
        id: rocketEmitter
        anchors.bottom: parent.bottom
        width: parent.width; height: 40
        system: particleSystem
        group: 'rocket'
        emitRate: 2
        maximumEmitted: 8
        lifeSpan: 4800
        lifeSpanVariation: 400
        size: 32
        velocity: AngleDirection { angle: 270; magnitude: 150; magnitudeVariation: 10 }
        acceleration: AngleDirection { angle: 90; magnitude: 50 }
        Tracer { color: 'red'; visible: root.tracer }
    }

    TrailEmitter {
        id: smokeEmitter
        system: particleSystem
        group: 'smoke'
        follow: 'rocket'
        size: 16
        sizeVariation: 8
        emitRatePerParticle: 16
        velocity: AngleDirection { angle: 90; magnitude: 100; angleVariation: 15 }
        lifeSpan: 200
        Tracer { color: 'blue'; visible: root.tracer }
    }

    Friction {
        groups: ['rocket']
        anchors.top: parent.top
        width: parent.width; height: 80
        system: particleSystem
        threshold: 5
        factor: 0.9

    }

    Turbulence {
        groups: ['rocket']
        anchors.bottom: parent.bottom
        width: parent.width; height: 160
        system: particleSystem
        strength:25
        Tracer { color: 'green'; visible: root.tracer }
    }


    ImageParticle {
        id: sparklePainter
        system: particleSystem
        groups: ['sparkle']
        color: 'red'
        colorVariation: 0.6
        source: "assets/star.png"
        alpha: 0.3
    }

    GroupGoal {
        id: rocketChanger
        anchors.top: parent.top
        width: parent.width; height: 80
        system: particleSystem
        groups: ['rocket']
        goalState: 'explosion'
        jump: true
        Tracer { color: 'blue'; visible: root.tracer }
    }

    ParticleGroup {
        name: 'explosion'
        system: particleSystem

        TrailEmitter {
            id: explosionEmitter
            anchors.fill: parent
            group: 'sparkle'
            follow: 'rocket'
            lifeSpan: 750
            emitRatePerParticle: 200
            size: 32
            velocity: AngleDirection { angle: -90; angleVariation: 180; magnitude: 50 }
        }

        TrailEmitter {
            id: explosion2Emitter
            anchors.fill: parent
            group: 'sparkle'
            follow: 'rocket'
            lifeSpan: 250
            emitRatePerParticle: 100
            size: 32
            velocity: AngleDirection { angle: 90; angleVariation: 15; magnitude: 400 }
        }
    }
}
```

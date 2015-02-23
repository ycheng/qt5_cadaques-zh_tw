# 粒子控制（Affecting Particles）

粒子由粒子發射器發出。在粒子發射出後，發射器無法再改變粒子。粒子控制器允許你控制發射後的粒子參數。

控制器的每個類型使用不同的方法來影響粒子：

* 生命週期（Age）- 修改粒子的生命週期

* 吸引（Attractor）- 吸引粒子朝向指定點

* 摩擦（Friction）- 按當前粒子速度成正比減慢運動

* 重力（Gravity）- 設置一個角度的加速度

* 紊流（Turbulence）- 強制基于噪聲圖像方式的流動

* 漂移（Wander）- 隨機變化的軌蹟

* 組目標（GroupGoal）- 改變一組粒子群的狀態

* 子粒子（SpriteGoal）- 改變一個子粒子的狀態

**生命週期（Age）**

允許粒子老得更快，lifeLeft屬性指定了粒子的有多少的生命週期。

```
    Age {
        anchors.horizontalCenter: parent.horizontalCenter
        width: 240; height: 120
        system: particleSystem
        advancePosition: true
        lifeLeft: 1200
        once: true
        Tracer {}
    }
```

在這個例子中，當粒子的生命週期達到1200毫秒後，我們將會縮短上方的粒子的生命週期一次。由于我們設置了advancePosition為true，當粒子的生命週期到達1200毫秒後，我們將會再一次在這個位置看到粒子出現。

![](http://qmlbook.org/_images/age.png)

**吸引（Attractor）**

吸引會將粒子朝指定的點上吸引。這個點使用pointX與pointY來指定，它是與吸引區域的幾何形狀相對的。strength指定了吸引的力度。在我們的例子中，我們讓粒子從左向右運動，吸引放在頂部，有一半運動的粒子會穿過吸引區域。控制器只會影響在它們幾何形狀內的粒子。這種分離讓我們可以同步看到正常的流動與受影響的流動。

```
    Attractor {
        anchors.horizontalCenter: parent.horizontalCenter
        width: 160; height: 120
        system: particleSystem
        pointX: 0
        pointY: 0
        strength: 1.0
        Tracer {}
    }
```

很容易看出上半部分粒子受到吸引。吸引點被設置為吸引區域的左上角（0/0點），吸引力為1.0。

![](http://qmlbook.org/_images/attractor.png)

**摩擦（Friction）**

摩擦控制器使用一個參數（factor）減慢粒子運動，直到達到一個閾值。

```
    Friction {
        anchors.horizontalCenter: parent.horizontalCenter
        width: 240; height: 120
        system: particleSystem
        factor : 0.8
        threshold: 25
        Tracer {}
    }
```

在上部的摩擦區域，粒子被按照0.8的參數（factor）減慢，直到粒子的速度達到25像素每秒。這個閾值像一個過濾器。粒子運動速度高于閾值將會按照給定的參數來減慢它。

![](http://qmlbook.org/_images/friction.png)

**重力（Gravity）**

重力控制器應用在加速度上，在我們的例子中，我們使用一個角度方向將粒子從底部發射到頂部。右邊是為控制區域，左邊使用重力控制器控制，重力方向為90度方向（垂直向下），梯度值為50。

```
    Gravity {
        width: 240; height: 240
        system: particleSystem
        magnitude: 50
        angle: 90
        Tracer {}
    }
```

左邊的粒子試圖爬上去，但是穩定向下的加速度將它們按照重力的方向拖拽下來。

![](http://qmlbook.org/_images/gravity.png)

**紊流（Turbulence）**

紊流控制器，對粒子應用了一個混亂映射方向力的矢量。這個混亂映射是由一個噪聲圖像定義的。可以使用noiseSource屬性來定義噪聲圖像。strength定義了矢量對于粒子運動的影響有多大。

```
    Turbulence {
        anchors.horizontalCenter: parent.horizontalCenter
        width: 240; height: 120
        system: particleSystem
        strength: 100
        Tracer {}
    }
```

在這個例子中，上部區域被紊流影響。它們的運動看起來是不穩定的。不穩定的粒子偏差值來自原路徑定義的strength。

![](http://qmlbook.org/_images/turbulence.png)

**漂移（Wander）**

漂移控制器控制了軌蹟。affectedParameter屬性可以指定哪個參數控制了漂移（速度，位置或者加速度）。pace屬性制定了每秒最多改變的屬性。yVariance指定了y組件對粒子軌蹟的影響。

```
    Wander {
        anchors.horizontalCenter: parent.horizontalCenter
        width: 240; height: 120
        system: particleSystem
        affectedParameter: Wander.Position
        pace: 200
        yVariance: 240
        Tracer {}
    }
```

在頂部漂移控制器的粒子被隨機的軌蹟改變。在這種情境下，每秒改變粒子y方向的位置200次。

![](http://qmlbook.org/_images/wander.png)

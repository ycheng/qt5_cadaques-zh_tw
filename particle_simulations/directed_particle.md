# 粒子方向（Directed Particle）

我們已經看到了粒子的旋轉，但是我們的粒子需要一個軌蹟。軌蹟由速度或者粒子隨機方向的加速度指定，也可以叫做矢量空間。

有多種可用矢量空間用來定義粒子的速度或加速度：

* 角度方向（AngleDirection）- 使用角度的方向變化。

* 點方向（PointDirection）-  使用x,y組件組成的方向變化。

* 目標方向（TargetDirection）- 朝著目標點的方向變化。

![](http://qmlbook.org/_images/particle_directions.png)

讓我們在場景下試著用速度方向將粒子從左邊移動到右邊。

首先使用角度方向（AngleDirection）。我們使用AngleDirection元素作為我們的發射器（Emitter）的速度屬性：

```
velocity: AngleDirection { }
```

粒子的發射將會使用指定的角度屬性。角度值在0到360度之間，0度代表指向右邊。在我們的例子中，例子將會移動到右邊，所以0度已經指向右邊方向。粒子的角度變化在+/-15度之間：

```
velocity: AngleDirection {
    angle: 0
    angleVariation: 15
}
```

現在我們已經設置了方向，下面是指定粒子的速度。它由一個梯度值定義，這個梯度值定義了每秒像素的變化。正如我們設置大約640像素，梯度值為100，看起來是一個不錯的值。這意味著平均一個6.4秒生命週期的粒子可以穿越我們看到的區域。為了讓粒子的穿越看起來更加有趣，我們使用magnitudeVariation來設置梯度值的變化，這個值是我們的梯度值的一半：

```
velocity: AngleDirection {
    ...
    magnitude: 100
    magnitudeVariation: 50
}
```

![](http://qmlbook.org/_images/angledirection.png)

下面是完整的源碼，平均的生命週期被設置為6..4秒。我們設置發射器的寬度和高度為1個像素，這意味著所有的粒子都從相同的位置發射出去，然後基于我們給定的軌蹟運動。

```
    Emitter {
        id: emitter
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        width: 1; height: 1
        system: particleSystem
        lifeSpan: 6400
        lifeSpanVariation: 400
        size: 32
        velocity: AngleDirection {
            angle: 0
            angleVariation: 15
            magnitude: 100
            magnitudeVariation: 50
        }
    }
```

那麼加速度做些什麼？加速度是每個粒子加速度矢量，它會在運動的時間中改變速度矢量。例如我們做一個星星按照弧形運動的軌蹟。我們將會改變我們的速度方向為-45度，然後移除變量，可以得到一個更連貫的弧形軌蹟：

```
velocity: AngleDirection {
    angle: -45
    magnitude: 100
}
```

加速度的方向為90度（向下），加速度為速度的四分之一：

```
acceleration: AngleDirection {
    angle: 90
    magnitude: 25
}
```

結果是中間左方到右下的一個弧。

![](http://qmlbook.org/_images/angledirection2.png)
這個值是在不斷的嘗試與錯誤中發現的。

下面是發射器完整的代碼。

```
    Emitter {
        id: emitter
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        width: 1; height: 1
        system: particleSystem
        emitRate: 10
        lifeSpan: 6400
        lifeSpanVariation: 400
        size: 32
        velocity: AngleDirection {
            angle: -45
            angleVariation: 0
            magnitude: 100
        }
        acceleration: AngleDirection {
            angle: 90
            magnitude: 25
        }
    }
```

在下一個例子中，我們將使用點方向（PointDirection）矢量空間來再一次演示粒子從左到右的運動。

一個點方向（PointDirection）是由x和y組件組成的矢量空間。例如，如果你想粒子以45度的矢量運動，你需要為x，y指定相同的值。

在我們的例子中，我們希望粒子在從左到右的例子中建立一個15度的圓錐。我們指定一個坐標方向（PointDirection）作為我們速度矢量空間：

```
velocity: PointDirection { }
```

為了達到運動速度每秒100個像素，我們設置x為100,。15度角（90度的1/6）,我們指定y變量為100/6：

```
velocity: PointDirection {
    x: 100
    y: 0
    xVariation: 0
    yVariation: 100/6
}
```

結果是粒子的運動從左到右構成了一個15度的圓錐。

![](http://qmlbook.org/_images/pointdirection.png)

現在是最後一個方案，目標方向（TargetDirection）。目標方向允許我們指定發射器或者一個QML項的x,y坐標值。當一個QML項的中心點成為一個目標點時，你可以指定目標變化值是x目標值的1/6來完成一個15度的圓錐：

```
velocity: TargetDirection {
    targetX: 100
    targetY: 0
    targetVariation: 100/6
    magnitude: 100
}
```

**注意**

**當你期望發射粒子朝著指定的x,y坐標值流動時，目標方向是非常好的方案。**

我沒有再貼出結果圖，因為它與前一個結果相同，取而代之的有一個問題留給你。

在下圖的紅色和綠色圓指定每個目標項的目標方向速度的加速屬性。每個目標方向有相同的參數。那麼哪一個負責速度，哪一個負責加速度？

![](http://qmlbook.org/_images/directionquest.png)

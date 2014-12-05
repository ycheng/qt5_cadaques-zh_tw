# 簡單的模擬（Simple Simulation）

讓我們從一個簡單的模擬開始學習。Qt Quick使用簡單的粒子渲染非常簡單。下面是我們需要的：

* 綁定所有元素到一個模擬的粒子系統（ParticleSystem）。

* 一個向系統發射粒子的發射器（Emitter）。

* 一個ParticlePainter派生元素，用來實現粒子的可視化。

```
import QtQuick 2.0
import QtQuick.Particles 2.0

Rectangle {
    id: root
    width: 480; height: 160
    color: "#1f1f1f"

    ParticleSystem {
        id: particleSystem
    }

    Emitter {
        id: emitter
        anchors.centerIn: parent
        width: 160; height: 80
        system: particleSystem
        emitRate: 10
        lifeSpan: 1000
        lifeSpanVariation: 500
        size: 16
        endSize: 32
        Tracer { color: 'green' }
    }

    ImageParticle {
        source: "assets/particle.png"
        system: particleSystem
    }
}
```

例子的運行結果如下所示：

![](http://qmlbook.org/_images/simpleparticles.png)

我們使用一個80x80的黑色矩形框作為我們的根元素和背景。然後我們定義一個粒子系統（ParticleSystem）。這通常是粒子系統綁定所有元素的第一步。下一個元素是發射器（Emitter），它定義了基于矩形框的發射區域和發射粒子的基礎屬性。發射器使用system屬性與粒子系統進行綁定。

在這個例子中，發射器每秒發射10個粒子（emitRate:10）到發射器的區域，每個粒子的生命週期是1000毫秒（lifeSpan:1000），一個已發射粒子的生命週期變化是500毫秒（lifeSpanVariation:500）。一個粒子開始的大小是16個像素（size:16），生命週期結束時的大小是32個像素（endSize:32）。

綠色邊框的矩形是一個跟蹤元素，用來顯示發射器的幾何形狀。這個可視化展示了粒子在發射器矩形框內發射，但是渲染效果不被限制在發射器的矩形框內。渲染位置依賴于粒子的壽命和方向。這將幫助我們更加清楚的知道如何改變粒子的方向。

發射器發射邏輯粒子。一個邏輯粒子的可視化使用粒子畫筆（ParticlePainter）來實現，在這個例子中我們使用了圖像粒子（ImageParticle），使用一個圖片鏈接作為源屬性。圖像粒子也有其它的屬性用來控制粒子的外觀。

* 發射頻率（emitRate）- 每秒粒子發射數（默認為10個）。

* 生命週期（lifeSpan）- 粒子持續時間（單位毫秒，默認為1000毫秒）。

* 初始大小（size），結束大小（endSize）- 粒子在它的生命週期的開始和結束時的大小（默認為16像素）。

改變這些屬性將會徹底改變顯示結果：

```
    Emitter {
        id: emitter
        anchors.centerIn: parent
        width: 20; height: 20
        system: particleSystem
        emitRate: 40
        lifeSpan: 2000
        lifeSpanVariation: 500
        size: 64
        sizeVariation: 32
        Tracer { color: 'green' }
    }
```

增加發射頻率為40，生命週期增加到2秒，開始大小為64像素，結束大小減少到32像素。

![](http://qmlbook.org/_images/simpleparticles2.png)

增加結束大小（endSize）可能會導致白色的背景出現。請注意粒子只有發射被限制在發射器定義的區域內，而粒子渲染是不會考慮這個參數的。

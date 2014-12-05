# 漸變（Gradients）

畫布中可以使用顏色填充也可以使用漸變或者圖像來填充。

```
    onPaint: {
        var ctx = getContext("2d")

        var gradient = ctx.createLinearGradient(100,0,100,200)
        gradient.addColorStop(0, "blue")
        gradient.addColorStop(0.5, "lightsteelblue")
        ctx.fillStyle = gradient
        ctx.fillRect(50,50,100,100)
    }
```

在這個例子中，漸變色定義在開始點（100,0）到結束點（100,200）。在我們畫布中是一個中間垂直的線。漸變色在停止點定義一個顏色，範圍從0.0到1.0。這裡我們使用一個藍色作為0.0（100,0），一個高亮剛藍色作為0.5（100,200）。漸變色的定義比我們想要繪制的矩形更大，所以矩形在它定義的範圍內對漸變進行了裁剪。

![](http://qmlbook.org/_images/gradient.png)

**注意**

**漸變色是在畫布坐標下定義的，而不是在繪制路徑相對坐標下定義的。畫布中沒有相對坐標的概念。**

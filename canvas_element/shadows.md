# 陰影（Shadows）

**注意**

**在Qt5的alpha版本中，我們使用陰影遇到了一些問題。**

2D對象的路徑可以使用陰影增強顯示效果。陰影是一個區域的輪廓線使用偏移量，顏色和模糊來實現的。所以你需要指定一個陰影顏色（shadowColor），陰影X軸偏移值（shadowOffsetX），陰影Y軸偏移值（shadowOffsetY）和陰影模糊（shadowBlur）。這些參數的定義都使用2D context來定義。2D context是唯一的繪制操作接口。

陰影也可以用來創建發光的效果。在下面的例子中我們使用白色的光創建了一個“Earth”的文本。在一個黑色的背景上可以有更加好的顯示效果。

首先我們繪制黑色背景：

```
        // setup a dark background
        ctx.strokeStyle = "#333"
        ctx.fillRect(0,0,canvas.width,canvas.height);
```

然後定義我們的陰影配置：

```
        ctx.shadowColor = "blue";
        ctx.shadowOffsetX = 2;
        ctx.shadowOffsetY = 2;
        // next line crashes
        // ctx.shadowBlur = 10;
```

最後我們使用加粗的，80像素寬度的Ubuntu字體來繪制“Earth”文本：

```
        ctx.font = 'Bold 80px Ubuntu';
        ctx.fillStyle = "#33a9ff";
        ctx.fillText("Earth",30,180);
```

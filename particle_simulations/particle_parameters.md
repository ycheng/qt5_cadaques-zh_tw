# 粒子參數（Particle Parameters）

我們已經知道通過改變發射器的行為就可以改變我們的粒子模擬。粒子畫筆被用來繪制每一個粒子。
回到我們之前的粒子中，我們更新一下我們的圖片粒子畫筆（ImageParticle）。首先我們改變粒子圖片為一個小的星形圖片：

```
ImageParticle {
    ...
    source: 'assets/star.png'
}
```

粒子使用金色來進行初始化，不同的粒子顏色變化範圍為+/- 20%。

```
color: '#FFD700'
colorVariation: 0.2
```

為了讓場景更加生動，我們需要旋轉粒子。每個粒子首先按順時針旋轉15度，不同的粒子在+/-5度之間變化。每個例子會不斷的以每秒45度旋轉。每個粒子的旋轉速度在+/-15度之間變化：

```
rotation: 15
rotationVariation: 5
rotationVelocity: 45
rotationVelocityVariation: 15
```

最後，我們改變粒子的入場效果。 這個效果是粒子產生時的效果，在這個例子中，我們希望使用一個縮放效果：

```
entryEffect: ImageParticle.Scale
```

現在我們可以看到旋轉的星星出現在我們的屏幕上。

![](http://qmlbook.org/_images/particleparameters.png)

下面是我們如何改變圖片粒子畫筆的代碼段。

```
    ImageParticle {
        source: "assets/star.png"
        system: particleSystem
        color: '#FFD700'
        colorVariation: 0.2
        rotation: 0
        rotationVariation: 45
        rotationVelocity: 15
        rotationVelocityVariation: 15
        entryEffect: ImageParticle.Scale
    }
```

# 概念（Concept）

粒子模擬的核心是粒子系統（ParticleSystem），它控制了共享時間線。一個場景下可以有多個粒子系統，每個都有自己獨立的時間線。一個粒子使用發射器元素（Emitter）發射，使用粒子畫筆（ParticlePainter）實現可視化，它可以是一張圖片，一個QML項或者一個著色項（shader item）。一個發射器元素（Emitter）也提供向量來控制粒子方向。一個粒子被發送後就再也無法控制。粒子模型提供粒子控制器（Affector），它可以控制已發射粒子的參數。

在一個系統中，粒子可以使用粒子群元素（ParticleGroup）來共享移動時間。默認下，每個例子都屬于空（""）組。

![](http://qmlbook.org/_images/particlesystem.png)

* 粒子系統（ParticleSystem）- 管理發射器之間的共享時間線。

* 發射器（Emitter）- 向系統中發射邏輯粒子。

* 粒子畫筆（ParticlePainter）- 實現粒子可視化。

* 方向（Direction）- 已發射粒子的向量空間。

* 粒子組（ParticleGroup）- 每個粒子是一個粒子組的成員。

* 粒子控制器（Affector）- 控制已發射粒子。

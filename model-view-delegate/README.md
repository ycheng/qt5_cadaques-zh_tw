# Model-View-Delegate

**注意**

**最後一次構建：2014年1月20日下午18:00。**

**這章的源代碼能夠在[assetts folder](http://qmlbook.org/assets)找到。**

在QtQuick中，數據通過model-view（模型-視圖）分離。對于每個view（視圖），每個數據元素的可視化都分給一個代理（delegate）。QtQuick附帶了一組預定義的模型與視圖。想要使用這個系統，必須理解這些類，並且知道如何創建合適的代理來獲得正確的顯示和交互。

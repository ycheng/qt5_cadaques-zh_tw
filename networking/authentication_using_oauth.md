# 使用開放授權登陸驗證（Authentication using OAuth）

OAuth是一個開放協議，允許簡單的安全驗證，是來自web的典型方法，用于移動和桌面應用程序。使用OAuth對通常的web服務的客戶端進行身份驗證，例如Google，Facebook和Twitter。

**注意**

**對于自定義的web服務，你也可以使用典型的HTTP身份驗證，例如使用XMLHttpRequest的用戶名和密碼的獲取方法（比如xhr.open(verb,url,true,username,password））。**

Auth目前不是QML/JS的接口，你需要寫一些C++代碼並且將身份驗證導入到QML/JS中。另一個問題是安全的存儲訪問密碼。

下面這些是我找到的有用的連接：

* http://oauth.net

* http://hueniverse.com/oauth/

* https://github.com/pipacs/o2

* http://www.johanpaul.com/blog/2011/05/oauth2-explained-with-qt-quick/

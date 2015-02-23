# 應用程序類型（Application Types）

這一節貫穿了可能使用Qt5編寫的不同類型的應用程序。沒有任何建議的選擇，只是想告訴讀者Qt5通常情況下能做些什麼。

## 2.3.1 控制台應用程序

一個控制台應用程序不需要提供任何人機交互圖形界面通常被稱作系統服務，或者通過命令行來運行。Qt5附帶了一系列現成的組件來幫助你非常有效的創建跨平台的控制台應用程序。例如網絡應用程序編程接口或者文件應用程序編程接口，字符串的處理，自Qt5.1發布的高效的命令解析器。由于Qt是基于C++的高級應用程序接口，你能夠快速的編程並且程序擁有快速的執行速度。不要認為Qt僅僅只是用戶界面工具，它也提供了許多其它的功能。

**字符串處理**

在第一個例子中我們展示了怎樣簡單的增加兩個字符串常量。這不是一個有用的應用程序，但能讓你了解本地端C++應用程序沒有事件循環時是什麼樣的。

```
// module or class includes
#include <QtCore>

// text stream is text-codec aware
QTextStream cout(stdout, QIODevice::WriteOnly);

int main(int argc, char** argv)
{
    // avoid compiler warnings
    Q_UNUSED(argc)
    Q_UNUSED(argv)
    QString s1("Paris");
    QString s2("London");
    // string concatenation
    QString s = s1 + " " + s2 + "!";
    cout << s << endl;
}
```

**容器類**

這個例子在應用程序中增加了一個鏈表和一個鏈表迭代器。Qt自帶大量方便使用的容器類，並且其中的元素使用相同的應用程序接口模式。

```
QString s1("Hello");
QString s2("Qt");
QList<QString> list;
// stream into containers
list <<  s1 << s2;
// Java and STL like iterators
QListIterator<QString> iter(list);
while(iter.hasNext()) {
    cout << iter.next();
    if(iter.hasNext()) {
        cout << " ";
    }
}
cout << "!" << endl;
```

這裡我們展示了一些高級的鏈表函數，允許你在一個字符串中加入一個鏈表的字符串。當你需要持續的文本輸入時非常的方便。使用QString::split()函數可以將這個操作逆向（將字符串轉換為字符串鏈表）。

```
QString s1("Hello");
QString s2("Qt");
// convenient container classes
QStringList list;
list <<  s1 << s2;
// join strings
QString s = list.join(" ") + "!";
cout << s << endl;
```

**文件IO**

下一個代碼片段我們從本地讀取了一個CSV文件並且遍歷提取每一行的每一個單元的數據。我們從CSV文件中獲取大約20行的編碼。文件讀取僅僅給了我們一個比特流，為了有效的將它轉換為可以使用的Unicode文本，我們需要使用這個文件作為文本流的底層流數據。編寫CSV文件，你只需要以寫入的方式打開一個文件並且一行一行的輸入到文件流中。

```
QList<QStringList> data;
// file operations
QFile file("sample.csv");
if(file.open(QIODevice::ReadOnly)) {
    QTextStream stream(&file);
    // loop forever macro
    forever {
        QString line = stream.readLine();
        // test for empty string 'QString("")'
        if(line.isEmpty()) {
            continue;
        }
        // test for null string 'String()'
        if(line.isNull()) {
            break;
        }
        QStringList row;
        // for each loop to iterate over containers
        foreach(const QString& cell, line.split(",")) {
            row.append(cell.trimmed());
        }
        data.append(row);
    }
}
// No cleanup necessary.
```

現在我們結束Qt關于基于控制台應用程序小節。

## 2.3.2 窗口應用程序

基于控制台的應用程序非常方便，但是有時候你需要有一些用戶界面。但是基于用戶界面的應用程序需要後端來寫入/讀取文件，使用網絡進行通訊或者保存數據到一個容器中。

在第一個基于窗口的應用程序代碼片段，我們僅僅只創建了一個窗口並顯示它。沒有父對象的窗口部件是Qt世界中的一個窗口。我們使用智能指針來確保當智能指針指向範圍外時窗口會被刪除掉。

這個應用程序對象封裝了Qt的運行，調用exec開始我們的事件循環。從這裡開始我們的應用程序只響應由鼠標或者鍵盤或者其它的例如網絡或者文件IO的事件觸發。應用程序也只有在事件循環退出時才退出，在應用程序中調用"quit()"或者關掉窗口來退出。
當你運行這段代碼的時候你可以看到一個240乘以120像素的窗口。

```
#include <QtGui>

int main(int argc, char** argv)
{
    QApplication app(argc, argv);
    QScopedPointer<QWidget> widget(new CustomWidget());
    widget->resize(240, 120);
    widget->show();
    return app.exec();
}
```

**自定義窗口部件**

當你使用用戶界面時你需要創建一個自定義的窗口部件。典型的窗口是一個窗口部件區域的繪制調用。附加一些窗口部件內部如何處理外部觸發的鍵盤或者鼠標輸入。為此我們需要繼承QWidget並且重寫幾個函數來繪制和處理事件。

```
#ifndef CUSTOMWIDGET_H
#define CUSTOMWIDGET_H

#include <QtWidgets>

class CustomWidget : public QWidget
{
    Q_OBJECT
public:
    explicit CustomWidget(QWidget *parent = 0);
    void paintEvent(QPaintEvent *event);
    void mousePressEvent(QMouseEvent *event);
    void mouseMoveEvent(QMouseEvent *event);
private:
    QPoint m_lastPos;
};

#endif // CUSTOMWIDGET_H
```

在實現中我們繪制了窗口的邊界並在鼠標最後的位置上繪制了一個小的矩形框。這是一個非常典型的低層次的自定義窗口部件。鼠標或者鍵盤事件會改變窗口的內部狀態並觸發重新繪制。我們不需要更加詳細的分析這個代碼，你應該有能力分析它。Qt自帶了大量現成的桌面窗口部件，你有很大的幾率不需要再做這些工作。

```
#include "customwidget.h"

CustomWidget::CustomWidget(QWidget *parent) :
    QWidget(parent)
{
}

void CustomWidget::paintEvent(QPaintEvent *)
{
    QPainter painter(this);
    QRect r1 = rect().adjusted(10,10,-10,-10);
    painter.setPen(QColor("#33B5E5"));
    painter.drawRect(r1);

    QRect r2(QPoint(0,0),QSize(40,40));
    if(m_lastPos.isNull()) {
        r2.moveCenter(r1.center());
    } else {
        r2.moveCenter(m_lastPos);
    }
    painter.fillRect(r2, QColor("#FFBB33"));
}

void CustomWidget::mousePressEvent(QMouseEvent *event)
{
    m_lastPos = event->pos();
    update();
}

void CustomWidget::mouseMoveEvent(QMouseEvent *event)
{
    m_lastPos = event->pos();
    update();
}
```

**桌面窗口**

Qt的開發者們已經為你做好大量現成的桌面窗口部件，在不同的操作系統中他們看起來都像是本地的窗口部件。你的工作只需要在一個打的窗口容器中安排不同的的窗口部件。在Qt中一個窗口部件能夠包含其它的窗口部件。這個操作由分配父子關系來完成。這意味著我們需要準備類似按鈕（button），復選框（check box），單選按鈕（radio button）的窗口部件並且對它們進行布局。下面展示了一種完成的方法。

這裡有一個頭文件就是所謂的窗口部件容器。

```
class CustomWidget : public QWidget
{
    Q_OBJECT
public:
    explicit CustomWidgetQWidget *parent = 0);
private slots:
    void itemClicked(QListWidgetItem* item);
    void updateItem();
private:
    QListWidget *m_widget;
    QLineEdit *m_edit;
    QPushButton *m_button;
};
```

在實現中我們使用布局來更好的安排我們的窗口部件。當容器窗口部件大小被改變後它會按照窗口部件的大小策略進行重新布局。在這個例子中我們有一個鏈表窗口部件，行編輯器與按鈕垂直排列來編輯一個城市的鏈表。我們使用Qt的信號與槽來連接發送和接收對象。

```
CustomWidget::CustomWidget(QWidget *parent) :
    QWidget(parent)
{
    QVBoxLayout *layout = new QVBoxLayout(this);
    m_widget = new QListWidget(this);
    layout->addWidget(m_widget);

    m_edit = new QLineEdit(this);
    layout->addWidget(m_edit);

    m_button = new QPushButton("Quit", this);
    layout->addWidget(m_button);
    setLayout(layout);

    QStringList cities;
    cities << "Paris" << "London" << "Munich";
    foreach(const QString& city, cities) {
        m_widget->addItem(city);
    }

    connect(m_widget, SIGNAL(itemClicked(QListWidgetItem*)), this, SLOT(itemClicked(QListWidgetItem*)));
    connect(m_edit, SIGNAL(editingFinished()), this, SLOT(updateItem()));
    connect(m_button, SIGNAL(clicked()), qApp, SLOT(quit()));
}

void CustomWidget::itemClicked(QListWidgetItem *item)
{
    Q_ASSERT(item);
    m_edit->setText(item->text());
}

void CustomWidget::updateItem()
{
    QListWidgetItem* item = m_widget->currentItem();
    if(item) {
        item->setText(m_edit->text());
    }
}
```

**繪制圖形**

有一些問題最好用可視化的方式表達。如果手邊的問題看起來有點像幾何對象，qt graphics view是一個很好的選擇。一個圖形視窗（graphics view）能夠在一個場景（scene）排列簡單的幾何圖形。用戶可以與這些圖形交互，它們使用一定的算法放置在場景（scene）上。填充一個圖形視圖你需要一個圖形窗口（graphics view）和一個圖形場景（graphics scene）。一個圖形場景（scene）連接在一個圖形窗口（view）上，圖形對象（graphics item）是被放在圖形場景（scene）上的。這裡有一個簡單的例子，首先頭文件定義了圖形窗口（view）與圖形場景（scene）。

```
class CustomWidgetV2 : public QWidget
{
    Q_OBJECT
public:
    explicit CustomWidgetV2(QWidget *parent = 0);
private:
    QGraphicsView *m_view;
    QGraphicsScene *m_scene;

};
```

在實現中首先將圖形場景（scene）與圖形窗口（view）連接。圖形窗口（view）是一個窗口部件，能夠被我們的窗口部件容器包含。最後我們添加一個小的矩形框在圖形場景（scene）中。然後它會被渲染到我們的圖形窗口（view）上。

```
#include "customwidgetv2.h"

CustomWidget::CustomWidget(QWidget *parent) :
    QWidget(parent)
{
    m_view = new QGraphicsView(this);
    m_scene = new QGraphicsScene(this);
    m_view->setScene(m_scene);

    QVBoxLayout *layout = new QVBoxLayout(this);
    layout->setMargin(0);
    layout->addWidget(m_view);
    setLayout(layout);

    QGraphicsItem* rect1 = m_scene->addRect(0,0, 40, 40, Qt::NoPen, QColor("#FFBB33"));
    rect1->setFlags(QGraphicsItem::ItemIsFocusable|QGraphicsItem::ItemIsMovable);
}
```

## 2.3.3 數據適配

到現在我們已經知道了大多數的基本數據類型，並且知道如何使用窗口部件和圖形視圖（graphics views）。通常在應用程序中你需要處理大量的結構體數據，也可能需要不停的儲存它們，或者這些數據需要被用來顯示。對于這些Qt使用了模型的概念。下面一個簡單的模型是字符串鏈表模型，它被一大堆字符串填滿然後與一個鏈表視圖（list view）連接。

```
m_view = new QListView(this);
m_model = new QStringListModel(this);
view->setModel(m_model);

QList<QString> cities;
cities << "Munich" << "Paris" << "London";
model->setStringList(cities);
```

另一個比較普遍的用法是使用SQL（結構化數據查詢語言）來存儲和讀取數據。Qt自身附帶了嵌入式版的SQLLite並且也支持其它的數據引擎（比如MySQL，PostgresSQL，等等）。首先你需要使用一個模式來創建你的數據庫，比如像這樣：

```
CREATE TABLE city (name TEXT, country TEXT);
INSERT INTO city value ("Munich", "Germany");
INSERT INTO city value ("Paris", "France");
INSERT INTO city value ("London", "United Kingdom");
```

為了能夠在使用sql，我們需要在我們的項目文件（*.pro）中加入sql模塊。

```
QT += sql
```

然後我們需要c++來打開我們的數據庫。首先我們需要獲取一個指定的數據庫引擎的數據對象。使用這個數據庫對象我們可以打開數據庫。對于SQLLite這樣的數據庫我們可以指定一個數據庫文件的路徑。Qt提供了一些高級的數據庫模型，其中有一種表格模型（table model）使用表格標示符和一個選項分支語句（where clause）來選擇數據。這個模型的結果能夠與一個鏈表視圖連接，就像之前連接其它數據模型一樣。

```
QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
db.setDatabaseName('cities.db');
if(!db.open()) {
    qFatal("unable to open database");
}

m_model = QSqlTableModel(this);
m_model->setTable("city");
m_model->setHeaderData(0, Qt::Horizontal, "City");
m_model->setHeaderData(1, Qt::Horizontal, "Country");

view->setModel(m_model);
m_model->select();
```

對高級的模型操作，Qt提供了一種分類文件代理模型，允許你使用基礎的分類排序和數據過濾來操作其它的模型。

```
QSortFilterProxyModel* proxy = new QSortFilterProxyModel(this);
proxy->setSourceModel(m_model);
view->setModel(proxy);
view->setSortingEnabled(true);
```

數據過濾基于列號與一個字符串參數完成。

```
proxy->setFilterKeyColumn(0);
proxy->setFilterCaseSensitive(Qt::CaseInsensitive);
proxy->setFilterFixedString(QString)
```

過濾代理模型比這裡演示的要強大的多，現在我們只需要知道有它的存在就夠了。

**注意**

**這裡是綜述了你可以在Qt5中開發的不同類型的經典應用程序。桌面應用程序正在發生著改變，不久之後移動設備將會為佔據我們的世界。移動設備的用戶界面設計非常不同。它們相對于桌面應用程序更加簡潔，只需要專注的做一件事情。動畫效果是一個非常重要的部分，用戶界面需要生動活潑。傳統的Qt技術已經不適于這些市場了。**

**接下來：Qt Quick將會解決這個問題。**

## 2.3.4 Qt Quick應用程序

在現代的軟件開發中有一個內在的衝突，用戶界面的改變速度遠遠高于我們的後端服務。在傳統的技術中我們開發的前端需要與後端保持相同的步調。當一個項目在開發時用戶想要改變用戶界面，或者在一個項目中開發一個用戶界面的想法就會引發這個衝突。敏捷項目需要敏捷的方法。

Qt Quick 提供了一個類似HTML聲明語言的環境應用程序作為你的用戶界面前端（the front-end），在你的後端使用本地的c++代碼。這樣允許你在兩端都遊刃有餘。

下面是一個簡單的Qt Quick UI的例子。

```
import QtQuick 2.0

Rectangle {
    width: 240; height: 1230
    Rectangle {
        width: 40; height: 40
        anchors.centerIn: parent
        color: '#FFBB33'
    }
}
```

這種聲明語言被稱作QML，它需要在運行時啟動。Qt提供了一個典型的運行環境叫做qmlscene，但是想要寫一個自定義的允許環境也不是很困難，我們需要一個快速視圖（quick view）並且將QML文檔作為它的資源。剩下的事情就只是展示我們的用戶界面了。

```
QQuickView* view = new QQuickView();
QUrl source = Qurl::fromLocalUrl("main.qml");
view->setSource(source);
view.show();
```

回到我們之前的例子，在一個例子中我們使用了一個c++的城市數據模型。如果我們能夠在QML代碼中使用它將會更加的好。

為了實現它我們首先要編寫前端代碼怎樣展示我們需要使用的城市數據模型。在這一個例子中前端指定了一個對象叫做cityModel，我們可以在鏈表視圖（list view）中使用它。

```
import QtQuick 2.0

Rectangle {
    width: 240; height: 120
    ListView {
        width: 180; height: 120
        anchors.centerIn: parent
        model: cityModel
        delegate: Text { text: model.city }
    }
}
```

為了使用cityModel，我們通常需要重復使用我們以前的數據模型，給我們的根環境（root context）加上一個內容屬性（context property）。（root context是在另一個文檔的根元素中）。

```
m_model = QSqlTableModel(this);
... // some magic code
QHash<int, QByteArray> roles;
roles[Qt::UserRole+1] = "city";
roles[Qt::UserRole+2] = "country";
m_model->setRoleNames(roles);
view->rootContext()->setContextProperty("cityModel", m_model);
```

**警告**

**這不是完全正確的用法，作為包含在SQL表格模型列中的數據，一個QML模型的任務是來表達這些數據。所以需要做一個在列和任務之間的映射關系。請查看來[QML and QSqlTableModel](http://qt-project.org/wiki/QML_and_QSqlTableModel)獲得更多的信息。**

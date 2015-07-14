#include <QtCore/QObject>

class Bar : public QObject
{
    Q_OBJECT

public:
    Bar();
    ~Bar();
    const int& getValue();
    void setValue(const int& value);

public slots:
    void slot();

signals:
    void signal();

private:
    int _value;
};
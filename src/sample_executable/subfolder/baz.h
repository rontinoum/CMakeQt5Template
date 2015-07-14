#include <QtCore/QObject>

class Baz : public QObject
{
    Q_OBJECT

public:
    Baz();
    ~Baz();
    const int& getValue();
    void setValue(const int& value);

public slots:
    void slot();

signals:
    void signal();

private:
    int _value;
};
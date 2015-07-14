#include <QtCore/QObject>

class Bazz : public QObject
{
    Q_OBJECT

public:
    Bazz();
    ~Bazz();
    const int& getValue();
    void setValue(const int& value);

public slots:
    void slot();

signals:
    void signal();

private:
    int _value;
};
#include "sample_executable/module_config.h"

#include <QtCore/QObject>

SAMPLE_EXECUTABLE_NAMESPACE_BEGIN

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

SAMPLE_EXECUTABLE_NAMESPACE_END

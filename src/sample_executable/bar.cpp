#include "bar.h"

#include <iostream>

SAMPLE_EXECUTABLE_NAMESPACE_BEGIN

Bar::Bar()
{
    _value = 0;

    connect(this, &Bar::signal, this, &Bar::slot);
}

Bar::~Bar()
{

}

const int& Bar::getValue()
{
    return _value;
}

void Bar::setValue(const int& value)
{
    _value = value;
    emit signal();
}

void Bar::slot()
{
    std::cout << "Value set to " << QString::number(_value).toLatin1().data() << std::endl;
}

SAMPLE_EXECUTABLE_NAMESPACE_END

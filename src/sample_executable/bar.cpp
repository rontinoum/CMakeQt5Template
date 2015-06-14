#include "bar.h"

#include <iostream>

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
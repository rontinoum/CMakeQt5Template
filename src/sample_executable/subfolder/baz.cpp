#include "baz.h"

#include <iostream>

Baz::Baz()
{
    _value = 0;

    connect(this, &Baz::signal, this, &Baz::slot);
}

Baz::~Baz()
{

}

const int& Baz::getValue()
{
    return _value;
}

void Baz::setValue(const int& value)
{
    _value = value;
    emit signal();
}

void Baz::slot()
{
    std::cout << "Value set to " << QString::number(_value).toLatin1().data() << std::endl;
}

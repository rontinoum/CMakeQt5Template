#include "Bazz.h"

#include <iostream>

Bazz::Bazz()
{
    _value = 0;

    connect(this, &Bazz::signal, this, &Bazz::slot);
}

Bazz::~Bazz()
{

}

const int& Bazz::getValue()
{
    return _value;
}

void Bazz::setValue(const int& value)
{
    _value = value;
    emit signal();
}

void Bazz::slot()
{
    std::cout << "Value set to " << QString::number(_value).toLatin1().data() << std::endl;
}

#include "foo.h"

Foo::Foo()
{
    _value = 0;
}

Foo::~Foo()
{
    
}

void Foo::inc()
{
    _value++;
}

void Foo::dec()
{
    _value--;
}
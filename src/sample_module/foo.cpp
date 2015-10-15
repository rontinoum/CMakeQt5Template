#include "foo.h"

SAMPLE_MODULE_NAMESPACE_BEGIN

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

SAMPLE_MODULE_NAMESPACE_END

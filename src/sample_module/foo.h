#pragma once

#include "defines.h"

#ifndef _FOO_H_
#define _FOO_H_

class D_EXPORT Foo
{
public:
    Foo();
    ~Foo();
    void inc();
    void dec();
    
private:
    int _value;
};

#endif //_FOO_H_

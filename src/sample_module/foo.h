#ifndef _FOO_H_
#define _FOO_H_

#include "sample_module/module_config.h"

SAMPLE_MODULE_NAMESPACE_BEGIN

class SAMPLE_MODULE_API Foo
{
public:
    Foo();
    ~Foo();
    void inc();
    void dec();
    
private:
    int _value;
};

SAMPLE_MODULE_NAMESPACE_END

#endif //_FOO_H_
